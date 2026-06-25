-- 1. Tạo bảng Khách Hàng
CREATE TABLE KhachHang (
    MaKH VARCHAR(15) PRIMARY KEY,
    TenKH VARCHAR(50) NOT NULL,
    SDT VARCHAR(15)
);

-- 2. Tạo bảng Sản Phẩm
CREATE TABLE SanPham (
    MaSP VARCHAR(15) PRIMARY KEY,
    TenSP VARCHAR(100) NOT NULL,
    GiaBan DECIMAL(12,2) NOT NULL
);

-- 3. Tạo bảng Hóa Đơn (Mối quan hệ 1-N với Khách Hàng)
CREATE TABLE HoaDon (
    MaHD VARCHAR(15) PRIMARY KEY,
    NgayMua DATETIME DEFAULT CURRENT_TIMESTAMP,
    TongTien DECIMAL(12,2) DEFAULT 0,
    MaKH VARCHAR(15),
    FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH) ON DELETE SET NULL
);

-- 4. Tạo bảng Chi Tiết Hóa Đơn (Bảng trung gian giải quyết quan hệ N-N)
CREATE TABLE ChiTietHoaDon (
    MaHD VARCHAR(15),
    MaSP VARCHAR(15),
    SoLuong INT NOT NULL CHECK (SoLuong > 0),
    GiaMua DECIMAL(12,2) NOT NULL,
    PRIMARY KEY (MaHD, MaSP), -- Khóa chính kết hợp
    FOREIGN KEY (MaHD) REFERENCES HoaDon(MaHD) ON DELETE CASCADE,
    FOREIGN KEY (MaSP) REFERENCES SanPham(MaSP) ON DELETE RESTRICT
);
