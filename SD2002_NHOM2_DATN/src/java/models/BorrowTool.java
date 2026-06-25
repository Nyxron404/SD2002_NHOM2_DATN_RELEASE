/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package models;
import java.time.LocalDateTime;
/**
 *
 * @author longd
 */
public class BorrowTool {
    private int MaMuonDungCu;
    private int MaDungCu;
    private int MaNhanVien;
    private int MaKhuVuc;
    private int SoLuong;
    private LocalDateTime ThoiGianBatDau;
    private LocalDateTime ThoiGianKetThuc;
    private String TinhTrangTruocKhiDung;
    private String TinhTrangSauKhiDung;
    private float TongThoiGianSuDung;
    private String GhiChu;
    private String TrangThai;

    public BorrowTool() {
    }

    public BorrowTool(int MaMuonDungCu, int MaDungCu, int MaNhanVien, int MaKhuVuc, int SoLuong, LocalDateTime ThoiGianBatDau, LocalDateTime ThoiGianKetThuc, String TinhTrangTruocKhiDung, String TinhTrangSauKhiDung, float TongThoiGianSuDung, String GhiChu, String TrangThai) {
        this.MaMuonDungCu = MaMuonDungCu;
        this.MaDungCu = MaDungCu;
        this.MaNhanVien = MaNhanVien;
        this.MaKhuVuc = MaKhuVuc;
        this.SoLuong = SoLuong;
        this.ThoiGianBatDau = ThoiGianBatDau;
        this.ThoiGianKetThuc = ThoiGianKetThuc;
        this.TinhTrangTruocKhiDung = TinhTrangTruocKhiDung;
        this.TinhTrangSauKhiDung = TinhTrangSauKhiDung;
        this.TongThoiGianSuDung = TongThoiGianSuDung;
        this.GhiChu = GhiChu;
        this.TrangThai = TrangThai;
    }

    public int getMaMuonDungCu() {
        return MaMuonDungCu;
    }

    public void setMaMuonDungCu(int MaMuonDungCu) {
        this.MaMuonDungCu = MaMuonDungCu;
    }

    public int getMaDungCu() {
        return MaDungCu;
    }

    public void setMaDungCu(int MaDungCu) {
        this.MaDungCu = MaDungCu;
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

    public int getSoLuong() {
        return SoLuong;
    }

    public void setSoLuong(int SoLuong) {
        this.SoLuong = SoLuong;
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

    public float getTongThoiGianSuDung() {
        return TongThoiGianSuDung;
    }

    public void setTongThoiGianSuDung(float TongThoiGianSuDung) {
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
    
}
