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
import jakarta.servlet.http.HttpSession;
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

    private String getClientIpAddress(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        // Chuyển đổi IPv6 localhost sang IPv4 hiển thị gọn gàng hơn nếu cần
        if ("0:0:0:0:0:0:0:1".equals(ip) || "127.0.0.1".equals(ip)) {
            try {
                ip = java.net.InetAddress.getLocalHost().getHostAddress();
            } catch (Exception e) {
                ip = "127.0.0.1";
            }
        }
        return ip;
    }

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
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        Integer nguoiThucHien = (Integer) session.getAttribute("userId");
        if (nguoiThucHien == null) {
            nguoiThucHien = 1; // Giá trị dự phòng nếu session chưa lưu
        }

        // Hàm phụ lấy IP khách hàng để ghi log
        String clientIp = getClientIpAddress(request);

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
                    request.setAttribute("toastMessage", "Thêm nhân viên thành công! Tài khoản đã được tạo và gửi về email.");
                    request.setAttribute("toastType", "success");

                    // GHI SYSTEM LOG: THÊM NHÂN VIÊN
                    dao.SystemLogDAO.insertLog(nguoiThucHien, "THÊM NHÂN VIÊN MỚI: " + hoTen, "Staff", clientIp);

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
        } // LUỒNG 2: XỬ LÝ GÁN NHÓM (PHÂN QUYỀN)
        else if ("updateRole".equals(action)) {
            List<String> myPermissions = (List<String>) session.getAttribute("QuyenHan");
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

                    // GHI SYSTEM LOG: PHÂN QUYỀN / GÁN NHÓM
                    dao.SystemLogDAO.insertLog(nguoiThucHien, "PHÂN QUYỀN NHÂN VIÊN (Mã NV: " + maNhanVien + ", Nhóm: " + selectedGroupId + ")", "User", clientIp);

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

            // GHI SYSTEM LOG: SỬA NHÂN VIÊN
            dao.SystemLogDAO.insertLog(nguoiThucHien, "CẬP NHẬT THÔNG TIN NHÂN VIÊN (Mã NV: " + st.getMaNhanVien() + ")", "Staff", clientIp);

        } // LUỒNG 4: KHÓA/MỞ TÀI KHOẢN (TrangThai = false/true)
        else if ("lock".equals(action)) {
            int maNguoiDung = Integer.parseInt(request.getParameter("maNguoiDung"));
            boolean trangThai = Boolean.parseBoolean(request.getParameter("trangThai"));
            stDAO.UpdateStaffStatus(maNguoiDung, trangThai);

            request.setAttribute("toastMessage", trangThai ? "Mở khóa tài khoản thành công!" : "Khóa tài khoản thành công!");
            request.setAttribute("toastType", "success");

            // GHI SYSTEM LOG: KHÓA / MỞ TÀI KHOẢN
            String trangThaiText = trangThai ? "MỞ KHÓA" : "KHÓA";
            dao.SystemLogDAO.insertLog(nguoiThucHien, trangThaiText + " TÀI KHOẢN (Mã người dùng: " + maNguoiDung + ")", "User", clientIp);

        } // LUỒNG 5: XÓA NHÂN VIÊN VÀ TÀI KHOẢN
        else if ("delete".equals(action)) {
            int maNhanVien = Integer.parseInt(request.getParameter("maNhanVien"));
            int maNguoiDung = Integer.parseInt(request.getParameter("maNguoiDung"));

            boolean isDeleted = stDAO.DeleteStaff(maNhanVien, maNguoiDung);
            if (isDeleted) {
                request.setAttribute("toastMessage", "Đã xóa nhân viên và tài khoản!");
                request.setAttribute("toastType", "success");

                // GHI SYSTEM LOG: XÓA NHÂN VIÊN
                dao.SystemLogDAO.insertLog(nguoiThucHien, "XÓA NHÂN VIÊN VÀ TÀI KHOẢN (Mã NV: " + maNhanVien + ")", "Staff", clientIp);

            } else {
                request.setAttribute("toastMessage", "Lỗi: Không thể xóa (Có thể nhân viên này đang dính dữ liệu ở bảng khác)!");
                request.setAttribute("toastType", "error");
            }
        }

        request.setAttribute("LIST_GROUP", ugDAO.SelectUserGroups());
        request.setAttribute("LIST_STAFF", stDAO.SelectStaffAndGroup());
        request.setAttribute("LIST_USER", new UserDAO().SelectUser());
        request.getRequestDispatcher("./views/hrManager/hrManager.jsp").forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }

}
