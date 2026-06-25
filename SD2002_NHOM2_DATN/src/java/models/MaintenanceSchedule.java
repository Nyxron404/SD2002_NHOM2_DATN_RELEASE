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
public class MaintenanceSchedule {
    private int MaBaoTri;
    private int MaThietBi;
    private LocalDate NgayDuKien;
    private String NoiDungDuKien;
    private String TrangThai;
    private LocalDate NgayThucTe;
    private String NoiDungThucTe;
    private double ChiPhi;
    private String KetQua;
    private int NguoiThucHien;

    public MaintenanceSchedule() {
    }

    public MaintenanceSchedule(int MaBaoTri, int MaThietBi, LocalDate NgayDuKien, String NoiDungDuKien, String TrangThai, LocalDate NgayThucTe, String NoiDungThucTe, double ChiPhi, String KetQua, int NguoiThucHien) {
        this.MaBaoTri = MaBaoTri;
        this.MaThietBi = MaThietBi;
        this.NgayDuKien = NgayDuKien;
        this.NoiDungDuKien = NoiDungDuKien;
        this.TrangThai = TrangThai;
        this.NgayThucTe = NgayThucTe;
        this.NoiDungThucTe = NoiDungThucTe;
        this.ChiPhi = ChiPhi;
        this.KetQua = KetQua;
        this.NguoiThucHien = NguoiThucHien;
    }
    public MaintenanceSchedule(int MaBaoTri, int MaThietBi, LocalDate NgayDuKien, String NoiDungDuKien, String TrangThai) {
        this.MaBaoTri = MaBaoTri;
        this.MaThietBi = MaThietBi;
        this.NgayDuKien = NgayDuKien;
        this.NoiDungDuKien = NoiDungDuKien;
        this.TrangThai = TrangThai;
    }

    public int getMaBaoTri() {
        return MaBaoTri;
    }

    public void setMaBaoTri(int MaBaoTri) {
        this.MaBaoTri = MaBaoTri;
    }

    public int getMaThietBi() {
        return MaThietBi;
    }

    public void setMaThietBi(int MaThietBi) {
        this.MaThietBi = MaThietBi;
    }

    public LocalDate getNgayDuKien() {
        return NgayDuKien;
    }

    public void setNgayDuKien(LocalDate NgayDuKien) {
        this.NgayDuKien = NgayDuKien;
    }

    public String getNoiDungDuKien() {
        return NoiDungDuKien;
    }

    public void setNoiDungDuKien(String NoiDungDuKien) {
        this.NoiDungDuKien = NoiDungDuKien;
    }

    public String getTrangThai() {
        return TrangThai;
    }

    public void setTrangThai(String TrangThai) {
        this.TrangThai = TrangThai;
    }

    public LocalDate getNgayThucTe() {
        return NgayThucTe;
    }

    public void setNgayThucTe(LocalDate NgayThucTe) {
        this.NgayThucTe = NgayThucTe;
    }

    public String getNoiDungThucTe() {
        return NoiDungThucTe;
    }

    public void setNoiDungThucTe(String NoiDungThucTe) {
        this.NoiDungThucTe = NoiDungThucTe;
    }

    public double getChiPhi() {
        return ChiPhi;
    }

    public void setChiPhi(double ChiPhi) {
        this.ChiPhi = ChiPhi;
    }

    public String getKetQua() {
        return KetQua;
    }

    public void setKetQua(String KetQua) {
        this.KetQua = KetQua;
    }

    public int getNguoiThucHien() {
        return NguoiThucHien;
    }

    public void setNguoiThucHien(int NguoiThucHien) {
        this.NguoiThucHien = NguoiThucHien;
    }
    
}
