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
}