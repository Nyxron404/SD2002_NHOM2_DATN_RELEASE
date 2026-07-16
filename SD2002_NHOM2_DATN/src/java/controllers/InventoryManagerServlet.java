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

/**
 *
 * @author Hoang Anh
 */
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
                        ok ? "Xóa vật tư thành công!" : "Không thể xóa vật tư.");
            } catch (Exception e) {
                e.printStackTrace();
                request.getSession().setAttribute("ERROR_MSG", "Có lỗi xảy ra khi xóa vật tư.");
            }
            response.sendRedirect("inventory");
            return;
        }

        // Hiển thị thông báo thành công/lỗi (flash message) được set từ chính servlet này
        // hoặc từ WarehouseSlipServlet (khi lập phiếu Nhập/Xuất kho), rồi xóa khỏi session.
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
        String action = request.getParameter("action"); // Nhận "add" hoặc "edit" từ form ẩn
        HttpSession session = request.getSession();

        String errorMsg = null;
        try {
            String tenVatTu = request.getParameter("tenVatTu");
            String loaiVatTu = request.getParameter("loaiVatTu");
            String donViTinh = request.getParameter("donViTinh");
            int soLuongTon = Integer.parseInt(request.getParameter("soLuongTon"));
            // Giới hạn tồn kho tối thiểu do người dùng tự thiết lập; nếu bỏ trống thì mặc định 0 (không cảnh báo).
            String soLuongToiThieuParam = request.getParameter("soLuongToiThieu");
            int soLuongToiThieu = (soLuongToiThieuParam == null || soLuongToiThieuParam.trim().isEmpty())
                    ? 0 : Integer.parseInt(soLuongToiThieuParam.trim());
            double donGia = Double.parseDouble(request.getParameter("donGia"));
            String moTa = request.getParameter("moTa");
            LocalDateTime ngayNhap = LocalDateTime.parse(request.getParameter("ngayNhapGanNhat"));
            boolean trangThai = Boolean.parseBoolean(request.getParameter("trangThai"));

            if ("add".equals(action)) {
                Supplie s = new Supplie(0, tenVatTu, loaiVatTu, donViTinh, soLuongTon, soLuongToiThieu, donGia, moTa, ngayNhap, trangThai);
                errorMsg = service.addSupplie(s);
                if (errorMsg == null) {
                    session.setAttribute("SUCCESS_MSG", "Thêm vật tư mới thành công!");
                }
            } else if ("edit".equals(action)) {
                int maVatTu = Integer.parseInt(request.getParameter("maVatTu"));
                Supplie s = new Supplie(maVatTu, tenVatTu, loaiVatTu, donViTinh, soLuongTon, soLuongToiThieu, donGia, moTa, ngayNhap, trangThai);
                errorMsg = service.updateSupplie(s);
                if (errorMsg == null) {
                    session.setAttribute("SUCCESS_MSG", "Cập nhật vật tư thành công!");
                }
            }
        } catch (NumberFormatException | java.time.format.DateTimeParseException e) {
            errorMsg = "Dữ liệu nhập không hợp lệ (số lượng, đơn giá hoặc ngày nhập sai định dạng).";
        } catch (Exception e) {
            e.printStackTrace();
            errorMsg = "Có lỗi xảy ra, vui lòng thử lại.";
        }

        if (errorMsg != null) {
            session.setAttribute("ERROR_MSG", errorMsg);
        }

        response.sendRedirect("inventory");
    }
}
