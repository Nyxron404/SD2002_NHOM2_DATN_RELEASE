<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%-- Sử dụng namespace jakarta cho Tomcat 10+ --%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Smart Farmer - Quản lý nhân sự</title>
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

            /* ================= HEADER & MAIN CONTENT ================= */
            .main-wrapper {
                flex: 1;
                display: flex;
                flex-direction: column;
                overflow: hidden;
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
                min-height: 12px;
                display: flex;
                justify-content: center;
                align-items: center;
            }

            .content-area {
                flex: 1;
                padding: 40px;
                overflow-y: auto;
            }

            /* ================= HR MANAGEMENT STYLES ================= */
            .page-toolbar {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 25px;
            }

            .page-toolbar h2 {
                margin: 0;
                color: #ffffff;
                font-size: 24px;
                font-weight: 700;
                text-shadow: 0 2px 4px rgba(0,0,0,0.5);
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
                background: linear-gradient(135deg, #579c3f, #396728);
                color: white;
                border: none;
                padding: 12px 24px;
                border-radius: 8px;
                font-size: 15px;
                font-weight: bold;
                cursor: pointer;
                box-shadow: 0 4px 15px rgba(87, 156, 63, 0.4);
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .btn-add:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(87, 156, 63, 0.6);
            }

            .table-card {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(15px);
                border-radius: 16px;
                padding: 25px;
                border: 1px solid rgba(255, 255, 255, 0.6);
                box-shadow: 0px 8px 32px rgba(0, 0, 0, 0.15);
                overflow-x: auto;
            }

            table {
                width: 100%;
                border-collapse: collapse;
            }

            th, td {
                padding: 16px;
                text-align: left;
                border-bottom: 1px solid rgba(0, 0, 0, 0.08);
            }

            th {
                color: #4a5c43;
                font-weight: 700;
                text-transform: uppercase;
                font-size: 13px;
            }

            td {
                color: #1a2419;
                font-weight: 500;
                font-size: 14px;
            }

            .status-badge {
                padding: 6px 12px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 700;
                display: inline-block;
            }
            .status-active {
                background: #e8f5e9;
                color: #2e7d32;
            }
            .status-locked {
                background: #ffebee;
                color: #c62828;
            }

            .role-badge {
                background: #f1f2f6;
                color: #2f3542;
                padding: 6px 10px;
                border-radius: 6px;
                font-size: 13px;
                font-weight: 600;
                border: 1px solid #dfe4ea;
            }

            .action-btns {
                display: flex;
                gap: 8px;
            }
            .btn-action {
                border: none;
                padding: 8px 12px;
                border-radius: 6px;
                font-size: 13px;
                font-weight: 600;
                cursor: pointer;
                color: white;
                transition: 0.2s;
            }

            .btn-edit {
                background: #f39c12;
            }
            .btn-edit:hover {
                background: #e67e22;
            }
            .btn-role {
                background: #3498db;
            }
            .btn-role:hover {
                background: #2980b9;
            }
            .btn-lock {
                background: #e74c3c;
            }
            .btn-lock:hover {
                background: #c0392b;
            }

            /* ================= MODAL ================= */
            .modal-overlay {
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0, 0, 0, 0.6);
                z-index: 100;
                display: none;
                justify-content: center;
                align-items: center;
                backdrop-filter: blur(5px);
            }

            .modal-content {
                background: white;
                width: 500px;
                max-width: 90%;
                border-radius: 16px;
                padding: 30px;
                box-shadow: 0 10px 40px rgba(0, 0, 0, 0.3);
                animation: slideIn 0.3s ease-out;
                max-height: 90vh;
                overflow-y: auto;
            }

            @keyframes slideIn {
                from {
                    transform: translateY(-30px);
                    opacity: 0;
                }
                to {
                    transform: translateY(0);
                    opacity: 1;
                }
            }

            .modal-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
                border-bottom: 1px solid #eee;
                padding-bottom: 10px;
            }
            .modal-header h3 {
                margin: 0;
                color: #2e541f;
                font-size: 20px;
                font-weight: 700;
            }
            .close-btn {
                background: none;
                border: none;
                font-size: 24px;
                cursor: pointer;
                color: #999;
            }
            .close-btn:hover {
                color: #e74c3c;
            }

            .form-row {
                display: flex;
                gap: 15px;
            }
            .form-row .form-group {
                flex: 1;
            }

            .form-group {
                margin-bottom: 15px;
            }
            .form-group label {
                display: block;
                margin-bottom: 8px;
                font-weight: 600;
                color: #444;
                font-size: 14px;
            }
            .form-control {
                width: 100%;
                padding: 10px 12px;
                border: 1px solid #ddd;
                border-radius: 8px;
                font-size: 14px;
                box-sizing: border-box;
                transition: 0.3s;
                font-family: inherit;
            }
            .form-control:focus {
                outline: none;
                border-color: #579c3f;
                box-shadow: 0 0 0 3px rgba(87,156,63,0.1);
            }

            .modal-footer {
                display: flex;
                justify-content: flex-end;
                gap: 10px;
                margin-top: 25px;
            }
            .btn-cancel, .btn-save {
                padding: 10px 20px;
                border: none;
                border-radius: 8px;
                font-weight: 600;
                cursor: pointer;
            }
            .btn-cancel {
                background: #f1f2f6;
                color: #333;
            }
            .btn-cancel:hover {
                background: #dfe4ea;
            }
            .btn-save {
                background: #579c3f;
                color: white;
            }
            .btn-save:hover {
                background: #467e32;
            }

            /* Checkbox styles */
            .checkbox-group {
                display: flex;
                flex-direction: column;
                gap: 10px;
                margin-top: 10px;
                background: #f9f9f9;
                padding: 15px;
                border-radius: 8px;
                border: 1px solid #eee;
            }
            .checkbox-group label {
                margin: 0;
                display: flex;
                align-items: center;
                gap: 8px;
                cursor: pointer;
                font-weight: 500;
            }
            .checkbox-group input[type="checkbox"] {
                width: 16px;
                height: 16px;
                cursor: pointer;
            }
            /* ================= TOAST NOTIFICATION ================= */
            .toast {
                position: fixed;
                top: 25px;
                right: 25px;
                padding: 15px 25px;
                border-radius: 8px;
                color: white;
                font-weight: 600;
                font-size: 15px;
                z-index: 9999;
                box-shadow: 0 4px 15px rgba(0,0,0,0.2);
                display: flex;
                align-items: center;
                gap: 10px;
                /* Hiệu ứng trượt vào */
                animation: slideInRight 0.5s ease-out forwards;
            }
            .toast.success {
                background-color: #2ecc71;
                border-left: 6px solid #27ae60;
            }
            .toast.error {
                background-color: #e74c3c;
                border-left: 6px solid #c0392b;
            }

            @keyframes slideInRight {
                from {
                    transform: translateX(100%);
                    opacity: 0;
                }
                to {
                    transform: translateX(0);
                    opacity: 1;
                }
            }
        </style>
    </head>
    <body>

        <jsp:include page="/views/common/sidebar.jsp">
            <jsp:param name="activePage" value="hrManager" />
        </jsp:include>

        <div class="main-wrapper">
            <jsp:include page="/views/common/header.jsp">
                <jsp:param name="pageTitle" value="Quản Lý Nhân Sự" />
            </jsp:include>

            <main class="content-area">

                <div class="page-toolbar">
                    <h2>Danh sách nhân viên</h2>

                    <%-- THANH TÌM KIẾM ĐƯỢC CHÈN VÀO ĐÂY --%>
                    <div style="display: flex; align-items: center; gap: 15px;">
                        <div class="search-box">
                            <input type="text" id="searchInput" placeholder="Nhập tên hoặc ID nhân viên..." onkeydown="if (event.key === 'Enter')
                                        openSearchModal()">
                            <button class="btn-search" onclick="openSearchModal()">🔍 Tìm kiếm</button>
                        </div>

                        <button class="btn-add" onclick="openEmployeeForm('add')">
                            <svg viewBox="0 0 24 24" width="20" height="20" fill="white"><path d="M19 13h-6v6h-2v-6H5v-2h6V5h2v6h6v2z"/></svg>
                            Thêm nhân viên
                        </button>
                    </div>
                </div>

                <div class="table-card">
                    <table id="mainStaffTable">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Họ và Tên</th>
                                <th>Giới tính</th> 
                                <th>SĐT</th>
                                <th>Email</th>
                                <th>Quyền / Chức vụ</th>
                                <th>Trạng thái</th>
                                <th>Hành động</th>
                            </tr>
                        </thead>
                        <%-- CẤP ID CHO TBODY ĐỂ JS LẤY DỮ LIỆU ĐỔ VÀO MODAL TÌM KIẾM --%>
                        <tbody id="mainTableBody">
                            <c:forEach var="st" items="${LIST_STAFF}">
                                <tr>
                                    <td>${st.getMaNhanVien()}</td>
                                    <td><strong>${st.getHoTen()}</strong></td>
                                    <td>${st.isGioiTinh() ? 'Nam' : 'Nữ'}</td>
                                    <td>${st.getSDT()}</td>
                                    <td>${st.getEmail()}</td>

                                    <td>
                                        <div style="display: flex; flex-wrap: wrap; gap: 6px;">
                                            <c:choose>
                                                <c:when test="${empty st.getDanhSachQuyen() or st.getDanhSachQuyen() == 'Chưa phân quyền'}">
                                                    <span class="role-badge status-locked" style="margin:0;">Chưa phân quyền</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:forEach var="quyen" items="${fn:split(st.getDanhSachQuyen(), ',')}">
                                                        <span class="role-badge status-active" style="margin:0;">${fn:trim(quyen)}</span>
                                                    </c:forEach>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </td>

                                    <td>
                                        <span class="status-badge ${st.isDangKy() ? 'status-active' : 'status-locked'}">
                                            ${st.isDangKy() ? 'Bình thường' : 'Đã khóa'}
                                        </span>
                                    </td>

                                    <td>
                                        <div class="action-btns">
                                            <button class="btn-action btn-edit" onclick="openEmployeeForm('edit', '${st.getMaNhanVien()}', '${st.getHoTen()}', '${st.getNgaySinh()}', '${st.isGioiTinh() ? 1 : 0}', '${st.getSDT()}', '${st.getEmail()}', '${st.getDiaChi()}', '${st.getLuong()}')">Sửa</button>
                                            <button class="btn-action btn-role" style="white-space: nowrap;" title="Cấp Quyền" onclick="openRoleForm('${st.getMaNhanVien()}', '${st.getMaNguoiDung()}', '${st.getMaNhom()}')">Phân Quyền</button>
                                            <button class="btn-action btn-lock" onclick="openLockForm('${st.getMaNguoiDung()}')">Khóa</button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </main>
        </div>

        <%-- MODAL KẾT QUẢ TÌM KIẾM (MỚI THÊM) --%>
        <div class="modal-overlay" id="searchModal">
            <%-- Đổi width to hơn cho vừa cái bảng --%>
            <div class="modal-content" style="width: 1000px; max-width: 95%;"> 
                <div class="modal-header">
                    <h3>Kết quả Tìm kiếm</h3>
                    <button class="close-btn" onclick="closeModal('searchModal')">&times;</button>
                </div>

                <div class="table-card" style="box-shadow: none; border: 1px solid #ddd; padding: 10px; max-height: 400px; overflow-y: auto;">
                    <table style="width: 100%; border-collapse: collapse;">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Họ và Tên</th>
                                <th>Giới tính</th> 
                                <th>SĐT</th>
                                <th>Email</th>
                                <th>Quyền / Chức vụ</th>
                                <th>Trạng thái</th>
                                <th>Hành động</th>
                            </tr>
                        </thead>
                        <%-- Tbody rỗng, JS sẽ nhét kết quả vào đây --%>
                        <tbody id="searchResultBody">

                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <%-- CÁC MODAL CŨ GIỮ NGUYÊN BÊN DƯỚI --%>
        <div class="modal-overlay" id="employeeModal">
            <div class="modal-content">
                <div class="modal-header">
                    <h3 id="employeeModalTitle">Thêm nhân viên mới</h3>
                    <button class="close-btn" onclick="closeModal('employeeModal')">&times;</button>
                </div>
                <form action="hr" method="POST">
                    <input type="hidden" name="action" id="formAction" value="add">
                    <input type="hidden" name="maNhanVien" id="editEmpId" value="">

                    <div class="form-group">
                        <label>Họ và tên</label>
                        <input type="text" name="hoTen" class="form-control" placeholder="Nhập họ tên đầy đủ" required>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label>Ngày sinh</label>
                            <input type="date" name="ngaySinh" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label>Giới tính</label>
                            <select name="gioiTinh" class="form-control" required>
                                <option value="1">Nam</option>
                                <option value="0">Nữ</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label>Số điện thoại</label>
                            <input type="number" name="sdt" class="form-control" placeholder="Ví dụ: 0822069476" required>
                        </div>
                        <div class="form-group">
                            <label>Email</label>
                            <input type="email" name="email" class="form-control" placeholder="example@gmail.com" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Địa chỉ</label>
                        <input type="text" name="diaChi" class="form-control" placeholder="Nhập địa chỉ" required>
                    </div>

                    <div class="form-group">
                        <label>Lương (VNĐ)</label>
                        <input type="number" name="luong" class="form-control" placeholder="Ví dụ: 93129131" required>
                    </div>

                    <div class="modal-footer">
                        <button type="button" class="btn-cancel" onclick="closeModal('employeeModal')">Hủy bỏ</button>
                        <button type="submit" class="btn-save">Lưu thông tin</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- MODAL CẤP CHỨC VỤ -->
        <div class="modal-overlay" id="roleModal">
            <div class="modal-content" style="width: 400px;">
                <div class="modal-header">
                    <h3>Gán Chức vụ (Nhóm)</h3>
                    <button class="close-btn" onclick="closeModal('roleModal')">&times;</button>
                </div>
                <form action="hr" method="POST">
                    <input type="hidden" name="action" value="updateRole">
                    <input type="hidden" name="maNhanVien" id="roleEmployeeId" value="">
                    <input type="hidden" name="maNguoiDung" id="roleUserId" value="">

                    <div class="form-group">
                        <label style="color:#2e541f; font-size:16px; margin-bottom: 15px;">Chọn chức vụ cho nhân viên:</label>

                        <div class="checkbox-group" style="max-height: 250px; overflow-y: auto;">
                            <c:forEach var="group" items="${LIST_GROUP}">
                                <label style="padding: 5px 0;">
                                    <input type="radio" name="selectedGroup" value="${group.getMaNhom()}" required> 
                                    ${group.getTenNhom()}
                                </label>
                            </c:forEach>
                        </div>
                    </div>

                    <div class="modal-footer">
                        <button type="button" class="btn-cancel" onclick="closeModal('roleModal')">Hủy bỏ</button>
                        <button type="submit" class="btn-save">Xác nhận Lưu</button>
                    </div>
                </form>
            </div>
        </div>

        <div class="modal-overlay" id="lockModal">
            <div class="modal-content" style="width: 350px;">
                <h3>Trạng thái tài khoản</h3>
                <form action="hr" method="POST">
                    <input type="hidden" name="action" value="lock">
                    <input type="hidden" name="maNguoiDung" id="lockUserId">
                    <select name="trangThai" class="form-control">
                        <option value="true">Bình thường (Đang hoạt động)</option>
                        <option value="false">Khóa tài khoản</option>
                    </select>
                    <div class="modal-footer">
                        <button type="button" class="btn-cancel" onclick="closeModal('lockModal')">Hủy</button>
                        <button type="submit" class="btn-save">Lưu</button>
                    </div>
                </form>
            </div>
        </div>

        <script>
            // HÀM MỚI: QUÉT DỮ LIỆU BẢNG GỐC VÀ ĐỔ VÀO MODAL TÌM KIẾM
            function openSearchModal() {
                // Lấy từ khóa, chuyển thành chữ thường để tìm kiếm không phân biệt hoa/thường
                let keyword = document.getElementById('searchInput').value.trim().toLowerCase();
                let resultBody = document.getElementById('searchResultBody');

                // Xóa dữ liệu kết quả của lần tìm trước đó
                resultBody.innerHTML = '';

                if (keyword === '') {
                    alert("Vui lòng nhập tên hoặc ID để tìm kiếm!");
                    return;
                }

                // Lấy tất cả các dòng <tr> nằm trong <tbody> của bảng gốc
                let mainTableRows = document.querySelectorAll('#mainTableBody tr');
                let matchCount = 0;

                mainTableRows.forEach(row => {
                    // Cột 0 là ID, Cột 1 là Tên. Lấy nội dung chữ và ép thành chữ thường
                    let idText = row.cells[0].innerText.toLowerCase();
                    let nameText = row.cells[1].innerText.toLowerCase();

                    // Nếu ID hoặc Tên có chứa từ khóa
                    if (idText.includes(keyword) || nameText.includes(keyword)) {
                        // Sao chép nguyên si dòng đó (kéo theo cả các nút Sửa, Phân quyền có sẵn ID bên trong)
                        let clonedRow = row.cloneNode(true);
                        resultBody.appendChild(clonedRow);
                        matchCount++;
                    }
                });

                // Nếu không có ai khớp
                if (matchCount === 0) {
                    resultBody.innerHTML = '<tr><td colspan="8" style="text-align: center; padding: 25px; color: #c0392b; font-weight: bold;">Không tìm thấy nhân viên nào khớp với "' + keyword + '"</td></tr>';
                }

                // Hiển thị modal tìm kiếm
                document.getElementById('searchModal').style.display = 'flex';
            }


            // Các hàm cũ giữ nguyên
            function openEmployeeForm(mode, id, ten, ngaysinh, gioitinh, sdt, email, diachi, luong) {
                // Đóng luôn cái modal tìm kiếm nếu đang mở (để tránh chồng chéo 2 cái modal)
                closeModal('searchModal');

                const modal = document.getElementById('employeeModal');
                const title = document.getElementById('employeeModalTitle');
                const actionInput = document.getElementById('formAction');
                const form = modal.querySelector('form');

                form.reset();

                if (mode === 'add') {
                    title.innerText = 'Thêm nhân viên mới';
                    actionInput.value = 'add';
                } else if (mode === 'edit') {
                    title.innerText = 'Sửa thông tin';
                    actionInput.value = 'edit';
                    document.getElementById('editEmpId').value = id;
                    form.elements['hoTen'].value = ten;
                    form.elements['ngaySinh'].value = ngaysinh;
                    form.elements['gioiTinh'].value = gioitinh;
                    form.elements['sdt'].value = sdt;
                    form.elements['email'].value = email;
                    form.elements['diaChi'].value = diachi;
                    form.elements['luong'].value = luong;
                }
                modal.style.display = 'flex';
            }

            function openRoleForm(maNhanVien, maNguoiDung, maNhomHienTai) {
                closeModal('searchModal');
                document.getElementById('roleEmployeeId').value = maNhanVien;
                document.getElementById('roleUserId').value = maNguoiDung || '0';

                let radios = document.getElementsByName('selectedGroup');
                for (let i = 0; i < radios.length; i++) {
                    if (radios[i].value == maNhomHienTai) {
                        radios[i].checked = true;
                    }
                }
                // Đã xóa toggleNewGroupInput();
                document.getElementById('roleModal').style.display = 'flex';
            }
            // ĐÃ XÓA HÀM toggleNewGroupInput() Ở ĐÂY

            function toggleNewGroupInput() {
                let isNew = document.getElementById('radioNewGroup').checked;
                document.getElementById('divNewGroupName').style.display = isNew ? 'block' : 'none';
            }

            function closeModal(modalId) {
                document.getElementById(modalId).style.display = 'none';
            }

            function openLockForm(maNguoiDung) {
                closeModal('searchModal'); // Đóng bảng tìm kiếm nếu bấm từ bên trong nó
                document.getElementById('lockUserId').value = maNguoiDung;
                document.getElementById('lockModal').style.display = 'flex';
            }

            window.onclick = function (event) {
                let empModal = document.getElementById('employeeModal');
                let roleModal = document.getElementById('roleModal');
                let lockModal = document.getElementById('lockModal');
                let searchModal = document.getElementById('searchModal');

                if (event.target === empModal)
                    empModal.style.display = "none";
                if (event.target === roleModal)
                    roleModal.style.display = "none";
                if (event.target === lockModal)
                    lockModal.style.display = "none";
                if (event.target === searchModal)
                    searchModal.style.display = "none";
            }
            // Tự động ẩn thông báo sau 5 giây (5000 milliseconds)
            document.addEventListener("DOMContentLoaded", function () {
                var toast = document.getElementById("toastNotification");
                if (toast) {
                    setTimeout(function () {
                        // Thêm hiệu ứng mờ dần trước khi tắt
                        toast.style.transition = "opacity 0.5s ease";
                        toast.style.opacity = "0";
                        // Đợi mờ xong thì ẩn hẳn
                        setTimeout(() => toast.style.display = "none", 500);
                    }, 5000);
                }
            });
        </script>
    </body>
    <c:if test="${not empty toastMessage}">
        <div id="toastNotification" class="toast ${toastType}">
            <c:if test="${toastType == 'success'}">✅</c:if>
            <c:if test="${toastType == 'error'}">⚠️</c:if>
            ${toastMessage}
        </div>
    </c:if>
</html>