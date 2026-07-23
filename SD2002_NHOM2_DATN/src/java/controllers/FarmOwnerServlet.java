package controllers;

import dao.SystemLogDAO;
import dao.TaskDAO;      
import dao.SupplieDAO;    
import models.SystemLog;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name="farmOwnerServlet", urlPatterns={"/farmowner"})
public class FarmOwnerServlet extends HttpServlet {
   
    private SystemLogDAO systemLogDAO = new SystemLogDAO();
    private TaskDAO taskDAO = new TaskDAO();     
    private SupplieDAO supplieDAO = new SupplieDAO(); 

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("export".equals(action)) {
            response.setContentType("text/csv; charset=UTF-8");
            response.setHeader("Content-Disposition", "attachment; filename=\"BaoCaoNhatKy.csv\"");
            
            java.io.PrintWriter out = response.getWriter();
            out.write('\ufeff');
            
            out.println("Mã Log;Người Dùng;Hành Động;Bảng Dữ Liệu;Thời Gian;Địa Chỉ IP");
            
            List<SystemLog> logList = systemLogDAO.getAllLogs();
            for (SystemLog log : logList) {
                out.println(log.getMaNhatKy() + ";" + 
                            log.getMaNguoiDung() + ";" + 
                            log.getHanhDong() + ";" + 
                            log.getBangTacDong() + ";" + 
                            log.getThoiGian() + ";" + 
                            log.getDiaChiIP());
            }
            out.flush();
            out.close();
            return; 
        }

        // NẾU KHÔNG: Chạy code hiển thị giao diện Dashboard như bình thường
        List<SystemLog> logList = systemLogDAO.getAllLogs();
        request.setAttribute("systemLogs", logList);
        
        request.setAttribute("workerCount", taskDAO.getActiveWorkersCount());
        request.setAttribute("lowStockCount", supplieDAO.getLowStockCount());
        request.setAttribute("maintenanceCount", 2); 
        
        request.getRequestDispatcher("/views/farmOwner/farmOwner.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        request.getRequestDispatcher("/views/farmOwner/farmOwner.jsp").forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Controller cho trang chủ Farm Owner";
    }
}