/*
 * AuthFilter - Filter kiem tra dang nhap (authentication) va phan quyen (authorization)
 */

package filters;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import jakarta.servlet.DispatcherType;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;


@WebFilter(filterName = "AuthFilter", urlPatterns = {"/*"}, dispatcherTypes = {DispatcherType.REQUEST, DispatcherType.FORWARD})
public class AuthFilter implements Filter {

    private static final boolean debug = false;

    private FilterConfig filterConfig = null;

    private static final String[] PUBLIC_PATHS = {
        "/auth",   
        "/views/auth/",      
        "/css/", "/js/", "/images/", "/assets/", "/webjars/" 
    };

    private static final Map<String, String> ROLE_MAP = new HashMap<>();
    static {
        ROLE_MAP.put("/admin", "Admin");
        ROLE_MAP.put("/views/admin/", "Admin");

        ROLE_MAP.put("/farmowner", "FarmOwner");
        ROLE_MAP.put("/views/farmOwner/", "FarmOwner");

        ROLE_MAP.put("/hr", "HrManager");
        ROLE_MAP.put("/views/hrManager/", "HrManager");

        ROLE_MAP.put("/inventory", "InventoryManager");
        ROLE_MAP.put("/views/inventoryManager/", "InventoryManager");

        ROLE_MAP.put("/technician", "Technician");
        ROLE_MAP.put("/views/technician/", "Technician");

        ROLE_MAP.put("/worker", "Worker");
        ROLE_MAP.put("/views/worker/", "Worker");

        ROLE_MAP.put("/equipment", "EquipmentManager");
        ROLE_MAP.put("/views/equipmentManager/", "EquipmentManager");
    }

    public AuthFilter() {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        String contextPath = req.getContextPath();
        String uri = req.getRequestURI();
        String path = uri.substring(contextPath.length());

        if (debug) {
            log("AuthFilter: kiem tra request -> " + path);
        }

        if (isPublicPath(path)) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = req.getSession(false);
        List<String> quyenHan = (session != null) ? (List<String>) session.getAttribute("QuyenHan") : null;

        if (quyenHan == null) {
            res.sendRedirect(contextPath + "/views/auth/login.jsp");
            return;
        }

        if (quyenHan.contains("Admin")) {
            chain.doFilter(request, response);
            return;
        }
        
        String requiredRole = getRequiredRole(path);

        if (requiredRole != null && !quyenHan.contains(requiredRole)) {
            if (debug) {
                log("AuthFilter: role '" + quyenHan + "' khong co quyen vao '" + path + "'");
            }
            res.sendError(HttpServletResponse.SC_FORBIDDEN, "Ban khong co quyen truy cap trang nay");
            return;
        }

        chain.doFilter(request, response);
    }

    private boolean isPublicPath(String path) {
        for (String p : PUBLIC_PATHS) {
            if (path.startsWith(p)) {
                return true;
            }
        }
        return false;
    }

    private String getRequiredRole(String path) {
        for (Map.Entry<String, String> entry : ROLE_MAP.entrySet()) {
            if (path.startsWith(entry.getKey())) {
                return entry.getValue();
            }
        }
        return null;
    }

    public void destroy() {
    }

    public void init(FilterConfig filterConfig) {
        this.filterConfig = filterConfig;
        if (filterConfig != null) {
            if (debug) {
                log("AuthFilter: Initializing filter");
            }
        }
    }

    public void log(String msg) {
        filterConfig.getServletContext().log(msg);
    }

}
