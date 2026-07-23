<%-- 
    Document   : technician
    Created on : Jun 23, 2026, 0:00:00 PM
    Author     : pminh
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Smart Farmer - Thiết Lập Quy Trình</title>
        <style>
            * {
                box-sizing: border-box;
            }

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
                padding: 30px 40px;
                overflow-y: auto;
            }

            .section-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 25px;
                flex-wrap: wrap;
                gap: 15px;
            }

            .section-title {
                color: #ffffff;
                font-size: 24px;
                font-weight: 700;
                margin: 0;
                flex: 1 1 auto;
                text-shadow: 1px 1px 3px rgba(0,0,0,0.3);
            }

            .header-actions {
                display: flex;
                gap: 12px;
                align-items: center;
                flex-wrap: wrap;
            }

            .search-form {
                display: flex;
                gap: 8px;
                margin: 0;
                align-items: center;
            }

            .search-input {
                padding: 0 15px;
                height: 42px;
                border: 1px solid #ccc;
                border-radius: 8px;
                outline: none;
                font-family: inherit;
                font-size: 14px;
                width: 260px;
                transition: 0.3s;
            }

            .search-input:focus {
                border-color: #579c3f;
                box-shadow: 0 0 5px rgba(87,156,63,0.3);
            }

            .btn-search {
                background-color: #2c3e50;
                color: white;
                border: none;
                height: 42px;
                padding: 0 20px;
                border-radius: 8px;
                cursor: pointer;
                font-weight: 600;
                font-size: 14px;
                transition: 0.3s;
                display: inline-flex;
                align-items: center;
                justify-content: center;
            }

            .btn-search:hover {
                background-color: #1a252f;
            }

            .btn-add {
                background-color: #579c3f !important;
                color: white !important;
                border: none !important;
                height: 42px;
                padding: 0 20px !important;
                font-size: 14px !important;
                font-weight: 600 !important;
                border-radius: 8px !important;
                cursor: pointer;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                gap: 8px;
                box-shadow: 0 4px 12px rgba(87, 156, 63, 0.3);
                transition: all 0.3s;
                text-decoration: none;
            }

            .btn-add:hover {
                background-color: #467e32 !important;
                transform: translateY(-1px);
            }

            .table-container {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(15px);
                border-radius: 12px;
                padding: 25px;
                box-shadow: 0px 8px 32px rgba(0, 0, 0, 0.15);
                overflow-x: auto;
            }

            .data-info {
                font-size: 14px;
                color: #555;
                margin-bottom: 15px;
                font-weight: 600;
            }

            .custom-table {
                width: 100%;
                border-collapse: collapse;
                text-align: left;
            }

            .custom-table th {
                padding: 14px 16px;
                border-bottom: 2px solid #eef2f5;
                color: #637381;
                font-size: 13px;
                font-weight: 700;
                text-transform: uppercase;
                white-space: nowrap;
            }

            .custom-table td {
                padding: 14px 16px;
                border-bottom: 1px solid #eef2f5;
                color: #212b36;
                font-size: 14px;
                font-weight: 500;
                vertical-align: middle;
            }

            .custom-table tr:hover td {
                background-color: #f9fafb;
            }

            .status-badge {
                background-color: #fff3cd;
                color: #856404;
                border: 1px solid #ffeeba;
                padding: 5px 12px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 600;
                display: inline-block;
                text-align: center;
                min-width: 80px;
            }

            .status-badge.active-status {
                background-color: #e6f4ea;
                color: #1e8e3e;
                border: 1px solid #cce8d6;
            }

            .desc-column {
                max-width: 200px;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
                color: #637381;
            }

            .action-buttons {
                display: flex;
                gap: 8px;
                align-items: center;
                flex-wrap: wrap;
            }

            .btn-action-edit, .btn-action-stage, .btn-action-delete {
                padding: 0 12px;
                border-radius: 6px;
                font-size: 13px;
                font-weight: 600;
                cursor: pointer;
                border: none;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                color: white;
                transition: 0.2s;
                height: 32px;
            }

            .btn-action-edit { background-color: #f39c12; }
            .btn-action-edit:hover { background-color: #e67e22; }
            .btn-action-stage { background-color: #2980b9; }
            .btn-action-stage:hover { background-color: #3498db; }
            .btn-action-delete { background-color: #e74c3c; font-family: inherit; }
            .btn-action-delete:hover { background-color: #c0392b; }

            /* --- MODAL CSS PURA --- */
            .modal-toggle {
                display: none;
            }

            .modal-overlay {
                position: fixed;
                inset: 0;
                background: rgba(0, 0, 0, 0.5);
                backdrop-filter: blur(4px);
                display: flex;
                justify-content: center;
                align-items: center;
                z-index: 999;
                opacity: 0;
                pointer-events: none;
                transition: all 0.3s ease;
                padding: 20px;
            }

            .modal-overlay.active {
                opacity: 1;
                pointer-events: auto;
            }

            .modal-overlay.active .modal-container {
                transform: translateY(0);
                opacity: 1;
            }

            .modal-container {
                background: #ffffff;
                width: 100%;
                max-width: 600px;
                border-radius: 12px;
                padding: 30px;
                box-shadow: 0 15px 50px rgba(0,0,0,0.2);
                position: relative;
                transform: translateY(-20px);
                opacity: 0;
                transition: all 0.3s ease;
                max-height: 90vh;
                overflow-y: auto;
            }

            #createModalToggle:checked ~ .modal-overlay#modalOverlay {
                opacity: 1;
                pointer-events: auto;
            }

            #createModalToggle:checked ~ .modal-overlay#modalOverlay .modal-container {
                transform: translateY(0);
                opacity: 1;
            }

            <c:forEach var="item" items="${farmingPracticeList}">
                #editToggle-${item.maQuyTrinh}:checked ~ .modal-overlay#editModal-${item.maQuyTrinh},
                #stageToggle-${item.maQuyTrinh}:checked ~ .modal-overlay#stageModal-${item.maQuyTrinh} {
                    opacity: 1;
                    pointer-events: auto;
                }
                #editToggle-${item.maQuyTrinh}:checked ~ .modal-overlay#editModal-${item.maQuyTrinh} .modal-container,
                #stageToggle-${item.maQuyTrinh}:checked ~ .modal-overlay#stageModal-${item.maQuyTrinh} .modal-container {
                    transform: translateY(0);
                    opacity: 1;
                }
            </c:forEach>

            .modal-close {
                position: absolute;
                top: 15px;
                right: 15px;
                background: #f1f3f5;
                border: none;
                font-size: 20px;
                color: #495057;
                cursor: pointer;
                width: 32px;
                height: 32px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                transition: 0.2s;
                line-height: 1;
            }

            .modal-close:hover {
                background: #e9ecef;
                color: #212529;
            }

            .modal-title {
                font-size: 20px;
                font-weight: 700;
                color: #2c3e50;
                margin-top: 0;
                margin-bottom: 25px;
                padding-bottom: 12px;
                border-bottom: 2px solid #eef2f5;
            }

            .form-group {
                margin-bottom: 18px;
            }

            .form-group label {
                display: block;
                font-weight: 600;
                margin-bottom: 8px;
                color: #34495e;
                font-size: 14px;
            }

            .form-group input[type="text"],
            .form-group input[type="number"],
            .form-group input[type="date"],
            .form-group textarea,
            .form-group select {
                width: 100%;
                padding: 10px 14px;
                border: 1px solid #dce1e6;
                border-radius: 8px;
                font-size: 14px;
                color: #2c3e50;
                font-family: inherit;
                transition: 0.2s;
                background-color: #fff;
                outline: none;
            }

            .form-group input:focus, 
            .form-group select:focus, 
            .form-group textarea:focus {
                border-color: #579c3f;
                box-shadow: 0 0 0 3px rgba(87,156,63,0.1);
            }

            .form-row {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 15px;
                margin-bottom: 18px;
            }

            .form-row .form-group {
                margin-bottom: 0;
            }

            .grid-2-cols {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 15px;
            }

            .grid-7-5-cols {
                display: grid;
                grid-template-columns: 3fr 2fr;
                gap: 15px;
            }

            .input-group-custom {
                display: flex;
                gap: 10px;
            }

            .input-group-custom input {
                flex: 1;
            }

            .input-group-custom select {
                width: 100px;
                flex-shrink: 0;
            }

            .btn-submit {
                width: 100%;
                background: #579c3f;
                color: white;
                border: none;
                padding: 14px;
                font-size: 15px;
                font-weight: 600;
                border-radius: 8px;
                cursor: pointer;
                margin-top: 15px;
                transition: 0.3s;
            }

            .btn-submit:hover {
                background: #467e32;
                box-shadow: 0 4px 10px rgba(70,126,50,0.2);
            }

            .note-panel {
                margin-top: 15px;
                font-size: 13px;
                color: #c0392b;
                font-style: italic;
                background: #fdf2e9;
                padding: 12px 15px;
                border-radius: 8px;
                border-left: 4px solid #e67e22;
                line-height: 1.4;
            }

            .btn-cancel {
                background-color: #f1f3f5;
                color: #495057;
                padding: 10px 20px;
                border-radius: 8px;
                cursor: pointer;
                border: none;
                font-size: 14px;
                font-weight: 600;
                text-decoration: none;
                transition: 0.2s;
                display: inline-flex;
                align-items: center;
                justify-content: center;
            }

            .btn-cancel:hover {
                background-color: #e2e6ea;
                color: #212529;
            }

            .btn-save {
                background-color: #579c3f;
                color: white;
                padding: 10px 20px;
                border-radius: 8px;
                cursor: pointer;
                border: none;
                font-size: 14px;
                font-weight: 600;
                transition: 0.2s;
                display: inline-flex;
                align-items: center;
                justify-content: center;
            }

            .btn-save:hover {
                background-color: #467e32;
            }
        </style>
    </head>
    <body>

        <input type="checkbox" id="createModalToggle" class="modal-toggle">

        <c:forEach var="item" items="${farmingPracticeList}">
            <input type="checkbox" id="editToggle-${item.maQuyTrinh}" class="modal-toggle">
            <input type="checkbox" id="stageToggle-${item.maQuyTrinh}" class="modal-toggle">
        </c:forEach>

        <jsp:include page="/views/common/sidebar.jsp">
            <jsp:param name="activePage" value="technician" />
        </jsp:include>

        <div class="main-wrapper">
            <jsp:include page="/views/common/header.jsp">
                <jsp:param name="pageTitle" value="Thiết Lập Quy Trình" />
            </jsp:include>

            <main class="content-area">
                <div class="section-header">
                    <h2 class="section-title">Danh sách bộ quy chuẩn canh tác</h2>

                    <div class="header-actions">
                        <form action="${pageContext.request.contextPath}/technician" method="GET" class="search-form">
                            <input type="hidden" name="action" value="search">
                            <input type="text" name="keyword" class="search-input" placeholder="Nhập ID hoặc tên quy trình..." value="${param.keyword}">
                            <button type="submit" class="btn-search">🔍 Tìm kiếm</button>
                        </form>

                        <label for="createModalToggle" class="btn-add">+ Tạo bộ quy chuẩn</label>

                        <button class="btn-add" id="openModalBtn" style="background-color: #579c3f; color: white; border: none; padding: 12px 20px; font-size: 14px; font-weight: 600; border-radius: 8px; cursor: pointer;">
                            + Phân công công việc mới
                        </button>
                    </div>
                </div>

                <div class="table-container">
                    <div class="data-info">Số lượng quy trình lấy được: ${farmingPracticeList != null ? farmingPracticeList.size() : 0}</div>
                    <table class="custom-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Tên Quy Trình</th>
                                <th>Đối Tượng Áp Dụng</th>
                                <th>Ngày Tạo</th>
                                <th>Người Tạo</th>
                                <th>Trạng Thái</th>
                                <th>Mô Tả</th>
                                <th>Hành Động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${farmingPracticeList}">
                                <tr>
                                    <td>${item.maQuyTrinh}</td>
                                    <td>${item.tenQuyTrinh}</td>
                                    <td>${item.loaiApDung}</td>
                                    <td>${item.ngayTao}</td>
                                    <td>${item.nguoiTao}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${item.trangThai}">
                                                <span class="status-badge active-status">Hoạt động</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-badge">Bản nháp</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="desc-column" title="${item.moTa}">${item.moTa != null ? item.moTa : '---'}</td>
                                    <td>
                                        <div class="action-buttons">
                                            <label for="editToggle-${item.maQuyTrinh}" class="btn-action-edit">Sửa</label>

                                            <c:if test="${!item.trangThai}">
                                                <label for="stageToggle-${item.maQuyTrinh}" class="btn-action-stage">Thêm quy trình</label>
                                            </c:if>

                                            <form action="${pageContext.request.contextPath}/technician" method="POST" style="margin: 0;">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="id" value="${item.maQuyTrinh}">
                                                <button type="submit" class="btn-action-delete">Xóa</button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty farmingPracticeList}">
                                <tr>
                                    <td colspan="8" style="text-align: center; color: #7f8c8d; padding: 30px;">Chưa có quy trình nào được thiết lập. Hãy bấm nút tạo mới bên trên.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </main>
        </div>

        <div class="modal-overlay" id="modalOverlay">
            <div class="modal-container">
                <label for="createModalToggle" class="modal-close">&times;</label>
                <h3 class="modal-title">Tạo bộ quy chuẩn canh tác, sản xuất</h3>

                <form action="${pageContext.request.contextPath}/technician" method="POST">
                    <input type="hidden" name="action" value="create">
                    <div class="form-group">
                        <label for="processName">Tên Quy Trình Quy Chuẩn:</label>
                        <input type="text" id="processName" name="processName" placeholder="Nhập tên bộ quy chuẩn..." required>
                    </div>

                    <div class="form-group">
                        <label for="loaiApDung">Giống cây/Vật nuôi áp dụng:</label>
                        <select id="loaiApDung" name="loaiApDung" required>
                            <option value="">-- Chọn giống cây/vật nuôi --</option>
                            <option value="Lúa">Lúa</option>
                            <option value="Ngô">Ngô</option>
                            <option value="Cà phê">Cà phê</option>
                            <option value="Hồ tiêu">Hồ tiêu</option>
                            <option value="Cao su">Cao su</option>
                            <option value="Bò">Bò</option>
                            <option value="Gà">Gà</option>
                            <option value="Lợn">Lợn</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="description">Mô tả quy trình:</label>
                        <textarea id="description" name="description" rows="5" placeholder="Nhập mô tả tóm tắt cho quy trình canh tác này..." required></textarea>
                    </div>

                    <button type="submit" class="btn-submit">Lưu Khởi Tạo (Bản nháp)</button>

                    <div class="note-panel">
                        * Lưu ý: Quy trình sau khi tạo sẽ nằm ở trạng thái "Bản nháp". Bạn cần phê duyệt để chính thức áp dụng.
                    </div>
                </form>
            </div>
        </div>

        <div class="modal-overlay" id="assignTaskModalOverlay">
            <div class="modal-container">
                <button class="modal-close" id="closeModalBtn">&times;</button>
                <h3 class="modal-title">Khởi tạo và Phân công việc</h3>

                <form action="worker" method="POST">
                    <div class="form-row">
                        <div class="form-group">
                            <label for="maKhuVuc">Chọn Lô Đất / Khu Vực:</label>
                            <select id="maKhuVuc" name="maKhuVuc" required>
                                <option value="">-- Chọn khu vực --</option>
                                <c:forEach var="area" items="${farmAreaList}">
                                    <option value="${area.getMaKhuVuc()}">${area.getTenKhuVuc()}</option>
                                </c:forEach>
                            </select>
                        </div>

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

        <c:forEach var="item" items="${farmingPracticeList}">

            <div class="modal-overlay" id="editModal-${item.maQuyTrinh}">
                <div class="modal-container">
                    <label for="editToggle-${item.maQuyTrinh}" class="modal-close">&times;</label>
                    <h3 class="modal-title" style="color: #2e541f; border-bottom: 2px solid #579c3f; padding-bottom: 10px;">Cập Nhật Quy Trình Canh Tác</h3>

                    <form action="${pageContext.request.contextPath}/technician" method="POST" style="margin-top: 20px;">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="id" value="${item.maQuyTrinh}">

                        <div class="form-group" style="margin-top: 15px;">
                            <label>ID Quy Trình:</label>
                            <input type="text" value="${item.maQuyTrinh}" disabled style="background: #e9ecef; color: #495057; cursor: not-allowed;">
                        </div>

                        <div class="form-group">
                            <label for="editName-${item.maQuyTrinh}">Tên Quy Trình:</label>
                            <input type="text" id="editName-${item.maQuyTrinh}" name="processName" value="${item.tenQuyTrinh}" required>
                        </div>

                        <div class="form-group">
                            <label for="editLoaiApDung-${item.maQuyTrinh}">Giống cây/Vật nuôi áp dụng:</label>
                            <select id="editLoaiApDung-${item.maQuyTrinh}" name="loaiApDung" required>
                                <option value="Lúa" ${item.loaiApDung == 'Lúa' ? 'selected' : ''}>Lúa</option>
                                <option value="Ngô" ${item.loaiApDung == 'Ngô' ? 'selected' : ''}>Ngô</option>
                                <option value="Cà phê" ${item.loaiApDung == 'Cà phê' ? 'selected' : ''}>Cà phê</option>
                                <option value="Hồ tiêu" ${item.loaiApDung == 'Hồ tiêu' ? 'selected' : ''}>Hồ tiêu</option>
                                <option value="Cao su" ${item.loaiApDung == 'Cao su' ? 'selected' : ''}>Cao su</option>
                                <option value="Bò" ${item.loaiApDung == 'Bò' ? 'selected' : ''}>Bò</option>
                                <option value="Gà" ${item.loaiApDung == 'Gà' ? 'selected' : ''}>Gà</option>
                                <option value="Lợn" ${item.loaiApDung == 'Lợn' ? 'selected' : ''}>Lợn</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="editStatus-${item.maQuyTrinh}">Trạng Thái:</label>
                            <select id="editStatus-${item.maQuyTrinh}" name="status">
                                <option value="false" ${!item.trangThai ? 'selected' : ''}>Bản nháp</option>
                                <option value="true" ${item.trangThai ? 'selected' : ''}>Hoạt động</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="editDesc-${item.maQuyTrinh}">Mô tả quy trình:</label>
                            <textarea id="editDesc-${item.maQuyTrinh}" name="description" rows="5" required>${item.moTa}</textarea>
                        </div>

                        <div style="text-align: right; margin-top: 25px; gap: 10px; display: flex; justify-content: flex-end;">
                            <label for="editToggle-${item.maQuyTrinh}" class="btn-cancel">Hủy</label>
                            <button type="submit" class="btn-save">Lưu Cập Nhật</button>
                        </div>
                    </form>
                </div>
            </div>

            <div class="modal-overlay" id="stageModal-${item.maQuyTrinh}">
                <div class="modal-container">
                    <label for="stageToggle-${item.maQuyTrinh}" class="modal-close">&times;</label>
                    <h3 class="modal-title" style="color: #2e541f; border-bottom: 2px solid #579c3f; padding-bottom: 10px;">
                        Thiết lập lộ trình: <span>${item.tenQuyTrinh}</span>
                    </h3>

                    <form action="${pageContext.request.contextPath}/technician" method="POST" style="margin-top: 20px;">
                        <input type="hidden" name="farmingPracticeId" value="${item.maQuyTrinh}">

                        <div class="form-group">
                            <label>Tên giai đoạn:</label>
                            <input type="text" name="stageName" value="${form.tenGD}" placeholder="Ví dụ: Giai đoạn ngâm ủ mầm..." required>
                        </div>

                        <div class="grid-2-cols">
                            <div class="form-group">
                                <label>Ngày bắt đầu:</label>
                                <input type="date" name="startDay" value="${form.ngayBD}" required>
                            </div>
                            <div class="form-group">
                                <label>Ngày kết thúc:</label>
                                <input type="date" name="endDay" value="${form.ngayKT}" required>
                            </div>
                        </div>

                        <div class="grid-7-5-cols">
                            <div class="form-group">
                                <label>Tên vật tư:</label>
                                <select name="supplyId" required>
                                    <option value="">-- Chọn vật tư --</option>
                                    <c:forEach var="sup" items="${suppliesList}">
                                        <option value="${sup.maVatTu}">${sup.tenVatTu} (Mã: ${sup.maVatTu})</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Định lượng vật tư:</label>
                                <div class="input-group-custom">
                                    <input type="number" step="0.01" name="quantity" required>
                                    <select name="unit">
                                        <option value="kg">kg</option>
                                        <option value="g">g</option>
                                        <option value="con">con</option>
                                        <option value="lít">lít</option>
                                        <option value="bao">bao</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Mô tả:</label>
                            <textarea name="description" rows="3" placeholder="Ghi chú thêm về quy trình thực hiện..."></textarea>
                        </div>

                        <div style="text-align: right; margin-top: 25px; gap: 10px; display: flex; justify-content: flex-end;">
                            <label for="stageToggle-${item.maQuyTrinh}" class="btn-cancel">Đóng</label>
                            <button type="submit" name="action" value="saveStage" class="btn-save">Lưu giai đoạn</button>
                            <button type="submit" name="action" value="publishProcess" class="btn-action-delete" style="border: none; padding: 10px 20px; font-size: 14px; display: inline-flex; align-items: center; justify-content: center;">Ban hành</button>
                        </div>
                    </form>
                </div>
            </div>

        </c:forEach>

        <script>
            document.addEventListener("DOMContentLoaded", function () {
                const openModalBtn = document.getElementById('openModalBtn');
                const closeModalBtn = document.getElementById('closeModalBtn');
                const assignModalOverlay = document.getElementById('assignTaskModalOverlay');

                if (openModalBtn && closeModalBtn && assignModalOverlay) {
                    openModalBtn.addEventListener('click', () => {
                        assignModalOverlay.classList.add('active');
                    });
                    closeModalBtn.addEventListener('click', () => {
                        assignModalOverlay.classList.remove('active');
                    });
                    assignModalOverlay.addEventListener('click', (e) => {
                        if (e.target === assignModalOverlay) {
                            assignModalOverlay.classList.remove('active');
                        }
                    });
                }
            });
        </script>
    </body>
</html>