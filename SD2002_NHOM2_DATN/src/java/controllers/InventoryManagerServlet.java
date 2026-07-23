package controllers;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.DetailedWarehouseSlipView;
import models.Supplie;
import models.WarehouseSlipView;
import services.InventoryManagerService;
import services.WarehouseSlipService;

@WebServlet(name = "inventoryManagerServlet", urlPatterns = {"/inventory"})
public class InventoryManagerServlet extends HttpServlet {

    private InventoryManagerService service = new InventoryManagerService();
    private WarehouseSlipService warehouseSlipService = new WarehouseSlipService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            try {
                int maVatTu = Integer.parseInt(request.getParameter("id"));
                boolean ok = service.deleteSupplie(maVatTu);
                request.getSession().setAttribute(ok ? "SUCCESS_MSG" : "ERROR_MSG",
                        ok ? "Xóa vật tư thành công!" : "Không thể xóa vật tư (có thể vật tư không tồn tại hoặc đang được tham chiếu bởi phiếu kho).");
            } catch (Exception e) {
                e.printStackTrace();
                request.getSession().setAttribute("ERROR_MSG", "Có lỗi xảy ra khi xóa vật tư.");
            }
            response.sendRedirect("inventory");
            return;
        }

        HttpSession session = request.getSession();
        Object successMsg = session.getAttribute("SUCCESS_MSG");
        Object errorMsg = session.getAttribute("ERROR_MSG");
        if (successMsg != null) {
            request.setAttribute("SUCCESS_MSG", successMsg);
            session.removeAttribute("SUCCESS_MSG");
        }
        if (errorMsg != null) {
            request.setAttribute("ERROR_MSG", errorMsg);
            session.removeAttribute("ERROR_MSG");
        }

        // Tab đang được chọn: "supplie" (mặc định, danh sách vật tư) hoặc "warehouse" (danh sách phiếu kho)
        String activeView = request.getParameter("view");
        if (activeView == null || (!activeView.equals("warehouse") && !activeView.equals("supplie"))) {
            activeView = "supplie";
        }
        request.setAttribute("ACTIVE_VIEW", activeView);

        // LIST_SUPPLIE luôn cần: cho bảng vật tư VÀ cho combobox chọn vật tư trong form Nhập/Xuất kho
        request.setAttribute("LIST_SUPPLIE", service.getAllSupplies());

        if ("warehouse".equals(activeView)) {
            loadWarehouseSlipList(request);
        }

        request.getRequestDispatcher("./views/inventoryManager/inventoryManager.jsp").forward(request, response);
    }

    /**
     * Đọc tham số lọc (loại phiếu, khoảng giá trị, khoảng ngày) từ request, gọi Service
     * để lấy danh sách phiếu kho đã lọc (kèm Tên người lập + Tổng tiền), đồng thời nạp sẵn
     * chi tiết từng phiếu để hiển thị trong form "Xem chi tiết" mà không cần gọi thêm AJAX/JS.
     */
    private void loadWarehouseSlipList(HttpServletRequest request) {
        String loaiPhieu = request.getParameter("loaiPhieu");
        String giaKhoang = request.getParameter("giaKhoang");
        String tuNgayStr = request.getParameter("tuNgay");
        String denNgayStr = request.getParameter("denNgay");

        // Quy đổi mốc giá trị phiếu sang khoảng số tiền cụ thể
        Double giaTienTu = null;
        Double giaTienDen = null;
        if (giaKhoang != null) {
            switch (giaKhoang) {
                case "duoi5":
                    giaTienDen = 5_000_000d;
                    break;
                case "5-10":
                    giaTienTu = 5_000_000d;
                    giaTienDen = 10_000_000d;
                    break;
                case "10-20":
                    giaTienTu = 10_000_000d;
                    giaTienDen = 20_000_000d;
                    break;
                case "tren20":
                    giaTienTu = 20_000_000d;
                    break;
                default:
                    // "" hoặc giá trị khác -> không lọc theo giá
            }
        }

        LocalDate tuNgay = null;
        LocalDate denNgay = null;
        try {
            if (tuNgayStr != null && !tuNgayStr.trim().isEmpty()) {
                tuNgay = LocalDate.parse(tuNgayStr.trim());
            }
            if (denNgayStr != null && !denNgayStr.trim().isEmpty()) {
                denNgay = LocalDate.parse(denNgayStr.trim());
            }
        } catch (Exception e) {
            e.printStackTrace(); // sai định dạng ngày -> bỏ qua điều kiện ngày, không chặn cả trang
        }

        String loaiPhieuLoc = (loaiPhieu == null || loaiPhieu.trim().isEmpty()) ? null : loaiPhieu;

        List<WarehouseSlipView> listSlip = warehouseSlipService.getFilteredSlips(
                loaiPhieuLoc, giaTienTu, giaTienDen, tuNgay, denNgay);

        // Nạp sẵn chi tiết từng phiếu (join tên vật tư) để JSP hiển thị modal mà không cần JS gọi lại server
        Map<Integer, List<DetailedWarehouseSlipView>> mapDetails = new HashMap<>();
        for (WarehouseSlipView slip : listSlip) {
            mapDetails.put(slip.getMaPhieuKho(), warehouseSlipService.getDetailsWithName(slip.getMaPhieuKho()));
        }

        request.setAttribute("LIST_WAREHOUSE_SLIP", listSlip);
        request.setAttribute("MAP_SLIP_DETAILS", mapDetails);

        // Trả lại giá trị đã chọn để JSP tự chọn lại đúng ô lọc sau khi submit
        request.setAttribute("FILTER_LOAIPHIEU", loaiPhieu);
        request.setAttribute("FILTER_GIAKHOANG", giaKhoang);
        request.setAttribute("FILTER_TUNGAY", tuNgayStr);
        request.setAttribute("FILTER_DENNGAY", denNgayStr);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        // Đọc trước tất cả tham số dạng String để có thể echo lại lên form nếu có lỗi
        String maVatTuStr = request.getParameter("maVatTu");
        String tenVatTu = request.getParameter("tenVatTu");
        String loaiVatTu = request.getParameter("loaiVatTu");
        String donViTinh = request.getParameter("donViTinh");
        String soLuongTonStr = request.getParameter("soLuongTon");
        String soLuongToiThieuStr = request.getParameter("soLuongToiThieu");
        String donGiaStr = request.getParameter("donGia");
        String moTa = request.getParameter("moTa");
        String ngayNhapStr = request.getParameter("ngayNhapGanNhat");
        String trangThaiStr = request.getParameter("trangThai");

        String errorMsg = null;
        try {
            int soLuongTon = Integer.parseInt(soLuongTonStr);
            int soLuongToiThieu = (soLuongToiThieuStr == null || soLuongToiThieuStr.trim().isEmpty())
                    ? 0 : Integer.parseInt(soLuongToiThieuStr.trim());
            double donGia = Double.parseDouble(donGiaStr);
            LocalDateTime ngayNhap = LocalDateTime.parse(ngayNhapStr);
            boolean trangThai = Boolean.parseBoolean(trangThaiStr);

            if ("add".equals(action)) {
                Supplie s = new Supplie(0, tenVatTu, loaiVatTu, donViTinh, soLuongTon, soLuongToiThieu, donGia, moTa, ngayNhap, trangThai);
                errorMsg = service.addSupplie(s);
                if (errorMsg == null) {
                    session.setAttribute("SUCCESS_MSG", "Thêm vật tư mới thành công!");
                    response.sendRedirect("inventory");
                    return;
                }
            } else if ("edit".equals(action)) {
                int maVatTu = Integer.parseInt(maVatTuStr);
                Supplie s = new Supplie(maVatTu, tenVatTu, loaiVatTu, donViTinh, soLuongTon, soLuongToiThieu, donGia, moTa, ngayNhap, trangThai);
                errorMsg = service.updateSupplie(s);
                if (errorMsg == null) {
                    session.setAttribute("SUCCESS_MSG", "Cập nhật vật tư thành công!");
                    response.sendRedirect("inventory");
                    return;
                }
            } else {
                errorMsg = "Hành động không hợp lệ.";
            }
        } catch (NumberFormatException | java.time.format.DateTimeParseException e) {
            errorMsg = "Dữ liệu nhập không hợp lệ (số lượng, đơn giá hoặc ngày nhập sai định dạng).";
        } catch (Exception e) {
            e.printStackTrace();
            errorMsg = "Có lỗi xảy ra, vui lòng thử lại.";
        }

        // Có lỗi -> forward lại trang (KHÔNG redirect) để giữ lại dữ liệu vừa nhập,
        // JSP sẽ tự mở lại modal Thêm/Sửa và hiển thị lỗi ngay trên form.
        request.setAttribute("FORM_ERROR_MSG", errorMsg);
        request.setAttribute("FORM_ACTION", action);
        request.setAttribute("FORM_MAVATTU", maVatTuStr);
        request.setAttribute("FORM_TENVATTU", tenVatTu);
        request.setAttribute("FORM_LOAIVATTU", loaiVatTu);
        request.setAttribute("FORM_DONVITINH", donViTinh);
        request.setAttribute("FORM_SOLUONGTON", soLuongTonStr);
        request.setAttribute("FORM_SOLUONGTOITHIEU", soLuongToiThieuStr);
        request.setAttribute("FORM_DONGIA", donGiaStr);
        request.setAttribute("FORM_MOTA", moTa);
        request.setAttribute("FORM_NGAYNHAP", ngayNhapStr);
        request.setAttribute("FORM_TRANGTHAI", trangThaiStr);

        // Lỗi thêm/sửa vật tư luôn xảy ra ở tab "vật tư" -> ép ACTIVE_VIEW về "supplie"
        request.setAttribute("ACTIVE_VIEW", "supplie");
        request.setAttribute("LIST_SUPPLIE", service.getAllSupplies());
        request.getRequestDispatcher("./views/inventoryManager/inventoryManager.jsp").forward(request, response);
    }
}