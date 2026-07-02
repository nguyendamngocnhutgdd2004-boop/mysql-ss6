-- =========================================================================
-- ĐOẠN 1: KHỞI TẠO HỆ THỐNG 5 BẢNG ĐỒNG BỘ (DATABASE CHUẨN)
-- =========================================================================
CREATE DATABASE IF NOT EXISTS he_thong_ban_hang_tong_hop;
USE he_thong_ban_hang_tong_hop;

DROP TABLE IF EXISTS order_details;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS customers;

-- 1. Bảng Danh mục
CREATE TABLE categories (
    category_id VARCHAR(20) PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL
);

-- 2. Bảng Sản phẩm
CREATE TABLE products (
    product_id VARCHAR(20) PRIMARY KEY,
    product_name VARCHAR(150) NOT NULL,
    price DECIMAL(15, 2) NOT NULL,
    category_id VARCHAR(20),
    CONSTRAINT fk_prod_cat FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- 3. Bảng Khách hàng
CREATE TABLE customers (
    customer_id VARCHAR(20) PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL
);

-- 4. Bảng Đơn hàng
CREATE TABLE orders (
    order_id VARCHAR(20) PRIMARY KEY,
    order_date DATE NOT NULL,
    customer_id VARCHAR(20),
    CONSTRAINT fk_ord_cust FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- 5. Bảng Chi tiết đơn hàng
CREATE TABLE order_details (
    order_id VARCHAR(20),
    product_id VARCHAR(20), -- Dùng product_id để liên kết chuẩn hóa với bảng products
    quantity INT NOT NULL,
    price DECIMAL(15, 2) NOT NULL,
    PRIMARY KEY (order_id, product_id),
    CONSTRAINT fk_det_ord FOREIGN KEY (order_id) REFERENCES orders(order_id),
    CONSTRAINT fk_det_prod FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- =========================================================================
-- ĐOẠN 2: CHÈN DỮ LIỆU MẪU ĐỂ KIỂM TRA ĐỦ CÁC TRƯỜNG HỢP ĐẶC BIỆT
-- =========================================================================
INSERT INTO categories VALUES 
('CAT01', 'Điện thoại'), -- Danh mục lớn nhất (3 sản phẩm)
('CAT02', 'Laptop'),     -- Danh mục vừa (2 sản phẩm)
('CAT03', 'Phụ kiện');   -- Danh mục nhỏ (1 sản phẩm)

INSERT INTO products VALUES 
('P01', 'iPhone 15 Pro', 25000000.00, 'CAT01'),
('P02', 'Samsung S24', 22000000.00, 'CAT01'),
('P03', 'Oppo Reno 11', 10000000.00, 'CAT01'),
('P04', 'MacBook Air M3', 30000000.00, 'CAT02'),
('P05', 'Dell XPS 13', 35000000.00, 'CAT02'),
('P06', 'Chuột Bluetooth', 1000000.00, 'CAT03'); -- Sản phẩm ế (chưa từng bán)

INSERT INTO customers VALUES 
('C01', 'Khách VIP A'), ('C02', 'Khách VIP B'), ('C03', 'Khách C'), 
('C04', 'Khách D'),     ('C05', 'Khách E'),     ('C06', 'Khách F');

INSERT INTO orders VALUES 
('HD01', '2026-07-01', 'C01'), ('HD02', '2026-07-01', 'C01'), -- Khách C01 có 2 đơn
('HD03', '2026-07-02', 'C02'), ('HD04', '2026-07-02', 'C03'),
('HD05', '2026-07-02', 'C04'), ('HD06', '2026-07-02', 'C05');

INSERT INTO order_details VALUES 
('HD01', 'P01', 2, 25000000.00), -- HD01 = 50M (C01 mua Điện thoại)
('HD02', 'P04', 1, 30000000.00), -- HD02 = 30M (C01) -> Tổng chi tiêu C01 = 80M
('HD03', 'P05', 2, 35000000.00), -- HD03 = 70M (C02)
('HD04', 'P02', 1, 22000000.00), -- HD04 = 22M (C03)
('HD05', 'P03', 1, 10000000.00), -- HD05 = 10M (C04)
('HD06', 'P03', 1, 10000000.00); -- HD06 = 10M (C05)


-- =========================================================================
-- ĐOẠN 3: THỰC THI CÁC TRUY VẤN TỔNG HỢP NÂNG CAO
-- =========================================================================

-- Yêu cầu 1: Liệt kê sản phẩm cùng với tên danh mục tương ứng
SELECT 
    p.product_id, 
    p.product_name, 
    p.price, 
    c.category_name
FROM products p
INNER JOIN categories c ON p.category_id = c.category_id;


-- Yêu cầu 2: Đếm số đơn hàng của từng khách hàng (Giữ lại cả người có 0 đơn)
SELECT 
    c.customer_id, 
    c.customer_name, 
    COUNT(o.order_id) AS so_luong_don_hang
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY so_luong_don_hang DESC;


-- Yêu cầu 3: Xác định 5 khách hàng có tổng doanh thu chi tiêu cao nhất
SELECT 
    c.customer_id, 
    c.customer_name, 
    SUM(od.quantity * od.price) AS tong_chi_tieu
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
INNER JOIN order_details od ON o.order_id = od.order_id
GROUP BY c.customer_id, c.customer_name
ORDER BY tong_chi_tieu DESC
LIMIT 5;


-- Yêu cầu 4: Tìm các sản phẩm chưa từng xuất hiện trong bất kỳ đơn hàng nào (Dùng NOT IN)
SELECT * 
FROM products
WHERE product_id NOT IN (
    SELECT DISTINCT product_id 
    FROM order_details
);


-- Yêu cầu 5: Tìm những khách hàng đã mua sản phẩm thuộc danh mục có số lượng sản phẩm lớn nhất
SELECT DISTINCT 
    cust.customer_id, 
    cust.customer_name
FROM customers cust
INNER JOIN orders o ON cust.customer_id = o.customer_id
INNER JOIN order_details od ON o.order_id = od.order_id
INNER JOIN products p ON od.product_id = p.product_id
WHERE p.category_id = (
    -- Subquery 1: Tìm mã danh mục có số lượng sản phẩm nhiều nhất
    SELECT category_id
    FROM products
    GROUP BY category_id
    ORDER BY COUNT(product_id) DESC
    LIMIT 1
);
