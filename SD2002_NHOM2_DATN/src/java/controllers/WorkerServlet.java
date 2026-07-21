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
import models.Task;
import services.WorkerService;

@WebServlet(name = "workerServlet", urlPatterns = {"/worker"})
public class WorkerServlet extends HttpServlet {

    private WorkerService workerService = new WorkerService();
    private AttendanceLogDAO attendanceDAO = new AttendanceLogDAO();
    private TaskDAO taskDAO = new TaskDAO();
    private FarmingPracticeDAO farmingPracticeDAO = new FarmingPracticeDAO();
    private FarmAreaDAO farmAreaDAO = new FarmAreaDAO();

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

        request.setAttribute("taskList", workerService.getAllTasks());
        request.setAttribute("workerList", taskDAO.getWorkers());
        request.setAttribute("farmAreaList", farmAreaDAO.getAllFarmAreas());
        request.setAttribute("farmingPracticeList", farmingPracticeDAO.getAllFarmingPractices());
        if (userId != null) {
            request.setAttribute("attendanceList", attendanceDAO.getAttendanceByUser(userId));
            request.setAttribute("currentUserId", userId); // Báo cho UI biết đang xem của ai
        }

        request.getRequestDispatcher("/views/worker/worker.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        // Trong WorkerServlet.java
        if ("report".equals(action)) {
            int maCongViec = Integer.parseInt(request.getParameter("maCongViec"));
            String ghiChu = request.getParameter("ghiChuVatTu");
            String anh = request.getParameter("chuoiAnhHienTruong");

            HttpSession session = request.getSession();
            Integer maNguoiDung = (Integer) session.getAttribute("userId");

            // Chỉ thực hiện khi có User hợp lệ
            if (maNguoiDung != null) {
                workerService.completeTaskReport(maCongViec, ghiChu, anh, maNguoiDung);
            }
        } else {
            String tenCongViec = request.getParameter("tenCongViec");
            String moTa = request.getParameter("moTa");
            int maQuyTrinh = Integer.parseInt(request.getParameter("maQuyTrinh"));
            int maKhuVuc = Integer.parseInt(request.getParameter("maKhuVuc"));
            int nguoiPhuTrach = Integer.parseInt(request.getParameter("nguoiPhuTrach"));
            LocalDate ngayBatDau = LocalDate.parse(request.getParameter("ngayBatDau"));
            LocalDate ngayKetThuc = LocalDate.parse(request.getParameter("ngayKetThuc"));

            Task newTask = new Task(0, tenCongViec, moTa, maQuyTrinh, maKhuVuc, nguoiPhuTrach, ngayBatDau, ngayKetThuc, "Chưa thực hiện");

            workerService.addTaskAndAssign(newTask);
        }
        response.sendRedirect("worker");
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}
