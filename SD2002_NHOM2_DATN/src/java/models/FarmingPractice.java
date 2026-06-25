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
public class FarmingPractice {
    private int MaQuyTrinh;
    private String TenQuyTrinh;
    private String MoTa;
    private LocalDate NgayTao;
    private int NguoiTao;
    private boolean TrangThai;

    public FarmingPractice() {
    }

    public FarmingPractice(int MaQuyTrinh, String TenQuyTrinh, String MoTa, LocalDate NgayTao, int NguoiTao, boolean TrangThai) {
        this.MaQuyTrinh = MaQuyTrinh;
        this.TenQuyTrinh = TenQuyTrinh;
        this.MoTa = MoTa;
        this.NgayTao = NgayTao;
        this.NguoiTao = NguoiTao;
        this.TrangThai = TrangThai;
    }

    public int getMaQuyTrinh() {
        return MaQuyTrinh;
    }

    public void setMaQuyTrinh(int MaQuyTrinh) {
        this.MaQuyTrinh = MaQuyTrinh;
    }

    public String getTenQuyTrinh() {
        return TenQuyTrinh;
    }

    public void setTenQuyTrinh(String TenQuyTrinh) {
        this.TenQuyTrinh = TenQuyTrinh;
    }

    public String getMoTa() {
        return MoTa;
    }

    public void setMoTa(String MoTa) {
        this.MoTa = MoTa;
    }

    public LocalDate getNgayTao() {
        return NgayTao;
    }

    public void setNgayTao(LocalDate NgayTao) {
        this.NgayTao = NgayTao;
    }

    public int getNguoiTao() {
        return NguoiTao;
    }

    public void setNguoiTao(int NguoiTao) {
        this.NguoiTao = NguoiTao;
    }

    public boolean isTrangThai() {
        return TrangThai;
    }

    public void setTrangThai(boolean TrangThai) {
        this.TrangThai = TrangThai;
    }
    
    
}
