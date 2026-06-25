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
public class Staff {
    private int MaNhanVien;
    private String HoTen;
    private LocalDate NgaySinh;
    private boolean GioiTinh;
    private String SDT;
    private String Email;
    private String DiaChi;
    private LocalDate NgayVaoLam;
    private double Luong;
    private int MaNguoiDung;
    private boolean DangKy;
    public Staff() {
    }

    public Staff(int MaNhanVien, String HoTen, LocalDate NgaySinh, boolean GioiTinh, String SDT, String Email, String DiaChi, LocalDate NgayVaoLam, double Luong, int MaNguoiDung) {
        this.MaNhanVien = MaNhanVien;
        this.HoTen = HoTen;
        this.NgaySinh = NgaySinh;
        this.GioiTinh = GioiTinh;
        this.SDT = SDT;
        this.Email = Email;
        this.DiaChi = DiaChi;
        this.NgayVaoLam = NgayVaoLam;
        this.Luong = Luong;
        this.MaNguoiDung = MaNguoiDung;
    }

    public Staff(int MaNhanVien, String HoTen, LocalDate NgaySinh, boolean GioiTinh, String SDT, String Email, String DiaChi, LocalDate NgayVaoLam, double Luong, int MaNguoiDung, boolean DangKy) {
        this.MaNhanVien = MaNhanVien;
        this.HoTen = HoTen;
        this.NgaySinh = NgaySinh;
        this.GioiTinh = GioiTinh;
        this.SDT = SDT;
        this.Email = Email;
        this.DiaChi = DiaChi;
        this.NgayVaoLam = NgayVaoLam;
        this.Luong = Luong;
        this.MaNguoiDung = MaNguoiDung;
        this.DangKy = DangKy;
    }
    
    public boolean isDangKy() {
        return DangKy;
    }

    public void setDangKy(boolean DangKy) {
        this.DangKy = DangKy;
    }
    
    
    
    public int getMaNhanVien() {
        return MaNhanVien;
    }

    public void setMaNhanVien(int MaNhanVien) {
        this.MaNhanVien = MaNhanVien;
    }

    public String getHoTen() {
        return HoTen;
    }

    public void setHoTen(String HoTen) {
        this.HoTen = HoTen;
    }

    public LocalDate getNgaySinh() {
        return NgaySinh;
    }

    public void setNgaySinh(LocalDate NgaySinh) {
        this.NgaySinh = NgaySinh;
    }

    public boolean isGioiTinh() {
        return GioiTinh;
    }

    public void setGioiTinh(boolean GioiTinh) {
        this.GioiTinh = GioiTinh;
    }

    public String getSDT() {
        return SDT;
    }

    public void setSDT(String SDT) {
        this.SDT = SDT;
    }

    public String getEmail() {
        return Email;
    }

    public void setEmail(String Email) {
        this.Email = Email;
    }

    public String getDiaChi() {
        return DiaChi;
    }

    public void setDiaChi(String DiaChi) {
        this.DiaChi = DiaChi;
    }

    public LocalDate getNgayVaoLam() {
        return NgayVaoLam;
    }

    public void setNgayVaoLam(LocalDate NgayVaoLam) {
        this.NgayVaoLam = NgayVaoLam;
    }

    public double getLuong() {
        return Luong;
    }

    public void setLuong(double Luong) {
        this.Luong = Luong;
    }

    public int getMaNguoiDung() {
        return MaNguoiDung;
    }

    public void setMaNguoiDung(int MaNguoiDung) {
        this.MaNguoiDung = MaNguoiDung;
    }
    
}
