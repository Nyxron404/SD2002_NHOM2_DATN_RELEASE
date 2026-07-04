<%-- 
    Document   : header
    Created on : Jun 23, 2026, 2:12:07 PM
    Author     : longd
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<style>
    .header {
        height: 85px;
        background: rgba(255, 255, 255, 0.85);
        backdrop-filter: blur(20px);
        -webkit-backdrop-filter: blur(20px);
        border-bottom: 1px solid rgba(255, 255, 255, 0.4);
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 0 40px;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
        z-index: 5;
    }

    .header-title h1 {
        margin: 0;
        font-size: 26px;
        font-weight: 800;
        color: #1a2419;
    }

    .user-profile {
        display: flex;
        align-items: center;
        gap: 20px;
    }
    .notification {
        position: relative;
        cursor: pointer;
        width: 45px;
        height: 45px;
        background: rgba(87, 156, 63, 0.1);
        border-radius: 50%;
        display: flex;
        justify-content: center;
        align-items: center;
        transition: background 0.3s;
    }
    .notification:hover {
        background: rgba(87, 156, 63, 0.2);
    }
    .notification svg {
        width: 22px;
        height: 22px;
        fill: #2e541f;
    }
    .badge {
        position: absolute;
        top: 2px;
        right: 2px;
        background-color: #e74c3c;
        color: white;
        font-size: 11px;
        font-weight: 800;
        padding: 3px 6px;
        border-radius: 12px;
        min-width: 10px;
        min-height: 12px; /* Giữ form khi trống data */
        display: flex;
        justify-content: center;
        align-items: center;
    }

    .avatar {
        width: 45px;
        height: 45px;
        background: linear-gradient(135deg, #579c3f, #2e541f);
        color: #ffffff;
        border-radius: 12px;
        display: flex;
        justify-content: center;
        align-items: center;
        font-weight: 800;
        font-size: 18px;
        cursor: pointer;
        box-shadow: 0 4px 10px rgba(46, 84, 31, 0.3);
    }
</style>
<header class="header">
    <div class="header-title">
        <h1>Trang Chủ Hệ Thống</h1>
    </div>
    <div class="user-profile">
        <div class="notification">
            <svg viewBox="0 0 24 24"><path d="M12 22c1.1 0 2-.9 2-2h-4c0 1.1.9 2 2 2zm6-6v-5c0-3.07-1.63-5.64-4.5-6.32V4c0-.83-.67-1.5-1.5-1.5s-1.5.67-1.5 1.5v.68C7.64 5.36 6 7.92 6 11v5l-2 2v1h16v-1l-2-2zm-2 1H8v-6c0-2.48 1.51-4.5 4-4.5s4 2.02 4 4.5v6z"/></svg>
            <span class="badge">
            </span>
        </div>

        <div class="avatar">
        </div>
    </div>
</header>