package models;

import java.time.LocalDate;

/**
 * Ánh xạ bảng [dbo].[Vegetable]
 * Cột: MaRau, TenRau, LoaiRau, Giong, MaKhuVuc, NgayGieo, NgayThuHoachDuKien,
 *      DienTich, SoLuong, TrangThai, GhiChu
 */
public class Vegetable {

    private int MaRau;
    private String TenRau;
    private String LoaiRau;
    private String Giong;
    private int MaKhuVuc;
    private LocalDate NgayGieo;
    private LocalDate NgayThuHoachDuKien;
    private double DienTich;
    private int SoLuong;
    private String TrangThai;
    private String GhiChu;

    // Trường phụ (KHÔNG có trong DB) - chỉ để JSP hiển thị tên khu vực thay vì mã
    private String TenKhuVuc;

    public Vegetable() {
    }

    public Vegetable(int MaRau, String TenRau, String LoaiRau, String Giong, int MaKhuVuc,
            LocalDate NgayGieo, LocalDate NgayThuHoachDuKien, double DienTich, int SoLuong,
            String TrangThai, String GhiChu) {
        this.MaRau = MaRau;
        this.TenRau = TenRau;
        this.LoaiRau = LoaiRau;
        this.Giong = Giong;
        this.MaKhuVuc = MaKhuVuc;
        this.NgayGieo = NgayGieo;
        this.NgayThuHoachDuKien = NgayThuHoachDuKien;
        this.DienTich = DienTich;
        this.SoLuong = SoLuong;
        this.TrangThai = TrangThai;
        this.GhiChu = GhiChu;
    }

    public int getMaRau() {
        return MaRau;
    }

    public void setMaRau(int MaRau) {
        this.MaRau = MaRau;
    }

    public String getTenRau() {
        return TenRau;
    }

    public void setTenRau(String TenRau) {
        this.TenRau = TenRau;
    }

    public String getLoaiRau() {
        return LoaiRau;
    }

    public void setLoaiRau(String LoaiRau) {
        this.LoaiRau = LoaiRau;
    }

    public String getGiong() {
        return Giong;
    }

    public void setGiong(String Giong) {
        this.Giong = Giong;
    }

    public int getMaKhuVuc() {
        return MaKhuVuc;
    }

    public void setMaKhuVuc(int MaKhuVuc) {
        this.MaKhuVuc = MaKhuVuc;
    }

    public LocalDate getNgayGieo() {
        return NgayGieo;
    }

    public void setNgayGieo(LocalDate NgayGieo) {
        this.NgayGieo = NgayGieo;
    }

    public LocalDate getNgayThuHoachDuKien() {
        return NgayThuHoachDuKien;
    }

    public void setNgayThuHoachDuKien(LocalDate NgayThuHoachDuKien) {
        this.NgayThuHoachDuKien = NgayThuHoachDuKien;
    }

    public double getDienTich() {
        return DienTich;
    }

    public void setDienTich(double DienTich) {
        this.DienTich = DienTich;
    }

    public int getSoLuong() {
        return SoLuong;
    }

    public void setSoLuong(int SoLuong) {
        this.SoLuong = SoLuong;
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