/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controllers;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;
import services.AdminService;

/**
 *
 * @author longd
 */
@WebServlet(name = "adminServlet", urlPatterns = {"/admin"})
public class AdminServlet extends HttpServlet {

    private AdminService adminSV = new AdminService();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet adminServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet adminServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String action = request.getParameter("action");
            if ("add".equals(action)) {
                request.setAttribute("Form", "add");
                request.setAttribute("Permission", adminSV.GetListPS());
            } else if ("detail".equals(action)) {
                request.setAttribute("Detail", "detail");
                int maNhom = Integer.parseInt(request.getParameter("MaNhom"));
                request.setAttribute("MaNhom", maNhom);
                request.setAttribute("Permission", adminSV.GetListPS());
                request.setAttribute("MaQuyen", adminSV.GetAllMaQuyen(maNhom));
                request.setAttribute("SLNV", adminSV.GetSLNV(maNhom));
            }else if("search".equals(action)){
                
            }
            request.setAttribute("LISTUG", adminSV.GetListUG());
            request.getRequestDispatcher("./views/admin/admin.jsp").forward(request, response);
        } catch (Exception e) {
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String action = request.getParameter("action");
            if ("add&save".equals(action)) {
                String tenNhom = request.getParameter("TenNhom");
                String[] quyenArr = request.getParameterValues("Quyen");
                List<Integer> listMaQuyen = new ArrayList<>();
                for (String quyen : quyenArr) {
                    listMaQuyen.add(Integer.parseInt(quyen));
                }
                String moTa = request.getParameter("MoTa");
                int checkAdd = adminSV.AddUG(tenNhom, listMaQuyen, moTa);
                if (checkAdd == 1) {
                    request.setAttribute("success", "Thêm nhóm người dùng thành công");
                } else if (checkAdd == 2) {
                    request.setAttribute("errorCheck", "Tên nhóm đã bị trùng");
                } else {
                    request.setAttribute("errorLog", "Hệ thống gặp sự cố, thêm thất bại");
                }
            }else if("update&save".equals(action)){
                String tenNhom = request.getParameter("TenNhom");
                boolean trangThai = Boolean.parseBoolean(request.getParameter("TrangThai"));
                String[] quyenArr = request.getParameterValues("Quyen");
                List<Integer> listMaQuyen = new ArrayList<>();
                for (String quyen : quyenArr) {
                    listMaQuyen.add(Integer.parseInt(quyen));
                }
                String moTa = request.getParameter("MoTa");
                String tenNhomGoc = request.getParameter("TenNhomGoc");
                int maNhom = Integer.parseInt(request.getParameter("MaNhom"));
                int checkUpdateUG = adminSV.EditUG(maNhom, tenNhom, trangThai, listMaQuyen, moTa, tenNhomGoc);
                if(checkUpdateUG == 1){
                    request.setAttribute("success", "Sửa nhóm người dùng thành công");
                }else if(checkUpdateUG == 2){
                    request.setAttribute("errorCheck", "Tên nhóm đã bị trùng");
                }else{
                    request.setAttribute("errorLog", "Hệ thống gặp sự cố, sửa thất bại");
                }
            }else if("delete".equals(action)){
                int maNhom = Integer.parseInt(request.getParameter("MaNhom"));
                int slnv = Integer.parseInt(request.getParameter("SoLuongNV"));
                int checkDeleteUG = adminSV.Delete(maNhom, slnv);
                if(checkDeleteUG == 1){
                    request.setAttribute("success", "Xóa nhóm người dùng thành công");
                }else if(checkDeleteUG == 2){
                    request.setAttribute("errorCheck", "Nhóm còn nhân viên, không thể xóa");
                }else{
                    request.setAttribute("errorLog", "Hệ thống gặp sự cố, xóa thất bại");
                }
            }
            request.setAttribute("LISTUG", adminSV.GetListUG());
            request.getRequestDispatcher("./views/admin/admin.jsp").forward(request, response);
        } catch (Exception e) {
        }

    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}
