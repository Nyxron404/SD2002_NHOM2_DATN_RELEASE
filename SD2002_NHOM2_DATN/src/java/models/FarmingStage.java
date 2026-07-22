/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package models;

/**
 *
 * @author pminh
 */
public class FarmingStage {
    private int id;
    private int farmingPracticeId;
    private String stageName;
    private int startDay;
    private int endDay;
    private int supplyId;
    private double quantity;
    private String unit;
    private String description;

    public FarmingStage() {
    }

    public FarmingStage(int id, int farmingPracticeId, String stageName, int startDay, int endDay, int supplyId, double quantity, String unit, String description) {
        this.id = id;
        this.farmingPracticeId = farmingPracticeId;
        this.stageName = stageName;
        this.startDay = startDay;
        this.endDay = endDay;
        this.supplyId = supplyId;
        this.quantity = quantity;
        this.unit = unit;
        this.description = description;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getFarmingPracticeId() {
        return farmingPracticeId;
    }

    public void setFarmingPracticeId(int farmingPracticeId) {
        this.farmingPracticeId = farmingPracticeId;
    }

    public String getStageName() {
        return stageName;
    }

    public void setStageName(String stageName) {
        this.stageName = stageName;
    }

    public int getStartDay() {
        return startDay;
    }

    public void setStartDay(int startDay) {
        this.startDay = startDay;
    }

    public int getEndDay() {
        return endDay;
    }

    public void setEndDay(int endDay) {
        this.endDay = endDay;
    }

    public int getSupplyId() {
        return supplyId;
    }

    public void setSupplyId(int supplyId) {
        this.supplyId = supplyId;
    }

    public double getQuantity() {
        return quantity;
    }

    public void setQuantity(double quantity) {
        this.quantity = quantity;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
    
    
}
