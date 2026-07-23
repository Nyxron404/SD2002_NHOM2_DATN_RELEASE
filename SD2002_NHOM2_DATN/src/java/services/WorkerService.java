package services;

import dao.AssignmentTaskDAO;
import dao.TaskDAO;
import dao.SystemLogDAO;
import dao.AttendanceLogDAO;
import java.time.LocalDateTime;
import java.util.List;
import models.AssignmentTask;
import models.Task;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.time.LocalDate;
import models.AttendanceLog;

public class WorkerService {

    private TaskDAO taskDAO = new TaskDAO();
    private AssignmentTaskDAO assignmentDAO = new AssignmentTaskDAO();
    private AttendanceLogDAO attendanceLogDAO = new AttendanceLogDAO(); 

    public List<Task> getAllTasks() {
        return taskDAO.getAllTasks();
    }
    
    public List<Task> searchTasks(String keyword) {
        return taskDAO.searchTasks(keyword);
    }
    
    public List<Task> getTasksByUser(int maNguoiDung) {
        return taskDAO.getTasksByUser(maNguoiDung);
    }
    
    public List<Task> getTasksByDateRange(LocalDate fromDate, LocalDate toDate) {
        return taskDAO.getTasksByDateRange(fromDate, toDate);
    }

    public List<Task> getTasksByUserAndDateRange(int maNguoiDung, LocalDate fromDate, LocalDate toDate) {
        return taskDAO.getTasksByUserAndDateRange(maNguoiDung, fromDate, toDate);
    }
    
    public List<AttendanceLog> getAllAttendance() {
        return attendanceLogDAO.getAttendance();
    }
    
    public List<AttendanceLog> getAttendanceByUser(int maNguoiDung) {
        return attendanceLogDAO.getAttendanceByUser(maNguoiDung);
    }
    
    public List<AttendanceLog> searchAttendanceByTaskIds(List<Integer> taskIds) {
        return attendanceLogDAO.searchAttendanceByTaskIds(taskIds);
    }
    
    public List<AttendanceLog> getAttendanceByDateRange(LocalDate fromDate, LocalDate toDate) {
        return attendanceLogDAO.getAttendanceByDateRange(fromDate, toDate);
    }

    public List<AttendanceLog> getAttendanceByUserAndDateRange(int maNguoiDung, LocalDate fromDate, LocalDate toDate) {
        return attendanceLogDAO.getAttendanceByUserAndDateRange(maNguoiDung, fromDate, toDate);
    }

    private String getClientIpAddress() {
        try {
            return InetAddress.getLocalHost().getHostAddress();
        } catch (UnknownHostException e) {
            return "Lỗi lấy IP";
        }
    }

    public boolean addTaskAndAssign(Task task, int nguoiThucHien) {
        int newMaCongViec = taskDAO.insertTaskAndGetId(task);
        if (newMaCongViec > 0) {
            AssignmentTask at = new AssignmentTask(
                    0,
                    newMaCongViec,
                    task.getNguoiPhuTrach(),
                    LocalDateTime.now(),
                    "Mới phân công"
            );
            boolean success = assignmentDAO.insertAssignmentTask(at);
            if (success) {
                dao.SystemLogDAO.insertLog(nguoiThucHien, "PHÂN CÔNG CÔNG VIỆC MỚI (Mã việc: " + newMaCongViec + ")", "Task", getClientIpAddress());
            }
            return success;
        }
        return false;
    }

    public boolean cancelTask(int maCongViec, int nguoiThucHien) {
        boolean success = taskDAO.updateTaskStatus(maCongViec, "Đã hủy");
        if (success) {
            assignmentDAO.updateAssignmentStatus(maCongViec, "Đã hủy");
            dao.SystemLogDAO.insertLog(nguoiThucHien, "HỦY VIỆC (Mã việc: " + maCongViec + ")", "Task", getClientIpAddress());
        }
        return success;
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
    
    public boolean approveSalaryLog(int maChamCong, int nguoiThucHien) {
        boolean success = attendanceLogDAO.approveSalary(maChamCong);
        if (success) {
            dao.SystemLogDAO.insertLog(nguoiThucHien, "CHỐT LƯƠNG (Mã chấm công: " + maChamCong + ")", "AttendanceLog", getClientIpAddress());
        }
        return success;
    }

    public boolean reportAttendanceErrorLog(int maChamCong, String lyDo, int nguoiThucHien) {
        String thongDiep = "BÁO CÁO LỖI (Mã chấm công: " + maChamCong + ") - Lý do: " + lyDo;
        dao.SystemLogDAO.insertLog(nguoiThucHien, thongDiep, "AttendanceLog", getClientIpAddress());
        return true;
    }
}