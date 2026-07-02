-- Chỉ định sử dụng cơ sở dữ liệu từ bài tập khách hàng & đơn hàng trước đó
USE quan_ly_khach_hang_don_hang;

-- =========================================================================
-- Yêu cầu 1: Thêm một đơn hàng mới và chi tiết của đơn hàng đó
-- =========================================================================
-- Thêm đơn hàng mới cho khách hàng KH002
INSERT INTO orders (order_id, order_date, customer_id) VALUES 
('DH003', '2026-07-02', 'KH002');

-- Thêm chi tiết các mặt hàng cho đơn hàng DH003 vừa tạo
INSERT INTO order_details (order_id, product_name, quantity, price) VALUES 
('DH003', 'Tai nghe không dây', 2, 1500000.00), -- 3.0M
('DH003', 'Chuột Logitech G502', 1, 1200000.00); -- 1.2M -> Tổng đơn DH003 = 4.2M


-- =========================================================================
-- Yêu cầu 2: Tính tổng doanh thu của toàn bộ cửa hàng
-- =========================================================================
SELECT 
    SUM(quantity * price) AS tong_doanh_thu_cua_hang
FROM order_details;


-- =========================================================================
-- Yêu cầu 3: Tính doanh thu trung bình của mỗi đơn hàng
-- =========================================================================
-- Dùng Subquery để tính tổng tiền của từng đơn trước, sau đó tính trung bình (AVG)
SELECT 
    AVG(tong_tien_don) AS doanh_thu_trung_binh_moi_don
FROM (
    SELECT order_id, SUM(quantity * price) AS tong_tien_don
    FROM order_details
    GROUP BY order_id
) AS bang_tam;


-- =========================================================================
-- Yêu cầu 4: Tìm và hiển thị thông tin của đơn hàng có doanh thu cao nhất
-- =========================================================================
SELECT 
    order_id, 
    SUM(quantity * price) AS doanh_thu_cao_nhat
FROM order_details
GROUP BY order_id
HAVING SUM(quantity * price) = (
    SELECT MAX(tong_tien) 
    FROM (
        SELECT SUM(quantity * price) AS tong_tien 
        FROM order_details 
        GROUP BY order_id
    ) AS bang_tam
);


-- =========================================================================
-- Yêu cầu 5: Tìm và hiển thị danh sách 3 sản phẩm bán chạy nhất (Tổng số lượng bán)
-- =========================================================================
SELECT 
    product_name, 
    SUM(quantity) AS tong_so_luong_da_ban
FROM order_details
GROUP BY product_name
ORDER BY tong_so_luong_da_ban DESC
LIMIT 3;
