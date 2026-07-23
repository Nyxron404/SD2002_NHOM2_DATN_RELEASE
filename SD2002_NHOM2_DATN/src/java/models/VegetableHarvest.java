package models;

import java.time.LocalDate;

/**
 * Ánh xạ bảng [dbo].[VegetableHarvest]
 * Cột: MaThuHoach, MaRau, NgayThuHoach, SoLuongThuHoach, ChatLuong,
 *      GiaTriUocTinh, NguoiThuHoach, GhiChu
 * Lưu ý: MaThuHoach KHÔNG phải IDENTITY trong DB -> DAO tự sinh giá trị kế tiếp.
 */
public class VegetableHarvest {

    private int MaThuHoach;
    private int MaRau;
    private LocalDate NgayThuHoach;
    private int SoLuongThuHoach;
    private String ChatLuong;
    private double GiaTriUocTinh;
    private int NguoiThuHoach;
    private String GhiChu;

    // Trường phụ (KHÔNG có trong DB) để hiển thị
    private String TenRau;
    private String TenNguoiThuHoach;

    public VegetableHarvest() {
    }

    public VegetableHarvest(int MaThuHoach, int MaRau, LocalDate NgayThuHoach, int SoLuongThuHoach,
            String ChatLuong, double GiaTriUocTinh, int NguoiThuHoach, String GhiChu) {
        this.MaThuHoach = MaThuHoach;
        this.MaRau = MaRau;
        this.NgayThuHoach = NgayThuHoach;
        this.SoLuongThuHoach = SoLuongThuHoach;
        this.ChatLuong = ChatLuong;
        this.GiaTriUocTinh = GiaTriUocTinh;
        this.NguoiThuHoach = NguoiThuHoach;
        this.GhiChu = GhiChu;
    }

    public int getMaThuHoach() {
        return MaThuHoach;
    }

    public void setMaThuHoach(int MaThuHoach) {
        this.MaThuHoach = MaThuHoach;
    }

    public int getMaRau() {
        return MaRau;
    }

    public void setMaRau(int MaRau) {
        this.MaRau = MaRau;
    }

    public LocalDate getNgayThuHoach() {
        return NgayThuHoach;
    }

    public void setNgayThuHoach(LocalDate NgayThuHoach) {
        this.NgayThuHoach = NgayThuHoach;
    }

    public int getSoLuongThuHoach() {
        return SoLuongThuHoach;
    }

    public void setSoLuongThuHoach(int SoLuongThuHoach) {
        this.SoLuongThuHoach = SoLuongThuHoach;
    }

    public String getChatLuong() {
        return ChatLuong;
    }

    public void setChatLuong(String ChatLuong) {
        this.ChatLuong = ChatLuong;
    }

    public double getGiaTriUocTinh() {
        return GiaTriUocTinh;
    }

    public void setGiaTriUocTinh(double GiaTriUocTinh) {
        this.GiaTriUocTinh = GiaTriUocTinh;
    }

    public int getNguoiThuHoach() {
        return NguoiThuHoach;
    }

    public void setNguoiThuHoach(int NguoiThuHoach) {
        this.NguoiThuHoach = NguoiThuHoach;
    }

    public String getGhiChu() {
        return GhiChu;
    }

    public void setGhiChu(String GhiChu) {
        this.GhiChu = GhiChu;
    }

    public String getTenRau() {
        return TenRau;
    }

    public void setTenRau(String TenRau) {
        this.TenRau = TenRau;
    }

    public String getTenNguoiThuHoach() {
        return TenNguoiThuHoach;
    }

    public void setTenNguoiThuHoach(String TenNguoiThuHoach) {
        this.TenNguoiThuHoach = TenNguoiThuHoach;
    }
}