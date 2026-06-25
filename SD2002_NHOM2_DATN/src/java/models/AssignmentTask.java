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
public class AssignmentTask {
    private int MaPhanCong;
    private int MaCongViec;
    private int MaNguoiDung;
    private LocalDateTime NgayPhanCong;
    private String TrangThai;

    public AssignmentTask() {
    }

    public AssignmentTask(int MaPhanCong, int MaCongViec, int MaNguoiDung, LocalDateTime NgayPhanCong, String TrangThai) {
        this.MaPhanCong = MaPhanCong;
        this.MaCongViec = MaCongViec;
        this.MaNguoiDung = MaNguoiDung;
        this.NgayPhanCong = NgayPhanCong;
        this.TrangThai = TrangThai;
    }

    public int getMaPhanCong() {
        return MaPhanCong;
    }

    public void setMaPhanCong(int MaPhanCong) {
        this.MaPhanCong = MaPhanCong;
    }

    public int getMaCongViec() {
        return MaCongViec;
    }

    public void setMaCongViec(int MaCongViec) {
        this.MaCongViec = MaCongViec;
    }

    public int getMaNguoiDung() {
        return MaNguoiDung;
    }

    public void setMaNguoiDung(int MaNguoiDung) {
        this.MaNguoiDung = MaNguoiDung;
    }

    public LocalDateTime getNgayPhanCong() {
        return NgayPhanCong;
    }

    public void setNgayPhanCong(LocalDateTime NgayPhanCong) {
        this.NgayPhanCong = NgayPhanCong;
    }

    public String getTrangThai() {
        return TrangThai;
    }

    public void setTrangThai(String TrangThai) {
        this.TrangThai = TrangThai;
    }
    
}
