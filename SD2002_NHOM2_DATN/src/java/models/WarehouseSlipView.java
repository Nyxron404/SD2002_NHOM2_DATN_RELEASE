package models;

import java.time.LocalDateTime;

/**
 * DTO hiển thị Phiếu kho kèm Tên người lập (join Staff) và Tổng tiền
 * (SUM ThanhTien của các dòng chi tiết thuộc phiếu). Dùng riêng cho màn hình
 * danh sách phiếu kho, không đụng tới model WarehouseSlip gốc.
 *
 * @author longd
 */
public class WarehouseSlipView {
    private int MaPhieuKho;
    private String LoaiPhieu;
    private LocalDateTime NgayLap;
    private int NguoiLap;
    private String TenNguoiLap;
    private String GhiChu;
    private double TongTien;

    public WarehouseSlipView() {
    }

    public WarehouseSlipView(int MaPhieuKho, String LoaiPhieu, LocalDateTime NgayLap, int NguoiLap,
            String TenNguoiLap, String GhiChu, double TongTien) {
        this.MaPhieuKho = MaPhieuKho;
        this.LoaiPhieu = LoaiPhieu;
        this.NgayLap = NgayLap;
        this.NguoiLap = NguoiLap;
        this.TenNguoiLap = TenNguoiLap;
        this.GhiChu = GhiChu;
        this.TongTien = TongTien;
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

    public String getTenNguoiLap() {
        return TenNguoiLap;
    }

    public void setTenNguoiLap(String TenNguoiLap) {
        this.TenNguoiLap = TenNguoiLap;
    }

    public String getGhiChu() {
        return GhiChu;
    }

    public void setGhiChu(String GhiChu) {
        this.GhiChu = GhiChu;
    }

    public double getTongTien() {
        return TongTien;
    }

    public void setTongTien(double TongTien) {
        this.TongTien = TongTien;
    }
}