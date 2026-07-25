<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản Lý Khu Vực</title>
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
            .content-area { flex: 1; padding: 40px; overflow-y: auto; }

            .page-toolbar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; }
            .page-toolbar h2 { margin: 0; color: #ffffff; font-size: 24px; font-weight: 700; text-shadow: 0 2px 4px rgba(0,0,0,0.5); }

            .btn-add {
                background: linear-gradient(135deg, #579c3f, #396728); color: white; border: none;
                padding: 12px 24px; border-radius: 8px; font-size: 15px; font-weight: bold; cursor: pointer;
                box-shadow: 0 4px 15px rgba(87, 156, 63, 0.4); display: flex; align-items: center; gap: 8px; transition: 0.3s;
            }
            .btn-add:hover { transform: translateY(-2px); box-shadow: 0 6px 20px rgba(87, 156, 63, 0.6); }

            .table-card {
                background: rgba(255, 255, 255, 0.95); backdrop-filter: blur(15px);
                border-radius: 16px; padding: 25px; border: 1px solid rgba(255, 255, 255, 0.6);
                box-shadow: 0px 8px 32px rgba(0, 0, 0, 0.15); overflow-x: auto;
            }
            table { width: 100%; border-collapse: collapse; }
            th, td { padding: 16px; text-align: left; border-bottom: 1px solid rgba(0, 0, 0, 0.08); }
            th { color: green; font-weight: 700; text-transform: uppercase; font-size: 14px; }
            td { color: #1a2419; font-weight: 600; font-size: 14px; }

            .badge-type {
                background: #eef2f5; color: #2c3e50; padding: 5px 10px; border-radius: 6px;
                font-size: 13px; font-weight: 600; border: 1px solid #dfe4ea;
            }

            .btn-action {
                border: none; padding: 8px 15px; border-radius: 6px; font-size: 13px;
                font-weight: 600; cursor: pointer; color: white; transition: 0.2s; background: #f39c12;
            }
            .btn-action:hover { background: #e67e22; }

            /* ================= MODAL ================= */
            .modal-overlay {
                position: fixed; inset: 0; background: rgba(0, 0, 0, 0.6); z-index: 100;
                display: none; justify-content: center; align-items: center; backdrop-filter: blur(5px);
            }
            .modal-content {
                background: white; width: 500px; max-width: 90%; border-radius: 16px;
                padding: 30px; box-shadow: 0 10px 40px rgba(0, 0, 0, 0.3); animation: slideIn 0.3s ease-out;
            }
            @keyframes slideIn { from { transform: translateY(-30px); opacity: 0; } to { transform: translateY(0); opacity: 1; } }
            
            .modal-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; border-bottom: 1px solid #eee; padding-bottom: 10px; }
            .modal-header h3 { margin: 0; color: #2e541f; font-size: 20px; font-weight: 700; }
            .close-btn { background: none; border: none; font-size: 24px; cursor: pointer; color: #999; }
            .close-btn:hover { color: #e74c3c; }

            .form-row { display: flex; gap: 15px; }
            .form-row .form-group { flex: 1; }
            .form-group { margin-bottom: 15px; }
            .form-group label { display: block; margin-bottom: 8px; font-weight: 600; color: #444; font-size: 14px; }
            .form-control { width: 100%; padding: 10px 12px; border: 1px solid #ddd; border-radius: 8px; font-size: 14px; box-sizing: border-box; transition: 0.3s; font-family: inherit; }
            .form-control:focus { outline: none; border-color: #579c3f; box-shadow: 0 0 0 3px rgba(87,156,63,0.1); }
            
            .modal-footer { display: flex; justify-content: flex-end; gap: 10px; margin-top: 25px; }
            .btn-cancel { background: #f1f2f6; color: #333; padding: 10px 20px; border: none; border-radius: 8px; font-weight: 600; cursor: pointer; }
            .btn-save { background: #579c3f; color: white; padding: 10px 20px; border: none; border-radius: 8px; font-weight: 600; cursor: pointer; }
            .btn-cancel:hover { background: #dfe4ea; }
            .btn-save:hover { background: #467e32; }
        </style>
    </head>
    <body>
        
        <!-- NẠP SIDEBAR: Truyền param activePage là farmArea để tự động highlight menu -->
        <jsp:include page="/views/common/sidebar.jsp">
            <jsp:param name="activePage" value="farmArea" />
        </jsp:include>
        
        <div class="main-wrapper">
            <!-- NẠP HEADER -->
            <jsp:include page="/views/common/header.jsp">
                <jsp:param name="pageTitle" value="Quản Lý Khu Vực" />
            </jsp:include>
            
            <main class="content-area">
                <div class="page-toolbar">
                    <h2>Danh sách lô đất / khu vực</h2>
                    <button class="btn-add" onclick="openAreaForm('add')">
                        <svg viewBox="0 0 24 24" width="20" height="20" fill="white"><path d="M19 13h-6v6h-2v-6H5v-2h6V5h2v6h6v2z"/></svg>
                        Thêm khu vực
                    </button>
                </div>

                <div class="table-card">
                    <table>
                        <thead>
                            <tr>
                                <th>Mã KV</th>
                                <th>Tên Khu Vực</th>
                                <th>Loại Khu Vực</th>
                                <th>Diện Tích (m²)</th>
                                <th>Mô Tả</th>
                                <th>Hành Động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="area" items="${LIST_FARM_AREA}">
                                <tr>
                                    <td>#${area.getMaKhuVuc()}</td>
                                    <td><strong>${area.getTenKhuVuc()}</strong></td>
                                    <td><span class="badge-type">${area.getLoaiKhuVuc()}</span></td>
                                    <td>${area.getDienTich()} m²</td>
                                    <td>${empty area.getMoTa() ? 'Không có mô tả' : area.getMoTa()}</td>
                                    <td>
                                        <button class="btn-action" onclick="openAreaForm('edit', '${area.getMaKhuVuc()}', '${area.getTenKhuVuc()}', '${area.getLoaiKhuVuc()}', '${area.getDienTich()}', '${area.getMoTa()}')">Chỉnh sửa</button>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty LIST_FARM_AREA}">
                                <tr>
                                    <td colspan="6" style="text-align: center; color: #7f8c8d; padding: 20px;">
                                        Chưa có dữ liệu khu vực.
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </main>
        </div>

        <!-- MODAL THÊM / SỬA KHU VỰC -->
        <div class="modal-overlay" id="areaModal">
            <div class="modal-content">
                <div class="modal-header">
                    <h3 id="modalTitle">Thêm khu vực mới</h3>
                    <button class="close-btn" onclick="closeModal()">&times;</button>
                </div>
                <form action="${pageContext.request.contextPath}/farmarea" method="POST" autocomplete="off">
                    <input type="hidden" name="action" id="formAction" value="add">
                    <input type="hidden" name="maKhuVuc" id="maKhuVuc">
                    
                    <div class="form-group">
                        <label>Tên khu vực (Ví dụ: Lô Đất A1, Chuồng Heo C2)</label>
                        <input type="text" name="tenKhuVuc" id="tenKhuVuc" class="form-control" required>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label>Loại khu vực</label>
                            <select name="loaiKhuVuc" id="loaiKhuVuc" class="form-control">
                                <option value="Đất trồng">Đất trồng</option>
                                <option value="Nhà kính">Nhà kính</option>
                                <option value="Chuồng trại">Chuồng trại</option>
                                <option value="Kho bãi">Kho bãi</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Diện tích (m²)</label>
                            <input type="number" step="0.01" min="0" name="dienTich" id="dienTich" class="form-control" required>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label>Mô tả chi tiết</label>
                        <textarea name="moTa" id="moTa" class="form-control" style="resize:vertical; min-height:80px;"></textarea>
                    </div>
                    
                    <div class="modal-footer">
                        <button type="button" class="btn-cancel" onclick="closeModal()">Hủy</button>
                        <button type="submit" class="btn-save">Lưu dữ liệu</button>
                    </div>
                </form>
            </div>
        </div>

        <script>
            function openAreaForm(mode, id, ten, loai, dientich, mota) {
                const modal = document.getElementById('areaModal');
                
                if (mode === 'edit') {
                    document.getElementById('modalTitle').innerText = 'Sửa thông tin khu vực';
                    document.getElementById('formAction').value = 'update';
                    
                    document.getElementById('maKhuVuc').value = id;
                    document.getElementById('tenKhuVuc').value = ten;
                    document.getElementById('loaiKhuVuc').value = loai;
                    document.getElementById('dienTich').value = dientich;
                    document.getElementById('moTa').value = mota;
                } else {
                    document.getElementById('modalTitle').innerText = 'Thêm khu vực mới';
                    document.getElementById('formAction').value = 'add';
                    
                    document.getElementById('maKhuVuc').value = '';
                    document.getElementById('tenKhuVuc').value = '';
                    document.getElementById('loaiKhuVuc').value = 'Đất trồng';
                    document.getElementById('dienTich').value = '';
                    document.getElementById('moTa').value = '';
                }
                modal.style.display = 'flex';
            }

            function closeModal() {
                document.getElementById('areaModal').style.display = 'none';
            }

            window.onclick = function (e) {
                const modal = document.getElementById('areaModal');
                if (e.target === modal) {
                    modal.style.display = 'none';
                }
            };
        </script>
    </body>
</html>