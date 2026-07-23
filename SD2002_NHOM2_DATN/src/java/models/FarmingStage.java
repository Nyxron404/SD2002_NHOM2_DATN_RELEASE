package models;

import java.util.Date;

public class FarmingStage{
    private int ID;
    private int MaQuyTrinh;
    private String stageName;
    private Date startDay;
    private Date endDay;
    private String TenVatTu;
    private double dinhLuong;
    private String donVi;
    private String moTa;

    public FarmingStage() {
    }

    public FarmingStage(int ID, int MaQuyTrinh, String stageName, Date startDay, Date endDay, String TenVatTu, double dinhLuong, String donVi, String moTa) {
        this.ID = ID;
        this.MaQuyTrinh = MaQuyTrinh;
        this.stageName = stageName;
        this.startDay = startDay;
        this.endDay = endDay;
        this.TenVatTu = TenVatTu;
        this.dinhLuong = dinhLuong;
        this.donVi = donVi;
        this.moTa = moTa;
    }

    public int getID() {
        return ID;
    }

    public void setID(int ID) {
        this.ID = ID;
    }

    public int getMaQuyTrinh() {
        return MaQuyTrinh;
    }

    public void setMaQuyTrinh(int MaQuyTrinh) {
        this.MaQuyTrinh = MaQuyTrinh;
    }

    public String getStageName() {
        return stageName;
    }

    public void setStageName(String stageName) {
        this.stageName = stageName;
    }

    public Date getStartDay() {
        return startDay;
    }

    public void setStartDay(Date startDay) {
        this.startDay = startDay;
    }

    public Date getEndDay() {
        return endDay;
    }

    public void setEndDay(Date endDay) {
        this.endDay = endDay;
    }

    public String getTenVatTu() {
        return TenVatTu;
    }

    public void setTenVatTu(String TenVatTu) {
        this.TenVatTu = TenVatTu;
    }

    public double getDinhLuong() {
        return dinhLuong;
    }

    public void setDinhLuong(double dinhLuong) {
        this.dinhLuong = dinhLuong;
    }

    public String getDonVi() {
        return donVi;
    }

    public void setDonVi(String donVi) {
        this.donVi = donVi;
    }

    public String getMoTa() {
        return moTa;
    }

    public void setMoTa(String moTa) {
        this.moTa = moTa;
    }
    
}