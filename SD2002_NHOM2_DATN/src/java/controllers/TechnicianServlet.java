package controllers;

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

    private final TechnicianService farmingPracticeService = new TechnicianService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        String action = request.getParameter("action");
        String keyword = request.getParameter("keyword");
        List<FarmingPractice> list;
        
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

        request.setAttribute("farmingPracticeList", list);
        request.getRequestDispatcher("/views/technician/technician.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        
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
        }
        else if ("update".equals(action)) {
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
        }
        else if ("create".equals(action)) { // Bắt chính xác chữ create từ Form
            String tenQuyTrinh = request.getParameter("processName");
            String moTa = request.getParameter("description");
            String loaiApDung = request.getParameter("loaiApDung");
            
            int nguoiTaoId = 11; // Chú ý: Sau này đổi lấy từ Session khi ghép đăng nhập
            
            models.FarmingPractice fp = new models.FarmingPractice();
            fp.setTenQuyTrinh(tenQuyTrinh);
            fp.setMoTa(moTa);
            fp.setLoaiApDung(loaiApDung);
            fp.setNgayTao(java.time.LocalDate.now());
            fp.setNguoiTao(nguoiTaoId);
            
            boolean ok = farmingPracticeService.createFarmingPractice(fp);
            session.setAttribute(ok ? "SUCCESS_MSG" : "ERROR_MSG", 
                    ok ? "Tạo bộ quy chuẩn mới thành công!" : "Vui lòng nhập đầy đủ thông tin.");
        }
        
        response.sendRedirect(request.getContextPath() + "/technician");
    }
}