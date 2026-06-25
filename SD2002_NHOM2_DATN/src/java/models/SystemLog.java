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
public class SystemLog {
    private int MaNhatKy;
    private int MaNguoiDung;
    private String HanhDong;
    private String BangTacDong;
    private LocalDateTime ThoiGian;
    private String DiaChiIP;

    public SystemLog() {
    }

    public SystemLog(int MaNhatKy, int MaNguoiDung, String HanhDong, String BangTacDong, LocalDateTime ThoiGian, String DiaChiIP) {
        this.MaNhatKy = MaNhatKy;
        this.MaNguoiDung = MaNguoiDung;
        this.HanhDong = HanhDong;
        this.BangTacDong = BangTacDong;
        this.ThoiGian = ThoiGian;
        this.DiaChiIP = DiaChiIP;
    }

    public int getMaNhatKy() {
        return MaNhatKy;
    }

    public void setMaNhatKy(int MaNhatKy) {
        this.MaNhatKy = MaNhatKy;
    }

    public int getMaNguoiDung() {
        return MaNguoiDung;
    }

    public void setMaNguoiDung(int MaNguoiDung) {
        this.MaNguoiDung = MaNguoiDung;
    }

    public String getHanhDong() {
        return HanhDong;
    }

    public void setHanhDong(String HanhDong) {
        this.HanhDong = HanhDong;
    }

    public String getBangTacDong() {
        return BangTacDong;
    }

    public void setBangTacDong(String BangTacDong) {
        this.BangTacDong = BangTacDong;
    }

    public LocalDateTime getThoiGian() {
        return ThoiGian;
    }

    public void setThoiGian(LocalDateTime ThoiGian) {
        this.ThoiGian = ThoiGian;
    }

    public String getDiaChiIP() {
        return DiaChiIP;
    }

    public void setDiaChiIP(String DiaChiIP) {
        this.DiaChiIP = DiaChiIP;
    }
    
}
