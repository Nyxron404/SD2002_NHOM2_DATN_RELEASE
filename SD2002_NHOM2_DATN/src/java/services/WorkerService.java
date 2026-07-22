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
    
    // Gọi hàm tìm kiếm từ DAO
    public List<Task> searchTasks(String keyword) {
        return taskDAO.searchTasks(keyword);
    }
    
    public List<AttendanceLog> getAllAttendance() {
        return attendanceLogDAO.getAttendance();
    }
    
    // Gọi hàm tìm kiếm ngày công từ DAO
    public List<AttendanceLog> searchAttendanceByTaskIds(List<Integer> taskIds) {
        return attendanceLogDAO.searchAttendanceByTaskIds(taskIds);
    }

    private String getClientIpAddress() {
        try {
            return InetAddress.getLocalHost().getHostAddress();
        } catch (UnknownHostException e) {
            return "Lỗi lấy IP";
        }
    }

    // nguoiThucHien: người đang thao tác phân công (quản lý/admin đang đăng nhập)
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
                // Tự động ghi log mỗi khi có công nhân được phân công việc mới
                dao.SystemLogDAO.insertLog(nguoiThucHien, "PHÂN CÔNG CÔNG VIỆC MỚI (Mã việc: " + newMaCongViec + ")", "Task", getClientIpAddress());
            }
            return success;
        }
        return false;
    }

    // Hủy 1 công việc: đổi trạng thái Task + AssignmentTask, đồng thời ghi log
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
    
    // Chức năng chốt lương và ghi log với IP nội bộ LAN
    public boolean approveSalaryLog(int maChamCong, int nguoiThucHien) {
        boolean success = attendanceLogDAO.approveSalary(maChamCong);
        if (success) {
            dao.SystemLogDAO.insertLog(nguoiThucHien, "CHỐT LƯƠNG (Mã chấm công: " + maChamCong + ")", "AttendanceLog", getClientIpAddress());
        }
        return success;
    }

    // Chức năng báo cáo sai sót ngày công và ghi log với IP nội bộ LAN
    public boolean reportAttendanceErrorLog(int maChamCong, String lyDo, int nguoiThucHien) {
        String thongDiep = "BÁO CÁO LỖI (Mã chấm công: " + maChamCong + ") - Lý do: " + lyDo;
        // Báo cáo lỗi thì cứ lưu log trực tiếp
        dao.SystemLogDAO.insertLog(nguoiThucHien, thongDiep, "AttendanceLog", getClientIpAddress());
        return true;
    }
}