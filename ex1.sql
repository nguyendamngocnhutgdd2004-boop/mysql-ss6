-- =========================================================================
-- ĐOẠN 1: KHỞI TẠO CƠ SỞ DỮ LIỆU & BẢNG (Mối quan hệ 1 - Nhiều)
-- =========================================================================
CREATE DATABASE IF NOT EXISTS quan_ly_san_pham_danh_muc;
USE quan_ly_san_pham_danh_muc;

DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;

-- 1. Tạo bảng Danh mục trước (Bảng cha)
CREATE TABLE categories (
    category_id VARCHAR(20) PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL
);

-- 2. Tạo bảng Sản phẩm sau (Bảng con)
CREATE TABLE products (
    product_id VARCHAR(20) PRIMARY KEY,
    product_name VARCHAR(150) NOT NULL,
    price DECIMAL(15, 2) NOT NULL,
    quantity INT DEFAULT 0,
    category_id VARCHAR(20),
    CONSTRAINT fk_products_categories 
        FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- Chuẩn bị dữ liệu danh mục gốc ban đầu để làm việc
INSERT INTO categories VALUES 
('CAT001', 'Điện thoại'),
('CAT002', 'Laptop'),
('CAT003', 'Phụ kiện');


-- =========================================================================
-- ĐOẠN 2: THỰC HIỆN CÁC THAO TÁC THEO YÊU CẦU ĐỀ BÀI
-- =========================================================================

-- Yêu cầu 1: Thêm 3 sản phẩm mới vào bảng products
INSERT INTO products (product_id, product_name, price, quantity, category_id) VALUES
('P001', 'iPhone 15 Pro Max', 30000000.00, 10, 'CAT001'),
('P002', 'MacBook Air M3', 28000000.00, 5, 'CAT002'),
('P003', 'Chuột Logitech G502', 1500000.00, 20, 'CAT003'),
('P004', 'Samsung Galaxy S24 Ultra', 26000000.00, 8, 'CAT001'); -- Thêm 4 cái để có dữ liệu đa dạng để sửa/xóa


-- Yêu cầu 2: Cập nhật giá của một sản phẩm đã có (Ví dụ: Tăng giá MacBook Air M3)
UPDATE products 
SET price = 29500000.00 
WHERE product_id = 'P002';


-- Yêu cầu 3: Xóa một sản phẩm (Ví dụ: Xóa sản phẩm Chuột Logitech G502)
DELETE FROM products 
WHERE product_id = 'P003';


-- =========================================================================
-- ĐOẠN 3: TRUY VẤN VÀ THỐNG KÊ (KẾT QUẢ MONG MUỐN)
-- =========================================================================

-- Yêu cầu 4: Hiển thị tất cả sản phẩm, sắp xếp giảm dần theo giá (ORDER BY DESC)
SELECT 
    p.product_id, 
    p.product_name, 
    p.price, 
    p.quantity, 
    c.category_name
FROM products p
LEFT JOIN categories c ON p.category_id = c.category_id
ORDER BY p.price DESC;


-- Yêu cầu 5: Thống kê số lượng sản phẩm cho từng danh mục (Dùng GROUP BY)
SELECT 
    c.category_id,
    c.category_name,
    COUNT(p.product_id) AS so_luong_san_pham
FROM categories c
LEFT JOIN products p ON c.category_id = p.category_id
GROUP BY c.category_id, c.category_name;
