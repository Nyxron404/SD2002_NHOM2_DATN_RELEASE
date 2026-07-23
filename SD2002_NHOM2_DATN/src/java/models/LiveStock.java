package models;

import java.time.LocalDate;

/**
 * Ánh xạ bảng [dbo].[LiveStock].
 * Theo yêu cầu, KHÔNG sử dụng cột ChuongTrai (sẽ được xóa khỏi DB sau này).
 */
public class LiveStock {

    private int MaVatNuoi;
    private String TenVatNuoi;
    private String LoaiVatNuoi;
    private String Giong;
    private LocalDate NgayNhap;
    private int SoLuong;
    private double TrongLuongTrungBinh;
    private int MaKhuVuc;
    private String TrangThai;
    private String GhiChu;

    // Trường phụ (KHÔNG có trong DB) để hiển thị tên khu vực
    private String TenKhuVuc;

    public LiveStock() {
    }

    public LiveStock(int MaVatNuoi, String TenVatNuoi, String LoaiVatNuoi, String Giong,
            LocalDate NgayNhap, int SoLuong, double TrongLuongTrungBinh, int MaKhuVuc,
            String TrangThai, String GhiChu) {
        this.MaVatNuoi = MaVatNuoi;
        this.TenVatNuoi = TenVatNuoi;
        this.LoaiVatNuoi = LoaiVatNuoi;
        this.Giong = Giong;
        this.NgayNhap = NgayNhap;
        this.SoLuong = SoLuong;
        this.TrongLuongTrungBinh = TrongLuongTrungBinh;
        this.MaKhuVuc = MaKhuVuc;
        this.TrangThai = TrangThai;
        this.GhiChu = GhiChu;
    }

    public int getMaVatNuoi() {
        return MaVatNuoi;
    }

    public void setMaVatNuoi(int MaVatNuoi) {
        this.MaVatNuoi = MaVatNuoi;
    }

    public String getTenVatNuoi() {
        return TenVatNuoi;
    }

    public void setTenVatNuoi(String TenVatNuoi) {
        this.TenVatNuoi = TenVatNuoi;
    }

    public String getLoaiVatNuoi() {
        return LoaiVatNuoi;
    }

    public void setLoaiVatNuoi(String LoaiVatNuoi) {
        this.LoaiVatNuoi = LoaiVatNuoi;
    }

    public String getGiong() {
        return Giong;
    }

    public void setGiong(String Giong) {
        this.Giong = Giong;
    }

    public LocalDate getNgayNhap() {
        return NgayNhap;
    }

    public void setNgayNhap(LocalDate NgayNhap) {
        this.NgayNhap = NgayNhap;
    }

    public int getSoLuong() {
        return SoLuong;
    }

    public void setSoLuong(int SoLuong) {
        this.SoLuong = SoLuong;
    }

    public double getTrongLuongTrungBinh() {
        return TrongLuongTrungBinh;
    }

    public void setTrongLuongTrungBinh(double TrongLuongTrungBinh) {
        this.TrongLuongTrungBinh = TrongLuongTrungBinh;
    }

    public int getMaKhuVuc() {
        return MaKhuVuc;
    }

    public void setMaKhuVuc(int MaKhuVuc) {
        this.MaKhuVuc = MaKhuVuc;
    }

    public String getTrangThai() {
        return TrangThai;
    }

    public void setTrangThai(String TrangThai) {
        this.TrangThai = TrangThai;
    }

    public String getGhiChu() {
        return GhiChu;
    }

    public void setGhiChu(String GhiChu) {
        this.GhiChu = GhiChu;
    }

    public String getTenKhuVuc() {
        return TenKhuVuc;
    }

    public void setTenKhuVuc(String TenKhuVuc) {
        this.TenKhuVuc = TenKhuVuc;
    }
}