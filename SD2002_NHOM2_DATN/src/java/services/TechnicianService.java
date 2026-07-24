/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package services;

import dao.FarmingPracticeDAO;
import java.util.List;
import models.FarmingPractice;

public class TechnicianService {

    private final FarmingPracticeDAO farmingPracticeDAO = new FarmingPracticeDAO();

    public List<FarmingPractice> getAllFarmingPractices() {
        return farmingPracticeDAO.getAllFarmingPractices();
    }

    public List<FarmingPractice> searchFarmingPractices(String keyword) {
        return farmingPracticeDAO.searchFarmingPractices(keyword);
    }

    public boolean createFarmingPractice(FarmingPractice fp) {
        if (fp.getTenQuyTrinh() == null || fp.getTenQuyTrinh().trim().isEmpty()) {
            return false;
        }
        return farmingPracticeDAO.insertFarmingPractice(fp);
    }

    public boolean deleteFarmingPractice(int id) {
        return farmingPracticeDAO.deleteFarmingPractice(id);
    }

    public boolean updateFarmingPractice(int id, String tenQuyTrinh, String moTa, String loaiApDung, String trangThai) {
        return farmingPracticeDAO.updateFarmingPractice(id, tenQuyTrinh, moTa, loaiApDung, trangThai);
    }
    
    public boolean addTaskAndAssign(models.Task task, int nguoiThucHien) {
        dao.TaskDAO taskDAO = new dao.TaskDAO();
        dao.AssignmentTaskDAO assignmentDAO = new dao.AssignmentTaskDAO();
        
        int newMaCongViec = taskDAO.insertTaskAndGetId(task);
        if (newMaCongViec > 0) {
            models.AssignmentTask at = new models.AssignmentTask(
                    0,
                    newMaCongViec,
                    task.getNguoiPhuTrach(),
                    java.time.LocalDateTime.now(),
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

    private String getClientIpAddress() {
        try {
            return java.net.InetAddress.getLocalHost().getHostAddress();
        } catch (java.net.UnknownHostException e) {
            return "Lỗi lấy IP";
        }
    }
}
