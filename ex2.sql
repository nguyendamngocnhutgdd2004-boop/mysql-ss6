-- =========================================================================
-- ĐOẠN 1: KHỞI TẠO CƠ SỞ DỮ LIỆU & CẤU TRÚC CÁC BẢNG NÂNG CAO
-- =========================================================================
CREATE DATABASE IF NOT EXISTS quan_ly_khach_hang_don_hang;
USE quan_ly_khach_hang_don_hang;

DROP TABLE IF EXISTS order_details;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;

-- 1. Tạo bảng Khách hàng
CREATE TABLE customers (
    customer_id VARCHAR(20) PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE
);

-- 2. Tạo bảng Đơn hàng
CREATE TABLE orders (
    order_id VARCHAR(20) PRIMARY KEY,
    order_date DATE NOT NULL,
    customer_id VARCHAR(20),
    CONSTRAINT fk_orders_customers FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- 3. Tạo bảng Chi tiết đơn hàng
CREATE TABLE order_details (
    order_id VARCHAR(20),
    product_name VARCHAR(150),
    quantity INT NOT NULL,
    price DECIMAL(15, 2) NOT NULL,
    PRIMARY KEY (order_id, product_name),
    CONSTRAINT fk_details_orders FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- Chuẩn bị dữ liệu mẫu ban đầu để hệ thống hoạt động ổn định
INSERT INTO customers VALUES 
('KH001', 'Nguyen Van A', 'a@gmail.com'),
('KH002', 'Tran Thi B', 'b@gmail.com');

INSERT INTO orders VALUES 
('DH001', '2026-07-01', 'KH001');

INSERT INTO order_details VALUES 
('DH001', 'Màn hình ASUS', 1, 5000000.00),
('DH001', 'Bàn phím cơ', 2, 1200000.00); -- Đơn DH001 tổng = 7.4M


-- =========================================================================
-- ĐOẠN 2: THỰC HIỆN CÁC YÊU CẦU THEO ĐỀ BÀI
-- =========================================================================

-- Yêu cầu 1: Thêm 2 khách hàng mới vào bảng customers
INSERT INTO customers (customer_id, customer_name, email) VALUES
('KH003', 'Le Van C', 'c@gmail.com'),
('KH004', 'Pham Minh D', 'd@gmail.com');

-- Thêm một đơn hàng mới trị giá cao cho khách KH003 để làm dữ liệu kiểm tra các câu sau
INSERT INTO orders VALUES ('DH002', '2026-07-02', 'KH003');
INSERT INTO order_details VALUES ('DH002', 'Laptop Gaming VIP', 1, 45000000.00); -- Sản phẩm giá cao nhất


-- Yêu cầu 2: Liệt kê những khách hàng đã có ít nhất một đơn hàng (Dùng INNER JOIN hoặc DISTINCT)
SELECT DISTINCT 
    c.customer_id, 
    c.customer_name, 
    c.email
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id;


-- Yêu cầu 3: Tìm những khách hàng chưa từng đặt đơn hàng nào (Dùng LEFT JOIN kết hợp IS NULL)
SELECT 
    c.customer_id, 
    c.customer_name, 
    c.email
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;


-- Yêu cầu 4: Tính toán tổng doanh thu mà mỗi khách hàng đã mang lại (Gộp cả người có doanh thu bằng 0)
SELECT 
    c.customer_id,
    c.customer_name,
    IFNULL(SUM(od.quantity * od.price), 0) AS tong_doanh_thu
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
LEFT JOIN order_details od ON o.order_id = od.order_id
GROUP BY c.customer_id, c.customer_name;


-- Yêu cầu 5: Xác định khách hàng đã mua sản phẩm có giá cao nhất (Dùng Subquery tìm mức giá MAX)
SELECT DISTINCT 
    c.customer_id, 
    c.customer_name,
    od.product_name,
    od.price AS gia_san_pham
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
INNER JOIN order_details od ON o.order_id = od.order_id
WHERE od.price = (SELECT MAX(price) FROM order_details);
