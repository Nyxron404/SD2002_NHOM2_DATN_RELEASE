<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%-- Sử dụng namespace jakarta cho Tomcat 10+ --%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<style>
    /* ================= SIDEBAR ================= */
    .sidebar {
        width: 300px;
        background: rgba(255, 255, 255, 0.9);
        backdrop-filter: blur(20px);
        -webkit-backdrop-filter: blur(20px);
        border-right: 1px solid rgba(255, 255, 255, 0.4);
        display: flex;
        flex-direction: column;
        box-shadow: 4px 0 25px rgba(0, 0, 0, 0.15);
        z-index: 10;
    }

    .logo-area {
        height: 85px;
        display: flex;
        align-items: center;
        padding: 0 25px;
        border-bottom: 1px solid rgba(0, 0, 0, 0.08);
    }

    /* Định dạng cho thẻ a bọc logo để không bị vỡ giao diện */
    .logo-area a {
        display: flex;
        align-items: center;
        gap: 15px;
        text-decoration: none;
        width: 100%;
    }

    .logo-area svg {
        width: 36px;
        height: 36px;
        flex-shrink: 0;
        filter: drop-shadow(0px 2px 4px rgba(0,0,0,0.15));
    }

    .logo-area h2 {
        margin: 0;
        font-size: 22px;
        font-weight: 850;
        background: linear-gradient(135deg, #1e4512, #467e32);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        white-space: nowrap; /* Tránh việc chữ Smart Farmer bị xuống dòng */
    }

    .menu {
        list-style: none;
        padding: 25px 0;
        margin: 0;
        flex: 1;
        overflow-y: auto;
    }
    .menu-item {
        padding: 14px 25px;
        display: flex;
        align-items: center;
        gap: 15px;
        color: #1a2419;
        text-decoration: none;
        font-weight: 700;
        font-size: 15px;
        transition: all 0.3s ease;
        border-left: 5px solid transparent;
        width: 100%; /* Chiếm toàn bộ chiều rộng form */
        background: none;
        border: none;
        outline: none; /* KHẮC PHỤC: Xóa bỏ viền đen focus mặc định của trình duyệt */
        cursor: pointer;
        text-align: left;
        font-family: inherit;
    }

    /* Đảm bảo khi click/focus vào button sẽ không hiện viền đen */
    .menu-item:focus, .menu-item:active {
        outline: none;
        box-shadow: none;
    }

    .menu-item:hover, .menu-item.active {
        background: linear-gradient(90deg, rgba(87, 156, 63, 0.15) 0%, rgba(255, 255, 255, 0) 100%);
        border-left-color: #579c3f;
        color: #467e32;
    }

    .menu-item svg {
        width: 22px;
        height: 22px;
        fill: currentColor; /* SVG tự động ăn theo màu chữ (color) của thẻ cha */
    }

    /* ================= KHU VỰC ĐĂNG XUẤT ================= */
    .logout-container {
        margin-top: 20px;
        border-top: 1px solid rgba(0, 0, 0, 0.08);
        width: 100%; /* Trải rộng full sidebar */
    }

    /* Class riêng cho form Đăng xuất để kéo dãn chiều rộng */
    .logout-form {
        margin: 0;
        padding: 0;
        width: 100%; /* KHẮC PHỤC: Đảm bảo form rộng bằng thẻ li */
        display: block;
    }

    /* Màu chữ và icon đỏ mặc định */
    .logout-btn-submit {
        color: #e74c3c !important;
    }

    /* Hiệu ứng hover riêng cho nút Đăng xuất */
    .logout-btn-submit:hover {
        background: linear-gradient(90deg, rgba(231, 76, 60, 0.1) 0%, rgba(255, 255, 255, 0) 100%);
        border-left-color: #e74c3c;
        color: #e74c3c !important;
    }
</style>
<aside class="sidebar">
    <div class="logo-area">
        <a href="${pageContext.request.contextPath}/admin"><svg viewBox="0 0 100 100">
            <path d="M52 90 C55 70 58 55 52 45 C50 42 48 44 50 48 C55 58 52 72 49 90 Z" fill="#396728" />
            <path d="M50 51 C38 48 26 38 28 30 C30 22 45 32 52 45 C50 47 49 49 50 51 Z" fill="#579c3f" />
            </svg>
            <h2>Smart Farm</h2>
        </a>
    </div>


    <ul class="menu">
        <c:forEach var="QuyenHan" items="${sessionScope.QuyenHan}">
            <c:if test="${QuyenHan == 'Admin'}">
                <li>
                    <a href="${pageContext.request.contextPath}/admin" class="menu-item ${param.activePage == 'admin' ? 'active' : ''}">
                        <svg viewBox="0 0 24 24"><path d="M3 13h8V3H3v10zm0 8h8v-6H3v6zm10 0h8V11h-8v10zm0-18v6h8V3h-8z"/></svg>
                        Quản lý vai trò
                    </a>
                </li>
            </c:if>
            <c:if test="${QuyenHan == 'FarmOwner' || QuyenHan == 'Admin'}">
                <li>
                    <a href="${pageContext.request.contextPath}/farmowner" class="menu-item ${param.activePage == 'farmOwner' ? 'active' : ''}">
                        <svg viewBox="0 0 24 24"><path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zM9 17H7v-7h2v7zm4 0h-2V7h2v10zm4 0h-2v-4h2v4z"/></svg>
                        Báo cáo tổng quan 
                    </a>
                </li>
            </c:if>
            <c:if test="${QuyenHan == 'HrManager' || QuyenHan == 'Admin'}">

                <li>
                    <a href="${pageContext.request.contextPath}/hr" class="menu-item ${param.activePage == 'hrManager' ? 'active' : ''}">
                        <svg viewBox="0 0 24 24"><path d="M16 11c1.66 0 2.99-1.34 2.99-3S17.66 5 16 5c-1.66 0-3 1.34-3 3s1.34 3 3 3zm-8 0c1.66 0 2.99-1.34 2.99-3S9.66 5 8 5C6.34 5 5 6.34 5 8s1.34 3 3 3zm0 2c-2.33 0-7 1.17-7 3.5V19h14v-2.5c0-2.33-4.67-3.5-7-3.5zm8 0c-.29 0-.62.02-.97.05 1.16.84 1.97 1.97 1.97 3.45V19h6v-2.5c0-2.33-4.67-3.5-7-3.5z"/></svg>
                        Quản lý nhân sự 
                    </a>
                </li>
            </c:if>
            <c:if test="${QuyenHan == 'InventoryManager' || QuyenHan == 'Admin'}">
                <li>
                    <a href="${pageContext.request.contextPath}/inventory" class="menu-item ${param.activePage == 'inventoryManager' ? 'active' : ''}">
                        <svg viewBox="0 0 24 24"><path d="M20 4H4c-1.1 0-1.99.89-1.99 2L2 18c0 1.11.89 2 2 2h16c1.11 0 2-.89 2-2V6c0-1.11-.89-2-2-2zm0 14H4V8h16v10zm-2-1h-4v-2h4v2zm0-4h-4v-2h4v2z"/></svg>
                        Quản lý kho vật tư 
                    </a>
                </li>
            </c:if>
            <c:if test="${QuyenHan == 'Technician' || QuyenHan == 'Admin'}">
                <li>
                    <a href="${pageContext.request.contextPath}/technician" class="menu-item ${param.activePage == 'technician' ? 'active' : ''}">
                        <svg viewBox="0 0 24 24"><path d="M11.99 2C6.47 2 2 6.48 2 12s4.47 10 9.99 10C17.52 22 22 17.52 22 12S17.52 2 11.99 2zM12 20c-4.42 0-8-3.58-8-8s3.58-8 8-8 8 3.58 8 8-3.58 8-8 8z"/><path d="M12.5 7H11v6l5.25 3.15.75-1.23-4.5-2.67z"/></svg>
                        Thiết lập quy trình 
                    </a>
                </li>
            </c:if>
            <c:if test="${QuyenHan == 'Worker' || QuyenHan == 'Admin'}">
                <li>
                    <a href="${pageContext.request.contextPath}/worker" class="menu-item ${param.activePage == 'worker' ? 'active' : ''}">
                        <svg viewBox="0 0 24 24"><path d="M19 3h-4.18C14.4 1.84 13.3 1 12 1c-1.3 0-2.4.84-2.82 2H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-7 0c.55 0 1 .45 1 1s-.45 1-1 1-1-.45-1-1 .45-1 1-1zm2 14H7v-2h7v2zm3-4H7v-2h10v2zm0-4H7V7h10v2z"/></svg>
                        Công Việc 
                    </a>
                </li>
            </c:if>
            <c:if test="${QuyenHan == 'EquipmentManager' || QuyenHan == 'Admin'}">
                <li>
                    <a href="${pageContext.request.contextPath}/views/equipmentManager/equipmentManager.jsp" class="menu-item ${param.activePage == 'equipmentManager' ? 'active' : ''}">
                        <svg viewBox="0 0 24 24"><path d="M22.7 19l-9.1-9.1c.9-2.3.4-5-1.5-6.9-2-2-5-2.4-7.4-1.3L9 6 6 9 1.6 4.7C.4 7.1.9 10.1 2.9 12.1c1.9 1.9 4.6 2.4 6.9 1.5l9.1 9.1c.4.4 1 .4 1.4 0l2.3-2.3c.5-.4.5-1.1.1-1.4z"/></svg>
                        Quản lý thiết bị
                    </a>
                </li>
            </c:if>
        </c:forEach>
        <li class="logout-container">
            <form action="${pageContext.request.contextPath}/auth" method="Post" class="logout-form">
                <input type="hidden" name="action" value="logout"/>
                <button type="submit" class="menu-item logout-btn-submit">
                    <svg viewBox="0 0 24 24"><path d="M17 7l-1.41 1.41L18.17 11H8v2h10.17l-2.58 2.58L17 17l5-5zM4 5h8V3H4c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h8v-2H4V5z"/></svg>
                    Đăng xuất
                </button>
            </form>
        </li>
    </ul>
</aside>