/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package models;

import java.time.LocalDate;

public class FarmingPractice {
    private int maQuyTrinh;
    private String tenQuyTrinh;
    private String moTa;
    private String loaiApDung;
    private LocalDate ngayTao;
    private int nguoiTao;
    private boolean trangThai;

    public FarmingPractice() {
    }

    public FarmingPractice(int maQuyTrinh, String tenQuyTrinh, String moTa, String loaiApDung, LocalDate ngayTao, int nguoiTao, boolean trangThai) {
        this.maQuyTrinh = maQuyTrinh;
        this.tenQuyTrinh = tenQuyTrinh;
        this.moTa = moTa;
        this.loaiApDung = loaiApDung;
        this.ngayTao = ngayTao;
        this.nguoiTao = nguoiTao;
        this.trangThai = trangThai;
    }

    public int getMaQuyTrinh() {
        return maQuyTrinh;
    }

    public void setMaQuyTrinh(int maQuyTrinh) {
        this.maQuyTrinh = maQuyTrinh;
    }

    public String getTenQuyTrinh() {
        return tenQuyTrinh;
    }

    public void setTenQuyTrinh(String tenQuyTrinh) {
        this.tenQuyTrinh = tenQuyTrinh;
    }

    public String getMoTa() {
        return moTa;
    }

    public void setMoTa(String moTa) {
        this.moTa = moTa;
    }

    public String getLoaiApDung() {
        return loaiApDung;
    }

    public void setLoaiApDung(String loaiApDung) {
        this.loaiApDung = loaiApDung;
    }

    public LocalDate getNgayTao() {
        return ngayTao;
    }

    public void setNgayTao(LocalDate ngayTao) {
        this.ngayTao = ngayTao;
    }

    public int getNguoiTao() {
        return nguoiTao;
    }

    public void setNguoiTao(int nguoiTao) {
        this.nguoiTao = nguoiTao;
    }

    public boolean isTrangThai() {
        return trangThai;
    }

    public void setTrangThai(boolean trangThai) {
        this.trangThai = trangThai;
    }
}