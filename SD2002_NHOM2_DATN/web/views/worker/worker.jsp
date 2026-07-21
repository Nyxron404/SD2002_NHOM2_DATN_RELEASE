<%-- 
    Document   : worker
    Created on : Jun 23, 2026, 2:14:09 PM
    Author     : longd
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Smart Farmer - Nhiệm Vụ Công Nhân</title>
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

            /* ================= HEADER ================= */
            .header {
                height: 85px;
                background: rgba(255, 255, 255, 0.85);
                backdrop-filter: blur(20px);
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
            }
            .notification svg {
                width: 22px;
                height: 22px;
                fill: #2e541f;
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
            }

            /* ================= CONTENT AREA & TABLE ================= */
            .content-area {
                flex: 1;
                padding: 40px;
                overflow-y: auto;
            }

            .section-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 25px;
            }
            .section-title {
                color: #ffffff;
                font-size: 22px;
                font-weight: 700;
                margin: 0;
            }

            .btn-add {
                background-color: #579c3f;
                color: white;
                border: none;
                padding: 12px 20px;
                font-size: 14px;
                font-weight: 600;
                border-radius: 8px;
                cursor: pointer;
                display: flex;
                align-items: center;
                gap: 8px;
                box-shadow: 0 4px 12px rgba(87, 156, 63, 0.3);
                transition: all 0.3s;
                text-decoration: none;
            }
            .btn-add:hover {
                background-color: #467e32;
                transform: translateY(-1px);
            }

            .table-container {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(15px);
                border-radius: 16px;
                padding: 30px;
                box-shadow: 0px 8px 32px rgba(0, 0, 0, 0.15);
            }
            .data-info {
                font-size: 14px;
                color: #555;
                margin-bottom: 20px;
                font-weight: 500;
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

            .status-badge {
                background-color: #e67e22;
                color: white;
                padding: 5px 10px;
                border-radius: 12px;
                font-size: 12px;
                font-weight: 700;
                display: inline-block;
            }
            .action-link {
                color: #3498db;
                text-decoration: none;
                margin-right: 10px;
            }
            .action-link:hover {
                text-decoration: underline;
            }

            /* ================= MODAL POPUP ================= */
            .modal-overlay {
                position: fixed;
                inset: 0;
                background: rgba(0, 0, 0, 0.6);
                display: flex;
                justify-content: center;
                align-items: center;
                z-index: 999;
                opacity: 0;
                pointer-events: none;
                transition: opacity 0.3s ease;
            }
            .modal-overlay.active {
                opacity: 1;
                pointer-events: auto;
            }

            .modal-container {
                background: #ffffff;
                width: 100%;
                max-width: 650px;
                border-radius: 16px;
                padding: 35px;
                box-shadow: 0 10px 40px rgba(0,0,0,0.3);
                position: relative;
                transform: translateY(-30px);
                transition: transform 0.3s ease;
            }
            .modal-overlay.active .modal-container {
                transform: translateY(0);
            }

            .modal-close {
                position: absolute;
                top: 20px;
                right: 20px;
                background: none;
                border: none;
                font-size: 24px;
                color: #aaa;
                cursor: pointer;
            }
            .modal-close:hover {
                color: #333;
            }

            .modal-title {
                font-size: 22px;
                font-weight: 800;
                color: #1a2419;
                margin-top: 0;
                margin-bottom: 20px;
            }

            .uc-info {
                font-size: 13px;
                color: #4a5c43;
                margin-bottom: 20px;
                background: rgba(87, 156, 63, 0.1);
                padding: 10px 12px;
                border-radius: 6px;
                border-left: 4px solid #579c3f;
                font-weight: 600;
            }

            .form-row {
                display: flex;
                gap: 20px;
                margin-bottom: 18px;
            }
            .form-group {
                flex: 1;
            }
            .form-group label {
                display: block;
                font-weight: 700;
                margin-bottom: 8px;
                color: #1a2419;
                font-size: 14px;
            }
            .form-group input[type="text"], .form-group input[type="date"], .form-group select, .form-group textarea {
                width: 100%;
                padding: 12px;
                border: 1px solid #ccc;
                border-radius: 8px;
                font-size: 14px;
                box-sizing: border-box;
            }
            .form-group textarea {
                resize: vertical;
                height: 70px;
            }

            .btn-submit {
                width: 100%;
                background: #579c3f;
                color: white;
                border: none;
                padding: 14px;
                font-size: 15px;
                font-weight: bold;
                border-radius: 8px;
                cursor: pointer;
                margin-top: 10px;
                transition: background 0.3s;
            }
            .btn-submit:hover {
                background: #467e32;
            }
            .note-panel {
                margin-top: 15px;
                font-size: 12px;
                color: #c0392b;
                font-style: italic;
                background: #fdf2e9;
                padding: 10px;
                border-radius: 6px;
                border-left: 4px solid #e67e22;
            }
        </style>
    </head>
    <body>

        <jsp:include page="/views/common/sidebar.jsp">
            <jsp:param name="activePage" value="worker" />
        </jsp:include>

        <div class="main-wrapper">
            <jsp:include page="/views/common/header.jsp">
                <jsp:param name="pageTitle" value="Công Việc" />
            </jsp:include>

            <main class="content-area">
                <div class="section-header">
                    <h2 class="section-title">Danh sách phân công nhiệm vụ</h2>
                    <button class="btn-add" id="openModalBtn">+ Phân công mới</button>
                </div>

                <div class="table-container">
                    <div class="data-info">Số lượng công việc đang triển khai: ${taskList != null ? taskList.size() : 0}</div>
                    <table class="custom-table">
                        <thead>
                            <tr>
                                <th>Mã Việc</th>
                                <th>Tên Công Việc</th>
                                <th>Khu Vực</th>
                                <th>Người Phụ Trách</th>
                                <th>Hạn Chót</th>
                                <th>Trạng Thái</th>
                                <th>Hành Động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="task" items="${taskList}">
                                <tr>
                                    <td>${task.getMaCongViec()}</td>
                                    <td>${task.getTenCongViec()}</td>
                                    <td>Khu ${task.getMaKhuVuc()}</td>
                                    <td>Công nhân ${task.getNguoiPhuTrach()}</td>
                                    <td>${task.getNgayKetThuc()}</td>
                                    <td>
                                        <!-- Đổi màu sắc badge theo trạng thái thực tế -->
                                        <c:choose>
                                            <c:when test="${task.getTrangThai() eq 'Hoàn thành'}">
                                                <span class="status-badge" style="background-color: #27ae60;">Hoàn thành</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-badge" style="background-color: #e67e22;">${task.getTrangThai()}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>

                                            <c:when test="${task.getTrangThai() eq 'Hoàn thành'}">
                                                <span style="color: #7f8c8d; font-size: 13px; font-style: italic;">Nhiệm vụ đã hoàn thành</span>
                                            </c:when>

                                            <c:otherwise>
                                                <button onclick="openReportModal(${task.getMaCongViec()})" class="action-link" style="border:none; background:none; cursor:pointer; color:#579c3f; font-weight: 700;">Báo cáo</button>
                                                <a href="#" class="action-link" style="color: #e74c3c;">Hủy việc</a>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
                <!-- ================= BẢNG LỊCH SỬ NGÀY CÔNG (UC-9.3) ================= -->
                <div class="section-header" style="margin-top: 40px;">
                    <h2 class="section-title">Tra cứu lịch sử ngày công (Tháng này)</h2>
                </div>

                <div class="table-container">
                    <div class="data-info">Toàn bộ công việc đã hoàn thành và được hệ thống tự động quy đổi thành ngày công.</div>
                    <table class="custom-table">
                        <thead>
                            <tr>
                                <th>Mã Chấm Công</th>
                                <th>Mã Việc Hoàn Thành</th>
                                <th>Ngày Tích Lũy</th>
                                <th>Số Công (Hệ Số)</th>
                                <th>Trạng Thái Duyệt</th>
                                <th>Hành Động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="log" items="${attendanceList}">
                                <tr>
                                    <!-- Hiển thị đúng các thuộc tính từ model AttendanceLog -->
                                    <td>#${log.getMaChamCong()}</td>
                                    <td>Mã số: ${log.getMaCongViec()}</td>
                                    <td>${log.getNgayTichLuy()}</td>
                                    <td style="color: #27ae60; font-weight: 800; font-size: 16px;">
                                        + ${log.getSoCongTichLuy()}
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${log.isTrangThaiDuyet()}">
                                                <span class="status-badge" style="background-color: #27ae60;">Đã chốt lương</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-badge" style="background-color: #f39c12;">Đang chờ duyệt</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <!-- Chức năng báo lỗi theo Luồng chạy B4 của UC-9.3 -->
                                        <a href="#" class="action-link" style="color: #e74c3c;">Báo cáo sai sót</a>
                                    </td>
                                </tr>
                            </c:forEach>

                            <!-- Bắt lỗi giao diện nếu chưa có dữ liệu -->
                            <c:if test="${empty attendanceList}">
                                <tr>
                                    <td colspan="6" style="text-align: center; color: #7f8c8d; padding: 20px;">
                                        Chưa có dữ liệu ngày công nào được ghi nhận. Hãy báo cáo hoàn thành công việc để hệ thống tính công tự động!
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </main>
        </div>

        <div class="modal-overlay" id="modalOverlay">
            <div class="modal-container">
                <button class="modal-close" id="closeModalBtn">&times;</button>
                <h3 class="modal-title">Khởi tạo và Phân công việc</h3>

                <form action="worker" method="POST">
                    <div class="form-row">
                        <!-- Cập nhật danh sách Lô đất -->
                        <div class="form-group">
                            <label for="maKhuVuc">Chọn Lô Đất / Khu Vực:</label>
                            <select id="maKhuVuc" name="maKhuVuc" required>
                                <option value="">-- Chọn khu vực --</option>
                                <c:forEach var="area" items="${farmAreaList}">
                                    <option value="${area.getMaKhuVuc()}">${area.getTenKhuVuc()}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <!-- Cập nhật danh sách Quy trình -->
                        <div class="form-group">
                            <label for="maQuyTrinh">Quy Trình Mẫu Áp Dụng:</label>
                            <select id="maQuyTrinh" name="maQuyTrinh" required>
                                <option value="">-- Tự động gợi ý quy trình --</option>
                                <c:forEach var="practice" items="${farmingPracticeList}">
                                    <option value="${practice.getMaQuyTrinh()}">${practice.getTenQuyTrinh()}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="tenCongViec">Tên Công Việc Nhiệm Vụ:</label>
                        <input type="text" id="tenCongViec" name="tenCongViec" placeholder="Nhập tên nhiệm vụ cụ thể..." required>
                    </div>

                    <div class="form-group">
                        <label for="moTa">Mô Tả Chi Tiết Hướng Dẫn:</label>
                        <textarea id="moTa" name="moTa" placeholder="Ghi chú các bước thực hiện nếu có..."></textarea>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="nguoiPhuTrach">Chọn Công Nhân Phụ Trách:</label>
                            <select id="nguoiPhuTrach" name="nguoiPhuTrach" required>
                                <option value="">-- Chọn công nhân --</option>
                                <c:forEach var="worker" items="${workerList}">
                                    <option value="${worker.getMaNguoiDung()}">${worker.getHoTen()} (Mã: ${worker.getMaNguoiDung()})</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="ngayBatDau">Ngày Bắt Đầu:</label>
                            <input type="date" id="ngayBatDau" name="ngayBatDau" required>
                        </div>
                        <div class="form-group">
                            <label for="ngayKetThuc">Hạn Chót (Ngày Kết Thúc):</label>
                            <input type="date" id="ngayKetThuc" name="ngayKetThuc" required>
                        </div>
                    </div>

                    <button type="submit" class="btn-submit">Xác Nhận Giao Việc</button>

                    <div class="note-panel">
                        * Hệ thống tích hợp cơ chế tự động quét lịch để tránh trùng lặp, quá tải ngày làm việc của công nhân.
                    </div>
                </form>
            </div>
        </div>
        <!-- Modal Báo cáo hoàn thành -->
        <div class="modal-overlay" id="reportModal">
            <div class="modal-container">
                <button class="modal-close" onclick="closeReportModal()">&times;</button>
                <h3 class="modal-title">Báo cáo hoàn thành công việc</h3>
                <form action="worker?action=report" method="POST">
                    <input type="hidden" name="maCongViec" id="reportMaCongViec"> <!-- ID PHẢI KHỚP VỚI JS -->
                    <div class="form-group">
                        <label>Ghi chú vật tư sử dụng:</label>
                        <textarea name="ghiChuVatTu" required></textarea>
                    </div>
                    <div class="form-group">
                        <label>Đường dẫn ảnh hiện trường:</label>
                        <input type="text" name="chuoiAnhHienTruong" placeholder="Dán link ảnh tại đây...">
                    </div>

                    <button type="submit" class="btn-submit">Xác nhận hoàn thành</button>
                </form>
            </div>
        </div>

        <script>
            const openModalBtn = document.getElementById('openModalBtn');
            const closeModalBtn = document.getElementById('closeModalBtn');
            const modalOverlay = document.getElementById('modalOverlay');
            openModalBtn.addEventListener('click', () => modalOverlay.classList.add('active'));
            closeModalBtn.addEventListener('click', () => modalOverlay.classList.remove('active'));
            modalOverlay.addEventListener('click', (e) => {
                if (e.target === modalOverlay)
                    modalOverlay.classList.remove('active');
            });

            function openReportModal(id) {
                // Gán ID công việc vào input ẩn
                document.getElementById('reportMaCongViec').value = id;
                // Thêm class 'active' vào overlay
                document.getElementById('reportModal').classList.add('active');
            }

            function closeReportModal() {
                document.getElementById('reportModal').classList.remove('active');
            }

            // Đảm bảo nút đóng hoạt động
            document.getElementById('closeModalBtn').addEventListener('click', () => {
                document.getElementById('modalOverlay').classList.remove('active');
            });
        </script>
    </script>
</body>
</html>