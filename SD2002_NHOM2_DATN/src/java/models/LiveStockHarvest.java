package models;

import java.time.LocalDate;

/**
 * Ánh xạ bảng [dbo].[LiveStockHarvest] - phiếu thu hoạch vật nuôi.
 * Tương tự VegetableHarvest nhưng áp dụng cho LiveStock.
 */
public class LiveStockHarvest {

    private int maThuHoachVN;
    private int maVatNuoi;
    private String tenVatNuoi;   // JOIN từ LiveStock, chỉ dùng để hiển thị
    private String loaiVatNuoi;  // JOIN từ LiveStock, dùng để gom nhóm biểu đồ
    private LocalDate ngayThuHoach;
    private int soLuongThuHoach;
    private String chatLuong;
    private double giaTriUocTinh;
    private int nguoiThuHoach;
    private String tenNguoiThuHoach; // JOIN từ Staff, chỉ dùng để hiển thị
    private String ghiChu;

    public LiveStockHarvest() {
    }

    public LiveStockHarvest(int maThuHoachVN, int maVatNuoi, String tenVatNuoi, String loaiVatNuoi,
            LocalDate ngayThuHoach, int soLuongThuHoach, String chatLuong, double giaTriUocTinh,
            int nguoiThuHoach, String tenNguoiThuHoach, String ghiChu) {
        this.maThuHoachVN = maThuHoachVN;
        this.maVatNuoi = maVatNuoi;
        this.tenVatNuoi = tenVatNuoi;
        this.loaiVatNuoi = loaiVatNuoi;
        this.ngayThuHoach = ngayThuHoach;
        this.soLuongThuHoach = soLuongThuHoach;
        this.chatLuong = chatLuong;
        this.giaTriUocTinh = giaTriUocTinh;
        this.nguoiThuHoach = nguoiThuHoach;
        this.tenNguoiThuHoach = tenNguoiThuHoach;
        this.ghiChu = ghiChu;
    }

    public int getMaThuHoachVN() {
        return maThuHoachVN;
    }

    public void setMaThuHoachVN(int maThuHoachVN) {
        this.maThuHoachVN = maThuHoachVN;
    }

    public int getMaVatNuoi() {
        return maVatNuoi;
    }

    public void setMaVatNuoi(int maVatNuoi) {
        this.maVatNuoi = maVatNuoi;
    }

    public String getTenVatNuoi() {
        return tenVatNuoi;
    }

    public void setTenVatNuoi(String tenVatNuoi) {
        this.tenVatNuoi = tenVatNuoi;
    }

    public String getLoaiVatNuoi() {
        return loaiVatNuoi;
    }

    public void setLoaiVatNuoi(String loaiVatNuoi) {
        this.loaiVatNuoi = loaiVatNuoi;
    }

    public LocalDate getNgayThuHoach() {
        return ngayThuHoach;
    }

    public void setNgayThuHoach(LocalDate ngayThuHoach) {
        this.ngayThuHoach = ngayThuHoach;
    }

    public int getSoLuongThuHoach() {
        return soLuongThuHoach;
    }

    public void setSoLuongThuHoach(int soLuongThuHoach) {
        this.soLuongThuHoach = soLuongThuHoach;
    }

    public String getChatLuong() {
        return chatLuong;
    }

    public void setChatLuong(String chatLuong) {
        this.chatLuong = chatLuong;
    }

    public double getGiaTriUocTinh() {
        return giaTriUocTinh;
    }

    public void setGiaTriUocTinh(double giaTriUocTinh) {
        this.giaTriUocTinh = giaTriUocTinh;
    }

    public int getNguoiThuHoach() {
        return nguoiThuHoach;
    }

    public void setNguoiThuHoach(int nguoiThuHoach) {
        this.nguoiThuHoach = nguoiThuHoach;
    }

    public String getTenNguoiThuHoach() {
        return tenNguoiThuHoach;
    }

    public void setTenNguoiThuHoach(String tenNguoiThuHoach) {
        this.tenNguoiThuHoach = tenNguoiThuHoach;
    }

    public String getGhiChu() {
        return ghiChu;
    }

    public void setGhiChu(String ghiChu) {
        this.ghiChu = ghiChu;
    }
}
