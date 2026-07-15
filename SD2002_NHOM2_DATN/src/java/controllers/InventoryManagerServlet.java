package controllers;

import java.io.IOException;
import java.time.LocalDateTime;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
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
                service.deleteSupplie(maVatTu);
            } catch (Exception e) { e.printStackTrace(); }
        }

        request.setAttribute("LIST_SUPPLIE", service.getAllSupplies());
        request.getRequestDispatcher("./views/inventoryManager/inventoryManager.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action"); // Nhận "add" hoặc "edit" từ form ẩn

        try {
            String tenVatTu = request.getParameter("tenVatTu");
            String loaiVatTu = request.getParameter("loaiVatTu");
            String donViTinh = request.getParameter("donViTinh");
            int soLuongTon = Integer.parseInt(request.getParameter("soLuongTon"));
            double donGia = Double.parseDouble(request.getParameter("donGia"));
            String moTa = request.getParameter("moTa");
            LocalDateTime ngayNhap = LocalDateTime.parse(request.getParameter("ngayNhapGanNhat"));
            boolean trangThai = Boolean.parseBoolean(request.getParameter("trangThai"));

            if ("add".equals(action)) {
                Supplie s = new Supplie(0, tenVatTu, loaiVatTu, donViTinh, soLuongTon, donGia, moTa, ngayNhap, trangThai);
                service.addSupplie(s);
            } else if ("edit".equals(action)) {
                int maVatTu = Integer.parseInt(request.getParameter("maVatTu"));
                Supplie s = new Supplie(maVatTu, tenVatTu, loaiVatTu, donViTinh, soLuongTon, donGia, moTa, ngayNhap, trangThai);
                service.updateSupplie(s);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("inventory");
    }
}
