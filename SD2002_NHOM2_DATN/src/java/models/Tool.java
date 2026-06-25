/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package models;

/**
 *
 * @author longd
 */
public class Tool {
    private int MaDungCu;
    private String TenDungCu;
    private int SoLuong;
    private String DonViTinh;
    private String TinhTrang;
    private String MoTa;

    public Tool() {
    }

    public Tool(int MaDungCu, String TenDungCu, int SoLuong, String DonViTinh, String TinhTrang, String MoTa) {
        this.MaDungCu = MaDungCu;
        this.TenDungCu = TenDungCu;
        this.SoLuong = SoLuong;
        this.DonViTinh = DonViTinh;
        this.TinhTrang = TinhTrang;
        this.MoTa = MoTa;
    }

    public int getMaDungCu() {
        return MaDungCu;
    }

    public void setMaDungCu(int MaDungCu) {
        this.MaDungCu = MaDungCu;
    }

    public String getTenDungCu() {
        return TenDungCu;
    }

    public void setTenDungCu(String TenDungCu) {
        this.TenDungCu = TenDungCu;
    }

    public int getSoLuong() {
        return SoLuong;
    }

    public void setSoLuong(int SoLuong) {
        this.SoLuong = SoLuong;
    }

    public String getDonViTinh() {
        return DonViTinh;
    }

    public void setDonViTinh(String DonViTinh) {
        this.DonViTinh = DonViTinh;
    }

    public String getTinhTrang() {
        return TinhTrang;
    }

    public void setTinhTrang(String TinhTrang) {
        this.TinhTrang = TinhTrang;
    }

    public String getMoTa() {
        return MoTa;
    }

    public void setMoTa(String MoTa) {
        this.MoTa = MoTa;
    }
    
}
