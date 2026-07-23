package controllers;

import dao.AttendanceLogDAO;
import dao.TaskDAO;
import dao.FarmingPracticeDAO;
import dao.FarmAreaDAO;
import java.io.IOException;
import java.time.LocalDate;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;
import models.Task;
import services.WorkerService;

@WebServlet(name = "workerServlet", urlPatterns = {"/worker"})
public class WorkerServlet extends HttpServlet {

    private WorkerService workerService = new WorkerService();
    private AttendanceLogDAO attendanceDAO = new AttendanceLogDAO();
    private TaskDAO taskDAO = new TaskDAO();
    private FarmingPracticeDAO farmingPracticeDAO = new FarmingPracticeDAO();
    private FarmAreaDAO farmAreaDAO = new FarmAreaDAO();

    @SuppressWarnings("unchecked")
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String testUserIdStr = request.getParameter("testUserId");
        Integer userId = null;
        if (testUserIdStr != null && !testUserIdStr.isEmpty()) {
            userId = Integer.parseInt(testUserIdStr);
            request.getSession().setAttribute("userId", userId);
        } else {
            userId = (Integer) request.getSession().getAttribute("userId");
        }

        List<String> quyenHan = (List<String>) request.getSession().getAttribute("QuyenHan");
        boolean isAdmin = quyenHan != null && quyenHan.contains("Admin");
        request.setAttribute("isAdmin", isAdmin);

        attendanceDAO.autoCalculateAttendance();

        // 1. Tham số lọc riêng cho Bảng Công Việc (Task)
        String taskFromStr = request.getParameter("taskFrom");
        String taskToStr = request.getParameter("taskTo");
        LocalDate taskFrom = (taskFromStr != null && !taskFromStr.isEmpty()) ? LocalDate.parse(taskFromStr) : null;
        LocalDate taskTo = (taskToStr != null && !taskToStr.isEmpty()) ? LocalDate.parse(taskToStr) : null;

        // 2. Tham số lọc riêng cho Bảng Ngày Công (AttendanceLog)
        String attFromStr = request.getParameter("attFrom");
        String attToStr = request.getParameter("attTo");
        LocalDate attFrom = (attFromStr != null && !attFromStr.isEmpty()) ? LocalDate.parse(attFromStr) : null;
        LocalDate attTo = (attToStr != null && !attToStr.isEmpty()) ? LocalDate.parse(attToStr) : null;

        // Xử lý dữ liệu cho Bảng Công Việc (Task)
        if (isAdmin) {
            String keyword = request.getParameter("keyword");
            if (keyword != null && !keyword.trim().isEmpty()) {
                List<Task> searchTasksResult = workerService.searchTasks(keyword);
                request.setAttribute("taskList", searchTasksResult);
            } else if (taskFrom != null && taskTo != null) {
                // Tùy chỉnh: nếu bạn muốn lọc theo Hạn chót (NgayKetThuc) hay Ngày bắt đầu thì dùng hàm tương ứng trong TaskDAO
                request.setAttribute("taskList", workerService.getTasksByDateRange(taskFrom, taskTo));
            } else {
                request.setAttribute("taskList", workerService.getAllTasks());
            }
        } else {
            int uid = (userId != null) ? userId : 0;
            if (taskFrom != null && taskTo != null) {
                request.setAttribute("taskList", workerService.getTasksByUserAndDateRange(uid, taskFrom, taskTo));
            } else {
                request.setAttribute("taskList", workerService.getTasksByUser(uid));
            }
        }

        // Xử lý dữ liệu cho Bảng Ngày Công (AttendanceLog)
        if (isAdmin) {
            String keyword = request.getParameter("keyword");
            if (keyword != null && !keyword.trim().isEmpty()) {
                List<Task> searchTasksResult = workerService.searchTasks(keyword);
                List<Integer> taskIds = new ArrayList<>();
                for (Task t : searchTasksResult) {
                    taskIds.add(t.getMaCongViec());
                }
                request.setAttribute("attendanceList", workerService.searchAttendanceByTaskIds(taskIds));
            } else if (attFrom != null && attTo != null) {
                request.setAttribute("attendanceList", workerService.getAttendanceByDateRange(attFrom, attTo));
            } else {
                request.setAttribute("attendanceList", workerService.getAllAttendance());
            }
        } else {
            int uid = (userId != null) ? userId : 0;
            if (attFrom != null && attTo != null) {
                request.setAttribute("attendanceList", workerService.getAttendanceByUserAndDateRange(uid, attFrom, attTo));
            } else {
                request.setAttribute("attendanceList", attendanceDAO.getAttendanceByUser(uid));
            }
        }

        request.setAttribute("currentUserId", userId);
        request.getRequestDispatcher("/views/worker/worker.jsp").forward(request, response);
    }

    @SuppressWarnings("unchecked")
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        Integer nguoiThucHien = (Integer) request.getSession().getAttribute("userId");
        List<String> quyenHan = (List<String>) request.getSession().getAttribute("QuyenHan");
        boolean isAdmin = quyenHan != null && quyenHan.contains("Admin");

        if ("report".equals(action)) {
            int maCongViec = Integer.parseInt(request.getParameter("maCongViec"));
            String ghiChu = request.getParameter("ghiChuVatTu");
            String anh = request.getParameter("chuoiAnhHienTruong");
            int nguoiPhuTrach = Integer.parseInt(request.getParameter("nguoiPhuTrach"));
            workerService.completeTaskReport(maCongViec, ghiChu, anh, nguoiPhuTrach);
        } else if ("cancel".equals(action)) {
            int maCongViec = Integer.parseInt(request.getParameter("maCongViec"));
            workerService.cancelTask(maCongViec, nguoiThucHien);
        } else if ("approve_salary".equals(action)) {
            if (isAdmin) {
                int maChamCong = Integer.parseInt(request.getParameter("maChamCong"));
                workerService.approveSalaryLog(maChamCong, nguoiThucHien);
            }
        } else if ("report_error".equals(action)) {
            int maChamCong = Integer.parseInt(request.getParameter("maChamCong"));
            String lyDo = request.getParameter("lyDo");
            workerService.reportAttendanceErrorLog(maChamCong, lyDo, nguoiThucHien);
            request.getSession().setAttribute("thongBao", "Đã gửi báo cáo sai sót cho Quản lý thành công!");
            String reported = (String) request.getSession().getAttribute("reportedErrors");
            if (reported == null) {
                reported = ",";
            }
            reported += maChamCong + ",";
            request.getSession().setAttribute("reportedErrors", reported);
        } else if (isAdmin) {
            String tenCongViec = request.getParameter("tenCongViec");
            String moTa = request.getParameter("moTa");
            int maQuyTrinh = Integer.parseInt(request.getParameter("maQuyTrinh"));
            int maKhuVuc = Integer.parseInt(request.getParameter("maKhuVuc"));
            int nguoiPhuTrach = Integer.parseInt(request.getParameter("nguoiPhuTrach"));
            LocalDate ngayBatDau = LocalDate.parse(request.getParameter("ngayBatDau"));
            LocalDate ngayKetThuc = LocalDate.parse(request.getParameter("ngayKetThuc"));
            Task newTask = new Task(0, tenCongViec, moTa, maQuyTrinh, maKhuVuc, nguoiPhuTrach, ngayBatDau, ngayKetThuc, "Chưa thực hiện");
            workerService.addTaskAndAssign(newTask, nguoiThucHien);
        }
        response.sendRedirect("worker");
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}