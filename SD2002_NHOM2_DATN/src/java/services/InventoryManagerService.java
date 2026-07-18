/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package services;

import dao.SupplieDAO;
import java.util.List;
import models.Supplie;

/**
 *
 * @author longd
 */
public class InventoryManagerService {

    private SupplieDAO supplieDAO = new SupplieDAO();

    public List<Supplie> getAllSupplies() {
        return supplieDAO.SelectSupplie();
    }

    public Supplie getSupplieById(int maVatTu) {
        return supplieDAO.getSupplieById(maVatTu);
    }

    /**
     * Thêm vật tư mới. Kiểm tra đầy đủ dữ liệu, trong đó có kiểm tra số lượng tồn kho
     * ban đầu (soLuongTon) được thiết lập khi thêm vật tư phải hợp lệ (số nguyên >= 0).
     *
     * @return null nếu thêm thành công, ngược lại trả về thông báo lỗi cụ thể.
     */
    public String addSupplie(Supplie s) {
        String error = validate(s);
        if (error != null) {
            return error;
        }
        supplieDAO.addSupplie(s);
        return null;
    }

    /**
     * Sửa thông tin vật tư.
     * @return null nếu sửa thành công, ngược lại trả về thông báo lỗi cụ thể.
     */
    public String updateSupplie(Supplie s) {
        if (s.getMaVatTu() <= 0) {
            return "Mã vật tư không hợp lệ.";
        }
        String error = validate(s);
        if (error != null) {
            return error;
        }
        supplieDAO.updateSupplie(s);
        return null;
    }

    public boolean deleteSupplie(int maVatTu) {
        if (maVatTu <= 0) {
            return false;
        }
        supplieDAO.deleteSupplie(maVatTu);
        return true;
    }

    /**
     * Kiểm tra tồn kho hiện tại của 1 vật tư có đủ để xuất kho 1 số lượng cho trước hay không.
     * Dùng cho màn hình lập phiếu xuất kho (kiểm tra "mềm" phía trên trước khi submit).
     */
    public boolean isEnoughStock(int maVatTu, int soLuongCan) {
        Supplie s = supplieDAO.getSupplieById(maVatTu);
        return s != null && s.getSoLuongTon() >= soLuongCan;
    }

    /** Vật tư có tồn kho thấp hơn ngưỡng tối thiểu do người dùng tự thiết lập hay không. */
    public boolean isLowStock(Supplie s) {
        return (s.getSoLuongTon() <= s.getSoLuongToiThieu());
    }

    private String validate(Supplie s) {
        if (s.getTenVatTu() == null || s.getTenVatTu().trim().isEmpty()) {
            return "Tên vật tư không được để trống.";
        }
        if (s.getLoaiVatTu() == null || s.getLoaiVatTu().trim().isEmpty()) {
            return "Vui lòng chọn loại vật tư.";
        }
        if (s.getDonViTinh() == null || s.getDonViTinh().trim().isEmpty()) {
            return "Đơn vị tính không được để trống.";
        }
        // Kiểm tra số lượng tồn kho được thiết lập khi thêm/sửa vật tư: phải là số nguyên không âm.
        if (s.getSoLuongTon() < 0) {
            return "Số lượng tồn kho không được âm.";
        }
        // Giới hạn tồn kho tối thiểu do người dùng tự thiết lập để nhận cảnh báo "Tồn thấp".
        if (s.getSoLuongToiThieu() < 0) {
            return "Giới hạn tồn kho tối thiểu không được âm.";
        }
        if (s.getDonGia() < 0) {
            return "Đơn giá không được âm.";
        }
        if (s.getNgayNhapGanNhat() == null) {
            return "Vui lòng chọn ngày nhập gần nhất.";
        }
        return null;
    }
}
