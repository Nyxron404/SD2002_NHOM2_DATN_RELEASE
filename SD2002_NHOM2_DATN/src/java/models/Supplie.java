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
public class Supplie {
    private int MaVatTu;
    private String TenVatTu;
    private String LoaiVatTu;
    private String DonViTinh;
    private int SoLuongTon;
    private int soLuongToiThieu;
    private double DonGia;
    private String MoTa;
    private LocalDateTime NgayNhapGanNhat;
    private boolean TrangThai;

    public Supplie() {
    }

    public Supplie(int MaVatTu, String TenVatTu, String LoaiVatTu, String DonViTinh, int SoLuongTon, int soLuongToiThieu, double DonGia, String MoTa, LocalDateTime NgayNhapGanNhat, boolean TrangThai) {
        this.MaVatTu = MaVatTu;
        this.TenVatTu = TenVatTu;
        this.LoaiVatTu = LoaiVatTu;
        this.DonViTinh = DonViTinh;
        this.SoLuongTon = SoLuongTon;
        this.soLuongToiThieu = soLuongToiThieu;
        this.DonGia = DonGia;
        this.MoTa = MoTa;
        this.NgayNhapGanNhat = NgayNhapGanNhat;
        this.TrangThai = TrangThai;
    }

    

    public int getMaVatTu() {
        return MaVatTu;
    }

    public void setMaVatTu(int MaVatTu) {
        this.MaVatTu = MaVatTu;
    }

    public String getTenVatTu() {
        return TenVatTu;
    }

    public void setTenVatTu(String TenVatTu) {
        this.TenVatTu = TenVatTu;
    }

    public String getLoaiVatTu() {
        return LoaiVatTu;
    }

    public void setLoaiVatTu(String LoaiVatTu) {
        this.LoaiVatTu = LoaiVatTu;
    }

    public String getDonViTinh() {
        return DonViTinh;
    }

    public void setDonViTinh(String DonViTinh) {
        this.DonViTinh = DonViTinh;
    }

    public int getSoLuongTon() {
        return SoLuongTon;
    }

    public void setSoLuongTon(int SoLuongTon) {
        this.SoLuongTon = SoLuongTon;
    }

    public double getDonGia() {
        return DonGia;
    }

    public void setDonGia(double DonGia) {
        this.DonGia = DonGia;
    }

    public String getMoTa() {
        return MoTa;
    }

    public void setMoTa(String MoTa) {
        this.MoTa = MoTa;
    }

    public LocalDateTime getNgayNhapGanNhat() {
        return NgayNhapGanNhat;
    }

    public void setNgayNhapGanNhat(LocalDateTime NgayNhapGanNhat) {
        this.NgayNhapGanNhat = NgayNhapGanNhat;
    }

    public boolean isTrangThai() {
        return TrangThai;
    }

    public void setTrangThai(boolean TrangThai) {
        this.TrangThai = TrangThai;
    }
    
}
