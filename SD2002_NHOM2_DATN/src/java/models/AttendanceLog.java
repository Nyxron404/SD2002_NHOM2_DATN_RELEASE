package models;
import java.time.LocalDate;

public class AttendanceLog {
    private int maChamCong;
    private int maNguoiDung;
    private int maCongViec;
    private LocalDate ngayTichLuy;
    private double soCongTichLuy;
    private boolean trangThaiDuyet;

    public AttendanceLog() {}

    public AttendanceLog(int maChamCong, int maNguoiDung, int maCongViec, LocalDate ngayTichLuy, double soCongTichLuy, boolean trangThaiDuyet) {
        this.maChamCong = maChamCong;
        this.maNguoiDung = maNguoiDung;
        this.maCongViec = maCongViec;
        this.ngayTichLuy = ngayTichLuy;
        this.soCongTichLuy = soCongTichLuy;
        this.trangThaiDuyet = trangThaiDuyet;
    }

    // Getters and Setters
    public int getMaChamCong() { return maChamCong; }
    public void setMaChamCong(int maChamCong) { this.maChamCong = maChamCong; }
    public int getMaNguoiDung() { return maNguoiDung; }
    public void setMaNguoiDung(int maNguoiDung) { this.maNguoiDung = maNguoiDung; }
    public int getMaCongViec() { return maCongViec; }
    public void setMaCongViec(int maCongViec) { this.maCongViec = maCongViec; }
    public LocalDate getNgayTichLuy() { return ngayTichLuy; }
    public void setNgayTichLuy(LocalDate ngayTichLuy) { this.ngayTichLuy = ngayTichLuy; }
    public double getSoCongTichLuy() { return soCongTichLuy; }
    public void setSoCongTichLuy(double soCongTichLuy) { this.soCongTichLuy = soCongTichLuy; }
    public boolean isTrangThaiDuyet() { return trangThaiDuyet; }
    public void setTrangThaiDuyet(boolean trangThaiDuyet) { this.trangThaiDuyet = trangThaiDuyet; }
}