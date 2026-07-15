<%-- 
    Document   : admin
    Created on : Jun 23, 2026, 2:11:11 PM
    Author     : longd
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Smart Farmer - Quản lý vai trò</title>
        <!-- Thêm thư viện Font Awesome để sử dụng các icon đẹp mắt cho nút bấm -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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

            /* CSS bổ sung cho phần bảng dữ liệu */
            .content-container {
                flex: 1;
                padding: 24px;
                overflow-y: auto;
            }

            .table-card {
                background-color: rgba(255, 255, 255, 0.95);
                border-radius: 8px;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
                padding: 20px;
                margin-top: 10px;
            }

            /* Header của bảng: chứa Tiêu đề và Cụm công cụ (Tìm kiếm + Thêm mới) */
            .table-header-wrapper {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
                border-bottom: 2px solid #2e7d32;
                padding-bottom: 12px;
                flex-wrap: wrap;
                gap: 15px;
            }

            .table-title {
                color: #2e7d32;
                margin: 0;
                font-size: 1.5rem;
                font-weight: 600;
            }

            /* Container cho thanh tìm kiếm và nút thêm */
            .table-actions {
                display: flex;
                align-items: center;
                gap: 12px;
            }

            /* Khung tìm kiếm */
            .search-container {
                position: relative;
                display: flex;
                align-items: center;
            }

            .search-input {
                padding: 10px 15px 10px 35px;
                border: 1px solid #cccccc;
                border-radius: 4px;
                font-size: 0.9rem;
                width: 220px;
                transition: all 0.3s ease;
                outline: none;
            }

            .search-input:focus {
                border-color: #2e7d32;
                box-shadow: 0 0 5px rgba(46, 125, 50, 0.3);
                width: 260px; /* Hiệu ứng dãn rộng nhẹ khi focus */
            }

            .search-icon {
                position: absolute;
                left: 12px;
                color: #888888;
                font-size: 0.9rem;
                pointer-events: none;
            }

            .data-table {
                width: 100%;
                border-collapse: collapse;
            }

            /* Căn chữ ra GIỮA cho tất cả th (tiêu đề cột) và td (ô dữ liệu) */
            .data-table th, .data-table td {
                padding: 12px 15px;
                border-bottom: 1px solid #e0e0e0;
                vertical-align: middle;
                text-align: center; /* Căn giữa */
            }

            .data-table th {
                background-color: #2e7d32;
                color: white;
                font-weight: 600;
            }

            .data-table tbody tr:hover {
                background-color: #f1f8e9;
            }

            .status-active {
                color: #2e7d32;
                font-weight: bold;
            }

            .status-inactive {
                color: #c62828;
                font-weight: bold;
            }

            /* Định dạng chung cho các nút hành động */
            .btn-action {
                display: inline-flex;
                align-items: center;
                justify-content: center; /* Căn giữa nội dung bên trong nút */
                gap: 6px;
                padding: 6px 12px;
                color: white;
                text-decoration: none;
                border-radius: 4px;
                font-size: 0.85rem;
                font-weight: 500;
                transition: all 0.2s ease-in-out;
                border: none;
                cursor: pointer;
                box-sizing: border-box; /* Đảm bảo padding không làm nở rộng size nút quá đà */
            }

            /* Áp dụng kích cỡ đồng đều cho nút Chi tiết */
            .action-group .btn-action {
                width: 100px;     /* Chiều rộng cố định, cân đối hơn */
                height: 32px;    /* Chiều cao cố định đảm bảo căn giữa hoàn hảo theo height */
                padding: 0;      /* Reset padding dọc để căn giữa hoàn hảo theo height */
            }

            /* Nút Thêm Nhóm (Nằm ở góc trên, không bị áp dụng chiều rộng của dòng) */
            .btn-add {
                background-color: #2e7d32;
                font-size: 0.95rem;
                padding: 10px 18px;
            }

            .btn-add:hover {
                background-color: #1b5e20;
                transform: translateY(-2px);
                box-shadow: 0 4px 8px rgba(0,0,0,0.15);
            }

            /* Nút Chi Tiết (Xanh dương) */
            .btn-detail {
                background-color: #1976d2;
            }

            .btn-detail:hover {
                background-color: #115293;
            }

            /* Wrapper chứa các nút hành động cùng dòng */
            .action-group {
                display: flex;
                justify-content: center; /* Giữ nút hành động ở chính giữa ô */
                align-items: center;
            }
            /* --- CSS HỆ THỐNG DIỄN HỌA MODAL DIỆN RỘNG --- */

            /* Lớp phủ làm mờ toàn màn hình phía sau */
            .modal-overlay {
                position: fixed;
                inset: 0;
                background-color: rgba(0, 0, 0, 0.55); /* Tạo độ mờ tối màu sâu rộng */
                backdrop-filter: blur(4px); /* Hiệu ứng kính mờ thời thượng */
                display: flex;
                justify-content: center;
                align-items: center;
                z-index: 9999; /* Đảm bảo nổi lên trên mọi layout */
                animation: fadeInOverlay 0.25s ease-out forwards;
            }

            /* Khung hộp thoại chính của Form nhập liệu */
            .modal-box {
                background-color: #ffffff;
                width: 100%;
                max-width: 550px;
                max-height: 90vh; /* Giới hạn chiều cao để không bị tràn màn hình */
                border-radius: 8px;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
                overflow-y: auto; /* Cho phép cuộn bên trong hộp thoại nếu quá dài */
                animation: slideUpBox 0.3s cubic-bezier(0.25, 1, 0.5, 1) forwards;
            }

            /* Thanh tiêu đề Modal */
            .modal-header {
                background-color: #2e7d32;
                color: white;
                padding: 16px 20px;
                display: flex;
                justify-content: space-between;
                align-items: center;
                position: sticky;
                top: 0;
                z-index: 10;
            }

            .modal-header h3 {
                margin: 0;
                font-size: 1.25rem;
                font-weight: 600;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            /* Nút dấu X đóng nhanh */
            .close-modal-btn {
                background: none;
                border: none;
                color: white;
                font-size: 1.8rem;
                cursor: pointer;
                line-height: 1;
                padding: 0;
                transition: opacity 0.2s;
            }

            .close-modal-btn:hover {
                opacity: 0.7;
            }

            /* Thân biểu mẫu */
            .modal-form {
                padding: 20px;
            }

            .form-group {
                margin-bottom: 18px;
            }

            .form-group label {
                display: block;
                font-weight: 600;
                color: #333333;
                margin-bottom: 6px;
                font-size: 0.95rem;
            }

            .form-group .required {
                color: #d32f2f;
            }

            /* Ô nhập chữ và vùng văn bản mô tả */
            .form-group input[type="text"],
            .form-group textarea {
                width: 100%;
                padding: 10px 12px;
                border: 1px solid #cccccc;
                border-radius: 4px;
                font-size: 0.9rem;
                font-family: inherit;
                box-sizing: border-box;
                outline: none;
                transition: border-color 0.2s;
            }

            .form-group input[type="text"]:focus,
            .form-group textarea:focus {
                border-color: #2e7d32;
            }

            /* CSS cho ô chỉ đọc (readonly) */
            .form-group input[readonly] {
                background-color: #f5f5f5;
                color: #666666;
                cursor: not-allowed;
                border: 1px solid #dddddd;
            }

            /* Layout chia ô lưới cho danh sách chọn nhiều Quyền hạn (Checkbox) */
            .permissions-grid {
                display: grid;
                grid-template-columns: repeat(2, 1fr); /* Tự động chia 2 cột đều nhau */
                gap: 10px;
                background-color: #f9f9f9;
                padding: 12px;
                border: 1px solid #e0e0e0;
                border-radius: 4px;
                max-height: 160px;
                overflow-y: auto; /* Cuộn dọc tự động nếu danh sách quyền quá dài */
            }

            /* Custom hiển thị Checkbox cho thẩm mỹ */
            .checkbox-container {
                display: flex;
                align-items: center;
                position: relative;
                padding-left: 26px;
                cursor: pointer;
                font-size: 0.88rem;
                color: #444;
                user-select: none;
            }

            .checkbox-container input {
                position: absolute;
                opacity: 0;
                cursor: pointer;
                height: 0;
                width: 0;
            }

            .checkmark {
                position: absolute;
                left: 0;
                height: 18px;
                width: 18px;
                background-color: #eee;
                border: 1px solid #bbb;
                border-radius: 3px;
                transition: all 0.2s;
            }

            .checkbox-container:hover input ~ .checkmark {
                background-color: #ddd;
            }

            .checkbox-container input:checked ~ .checkmark {
                background-color: #2e7d32;
                border-color: #2e7d32;
            }

            .checkmark:after {
                content: "";
                position: absolute;
                display: none;
            }

            .checkbox-container input:checked ~ .checkmark:after {
                display: block;
            }

            .checkbox-container .checkmark:after {
                left: 6px;
                top: 2px;
                width: 4px;
                height: 9px;
                border: solid white;
                border-width: 0 2px 2px 0;
                transform: rotate(45deg);
            }

            /* Khu vực chân biểu mẫu chứa cụm nút chính */
            .modal-footer {
                display: flex;
                justify-content: flex-end;
                align-items: center;
                gap: 12px;
                border-top: 1px solid #eeeeee;
                padding-top: 15px;
                margin-top: 10px;
            }

            .btn-modal-action {
                padding: 10px 20px;
                font-size: 0.9rem;
                font-weight: 600;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                transition: background-color 0.2s;
            }

            .btn-modal-cancel {
                background-color: #e0e0e0;
                color: #333333;
            }

            .btn-modal-cancel:hover {
                background-color: #d5d5d5;
            }

            .btn-modal-submit {
                background-color: #2e7d32;
                color: white;
                display: inline-flex;
                align-items: center;
                gap: 6px;
            }

            .btn-modal-submit:hover {
                background-color: #1b5e20;
            }

            /* Nút xóa màu đỏ nổi bật */
            .btn-modal-danger {
                background-color: #d32f2f;
                color: white;
                display: inline-flex;
                align-items: center;
                gap: 6px;
            }

            .btn-modal-danger:hover {
                background-color: #c62828;
            }

            /* Hiệu ứng chuyển động mượt mà khi Modal bật lên */
            @keyframes fadeInOverlay {
                from {
                    opacity: 0;
                }
                to {
                    opacity: 1;
                }
            }

            @keyframes slideUpBox {
                from {
                    transform: translateY(30px);
                    opacity: 0;
                }
                to {
                    transform: translateY(0);
                    opacity: 1;
                }
            }
            /* --- CSS CHO KHU VỰC THÔNG BÁO (ALERTS) --- */
            .alert-container {
                margin-bottom: 20px;
                display: flex;
                flex-direction: column;
                gap: 10px;
            }

            .alert {
                padding: 12px 16px;
                border-radius: 6px;
                font-size: 0.95rem;
                font-weight: 500;
                display: flex;
                align-items: center;
                gap: 12px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.08);
                animation: slideInAlert 0.4s ease-out forwards;
            }

            /* Hộp thoại thông báo thành công */
            .alert-success {
                background-color: #edf7ed;
                color: #1e4620;
                border-left: 5px solid #4caf50;
            }

            .alert-success i {
                color: #4caf50;
                font-size: 1.3rem;
            }

            /* Hộp thoại thông báo lỗi */
            .alert-error {
                background-color: #fdeded;
                color: #5f2120;
                border-left: 5px solid #ef5350;
            }

            .alert-error i {
                color: #ef5350;
                font-size: 1.3rem;
            }

            /* Hiệu ứng trượt vào mượt mà */
            @keyframes slideInAlert {
                from {
                    opacity: 0;
                    transform: translateX(-20px);
                }
                to {
                    opacity: 1;
                    transform: translateX(0);
                }
            }
            /* Định dạng thông báo nằm giữa bảng với màu sắc trực quan */
            .message-container {
                text-align: center;      /* Căn giữa chữ */
                margin: 15px auto;       /* Tạo khoảng cách phía trên và dưới bảng */
                font-size: 1.1rem;       /* Tăng kích thước chữ một chút cho dễ đọc */
                font-weight: 600;        /* Làm chữ dày dặn hơn */
                padding: 10px;
                border-radius: 6px;
                display: inline-block;   /* Đảm bảo khung bọc vừa vặn với dòng chữ */
                width: 100%;             /* Chiếm trọn bề ngang để căn giữa chính xác */
            }

            /* Chữ thành công màu xanh lá */
            .text-success {
                color: #2e7d32;          /* Màu xanh lá đậm của Smart Farmer */
                background-color: #edf7ed; /* Nền xanh nhạt dịu mắt */
                padding: 8px 16px;
                border-radius: 4px;
                border: 1px solid #c3e6cb;
            }

            /* Chữ lỗi màu đỏ */
            .text-error {
                color: #c62828;          /* Màu đỏ đậm cảnh báo */
                background-color: #fdeded; /* Nền đỏ nhạt */
                padding: 8px 16px;
                border-radius: 4px;
                border: 1px solid #f5c6cb;
            }
            /* Màu chủ đạo xanh dương dành riêng cho Header của Modal Chi Tiết */
            .header-detail {
                background-color: #1976d2 !important;
            }

            /* Nút cập nhật màu xanh dương đồng bộ */
            .btn-update {
                background-color: #1976d2 !important;
            }

            .btn-update:hover {
                background-color: #115293 !important;
            }

            /* Định dạng cho ô Select-box chọn trạng thái hoạt động */
            .select-custom {
                width: 100%;
                padding: 10px 12px;
                border: 1px solid #cccccc;
                border-radius: 4px;
                font-size: 0.9rem;
                font-family: inherit;
                box-sizing: border-box;
                outline: none;
                transition: border-color 0.2s;
                background-color: #ffffff;
                cursor: pointer;
            }

            .select-custom:focus {
                border-color: #1976d2;
            }

            /* Custom viền hộp thoại chi tiết */
            .border-detail {
                border-top: 4px solid #1976d2;
            }
            /* Ẩn thanh cuộn cho các trình duyệt dựa trên Webkit (Chrome, Safari, Edge, Opera) */
            .modal-box::-webkit-scrollbar {
                display: none;
            }

            /* Ẩn thanh cuộn cho Firefox và IE/Edge cũ */
            .modal-box {
                -ms-overflow-style: none;  /* IE và Edge */
                scrollbar-width: none;  /* Firefox */
            }
        </style>
    </head>
    <body>
        <jsp:include page="/views/common/sidebar.jsp">
            <jsp:param name="activePage" value="admin" />
        </jsp:include>
        <div class="main-wrapper">
            <jsp:include page="/views/common/header.jsp"></jsp:include>

                <!-- Phần nội dung bảng hiển thị thông tin nhóm người dùng -->
                <div class="content-container">
                    <div class="table-card">

                        <!-- Khu vực Tiêu đề và Cụm hành động (Tìm kiếm + Thêm) -->
                        <div class="table-header-wrapper">
                            <h2 class="table-title">Danh sách nhóm</h2>
                            <div class="table-actions">
                                <!-- Thanh tìm kiếm -->
                                <div class="search-container">
                                    <i class="fa-solid fa-magnifying-glass search-icon"></i>
                                    <input type="text" class="search-input" id="searchInput" placeholder="Tìm kiếm nhóm...">
                                </div>
                                <!-- Nút thêm nhóm -->
                                <form method="Get" action="${pageContext.request.contextPath}/admin">
                                <button type="submit" name="action" value="add" class="btn-action btn-add">
                                    <i class="fa-solid fa-plus"></i> Thêm nhóm
                                </button>
                            </form>

                        </div>
                    </div>
                    <!-- Khu vực hiển thị thông báo được căn giữa -->
                    <div class="message-container">
                        <c:if test="${success != null}">
                            <span class="text-success">
                                <i class="fa-solid fa-circle-check"></i> ${success}
                            </span>
                        </c:if>
                        <c:if test="${errorName != null}">
                            <span class="text-error">
                                <i class="fa-solid fa-triangle-exclamation"></i> ${errorName}
                            </span>
                        </c:if>
                        <c:if test="${errorLog != null}">
                            <span class="text-error">
                                <i class="fa-solid fa-bug"></i> ${errorLog}
                            </span>
                        </c:if>
                    </div>
                    <table class="data-table" id="rolesTable">
                        <thead>
                            <tr>
                                <th>Tên nhóm người dùng</th>
                                <th>Ngày tạo</th>
                                <th>Trạng thái</th>
                                <th>Hành động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="ug" items="${LISTUG}">
                                <tr>
                                    <td>${ug.tenNhom}</td>
                                    <td>${ug.ngayTao}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${ug.trangThai}">
                                                <span class="status-active">Hoạt động</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-inactive">Tạm dừng</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="action-group">
                                            <form method="Get" action="${pageContext.request.contextPath}/admin">
                                                <input type="hidden" name="id" value="${ug.maNhom}"> <!-- Truyền ID nhóm cần xem -->
                                                <button type="submit" name="action" value="detail" class="btn-action btn-detail" title="Xem chi tiết"><i class="fa-solid fa-eye"></i> Chi tiết</button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
            <div>
                <!-- Khối hiển thị form thêm mới khi biến form có giá trị 'add' -->
                <c:if test="${Form == 'add' && Form !=null}">
                    <!-- Lớp nền mờ bao phủ toàn bộ màn hình -->
                    <div class="modal-overlay">
                        <!-- Khung chứa Form nhập liệu nổi lên trên -->
                        <div class="modal-box">
                            <div class="modal-header">
                                <h3><i class="fa-solid fa-folder-plus"></i> Thêm Nhóm Người Dùng Mới</h3>
                            </div>

                            <form action="${pageContext.request.contextPath}/admin" method="Post" class="modal-form">
                                <div class="form-group">
                                    <label for="modalTenNhom">Tên nhóm <span class="required">*</span></label>
                                    <input type="text" id="modalTenNhom" name="TenNhom" placeholder="Nhập tên nhóm người dùng..." required autocomplete="off">
                                </div>

                                <!-- Chọn đa quyền bằng Checkbox -->
                                <div class="form-group">
                                    <label>Phân chia quyền hạn <span class="required">*</span></label>
                                    <small style="color: #666; display: block; margin-bottom: 8px;">(Tích chọn một hoặc nhiều quyền hạn cho nhóm này)</small>
                                    <div class="permissions-grid">
                                        <c:forEach var="ps" items="${Permission}">
                                            <label class="checkbox-container">
                                                <input type="checkbox" name="Quyen" value="${ps.getMaQuyen()}">
                                                <span class="checkmark"></span> ${ps.getTenQuyen()}
                                            </label>
                                        </c:forEach>
                                    </div>
                                </div>

                                <!-- Nhập mô tả -->
                                <div class="form-group">
                                    <label for="modalMoTa">Mô tả chức năng</label>
                                    <textarea id="modalMoTa" name="MoTa" rows="3" placeholder="Tóm tắt ngắn gọn vai trò và trách nhiệm của nhóm này..."></textarea>
                                </div>
                                <!-- Cụm nút xác nhận / hủy bỏ hành động cuối form -->
                                <div class="modal-footer">
                                    <button type="button" class="btn-modal-action btn-modal-cancel" onclick="window.location.href = '${pageContext.request.contextPath}/admin'">
                                        Hủy bỏ
                                    </button>
                                    <button type="submit" name="action" value="add&save" class="btn-modal-action btn-modal-submit">
                                        <i class="fa-solid fa-floppy-disk"></i> Lưu thông tin
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </c:if>
            </div>
            <div>
                <c:if test="${Detail == 'detail' && Detail !=null}">
                    <!-- Lớp nền mờ bao phủ toàn bộ màn hình cho phần Chi tiết -->
                    <div class="modal-overlay">
                        <!-- Khung chứa Form thông tin chi tiết nổi lên trên -->
                        <!-- Khung chứa Form thông tin chi tiết nổi lên trên -->
                        <div class="modal-box border-detail">
                            <div class="modal-header header-detail">
                                <h3><i class="fa-solid fa-circle-info"></i> Chi Tiết & Chỉnh Sửa Nhóm</h3>

                            </div>

                            <!-- Form gửi dữ liệu cập nhật -->
                            <form action="/admin" method="Post" class="modal-form">
                                <!-- ID ẩn của nhóm để gửi về server -->
                                <input type="hidden" name="id" value="ROLE_01">

                                <!-- Mã Nhóm (Không thể cập nhật) -->
                                <div class="form-group">
                                    <label for="detailMaNhom">Mã nhóm <small style="color: #c62828;">(Không thể chỉnh sửa)</small></label>
                                    <input type="text" id="detailMaNhom" name="MaNhom" value="ROLE_01" readonly>
                                </div>

                                <!-- Tên nhóm (Có thể cập nhật) -->
                                <div class="form-group">
                                    <label for="detailTenNhom">Tên nhóm <span class="required">*</span></label>
                                    <input type="text" id="detailTenNhom" name="TenNhom" value="Ban Quản Trị" required autocomplete="off">
                                </div>

                                <!-- Ngày tạo (Không thể cập nhật) -->
                                <div class="form-group">
                                    <label for="detailNgayTao">Ngày tạo <small style="color: #c62828;">(Không thể chỉnh sửa)</small></label>
                                    <input type="text" id="detailNgayTao" name="NgayTao" value="2026-06-23" readonly>
                                </div>

                                <!-- Trạng thái hoạt động (Có thể cập nhật) -->
                                <div class="form-group">
                                    <label for="detailTrangThai">Trạng thái hoạt động <span class="required">*</span></label>
                                    <select id="detailTrangThai" name="TrangThai" class="select-custom">
                                        <option value="true" selected>Hoạt động</option>
                                        <option value="false">Tạm dừng</option>
                                    </select>
                                </div>

                                <!-- Phân chia quyền hạn (Chọn nhiều ô Checkbox giống form thêm nhóm, đã tích sẵn mẫu) -->
                                <div class="form-group">
                                    <label>Quyền hạn được cấp <span class="required">*</span></label>
                                    <small style="color: #666; display: block; margin-bottom: 8px;">(Tích chọn để thay đổi danh sách quyền của nhóm này)</small>
                                    <div class="permissions-grid">
                                        <!-- Quyền 1 (Tích sẵn) -->
                                        <label class="checkbox-container">
                                            <input type="checkbox" name="Quyen" value="P_VIEW" checked>
                                            <span class="checkmark"></span> Xem báo cáo
                                        </label>
                                        <!-- Quyền 2 (Tích sẵn) -->
                                        <label class="checkbox-container">
                                            <input type="checkbox" name="Quyen" value="P_ADD" checked>
                                            <span class="checkmark"></span> Thêm mới dữ liệu
                                        </label>
                                        <!-- Quyền 3 (Chưa tích) -->
                                        <label class="checkbox-container">
                                            <input type="checkbox" name="Quyen" value="P_EDIT">
                                            <span class="checkmark"></span> Chỉnh sửa hệ thống
                                        </label>
                                        <!-- Quyền 4 (Tích sẵn) -->
                                        <label class="checkbox-container">
                                            <input type="checkbox" name="Quyen" value="P_DELETE" checked>
                                            <span class="checkmark"></span> Xóa dữ liệu
                                        </label>
                                        <!-- Quyền 5 (Chưa tích) -->
                                        <label class="checkbox-container">
                                            <input type="checkbox" name="Quyen" value="P_EXPORT">
                                            <span class="checkmark"></span> Xuất file Excel
                                        </label>
                                    </div>
                                </div>

                                <!-- Số lượng nhân viên (Không thể cập nhật) -->
                                <div class="form-group">
                                    <label for="detailSoLuong">Số lượng nhân viên <small style="color: #c62828;">(Không thể chỉnh sửa)</small></label>
                                    <input type="text" id="detailSoLuong" name="SoLuongNV" value="5" readonly>
                                </div>

                                <!-- Mô tả chức năng (Có thể cập nhật - Ở dưới cùng bảng) -->
                                <div class="form-group">
                                    <label for="detailMoTa">Mô tả chức năng</label>
                                    <textarea id="detailMoTa" name="MoTa" rows="3" placeholder="Mô tả vai trò của nhóm này...">Nhóm có toàn quyền quản trị hệ thống nông trại thông minh.</textarea>
                                </div>

                                <!-- Cụm nút bấm hành động -->
                                <div class="modal-footer">
                                    <!-- Nút xóa nằm bên tay trái -->
                                    <button type="submit" name="action" value="delete" class="btn-modal-action btn-modal-danger" style="margin-right: auto;" onclick="return confirm('Bạn có chắc chắn muốn xóa nhóm này không?');">
                                        <i class="fa-solid fa-trash-can"></i> Xóa nhóm
                                    </button>

                                    <button type="button" class="btn-modal-action btn-modal-cancel" onclick="window.location.href = '${pageContext.request.contextPath}/admin'">
                                        Đóng lại
                                    </button>
                                    <button type="submit" name="action" value="update&save" class="btn-modal-action btn-modal-submit btn-update">
                                        <i class="fa-solid fa-pen-to-square"></i> Cập nhật thay đổi
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </c:if>
            </div>
        </div>
    </body>
</html>