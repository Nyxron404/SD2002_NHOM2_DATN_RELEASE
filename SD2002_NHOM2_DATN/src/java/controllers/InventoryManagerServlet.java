package controllers;

import java.io.IOException;
import java.time.LocalDateTime;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Supplie;
import services.InventoryManagerService;

@WebServlet(name = "inventoryManagerServlet", urlPatterns = {"/inventory"})
public class InventoryManagerServlet extends HttpServlet {

    private InventoryManagerService service = new InventoryManagerService();

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

        request.setAttribute("LIST_SUPPLIE", service.getAllSupplies());
        request.getRequestDispatcher("./views/inventoryManager/inventoryManager.jsp").forward(request, response);
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

        request.setAttribute("LIST_SUPPLIE", service.getAllSupplies());
        request.getRequestDispatcher("./views/inventoryManager/inventoryManager.jsp").forward(request, response);
    }
}