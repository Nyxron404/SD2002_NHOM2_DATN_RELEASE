package controllers;

import dao.EquipmentDAO;
import dao.SystemLogDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import models.BorrowEquipment;
import models.Equipment;
import models.MaintenanceSchedule;
import services.EquipmentManagerService;
import uril.DBConnect;

/**
 * Servlet điều hướng cho module Quản lý thiết bị & Bảo trì.
 *
 * GET  /equipmentManager?view=equipment    -> danh sách thiết bị      (UC-5.1, UC-5.2)
 * GET  /equipmentManager?view=maintenance  -> danh sách lịch bảo trì  (UC-6.1, UC-6.2)
 * GET  /equipmentManager?view=usage        -> lịch sử sử dụng         (UC-5.3)
 *
 * POST /equipmentManager  action=addEquipment | updateStatus
 *                                | borrow | returnEquipment
 *                                | addSchedule | completeSchedule
 *
 * @author (Quản lý thiết bị & Bảo trì)
 */
@WebServlet(name = "equipmentManagerServlet", urlPatterns = {"/equipmentManager"})
public class EquipmentManagerServlet extends HttpServlet {

    private final EquipmentManagerService service = new EquipmentManagerService();

    // Lấy IP client để ghi log (giống pattern HrManagerServlet)
    private String getClientIpAddress(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        if ("0:0:0:0:0:0:0:1".equals(ip) || "127.0.0.1".equals(ip)) {
            try {
                ip = java.net.InetAddress.getLocalHost().getHostAddress();
            } catch (Exception e) {
                ip = "127.0.0.1";
            }
        }
        return ip;
    }

    // session lưu "userId" = MaNguoiDung (tài khoản đăng nhập).
    // BorrowEquipment.MaNhanVien / MaintenanceSchedule.NguoiThucHien lại cần MaNhanVien (mã nhân viên)
    // -> tra ngược qua bảng Staff.
    private int getCurrentMaNhanVien(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return 0;
        }
        Object obj = session.getAttribute("userId");
        if (!(obj instanceof Integer)) {
            return 0;
        }
        int maNguoiDung = (Integer) obj;

