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

@WebServlet(name = "authServlet", urlPatterns = {"/auth"})
public class AuthServlet extends HttpServlet {

    private AuthService authSV = new AuthService();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
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
            
        } else if(action.equals("login")){
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
                    session.setAttribute("userId", authSV.GetMaNguoiDung(tenDangNhap));
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
            } else {
                request.setAttribute("errorLogin", "Tên đăng nhập hoặc mật khẩu sai.");
                request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
            }
            
        } else if(action.equals("logout")){
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
            
        } 
        else if (action.equals("forgotPassword")) {
            String tenDangNhap = request.getParameter("TenDangNhap");
            String email = request.getParameter("Email");
            
            int userId = authSV.checkUserEmailMatch(tenDangNhap, email);
            if(userId > 0) {
                String otp = authSV.generateAndSendOTP(email);
                HttpSession session = request.getSession();
                session.setAttribute("reset_otp", otp);
                session.setAttribute("reset_userId", userId);
                
                request.setAttribute("step", 2); 
            } else {
                request.setAttribute("errorSystem", "Tên đăng nhập hoặc email không tồn tại / không khớp.");
                request.setAttribute("step", 1);
            }
            request.getRequestDispatcher("/views/auth/forgot.jsp").forward(request, response);
            
        } else if (action.equals("resetPassword")) {
            String inputOtp = request.getParameter("otp1") + request.getParameter("otp2") + request.getParameter("otp3") + 
                              request.getParameter("otp4") + request.getParameter("otp5") + request.getParameter("otp6");
            String newPassword = request.getParameter("newPassword");
            
            HttpSession session = request.getSession();
            String realOtp = (String) session.getAttribute("reset_otp");
            Integer userId = (Integer) session.getAttribute("reset_userId");
            
            // So sánh OTP
            if (realOtp != null && realOtp.equals(inputOtp)) {
                if(authSV.CheckFormatMatKhau(newPassword) == 1) {
                    authSV.updatePassword(userId, newPassword);
                    
                    // Xóa các session bảo mật
                    session.removeAttribute("reset_otp");
                    session.removeAttribute("reset_userId");
                    
                    request.setAttribute("success", "Đổi mật khẩu thành công. Vui lòng đăng nhập lại.");
                    request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
                } else {
                    request.setAttribute("errorSystem", "Mật khẩu không đúng định dạng (ít nhất 8 kí tự).");
                    request.setAttribute("step", 2);
                    request.getRequestDispatcher("/views/auth/forgot.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("errorSystem", "Mã OTP không chính xác.");
                request.setAttribute("step", 2);
                request.getRequestDispatcher("/views/auth/forgot.jsp").forward(request, response);
            }
        }
    }

    @Override
    public String getServletInfo() {
        return "Auth Controller handling Login, Register and Forgot Password";
    }
}