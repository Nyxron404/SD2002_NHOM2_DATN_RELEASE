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

        // Xác định quyền hạn: Admin xem được toàn bộ, Công nhân chỉ xem của riêng mình
        List<String> quyenHan = (List<String>) request.getSession().getAttribute("QuyenHan");
        boolean isAdmin = quyenHan != null && quyenHan.contains("Admin");
        request.setAttribute("isAdmin", isAdmin);

        attendanceDAO.autoCalculateAttendance();

        if (isAdmin) {
            // ================= GIAO DIỆN ADMIN: xem toàn bộ + có tìm kiếm =================
            String keyword = request.getParameter("keyword");
            if (keyword != null && !keyword.trim().isEmpty()) {

                List<Task> searchTasksResult = workerService.searchTasks(keyword);
                request.setAttribute("taskList", searchTasksResult);

                List<Integer> taskIds = new ArrayList<>();
                for (Task t : searchTasksResult) {
                    taskIds.add(t.getMaCongViec());
                }

                request.setAttribute("attendanceList", workerService.searchAttendanceByTaskIds(taskIds));

            } else {
                request.setAttribute("taskList", workerService.getAllTasks());
                request.setAttribute("attendanceList", workerService.getAllAttendance());
            }
            request.setAttribute("workerList", taskDAO.getWorkers());
            request.setAttribute("farmAreaList", farmAreaDAO.getAllFarmAreas());
            request.setAttribute("farmingPracticeList", farmingPracticeDAO.getAllFarmingPractices());

        } else {
            int uid = (userId != null) ? userId : 0;
            request.setAttribute("taskList", workerService.getTasksByUser(uid));
            request.setAttribute("attendanceList", attendanceDAO.getAttendanceByUser(uid));
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

        // Lấy id người đang thao tác (quản lý/admin) để ghi log cho đúng người thực hiện
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
            // Chỉ Admin được chốt lương; Công nhân không được tự chốt lương của bản thân
            if (isAdmin) {
                int maChamCong = Integer.parseInt(request.getParameter("maChamCong"));
                // Gọi qua Service để nó tự động xử lý lấy IP LAN và ghi log
                workerService.approveSalaryLog(maChamCong, nguoiThucHien);
            }

        } else if ("report_error".equals(action)) {
            // Nhận dữ liệu từ form
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
            // Chỉ Admin được phân công việc mới; Công nhân không có chức năng này
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