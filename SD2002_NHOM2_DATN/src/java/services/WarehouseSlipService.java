/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package services;

import dao.DetailedWarehouseSlipDAO;
import dao.SupplieDAO;
import dao.WarehouseSlipDAO;
import java.sql.Connection;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;
import models.DetailedWarehouseSlip;
import models.Supplie;
import models.WarehouseSlip;
import uril.DBConnect;

/**
 * Xử lý nghiệp vụ lập phiếu Nhập kho / Xuất kho. Mỗi phiếu có thể gồm nhiều
 * dòng vật tư (DetailedWarehouseSlip). Toàn bộ việc tạo phiếu + tạo chi tiết +
 * cập nhật tồn kho chạy trong CÙNG 1 transaction: nếu 1 dòng lỗi (vd không đủ
 * tồn kho khi xuất) thì rollback toàn bộ phiếu.
 *
 * @author longd
 */
public class WarehouseSlipService {

    public static final String PHIEU_NHAP = "Nhập";
    public static final String PHIEU_XUAT = "Xuất";

    private final WarehouseSlipDAO warehouseSlipDAO = new WarehouseSlipDAO();
    private final DetailedWarehouseSlipDAO detailDAO = new DetailedWarehouseSlipDAO();
    private final SupplieDAO supplieDAO = new SupplieDAO();

    /**
     * Lập phiếu NHẬP kho: cộng số lượng tồn cho từng vật tư trong danh sách.
     *
     * @return null nếu thành công, ngược lại trả về thông báo lỗi để hiển thị
     * cho người dùng.
     */
    public String createImportSlip(int nguoiLap, String ghiChu, List<DetailedWarehouseSlip> chiTietList) {
        String validate = validateCommon(chiTietList);
        if (validate != null) {
            return validate;
        }
        // Kiểm tra vật tư có tồn tại trước khi lập phiếu (tránh lỗi FK khó hiểu khi ghi CSDL)
        for (DetailedWarehouseSlip ct : chiTietList) {
            Supplie s = supplieDAO.getSupplieById(ct.getMaVatTu());
            if (s == null) {
                return "Vật tư mã " + ct.getMaVatTu() + " không tồn tại.";
            }
        }
        return createSlip(PHIEU_NHAP, nguoiLap, ghiChu, chiTietList);
    }

    /**
     * Lập phiếu XUẤT kho: kiểm tra đủ tồn kho cho TỪNG vật tư trước khi cho lập
     * phiếu, sau đó trừ số lượng tồn tương ứng.
     *
     * @return null nếu thành công, ngược lại trả về thông báo lỗi để hiển thị
     * cho người dùng.
     */
    public String createExportSlip(int nguoiLap, String ghiChu, List<DetailedWarehouseSlip> chiTietList) {
        String validate = validateCommon(chiTietList);
        if (validate != null) {
            return validate;
        }

        // Kiểm tra tồn kho hiện có trước khi lập phiếu (kiểm tra "mềm" để báo lỗi thân thiện;
        // updateStock() trong transaction vẫn là lớp bảo vệ cuối cùng chống tồn kho âm).
        for (DetailedWarehouseSlip ct : chiTietList) {
            Supplie s = supplieDAO.getSupplieById(ct.getMaVatTu());
            if (s == null) {
                return "Vật tư mã " + ct.getMaVatTu() + " không tồn tại.";
            }
            if (!s.isTrangThai()) {
                return "Vật tư \"" + s.getTenVatTu() + "\" đang ở trạng thái Ngừng sử dụng, không thể xuất kho.";
            }
            if (s.getSoLuongTon() < ct.getSoLuong()) {
                return "Vật tư \"" + s.getTenVatTu() + "\" không đủ tồn kho (còn " + s.getSoLuongTon()
                        + " " + s.getDonViTinh() + ", cần xuất " + ct.getSoLuong() + ").";
            }
        }

        return createSlip(PHIEU_XUAT, nguoiLap, ghiChu, chiTietList);
    }

    private String validateCommon(List<DetailedWarehouseSlip> chiTietList) {
        if (chiTietList == null || chiTietList.isEmpty()) {
            return "Phiếu phải có ít nhất 1 dòng vật tư.";
        }
        for (DetailedWarehouseSlip ct : chiTietList) {
            if (ct.getMaVatTu() <= 0) {
                return "Vui lòng chọn vật tư hợp lệ cho tất cả các dòng.";
            }
            if (ct.getSoLuong() <= 0) {
                return "Số lượng của mỗi dòng vật tư phải lớn hơn 0.";
            }
            if (ct.getDonGia() < 0) {
                return "Đơn giá không được âm.";
            }
        }
        return null;
    }

    private String createSlip(String loaiPhieu, int nguoiLap, String ghiChu, List<DetailedWarehouseSlip> chiTietList) {
        Connection con = null;
        try {
            con = DBConnect.getConnection();
            con.setAutoCommit(false);

            WarehouseSlip slip = new WarehouseSlip(0, loaiPhieu, LocalDateTime.now(), nguoiLap, ghiChu);
            int maPhieuKho = warehouseSlipDAO.insertWarehouseSlip(con, slip);

            for (DetailedWarehouseSlip ct : chiTietList) {
                ct.setMaPhieuKho(maPhieuKho);
                ct.setThanhTien(ct.getSoLuong() * ct.getDonGia());
                detailDAO.insertDetail(con, ct);

                int delta = PHIEU_NHAP.equals(loaiPhieu) ? ct.getSoLuong() : -ct.getSoLuong();
                supplieDAO.updateStock(con, ct.getMaVatTu(), delta);
            }

            con.commit();
            return null;
        } catch (SQLException e) {
            e.printStackTrace();
            if (con != null) {
                try {
                    con.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            return "Có lỗi xảy ra khi lập phiếu, mọi thay đổi đã được hoàn tác: " + e.getMessage();
        } finally {
            if (con != null) {
                try {
                    con.setAutoCommit(true);
                    con.close();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        }
    }

    public List<WarehouseSlip> getAllSlips() {
        return warehouseSlipDAO.getAllWarehouseSlips();
    }

    public List<WarehouseSlip> getSlipsByType(String loaiPhieu) {
        return warehouseSlipDAO.getWarehouseSlipsByType(loaiPhieu);
    }

    public List<DetailedWarehouseSlip> getDetailsBySlip(int maPhieuKho) {
        return detailDAO.getDetailsByPhieuKho(maPhieuKho);
    }
}
