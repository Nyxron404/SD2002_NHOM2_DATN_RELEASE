package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import models.FarmingPractice;
import services.TechnicianService;

@WebServlet(name = "TechinicianServlet", urlPatterns = {"/technician"})
public class TechnicianServlet extends HttpServlet {

    private final TechnicianService farmingPracticeService = new TechnicianService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<FarmingPractice> list = farmingPracticeService.getAllFarmingPractices();
        request.setAttribute("farmingPracticeList", list);
        request.getRequestDispatcher("/views/technician/technician.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        String action = request.getParameter("action");
        
        if ("delete".equals(action)) {
            String idRaw = request.getParameter("id");
            if (idRaw != null) {
                try {
                    int id = Integer.parseInt(idRaw);
                    farmingPracticeService.deleteFarmingPractice(id);
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
                    farmingPracticeService.updateFarmingPractice(id, tenQuyTrinh, moTa, loaiApDung, trangThai);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
        else {
            String tenQuyTrinh = request.getParameter("processName");
            String moTa = request.getParameter("description");
            String loaiApDung = request.getParameter("loaiApDung");
            
            int nguoiTaoId = 11; 
            
            models.FarmingPractice fp = new models.FarmingPractice();
            fp.setTenQuyTrinh(tenQuyTrinh);
            fp.setMoTa(moTa);
            fp.setLoaiApDung(loaiApDung);
            fp.setNgayTao(java.time.LocalDate.now());
            fp.setNguoiTao(nguoiTaoId);
            
            farmingPracticeService.createFarmingPractice(fp);
        }
        
        response.sendRedirect(request.getContextPath() + "/technician");
    }
}