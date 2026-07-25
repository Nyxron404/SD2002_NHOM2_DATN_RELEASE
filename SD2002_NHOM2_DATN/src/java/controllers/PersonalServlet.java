package controllers;

import dao.StaffDAO;
import dao.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Staff;
import models.User;

@WebServlet(name = "PersonalServlet", urlPatterns = {"/personal"})
public class PersonalServlet extends HttpServlet {

    private StaffDAO staffDAO = new StaffDAO();
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/auth");
            return;
        }

        // Lấy thông tin cá nhân và tài khoản
        Staff staffInfo = staffDAO.GetStaffByUserId(userId);
        User userInfo = userDAO.GetUserById(userId);

        request.setAttribute("staffInfo", staffInfo);
        request.setAttribute("userInfo", userInfo);
        
        // Nhận thông báo từ session (nếu có sau khi đổi mật khẩu)
        if (session.getAttribute("toastMessage") != null) {
            request.setAttribute("toastMessage", session.getAttribute("toastMessage"));
            request.setAttribute("toastType", session.getAttribute("toastType"));
            session.removeAttribute("toastMessage");
            session.removeAttribute("toastType");
        }

        request.getRequestDispatcher("/views/personal/personal.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        if ("changePassword".equals(action)) {
            String oldPassword = request.getParameter("oldPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            User u = userDAO.GetUserById(userId);
            
            // Kiểm tra mật khẩu cũ
            if (u != null && u.getMatKhau().equals(oldPassword)) {
                // Kiểm tra xác nhận mật khẩu mới
                if (newPassword != null && newPassword.equals(confirmPassword)) {
                    boolean success = userDAO.UpdatePassword(userId, newPassword);
                    if (success) {
                        session.setAttribute("toastMessage", "Đổi mật khẩu thành công!");
                        session.setAttribute("toastType", "success");
                    } else {
                        session.setAttribute("toastMessage", "Lỗi hệ thống, không thể đổi mật khẩu.");
                        session.setAttribute("toastType", "error");
                    }
                } else {
                    session.setAttribute("toastMessage", "Mật khẩu xác nhận không trùng khớp!");
                    session.setAttribute("toastType", "error");
                }
            } else {
                session.setAttribute("toastMessage", "Mật khẩu cũ không chính xác!");
                session.setAttribute("toastType", "error");
            }
            
            response.sendRedirect(request.getContextPath() + "/personal");
        }
    }

    @Override
    public String getServletInfo() {
        return "Personal Page Controller";
    }
}