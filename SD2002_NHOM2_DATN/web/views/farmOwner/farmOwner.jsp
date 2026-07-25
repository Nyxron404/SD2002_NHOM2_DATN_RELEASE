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

            .content-area {
                flex: 1;
                padding: 40px;
                overflow-y: auto;
            }

            /* ================= BẢNG ĐIỀU KHIỂN ================= */
            .welcome-panel {
                background: linear-gradient(135deg, rgba(87, 156, 63, 0.95), rgba(46, 84, 31, 0.95));
                backdrop-filter: blur(15px);
                border: 1px solid rgba(255, 255, 255, 0.3);
                border-radius: 16px;
                padding: 35px;
                color: #ffffff;
                margin-bottom: 35px;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
                position: relative;
                overflow: hidden;
            }
            .welcome-panel::after {
                content: "";
                position: absolute;
                top: -50px;
                right: -50px;
                width: 200px;
                height: 200px;
                background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='%23ffffff15'%3E%3Cpath d='M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-6h2v6zm0-8h-2V7h2v2z'/%3E%3C/svg%3E");
                background-size: cover;
                pointer-events: none;
            }

            .welcome-panel h2 {
                margin: 0 0 12px 0;
                font-size: 28px;
                font-weight: 850;
                text-shadow: 0 2px 4px rgba(0,0,0,0.2);
                min-height: 35px; /* Giữ form khi chưa đổ Data */
            }
            .welcome-panel p {
                margin: 0;
                font-size: 16px;
                font-weight: 500;
                opacity: 0.95;
                line-height: 1.5;
            }

            .dashboard-cards {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
                gap: 25px;
                margin-bottom: 40px;
            }
            .card {
                background: rgba(255, 255, 255, 0.9);
                backdrop-filter: blur(15px);
                border-radius: 16px;
                padding: 25px;
                border: 1px solid rgba(255, 255, 255, 0.6);
                box-shadow: 0px 8px 32px rgba(0, 0, 0, 0.15);
                display: flex;
                align-items: center;
                gap: 20px;
                transition: transform 0.3s ease;
            }
            .card:hover {
                transform: translateY(-5px);
                box-shadow: 0px 12px 40px rgba(0, 0, 0, 0.25);
            }
            .card-icon {
                width: 70px;
                height: 70px;
                border-radius: 16px;
                background: linear-gradient(135deg, #579c3f, #396728);
                display: flex;
                justify-content: center;
                align-items: center;
                box-shadow: 0 5px 15px rgba(87, 156, 63, 0.4);
            }
            .card-icon svg {
                width: 32px;
                height: 32px;
                fill: #ffffff;
            }
            .card-info h3 {
                margin: 0 0 5px 0;
                font-size: 15px;
                color: #4a5c43;
                text-transform: uppercase;
                font-weight: 700;
            }
            .card-info p {
                margin: 0;
                font-size: 34px;
                font-weight: 900;
                color: #1a2419;
                min-height: 40px; /* Giữ form khi chưa đổ Data */
            }
            /* ================= TABLE LOGS ================= */
            .table-container {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(15px);
                border-radius: 16px;
                padding: 30px;
                box-shadow: 0px 8px 32px rgba(0, 0, 0, 0.15);
                margin-bottom: 40px;
            }
            .section-title {
                color: #1a2419;
                font-size: 22px;
                font-weight: 700;
                margin-top: 0;
                margin-bottom: 25px;
            }
            .custom-table {
                width: 100%;
                border-collapse: collapse;
                text-align: left;
            }
            .custom-table th {
                padding: 16px;
                border-bottom: 2px solid #eef2f5;
                color: #7f8c8d;
                font-size: 13px;
                font-weight: 700;
                text-transform: uppercase;
            }
            .custom-table td {
                padding: 16px;
                border-bottom: 1px solid #eef2f5;
                color: #2c3e50;
                font-size: 14px;
                font-weight: 600;
            }
            .badge-action {
                background-color: #e67e22;
                color: white;
                padding: 5px 10px;
                border-radius: 6px;
                font-size: 12px;
            }
            /* ================= CSS-ONLY CHART ================= */
            .chart-wrapper {
                margin-bottom: 40px;
            }
            .bar-group {
                display: flex;
                align-items: center;
                margin-bottom: 20px;
            }
            .bar-title {
                width: 180px;
                font-weight: 700;
                color: #4a5c43;
                font-size: 14px;
                text-transform: uppercase;
            }
            .bar-bg {
                flex: 1;
                background-color: #eef2f5;
                border-radius: 20px;
                height: 35px;
                overflow: hidden;
                box-shadow: inset 0 2px 5px rgba(0,0,0,0.05);
            }
            .bar-fill {
                height: 100%;
                border-radius: 20px;
                display: flex;
                align-items: center;
                padding-left: 15px;
                color: white;
                font-weight: 800;
                font-size: 15px;
                text-shadow: 0 1px 2px rgba(0,0,0,0.2);
            }
            .fill-worker {
                background: linear-gradient(90deg, #579c3f, #7ed957);
            }
            .fill-stock {
                background: linear-gradient(90deg, #e67e22, #f39c12);
            }
            .fill-maint {
                background: linear-gradient(90deg, #c0392b, #e74c3c);
            }

            .btn-export {
                float: right;
                background: #2c3e50;
                color: white;
                padding: 10px 20px;
                text-decoration: none;
                border-radius: 8px;
                font-weight: bold;
                font-size: 14px;
            }
            .btn-export:hover {
                background: #1a252f;
            }
            /* ================= MODAL DANH SÁCH CÔNG NHÂN ================= */
            .worker-modal-overlay {
                position: fixed;
                inset: 0;
                background: rgba(0, 0, 0, 0.6);
                z-index: 1000;
                display: none;
                justify-content: center;
                align-items: center;
                backdrop-filter: blur(5px);
            }
            .worker-modal-content {
                background: #ffffff;
                width: 100%;
                max-width: 650px;
                border-radius: 16px;
                padding: 30px;
                box-shadow: 0 10px 40px rgba(0,0,0,0.3);
                position: relative;
                max-height: 85vh;
                overflow-y: auto;
            }
            .worker-modal-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
                border-bottom: 1px solid #eee;
                padding-bottom: 10px;
            }
            .worker-modal-header h3 {
                margin: 0;
                color: #2e541f;
                font-size: 20px;
                font-weight: 700;
            }
            .worker-close-btn {
                background: none;
                border: none;
                font-size: 24px;
                cursor: pointer;
                color: #999;
            }
            .worker-close-btn:hover {
                color: #e74c3c;
            }
            .clickable-card {
                cursor: pointer;
            }
            .dot-online {
                display: inline-block;
                width: 10px;
                height: 10px;
                background-color: #2ecc71;
                border-radius: 50%;
                margin-right: 5px;
                box-shadow: 0 0 5px #2ecc71;
            }
            .dot-offline {
                display: inline-block;
                width: 10px;
                height: 10px;
                background-color: #95a5a6;
                border-radius: 50%;
                margin-right: 5px;
            }
        </style>
    </head>
    <body>
        <jsp:include page="/views/common/sidebar.jsp">
            <jsp:param name="activePage" value="farmOwner" />
        </jsp:include>
        <div class="main-wrapper">
            <jsp:include page="/views/common/header.jsp">
                <jsp:param name="pageTitle" value="Báo Cáo Tổng Quan" />
            </jsp:include>
            <main class="content-area">
                <div class="welcome-panel">
                    <h2>
                    </h2>
                    <p>Khung điều hành trung tâm Smart Farm. Tình trạng canh tác và thông số vật tư đang được hệ thống thu thập và xử lý thời gian thực.</p>
                </div>

                <div class="dashboard-cards">
                    <!-- Thẻ 1: Công nhân ca làm -->
                    <div class="card clickable-card" onclick="openWorkerModal()">
                        <div class="card-icon"><svg viewBox="0 0 24 24"><path d="M16 11c1.66 0 2.99-1.34 2.99-3S17.66 5 16 5c-1.66 0-3 1.34-3 3s1.34 3 3 3zm-8 0c1.66 0 2.99-1.34 2.99-3S9.66 5 8 5C6.34 5 5 6.34 5 8s1.34 3 3 3zm0 2c-2.33 0-7 1.17-7 3.5V19h14v-2.5c0-2.33-4.67-3.5-7-3.5zm8 0c-.29 0-.62.02-.97.05 1.16.84 1.97 1.97 1.97 3.45V19h6v-2.5c0-2.33-4.67-3.5-7-3.5z"/></svg></div>
                        <div class="card-info">
                            <h3>Công nhân ca làm</h3>
                            <p>${workerCount} <span style="font-size: 14px; font-weight: 600; color: #7f8c8d;">người</span></p>
                        </div>
                    </div>

                    <!-- Thẻ 2: Vật tư chạm đáy -->
                    <div class="card">
                        <div class="card-icon"><svg viewBox="0 0 24 24"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-6h2v6zm0-8h-2V7h2v2z"/></svg></div>
                        <div class="card-info">
                            <h3>Vật tư chạm đáy</h3>
                            <p>${lowStockCount} <span style="font-size: 14px; font-weight: 600; color: #7f8c8d;">mặt hàng</span></p>
                        </div>
                    </div>

                    <!-- Thẻ 3: Đến hạn bảo trì (Hiển thị số liệu tĩnh tạm thời) -->
                    <div class="card">
                        <div class="card-icon"><svg viewBox="0 0 24 24"><path d="M19.14 12.94c.04-.3.06-.61.06-.94 0-.32-.02-.64-.06-.94l2.03-1.58c.18-.14.23-.41.12-.61l-1.92-3.32c-.12-.22-.37-.29-.59-.22l-2.39.96c-.5-.38-1.03-.7-1.62-.94l-.36-2.54c-.04-.24-.24-.41-.48-.41h-3.84c-.24 0-.43.17-.47.41l-.36 2.54c-.59.24-1.13.56-1.62.94l-2.39-.96c-.22-.08-.47 0-.59.22L2.74 8.87c-.12.21-.08.47.12.61l2.03 1.58c-.05.3-.09.63-.09.94s.02.64.06.94l-2.03 1.58c-.18.14-.23.41-.12.61l1.92 3.32c.12.22.37.29.59.22l2.39-.96c.5.38 1.03.7 1.62.94l.36 2.54c.05.24.24.41.48.41h3.84c.24 0 .43-.17.47-.41l.36-2.54c.59-.24 1.13-.56 1.62-.94l2.39.96c.22.08.47 0 .59-.22l1.92-3.32c.12-.22.07-.49-.12-.61l-2.01-1.58zM12 15.6c-1.98 0-3.6-1.62-3.6-3.6s1.62-3.6 3.6-3.6 3.6 1.62 3.6 3.6-1.62 3.6-3.6 3.6z"/></svg></div>
                        <div class="card-info">
                            <h3>Đến hạn bảo trì</h3>
                            <p>${maintenanceCount} <span style="font-size: 14px; font-weight: 600; color: #7f8c8d;">thiết bị</span></p>
                        </div>
                    </div>
                </div>

                <div class="table-container chart-wrapper">
                    <h2 class="section-title">Biểu Đồ Tỷ Trọng Hoạt Động</h2>

                    <div class="bar-group">
                        <div class="bar-title">Nhân sự đang bận</div>
                        <div class="bar-bg">
                            <div class="bar-fill fill-worker" style="width: ${workerCount * 2 > 10 ? workerCount * 2 : 10}%;">
                                ${workerCount} Người
                            </div>
                        </div>
                    </div>

                    <div class="bar-group">
                        <div class="bar-title">Vật tư cảnh báo</div>
                        <div class="bar-bg">
                            <div class="bar-fill fill-stock" style="width: ${lowStockCount * 5 > 10 ? lowStockCount * 5 : 10}%;">
                                ${lowStockCount} Mặt hàng
                            </div>
                        </div>
                    </div>

                    <div class="bar-group">
                        <div class="bar-title">Thiết bị bảo trì</div>
                        <div class="bar-bg">
                            <div class="bar-fill fill-maint" style="width: ${maintenanceCount * 10 > 10 ? maintenanceCount * 10 : 10}%;">
                                ${maintenanceCount} Máy
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Phần hiển thị Nhật Ký Hệ Thống -->
                <div class="table-container">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                        <h2 class="section-title" style="margin-bottom: 0;">Nhật Ký Hoạt Động Hệ Thống</h2>

                        <a href="farmowner?action=export" class="btn-export">📥 Xuất Báo Cáo (CSV)</a>
                    </div>
                    <table class="custom-table">
                        <thead>
                            <tr>
                                <th>Mã Log</th>
                                <th>Ngày Tháng</th>
                                <th>Giờ</th>
                                <th>Người Dùng</th>
                                <th>Hành Động</th>
                                <th>Bảng Dữ Liệu</th>
                                <th>Địa Chỉ IP</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- Lặp qua danh sách systemLogs được gửi từ Servlet -->
                            <c:forEach var="log" items="${systemLogs}">
                                <tr>
                                    <td>#${log.getMaNhatKy()}</td>
                                    <!-- Cắt chuỗi thời gian để tách Ngày và Giờ (Ví dụ định dạng: 2026-07-25T02:59:05.893) -->
                                    <td>${fn:substringBefore(log.getThoiGian(), 'T')}</td>
                                    <td>${fn:substringAfter(log.getThoiGian(), 'T')}</td>
                                    <td>Mã số: ${log.getMaNguoiDung()}</td>
                                    <td><span class="badge-action">${log.getHanhDong()}</span></td>
                                    <td>${log.getBangTacDong()}</td>
                                    <td>${log.getDiaChiIP()}</td>
                                </tr>
                            </c:forEach>

                            <!-- Hiển thị khi chưa có dữ liệu -->
                            <c:if test="${empty systemLogs}">
                                <tr>
                                    <td colspan="7" style="text-align: center; color: #7f8c8d; padding: 20px;">
                                        Hệ thống chưa ghi nhận hoạt động nào.
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </main>
        </div>


        <!-- Modal Hiển Thị Danh Sách Công Nhân Ca Làm -->
        <div class="worker-modal-overlay" id="workerModalOverlay">
            <div class="worker-modal-content" style="max-width: 800px;">
                <div class="worker-modal-header">
                    <h3>Danh sách công nhân đang làm việc (${workerCount} người)</h3>
                    <button class="worker-close-btn" onclick="closeWorkerModal()">&times;</button>
                </div>

                <table class="custom-table" style="font-size: 14px;">
                    <thead>
                        <tr>
                            <th>Mã Nhân Viên</th>
                            <th>Mã Người Dùng</th>
                            <th>Họ và Tên</th>
                            <th>Trạng thái</th> <!-- Thêm cột Trạng Thái -->
                            <th>Số Điện Thoại</th>
                            <th>Email</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="worker" items="${activeWorkersList}">
                            <!-- Logic kiểm tra Online/Offline (Thời gian quá hạn: 5 phút = 300,000 milliseconds) -->
                            <c:set var="isOnline" value="false" />
                            <c:set var="lastActiveTime" value="${activeUsersMap[worker.getMaNguoiDung()]}" />

                            <c:if test="${not empty lastActiveTime}">
                                <c:if test="${(currentTimeMillis - lastActiveTime) <= 300000}">
                                    <c:set var="isOnline" value="true" />
                                </c:if>
                            </c:if>

                            <tr>
                                <td>#${worker.getMaNhanVien()}</td>
                                <td>#${worker.getMaNguoiDung()}</td>
                                <td><strong>${worker.getHoTen()}</strong></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${isOnline}">
                                            <span style="color: #27ae60; font-weight: bold;"><span class="dot-online"></span>Online</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: #7f8c8d; font-weight: bold;"><span class="dot-offline"></span>Offline</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${worker.getSDT()}</td>
                                <td>${worker.getEmail()}</td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty activeWorkersList}">
                            <tr>
                                <td colspan="6" style="text-align: center; color: #7f8c8d; padding: 20px;">
                                    Không có dữ liệu công nhân ca làm.
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>

                <div style="margin-top: 20px; text-align: right;">
                    <button type="button" class="btn-cancel" onclick="closeWorkerModal()" style="padding: 8px 16px; background: #e74c3c; color: white; border: none; border-radius: 6px; cursor: pointer; font-weight: bold;">Đóng</button>
                </div>
            </div>
        </div>

        <script>
            function openWorkerModal() {
                document.getElementById('workerModalOverlay').style.display = 'flex';
            }
            function closeWorkerModal() {
                document.getElementById('workerModalOverlay').style.display = 'none';
            }
            window.addEventListener('click', function (e) {
                const overlay = document.getElementById('workerModalOverlay');
                if (e.target === overlay) {
                    overlay.style.display = 'none';
                }
            });
        </script>
    </body>
</html>

