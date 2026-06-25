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
public class Equipment {
    private int MaThietBi;
    private String TenThietBi;
    private String LoaiThietBi;
    private LocalDate NgayMua;
    private double GiaTri;
    private String TinhTrang;
    private String MoTa;
    private int ChuKyBaoTriThang;

    public Equipment() {
    }

    public Equipment(int MaThietBi, String TenThietBi, String LoaiThietBi, LocalDate NgayMua, double GiaTri, String TinhTrang, String MoTa, int ChuKyBaoTriThang) {
        this.MaThietBi = MaThietBi;
        this.TenThietBi = TenThietBi;
        this.LoaiThietBi = LoaiThietBi;
        this.NgayMua = NgayMua;
        this.GiaTri = GiaTri;
        this.TinhTrang = TinhTrang;
        this.MoTa = MoTa;
        this.ChuKyBaoTriThang = ChuKyBaoTriThang;
    }

    public int getMaThietBi() {
        return MaThietBi;
    }

    public void setMaThietBi(int MaThietBi) {
        this.MaThietBi = MaThietBi;
    }

    public String getTenThietBi() {
        return TenThietBi;
    }

    public void setTenThietBi(String TenThietBi) {
        this.TenThietBi = TenThietBi;
    }

    public String getLoaiThietBi() {
        return LoaiThietBi;
    }

    public void setLoaiThietBi(String LoaiThietBi) {
        this.LoaiThietBi = LoaiThietBi;
    }

    public LocalDate getNgayMua() {
        return NgayMua;
    }

    public void setNgayMua(LocalDate NgayMua) {
        this.NgayMua = NgayMua;
    }

    public double getGiaTri() {
        return GiaTri;
    }

    public void setGiaTri(double GiaTri) {
        this.GiaTri = GiaTri;
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

    public int getChuKyBaoTriThang() {
        return ChuKyBaoTriThang;
    }

    public void setChuKyBaoTriThang(int ChuKyBaoTriThang) {
        this.ChuKyBaoTriThang = ChuKyBaoTriThang;
    }
    
}
