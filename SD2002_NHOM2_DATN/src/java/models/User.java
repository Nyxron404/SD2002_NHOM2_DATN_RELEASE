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
public class User {
    private int MaNguoiDung;
    private String TenDangNhap;
    private String MatKhau;
    private int MaNhom;
    private boolean TrangThai;
    private LocalDateTime NgayTao;

    public User() {
    }

    public User(int MaNguoiDung, String TenDangNhap, String MatKhau, int MaNhom, boolean TrangThai, LocalDateTime NgayTao) {
        this.MaNguoiDung = MaNguoiDung;
        this.TenDangNhap = TenDangNhap;
        this.MatKhau = MatKhau;
        this.MaNhom = MaNhom;
        this.TrangThai = TrangThai;
        this.NgayTao = NgayTao;
    }

    public int getMaNguoiDung() {
        return MaNguoiDung;
    }

    public void setMaNguoiDung(int MaNguoiDung) {
        this.MaNguoiDung = MaNguoiDung;
    }

    public String getTenDangNhap() {
        return TenDangNhap;
    }

    public void setTenDangNhap(String TenDangNhap) {
        this.TenDangNhap = TenDangNhap;
    }

    public String getMatKhau() {
        return MatKhau;
    }

    public void setMatKhau(String MatKhau) {
        this.MatKhau = MatKhau;
    }

    public int getMaNhom() {
        return MaNhom;
    }

    public void setMaNhom(int MaNhom) {
        this.MaNhom = MaNhom;
    }

    public boolean isTrangThai() {
        return TrangThai;
    }

    public void setTrangThai(boolean TrangThai) {
        this.TrangThai = TrangThai;
    }

    public LocalDateTime getNgayTao() {
        return NgayTao;
    }

    public void setNgayTao(LocalDateTime NgayTao) {
        this.NgayTao = NgayTao;
    }
    
}
