<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Smart Farmer - Quản lý thiết bị</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
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
        .header {
            height: 75px;
            background: rgba(255, 255, 255, 0.85);
            backdrop-filter: blur(20px);
            border-bottom: 1px solid rgba(255, 255, 255, 0.4);
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 40px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
            z-index: 5;
            flex-shrink: 0;
        }
        .header-title h1 {
            margin: 0;
            font-size: 24px;
            font-weight: 800;
            color: #1a2419;
        }
        .header-title small {
            font-size: 13px;
            color: #666;
            font-weight: 400;
            margin-left: 10px;
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
            border: none;
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
            font-size: 10px;
            font-weight: 800;
            padding: 2px 6px;
            border-radius: 12px;
            min-width: 18px;
            text-align: center;
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
            padding: 25px 35px;
            overflow-y: auto;
        }
        .alert {
            padding: 14px 18px;
            border-radius: 12px;
            margin-bottom: 18px;
            font-weight: 500;
            backdrop-filter: blur(10px);
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .alert-success {
            background: rgba(212, 237, 218, 0.95);
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .alert-error {
            background: rgba(248, 215, 218, 0.95);
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .alert-info {
            background: rgba(204, 229, 255, 0.95);
            color: #004085;
            border: 1px solid #b8daff;
        }
        .alert .close-alert {
            margin-left: auto;
            cursor: pointer;
            font-size: 18px;
            color: inherit;
            opacity: 0.6;
            background: none;
            border: none;
        }
        .alert .close-alert:hover {
            opacity: 1;
        }
        .stats-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));
            gap: 12px;
            margin-bottom: 20px;
        }
        .stat-card {
            background: rgba(255, 255, 255, 0.12);
            backdrop-filter: blur(10px);
            border-radius: 12px;
            padding: 14px 18px;
            border: 1px solid rgba(255, 255, 255, 0.15);
            text-align: center;
            transition: 0.3s;
            cursor: pointer;
        }
        .stat-card:hover {
            transform: translateY(-3px);
            background: rgba(255, 255, 255, 0.2);
        }
        .stat-card .number {
            font-size: 26px;
            font-weight: 800;
            color: white;
        }
        .stat-card .label {
            font-size: 12px;
            color: rgba(255, 255, 255, 0.7);
            margin-top: 4px;
        }
        .tabs-container {
            margin-bottom: 20px;
        }
        .tabs {
            display: flex;
            gap: 5px;
            border-bottom: 2px solid rgba(255, 255, 255, 0.2);
            padding-bottom: 0;
            flex-wrap: wrap;
        }
        .tab-btn {
            padding: 12px 24px;
            background: rgba(255, 255, 255, 0.1);
            border: none;
            border-radius: 10px 10px 0 0;
            font-size: 14px;
            font-weight: 600;
            color: rgba(255, 255, 255, 0.7);
            cursor: pointer;
            transition: 0.3s;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .tab-btn:hover {
            background: rgba(255, 255, 255, 0.2);
            color: white;
        }
        .tab-btn.active {
            background: rgba(255, 255, 255, 0.2);
            color: white;
            border-bottom: 3px solid #7cb342;
        }
        .tab-btn .tab-count {
            background: rgba(255, 255, 255, 0.2);
            padding: 1px 10px;
            border-radius: 12px;
            font-size: 12px;
        }
        .tab-btn.active .tab-count {
            background: #7cb342;
            color: white;
        }
        .tab-content {
            display: none;
            animation: fadeIn 0.3s ease;
        }
        .tab-content.active {
            display: block;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .page-toolbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 18px;
            flex-wrap: wrap;
            gap: 12px;
        }
        .page-toolbar-left {
            display: flex;
            align-items: center;
            gap: 15px;
            flex-wrap: wrap;
        }
        .page-toolbar h2 {
            margin: 0;
            color: #ffffff;
            font-size: 22px;
            font-weight: 700;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.5);
        }
        .search-box {
            display: flex;
            background: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(10px);
            border-radius: 10px;
            overflow: hidden;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }
        .search-box input {
            padding: 9px 14px;
            border: none;
            background: transparent;
            color: white;
            font-size: 14px;
            width: 200px;
            outline: none;
        }
        .search-box input::placeholder {
            color: rgba(255, 255, 255, 0.6);
        }
        .search-box button {
            padding: 9px 14px;
            border: none;
            background: rgba(87, 156, 63, 0.7);
            color: white;
            cursor: pointer;
            font-weight: 600;
            transition: 0.3s;
        }
        .search-box button:hover {
            background: #579c3f;
        }
        .toolbar-actions {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }
        .btn {
            padding: 9px 18px;
            border: none;
            border-radius: 8px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            transition: 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            text-decoration: none;
        }
        .btn-add {
            background: linear-gradient(135deg, #579c3f, #396728);
            color: white;
            box-shadow: 0 4px 15px rgba(87, 156, 63, 0.4);
        }
        .btn-add:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(87, 156, 63, 0.6);
        }
        .btn-outline {
            background: transparent;
            color: white;
            border: 2px solid rgba(255, 255, 255, 0.4);
        }
        .btn-outline:hover {
            background: rgba(255, 255, 255, 0.1);
            border-color: white;
        }
        .btn-primary {
            background: #579c3f;
            color: white;
        }
        .btn-primary:hover {
            background: #396728;
        }
        .btn-danger {
            background: #e74c3c;
            color: white;
        }
        .btn-danger:hover {
            background: #c0392b;
        }
        .btn-success {
            background: #27ae60;
            color: white;
        }
        .btn-success:hover {
            background: #1e8449;
        }
        .btn-warning {
            background: #f39c12;
            color: white;
        }
        .btn-warning:hover {
            background: #d68910;
        }
        .btn-sm {
            padding: 4px 10px;
            font-size: 11px;
            border-radius: 5px;
        }
        .table-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(15px);
            border-radius: 14px;
            padding: 18px;
            border: 1px solid rgba(255, 255, 255, 0.6);
            box-shadow: 0px 8px 32px rgba(0, 0, 0, 0.15);
            overflow-x: auto;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 13px;
        }
        th, td {
            padding: 12px 10px;
            text-align: left;
            border-bottom: 1px solid rgba(0, 0, 0, 0.06);
        }
        th {
            color: #4a5c43;
            font-weight: 700;
            text-transform: uppercase;
            font-size: 11px;
            letter-spacing: 0.5px;
            background: #f8f9fa;
        }
        td {
            color: #1a2419;
        }
        tr:hover td {
            background: rgba(87, 156, 63, 0.04);
        }
        .status-badge {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 700;
            display: inline-block;
        }
        .status-ready {
            background: #e8f5e9;
            color: #2e7d32;
        }
        .status-inuse {
            background: #e3f2fd;
            color: #1565c0;
        }
        .status-maintenance {
            background: #fff8e1;
            color: #f57f17;
        }
        .status-broken {
            background: #ffebee;
            color: #c62828;
        }
        .status-pending {
            background: #fff8e1;
            color: #f57f17;
        }
        .status-completed {
            background: #e8f5e9;
            color: #2e7d32;
        }
        .status-overdue {
            background: #fbe9e7;
            color: #c62828;
        }
        .type-badge {
            background: #f1f2f6;
            color: #2f3542;
            padding: 3px 8px;
            border-radius: 4px;
            font-size: 11px;
            font-weight: 600;
            border: 1px solid #dfe4ea;
            display: inline-block;
        }
        .action-btns {
            display: flex;
            gap: 4px;
            flex-wrap: wrap;
        }
        .btn-action {
            border: none;
            padding: 4px 10px;
            border-radius: 5px;
            font-size: 11px;
            font-weight: 600;
            cursor: pointer;
            color: white;
            transition: 0.2s;
        }
        .btn-action:hover {
            transform: scale(1.05);
        }
        .btn-status {
            background: #f39c12;
        }
        .btn-status:hover {
            background: #e67e22;
        }
        .btn-borrow {
            background: #9b59b6;
        }
        .btn-borrow:hover {
            background: #8e44ad;
        }
        .btn-return {
            background: #1abc9c;
        }
        .btn-return:hover {
            background: #16a085;
        }
        .btn-maintenance {
            background: #e74c3c;
        }
        .btn-maintenance:hover {
            background: #c0392b;
        }
        .btn-result {
            background: #2ecc71;
        }
        .btn-result:hover {
            background: #27ae60;
        }
        .btn-history {
            background: #34495e;
        }
        .btn-history:hover {
            background: #2c3e50;
        }
        .btn-disabled {
            opacity: 0.4;
            cursor: not-allowed;
        }
        .btn-disabled:hover {
            transform: none;
        }
        .empty-message {
            text-align: center;
            padding: 35px;
            color: #999;
            font-size: 15px;
        }
        .modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.6);
            z-index: 1000;
            display: none;
            justify-content: center;
            align-items: center;
            backdrop-filter: blur(5px);
        }
        .modal-overlay.show {
            display: flex;
        }
        .modal-content {
            background: white;
            width: 580px;
            max-width: 95%;
            border-radius: 16px;
            padding: 28px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.3);
            animation: slideIn 0.3s ease-out;
            max-height: 90vh;
            overflow-y: auto;
        }
        .modal-lg {
            width: 750px;
        }
        .modal-sm {
            width: 420px;
        }
        @keyframes slideIn {
            from { transform: translateY(-30px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }
        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 18px;
            border-bottom: 1px solid #eee;
            padding-bottom: 12px;
        }
        .modal-header h3 {
            margin: 0;
            color: #2e541f;
            font-size: 20px;
            font-weight: 700;
        }
        .modal-header .sub-title {
            font-size: 12px;
            color: #888;
            font-weight: 400;
            background: #f1f2f6;
            padding: 2px 10px;
            border-radius: 12px;
            margin-left: 10px;
        }
        .modal-close {
            background: none;
            border: none;
            font-size: 28px;
            cursor: pointer;
            color: #999;
            line-height: 1;
            transition: 0.3s;
        }
        .modal-close:hover {
            color: #e74c3c;
            transform: rotate(90deg);
        }
        .form-row {
            display: flex;
            gap: 15px;
        }
        .form-row .form-group {
            flex: 1;
        }
        .form-group {
            margin-bottom: 14px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: 600;
            color: #444;
            font-size: 13px;
        }
        .form-group label .required {
            color: #e74c3c;
            margin-left: 2px;
        }
        .form-control {
            width: 100%;
            padding: 9px 12px;
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
            box-shadow: 0 0 0 3px rgba(87, 156, 63, 0.1);
        }
        .form-control[readonly] {
            background: #f5f5f5;
            color: #666;
            cursor: not-allowed;
        }
        textarea.form-control {
            resize: vertical;
            min-height: 60px;
        }
        .form-help {
            font-size: 12px;
            color: #888;
            margin-top: 4px;
        }
        .form-help .highlight {
            color: #579c3f;
            font-weight: 600;
        }
        .modal-footer {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 18px;
            border-top: 1px solid #eee;
            padding-top: 18px;
        }
        .btn-cancel {
            padding: 9px 18px;
            background: #f1f2f6;
            color: #333;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: 0.2s;
        }
        .btn-cancel:hover {
            background: #dfe4ea;
        }
        .btn-save {
            padding: 9px 22px;
            background: #579c3f;
            color: white;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: 0.2s;
        }
        .btn-save:hover {
            background: #467e32;
        }
        .btn-save-purple {
            background: #9b59b6;
        }
        .btn-save-purple:hover {
            background: #8e44ad;
        }
        .btn-save-green {
            background: #1abc9c;
        }
        .btn-save-green:hover {
            background: #16a085;
        }
        .btn-save-red {
            background: #e74c3c;
        }
        .btn-save-red:hover {
            background: #c0392b;
        }
        .btn-save-orange {
            background: #e67e22;
        }
        .btn-save-orange:hover {
            background: #d35400;
        }
        @media (max-width: 768px) {
            .header { padding: 0 20px; height: 60px; }
            .header-title h1 { font-size: 18px; }
            .header-title small { display: none; }
            .content-area { padding: 15px 16px; }
            .page-toolbar { flex-direction: column; align-items: stretch; }
            .page-toolbar-left { flex-wrap: wrap; }
            .page-toolbar h2 { font-size: 18px; }
            .search-box input { width: 120px; font-size: 12px; }
            .stats-row { grid-template-columns: repeat(2, 1fr); gap: 8px; }
            .stat-card .number { font-size: 20px; }
            .stat-card .label { font-size: 11px; }
            .form-row { flex-direction: column; }
            .modal-content { padding: 18px; width: 98%; }
            .modal-lg { width: 98%; }
            .action-btns { flex-direction: column; gap: 3px; }
            .btn-action { width: 100%; text-align: center; padding: 5px; }
            .toolbar-actions { flex-direction: column; }
            .toolbar-actions .btn { width: 100%; justify-content: center; }
            .tabs { flex-direction: column; }
            .tab-btn { border-radius: 8px; justify-content: center; }
            .tab-btn.active { border-bottom: none; background: rgba(124, 179, 66, 0.3); }
            th, td { padding: 8px 6px; font-size: 11px; }
            .table-card { padding: 10px; }
        }
        @media (max-width: 480px) {
            .stats-row { grid-template-columns: 1fr 1fr; }
            .stat-card { padding: 10px; }
            .stat-card .number { font-size: 16px; }
            .stat-card .label { font-size: 10px; }
            .search-box input { width: 80px; font-size: 11px; padding: 7px 10px; }
            .search-box button { padding: 7px 10px; font-size: 11px; }
            .btn { font-size: 12px; padding: 7px 12px; }
            .modal-header h3 { font-size: 16px; }
        }
    </style>
</head>
<body>

    <jsp:include page="/views/common/sidebar.jsp">
        <jsp:param name="activePage" value="equipmentManager" />
    </jsp:include>

    <div class="main-wrapper">
        <header class="header">
            <div class="header-title">
                <h1>🌾 Quản lý thiết bị <small>Smart Farmer v2.0</small></h1>
            </div>
            <div class="user-profile">
                <button class="notification" onclick="openModal('notificationModal')">
                    <svg viewBox="0 0 24 24"><path d="M12 22c1.1 0 2-.9 2-2h-4c0 1.1.9 2 2 2zm6-6v-5c0-3.07-1.63-5.64-4.5-6.32V4c0-.83-.67-1.5-1.5-1.5s-1.5.67-1.5 1.5v.68C7.64 5.36 6 7.92 6 11v5l-2 2v1h16v-1l-2-2zm-2 1H8v-6c0-2.48 1.51-4.5 4-4.5s4 2.02 4 4.5v6z"/></svg>
                    <span class="badge" id="notificationBadge">${notificationCount != null ? notificationCount : 0}</span>
                </button>
                <div class="avatar" title="Quản lý thiết bị">QL</div>
            </div>
        </header>

        <main class="content-area">
            <c:if test="${not empty sessionScope.success}">
                <div class="alert alert-success">
                    <span>✅</span>
                    <span>${sessionScope.success}</span>
                    <button class="close-alert" onclick="this.parentElement.remove()">&times;</button>
                </div>
                <c:remove var="success" scope="session"/>
            </c:if>
            <c:if test="${not empty sessionScope.error}">
                <div class="alert alert-error">
                    <span>❌</span>
                    <span>${sessionScope.error}</span>
                    <button class="close-alert" onclick="this.parentElement.remove()">&times;</button>
                </div>
                <c:remove var="error" scope="session"/>
            </c:if>

            <div class="stats-row">
                <div class="stat-card" onclick="switchTab('all')">
                    <div class="number" id="totalEquipment">${stats != null ? stats.total : 0}</div>
                    <div class="label">📦 Tổng thiết bị</div>
                </div>
                <div class="stat-card" onclick="switchTab('all')">
                    <div class="number" style="color: #81c784;" id="readyCount">${stats != null ? stats.ready : 0}</div>
                    <div class="label">✅ Sẵn sàng</div>
                </div>
                <div class="stat-card" onclick="switchTab('borrowing')">
                    <div class="number" style="color: #64b5f6;" id="inUseCount">${stats != null ? stats.inUse : 0}</div>
                    <div class="label">🔄 Đang sử dụng</div>
                </div>
                <div class="stat-card" onclick="switchTab('maintenance')">
                    <div class="number" style="color: #ffb74d;" id="maintenanceCount">${stats != null ? stats.maintenance : 0}</div>
                    <div class="label">🔧 Đang bảo trì</div>
                </div>
                <div class="stat-card" onclick="switchTab('all')">
                    <div class="number" style="color: #ef5350;" id="brokenCount">${stats != null ? stats.broken : 0}</div>
                    <div class="label">❌ Bị hỏng</div>
                </div>
            </div>

            <div class="page-toolbar">
                <div class="page-toolbar-left">
                    <h2>📋 Danh sách thiết bị</h2>
                    <div class="search-box">
                        <input type="text" id="searchInput" placeholder="🔍 Tìm kiếm..." onkeyup="searchEquipment()">
                        <button onclick="searchEquipment()">Tìm</button>
                    </div>
                </div>
                <div class="toolbar-actions">
                    <button class="btn btn-add" onclick="openModal('addEquipmentModal')">➕ Thêm thiết bị</button>
                    <button class="btn btn-outline" onclick="openModal('notificationModal')">🔔 Cấu hình TB</button>
                </div>
            </div>

            <div class="tabs-container">
                <div class="tabs">
                    <button class="tab-btn active" data-tab="all" onclick="switchTab('all')">
                        📋 Tất cả <span class="tab-count" id="tabAllCount">${stats != null ? stats.total : 0}</span>
                    </button>
                    <button class="tab-btn" data-tab="borrowing" onclick="switchTab('borrowing')">
                        📤 Đang mượn <span class="tab-count" id="tabBorrowingCount">${borrowingCount != null ? borrowingCount : 0}</span>
                    </button>
                    <button class="tab-btn" data-tab="maintenance" onclick="switchTab('maintenance')">
                        🔧 Bảo trì <span class="tab-count" id="tabMaintenanceCount">${maintenanceCount != null ? maintenanceCount : 0}</span>
                    </button>
                </div>
            </div>

            <!-- TAB 1: TẤT CẢ -->
            <div class="tab-content active" id="tab-all">
                <div class="table-card">
                    <table>
                        <thead>
                            <tr>
                                <th>Mã ĐD</th>
                                <th>Tên thiết bị</th>
                                <th>Loại</th>
                                <th>Trạng thái</th>
                                <th>Ngày mua</th>
                                <th style="min-width: 260px;">Hành động</th>
                            </tr>
                        </thead>
                        <tbody id="equipmentTableBody">
                            <c:choose>
                                <c:when test="${empty equipmentList}">
                                    <tr><td colspan="6" class="empty-message">📭 Không có thiết bị nào</td></tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach items="${equipmentList}" var="item">
                                        <tr data-status="${item.currentStatus}">
                                            <td><strong>${item.identifierCode}</strong></td>
                                            <td>${item.name}</td>
                                            <td><span class="type-badge">${item.type}</span></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${item.currentStatus == 'Sẵn sàng'}">
                                                        <span class="status-badge status-ready">✅ Sẵn sàng</span>
                                                    </c:when>
                                                    <c:when test="${item.currentStatus == 'Đang sử dụng'}">
                                                        <span class="status-badge status-inuse">🔄 Đang sử dụng</span>
                                                    </c:when>
                                                    <c:when test="${item.currentStatus == 'Bảo trì'}">
                                                        <span class="status-badge status-maintenance">🔧 Bảo trì</span>
                                                    </c:when>
                                                    <c:when test="${item.currentStatus == 'Hỏng'}">
                                                        <span class="status-badge status-broken">❌ Hỏng</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-badge">${item.currentStatus}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td><fmt:formatDate value="${item.purchaseDate}" pattern="dd/MM/yyyy"/></td>
                                            <td>
                                                <div class="action-btns">
                                                    <button class="btn-action btn-status" onclick="openModal('statusModal', ${item.id})">📌 Trạng thái</button>
                                                    <c:choose>
                                                        <c:when test="${item.currentStatus == 'Sẵn sàng'}">
                                                            <button class="btn-action btn-borrow" onclick="openModal('borrowModal', ${item.id})">📤 Mượn</button>
                                                        </c:when>
                                                        <c:when test="${item.currentStatus == 'Đang sử dụng'}">
                                                            <button class="btn-action btn-return" onclick="openModal('returnModal', ${item.id})">📥 Trả</button>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <button class="btn-action btn-borrow btn-disabled" disabled>⛔ Không mượn</button>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <button class="btn-action btn-maintenance" onclick="openModal('maintenanceModal', ${item.id})">🔧 Bảo trì</button>
                                                    <button class="btn-action btn-history" onclick="openModal('historyModal', ${item.id})">📜 Lịch sử</button>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- TAB 2: ĐANG MƯỢN -->
            <div class="tab-content" id="tab-borrowing">
                <div class="table-card">
                    <table>
                        <thead>
                            <tr>
                                <th>Mã ĐD</th>
                                <th>Tên thiết bị</th>
                                <th>Người mượn</th>
                                <th>Khu vực</th>
                                <th>Thời gian mượn</th>
                                <th>Trạng thái</th>
                                <th>Hành động</th>
                            </tr>
                        </thead>
                        <tbody id="borrowingTableBody">
                            <c:choose>
                                <c:when test="${empty borrowingList}">
                                    <tr><td colspan="7" class="empty-message">📭 Không có thiết bị nào đang mượn</td></tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach items="${borrowingList}" var="item">
                                        <tr>
                                            <td><strong>${item.equipmentCode}</strong></td>
                                            <td>${item.equipmentName}</td>
                                            <td>${item.userName}</td>
                                            <td>${item.farmAreaName != null ? item.farmAreaName : 'N/A'}</td>
                                            <td><fmt:formatDate value="${item.borrowDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                                            <td>
                                                <span class="status-badge status-inuse">
                                                    ${item.status == 'Quá hạn' ? '⚠️ Quá hạn' : '🔄 Đang mượn'}
                                                </span>
                                            </td>
                                            <td>
                                                <div class="action-btns">
                                                    <button class="btn-action btn-return" onclick="openModal('returnModal', ${item.equipmentId})">📥 Trả</button>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- TAB 3: BẢO TRÌ -->
            <div class="tab-content" id="tab-maintenance">
                <div class="table-card">
                    <table>
                        <thead>
                            <tr>
                                <th>Mã ĐD</th>
                                <th>Tên thiết bị</th>
                                <th>Ngày dự kiến</th>
                                <th>Hạng mục</th>
                                <th>Chi phí</th>
                                <th>Trạng thái</th>
                                <th>Hành động</th>
                            </tr>
                        </thead>
                        <tbody id="maintenanceTableBody">
                            <c:choose>
                                <c:when test="${empty maintenanceList}">
                                    <tr><td colspan="7" class="empty-message">🔧 Không có lịch bảo trì</td></tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach items="${maintenanceList}" var="item">
                                        <tr>
                                            <td><strong>${item.equipmentCode}</strong></td>
                                            <td>${item.equipmentName}</td>
                                            <td><fmt:formatDate value="${item.scheduledDate}" pattern="dd/MM/yyyy"/></td>
                                            <td>${item.itemsToCheck}</td>
                                            <td><fmt:formatNumber value="${item.estimatedCost}" type="currency" currencySymbol="₫"/></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${item.status == 'Đang chờ'}">
                                                        <span class="status-badge status-pending">🟡 Chờ</span>
                                                    </c:when>
                                                    <c:when test="${item.status == 'Hoàn thành'}">
                                                        <span class="status-badge status-completed">✅ Hoàn thành</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-badge">${item.status}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <div class="action-btns">
                                                    <c:if test="${item.status == 'Đang chờ'}">
                                                        <button class="btn-action btn-result" onclick="openModal('maintenanceResultModal', ${item.id})">📋 Hoàn thành</button>
                                                    </c:if>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>

    <!-- ===== MODALS ===== -->

    <!-- UC-5.1: THÊM THIẾT BỊ -->
    <div class="modal-overlay" id="addEquipmentModal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>➕ Thêm thiết bị <span class="sub-title">UC-5.1</span></h3>
                <button class="modal-close" onclick="closeModal('addEquipmentModal')">&times;</button>
            </div>
            <form action="${pageContext.request.contextPath}/equipment" method="POST" enctype="multipart/form-data">
                <input type="hidden" name="action" value="add">
                <div class="form-group">
                    <label>Tên thiết bị <span class="required">*</span></label>
                    <input type="text" name="name" class="form-control" required>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Loại <span class="required">*</span></label>
                        <select name="type" class="form-control" required>
                            <option value="Máy móc lớn">🚜 Máy móc lớn</option>
                            <option value="Máy di động">📦 Máy di động</option>
                            <option value="Dụng cụ cầm tay">🔧 Dụng cụ cầm tay</option>
                            <option value="Hệ thống cố định">🏗️ Hệ thống cố định</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Mã định danh <span class="required">*</span></label>
                        <input type="text" name="identifierCode" class="form-control" placeholder="EQ-001" required>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Ngày mua <span class="required">*</span></label>
                        <input type="date" name="purchaseDate" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label>Tình trạng ban đầu</label>
                        <select name="initialStatus" class="form-control">
                            <option value="Mới">Mới</option>
                            <option value="Đã qua sử dụng">Đã qua sử dụng</option>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label>Hình ảnh</label>
                    <input type="file" name="image" class="form-control" accept="image/*">
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn-cancel" onclick="closeModal('addEquipmentModal')">Hủy</button>
                    <button type="submit" class="btn-save">💾 Lưu</button>
                </div>
            </form>
        </div>
    </div>

    <!-- UC-5.2: CẬP NHẬT TRẠNG THÁI -->
    <div class="modal-overlay" id="statusModal">
        <div class="modal-content modal-sm">
            <div class="modal-header">
                <h3>📌 Cập nhật trạng thái <span class="sub-title">UC-5.2</span></h3>
                <button class="modal-close" onclick="closeModal('statusModal')">&times;</button>
            </div>
            <form action="${pageContext.request.contextPath}/equipment" method="POST">
                <input type="hidden" name="action" value="update-status">
                <input type="hidden" name="id" id="statusEquipmentId">
                <div class="form-group">
                    <label>Thiết bị</label>
                    <input type="text" id="statusEquipmentName" class="form-control" readonly>
                </div>
                <div class="form-group">
                    <label>Trạng thái mới <span class="required">*</span></label>
                    <select name="status" class="form-control" required>
                        <option value="Sẵn sàng">✅ Sẵn sàng</option>
                        <option value="Đang sử dụng">🔄 Đang sử dụng</option>
                        <option value="Bảo trì">🔧 Bảo trì</option>
                        <option value="Hỏng">❌ Hỏng</option>
                    </select>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn-cancel" onclick="closeModal('statusModal')">Hủy</button>
                    <button type="submit" class="btn-save">🔄 Cập nhật</button>
                </div>
            </form>
        </div>
    </div>

    <!-- UC-5.3: MƯỢN THIẾT BỊ -->
    <div class="modal-overlay" id="borrowModal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>📤 Mượn thiết bị <span class="sub-title">UC-5.3</span></h3>
                <button class="modal-close" onclick="closeModal('borrowModal')">&times;</button>
            </div>
            <form action="${pageContext.request.contextPath}/equipment" method="POST">
                <input type="hidden" name="action" value="borrow">
                <input type="hidden" name="equipmentId" id="borrowEquipmentId">
                <div class="form-group">
                    <label>Thiết bị</label>
                    <input type="text" id="borrowEquipmentName" class="form-control" readonly>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>ID Người mượn <span class="required">*</span></label>
                        <input type="number" name="userId" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label>ID Khu vực</label>
                        <input type="number" name="farmAreaId" class="form-control">
                    </div>
                </div>
                <div class="form-group">
                    <label>Tình trạng trước khi mượn</label>
                    <textarea name="conditionBefore" class="form-control" placeholder="Mô tả tình trạng..."></textarea>
                </div>
                <div class="form-group">
                    <label>Ghi chú</label>
                    <textarea name="note" class="form-control" placeholder="Ghi chú..."></textarea>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn-cancel" onclick="closeModal('borrowModal')">Hủy</button>
                    <button type="submit" class="btn-save btn-save-purple">📤 Xác nhận mượn</button>
                </div>
            </form>
        </div>
    </div>

    <!-- UC-5.3: TRẢ THIẾT BỊ -->
    <div class="modal-overlay" id="returnModal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>📥 Trả thiết bị <span class="sub-title">UC-5.3</span></h3>
                <button class="modal-close" onclick="closeModal('returnModal')">&times;</button>
            </div>
            <form action="${pageContext.request.contextPath}/equipment" method="POST">
                <input type="hidden" name="action" value="return">
                <input type="hidden" name="borrowId" id="returnBorrowId">
                <div class="form-group">
                    <label>ID Phiếu mượn <span class="required">*</span></label>
                    <input type="number" name="borrowIdInput" class="form-control" required
                           onchange="document.getElementById('returnBorrowId').value = this.value">
                </div>
                <div class="form-group">
                    <label>Thiết bị</label>
                    <input type="text" id="returnEquipmentName" class="form-control" readonly>
                </div>
                <div class="form-group">
                    <label>Tình trạng sau khi sử dụng <span class="required">*</span></label>
                    <select name="conditionAfter" class="form-control" required>
                        <option value="Tốt">✅ Tốt</option>
                        <option value="Cần bảo trì nhẹ">⚠️ Cần bảo trì</option>
                        <option value="Hỏng">❌ Hỏng</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Ghi chú</label>
                    <textarea name="note" class="form-control" placeholder="Ghi chú khi trả..."></textarea>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn-cancel" onclick="closeModal('returnModal')">Hủy</button>
                    <button type="submit" class="btn-save btn-save-green">📥 Xác nhận trả</button>
                </div>
            </form>
        </div>
    </div>

    <!-- UC-6.1: LẬP LỊCH BẢO TRÌ -->
    <div class="modal-overlay" id="maintenanceModal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>🔧 Lập lịch bảo trì <span class="sub-title">UC-6.1</span></h3>
                <button class="modal-close" onclick="closeModal('maintenanceModal')">&times;</button>
            </div>
            <form action="${pageContext.request.contextPath}/equipment" method="POST">
                <input type="hidden" name="action" value="schedule-maintenance">
                <input type="hidden" name="equipmentId" id="maintenanceEquipmentId">
                <div class="form-group">
                    <label>Thiết bị</label>
                    <input type="text" id="maintenanceEquipmentName" class="form-control" readonly>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Ngày dự kiến <span class="required">*</span></label>
                        <input type="date" name="scheduledDate" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label>Chu kỳ</label>
                        <select name="cycleType" class="form-control">
                            <option value="DAILY">Hàng ngày</option>
                            <option value="WEEKLY" selected>Hàng tuần</option>
                            <option value="MONTHLY">Hàng tháng</option>
                            <option value="YEARLY">Hàng năm</option>
                        </select>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Giá trị chu kỳ</label>
                        <input type="number" name="cycleValue" class="form-control" value="1" min="1">
                    </div>
                    <div class="form-group">
                        <label>Chi phí dự kiến</label>
                        <input type="number" name="estimatedCost" class="form-control" value="0">
                    </div>
                </div>
                <div class="form-group">
                    <label>Hạng mục <span class="required">*</span></label>
                    <input type="text" name="itemsToCheck" class="form-control" required>
                </div>
                <div class="form-group">
                    <label>Người phụ trách</label>
                    <input type="text" name="responsiblePerson" class="form-control">
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn-cancel" onclick="closeModal('maintenanceModal')">Hủy</button>
                    <button type="submit" class="btn-save btn-save-red">📅 Lưu lịch</button>
                </div>
            </form>
        </div>
    </div>

    <!-- UC-6.2: KẾT QUẢ BẢO TRÌ -->
    <div class="modal-overlay" id="maintenanceResultModal">
        <div class="modal-content modal-lg">
            <div class="modal-header">
                <h3>📋 Kết quả bảo trì <span class="sub-title">UC-6.2</span></h3>
                <button class="modal-close" onclick="closeModal('maintenanceResultModal')">&times;</button>
            </div>
            <form action="${pageContext.request.contextPath}/equipment" method="POST">
                <input type="hidden" name="action" value="complete-maintenance">
                <input type="hidden" name="scheduleId" id="resultScheduleId">
                <div class="form-group">
                    <label>ID Lịch bảo trì <span class="required">*</span></label>
                    <input type="number" name="scheduleIdInput" class="form-control" required
                           onchange="document.getElementById('resultScheduleId').value = this.value">
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Ngày hoàn thành <span class="required">*</span></label>
                        <input type="date" name="actualDate" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label>Chi phí thực tế</label>
                        <input type="number" name="actualCost" class="form-control" value="0">
                    </div>
                </div>
                <div class="form-group">
                    <label>Chi tiết sửa chữa <span class="required">*</span></label>
                    <textarea name="repairDetails" class="form-control" rows="3" required></textarea>
                </div>
                <div class="form-group">
                    <label>Linh kiện thay thế</label>
                    <input type="text" name="replacedParts" class="form-control">
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn-cancel" onclick="closeModal('maintenanceResultModal')">Hủy</button>
                    <button type="submit" class="btn-save btn-save-green">✅ Lưu kết quả</button>
                </div>
            </form>
        </div>
    </div>

    <!-- LỊCH SỬ SỬ DỤNG -->
    <div class="modal-overlay" id="historyModal">
        <div class="modal-content modal-lg">
            <div class="modal-header">
                <h3>📜 Lịch sử sử dụng</h3>
                <button class="modal-close" onclick="closeModal('historyModal')">&times;</button>
            </div>
            <div>
                <div class="form-group">
                    <label>Thiết bị</label>
                    <input type="text" id="historyEquipmentName" class="form-control" readonly>
                </div>
                <div style="max-height: 350px; overflow-y: auto;">
                    <table style="width: 100%;">
                        <thead>
                            <tr style="background: #f8f9fa;">
                                <th>Người mượn</th>
                                <th>Ngày mượn</th>
                                <th>Ngày trả</th>
                                <th>Tình trạng</th>
                            </tr>
                        </thead>
                        <tbody id="historyTableBody">
                            <c:choose>
                                <c:when test="${empty historyList}">
                                    <tr><td colspan="4" class="empty-message">📭 Chưa có lịch sử</td></tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach items="${historyList}" var="item">
                                        <tr>
                                            <td>${item.userName}</td>
                                            <td><fmt:formatDate value="${item.borrowDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${item.returnDate != null}">
                                                        <fmt:formatDate value="${item.returnDate}" pattern="dd/MM/yyyy HH:mm"/>
                                                    </c:when>
                                                    <c:otherwise>Đang mượn</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${item.conditionAfter == 'Tốt'}">
                                                        <span class="status-badge status-ready">✅ Tốt</span>
                                                    </c:when>
                                                    <c:when test="${item.conditionAfter == 'Cần bảo trì nhẹ'}">
                                                        <span class="status-badge status-maintenance">⚠️ Cần BT</span>
                                                    </c:when>
                                                    <c:when test="${item.conditionAfter == 'Hỏng'}">
                                                        <span class="status-badge status-broken">❌ Hỏng</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-badge">${item.conditionAfter}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn-cancel" onclick="closeModal('historyModal')">Đóng</button>
            </div>
        </div>
    </div>

    <!-- UC-6.3: CẤU HÌNH THÔNG BÁO -->
    <div class="modal-overlay" id="notificationModal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>🔔 Cấu hình thông báo <span class="sub-title">UC-6.3</span></h3>
                <button class="modal-close" onclick="closeModal('notificationModal')">&times;</button>
            </div>
            <form action="${pageContext.request.contextPath}/equipment" method="POST">
                <input type="hidden" name="action" value="config-notification">
                <div class="form-group">
                    <label>ID Thiết bị</label>
                    <input type="number" name="equipmentId" class="form-control" placeholder="Để trống nếu áp dụng chung">
                </div>
                <div class="form-group">
                    <label>Phương thức <span class="required">*</span></label>
                    <select name="notificationMethod" class="form-control" required>
                        <option value="EMAIL">📧 Email</option>
                        <option value="SMS">📱 SMS</option>
                        <option value="BOTH">📧+📱 Cả hai</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Nhắc trước (ngày) <span class="required">*</span></label>
                    <input type="number" name="reminderDaysBefore" class="form-control" value="3" min="1" required>
                </div>
                <div class="form-group">
                    <label>Email</label>
                    <input type="email" name="recipientEmail" class="form-control" placeholder="admin@farm.com">
                </div>
                <div class="form-group">
                    <label>Số điện thoại</label>
                    <input type="tel" name="recipientPhone" class="form-control" placeholder="090xxxxxxx">
                </div>
                <div class="form-group">
                    <label>
                        <input type="checkbox" name="isActive" checked> Kích hoạt thông báo
                    </label>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn-cancel" onclick="closeModal('notificationModal')">Hủy</button>
                    <button type="submit" class="btn-save btn-save-orange">💾 Lưu</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function switchTab(tabName) {
            document.querySelectorAll('.tab-content').forEach(c => c.classList.remove('active'));
            document.getElementById('tab-' + tabName).classList.add('active');
            document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
            document.querySelector('.tab-btn[data-tab="' + tabName + '"]').classList.add('active');
        }

        function openModal(modalId, id) {
            var modal = document.getElementById(modalId);
            if (!modal) return;
            modal.classList.add('show');

            if (id) {
                var hiddenInputs = modal.querySelectorAll('input[name="equipmentId"], input[name="id"], input[name="scheduleId"]');
                hiddenInputs.forEach(function(input) {
                    input.value = id;
                });
                var rows = document.querySelectorAll('#equipmentTableBody tr');
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i];
                    var firstCell = row.querySelector('td:first-child');
                    if (firstCell) {
                        var code = firstCell.textContent.trim();
                        var nameCell = row.querySelector('td:nth-child(2)');
                        if (nameCell && (code == id || firstCell.textContent.trim() == id)) {
                            var name = nameCell.textContent.trim();
                            var nameFields = modal.querySelectorAll(
                                '#statusEquipmentName, #borrowEquipmentName, #returnEquipmentName, ' +
                                '#maintenanceEquipmentName, #historyEquipmentName'
                            );
                            nameFields.forEach(function(field) {
                                if (field) field.value = name;
                            });
                            break;
                        }
                    }
                }
            }
        }

        function closeModal(modalId) {
            var modal = document.getElementById(modalId);
            if (modal) {
                modal.classList.remove('show');
                var form = modal.querySelector('form');
                if (form) form.reset();
            }
        }

        window.onclick = function(event) {
            document.querySelectorAll('.modal-overlay').forEach(function(modal) {
                if (event.target === modal) {
                    modal.classList.remove('show');
                    var form = modal.querySelector('form');
                    if (form) form.reset();
                }
            });
        }

        function searchEquipment() {
            var filter = document.getElementById('searchInput').value.toLowerCase();
            var rows = document.querySelectorAll('#equipmentTableBody tr');
            rows.forEach(function(row) {
                if (row.classList.contains('empty-message')) return;
                var text = row.textContent.toLowerCase();
                row.style.display = text.includes(filter) ? '' : 'none';
            });
        }

        document.addEventListener('DOMContentLoaded', function() {
            var alerts = document.querySelectorAll('.alert');
            alerts.forEach(function(alert) {
                setTimeout(function() {
                    alert.style.transition = 'opacity 0.5s';
                    alert.style.opacity = '0';
                    setTimeout(function() { alert.remove(); }, 500);
                }, 5000);
            });
        });

        console.log('✅ Smart Farmer - Quản lý thiết bị đã sẵn sàng!');
    </script>

</body>
</html>