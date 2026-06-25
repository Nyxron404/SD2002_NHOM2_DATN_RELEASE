/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package models;

/**
 *
 * @author longd
 */
public class FarmArea {
    private int MaKhuVuc;
    private String TenKhuVuc;
    private String LoaiKhuVuc;
    private double DienTich;
    private String MoTa;

    public FarmArea() {
    }

    public FarmArea(int MaKhuVuc, String TenKhuVuc, String LoaiKhuVuc, double DienTich, String MoTa) {
        this.MaKhuVuc = MaKhuVuc;
        this.TenKhuVuc = TenKhuVuc;
        this.LoaiKhuVuc = LoaiKhuVuc;
        this.DienTich = DienTich;
        this.MoTa = MoTa;
    }

    public int getMaKhuVuc() {
        return MaKhuVuc;
    }

    public void setMaKhuVuc(int MaKhuVuc) {
        this.MaKhuVuc = MaKhuVuc;
    }

    public String getTenKhuVuc() {
        return TenKhuVuc;
    }

    public void setTenKhuVuc(String TenKhuVuc) {
        this.TenKhuVuc = TenKhuVuc;
    }

    public String getLoaiKhuVuc() {
        return LoaiKhuVuc;
    }

    public void setLoaiKhuVuc(String LoaiKhuVuc) {
        this.LoaiKhuVuc = LoaiKhuVuc;
    }

    public double getDienTich() {
        return DienTich;
    }

    public void setDienTich(double DienTich) {
        this.DienTich = DienTich;
    }

    public String getMoTa() {
        return MoTa;
    }

    public void setMoTa(String MoTa) {
        this.MoTa = MoTa;
    }
    
}
