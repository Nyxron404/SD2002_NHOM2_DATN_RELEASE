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
public class WarehouseSlip {
    private int MaPhieuKho;
    private String LoaiPhieu;
    private LocalDateTime NgayLap;
    private int NguoiLap;
    private String GhiChu;

    public WarehouseSlip() {
    }

    public WarehouseSlip(int MaPhieuKho, String LoaiPhieu, LocalDateTime NgayLap, int NguoiLap, String GhiChu) {
        this.MaPhieuKho = MaPhieuKho;
        this.LoaiPhieu = LoaiPhieu;
        this.NgayLap = NgayLap;
        this.NguoiLap = NguoiLap;
        this.GhiChu = GhiChu;
    }

    public int getMaPhieuKho() {
        return MaPhieuKho;
    }

    public void setMaPhieuKho(int MaPhieuKho) {
        this.MaPhieuKho = MaPhieuKho;
    }

    public String getLoaiPhieu() {
        return LoaiPhieu;
    }

    public void setLoaiPhieu(String LoaiPhieu) {
        this.LoaiPhieu = LoaiPhieu;
    }

    public LocalDateTime getNgayLap() {
        return NgayLap;
    }

    public void setNgayLap(LocalDateTime NgayLap) {
        this.NgayLap = NgayLap;
    }

    public int getNguoiLap() {
        return NguoiLap;
    }

    public void setNguoiLap(int NguoiLap) {
        this.NguoiLap = NguoiLap;
    }

    public String getGhiChu() {
        return GhiChu;
    }

    public void setGhiChu(String GhiChu) {
        this.GhiChu = GhiChu;
    }
    
}
