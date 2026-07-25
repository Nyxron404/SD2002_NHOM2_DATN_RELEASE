package filters;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.concurrent.ConcurrentHashMap;

// Áp dụng cho mọi đường dẫn
@WebFilter(filterName = "ActiveUserFilter", urlPatterns = {"/*"})
public class ActiveUserFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest req = (HttpServletRequest) request;
        HttpSession session = req.getSession(false);
        
        if (session != null) {
            Integer userId = (Integer) session.getAttribute("userId");
            if (userId != null) {
                // Lấy bản đồ lưu trữ thời gian từ ServletContext
                ConcurrentHashMap<Integer, Long> activeUsers = (ConcurrentHashMap<Integer, Long>) req.getServletContext().getAttribute("ACTIVE_USERS_MAP");
                
                if (activeUsers == null) {
                    activeUsers = new ConcurrentHashMap<>();
                    req.getServletContext().setAttribute("ACTIVE_USERS_MAP", activeUsers);
                }
                
                // Cập nhật timestamp hiện tại (millisecond) cho userId này
                activeUsers.put(userId, System.currentTimeMillis());
            }
        }
        
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {}
}