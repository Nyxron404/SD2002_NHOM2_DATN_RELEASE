/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controllers;

import dao.StaffDAO;
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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("LIST_GROUP", ugDAO.SelectAllGroups());
        request.setAttribute("LIST_STAFF", stDAO.SelectStaffAndGroup());
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

                hrService.AddStaff(st);
            } catch (Exception e) {
                e.printStackTrace();
            }
        } // LUỒNG 2: XỬ LÝ GÁN NHÓM (CŨ/MỚI) VÀ SỬA QUYỀN
        else if ("updateRole".equals(action)) {
            List<String> myPermissions = (List<String>) request.getSession().getAttribute("QuyenHan");
            boolean isAdmin = myPermissions != null && myPermissions.contains("Admin");
            
            int maNhanVien = Integer.parseInt(request.getParameter("maNhanVien"));
            int maNguoiDung = Integer.parseInt(request.getParameter("maNguoiDung"));
            int selectedGroupId = Integer.parseInt(request.getParameter("selectedGroup")); 
            String[] permissions = request.getParameterValues("permissions"); 

            // --- BẢO MẬT: CHẶN HR SỬA NHÓM ADMIN (MÃ 1) ---
            if (selectedGroupId == 1 && !isAdmin) {
                // Bạn có thể thêm request.setAttribute("error", "Bạn không có quyền này!");
                // Rồi dừng lại không làm gì tiếp cả
            } else {
                // XỬ LÝ 1: TẠO NHÓM MỚI (CHỈ ADMIN MỚI ĐƯỢC TẠO NHÓM NẾU CẦN)
                if (selectedGroupId == -1) {
                    if (!isAdmin) {
                         // Nếu không phải Admin thì không được tạo nhóm mới
                    } else {
                         String newGroupName = request.getParameter("newGroupName");
                         selectedGroupId = ugDAO.InsertNewGroup(newGroupName, "Nhóm tạo tùy chỉnh");
                    }
                }
                
                // XỬ LÝ 2 & 3: GÁN NHÓM VÀ CẬP NHẬT QUYỀN
                if (selectedGroupId > 0) {
                    if (maNguoiDung == 0) {
                        stDAO.CreateDraftUser(maNhanVien, selectedGroupId);
                    } else {
                        stDAO.UpdateStaffGroup(maNguoiDung, selectedGroupId);
                    }
                    stDAO.UpdateGroupPermissions(selectedGroupId, permissions);
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
        } // LUỒNG 4: KHÓA TÀI KHOẢN (TrangThai = false)
        else if ("lock".equals(action)) {
            int maNguoiDung = Integer.parseInt(request.getParameter("maNguoiDung"));
            // Nhận giá trị true/false từ giao diện (true: mở, false: khóa)
            boolean trangThai = Boolean.parseBoolean(request.getParameter("trangThai"));
            stDAO.UpdateStaffStatus(maNguoiDung, trangThai);
        }

        request.setAttribute("LIST_GROUP", ugDAO.SelectAllGroups()); // Gửi danh sách Nhóm ra web
        request.setAttribute("LIST_STAFF", stDAO.SelectStaffAndGroup());
        request.getRequestDispatcher("./views/hrManager/hrManager.jsp").forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }

}
