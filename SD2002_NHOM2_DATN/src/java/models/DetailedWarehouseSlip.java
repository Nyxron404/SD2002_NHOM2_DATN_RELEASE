/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package models;

/**
 *
 * @author longd
 */
public class DetailedWarehouseSlip {
    private int MaChiTiet;
    private int MaPhieuKho;
    private int MaVatTu;
    private int SoLuong;
    private double DonGia;
    private double ThanhTien;

    public DetailedWarehouseSlip() {
    }

    public DetailedWarehouseSlip(int MaChiTiet, int MaPhieuKho, int MaVatTu, int SoLuong, double DonGia, double ThanhTien) {
        this.MaChiTiet = MaChiTiet;
        this.MaPhieuKho = MaPhieuKho;
        this.MaVatTu = MaVatTu;
        this.SoLuong = SoLuong;
        this.DonGia = DonGia;
        this.ThanhTien = ThanhTien;
    }

    public int getMaChiTiet() {
        return MaChiTiet;
    }

    public void setMaChiTiet(int MaChiTiet) {
        this.MaChiTiet = MaChiTiet;
    }

    public int getMaPhieuKho() {
        return MaPhieuKho;
    }

    public void setMaPhieuKho(int MaPhieuKho) {
        this.MaPhieuKho = MaPhieuKho;
    }

    public int getMaVatTu() {
        return MaVatTu;
    }

    public void setMaVatTu(int MaVatTu) {
        this.MaVatTu = MaVatTu;
    }

    public int getSoLuong() {
        return SoLuong;
    }

    public void setSoLuong(int SoLuong) {
        this.SoLuong = SoLuong;
    }

    public double getDonGia() {
        return DonGia;
    }

    public void setDonGia(double DonGia) {
        this.DonGia = DonGia;
    }

    public double getThanhTien() {
        return ThanhTien;
    }

    public void setThanhTien(double ThanhTien) {
        this.ThanhTien = ThanhTien;
    }
    
}