        String sql = "SELECT MaNhanVien FROM Staff WHERE MaNguoiDung = ?";
        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, maNguoiDung);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("MaNhanVien");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String view = request.getParameter("view");
        if (view == null || view.trim().isEmpty()) {
            view = "equipment";
        }
        request.setAttribute("ACTIVE_VIEW", view);

        String keyword = request.getParameter("keyword");

        switch (view) {
            case "maintenance":
                request.setAttribute("LIST_SCHEDULE", service.getAllSchedules());
                request.setAttribute("LIST_EQUIPMENT", service.getAllEquipment());
                break;
            case "usage":
                request.setAttribute("LIST_USAGE", service.getAllUsageHistory());
                request.setAttribute("LIST_EQUIPMENT", service.getAllEquipment());
                break;
            case "equipment":
            default:
                if (keyword != null && !keyword.trim().isEmpty()) {
                    request.setAttribute("LIST_EQUIPMENT", service.searchEquipment(keyword));
                    request.setAttribute("KEYWORD", keyword);
                } else {
                    request.setAttribute("LIST_EQUIPMENT", service.getAllEquipment());
                }
                break;
        }

        request.getRequestDispatcher("./views/equipmentManager/equipmentManager.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }

        HttpSession session = request.getSession();
        Integer nguoiThucHien = (Integer) session.getAttribute("userId"); // dùng để ghi SystemLog (MaNguoiDung)
        if (nguoiThucHien == null) {
            nguoiThucHien = 1; // giá trị dự phòng nếu session chưa có, giống HrManagerServlet
        }
        String clientIp = getClientIpAddress(request);

        String errorMsg = null;
        String redirectView = "equipment";

        try {
            switch (action) {
                case "addEquipment": {
                    redirectView = "equipment";
                    String tenThietBi = request.getParameter("tenThietBi");
                    errorMsg = handleAddEquipment(request);
                    if (errorMsg == null) {
                        request.setAttribute("toastMessage", "Thêm thiết bị thành công!");
                        request.setAttribute("toastType", "success");
                        SystemLogDAO.insertLog(nguoiThucHien, "THÊM THIẾT BỊ MỚI: " + tenThietBi, "Equipment", clientIp);
                    }
                    break;
                }
                case "updateStatus": {
                    redirectView = "equipment";
                    String maThietBiStr = request.getParameter("maThietBi");
                    errorMsg = handleUpdateStatus(request);
                    if (errorMsg == null) {
                        request.setAttribute("toastMessage", "Cập nhật trạng thái thành công!");
                        request.setAttribute("toastType", "success");
                        SystemLogDAO.insertLog(nguoiThucHien, "CẬP NHẬT TÌNH TRẠNG THIẾT BỊ (Mã TB: " + maThietBiStr + ")", "Equipment", clientIp);
                    }
                    break;
                }
                case "borrow": {
                    redirectView = "usage";
                    errorMsg = handleBorrow(request);
                    if (errorMsg == null) {
                        request.setAttribute("toastMessage", "Lập phiếu sử dụng thành công!");
                        request.setAttribute("toastType", "success");
                        SystemLogDAO.insertLog(nguoiThucHien, "LẬP PHIẾU SỬ DỤNG THIẾT BỊ (Mã TB: " + request.getParameter("maThietBi") + ")", "BorrowEquipment", clientIp);
                    }
                    break;
                }
                case "returnEquipment": {
                    redirectView = "usage";
                    String maMuonStr = request.getParameter("maMuonThietBi");
                    errorMsg = handleReturn(request);
                    if (errorMsg == null) {
                        request.setAttribute("toastMessage", "Ghi nhận trả thiết bị thành công!");
                        request.setAttribute("toastType", "success");
                        SystemLogDAO.insertLog(nguoiThucHien, "XÁC NHẬN TRẢ THIẾT BỊ (Mã phiếu: " + maMuonStr + ")", "BorrowEquipment", clientIp);
                    }
                    break;
                }
                case "addSchedule": {
                    redirectView = "maintenance";
                    errorMsg = handleAddSchedule(request);
                    if (errorMsg == null) {
                        request.setAttribute("toastMessage", "Lập lịch bảo trì thành công!");
                        request.setAttribute("toastType", "success");
                        SystemLogDAO.insertLog(nguoiThucHien, "LẬP LỊCH BẢO TRÌ (Mã TB: " + request.getParameter("maThietBi") + ")", "MaintenanceSchedule", clientIp);
                    }
                    break;
                }
                case "completeSchedule": {
                    redirectView = "maintenance";
                    String maBaoTriStr = request.getParameter("maBaoTri");
                    errorMsg = handleCompleteSchedule(request);
                    if (errorMsg == null) {
                        request.setAttribute("toastMessage", "Ghi nhận kết quả bảo trì thành công!");
                        request.setAttribute("toastType", "success");
                        SystemLogDAO.insertLog(nguoiThucHien, "GHI NHẬN KẾT QUẢ BẢO TRÌ (Mã BT: " + maBaoTriStr + ")", "MaintenanceSchedule", clientIp);
                    }
                    break;
                }
                default:
                    errorMsg = "Hành động không hợp lệ.";
                    break;
            }
        } catch (NumberFormatException | java.time.format.DateTimeParseException ex) {
            errorMsg = "Dữ liệu nhập không hợp lệ, vui lòng kiểm tra lại các trường số/ngày tháng.";
        }

        if (errorMsg != null) {
            request.setAttribute("toastMessage", errorMsg);
            request.setAttribute("toastType", "error");
        }
        request.setAttribute("ACTIVE_VIEW", redirectView);

        switch (redirectView) {
            case "maintenance":
                request.setAttribute("LIST_SCHEDULE", service.getAllSchedules());
                request.setAttribute("LIST_EQUIPMENT", service.getAllEquipment());
                break;
            case "usage":
                request.setAttribute("LIST_USAGE", service.getAllUsageHistory());
                request.setAttribute("LIST_EQUIPMENT", service.getAllEquipment());
                break;
            default:
                request.setAttribute("LIST_EQUIPMENT", service.getAllEquipment());
                break;
        }

        request.getRequestDispatcher("./views/equipmentManager/equipmentManager.jsp").forward(request, response);
    }

    // ================== UC-5.1 ==================
    private String handleAddEquipment(HttpServletRequest request) {
        String tenThietBi = request.getParameter("tenThietBi");
        String loaiThietBi = request.getParameter("loaiThietBi");
        String ngayMuaStr = request.getParameter("ngayMua");
        String giaTriStr = request.getParameter("giaTri");
        String moTa = request.getParameter("moTa");
        String chuKyStr = request.getParameter("chuKyBaoTriThang");

        if (tenThietBi == null || ngayMuaStr == null || giaTriStr == null || chuKyStr == null
                || tenThietBi.trim().isEmpty() || ngayMuaStr.trim().isEmpty()) {
            return "Vui lòng điền đầy đủ thông tin bắt buộc.";
        }

        Equipment eq = new Equipment(
                tenThietBi,
                loaiThietBi,
                LocalDate.parse(ngayMuaStr),
                Double.parseDouble(giaTriStr),
                "Sẵn sàng",
                moTa,
                Integer.parseInt(chuKyStr)
        );
        return service.addEquipment(eq);
    }

    // ================== UC-5.2 ==================
    private String handleUpdateStatus(HttpServletRequest request) {
        String maThietBiStr = request.getParameter("maThietBi");
        String tinhTrangMoi = request.getParameter("tinhTrangMoi");
        if (maThietBiStr == null || tinhTrangMoi == null || tinhTrangMoi.trim().isEmpty()) {
            return "Thiếu thông tin cập nhật trạng thái.";
        }
        return service.updateEquipmentStatus(Integer.parseInt(maThietBiStr), tinhTrangMoi);
    }

    // ================== UC-5.3 (mượn) ==================
    private String handleBorrow(HttpServletRequest request) {
        String maThietBiStr = request.getParameter("maThietBi");
        String maKhuVucStr = request.getParameter("maKhuVuc");
        String tinhTrangTruoc = request.getParameter("tinhTrangTruocKhiDung");

        if (maThietBiStr == null || maKhuVucStr == null) {
            return "Vui lòng chọn thiết bị và khu vực sử dụng.";
        }

        int maNhanVien = getCurrentMaNhanVien(request);
        if (maNhanVien <= 0) {
            return "Không xác định được nhân viên hiện tại (tài khoản chưa liên kết hồ sơ nhân viên).";
        }

        BorrowEquipment be = new BorrowEquipment(
                Integer.parseInt(maThietBiStr),
                maNhanVien,
                Integer.parseInt(maKhuVucStr),
                tinhTrangTruoc
        );
        return service.borrowEquipment(be);
    }

    // ================== UC-5.3 (trả) ==================
    private String handleReturn(HttpServletRequest request) {
        String maMuonStr = request.getParameter("maMuonThietBi");
        String tinhTrangSau = request.getParameter("tinhTrangSauKhiDung");
        String ghiChu = request.getParameter("ghiChu");

        if (maMuonStr == null || tinhTrangSau == null || tinhTrangSau.trim().isEmpty()) {
            return "Vui lòng nhập tình trạng thiết bị sau khi sử dụng.";
        }
        return service.returnEquipment(Integer.parseInt(maMuonStr), tinhTrangSau, ghiChu);
    }

    // ================== UC-6.1 ==================
    private String handleAddSchedule(HttpServletRequest request) {
        String maThietBiStr = request.getParameter("maThietBi");
        String ngayDuKienStr = request.getParameter("ngayDuKien");
        String noiDungDuKien = request.getParameter("noiDungDuKien");
        String chiPhiStr = request.getParameter("chiPhiDuKien");

        if (maThietBiStr == null || ngayDuKienStr == null || noiDungDuKien == null) {
            return "Vui lòng điền đầy đủ thông tin lịch bảo trì.";
        }

        int nguoiPhuTrach = getCurrentMaNhanVien(request);
        double chiPhi = (chiPhiStr == null || chiPhiStr.trim().isEmpty()) ? 0 : Double.parseDouble(chiPhiStr);

        MaintenanceSchedule ms = new MaintenanceSchedule(
                Integer.parseInt(maThietBiStr),
                LocalDate.parse(ngayDuKienStr),
                noiDungDuKien,
                "Chưa thực hiện",
                chiPhi,
                nguoiPhuTrach
        );
        return service.addMaintenanceSchedule(ms);
    }

    // ================== UC-6.2 ==================
    private String handleCompleteSchedule(HttpServletRequest request) {
        String maBaoTriStr = request.getParameter("maBaoTri");
        String ngayThucTeStr = request.getParameter("ngayThucTe");
        String noiDungThucTe = request.getParameter("noiDungThucTe");
        String chiPhiThucTeStr = request.getParameter("chiPhiThucTe");
        String ketQua = request.getParameter("ketQua");

        if (maBaoTriStr == null || ngayThucTeStr == null) {
            return "Vui lòng nhập ngày hoàn thành thực tế.";
        }

        double chiPhiThucTe = (chiPhiThucTeStr == null || chiPhiThucTeStr.trim().isEmpty())
                ? 0 : Double.parseDouble(chiPhiThucTeStr);

        return service.completeMaintenance(
                Integer.parseInt(maBaoTriStr),
                LocalDate.parse(ngayThucTeStr),
                noiDungThucTe,
                chiPhiThucTe,
                ketQua
        );
    }

    @Override
    public String getServletInfo() {
        return "Quản lý thiết bị và bảo trì";
    }
}