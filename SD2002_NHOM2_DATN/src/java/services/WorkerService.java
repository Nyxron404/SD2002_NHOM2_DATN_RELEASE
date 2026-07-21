package services;

import dao.AssignmentTaskDAO;
import dao.TaskDAO;
import dao.SystemLogDAO; // Khai báo thêm DAO
import dao.AttendanceLogDAO; // Khai báo thêm DAO
import java.time.LocalDateTime;
import java.util.List;
import models.AssignmentTask;
import models.Task;
import java.net.InetAddress;
import java.net.UnknownHostException;

public class WorkerService {

    private TaskDAO taskDAO = new TaskDAO();
    private AssignmentTaskDAO assignmentDAO = new AssignmentTaskDAO();
    private AttendanceLogDAO attendanceLogDAO = new AttendanceLogDAO(); // Khởi tạo

    public List<Task> getAllTasks() {
        return taskDAO.getAllTasks();
    }

    private String getClientIpAddress() {
        try {
            return InetAddress.getLocalHost().getHostAddress();
        } catch (UnknownHostException e) {
            // Nếu không lấy được IP, trả về giá trị mặc định hoặc "127.0.0.1"
            return "Lỗi lấy IP";
        }
    }

    // Hàm tổng hợp 2 trong 1 (Tạo Task và Assignment)
    public boolean addTaskAndAssign(Task task) {
        int newMaCongViec = taskDAO.insertTaskAndGetId(task);
        if (newMaCongViec > 0) {
            AssignmentTask at = new AssignmentTask(
                    0,
                    newMaCongViec,
                    task.getNguoiPhuTrach(),
                    LocalDateTime.now(),
                    "Mới phân công"
            );
            return assignmentDAO.insertAssignmentTask(at);
        }
        return false;
    }

    public boolean completeTaskReport(int maCongViec, String ghiChuVatTu, String anhHienTruong, int maNguoiDung) {
        // 1. Cập nhật DB
        boolean success = taskDAO.submitTaskReport(maCongViec, ghiChuVatTu, anhHienTruong);

        if (success) {
            // 2. Ghi nhật ký hệ thống
            dao.SystemLogDAO.insertLog(maNguoiDung, "BÁO CÁO HOÀN THÀNH", "Task", getClientIpAddress());

            // 3. TỰ ĐỘNG CHẤM CÔNG (ĐÂY LÀ CHỖ QUAN TRỌNG)
            // Đảm bảo AttendanceLogDAO hoạt động đúng
            attendanceLogDAO.autoCalculateAttendance();
        }
        return success;
    }
}
