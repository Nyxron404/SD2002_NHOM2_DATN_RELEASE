<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
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

            /* THANH TÌM KIẾM */
            .search-box {
                display: flex;
                align-items: center;
                background: white;
                border-radius: 8px;
                padding: 4px 10px;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            }
            .search-box input {
                border: none;
                outline: none;
                padding: 8px 10px;
                width: 250px;
                font-size: 14px;
            }
            .btn-search {
                background: #f39c12;
                color: white;
                border: none;
                padding: 8px 15px;
                border-radius: 6px;
                font-weight: 600;
                cursor: pointer;
                transition: 0.3s;
            }
            .btn-search:hover {
                background: #e67e22;
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
                    <div style="display: flex; align-items: center; gap: 15px;">
                        <form action="worker" method="GET" class="search-box" autocomplete="off">
                            <input type="text" name="keyword" placeholder="Nhập tên việc, Mã việc, hoặc Mã nhân sự..." 
                                   value="${param.keyword}" autocomplete="off">
                            <button type="submit" class="btn-search">🔍 Tìm kiếm</button>
                        </form>
                        <button class="btn-add" id="openModalBtn">+ Phân công mới</button>
                    </div>
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
                                        <c:choose>
                                            <c:when test="${task.getTrangThai() eq 'Hoàn thành'}">
                                                <span style="color: #7f8c8d; font-size: 13px; font-style: italic;">Nhiệm vụ đã hoàn thành</span>
                                            </c:when>

                                            <c:when test="${task.getTrangThai() eq 'Đã hủy'}">
                                                <span style="color: #7f8c8d; font-size: 13px; font-style: italic;">Công việc đã bị hủy</span>
                                            </c:when>

                                            <c:otherwise>
                                                <button onclick="openReportModal(${task.getMaCongViec()}, ${task.getNguoiPhuTrach()})" class="action-link" style="border:none; background:none; cursor:pointer; color:#579c3f; font-weight: 700;">Báo cáo</button>
                                                <button type="button" onclick="cancelTask(${task.getMaCongViec()})" class="action-link" style="border:none; background:none; cursor:pointer; color: #e74c3c; font-weight: 700;">Hủy việc</button>
                                            </c:otherwise>
                                        </c:choose>

                                        <!-- Đã đưa nút Xem chi tiết ra ngoài khối c:choose -->
                                        <br>
                                        <button onclick="openDetailModal('${task.getMaCongViec()}')" class="action-link" style="color: #3498db; border:none; background:none; cursor:pointer; font-weight: 700;">Xem chi tiết</button>
                                        <div id="mota-${task.getMaCongViec()}" style="display:none;">${task.getMoTa()}</div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                    <c:if test="${not empty param.keyword && empty taskList}">
                        <div style="text-align: center; padding: 20px; color: #777;">
                            <p>Không tìm thấy công việc phù hợp với từ khóa: <strong>${param.keyword}</strong></p>
                        </div>
                    </c:if>
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
                                <th>Người Phụ Trách</th>
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
                                    <td>#${log.getMaChamCong()}</td>
                                    <td>Công nhân ${log.getMaNguoiDung()}</td>
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
                                        <c:choose>
                                            <c:when test="${log.isTrangThaiDuyet()}">
                                                <span style="color: #7f8c8d; font-size: 13px; font-style: italic;">Đã hoàn tất</span>
                                            </c:when>
                                            <c:otherwise>
                                                <form action="worker?action=approve_salary" method="POST" style="display:inline;">
                                                    <input type="hidden" name="maChamCong" value="${log.getMaChamCong()}">
                                                    <button type="submit" class="action-link" style="border:none; background:none; cursor:pointer; color: #27ae60; font-weight: 700;" onclick="return confirm('Xác nhận chốt lương cho mã công #${log.getMaChamCong()}?');">Chốt lương</button>
                                                </form>

                                                <c:set var="checkStr" value=",${log.getMaChamCong()}," />
                                                <c:choose>
                                                    <c:when test="${fn:contains(sessionScope.reportedErrors, checkStr)}">
                                                        <span style="color: #95a5a6; font-size: 13px; font-style: italic; margin-left: 10px;">Đã báo cáo</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <button type="button" onclick="openErrorModal(${log.getMaChamCong()})" class="action-link" style="border:none; background:none; cursor:pointer; color: #e74c3c; font-weight: 700; margin-left: 10px;">Báo cáo sai sót</button>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>

                            <c:if test="${empty attendanceList}">
                                <tr>áo hoàn thành công việc để hệ thống tính công tự động!
                                    </td>
                                    <td colspan="6" style="text-align: center; color: #7f8c8d; padding: 20px;">
                                        Chưa có dữ liệu ngày công nào được ghi nhận. Hãy báo c
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
                    <input type="hidden" name="maCongViec" id="reportMaCongViec"> 
                    <input type="hidden" name="nguoiPhuTrach" id="reportNguoiPhuTrach">
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

        <!-- Modal Báo cáo sai sót ngày công -->
        <div class="modal-overlay" id="errorModal">
            <div class="modal-container">
                <button class="modal-close" onclick="closeErrorModal()">&times;</button>
                <h3 class="modal-title" style="color: #e74c3c;">Báo cáo sai sót ngày công</h3>
                <form action="worker?action=report_error" method="POST">
                    <!-- Gửi kèm mã chấm công -->
                    <input type="hidden" name="maChamCong" id="errorMaChamCong"> 

                    <div class="form-group">
                        <label>Mô tả chi tiết sai sót:</label>
                        <textarea name="lyDo" placeholder="Ví dụ: Tính sai hệ số, thiếu giờ làm..." required style="border-color: #e74c3c;"></textarea>
                    </div>

                    <button type="submit" class="btn-submit" style="background: #e74c3c;">Gửi báo cáo cho Quản lý</button>
                </form>
            </div>
        </div>

        <!-- Form ẩn dùng để gửi yêu cầu Hủy việc -->
        <form id="cancelForm" action="worker?action=cancel" method="POST" style="display:none;">
            <input type="hidden" name="maCongViec" id="cancelMaCongViec">
        </form>

        <script>
            function cancelTask(maCongViec) {
                if (confirm('Bạn có chắc chắn muốn hủy công việc mã số ' + maCongViec + ' này không? Hành động này sẽ được ghi vào nhật ký hệ thống.')) {
                    document.getElementById('cancelMaCongViec').value = maCongViec;
                    document.getElementById('cancelForm').submit();
                }
            }

            const openModalBtn = document.getElementById('openModalBtn');
            const closeModalBtn = document.getElementById('closeModalBtn');
            const modalOverlay = document.getElementById('modalOverlay');
            openModalBtn.addEventListener('click', () => modalOverlay.classList.add('active'));
            closeModalBtn.addEventListener('click', () => modalOverlay.classList.remove('active'));
            modalOverlay.addEventListener('click', (e) => {
                if (e.target === modalOverlay)
                    modalOverlay.classList.remove('active');
            });

            // SỬA ĐOẠN NÀY ĐỂ MỞ MODAL BÁO CÁO
            function openReportModal(id, nguoiPhuTrach) {
                document.getElementById('reportMaCongViec').value = id;
                document.getElementById('reportNguoiPhuTrach').value = nguoiPhuTrach;
                document.getElementById('reportModal').classList.add('active');
            }

            function closeReportModal() {
                document.getElementById('reportModal').classList.remove('active');
            }

            // Đảm bảo nút đóng hoạt động
            document.getElementById('closeModalBtn').addEventListener('click', () => {
                document.getElementById('modalOverlay').classList.remove('active');
            });
            // Hàm mở Modal Chi tiết
            function openDetailModal(maCongViec) {
                // 1. Lấy nội dung mô tả gộp từ thẻ div ẩn
                let rawText = document.getElementById('mota-' + maCongViec).innerHTML;

                // 2. Tách chuỗi dựa vào khoảng trắng và dấu gạch đứng " | "
                let parts = rawText.split(' | ');

                let moTaGoc = parts[0] || "Không có mô tả chi tiết";
                let ghiChu = "Chưa có báo cáo";
                let linkAnh = "Chưa có";

                if (parts.length > 1) {
                    ghiChu = parts[1].replace('Ghi chú vật tư: ', '').trim();
                }
                if (parts.length > 2) {
                    linkAnh = parts[2].replace('Ảnh văn bản: ', '').trim();
                }

                // 3. Regex kiểm tra xem chuỗi có phải là URL hợp lệ không (bắt đầu bằng http hoặc https)
                const urlRegex = /^(https?:\/\/[^\s]+)/g;
                let isRealLink = urlRegex.test(linkAnh);

                let anhHtml = "";

                if (linkAnh === "Chưa có" || linkAnh === "") {
                    // Chưa điền gì cả
                    anhHtml = '<span style="color: #7f8c8d; font-style: italic;">Chưa có ảnh đính kèm</span>';
                } else if (isRealLink) {
                    // Là link thật, render thẻ a
                    anhHtml = '<a href="' + linkAnh + '" target="_blank" style="color: #3498db; text-decoration: underline; word-break: break-all;">Bấm để xem ảnh</a>';
                } else {
                    // Nhập text bậy bạ, không phải link, cảnh báo và in ra nội dung họ nhập
                    anhHtml = '<span style="color: #e74c3c; font-weight: 600;">Link ảnh không hợp lệ!</span><br><span style="color: #7f8c8d; font-size: 13px;">(Nội dung nhập sai: ' + linkAnh + ')</span>';
                }

                // 4. Tạo giao diện 3 CỘT DỌC
                let htmlContent =
                        '<div style="display: flex; gap: 20px; justify-content: space-between;">' +
                        // Cột 1: Mô tả
                        '<div style="flex: 1; background: #fff; padding: 15px; border-radius: 8px; border: 1px solid #eef2f5;">' +
                        '<strong style="color: #2e541f; font-size: 15px; display: block; border-bottom: 2px solid #579c3f; padding-bottom: 5px; margin-bottom: 10px;">📝 Mô Tả Việc</strong>' +
                        '<div style="color: #2c3e50; font-size: 14px;">' + moTaGoc + '</div>' +
                        '</div>' +
                        // Cột 2: Ghi chú vật tư
                        '<div style="flex: 1; background: #fff; padding: 15px; border-radius: 8px; border: 1px solid #eef2f5;">' +
                        '<strong style="color: #2e541f; font-size: 15px; display: block; border-bottom: 2px solid #e67e22; padding-bottom: 5px; margin-bottom: 10px;">🛠 Vật Tư</strong>' +
                        '<div style="color: #e67e22; font-size: 14px; font-weight: 600;">' + ghiChu + '</div>' +
                        '</div>' +
                        // Cột 3: Link ảnh
                        '<div style="flex: 1; background: #fff; padding: 15px; border-radius: 8px; border: 1px solid #eef2f5;">' +
                        '<strong style="color: #2e541f; font-size: 15px; display: block; border-bottom: 2px solid #3498db; padding-bottom: 5px; margin-bottom: 10px;">📸 Ảnh Gửi Kèm</strong>' +
                        '<div style="font-size: 14px;">' + anhHtml + '</div>' +
                        '</div>' +
                        '</div>';

                // 5. Đổ nội dung mới vào Modal và hiển thị
                document.getElementById('detailContent').innerHTML = htmlContent;
                document.getElementById('detailModal').classList.add('active');
            }

            // Hàm đóng Modal Chi tiết
            function closeDetailModal() {
                document.getElementById('detailModal').classList.remove('active');
            }

            // Hàm mở Modal Báo cáo sai sót
            function openErrorModal(maChamCong) {
                document.getElementById('errorMaChamCong').value = maChamCong;
                document.getElementById('errorModal').classList.add('active');
            }

            // Hàm đóng Modal Báo cáo sai sót
            function closeErrorModal() {
                document.getElementById('errorModal').classList.remove('active');
            }
        </script>
        <!-- Modal Xem Chi Tiết -->
        <div class="modal-overlay" id="detailModal">
            <div class="modal-container">
                <button class="modal-close" onclick="closeDetailModal()">&times;</button>
                <h3 class="modal-title">Chi tiết công việc</h3>
                <div id="detailContent" style="font-size: 15px; color: #2c3e50; line-height: 1.6; white-space: pre-wrap; background: #f8f9fa; padding: 15px; border-radius: 8px;">
                    <!-- Nội dung mô tả sẽ được Javascript đẩy vào đây -->
                </div>
            </div>
        </div>
        <c:if test="${not empty sessionScope.thongBao}">
            <script>
                // Hiển thị popup thông báo
                alert('${sessionScope.thongBao}');
            </script>
            <!-- Xóa thông báo đi để lần sau không hiện lại nếu chỉ F5 trang -->
            <c:remove var="thongBao" scope="session"/>
        </c:if>
    </body>
</html>