package controllers;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.DetailedWarehouseSlip;
import services.WarehouseSlipService;

/**
 * Servlet xử lý lập phiếu Nhập kho / Xuất kho.
 * Form gửi lên nhiều dòng vật tư cùng lúc dưới dạng mảng tham số:
 *   maVatTu[], soLuong[], donGia[]  (cùng độ dài, cùng chỉ số ứng với 1 dòng)
 *
 * LƯU Ý: servlet lấy mã nhân viên đang đăng nhập từ session attribute "MaNhanVien".
 * Nếu hệ thống đăng nhập của bạn dùng tên attribute khác (vd "staff", "currentUser"...),
 * hãy đổi lại dòng lấy session bên dưới cho khớp.
 *
 * @author Hoang Anh
 */
@WebServlet(name = "warehouseSlipServlet", urlPatterns = {"/warehouseSlip"})
public class WarehouseSlipServlet extends HttpServlet {

    private final WarehouseSlipService service = new WarehouseSlipService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        String action = request.getParameter("action"); // "import" (Nhập kho) hoặc "export" (Xuất kho)
        String ghiChu = request.getParameter("ghiChu");

        // TODO: đổi "MaNhanVien" cho khớp với tên session attribute mà chức năng đăng nhập của bạn đang dùng.
        Integer nguoiLap = (Integer) session.getAttribute("MaNhanVien");
        if (nguoiLap == null) {
            session.setAttribute("ERROR_MSG", "Không xác định được nhân viên lập phiếu, vui lòng đăng nhập lại.");
            response.sendRedirect("inventory");
            return;
        }

        String errorMsg;
        try {
            List<DetailedWarehouseSlip> chiTietList = parseChiTietList(request);

            if ("import".equals(action)) {
                errorMsg = service.createImportSlip(nguoiLap, ghiChu, chiTietList);
            } else if ("export".equals(action)) {
                errorMsg = service.createExportSlip(nguoiLap, ghiChu, chiTietList);
            } else {
                errorMsg = "Hành động không hợp lệ.";
            }
        } catch (Exception e) {
            e.printStackTrace();
            errorMsg = "Dữ liệu phiếu không hợp lệ, vui lòng kiểm tra lại các dòng vật tư.";
        }

        if (errorMsg == null) {
            String successMsg = "import".equals(action)
                    ? "Lập phiếu nhập kho thành công!"
                    : "Lập phiếu xuất kho thành công!";
            session.setAttribute("SUCCESS_MSG", successMsg);
        } else {
            session.setAttribute("ERROR_MSG", errorMsg);
        }

        response.sendRedirect("inventory");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("inventory");
    }

    /**
     * Gom các mảng tham số maVatTu[] / soLuong[] / donGia[] thành danh sách DetailedWarehouseSlip.
     * Bỏ qua dòng trống (chưa chọn vật tư) để người dùng không bắt buộc phải xóa dòng thừa trên form.
     */
    private List<DetailedWarehouseSlip> parseChiTietList(HttpServletRequest request) {
        String[] maVatTuArr = request.getParameterValues("maVatTu[]");
        String[] soLuongArr = request.getParameterValues("soLuong[]");
        String[] donGiaArr = request.getParameterValues("donGia[]");

        List<DetailedWarehouseSlip> list = new ArrayList<>();
        if (maVatTuArr == null) {
            return list;
        }

        for (int i = 0; i < maVatTuArr.length; i++) {
            String maVatTuStr = maVatTuArr[i];
            if (maVatTuStr == null || maVatTuStr.trim().isEmpty()) {
                continue; // dòng chưa chọn vật tư -> bỏ qua
            }
            int maVatTu = Integer.parseInt(maVatTuStr.trim());
            int soLuong = Integer.parseInt(soLuongArr[i].trim());
            double donGia = Double.parseDouble(donGiaArr[i].trim());

            list.add(new DetailedWarehouseSlip(0, 0, maVatTu, soLuong, donGia, 0));
        }
        return list;
    }
}
