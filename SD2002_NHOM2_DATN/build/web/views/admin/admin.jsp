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
                gap: 4px; /* Giảm gap một chút để text không bị tràn */
                padding: 6px 10px;
                color: white;
                text-decoration: none;
                border-radius: 4px;
                font-size: 0.8rem; /* Cho chữ nhỏ đi một chút cho thanh thoát */
                font-weight: 500;
                transition: all 0.2s ease-in-out;
                border: none;
                cursor: pointer;
                box-sizing: border-box; /* Đảm bảo padding không làm nở rộng size nút quá đà */
            }

            /* Áp dụng kích cỡ đồng đều cho các nút trong nhóm thao tác dòng */
            .action-group .btn-action {
                width: 90px;     /* Chiều rộng cố định, gọn gàng hơn trước */
                height: 32px;    /* Chiều cao cố định đảm bảo 3 nút bằng nhau chằn chặn */
                padding: 0;      /* Reset padding dọc để căn giữa hoàn hảo theo height */
            }

            /* Nút Thêm Nhóm (Nằm ở góc trên, không bị áp dụng chiều rộng 90px của dòng) */
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

            /* Nút Sửa Nhóm (Màu cam ấm) */
            .btn-edit {
                background-color: #f57c00;
            }

            .btn-edit:hover {
                background-color: #e65100;
            }

            /* Nút Xóa Nhóm (Màu đỏ) */
            .btn-delete {
                background-color: #d32f2f;
            }

            .btn-delete:hover {
                background-color: #c62828;
            }

            /* Wrapper chứa các nút hành động cùng dòng */
            .action-group {
                display: flex;
                gap: 8px;
                flex-wrap: wrap;
                justify-content: center; /* Giữ các nút hành động ở giữa ô */
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
                                <a href="#" class="btn-action btn-add">
                                    <i class="fa-solid fa-plus"></i> Thêm nhóm
                                </a>
                            </div>
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
                                    <td>${ug.getTenNhom()}</td>
                                    <td>${ug.getNgayTao()}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${ug.isTrangThai()== true}">
                                                <span class="status-active">Hoạt động</span>
                                            </c:when>
                                            <c:otherwise >
                                                <span class="status-inactive">Tạm dừng</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="action-group">
                                            <a href="#" class="btn-action btn-detail" title="Xem chi tiết"><i class="fa-solid fa-eye"></i> Chi tiết</a>
                                            <a href="#" class="btn-action btn-edit" title="Sửa nhóm"><i class="fa-solid fa-pen-to-square"></i> Sửa</a>
                                            <button class="btn-action btn-delete" title="Xóa nhóm"><i class="fa-solid fa-trash"></i> Xóa</button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>

        </div>
    </body>
</html>