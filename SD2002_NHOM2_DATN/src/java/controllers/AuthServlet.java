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
import jakarta.servlet.http.HttpSession;
import java.util.List;
import services.AuthService;

/**
 *
 * @author longd
 */
@WebServlet(name = "authServlet", urlPatterns = {"/auth"})
public class AuthServlet extends HttpServlet {

    private AuthService authSV = new AuthService();

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
            String tenDangKy = request.getParameter("TenDangKy");
            String email = request.getParameter("EmailDangKy");
            String matKhau = request.getParameter("MatKhau");
            int mess = authSV.Register(tenDangKy, email, matKhau);
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
            request.getRequestDispatcher("./views/auth/register.jsp").forward(request, response);
        }else if(action.equals("login")){
            String tenDangNhap = request.getParameter("TenDangNhap");
            String matKhau = request.getParameter("MatKhau");
            int checkLogin = authSV.CheckLogin(tenDangNhap, matKhau);
            if(checkLogin == 1){
                List<String> quyenHan = authSV.Login(tenDangNhap, matKhau);
                if(!quyenHan.isEmpty()){
                    HttpSession session = request.getSession();
                    session.setAttribute("QuyenHan", quyenHan);
                    session.setAttribute("TenDangNhap", tenDangNhap);
                    session.setAttribute("MaNhanVien", authSV.GetMaNhanVien(tenDangNhap));
                    String truyCap = quyenHan.get(0);
                    switch (truyCap) {
                        case "Admin":
                            response.sendRedirect(request.getContextPath()+"/admin");
                            break;
                        case "FarmOwner":
                            response.sendRedirect(request.getContextPath()+"/farmowner");
                            break;
                        case "HrManager":
                            response.sendRedirect(request.getContextPath()+"/hr");
                            break;
                        case "InventoryManager":
                            response.sendRedirect(request.getContextPath()+"/inventory");
                            break;
                        case "EquipmentManager":
                            response.sendRedirect(request.getContextPath()+"/equipment");
                            break;
                        case "Technician":
                            response.sendRedirect(request.getContextPath()+"/technician");
                            break;
                        case "Worker":
                            response.sendRedirect(request.getContextPath()+"/worker");
                            break;
                        default:
                            response.sendRedirect(request.getContextPath()+"/auth");
                    }
                    return;
                }
            }else{
                request.setAttribute("errorLogin", "Tên đăng nhập hoặc mất khẩu sai.");
                request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
            }
        }else if(action.equals("logout")){
            HttpSession session = request.getSession(false);
            session.invalidate();
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
        }
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
