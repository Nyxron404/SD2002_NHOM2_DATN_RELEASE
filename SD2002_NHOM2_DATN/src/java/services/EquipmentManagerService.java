package services;

import dao.BorrowDAO;
import dao.EquipmentDAO;
import dao.MaintenanceScheduleDAO;
import java.time.LocalDate;
import java.util.List;
import models.BorrowEquipment;
import models.Equipment;
import models.MaintenanceSchedule;

/**
 * Lớp nghiệp vụ trung gian cho module Quản lý thiết bị & Bảo trì.
 * Servlet gọi qua đây thay vì gọi thẳng DAO, để tập trung logic validate
 * và các quy tắc nghiệp vụ theo đúng UC-5.1, 5.2, 5.3, 6.1, 6.2.
 */
public class EquipmentManagerService {

    private final EquipmentDAO equipmentDAO;
    private final MaintenanceScheduleDAO maintenanceDAO;
    private final BorrowDAO borrowDAO;

    public EquipmentManagerService() {
        this.equipmentDAO = new EquipmentDAO();
        this.maintenanceDAO = new MaintenanceScheduleDAO();
        this.borrowDAO = new BorrowDAO();
    }

    // ================== UC-5.1: Thêm mới thiết bị ==================
    public String addEquipment(Equipment eq) {
        if (eq.getTenThietBi() == null || eq.getTenThietBi().trim().isEmpty()) {
            return "Tên thiết bị không được để trống.";
        }
        if (eq.getNgayMua() == null) {
            return "Ngày mua không được để trống.";
        }
        if (eq.getNgayMua().isAfter(LocalDate.now())) {
            return "Ngày mua không hợp lệ (không được ở tương lai).";
        }
        if (eq.getGiaTri() < 0) {
            return "Giá trị thiết bị không hợp lệ.";
        }
        if (eq.getChuKyBaoTriThang() <= 0) {
            return "Chu kỳ bảo trì (tháng) phải lớn hơn 0.";
        }
        if (equipmentDAO.checkTenThietBiExists(eq.getTenThietBi())) {
            return "Tên thiết bị đã tồn tại trong hệ thống.";
        }
        if (eq.getTinhTrang() == null || eq.getTinhTrang().trim().isEmpty()) {
            eq.setTinhTrang(EquipmentDAO.TT_SAN_SANG);
        }

        int id = equipmentDAO.insertEquipment(eq);
        return id > 0 ? null : "Lưu thiết bị thất bại, vui lòng thử lại.";
    }

    // ================== UC-5.2: Cập nhật tình trạng thiết bị ==================
    public String updateEquipmentStatus(int maThietBi, String tinhTrangMoi) {
        Equipment eq = equipmentDAO.getEquipmentById(maThietBi);
        if (eq == null) {
            return "Không tìm thấy thiết bị.";
        }
        if (!isValidStatus(tinhTrangMoi)) {
            return "Trạng thái không hợp lệ.";
        }

        // Nếu đang có phiếu mượn chưa trả mà chuyển sang Hỏng/Bảo trì -> chặn (Lưu ý UC-5.2)
        BorrowEquipment active = borrowDAO.getActiveBorrowByEquipment(maThietBi);
        if (active != null && !tinhTrangMoi.equals(EquipmentDAO.TT_DANG_SU_DUNG)) {
            return "Thiết bị đang được mượn sử dụng, không thể chuyển trạng thái này.";
        }

        boolean ok = equipmentDAO.updateEquipmentStatus(maThietBi, tinhTrangMoi);
        return ok ? null : "Cập nhật trạng thái thất bại.";
    }

    private boolean isValidStatus(String tt) {
        return EquipmentDAO.TT_SAN_SANG.equals(tt) || EquipmentDAO.TT_DANG_SU_DUNG.equals(tt)
                || EquipmentDAO.TT_BAO_TRI.equals(tt) || EquipmentDAO.TT_HONG.equals(tt);
    }

