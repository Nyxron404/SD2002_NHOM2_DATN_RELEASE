<%-- 
    Document   : admin_hr_management
    Created on : Jun 30, 2026
    Author     : longd (Modified for HR Management with Modals)
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
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

            /* ================= SIDEBAR ================= */
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

            .logo-area svg {
                width: 36px;
                height: 36px;
                filter: drop-shadow(0px 2px 4px rgba(0,0,0,0.15));
            }
            .logo-area h2 {
                margin: 0;
                font-size: 22px;
                font-weight: 850;
                background: linear-gradient(135deg, #1e4512, #467e32);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
            }

            .menu {
                list-style: none;
                padding: 25px 0;
                margin: 0;
                flex: 1;
                overflow-y: auto;
            }
            .menu-item {
                padding: 14px 25px;
                display: flex;
                align-items: center;
                gap: 15px;
                color: #1a2419;
                text-decoration: none;
                font-weight: 700;
                font-size: 15px;
                transition: all 0.3s ease;
                border-left: 5px solid transparent;
            }

            .menu-item:hover, .menu-item.active {
                background: linear-gradient(90deg, rgba(87, 156, 63, 0.15) 0%, rgba(255, 255, 255, 0) 100%);
                border-left-color: #579c3f;
                color: #467e32;
            }
            .menu-item svg {
                width: 22px;
                height: 22px;
                fill: currentColor;
            }

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
                backdrop-filter: blur(20px);
                -webkit-backdrop-filter: blur(20px);
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
                transition: background 0.3s;
            }
            .notification:hover {
                background: rgba(87, 156, 63, 0.2);
            }
            .notification svg {
                width: 22px;
                height: 22px;
                fill: #2e541f;
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
                box-shadow: 0 4px 10px rgba(46, 84, 31, 0.3);
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
            .btn-unlock {
                background: #2ecc71;
            }
            .btn-unlock:hover {
                background: #27ae60;
            }
            .btn-delete {
                background: #7f8c8d;
            }
            .btn-delete:hover {
                background: #95a5a6;
            }

            /* ================= MODAL (FORM BẬT LÊN) ================= */
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
            .btn-cancel {
                padding: 10px 20px;
                background: #f1f2f6;
                color: #333;
                border: none;
                border-radius: 8px;
                font-weight: 600;
                cursor: pointer;
            }
            .btn-cancel:hover {
                background: #dfe4ea;
            }
            .btn-save {
                padding: 10px 20px;
                background: #579c3f;
                color: white;
                border: none;
                border-radius: 8px;
                font-weight: 600;
                cursor: pointer;
            }
            .btn-save:hover {
                background: #467e32;
            }

        </style>
    </head>
    <body>

        <jsp:include page="/views/common/sidebar.jsp">
            <jsp:param name="activePage" value="hrManager" />
        </jsp:include>

        <div class="main-wrapper">
            <header class="header">
                <div class="header-title">
                    <h1>Quản Lý Kho Vật Tư</h1>
                </div>
                <div class="user-profile">
                    <div class="notification"><svg viewBox="0 0 24 24"><path d="M12 22c1.1 0 2-.9 2-2h-4c0 1.1.9 2 2 2zm6-6v-5c0-3.07-1.63-5.64-4.5-6.32V4c0-.83-.67-1.5-1.5-1.5s-1.5.67-1.5 1.5v.68C7.64 5.36 6 7.92 6 11v5l-2 2v1h16v-1l-2-2zm-2 1H8v-6c0-2.48 1.51-4.5 4-4.5s4 2.02 4 4.5v6z"/></svg><span class="badge"></span></div>
                    <div class="avatar">A</div>
                </div>
            </header>

            <main class="content-area">

                <div class="page-toolbar">
                    <h2>Danh sách nhân viên</h2>
                    <button class="btn-add" onclick="openEmployeeForm('add')">
                        <svg viewBox="0 0 24 24" width="20" height="20" fill="white"><path d="M19 13h-6v6h-2v-6H5v-2h6V5h2v6h6v2z"/></svg>
                        Thêm nhân viên
                    </button>
                </div>

                <div class="table-card">
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Họ và Tên</th>
                                <th>SĐT / Email</th>
                                <th>Quyền / Chức vụ</th>
                                <th>Trạng thái</th>
                                <th>Hành động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>1</td>
                                <td>Đặng Thành Long</td>
                                <td>0822069476 <br> <small style="color: #666">longdazng@gmail.com</small></td>
                                <td><span class="role-badge">Admin</span></td>
                                <td><span class="status-badge status-active">Hoạt động</span></td>
                                <td>
                                    <div class="action-btns">
                                        <button class="btn-action btn-edit" title="Sửa" onclick="openEmployeeForm('edit')">Sửa</button>
                                        <button class="btn-action btn-role" title="Đổi Quyền" onclick="openRoleForm()">Đổi Quyền</button>
                                        <button class="btn-action btn-lock" title="Khóa">Khóa</button>
                                    </div>
                                </td>
                            </tr>

                            <tr>
                                <td>2</td>
                                <td>Phạm Văn Minh</td>
                                <td>0387789504 <br> <small style="color: #666">minhpvth08530@gmail.com</small></td>
                                <td><span class="role-badge">Worker</span></td>
                                <td><span class="status-badge status-active">Hoạt động</span></td>
                                <td>
                                    <div class="action-btns">
                                        <button class="btn-action btn-edit" title="Sửa" onclick="openEmployeeForm('edit')">Sửa</button>
                                        <button class="btn-action btn-role" title="Đổi Quyền" onclick="openRoleForm()">Đổi Quyền</button>
                                        <button class="btn-action btn-lock" title="Khóa">Khóa</button>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </main>
        </div>

        <div class="modal-overlay" id="employeeModal">
            <div class="modal-content">
                <div class="modal-header">
                    <h3 id="employeeModalTitle">Thêm nhân viên mới</h3>
                    <button class="close-btn" onclick="closeModal('employeeModal')">&times;</button>
                </div>
                <form action="EmployeeServlet" method="POST">
                    <input type="hidden" name="action" id="formAction" value="add">

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

        <div class="modal-overlay" id="roleModal">
            <div class="modal-content" style="width: 400px;">
                <div class="modal-header">
                    <h3>Thay đổi Quyền / Chức vụ</h3>
                    <button class="close-btn" onclick="closeModal('roleModal')">&times;</button>
                </div>
                <form action="RoleServlet" method="POST">
                    <input type="hidden" name="maNhanVien" id="roleEmployeeId" value="">

                    <div class="form-group">
                        <label>Chọn chức vụ mới</label>
                        <select name="role" class="form-control" required>
                            <option value="admin">Admin</option>
                            <option value="equipment_manager">Equipment Manager</option>
                            <option value="farm_owner">Farm Owner</option>
                            <option value="hr_manager">HR Manager</option>
                            <option value="inventory_manager">Inventory Manager</option>
                            <option value="technician">Technician</option>
                            <option value="worker">Worker</option>
                        </select>
                    </div>

                    <div class="modal-footer">
                        <button type="button" class="btn-cancel" onclick="closeModal('roleModal')">Hủy bỏ</button>
                        <button type="submit" class="btn-save">Cập nhật quyền</button>
                    </div>
                </form>
            </div>
        </div>

        <script>
            // Hàm mở Form Thêm/Sửa
            function openEmployeeForm(mode) {
                const modal = document.getElementById('employeeModal');
                const title = document.getElementById('employeeModalTitle');
                const actionInput = document.getElementById('formAction');

                if (mode === 'add') {
                    title.innerText = 'Thêm nhân viên mới';
                    actionInput.value = 'add';
                    // Reset form rỗng nếu muốn thêm mới
                    modal.querySelector('form').reset();
                } else if (mode === 'edit') {
                    title.innerText = 'Sửa thông tin nhân viên';
                    actionInput.value = 'edit';
                    // Tại đây bạn có thể dùng JS đổ dữ liệu cũ vào form nếu cần
                }

                modal.style.display = 'flex';
            }

            // Hàm mở Form Đổi quyền
            function openRoleForm() {
                document.getElementById('roleModal').style.display = 'flex';
            }

            // Hàm đóng chung cho các Form
            function closeModal(modalId) {
                document.getElementById(modalId).style.display = 'none';
            }

            // Click ra ngoài khoảng xám để đóng Form
            window.onclick = function (event) {
                let empModal = document.getElementById('employeeModal');
                let roleModal = document.getElementById('roleModal');
                if (event.target == empModal) {
                    empModal.style.display = "none";
                }
                if (event.target == roleModal) {
                    roleModal.style.display = "none";
                }
            }
        </script>
    </body>
</html>