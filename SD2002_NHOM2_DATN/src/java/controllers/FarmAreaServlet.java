package controllers;

import dao.FarmAreaDAO;
import models.FarmArea;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "FarmAreaServlet", urlPatterns = {"/farmarea"})
public class FarmAreaServlet extends HttpServlet {

    private FarmAreaDAO faDAO = new FarmAreaDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Đẩy danh sách khu vực ra JSP
        request.setAttribute("LIST_FARM_AREA", faDAO.getAllFarmAreas());
        
        // Điều hướng tới file jsp (đường dẫn tùy theo thư mục của bạn, ở đây giả định là views/farmArea/)
        request.getRequestDispatcher("/views/farmArea/farmArea.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        
        try {
            String tenKhuVuc = request.getParameter("tenKhuVuc");
            String loaiKhuVuc = request.getParameter("loaiKhuVuc");
            double dienTich = Double.parseDouble(request.getParameter("dienTich"));
            String moTa = request.getParameter("moTa");

            if ("add".equals(action)) {
                FarmArea fa = new FarmArea(0, tenKhuVuc, loaiKhuVuc, dienTich, moTa);
                faDAO.insertFarmArea(fa);
            } else if ("update".equals(action)) {
                int maKhuVuc = Integer.parseInt(request.getParameter("maKhuVuc"));
                FarmArea fa = new FarmArea(maKhuVuc, tenKhuVuc, loaiKhuVuc, dienTich, moTa);
                faDAO.updateFarmArea(fa);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        // Redirect lại để load danh sách mới nhất
        response.sendRedirect(request.getContextPath() + "/farmarea");
    }

    @Override
    public String getServletInfo() {
        return "Farm Area Controller";
    }
}