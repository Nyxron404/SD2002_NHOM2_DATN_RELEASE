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
        String action = request.getParameter("action");
        if ("add".equals(action)) {
            request.setAttribute("Form", "add");
            request.setAttribute("Permission", adminSV.GetListPS());
        }
        request.setAttribute("LISTUG", adminSV.GetListUG());
        request.getRequestDispatcher("./views/admin/admin.jsp").forward(request, response);
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
                if(checkAdd == 1){
                    request.setAttribute("success", "Thêm nhóm người dùng thành công");
                }else if(checkAdd == 2){
                    request.setAttribute("errorName", "Tên nhóm đã bị trùng");
                }else{
                    request.setAttribute("errorLog", "Hệ thống gặp sự cố, thêm thất bại");
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
