package controllers;

import dao.StaffDAO;
import dao.SystemLogDAO;
import dao.TaskDAO;      
import dao.SupplieDAO;    
import models.SystemLog;
import java.io.IOException;
import java.util.List;
import java.util.concurrent.ConcurrentHashMap;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Staff;

@WebServlet(name="farmOwnerServlet", urlPatterns={"/farmowner"})
public class FarmOwnerServlet extends HttpServlet {
   
    private SystemLogDAO systemLogDAO = new SystemLogDAO();
    private TaskDAO taskDAO = new TaskDAO();     
    private SupplieDAO supplieDAO = new SupplieDAO(); 
    private StaffDAO staffDAO = new StaffDAO();

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

        // Lấy danh sách công nhân mỗi khi có request để luôn cập nhật
        List<Staff> workersOnlyList = staffDAO.getWorkersOnly();

        // Lấy danh sách trạng thái Online từ bộ nhớ (được cập nhật bởi Filter)
        ConcurrentHashMap<Integer, Long> activeUsers = (ConcurrentHashMap<Integer, Long>) request.getServletContext().getAttribute("ACTIVE_USERS_MAP");
        if(activeUsers == null) {
             activeUsers = new ConcurrentHashMap<>();
        }
        
        // Truyền thêm currentTime (thời gian hiện tại) để xử lý logic quá 5 phút ở JSP
        request.setAttribute("currentTimeMillis", System.currentTimeMillis());
        request.setAttribute("activeUsersMap", activeUsers);

        List<SystemLog> logList = systemLogDAO.getAllLogs();
        request.setAttribute("systemLogs", logList);
        request.setAttribute("activeWorkersList", workersOnlyList);
        request.setAttribute("workerCount", workersOnlyList.size());
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