-- =========================================================================
-- ĐOẠN 1: KHỞI TẠO CƠ SỞ DỮ LIỆU & DỮ LIỆU MẪU ĐỂ CHẠY THỬ
-- =========================================================================
CREATE DATABASE IF NOT EXISTS tim_kiem_san_pham_nang_cao;
USE tim_kiem_san_pham_nang_cao;

DROP TABLE IF EXISTS products;

CREATE TABLE products (
    product_id VARCHAR(20) PRIMARY KEY,
    product_name VARCHAR(150) NOT NULL,
    category VARCHAR(50) NOT NULL,
    price DECIMAL(15, 2) NOT NULL,
    quantity INT DEFAULT 0
);

INSERT INTO products (product_id, product_name, category, price, quantity) VALUES
('P001', 'iPhone 15 Pro', 'Phone', 25000000.00, 10),
('P002', 'Samsung Galaxy S24', 'Phone', 22000000.00, 15),
('P003', 'Oppo Reno 11', 'Phone', 9500000.00, 8), -- Rẻ nhất Phone
('P004', 'MacBook Air M3', 'Laptop', 28000000.00, 5),
('P005', 'Asus Vivobook 14', 'Laptop', 14000000.00, 12), -- Rẻ nhất Laptop
('P006', 'iPad Air 5', 'Tablet', 15000000.00, 7),
('P007', 'Samsung Galaxy Tab S9', 'Tablet', 13000000.00, 6); -- Rẻ nhất Tablet

-- Thống kê nhanh:
-- + Giá trung bình toàn bộ hệ thống là: ~18.071.428


-- =========================================================================
-- ĐOẠN 2: THỰC HIỆN CÁC TRUY VẤN THEO YÊU CẦU
-- =========================================================================

-- Yêu cầu 1: Tìm các sản phẩm có giá nằm trong một khoảng cụ thể (Ví dụ: từ 10.000.000 đến 25.000.000)
SELECT * 
FROM products 
WHERE price BETWEEN 10000000.00 AND 25000000.00;


-- Yêu cầu 2: Tìm các sản phẩm có tên chứa một chuỗi ký tự nhất định (Ví dụ: chứa chữ "Samsung")
SELECT * 
FROM products 
WHERE product_name LIKE '%Samsung%';


-- Yêu cầu 3: Tính giá trung bình của sản phẩm cho mỗi danh mục
SELECT 
    category AS danh_muc, 
    AVG(price) AS gia_trung_binh_danh_muc
FROM products
GROUP BY category;


-- Yêu cầu 4: Tìm những sản phẩm có giá cao hơn mức giá trung bình của toàn bộ sản phẩm
SELECT * 
FROM products
WHERE price > (SELECT AVG(price) FROM products);


-- Yêu cầu 5: Tìm sản phẩm có giá thấp nhất cho từng danh mục (Subquery tương quan)
SELECT p1.* 
FROM products p1
WHERE p1.price = (
    SELECT MIN(p2.price) 
    FROM products p2 
    WHERE p2.category = p1.category
);
