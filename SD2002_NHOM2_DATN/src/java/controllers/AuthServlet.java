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
import services.AuthService;

/**
 *
 * @author longd
 */
@WebServlet(name = "authServlet", urlPatterns = {"/auth"})
public class AuthServlet extends HttpServlet {

    AuthService authSV = new AuthService();

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet authServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet authServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        //processRequest(request, response);

    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        //processRequest(request, response);
        String action = request.getParameter("action");
        if (action.equals("register")) {
            String TenDangKy = request.getParameter("TenDangKy");
            String Email = request.getParameter("EmailDangKy");
            String MatKhau = request.getParameter("MatKhau");
            int mess = authSV.Register(TenDangKy, Email, MatKhau);
            if (mess == 1) {
                
                request.setAttribute("success", "Đăng ký tài khoản thành công.");
            } else if (mess == 2) {
                request.setAttribute("errorEmail", "Email không có quyền đăng ký tài khoản.");
            } else if (mess == 3) {
                request.setAttribute("errorTenDangKy", "Tên đăng ký bị trùng.");
            } else if (mess == 4) {
                request.setAttribute("errorFormatTenDangKy", "Tên đăng ký không đúng định dạng.");
            } else if (mess == 5) {
                request.setAttribute("errorFormatMatKhau", "Mật khẩu không đúng định dạng và ít nhất phải có 8 kí tự.");
            } else {
                request.setAttribute("errorSystem", "Hệ thống gặp lỗi không thể đăng ký.");
            }
        }
        request.getRequestDispatcher("./views/auth/register.jsp").forward(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
