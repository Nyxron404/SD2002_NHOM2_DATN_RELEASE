/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package services;

import dao.SupplieDAO;
import java.util.List;
import models.Supplie;

/**
 *
 * @author longd
 */
public class InventoryManagerService {
    private SupplieDAO supplieDAO = new SupplieDAO();
    
    public List<Supplie> getAllSupplies(){
        return supplieDAO.SelectSupplie();
    }
    
    public boolean addSupplie(Supplie s){
        if(s.getTenVatTu() == null || s.getTenVatTu().trim().isEmpty() || s.getDonGia() < 0 || s.getSoLuongTon() < 0){
            return false;
        }
        supplieDAO.addSupplie(s);
        return true;
    }

    public boolean updateSupplie(Supplie s) {
        if(s.getMaVatTu() <= 0 || s.getTenVatTu() == null || s.getTenVatTu().trim().isEmpty()){
            return false;
        }
        supplieDAO.updateSupplie(s);
        return true;
    }

    public boolean deleteSupplie(int maVatTu) {
        if (maVatTu <= 0) return false;
        supplieDAO.deleteSupplie(maVatTu);
        return true;
    }
}
