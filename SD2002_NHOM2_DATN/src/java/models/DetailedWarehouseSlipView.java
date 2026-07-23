package models;

/**
 * DTO hiển thị 1 dòng chi tiết phiếu kho kèm Tên vật tư + Đơn vị tính
 * (join Supplie), dùng cho form xem chi tiết phiếu kho.
 *
 * @author longd
 */
public class DetailedWarehouseSlipView {
    private int MaChiTiet;
    private int MaPhieuKho;
    private int MaVatTu;
    private String TenVatTu;
    private String DonViTinh;
    private int SoLuong;
    private double DonGia;
    private double ThanhTien;

    public DetailedWarehouseSlipView() {
    }

    public DetailedWarehouseSlipView(int MaChiTiet, int MaPhieuKho, int MaVatTu, String TenVatTu,
            String DonViTinh, int SoLuong, double DonGia, double ThanhTien) {
        this.MaChiTiet = MaChiTiet;
        this.MaPhieuKho = MaPhieuKho;
        this.MaVatTu = MaVatTu;
        this.TenVatTu = TenVatTu;
        this.DonViTinh = DonViTinh;
        this.SoLuong = SoLuong;
        this.DonGia = DonGia;
        this.ThanhTien = ThanhTien;
    }

    public int getMaChiTiet() {
        return MaChiTiet;
    }

    public void setMaChiTiet(int MaChiTiet) {
        this.MaChiTiet = MaChiTiet;
    }

    public int getMaPhieuKho() {
        return MaPhieuKho;
    }

    public void setMaPhieuKho(int MaPhieuKho) {
        this.MaPhieuKho = MaPhieuKho;
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

    public String getDonViTinh() {
        return DonViTinh;
    }

    public void setDonViTinh(String DonViTinh) {
        this.DonViTinh = DonViTinh;
    }

    public int getSoLuong() {
        return SoLuong;
    }

    public void setSoLuong(int SoLuong) {
        this.SoLuong = SoLuong;
    }

    public double getDonGia() {
        return DonGia;
    }

    public void setDonGia(double DonGia) {
        this.DonGia = DonGia;
    }

    public double getThanhTien() {
        return ThanhTien;
    }

    public void setThanhTien(double ThanhTien) {
        this.ThanhTien = ThanhTien;
    }
}