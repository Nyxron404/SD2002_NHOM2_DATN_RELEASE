package controllers;

import dao.FarmAreaDAO;
import dao.FarmingPracticeDAO;
import dao.SupplieDAO;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import models.FarmingPractice;
import services.TechnicianService;

@WebServlet(name = "TechnicianServlet", urlPatterns = {"/technician"})
public class TechnicianServlet extends HttpServlet {

    private final SupplieDAO supplieDAO = new SupplieDAO();
    private final FarmAreaDAO faDAO = new FarmAreaDAO();
    private final FarmingPracticeDAO fqDAO = new FarmingPracticeDAO();

    private final TechnicianService farmingPracticeService = new TechnicianService();

    List<FarmingPractice> list;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        String keyword = request.getParameter("keyword");

        // Xử lý Tìm kiếm
        if ("search".equals(action) && keyword != null && !keyword.trim().isEmpty()) {
            list = farmingPracticeService.searchFarmingPractices(keyword);
            request.setAttribute("keyword", keyword); // Giữ lại từ khóa trên ô input
        } else {
            list = farmingPracticeService.getAllFarmingPractices();
        }

        // Hứng thông báo (nếu có)
        HttpSession session = request.getSession();
        if (session.getAttribute("SUCCESS_MSG") != null) {
            request.setAttribute("SUCCESS_MSG", session.getAttribute("SUCCESS_MSG"));
            session.removeAttribute("SUCCESS_MSG");
        }
        if (session.getAttribute("ERROR_MSG") != null) {
            request.setAttribute("ERROR_MSG", session.getAttribute("ERROR_MSG"));
            session.removeAttribute("ERROR_MSG");
        }

        request.setAttribute("suppliesList", supplieDAO.SelectSupplie());
        request.setAttribute("farmAreaList", faDAO.getAllFarmAreas());
        request.setAttribute("workerList", fqDAO.WorkerList());
        request.setAttribute("farmingPracticeList", list);
        request.getRequestDispatcher("/views/technician/technician.jsp").forward(request, response);

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        // ===== Lưu giai đoạn / Ban hành quy trình =====
        if ("saveStage".equals(action) || "publishProcess".equals(action)) {
            FarmingPracticeDAO practiceDAO = new FarmingPracticeDAO();
            String practiceIdStr = request.getParameter("farmingPracticeId");

            if (practiceIdStr != null && !practiceIdStr.isEmpty()) {
                try {
                    int practiceId = Integer.parseInt(practiceIdStr);
                    String stageName = request.getParameter("stageName");
                    java.sql.Date startDay = java.sql.Date.valueOf(request.getParameter("startDay"));
                    java.sql.Date endDay = java.sql.Date.valueOf(request.getParameter("endDay"));
                    int maVatTu = Integer.parseInt(request.getParameter("maVatTu"));
                    double dinhLuong = Double.parseDouble(request.getParameter("quantity"));
                    String donVi = request.getParameter("unit");
                    String moTa = request.getParameter("description");

                    boolean ok = practiceDAO.saveFarmingStage(practiceId, stageName, startDay, endDay, maVatTu, dinhLuong, donVi, moTa);

                    if ("publishProcess".equals(action)) {
                        practiceDAO.publishProcess(practiceId);
                    }

                    session.setAttribute(ok ? "SUCCESS_MSG" : "ERROR_MSG",
                            ok ? "Lưu giai đoạn thành công!" : "Lưu giai đoạn thất bại.");
                } catch (Exception e) {
                    e.printStackTrace();
                    session.setAttribute("ERROR_MSG", "Lỗi lưu giai đoạn: " + e.getMessage());
                }
            } else {
                session.setAttribute("ERROR_MSG", "Thiếu farmingPracticeId.");
            }

            response.sendRedirect("technician");
            return;
        }

        // ===== Xóa quy trình =====
        if ("delete".equals(action)) {
            String idRaw = request.getParameter("id");
            if (idRaw != null) {
                try {
                    int id = Integer.parseInt(idRaw);
                    boolean ok = farmingPracticeService.deleteFarmingPractice(id);
                    session.setAttribute(ok ? "SUCCESS_MSG" : "ERROR_MSG",
                            ok ? "Xóa quy trình thành công!" : "Xóa quy trình thất bại.");
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }
            }

        // ===== Cập nhật quy trình =====
        } else if ("update".equals(action)) {
            String idRaw = request.getParameter("id");
            String tenQuyTrinh = request.getParameter("processName");
            String moTa = request.getParameter("description");
            String loaiApDung = request.getParameter("loaiApDung");
            String trangThai = request.getParameter("status");

            if (idRaw != null) {
                try {
                    int id = Integer.parseInt(idRaw);
                    boolean ok = farmingPracticeService.updateFarmingPractice(id, tenQuyTrinh, moTa, loaiApDung, trangThai);
                    session.setAttribute(ok ? "SUCCESS_MSG" : "ERROR_MSG",
                            ok ? "Cập nhật quy trình thành công!" : "Cập nhật quy trình thất bại.");
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }

        // ===== Tạo quy trình mới =====
        } else if ("create".equals(action)) {
            String tenQuyTrinh = request.getParameter("processName");
            String moTa = request.getParameter("description");
            String loaiApDung = request.getParameter("loaiApDung");

            Integer userId = (Integer) session.getAttribute("userId");

            models.FarmingPractice fp = new models.FarmingPractice();
            fp.setTenQuyTrinh(tenQuyTrinh);
            fp.setMoTa(moTa);
            fp.setLoaiApDung(loaiApDung);
            fp.setNgayTao(java.time.LocalDate.now());
            fp.setNguoiTao(userId);

            boolean ok = farmingPracticeService.createFarmingPractice(fp);
            session.setAttribute(ok ? "SUCCESS_MSG" : "ERROR_MSG",
                    ok ? "Tạo bộ quy chuẩn mới thành công!" : "Vui lòng nhập đầy đủ thông tin.");
        }

        // Chỉ redirect, không forward -> tránh lỗi "response đã commit"
        response.sendRedirect(request.getContextPath() + "/technician");
    }
}