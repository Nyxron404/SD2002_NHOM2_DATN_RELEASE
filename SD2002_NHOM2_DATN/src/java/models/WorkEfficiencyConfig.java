package models;

public class WorkEfficiencyConfig {
    private int maQuyTrinh;
    private String tenQuyTrinh;
    private double heSoCong;

    public WorkEfficiencyConfig() {}

    public WorkEfficiencyConfig(int maQuyTrinh, String tenQuyTrinh, double heSoCong) {
        this.maQuyTrinh = maQuyTrinh;
        this.tenQuyTrinh = tenQuyTrinh;
        this.heSoCong = heSoCong;
    }

    public int getMaQuyTrinh() { return maQuyTrinh; }
    public void setMaQuyTrinh(int maQuyTrinh) { this.maQuyTrinh = maQuyTrinh; }
    public String getTenQuyTrinh() { return tenQuyTrinh; }
    public void setTenQuyTrinh(String tenQuyTrinh) { this.tenQuyTrinh = tenQuyTrinh; }
    public double getHeSoCong() { return heSoCong; }
    public void setHeSoCong(double heSoCong) { this.heSoCong = heSoCong; }
}