<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Smart Farmer - Thiết Lập Quy Trình</title>
    <style>
        body {
            margin: 0; padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-image: url('https://images.unsplash.com/photo-1625246333195-78d9c38ad449?q=80&w=1920&auto=format&fit=crop');
            background-size: cover; background-position: center;
            display: flex; height: 100vh; overflow: hidden; position: relative;
        }

        body::before {
            content: ""; position: absolute; inset: 0;
            background-color: rgba(20, 35, 20, 0.6); z-index: -1;
        }

        .main-wrapper { flex: 1; display: flex; flex-direction: column; overflow: hidden; }

        .header {
            height: 85px; background: rgba(255, 255, 255, 0.85); backdrop-filter: blur(20px);
            border-bottom: 1px solid rgba(255, 255, 255, 0.4);
            display: flex; align-items: center; justify-content: space-between;
            padding: 0 40px; box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05); z-index: 5;
        }
        .header-title h1 { margin: 0; font-size: 26px; font-weight: 800; color: #1a2419; }
        .user-profile { display: flex; align-items: center; gap: 20px; }
        .notification {
            position: relative; cursor: pointer; width: 45px; height: 45px;
            background: rgba(87, 156, 63, 0.1); border-radius: 50%;
            display: flex; justify-content: center; align-items: center;
        }
        .notification svg { width: 22px; height: 22px; fill: #2e541f; }
        .avatar {
            width: 45px; height: 45px; background: linear-gradient(135deg, #579c3f, #2e541f);
            color: #ffffff; border-radius: 12px; display: flex; justify-content: center; align-items: center;
            font-weight: 800; font-size: 18px; cursor: pointer;
        }

        .content-area { flex: 1; padding: 40px; overflow-y: auto; }
        
        .section-header {
            display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px;
        }
        .section-title { color: #ffffff; font-size: 22px; font-weight: 700; margin: 0; }
        
        .header-actions {
            display: flex; gap: 15px; align-items: center;
        }

        /* ================= THANH TÌM KIẾM MỚI ================= */
        .search-box {
            display: flex;
            align-items: center;
            background: white;
            border-radius: 8px;
            padding: 4px 6px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            margin: 0;
        }
        .search-box input[type="text"] {
            border: none;
            outline: none;
            padding: 8px 10px;
            width: 250px;
            font-size: 14px;
            background: transparent;
        }
        .search-box .btn-search {
            background: #f39c12;
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 6px;
            font-weight: 600;
            cursor: pointer;
            transition: 0.3s;
            display: flex;
            align-items: center;
            gap: 5px;
        }
        .search-box .btn-search:hover {
            background: #e67e22;
        }

        .btn-add {
            background-color: #579c3f; color: white; border: none; padding: 12px 20px;
            font-size: 14px; font-weight: 600; border-radius: 8px; cursor: pointer;
            display: flex; align-items: center; gap: 8px; box-shadow: 0 4px 12px rgba(87, 156, 63, 0.3);
            transition: all 0.3s; text-decoration: none;
        }
        .btn-add:hover { background-color: #467e32; transform: translateY(-1px); }

        .table-container {
            background: rgba(255, 255, 255, 0.95); backdrop-filter: blur(15px);
            border-radius: 16px; padding: 30px; box-shadow: 0px 8px 32px rgba(0, 0, 0, 0.15);
        }
        .data-info { font-size: 14px; color: #555; margin-bottom: 20px; font-weight: 500; }

        .custom-table { width: 100%; border-collapse: collapse; text-align: left; }
        .custom-table th { padding: 16px; border-bottom: 2px solid #eef2f5; color: #7f8c8d; font-size: 13px; font-weight: 700; text-transform: uppercase; }
        .custom-table td { padding: 16px; border-bottom: 1px solid #eef2f5; color: #2c3e50; font-size: 14px; font-weight: 600; vertical-align: middle; }
        
        .status-badge {
            background-color: #fff3cd; color: #856404; border: 1px solid #ffeeba;
            padding: 6px 12px; border-radius: 20px; font-size: 12px; font-weight: 700; display: inline-block;
        }
        .status-badge.active-status {
            background-color: #e6f4ea; color: #1e8e3e; border: 1px solid #cce8d6;
        }

        .desc-column { max-width: 180px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; font-weight: 500; color: #555; }

        .action-buttons { display: flex; gap: 8px; align-items: center; }
        .btn-action-edit {
            background-color: #f39c12; color: white; padding: 6px 14px; 
            border-radius: 6px; font-size: 13px; font-weight: bold; cursor: pointer; border: none;
            text-decoration: none; display: inline-block;
        }
        .btn-action-edit:hover { background-color: #e67e22; }

        .btn-action-delete {
            background-color: #e74c3c; color: white; padding: 6px 14px; 
            border-radius: 6px; font-size: 13px; font-weight: bold; cursor: pointer; border: none;
            display: inline-block; font-family: inherit;
        }
        .btn-action-delete:hover { background-color: #c0392b; }

        .modal-toggle { display: none; }

        .modal-overlay {
            position: fixed; inset: 0; background: rgba(0, 0, 0, 0.6);
            display: flex; justify-content: center; align-items: center; z-index: 999;
            opacity: 0; pointer-events: none; transition: opacity 0.3s ease;
        }

        .modal-container {
            background: #ffffff; width: 100%; max-width: 600px; border-radius: 16px;
            padding: 35px; box-shadow: 0 10px 40px rgba(0,0,0,0.3);
            position: relative; transform: translateY(-30px); transition: transform 0.3s ease;
            max-height: 90vh; overflow-y: auto;
        }

        #createModalToggle:checked ~ .modal-overlay#modalOverlay { opacity: 1; pointer-events: auto; }
        #createModalToggle:checked ~ .modal-overlay#modalOverlay .modal-container { transform: translateY(0); }

        <c:forEach var="item" items="${farmingPracticeList}">
        #editToggle-${item.maQuyTrinh}:checked ~ .modal-overlay#editModal-${item.maQuyTrinh} { opacity: 1; pointer-events: auto; }
        #editToggle-${item.maQuyTrinh}:checked ~ .modal-overlay#editModal-${item.maQuyTrinh} .modal-container { transform: translateY(0); }
        </c:forEach>

        .modal-close {
            position: absolute; top: 20px; right: 20px; background: none; border: none;
            font-size: 24px; color: #aaa; cursor: pointer; display: inline-block; line-height: 1;
        }
        .modal-close:hover { color: #e74c3c; }

        .modal-title { font-size: 22px; font-weight: 800; color: #1a2419; margin-top: 0; margin-bottom: 20px; }
        
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; font-weight: 700; margin-bottom: 8px; color: #1a2419; font-size: 14px; }
        .form-group input[type="text"], .form-group textarea, .form-group select { width: 100%; padding: 12px; border: 1px solid #ccc; border-radius: 8px; font-size: 14px; box-sizing: border-box; font-family: inherit; }
        
        .btn-submit { width: 100%; background: #579c3f; color: white; border: none; padding: 14px; font-size: 15px; font-weight: bold; border-radius: 8px; cursor: pointer; margin-top: 10px; transition: background 0.3s; }
        .btn-submit:hover { background: #467e32; }
        .note-panel { margin-top: 20px; font-size: 12px; color: #c0392b; font-style: italic; background: #fdf2e9; padding: 10px; border-radius: 6px; border-left: 4px solid #e67e22; }

        .btn-cancel { background-color: #6c757d; color: white; padding: 10px 20px; border-radius: 6px; cursor: pointer; border: none; font-size: 14px; text-decoration: none; font-weight: bold; display: inline-block; }
        .btn-cancel:hover { background-color: #5a6268; }
        .btn-save { background-color: #28a745; color: white; padding: 10px 20px; border-radius: 6px; cursor: pointer; border: none; font-size: 14px; font-weight: bold; display: inline-block; }
        .btn-save:hover { background-color: #218838; }

        /* ================= THÔNG BÁO ================= */
        .alert-banner { padding: 14px 20px; border-radius: 10px; margin-bottom: 20px; font-weight: 600; box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1); }
        .alert-success { background: #e8f5e9; color: #2e7d32; border-left: 5px solid #2e7d32; }
        .alert-error { background: #ffebee; color: #c62828; border-left: 5px solid #c62828; }
    </style>
</head>
<body>

    <input type="checkbox" id="createModalToggle" class="modal-toggle">
    
    <c:forEach var="item" items="${farmingPracticeList}">
        <input type="checkbox" id="editToggle-${item.maQuyTrinh}" class="modal-toggle">
    </c:forEach>

    <jsp:include page="/views/common/sidebar.jsp">
        <jsp:param name="activePage" value="technician" />
    </jsp:include>

    <div class="main-wrapper">
        <jsp:include page="/views/common/header.jsp">
            <jsp:param name="pageTitle" value="Thiết Lập Quy Trình" />
        </jsp:include>
        
        <main class="content-area">
            
            <%-- HIỂN THỊ THÔNG BÁO THÀNH CÔNG HOẶC LỖI --%>
            <c:if test="${not empty SUCCESS_MSG}">
                <div class="alert-banner alert-success">✔ ${SUCCESS_MSG}</div>
            </c:if>
            <c:if test="${not empty ERROR_MSG}">
                <div class="alert-banner alert-error">✖ ${ERROR_MSG}</div>
            </c:if>

            <div class="section-header">
                <h2 class="section-title">Danh sách bộ quy chuẩn canh tác</h2>
                
                <div class="header-actions">
                    <%-- THANH TÌM KIẾM MỚI (DÙNG JAVASCRIPT) --%>
                    <div class="search-box">
                        <input type="text" id="searchInput" placeholder="Nhập tên hoặc ID quy trình..." onkeydown="if(event.key==='Enter') openSearchModal()">
                        <button class="btn-search" onclick="openSearchModal()">🔍 Tìm kiếm</button>
                    </div>
                    
                    <label for="createModalToggle" class="btn-add">+ Tạo bộ quy chuẩn</label>
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
                    <tbody id="mainTableBody">
                        <c:forEach var="item" items="${farmingPracticeList}">
                            <tr>
                                <td>${item.maQuyTrinh}</td>
                                <td><strong>${item.tenQuyTrinh}</strong></td>
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
                                        <form action="${pageContext.request.contextPath}/technician" method="POST" style="margin: 0;" onsubmit="return confirm('Bạn có chắc chắn muốn xóa quy trình này không?');">
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

    <%-- MODAL TẠO MỚI --%>
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

    <%-- MODAL CẬP NHẬT --%>
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
    </c:forEach>

    <%-- MODAL KẾT QUẢ TÌM KIẾM (MỚI THÊM) --%>
    <div class="modal-overlay" id="searchModal" style="opacity: 0; pointer-events: none; transition: opacity 0.3s ease;">
        <div class="modal-container" style="max-width: 900px; transform: translateY(0);">
            <button class="modal-close" onclick="closeSearchModal()">&times;</button>
            <h3 class="modal-title" style="color: #2e541f; border-bottom: 2px solid #579c3f; padding-bottom: 10px;">Kết quả Tìm kiếm</h3>
            <div class="table-container" style="box-shadow: none; border: 1px solid #ddd; padding: 10px; max-height: 400px; overflow-y: auto; border-radius: 8px;">
                <table class="custom-table" style="width: 100%;">
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
                    <tbody id="searchResultBody">
                        <%-- Kết quả lọc bằng JS sẽ được nhét vào đây --%>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <%-- SCRIPT XỬ LÝ TÌM KIẾM BẰNG JS --%>
    <script>
        function openSearchModal() {
            let keyword = document.getElementById('searchInput').value.trim().toLowerCase();
            let resultBody = document.getElementById('searchResultBody');
            let modal = document.getElementById('searchModal');
            
            resultBody.innerHTML = ''; // Làm sạch modal cũ
            
            if (keyword === '') {
                alert("Vui lòng nhập từ khóa tìm kiếm!");
                return;
            }

            // Lấy tất cả các dòng dữ liệu trong bảng chính
            let rows = document.querySelectorAll('#mainTableBody tr');
            let matchCount = 0;

            rows.forEach(row => {
                // Kiểm tra xem dòng này có phải là dòng chứa dữ liệu không
                if (row.cells.length > 1) {
                    let id = row.cells[0].innerText.toLowerCase();
                    let name = row.cells[1].innerText.toLowerCase();
                    
                    if (id.includes(keyword) || name.includes(keyword)) {
                        // Nếu khớp, clone dòng đó ném vào modal
                        let clonedRow = row.cloneNode(true);
                        resultBody.appendChild(clonedRow);
                        matchCount++;
                    }
                }
            });

            // Nếu không tìm thấy
            if (matchCount === 0) {
                resultBody.innerHTML = '<tr><td colspan="8" style="text-align:center; padding: 20px; color: #c0392b; font-weight: bold;">Không tìm thấy quy trình nào khớp với "' + keyword + '"</td></tr>';
            }

            // Hiện Modal
            modal.style.opacity = '1';
            modal.style.pointerEvents = 'auto';
        }

        function closeSearchModal() {
            let modal = document.getElementById('searchModal');
            modal.style.opacity = '0';
            modal.style.pointerEvents = 'none';
        }
    </script>
</body>
</html>