<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<style>
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

    /* === THÔNG BÁO === */
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
    .notification:hover { background: rgba(87, 156, 63, 0.2); }
    .notification svg { width: 22px; height: 22px; fill: #2e541f; }
    
    .badge {
        position: absolute; top: -2px; right: -2px;
        background-color: #e74c3c; color: white; font-size: 11px;
        font-weight: 800; padding: 3px 6px; border-radius: 12px;
        min-width: 10px; min-height: 12px; display: flex;
        justify-content: center; align-items: center; border: 2px solid #fff;
    }

    /* BẢNG DROPDOWN THÔNG BÁO */
    .notif-dropdown {
        position: absolute; top: 60px; right: -10px; width: 340px;
        background: #fff; border-radius: 12px; box-shadow: 0 10px 30px rgba(0,0,0,0.15);
        border: 1px solid #eee; display: none; flex-direction: column;
        z-index: 100; cursor: default;
        /* Hiệu ứng trượt mượt mà */
        opacity: 0; transform: translateY(-10px); transition: all 0.3s ease;
    }
    .notif-dropdown.show { display: flex; opacity: 1; transform: translateY(0); }
    
    /* Mũi tên trỏ lên chuông */
    .notif-dropdown::before {
        content: ''; position: absolute; top: -8px; right: 22px;
        border-left: 8px solid transparent; border-right: 8px solid transparent;
        border-bottom: 8px solid #fff;
    }
    .notif-header { padding: 15px 20px; font-weight: 800; color: #1a2419; border-bottom: 1px solid #eee; font-size: 16px; }
    .notif-body { max-height: 350px; overflow-y: auto; }
    
    .notif-empty { padding: 40px 20px; text-align: center; color: #888; font-weight: 600; font-size: 14px; line-height: 1.5;}
    
    .notif-item { padding: 15px 20px; border-bottom: 1px solid #f5f5f5; display: flex; gap: 15px; align-items: flex-start; cursor: pointer; transition: 0.2s; }
    .notif-item:hover { background: #fcfcfc; }
    .notif-item:last-child { border-bottom: none; }
    .notif-icon { width: 35px; height: 35px; border-radius: 50%; background: #fff3cd; color: #f39c12; display: flex; justify-content: center; align-items: center; font-size: 16px; flex-shrink: 0; }
    .notif-content { flex: 1; }
    .notif-text { font-size: 14px; color: #333; margin-bottom: 5px; line-height: 1.4; font-weight: 500; }
    .notif-time { font-size: 12px; color: #999; font-weight: 600;}

    /* === AVATAR === */
    .avatar {
        width: 45px; height: 45px; border-radius: 12px;
        display: flex; justify-content: center; align-items: center;
        font-weight: 800; font-size: 17px; color: #ffffff;
        cursor: pointer; box-shadow: 0 4px 10px rgba(0,0,0, 0.15);
        text-transform: uppercase; user-select: none;
    }
</style>

<header class="header">
    <div class="header-title">
        <%-- Lấy chữ tiêu đề được truyền vào từ các trang (Sẽ hướng dẫn ở Bước 2) --%>
        <h1>${empty param.pageTitle ? 'Trang Chủ Hệ Thống' : param.pageTitle}</h1>
    </div>
    <div class="user-profile">
        
        <!-- NÚT CHUÔNG VÀ BẢNG THÔNG BÁO -->
        <div class="notification" onclick="toggleNotif(event)">
            <svg viewBox="0 0 24 24"><path d="M12 22c1.1 0 2-.9 2-2h-4c0 1.1.9 2 2 2zm6-6v-5c0-3.07-1.63-5.64-4.5-6.32V4c0-.83-.67-1.5-1.5-1.5s-1.5.67-1.5 1.5v.68C7.64 5.36 6 7.92 6 11v5l-2 2v1h16v-1l-2-2zm-2 1H8v-6c0-2.48 1.51-4.5 4-4.5s4 2.02 4 4.5v6z"/></svg>
            
            <%-- GIẢ LẬP BIẾN ĐẾM THÔNG BÁO (BẠN SẼ THAY BẰNG BIẾN THẬT SAU) --%>
            <c:set var="notifCount" value="2" /> 
            
            <c:if test="${notifCount > 0}">
                <span class="badge">${notifCount}</span>
            </c:if>

            <div class="notif-dropdown" id="notifDropdown" onclick="event.stopPropagation()">
                <div class="notif-header">Thông báo của bạn</div>
                <div class="notif-body">
                    <c:choose>
                        <c:when test="${notifCount == 0}">
                            <!-- TRƯỜNG HỢP: KHÔNG CÓ THÔNG BÁO -->
                            <div class="notif-empty">
                                <svg style="width:50px; height:50px; fill:#dcdde1; margin-bottom:10px" viewBox="0 0 24 24"><path d="M12 22c1.1 0 2-.9 2-2h-4c0 1.1.9 2 2 2zm6-6v-5c0-3.07-1.63-5.64-4.5-6.32V4c0-.83-.67-1.5-1.5-1.5s-1.5.67-1.5 1.5v.68C7.64 5.36 6 7.92 6 11v5l-2 2v1h16v-1l-2-2zm-2 1H8v-6c0-2.48 1.51-4.5 4-4.5s4 2.02 4 4.5v6z"/></svg>
                                <br>Bạn không có thông báo nào mới.
                            </div>
                        </c:when>
                        <c:otherwise>
                            <!-- TRƯỜNG HỢP: CÓ THÔNG BÁO (Chuẩn bị div sẵn để sau đổ vòng lặp Java vào) -->
                            <div class="notif-item">
                                <div class="notif-icon">⚠️</div>
                                <div class="notif-content">
                                    <div class="notif-text">Vật tư: "Cám heo tăng trọng" sắp hết (Còn dưới 15kg).</div>
                                    <div class="notif-time">10 phút trước</div>
                                </div>
                            </div>
                            <div class="notif-item">
                                <div class="notif-icon" style="background:#d4edda; color:#27ae60">✅</div>
                                <div class="notif-content">
                                    <div class="notif-text">Công nhân Nguyễn Văn Hùng đã hoàn thành nhiệm vụ "Bón phân Lô A1".</div>
                                    <div class="notif-time">1 giờ trước</div>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <!-- KHU VỰC AVATAR (Lấy Tên từ Session gán vào data-name) -->
        <a href="${pageContext.request.contextPath}/personal" ><div class="avatar" id="userAvatar" data-name="${not empty sessionScope.TenDangNhap ? sessionScope.TenDangNhap : 'Hà Quang Linh'}">
            <!-- JavaScript bên dưới sẽ tự bắt chữ cái và vẽ màu vào đây -->
        </div></a>
    </div>
</header>

<script>
    // 1. TỰ ĐỘNG TẠO AVATAR (Chữ cái đầu/cuối + Random màu theo tên)
    document.addEventListener("DOMContentLoaded", function() {
        let avatarDiv = document.getElementById("userAvatar");
        let fullName = avatarDiv.getAttribute("data-name").trim();
        
        // Cắt chuỗi để lấy chữ cái
        let words = fullName.split(/\s+/);
        let initials = "";
        
        if (words.length >= 2) {
            // Lấy chữ đầu của từ đầu tiên và từ cuối cùng (VD: Hà Quang Linh -> HL)
            initials = words[0].charAt(0) + words[words.length - 1].charAt(0);
        } else if (words.length === 1 && words[0] !== "") {
            initials = words[0].charAt(0);
        } else {
            initials = "U";
        }
        avatarDiv.innerText = initials.toUpperCase();

        // Thuật toán băm chuỗi (Hash) để ra đúng 1 màu cố định cho mỗi tên
        let hash = 0;
        for (let i = 0; i < fullName.length; i++) {
            hash = fullName.charCodeAt(i) + ((hash << 5) - hash);
        }
        
        // Đổi mã Hash sang mã màu Hex
        let color = '#';
        for (let i = 0; i < 3; i++) {
            let value = (hash >> (i * 8)) & 0xFF;
            // Giới hạn độ sáng để đảm bảo chữ màu trắng (fff) luôn nổi bật trên nền
            value = Math.max(value, 30); 
            value = Math.min(value, 180);
            color += ('00' + value.toString(16)).substr(-2);
        }
        
        avatarDiv.style.background = color;
        // Đổ cái bóng bên dưới avatar giống hệt với màu nền cho đồng bộ
        avatarDiv.style.boxShadow = `0 4px 10px ${color}80`; 
    });

    // 2. LOGIC ĐÓNG/MỞ BẢNG THÔNG BÁO
    function toggleNotif(event) {
        event.stopPropagation(); // Ngăn lệnh click chọc thủng ra ngoài body
        let dropdown = document.getElementById("notifDropdown");
        dropdown.classList.toggle("show");
    }

    // Bấm ra ngoài màn hình thì tự động đóng bảng thông báo
    window.addEventListener('click', function(e) {
        let dropdown = document.getElementById("notifDropdown");
        if (dropdown.classList.contains('show')) {
            dropdown.classList.remove('show');
        }
    });
</script>