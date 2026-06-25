<%-- 
    Document   : admin
    Created on : Jun 23, 2026, 2:11:11 PM
    Author     : longd
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Smart Farmer - Trang Chủ Hệ Thống</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-image: url('https://images.unsplash.com/photo-1625246333195-78d9c38ad449?q=80&w=1920&auto=format&fit=crop');
            background-size: cover;
            background-position: center;
            display: flex;
            height: 100vh;
            overflow: hidden;
            position: relative;
        }

        body::before {
            content: "";
            position: absolute;
            inset: 0;
            background-color: rgba(20, 35, 20, 0.6);
            z-index: -1;
        }

        /* ================= SIDEBAR (MENU TRÁI TỪ US1 - US7) ================= */
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
            gap: 15px;
        }

        .logo-area svg { width: 36px; height: 36px; filter: drop-shadow(0px 2px 4px rgba(0,0,0,0.15)); }
        .logo-area h2 {
            margin: 0; font-size: 22px; font-weight: 850;
            background: linear-gradient(135deg, #1e4512, #467e32);
            -webkit-background-clip: text; -webkit-text-fill-color: transparent;
        }

        .menu { list-style: none; padding: 25px 0; margin: 0; flex: 1; overflow-y: auto; }
        .menu-item {
            padding: 14px 25px; display: flex; align-items: center; gap: 15px;
            color: #1a2419; text-decoration: none; font-weight: 700; font-size: 15px;
            transition: all 0.3s ease; border-left: 5px solid transparent;
        }

        .menu-item:hover, .menu-item.active {
            background: linear-gradient(90deg, rgba(87, 156, 63, 0.15) 0%, rgba(255, 255, 255, 0) 100%);
            border-left-color: #579c3f; color: #467e32;
        }
        .menu-item svg { width: 22px; height: 22px; fill: currentColor; }

        .logout-btn {
            border-top: 1px solid rgba(0, 0, 0, 0.08);
            padding: 20px 0;
        }

        /* ================= HEADER & MAIN CONTENT ================= */
        .main-wrapper {
            flex: 1;
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }

        .header {
            height: 85px;
            background: rgba(255, 255, 255, 0.85);
            backdrop-filter: blur(20px); -webkit-backdrop-filter: blur(20px);
            border-bottom: 1px solid rgba(255, 255, 255, 0.4);
            display: flex; align-items: center; justify-content: space-between;
            padding: 0 40px; box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05); z-index: 5;
        }

        .header-title h1 { margin: 0; font-size: 26px; font-weight: 800; color: #1a2419; }

        .user-profile { display: flex; align-items: center; gap: 20px; }
        .notification {
            position: relative; cursor: pointer; width: 45px; height: 45px;
            background: rgba(87, 156, 63, 0.1); border-radius: 50%;
            display: flex; justify-content: center; align-items: center; transition: background 0.3s;
        }
        .notification:hover { background: rgba(87, 156, 63, 0.2); }
        .notification svg { width: 22px; height: 22px; fill: #2e541f; }
        
        .badge {
            position: absolute; top: 2px; right: 2px; background-color: #e74c3c; color: white;
            font-size: 11px; font-weight: 800; padding: 3px 6px; border-radius: 12px;
            min-width: 10px; min-height: 12px; /* Giữ form khi trống data */
            display: flex; justify-content: center; align-items: center;
        }

        .avatar {
            width: 45px; height: 45px; background: linear-gradient(135deg, #579c3f, #2e541f);
            color: #ffffff; border-radius: 12px; display: flex; justify-content: center; align-items: center;
            font-weight: 800; font-size: 18px; cursor: pointer; box-shadow: 0 4px 10px rgba(46, 84, 31, 0.3);
        }

        .content-area { flex: 1; padding: 40px; overflow-y: auto; }

        /* ================= BẢNG ĐIỀU KHIỂN ================= */
        .welcome-panel {
            background: linear-gradient(135deg, rgba(87, 156, 63, 0.95), rgba(46, 84, 31, 0.95));
            backdrop-filter: blur(15px); border: 1px solid rgba(255, 255, 255, 0.3);
            border-radius: 16px; padding: 35px; color: #ffffff; margin-bottom: 35px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2); position: relative; overflow: hidden;
        }
        .welcome-panel::after {
            content: ""; position: absolute; top: -50px; right: -50px; width: 200px; height: 200px;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='%23ffffff15'%3E%3Cpath d='M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-6h2v6zm0-8h-2V7h2v2z'/%3E%3C/svg%3E");
            background-size: cover; pointer-events: none;
        }
        
        .welcome-panel h2 { 
            margin: 0 0 12px 0; font-size: 28px; font-weight: 850; text-shadow: 0 2px 4px rgba(0,0,0,0.2); 
            min-height: 35px; /* Giữ form khi chưa đổ Data */
        }
        .welcome-panel p { margin: 0; font-size: 16px; font-weight: 500; opacity: 0.95; line-height: 1.5; }

        .dashboard-cards { display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 25px; margin-bottom: 40px; }
        .card {
            background: rgba(255, 255, 255, 0.9); backdrop-filter: blur(15px); border-radius: 16px; padding: 25px;
            border: 1px solid rgba(255, 255, 255, 0.6); box-shadow: 0px 8px 32px rgba(0, 0, 0, 0.15);
            display: flex; align-items: center; gap: 20px; transition: transform 0.3s ease;
        }
        .card:hover { transform: translateY(-5px); box-shadow: 0px 12px 40px rgba(0, 0, 0, 0.25); }
        .card-icon {
            width: 70px; height: 70px; border-radius: 16px; background: linear-gradient(135deg, #579c3f, #396728);
            display: flex; justify-content: center; align-items: center; box-shadow: 0 5px 15px rgba(87, 156, 63, 0.4);
        }
        .card-icon svg { width: 32px; height: 32px; fill: #ffffff; }
        .card-info h3 { margin: 0 0 5px 0; font-size: 15px; color: #4a5c43; text-transform: uppercase; font-weight: 700; }
        .card-info p { 
            margin: 0; font-size: 34px; font-weight: 900; color: #1a2419; 
            min-height: 40px; /* Giữ form khi chưa đổ Data */
        }
    </style>
</head>
<body>

    <aside class="sidebar">
        <div class="logo-area">
            <svg viewBox="0 0 100 100">
                <defs>
                    <linearGradient id="leafGrad" x1="0%" y1="100%" x2="100%" y2="0%">
                        <stop offset="0%" stop-color="#396728" />
                        <stop offset="100%" stop-color="#579c3f" />
                    </linearGradient>
                </defs>
                <path d="M52 90 C55 70 58 55 52 45 C50 42 48 44 50 48 C55 58 52 72 49 90 Z" fill="url(#leafGrad)" />
                <path d="M50 51 C38 48 26 38 28 30 C30 22 45 32 52 45 C50 47 49 49 50 51 Z" fill="url(#leafGrad)" />
                <path d="M52 47 C55 30 65 12 71 12 C77 12 68 35 50 51 C50 49 51 48 52 47 Z" fill="url(#leafGrad)" />
            </svg>
            <h2>Smart Farmer</h2>
        </div>
        <ul class="menu">
            <li>
                <a href="index.html" class="menu-item active">
                    <svg viewBox="0 0 24 24"><path d="M3 13h8V3H3v10zm0 8h8v-6H3v6zm10 0h8V11h-8v10zm0-18v6h8V3h-8z"/></svg>
                    Trang chủ hệ thống
                </a>
            </li>
            <li>
                <a href="us1.html" class="menu-item">
                    <svg viewBox="0 0 24 24"><path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zM9 17H7v-7h2v7zm4 0h-2V7h2v10zm4 0h-2v-4h2v4z"/></svg>
                    Báo cáo tổng quan (US1)
                </a>
            </li>
            <li>
                <a href="us2.html" class="menu-item">
                    <svg viewBox="0 0 24 24"><path d="M12 1L3 5v6c0 5.55 3.84 10.74 9 12 5.16-1.26 9-6.45 9-12V5l-9-4zm0 10.99h7c-.53 4.12-3.28 7.79-7 8.94V12H5V6.3l7-3.11v8.8z"/></svg>
                    Quản trị hệ thống (US2)
                </a>
            </li>
            <li>
                <a href="us3.html" class="menu-item">
                    <svg viewBox="0 0 24 24"><path d="M20 4H4c-1.11 0-1.99.89-1.99 2L2 18c0 1.11.89 2 2 2h16c1.11 0 2-.89 2-2V6c0-1.11-.89-2-2-2zm0 14H4V8h16v10zm-2-1h-4v-2h4v2zm0-4h-4v-2h4v2z"/></svg>
                    Quản lý kho vật tư (US3)
                </a>
            </li>
            <li>
                <a href="us4.html" class="menu-item">
                    <svg viewBox="0 0 24 24"><path d="M22.7 19l-9.1-9.1c.9-2.3.4-5-1.5-6.9-2-2-5-2.4-7.4-1.3L9 6 6 9 1.6 4.7C.4 7.1.9 10.1 2.9 12.1c1.9 1.9 4.6 2.4 6.9 1.5l9.1 9.1c.4.4 1 .4 1.4 0l2.3-2.3c.5-.4.5-1.1.1-1.4z"/></svg>
                    Quản lý thiết bị (US4)
                </a>
            </li>
            <li>
                <a href="us5.html" class="menu-item">
                    <svg viewBox="0 0 24 24"><path d="M16 11c1.66 0 2.99-1.34 2.99-3S17.66 5 16 5c-1.66 0-3 1.34-3 3s1.34 3 3 3zm-8 0c1.66 0 2.99-1.34 2.99-3S9.66 5 8 5C6.34 5 5 6.34 5 8s1.34 3 3 3zm0 2c-2.33 0-7 1.17-7 3.5V19h14v-2.5c0-2.33-4.67-3.5-7-3.5zm8 0c-.29 0-.62.02-.97.05 1.16.84 1.97 1.97 1.97 3.45V19h6v-2.5c0-2.33-4.67-3.5-7-3.5z"/></svg>
                    Quản lý nhân sự (US5)
                </a>
            </li>
            <li>
                <a href="us6.html" class="menu-item">
                    <svg viewBox="0 0 24 24"><path d="M11.99 2C6.47 2 2 6.48 2 12s4.47 10 9.99 10C17.52 22 22 17.52 22 12S17.52 2 11.99 2zM12 20c-4.42 0-8-3.58-8-8s3.58-8 8-8 8 3.58 8 8-3.58 8-8 8z"/><path d="M12.5 7H11v6l5.25 3.15.75-1.23-4.5-2.67z"/></svg>
                    Thiết lập quy trình (US6)
                </a>
            </li>
            <li>
                <a href="us7.html" class="menu-item">
                    <svg viewBox="0 0 24 24"><path d="M19 3h-4.18C14.4 1.84 13.3 1 12 1c-1.3 0-2.4.84-2.82 2H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-7 0c.55 0 1 .45 1 1s-.45 1-1 1-1-.45-1-1 .45-1 1-1zm2 14H7v-2h7v2zm3-4H7v-2h10v2zm0-4H7V7h10v2z"/></svg>
                    Nhiệm vụ công nhân (US7)
                </a>
            </li>
            <li>
                <a href="us7.html" class="menu-item">...</a>
            </li>
            
            <li>
                <a href="logout" class="menu-item logout-btn" style="color: #e74c3c; margin-top: 20px; border-top: 1px solid rgba(0, 0, 0, 0.08);">
                    <svg viewBox="0 0 24 24" style="fill: #e74c3c;"><path d="M17 7l-1.41 1.41L18.17 11H8v2h10.17l-2.58 2.58L17 17l5-5zM4 5h8V3H4c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h8v-2H4V5z"/></svg>
                    Đăng xuất (US0)
                </a>
            </li>
        </ul>
    </aside>

    <div class="main-wrapper">
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

        <main class="content-area">
            <div class="welcome-panel">
                <h2>
                    </h2>
                <p>Khung điều hành trung tâm Smart Farmer. Tình trạng canh tác và thông số vật tư đang được hệ thống thu thập và xử lý thời gian thực.</p>
            </div>

            <div class="dashboard-cards">
                <div class="card">
                    <div class="card-icon"><svg viewBox="0 0 24 24"><path d="M16 11c1.66 0 2.99-1.34 2.99-3S17.66 5 16 5c-1.66 0-3 1.34-3 3s1.34 3 3 3zm-8 0c1.66 0 2.99-1.34 2.99-3S9.66 5 8 5C6.34 5 5 6.34 5 8s1.34 3 3 3zm0 2c-2.33 0-7 1.17-7 3.5V19h14v-2.5c0-2.33-4.67-3.5-7-3.5zm8 0c-.29 0-.62.02-.97.05 1.16.84 1.97 1.97 1.97 3.45V19h6v-2.5c0-2.33-4.67-3.5-7-3.5z"/></svg></div>
                    <div class="card-info">
                        <h3>Công nhân ca làm</h3>
                        <p>
                            </p>
                    </div>
                </div>
                <div class="card">
                    <div class="card-icon"><svg viewBox="0 0 24 24"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-6h2v6zm0-8h-2V7h2v2z"/></svg></div>
                    <div class="card-info">
                        <h3>Vật tư chạm đáy</h3>
                        <p>
                            </p>
                    </div>
                </div>
                <div class="card">
                    <div class="card-icon"><svg viewBox="0 0 24 24"><path d="M19.14 12.94c.04-.3.06-.61.06-.94 0-.32-.02-.64-.06-.94l2.03-1.58c.18-.14.23-.41.12-.61l-1.92-3.32c-.12-.22-.37-.29-.59-.22l-2.39.96c-.5-.38-1.03-.7-1.62-.94l-.36-2.54c-.04-.24-.24-.41-.48-.41h-3.84c-.24 0-.43.17-.47.41l-.36 2.54c-.59.24-1.13.56-1.62.94l-2.39-.96c-.22-.08-.47 0-.59.22L2.74 8.87c-.12.21-.08.47.12.61l2.03 1.58c-.05.3-.09.63-.09.94s.02.64.06.94l-2.03 1.58c-.18.14-.23.41-.12.61l1.92 3.32c.12.22.37.29.59.22l2.39-.96c.5.38 1.03.7 1.62.94l.36 2.54c.05.24.24.41.48.41h3.84c.24 0 .43-.17.47-.41l.36-2.54c.59-.24 1.13-.56 1.62-.94l2.39.96c.22.08.47 0 .59-.22l1.92-3.32c.12-.22.07-.49-.12-.61l-2.01-1.58zM12 15.6c-1.98 0-3.6-1.62-3.6-3.6s1.62-3.6 3.6-3.6 3.6 1.62 3.6 3.6-1.62 3.6-3.6 3.6z"/></svg></div>
                    <div class="card-info">
                        <h3>Đến hạn bảo trì</h3>
                        <p>
                            </p>
                    </div>
                </div>
            </div>
            
        </main>
    </div>
</body>
</html>
