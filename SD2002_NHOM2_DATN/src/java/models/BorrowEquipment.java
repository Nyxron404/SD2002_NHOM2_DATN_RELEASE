package models;

import java.time.LocalDateTime;

/**
 * Model tương ứng bảng dbo.BorrowEquipment
 * UC-5.3: Ghi nhận lịch sử sử dụng thiết bị
 */
public class BorrowEquipment {

    private int MaMuonThietBi;
    private int MaThietBi;
    private int MaNhanVien;
    private int MaKhuVuc;
    private LocalDateTime ThoiGianBatDau;
    private LocalDateTime ThoiGianKetThuc;
    private String TinhTrangTruocKhiDung;
    private String TinhTrangSauKhiDung;
    private double TongThoiGianSuDung;
    private String GhiChu;
    private String TrangThai;

    // Trường tiện ích khi JOIN hiển thị, không map cột trong bảng
    private String TenThietBi;
    private String HoTenNhanVien;
    private String TenKhuVuc;

    public BorrowEquipment() {
    }

    // Dùng khi lập phiếu sử dụng mới (UC-5.3 B1)
    public BorrowEquipment(int MaThietBi, int MaNhanVien, int MaKhuVuc, String TinhTrangTruocKhiDung) {
        this.MaThietBi = MaThietBi;
        this.MaNhanVien = MaNhanVien;
        this.MaKhuVuc = MaKhuVuc;
        this.TinhTrangTruocKhiDung = TinhTrangTruocKhiDung;
    }

    // Đầy đủ - dùng khi đọc từ DB
    public BorrowEquipment(int MaMuonThietBi, int MaThietBi, int MaNhanVien, int MaKhuVuc,
            LocalDateTime ThoiGianBatDau, LocalDateTime ThoiGianKetThuc, String TinhTrangTruocKhiDung,
            String TinhTrangSauKhiDung, double TongThoiGianSuDung, String GhiChu, String TrangThai) {
        this.MaMuonThietBi = MaMuonThietBi;
        this.MaThietBi = MaThietBi;
        this.MaNhanVien = MaNhanVien;
        this.MaKhuVuc = MaKhuVuc;
        this.ThoiGianBatDau = ThoiGianBatDau;
        this.ThoiGianKetThuc = ThoiGianKetThuc;
        this.TinhTrangTruocKhiDung = TinhTrangTruocKhiDung;
        this.TinhTrangSauKhiDung = TinhTrangSauKhiDung;
        this.TongThoiGianSuDung = TongThoiGianSuDung;
        this.GhiChu = GhiChu;
        this.TrangThai = TrangThai;
    }

    public int getMaMuonThietBi() {
        return MaMuonThietBi;
    }

    public void setMaMuonThietBi(int MaMuonThietBi) {
        this.MaMuonThietBi = MaMuonThietBi;
    }

    public int getMaThietBi() {
        return MaThietBi;
    }

    public void setMaThietBi(int MaThietBi) {
        this.MaThietBi = MaThietBi;
    }

    public int getMaNhanVien() {
        return MaNhanVien;
    }

    public void setMaNhanVien(int MaNhanVien) {
        this.MaNhanVien = MaNhanVien;
    }

    public int getMaKhuVuc() {
        return MaKhuVuc;
    }

    public void setMaKhuVuc(int MaKhuVuc) {
        this.MaKhuVuc = MaKhuVuc;
    }

    public LocalDateTime getThoiGianBatDau() {
        return ThoiGianBatDau;
    }

    public void setThoiGianBatDau(LocalDateTime ThoiGianBatDau) {
        this.ThoiGianBatDau = ThoiGianBatDau;
    }

    public LocalDateTime getThoiGianKetThuc() {
        return ThoiGianKetThuc;
    }

    public void setThoiGianKetThuc(LocalDateTime ThoiGianKetThuc) {
        this.ThoiGianKetThuc = ThoiGianKetThuc;
    }

    public String getTinhTrangTruocKhiDung() {
        return TinhTrangTruocKhiDung;
    }

    public void setTinhTrangTruocKhiDung(String TinhTrangTruocKhiDung) {
        this.TinhTrangTruocKhiDung = TinhTrangTruocKhiDung;
    }

    public String getTinhTrangSauKhiDung() {
        return TinhTrangSauKhiDung;
    }

    public void setTinhTrangSauKhiDung(String TinhTrangSauKhiDung) {
        this.TinhTrangSauKhiDung = TinhTrangSauKhiDung;
    }

    public double getTongThoiGianSuDung() {
        return TongThoiGianSuDung;
    }

    public void setTongThoiGianSuDung(double TongThoiGianSuDung) {
        this.TongThoiGianSuDung = TongThoiGianSuDung;
    }

    public String getGhiChu() {
        return GhiChu;
    }

    public void setGhiChu(String GhiChu) {
        this.GhiChu = GhiChu;
    }

    public String getTrangThai() {
        return TrangThai;
    }

    public void setTrangThai(String TrangThai) {
        this.TrangThai = TrangThai;
    }

    public String getTenThietBi() {
        return TenThietBi;
    }

    public void setTenThietBi(String TenThietBi) {
        this.TenThietBi = TenThietBi;
    }

    public String getHoTenNhanVien() {
        return HoTenNhanVien;
    }

    public void setHoTenNhanVien(String HoTenNhanVien) {
        this.HoTenNhanVien = HoTenNhanVien;
    }

    public String getTenKhuVuc() {
        return TenKhuVuc;
    }

    public void setTenKhuVuc(String TenKhuVuc) {
        this.TenKhuVuc = TenKhuVuc;
    }
}