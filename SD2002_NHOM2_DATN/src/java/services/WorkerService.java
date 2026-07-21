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
import models.AttendanceLog;

public class WorkerService {

    private TaskDAO taskDAO = new TaskDAO();
    private AssignmentTaskDAO assignmentDAO = new AssignmentTaskDAO();
    private AttendanceLogDAO attendanceLogDAO = new AttendanceLogDAO(); 

    public List<Task> getAllTasks() {
        return taskDAO.getAllTasks();
    }
    
    public List<AttendanceLog> getAllAttendance() {
        return attendanceLogDAO.getAttendance();
    }

    private String getClientIpAddress() {
        try {
            return InetAddress.getLocalHost().getHostAddress();
        } catch (UnknownHostException e) {
            return "Lỗi lấy IP";
        }
    }

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
        boolean success = taskDAO.submitTaskReport(maCongViec, ghiChuVatTu, anhHienTruong);

        if (success) {
            assignmentDAO.updateAssignmentStatus(maCongViec, "Hoàn thành");
            dao.SystemLogDAO.insertLog(maNguoiDung, "BÁO CÁO HOÀN THÀNH", "Task", getClientIpAddress());
            attendanceLogDAO.autoCalculateAttendance();
        }
        return success;
    }
}