    // ================== UC-5.3: Lập phiếu sử dụng (mượn thiết bị) ==================
    public String borrowEquipment(BorrowEquipment be) {
        Equipment eq = equipmentDAO.getEquipmentById(be.getMaThietBi());
        if (eq == null) {
            return "Không tìm thấy thiết bị.";
        }
        if (!EquipmentDAO.TT_SAN_SANG.equals(eq.getTinhTrang())) {
            return "Thiết bị hiện không sẵn sàng để sử dụng (đang: " + eq.getTinhTrang() + ").";
        }

        int id = borrowDAO.createBorrowRecord(be);
        if (id <= 0) {
            return "Lập phiếu sử dụng thất bại, vui lòng thử lại.";
        }
        equipmentDAO.updateEquipmentStatus(eq.getMaThietBi(), EquipmentDAO.TT_DANG_SU_DUNG);
        return null;
    }

    // ================== UC-5.3: Xác nhận trả thiết bị ==================
    public String returnEquipment(int maMuonThietBi, String tinhTrangSauKhiDung, String ghiChu) {
        BorrowEquipment be = borrowDAO.getById(maMuonThietBi);
        if (be == null) {
            return "Không tìm thấy phiếu sử dụng.";
        }
        if (!BorrowDAO.TT_DANG_SU_DUNG.equals(be.getTrangThai())) {
            return "Phiếu sử dụng này đã được xử lý trước đó.";
        }

        boolean ok = borrowDAO.returnEquipment(maMuonThietBi, tinhTrangSauKhiDung, ghiChu);
        if (!ok) {
            return "Ghi nhận trả thiết bị thất bại.";
        }

        // Nếu tình trạng sau khi dùng là "Hỏng" thì chuyển thiết bị sang trạng thái Hỏng,
        // ngược lại đưa về Sẵn sàng để có thể tiếp tục cho mượn
        String tinhTrangThietBiMoi = "Hỏng".equalsIgnoreCase(tinhTrangSauKhiDung)
                ? EquipmentDAO.TT_HONG : EquipmentDAO.TT_SAN_SANG;
        equipmentDAO.updateEquipmentStatus(be.getMaThietBi(), tinhTrangThietBiMoi);
        return null;
    }

    // ================== UC-6.1: Lập lịch bảo trì định kỳ ==================
    public String addMaintenanceSchedule(MaintenanceSchedule ms) {
        Equipment eq = equipmentDAO.getEquipmentById(ms.getMaThietBi());
        if (eq == null) {
            return "Không tìm thấy thiết bị.";
        }
        if (ms.getNgayDuKien() == null) {
            return "Ngày bảo trì dự kiến không được để trống.";
        }
        if (ms.getNgayDuKien().isBefore(LocalDate.now())) {
            return "Ngày bảo trì dự kiến không được ở quá khứ.";
        }
        if (ms.getNoiDungDuKien() == null || ms.getNoiDungDuKien().trim().isEmpty()) {
            return "Vui lòng nhập hạng mục cần kiểm tra.";
        }

        int id = maintenanceDAO.insertSchedule(ms);
        return id > 0 ? null : "Lập lịch bảo trì thất bại.";
    }

    // ================== UC-6.2: Ghi nhận kết quả bảo trì ==================
    public String completeMaintenance(int maBaoTri, LocalDate ngayThucTe, String noiDungThucTe,
            double chiPhiThucTe, String ketQua) {
        if (ngayThucTe == null) {
            return "Ngày hoàn thành thực tế không được để trống.";
        }
        if (chiPhiThucTe < 0) {
            return "Chi phí thực tế không hợp lệ.";
        }
        boolean ok = maintenanceDAO.completeSchedule(maBaoTri, ngayThucTe, noiDungThucTe, chiPhiThucTe, ketQua);
        return ok ? null : "Ghi nhận kết quả bảo trì thất bại.";
    }

    // ================== Các hàm lấy dữ liệu để hiển thị ==================
    public List<Equipment> getAllEquipment() {
        return equipmentDAO.getAllEquipment();
    }

    public List<Equipment> searchEquipment(String keyword) {
        return equipmentDAO.searchEquipment(keyword);
    }

    public List<MaintenanceSchedule> getAllSchedules() {
        return maintenanceDAO.getAllSchedules();
    }

    public List<BorrowEquipment> getAllUsageHistory() {
        return borrowDAO.getAllHistory();
    }

    public List<BorrowEquipment> getUsageHistoryByEquipment(int maThietBi) {
        return borrowDAO.getHistoryByEquipment(maThietBi);
    }
}