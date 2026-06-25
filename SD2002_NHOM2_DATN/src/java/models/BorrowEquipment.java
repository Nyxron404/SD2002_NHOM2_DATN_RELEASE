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
public class BorrowEquipment {
    private int MaMuonThietBi;
    private int MaThietBi;
    private int MaNhanVien;
    private int MaKhuVuc;
    private LocalDateTime ThoiGianBatDau;
    private LocalDateTime ThoiGianKetThuc;
    private String TinhTrangTruocKhiDung;
    private String TinhTrangSauKhiDung;
    private float TongThoiGianSuDung;
    private String GhiChu;
    private String TrangThai;

    public BorrowEquipment() {
    }

    public BorrowEquipment(int MaMuonThietBi, int MaThietBi, int MaNhanVien, int MaKhuVuc, LocalDateTime ThoiGianBatDau, LocalDateTime ThoiGianKetThuc, String TinhTrangTruocKhiDung, String TinhTrangSauKhiDung, float TongThoiGianSuDung, String GhiChu, String TrangThai) {
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
