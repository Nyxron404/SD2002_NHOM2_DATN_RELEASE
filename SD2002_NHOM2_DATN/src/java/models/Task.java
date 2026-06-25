/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package models;
import java.time.LocalDate;
/**
 *
 * @author longd
 */
public class Task {
    private int MaCongViec;
    private String TenCongViec;
    private String MoTa;
    private int MaQuyTrinh;
    private int MaKhuVuc;
    private int NguoiPhuTrach;
    private LocalDate NgayBatDau;
    private LocalDate NgayKetThuc;
    private String TrangThai;

    public Task() {
    }

    public Task(int MaCongViec, String TenCongViec, String MoTa, int MaQuyTrinh, int MaKhuVuc, int NguoiPhuTrach, LocalDate NgayBatDau, LocalDate NgayKetThuc, String TrangThai) {
        this.MaCongViec = MaCongViec;
        this.TenCongViec = TenCongViec;
        this.MoTa = MoTa;
        this.MaQuyTrinh = MaQuyTrinh;
        this.MaKhuVuc = MaKhuVuc;
        this.NguoiPhuTrach = NguoiPhuTrach;
        this.NgayBatDau = NgayBatDau;
        this.NgayKetThuc = NgayKetThuc;
        this.TrangThai = TrangThai;
    }

    public int getMaCongViec() {
        return MaCongViec;
    }

    public void setMaCongViec(int MaCongViec) {
        this.MaCongViec = MaCongViec;
    }

    public String getTenCongViec() {
        return TenCongViec;
    }

    public void setTenCongViec(String TenCongViec) {
        this.TenCongViec = TenCongViec;
    }

    public String getMoTa() {
        return MoTa;
    }

    public void setMoTa(String MoTa) {
        this.MoTa = MoTa;
    }

    public int getMaQuyTrinh() {
        return MaQuyTrinh;
    }

    public void setMaQuyTrinh(int MaQuyTrinh) {
        this.MaQuyTrinh = MaQuyTrinh;
    }

    public int getMaKhuVuc() {
        return MaKhuVuc;
    }

    public void setMaKhuVuc(int MaKhuVuc) {
        this.MaKhuVuc = MaKhuVuc;
    }

    public int getNguoiPhuTrach() {
        return NguoiPhuTrach;
    }

    public void setNguoiPhuTrach(int NguoiPhuTrach) {
        this.NguoiPhuTrach = NguoiPhuTrach;
    }

    public LocalDate getNgayBatDau() {
        return NgayBatDau;
    }

    public void setNgayBatDau(LocalDate NgayBatDau) {
        this.NgayBatDau = NgayBatDau;
    }

    public LocalDate getNgayKetThuc() {
        return NgayKetThuc;
    }

    public void setNgayKetThuc(LocalDate NgayKetThuc) {
        this.NgayKetThuc = NgayKetThuc;
    }

    public String getTrangThai() {
        return TrangThai;
    }

    public void setTrangThai(String TrangThai) {
        this.TrangThai = TrangThai;
    }
    
}
