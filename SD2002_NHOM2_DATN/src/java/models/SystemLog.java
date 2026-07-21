package models;
import java.time.LocalDateTime;

public class SystemLog {
    private int maNhatKy;
    private int maNguoiDung;
    private String hanhDong;
    private String bangTacDong;
    private LocalDateTime thoiGian;
    private String diaChiIP;

    public SystemLog() {}

    public SystemLog(int maNhatKy, int maNguoiDung, String hanhDong, String bangTacDong, LocalDateTime thoiGian, String diaChiIP) {
        this.maNhatKy = maNhatKy;
        this.maNguoiDung = maNguoiDung;
        this.hanhDong = hanhDong;
        this.bangTacDong = bangTacDong;
        this.thoiGian = thoiGian;
        this.diaChiIP = diaChiIP;
    }

    public int getMaNhatKy() { return maNhatKy; }
    public void setMaNhatKy(int maNhatKy) { this.maNhatKy = maNhatKy; }
    public int getMaNguoiDung() { return maNguoiDung; }
    public void setMaNguoiDung(int maNguoiDung) { this.maNguoiDung = maNguoiDung; }
    public String getHanhDong() { return hanhDong; }
    public void setHanhDong(String hanhDong) { this.hanhDong = hanhDong; }
    public String getBangTacDong() { return bangTacDong; }
    public void setBangTacDong(String bangTacDong) { this.bangTacDong = bangTacDong; }
    public LocalDateTime getThoiGian() { return thoiGian; }
    public void setThoiGian(LocalDateTime thoiGian) { this.thoiGian = thoiGian; }
    public String getDiaChiIP() { return diaChiIP; }
    public void setDiaChiIP(String diaChiIP) { this.diaChiIP = diaChiIP; }
}