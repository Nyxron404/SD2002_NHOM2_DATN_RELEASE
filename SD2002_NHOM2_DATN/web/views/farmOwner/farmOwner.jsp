<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Smart Farmer - Báo Cáo Tổng Quan</title>
        <style>
            /* CSS GỘP CHUNG CHO CẢ TRANG */
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

            /* BÁO CÁO CSS */
            .section-header {
                margin-bottom: 30px;
                color: #fff;
            }
            .section-header h2 {
                font-size: 28px;
                margin: 0;
                text-shadow: 0 2px 4px rgba(0,0,0,0.3);
            }
            .report-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                gap: 25px;
                margin-bottom: 30px;
            }
            .report-card {
                background: rgba(255, 255, 255, 0.95);
                border-radius: 16px;
                padding: 25px;
                box-shadow: 0 8px 32px rgba(0,0,0,0.15);
            }
            .report-card h3 {
                color: #2e541f;
                margin-top: 0;
                font-size: 18px;
                border-bottom: 2px solid #e8f5e9;
                padding-bottom: 10px;
            }
            .stat-item {
                display: flex;
                justify-content: space-between;
                padding: 10px 0;
                border-bottom: 1px solid #eee;
            }
            .stat-label {
                color: #555;
                font-weight: 600;
            }
            .stat-value {
                color: #1a2419;
                font-weight: 800;
            }
            .chart-placeholder {
                height: 200px;
                background: #f9f9f9;
                border: 2px dashed #ddd;
                display: flex;
                align-items: center;
                justify-content: center;
                color: #999;
                margin-top: 15px;
                border-radius: 8px;
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
                <div class="section-header">
                    <h2>Báo cáo hiệu suất trang trại (Tháng 07/2026)</h2>
                </div>

                <div class="report-grid">
                    <div class="report-card">
                        <h3>Sản lượng thu hoạch</h3>
                        <div class="stat-item"><span class="stat-label">Lúa ST25:</span> <span class="stat-value">12.5 Tấn</span></div>
                        <div class="stat-item"><span class="stat-label">Rau sạch:</span> <span class="stat-value">850 Kg</span></div>
                        <div class="stat-item"><span class="stat-label">Thịt heo:</span> <span class="stat-value">2.2 Tấn</span></div>
                        <div class="chart-placeholder">Biểu đồ sản lượng</div>
                    </div>

                    <div class="report-card">
                        <h3>Tài chính & Chi phí</h3>
                        <div class="stat-item"><span class="stat-label">Tổng thu:</span> <span class="stat-value" style="color: #27ae60;">450.000.000 VNĐ</span></div>
                        <div class="stat-item"><span class="stat-label">Tổng chi:</span> <span class="stat-value" style="color: #c0392b;">120.000.000 VNĐ</span></div>
                        <div class="stat-item"><span class="stat-label">Lợi nhuận:</span> <span class="stat-value">330.000.000 VNĐ</span></div>
                        <div class="chart-placeholder">Biểu đồ lợi nhuận</div>
                    </div>

                    <div class="report-card">
                        <h3>Hiệu suất nhân lực</h3>
                        <div class="stat-item"><span class="stat-label">Số ca làm:</span> <span class="stat-value">142 ca</span></div>
                        <div class="stat-item"><span class="stat-label">Số công việc hoàn thành:</span> <span class="stat-value">98</span></div>
                        <div class="stat-item"><span class="stat-label">Tỉ lệ đạt KPI:</span> <span class="stat-value" style="color: #3498db;">94%</span></div>
                        <div class="chart-placeholder">Biểu đồ nhân sự</div>
                    </div>
                </div>
            </main>
        </div>
    </body>
</html>