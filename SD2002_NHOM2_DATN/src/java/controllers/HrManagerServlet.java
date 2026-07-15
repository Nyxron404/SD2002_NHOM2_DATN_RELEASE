/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controllers;

import dao.StaffDAO;
import dao.UserDAO;
import dao.UserGroupDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.time.LocalDate;
import java.util.List;
import models.Staff;
import services.HrManagerService;

/**
 *
 * @author longd
 */
@WebServlet(name = "hrManagerServlet", urlPatterns = {"/hr"})
public class HrManagerServlet extends HttpServlet {

    private HrManagerService hrService = new HrManagerService();
    private StaffDAO stDAO = new StaffDAO();
    private UserGroupDAO ugDAO = new UserGroupDAO();
    private UserDAO usDAO = new UserDAO();

    @Override
protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    
    String keyword = request.getParameter("keyword");
    if (keyword != null && !keyword.trim().isEmpty()) {
        request.setAttribute("LIST_STAFF", stDAO.SearchStaff(keyword));
    } else {
        request.setAttribute("LIST_STAFF", stDAO.SelectStaffAndGroup());
    }
    
    request.setAttribute("LIST_GROUP", ugDAO.SelectUserGroups());
    request.setAttribute("LIST_USER", usDAO.SelectUser());
    request.getRequestDispatcher("./views/hrManager/hrManager.jsp").forward(request, response);
}
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        // LUỒNG 1: THÊM NHÂN VIÊN
        if ("add".equals(action)) {
            try {
                String hoTen = request.getParameter("hoTen");
                LocalDate ngaySinh = LocalDate.parse(request.getParameter("ngaySinh"));
                boolean gioiTinh = "1".equals(request.getParameter("gioiTinh"));
                String sdt = request.getParameter("sdt");
                String email = request.getParameter("email");
                String diaChi = request.getParameter("diaChi");
                double luong = Double.parseDouble(request.getParameter("luong"));

                Staff st = new Staff();
                st.setHoTen(hoTen);
                st.setNgaySinh(ngaySinh);
                st.setGioiTinh(gioiTinh);
                st.setSDT(sdt);
                st.setEmail(email);
                st.setDiaChi(diaChi);
                st.setLuong(luong);
                st.setDangKy(false);

                // HỨNG KẾT QUẢ TỪ SERVICE TRẢ VỀ
                int result = hrService.AddStaff(st);
                if (result == 1) {
                    // Chỉ hiển thị thông báo, vì Service đã lo phần tạo tài khoản và gửi email rồi
                    request.setAttribute("toastMessage", "Thêm nhân viên thành công! Tài khoản đã được tạo và gửi về email.");
                    request.setAttribute("toastType", "success");
                } else if (result == 2) {
                    request.setAttribute("toastMessage", "Lỗi: Số điện thoại không hợp lệ (Phải có 10 số và bắt đầu bằng số 0)!");
                    request.setAttribute("toastType", "error");
                } else if (result == 3) {
                    request.setAttribute("toastMessage", "Lỗi: Email không đúng định dạng!");
                    request.setAttribute("toastType", "error");
                } else if (result == 4) {
                    request.setAttribute("toastMessage", "Lỗi: Email này đã được sử dụng!");
                    request.setAttribute("toastType", "error");
                } else if (result == 5) {
                    request.setAttribute("toastMessage", "Lỗi: Số điện thoại này đã được sử dụng!");
                    request.setAttribute("toastType", "error");
                } else {
                    request.setAttribute("toastMessage", "Lỗi CSDL: Kiểm tra lại log NetBeans để biết chi tiết!");
                    request.setAttribute("toastType", "error");
                }

            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("toastMessage", "Lỗi: Vui lòng điền đầy đủ và đúng định dạng các trường!");
                request.setAttribute("toastType", "error");
            }
        } // LUỒNG 2: XỬ LÝ GÁN NHÓM
        else if ("updateRole".equals(action)) {
            List<String> myPermissions = (List<String>) request.getSession().getAttribute("QuyenHan");
            boolean isAdmin = myPermissions != null && myPermissions.contains("Admin");

            int maNhanVien = Integer.parseInt(request.getParameter("maNhanVien"));
            int maNguoiDung = Integer.parseInt(request.getParameter("maNguoiDung"));
            int selectedGroupId = Integer.parseInt(request.getParameter("selectedGroup"));

            // --- BẢO MẬT: CHẶN HR GÁN TÀI KHOẢN VÀO NHÓM ADMIN (MÃ 1) ---
            if (selectedGroupId == 1 && !isAdmin) {
                request.setAttribute("toastMessage", "Lỗi: Bạn không có quyền gán nhân viên thành Admin!");
                request.setAttribute("toastType", "error");
            } else {
                // CHỈ GÁN NHÓM VÀO TÀI KHOẢN
                if (selectedGroupId > 0) {
                    if (maNguoiDung == 0) {
                        stDAO.CreateDraftUser(maNhanVien, selectedGroupId); // Tạo nháp nếu chưa có tài khoản
                    } else {
                        stDAO.UpdateStaffGroup(maNguoiDung, selectedGroupId); // Đổi nhóm nếu đã có tài khoản
                    }
                    request.setAttribute("toastMessage", "Gán chức vụ thành công!");
                    request.setAttribute("toastType", "success");
                } else {
                    request.setAttribute("toastMessage", "Lỗi: Không thể gán nhóm!");
                    request.setAttribute("toastType", "error");
                }
            }
        } // LUỒNG 3: SỬA THÔNG TIN
        else if ("edit".equals(action)) {
            Staff st = new Staff();
            st.setMaNhanVien(Integer.parseInt(request.getParameter("maNhanVien")));
            st.setHoTen(request.getParameter("hoTen"));
            st.setNgaySinh(LocalDate.parse(request.getParameter("ngaySinh")));
            st.setGioiTinh("1".equals(request.getParameter("gioiTinh")));
            st.setSDT(request.getParameter("sdt"));
            st.setEmail(request.getParameter("email"));
            st.setDiaChi(request.getParameter("diaChi"));
            st.setLuong(Double.parseDouble(request.getParameter("luong")));
            stDAO.UpdateStaff(st);
            request.setAttribute("toastMessage", "Cập nhật thông tin thành công!");
            request.setAttribute("toastType", "success");
        } // LUỒNG 4: KHÓA TÀI KHOẢN (TrangThai = false)
        else if ("lock".equals(action)) {
            int maNguoiDung = Integer.parseInt(request.getParameter("maNguoiDung"));
            // Nhận giá trị true/false từ giao diện (true: mở, false: khóa)
            boolean trangThai = Boolean.parseBoolean(request.getParameter("trangThai"));
            stDAO.UpdateStaffStatus(maNguoiDung, trangThai);
        } // LUỒNG 5: XÓA NHÂN VIÊN VÀ TÀI KHOẢN
        else if ("delete".equals(action)) {
            int maNhanVien = Integer.parseInt(request.getParameter("maNhanVien"));
            int maNguoiDung = Integer.parseInt(request.getParameter("maNguoiDung"));

            boolean isDeleted = stDAO.DeleteStaff(maNhanVien, maNguoiDung);
            if (isDeleted) {
                request.setAttribute("toastMessage", "Đã xóa nhân viên và tài khoản!");
                request.setAttribute("toastType", "success");
            } else {
                request.setAttribute("toastMessage", "Lỗi: Không thể xóa (Có thể nhân viên này đang dính dữ liệu ở bảng khác)!");
                request.setAttribute("toastType", "error");
            }
        }

        request.setAttribute("LIST_GROUP", ugDAO.SelectUserGroups()); // Gửi danh sách Nhóm ra web
        request.setAttribute("LIST_STAFF", stDAO.SelectStaffAndGroup());
        request.setAttribute("LIST_USER", new UserDAO().SelectUser());
        request.getRequestDispatcher("./views/hrManager/hrManager.jsp").forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }

}
