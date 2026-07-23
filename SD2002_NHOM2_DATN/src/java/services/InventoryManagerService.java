package services;

import dao.SupplieDAO;
import java.sql.SQLException;
import java.util.Comparator;
import java.util.List;
import models.Supplie;

public class InventoryManagerService {

    private SupplieDAO supplieDAO = new SupplieDAO();

    /**
     * Lấy danh sách vật tư, đưa các vật tư đang ở/dưới ngưỡng tồn kho tối thiểu lên đầu danh sách
     * để người quản lý dễ nhận biết cần nhập thêm hàng.
     */
    public List<Supplie> getAllSupplies() {
        List<Supplie> list = supplieDAO.SelectSupplie();
        list.sort(Comparator
                .comparing((Supplie s) -> !isLowStock(s)) // hàng tồn thấp (false) đứng trước
                .thenComparing(Supplie::getTenVatTu, String.CASE_INSENSITIVE_ORDER));
        return list;
    }

    public Supplie getSupplieById(int maVatTu) {
        return supplieDAO.getSupplieById(maVatTu);
    }

    /**
     * Thêm vật tư mới.
     * @return null nếu thành công, ngược lại là thông báo lỗi cụ thể để hiển thị lên form.
     */
    public String addSupplie(Supplie s) {
        String error = validate(s, false);
        if (error != null) {
            return error;
        }
        try {
            if (supplieDAO.checkTenVatTuTrung(s.getTenVatTu(), 0)) {
                return "Tên vật tư \"" + s.getTenVatTu() + "\" đã bị trùng, vui lòng chọn tên khác.";
            }
            boolean ok = supplieDAO.addSupplie(s);
            return ok ? null : "Thêm vật tư thất bại, vui lòng thử lại.";
        } catch (SQLException e) {
            e.printStackTrace();
            return "Có lỗi xảy ra khi ghi dữ liệu vào cơ sở dữ liệu, vui lòng thử lại.";
        }
    }

    /**
     * Sửa vật tư. Cho phép đặt ngưỡng tối thiểu LỚN HƠN số lượng tồn kho hiện tại
     * (khác với khi thêm mới) vì tồn kho biến động theo thời gian, người dùng có thể
     * chủ động đặt trước ngưỡng cảnh báo để chuẩn bị nhập thêm hàng.
     */
    public String updateSupplie(Supplie s) {
        if (s.getMaVatTu() <= 0) {
            return "Mã vật tư không hợp lệ.";
        }
        String error = validate(s, true);
        if (error != null) {
            return error;
        }
        try {
            if (supplieDAO.checkTenVatTuTrung(s.getTenVatTu(), s.getMaVatTu())) {
                return "Tên vật tư \"" + s.getTenVatTu() + "\" đã bị trùng, vui lòng chọn tên khác.";
            }
            boolean ok = supplieDAO.updateSupplie(s);
            return ok ? null : "Cập nhật thất bại: không tìm thấy vật tư mã " + s.getMaVatTu() + ".";
        } catch (SQLException e) {
            e.printStackTrace();
            return "Có lỗi xảy ra khi cập nhật dữ liệu, vui lòng thử lại.";
        }
    }

    public boolean deleteSupplie(int maVatTu) {
        if (maVatTu <= 0) {
            return false;
        }
        try {
            return supplieDAO.deleteSupplie(maVatTu);
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean isEnoughStock(int maVatTu, int soLuongCan) {
        Supplie s = supplieDAO.getSupplieById(maVatTu);
        return s != null && s.getSoLuongTon() >= soLuongCan;
    }

    public boolean isLowStock(Supplie s) {
        return s.getSoLuongTon() <= s.getSoLuongToiThieu();
    }

    private String validate(Supplie s, boolean isEdit) {
        if (s.getTenVatTu() == null || s.getTenVatTu().trim().isEmpty()) {
            return "Tên vật tư không được để trống.";
        }
        if (s.getLoaiVatTu() == null || s.getLoaiVatTu().trim().isEmpty()) {
            return "Vui lòng chọn loại vật tư.";
        }
        if (s.getDonViTinh() == null || s.getDonViTinh().trim().isEmpty()) {
            return "Đơn vị tính không được để trống.";
        }
        if (s.getSoLuongTon() < 0) {
            return "Số lượng tồn kho không được âm.";
        }
        if (s.getSoLuongToiThieu() < 0) {
            return "Giới hạn tồn kho tối thiểu không được âm.";
        }
        if (!isEdit && s.getSoLuongToiThieu() > s.getSoLuongTon()) {
            return "Số lượng tồn kho không đủ để đặt giới hạn ngưỡng tối thiểu (khi thêm mới, ngưỡng tối thiểu phải nhỏ hơn hoặc bằng số lượng tồn kho).";
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