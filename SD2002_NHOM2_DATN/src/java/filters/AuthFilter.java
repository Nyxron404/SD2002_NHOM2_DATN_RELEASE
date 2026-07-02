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

/**
 * Filter nay chay cho TAT CA request ("/*").
 * Nhiem vu:
 *   1) Cho qua nhung trang khong can dang nhap (login, register, forgot, static resource...)
 *   2) Neu chua dang nhap (session khong co "account") -> chuyen ve trang login
 *   3) Neu da dang nhap nhung role khong khop voi khu vuc dang truy cap -> tra ve 403
 *   4) Hop le -> cho di tiep (chain.doFilter)
 *
 * @author longd
 */
//@WebFilter(filterName = "AuthFilter", urlPatterns = {"/*"}, dispatcherTypes = {DispatcherType.REQUEST, DispatcherType.FORWARD})
public class AuthFilter implements Filter {

    private static final boolean debug = true;

    private FilterConfig filterConfig = null;

    /**
     * Nhung duong dan KHONG can dang nhap.
     * Dung startsWith() nen chi can ghi tien to la du.
     * -> Sua/them tuy theo URL pattern thuc te cua AuthServlet va cac trang JSP cua ban.
     */
    private static final String[] PUBLIC_PATHS = {
        "/auth",      // servlet xu ly login/register/forgot
        "/views/auth/",      // login.jsp, register.jsp, forgot.jsp
        "/css/", "/js/", "/images/", "/assets/", "/webjars/" // tai nguyen tinh
    };

    /**
     * Map: tien to URL  ->  role duoc phep truy cap khu vuc do.
     * Dua theo cac servlet/folder trong anh project cua ban.
     * -> Sua lai cho dung @WebServlet urlPatterns cua tung Servlet ban da viet.
     */
    private static final Map<String, String> ROLE_MAP = new HashMap<>();
    static {
        ROLE_MAP.put("/admin", "admin");
        ROLE_MAP.put("/views/", "admin");

        ROLE_MAP.put("/farmowner", "farmOwner");
        ROLE_MAP.put("/views/farmOwner/", "farmOwner");

        ROLE_MAP.put("/hr", "hrManager");
        ROLE_MAP.put("/views/hrManager/", "hrManager");

        ROLE_MAP.put("/inventory", "inventoryManager");
        ROLE_MAP.put("/views/inventoryManager/", "inventoryManager");

        ROLE_MAP.put("/technician", "technician");
        ROLE_MAP.put("/views/technician/", "technician");

        ROLE_MAP.put("/worker", "worker");
        ROLE_MAP.put("/views/worker/", "worker");

        ROLE_MAP.put("/equipment", "equipmentManager");
        ROLE_MAP.put("/views/equipmentManager/", "equipmentManager");
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
        // Bo phan contextPath de chi con lai duong dan "thuan" trong app, vd: /views/admin/admin.jsp
        String path = uri.substring(contextPath.length());

        if (debug) {
            log("AuthFilter: kiem tra request -> " + path);
        }

        // BUOC 1: trang public thi cho qua luon, khong can kiem tra gi them
        if (isPublicPath(path)) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = req.getSession(false); // false = khong tu tao session moi
        Object account = (session != null) ? session.getAttribute("account") : null;

        // BUOC 2: chua dang nhap -> ve trang login
        if (account == null) {
            if (debug) {
                log("AuthFilter: chua dang nhap, redirect ve login");
            }
            res.sendRedirect(contextPath + "/views/auth/register.jsp");
            return;
        }

        // BUOC 3: da dang nhap -> kiem tra role co duoc phep vao khu vuc nay khong
        String role = (String) session.getAttribute("role");
        String requiredRole = getRequiredRole(path);

        if (requiredRole != null && !requiredRole.equalsIgnoreCase(role)) {
            if (debug) {
                log("AuthFilter: role '" + role + "' khong co quyen vao '" + path + "'");
            }
            res.sendError(HttpServletResponse.SC_FORBIDDEN, "Ban khong co quyen truy cap trang nay");
            return;
        }

        // BUOC 4: hop le -> cho request di tiep trong chain
        chain.doFilter(request, response);
    }

    /**
     * Kiem tra path co thuoc danh sach khong can dang nhap khong.
     */
    private boolean isPublicPath(String path) {
        for (String p : PUBLIC_PATHS) {
            if (path.startsWith(p)) {
                return true;
            }
        }
        return false;
    }

    /**
     * Tra ve role can co de duoc vao path nay.
     * Tra ve null neu path khong nam trong khu vuc can phan quyen rieng
     * (vd: tat ca user da dang nhap deu vao duoc).
     */
    private String getRequiredRole(String path) {
        for (Map.Entry<String, String> entry : ROLE_MAP.entrySet()) {
            if (path.startsWith(entry.getKey())) {
                return entry.getValue();
            }
        }
        return null;
    }

    public FilterConfig getFilterConfig() {
        return (this.filterConfig);
    }

    public void setFilterConfig(FilterConfig filterConfig) {
        this.filterConfig = filterConfig;
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

    @Override
    public String toString() {
        if (filterConfig == null) {
            return ("AuthFilter()");
        }
        StringBuilder sb = new StringBuilder("AuthFilter(");
        sb.append(filterConfig);
        sb.append(")");
        return (sb.toString());
    }

    public void log(String msg) {
        filterConfig.getServletContext().log(msg);
    }

}
