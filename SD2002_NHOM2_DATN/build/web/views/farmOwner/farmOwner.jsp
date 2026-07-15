<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
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
        
        .main-wrapper {
            flex: 1;
            display: flex;
            flex-direction: column;
            overflow: hidden;
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
    <jsp:include page="/views/common/sidebar.jsp">
        <jsp:param name="activePage" value="admin" />
    </jsp:include>
    <div class="main-wrapper">
        <jsp:include page="/views/common/header.jsp"></jsp:include>
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

