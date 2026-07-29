<%@page contentType="text/html" pageEncoding="UTF-8"%>
<style>
    /* ================= CSS GIAO DIỆN CHATBOT ================= */
    .ai-floating-btn {
        position: absolute; bottom: 0; right: 0; width: 60px; height: 60px;
        background: linear-gradient(135deg, #1e4512, #579c3f);
        border-radius: 50%; display: flex; justify-content: center; align-items: center;
        box-shadow: 0 4px 15px rgba(30, 69, 18, 0.4);
        cursor: grab; touch-action: none; transition: transform 0.3s ease; border: none; user-select: none; z-index: 20;
    }
    .ai-floating-btn:active { cursor: grabbing; }
    .ai-floating-btn:hover { transform: scale(1.1); }
    .ai-floating-btn svg { width: 35px; height: 35px; fill: white; }

    .ai-chatbox-container {
        position: absolute; width: 350px; height: 450px; background: #fff;
        border-radius: 15px; box-shadow: 0 5px 25px rgba(0,0,0,0.2);
        display: flex; flex-direction: column; overflow: hidden;
        transform: scale(0.95); opacity: 0; pointer-events: none;
        transition: opacity 0.3s ease, transform 0.3s ease; z-index: 10;
    }
    .ai-chatbox-container.show { transform: scale(1); opacity: 1; pointer-events: auto; }

    .ai-chat-header {
        background: linear-gradient(135deg, #1e4512, #579c3f); color: white;
        padding: 15px 20px; font-weight: bold; font-size: 16px;
        display: flex; justify-content: space-between; align-items: center; cursor: grab; z-index: 2; position: relative;
    }
    .ai-chat-header:active { cursor: grabbing; }

    .ai-header-actions { display: flex; gap: 12px; align-items: center; }
    .ai-action-btn {
        cursor: pointer; background: none; border: none; color: white;
        font-size: 18px; display: flex; align-items: center; justify-content: center;
        padding: 0; transition: transform 0.2s;
    }
    .ai-action-btn:hover { transform: scale(1.2); }

    .ai-chat-body {
        flex: 1; padding: 15px; overflow-y: auto; background: #f8f9fa;
        display: flex; flex-direction: column; gap: 10px; position: relative; scroll-behavior: smooth;
    }
    
    .ai-message { max-width: 80%; padding: 10px 15px; border-radius: 15px; font-size: 14px; line-height: 1.4; word-wrap: break-word;}
    .ai-message.bot { background: #e9ecef; color: #333; align-self: flex-start; border-bottom-left-radius: 5px; }
    .ai-message.user { background: #579c3f; color: white; align-self: flex-end; border-bottom-right-radius: 5px; }

    .ai-chat-input-area {
        padding: 15px; background: white; border-top: 1px solid #ddd;
        display: flex; gap: 10px; z-index: 2; position: relative;
    }
    .ai-chat-input-area input { flex: 1; padding: 10px 15px; border: 1px solid #ccc; border-radius: 20px; outline: none; }
    .ai-chat-input-area input:focus { border-color: #579c3f; }
    .ai-chat-input-area button {
        background: #579c3f; color: white; border: none; border-radius: 50%;
        width: 40px; height: 40px; cursor: pointer; display: flex; justify-content: center; align-items: center;
    }

    /* Bảng Lịch Sử Panel (Trượt ngang) */
    .ai-history-panel {
        position: absolute; top: 54px; left: 0; width: 100%; height: calc(100% - 54px);
        background: #fff; z-index: 5; display: flex; flex-direction: column;
        transform: translateX(100%); transition: transform 0.3s ease; overflow-y: auto;
    }
    .ai-history-panel.show { transform: translateX(0); }
    .session-item { padding: 15px 20px; border-bottom: 1px solid #eee; cursor: pointer; font-weight: bold; color: #333; transition: background 0.2s;}
    .session-item:hover { background: #f0f0f0; color: #579c3f; }
</style>

<!-- ================= HTML ================= -->
<div id="aiWidgetWrapper" style="position: fixed; bottom: 30px; right: 30px; z-index: 9999; width: 60px; height: 60px;">

    <!-- Cửa sổ Chat -->
    <div class="ai-chatbox-container" id="aiChatbox">
        <div class="ai-chat-header">
            <div>🤖 Trợ lý Smart Farm</div>
            <div class="ai-header-actions">
                <button class="ai-action-btn" id="aiNewChatBtn" title="Tạo cuộc trò chuyện mới">➕</button>
                <button class="ai-action-btn" id="aiHistoryBtn" title="Xem danh sách lịch sử">🕒</button>
                <button class="ai-action-btn" id="aiCloseBtn" title="Đóng">×</button>
            </div>
        </div>
        
        <!-- Bảng danh sách lịch sử trượt ra -->
        <div class="ai-history-panel" id="aiHistoryPanel"></div>
        
        <div class="ai-chat-body" id="aiChatBody"></div>
        
        <div class="ai-chat-input-area">
            <input type="text" id="aiChatInput" placeholder="Nhập tin nhắn..." autocomplete="off"/>
            <button id="aiSendBtn">
                <svg style="width: 20px; height: 20px; fill: white;" viewBox="0 0 24 24"><path d="M2.01 21L23 12 2.01 3 2 10l15 2-15 2z"/></svg>
            </button>
        </div>
    </div>
    
    <!-- Nút Mở Chat ở góc màn hình -->
    <button class="ai-floating-btn" id="aiToggleBtn">
        <svg viewBox="0 0 24 24">
        <path d="M12 2C10.5 2 9 3.5 9 5.5C9 7.5 12 9 12 9C12 9 15 7.5 15 5.5C15 3.5 13.5 2 12 2Z" fill="#a8e6cf"/>
        <rect x="4" y="9" width="16" height="12" rx="3" fill="white"/>
        <circle cx="8.5" cy="14" r="1.5" fill="#1e4512"/>
        <circle cx="15.5" cy="14" r="1.5" fill="#1e4512"/>
        <path d="M9 18h6" stroke="#1e4512" stroke-width="2" stroke-linecap="round"/>
        <line x1="12" y1="9" x2="12" y2="7" stroke="white" stroke-width="2"/>
        </svg>
    </button>
</div>

<!-- ================= JAVASCRIPT ================= -->
<script>
    // 1. BIẾN TOÀN CỤC LƯU ID PHIÊN CHAT HIỆN TẠI
    let currentSessionId = 'SESSION_' + Date.now();

    // 2. HÀM TẢI NỘI DUNG CỦA 1 CUỘC TRÒ CHUYỆN (Gọi từ bảng lịch sử)
    function loadSpecificSession(sessionId) {
        currentSessionId = sessionId;
        document.getElementById('aiHistoryPanel').classList.remove('show');
        document.getElementById('aiChatBody').innerHTML = '<div style="text-align:center; padding:10px; color:#666;">Đang tải nội dung...</div>';
        
        fetch('${pageContext.request.contextPath}/api/chat?action=getChat&sessionId=' + encodeURIComponent(sessionId))
            .then(res => res.text())
            .then(html => {
                document.getElementById('aiChatBody').innerHTML = html;
                // Cuộn xuống cuối
                const chatBody = document.getElementById('aiChatBody');
                chatBody.scrollTop = chatBody.scrollHeight;
            })
            .catch(err => console.error("Lỗi tải chat:", err));
    }

    document.addEventListener("DOMContentLoaded", function () {
        const toggleBtn = document.getElementById('aiToggleBtn');
        const closeBtn = document.getElementById('aiCloseBtn');
        const historyBtn = document.getElementById('aiHistoryBtn');
        const newChatBtn = document.getElementById('aiNewChatBtn');
        
        const chatbox = document.getElementById('aiChatbox');
        const historyPanel = document.getElementById('aiHistoryPanel');
        const chatBody = document.getElementById('aiChatBody');
        const input = document.getElementById('aiChatInput');
        const sendBtn = document.getElementById('aiSendBtn');
        
        const widgetWrapper = document.getElementById('aiWidgetWrapper');
        const chatHeader = document.querySelector('.ai-chat-header');

        // SỰ KIỆN: TẠO ĐOẠN CHAT MỚI
        newChatBtn.addEventListener('click', () => {
            currentSessionId = 'SESSION_' + Date.now();
            historyPanel.classList.remove('show');
            chatBody.innerHTML = '<div class="ai-message bot">Chào Linh và các bạn nhóm 2! Mình là trợ lý AI. Mình có thể giúp gì cho nông trại hôm nay?</div>';
        });

        // SỰ KIỆN: XEM BẢNG LỊCH SỬ
        historyBtn.addEventListener('click', async () => {
            historyPanel.classList.toggle('show');
            if(historyPanel.classList.contains('show')) {
                historyPanel.innerHTML = '<div style="text-align:center; padding:15px; color:#666;">Đang tải danh sách lịch sử...</div>';
                try {
                    const res = await fetch('${pageContext.request.contextPath}/api/chat?action=getSessions');
                    if (res.ok) {
                        historyPanel.innerHTML = await res.text();
                    } else {
                        historyPanel.innerHTML = '<div style="text-align:center; padding:15px; color:red;">Lỗi tải dữ liệu.</div>';
                    }
                } catch(e) {
                    historyPanel.innerHTML = '<div style="text-align:center; padding:15px; color:red;">Mất kết nối mạng.</div>';
                }
            }
        });

        // HIỂN THỊ MẶC ĐỊNH LẦN ĐẦU VÀO TRANG MÀ CHƯA BẤM VÀO LỊCH SỬ NÀO
        chatBody.innerHTML = '<div class="ai-message bot">Chào Linh và các bạn nhóm 2! Mình là trợ lý AI. Mình có thể giúp gì cho nông trại hôm nay?</div>';

        // ==========================================
        // SỰ KIỆN GỬI TIN NHẮN 
        // ==========================================
        async function sendMessage() {
            const text = input.value.trim();
            if (!text) return;
            
            // In tin nhắn của người dùng lên UI
            chatBody.innerHTML += '<div class="ai-message user">' + text + '</div>';
            input.value = ''; 
            chatBody.scrollTop = chatBody.scrollHeight;
            
            // Hiện trạng thái "Đang suy nghĩ..."
            const loadingId = "loading-" + Date.now();
            chatBody.innerHTML += '<div class="ai-message bot" id="' + loadingId + '"><span style="opacity: 0.6;">Đang suy nghĩ...</span></div>';
            chatBody.scrollTop = chatBody.scrollHeight;

            try {
                // Đảm bảo encode chuẩn dữ liệu trước khi gửi POST
                const postData = 'message=' + encodeURIComponent(text) + '&sessionId=' + encodeURIComponent(currentSessionId);
                
                const response = await fetch('${pageContext.request.contextPath}/api/chat', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: postData
                });
                
                if (response.ok) {
                    document.getElementById(loadingId).innerHTML = await response.text();
                } else {
                    document.getElementById(loadingId).innerText = "Hệ thống AI đang bận, vui lòng thử lại!";
                }
            } catch (error) {
                document.getElementById(loadingId).innerText = "Mất kết nối đến máy chủ Smart Farm!";
                console.error(error);
            }
            chatBody.scrollTop = chatBody.scrollHeight;
        }

        // Bắt sự kiện click nút gửi và Enter
        sendBtn.addEventListener('click', sendMessage);
        input.addEventListener('keypress', (e) => { 
            if (e.key === 'Enter') sendMessage(); 
        });

        // ==========================================
        // KÉO THẢ VÀ ĐỊNH VỊ THÔNG MINH
        // ==========================================
        function adjustChatboxPosition() {
            const rect = widgetWrapper.getBoundingClientRect();
            const centerX = window.innerWidth / 2, centerY = window.innerHeight / 2;
            if (rect.left < centerX) { chatbox.style.left = '0px'; chatbox.style.right = 'auto'; } 
            else { chatbox.style.right = '0px'; chatbox.style.left = 'auto'; }
            if (rect.top < centerY) { chatbox.style.top = '75px'; chatbox.style.bottom = 'auto'; } 
            else { chatbox.style.bottom = '75px'; chatbox.style.top = 'auto'; }
        }
        adjustChatboxPosition(); // Gọi lần đầu để setup UI

        let isDragging = false, hasDragged = false, startX, startY, offsetX, offsetY;
        
        function dragStart(e) {
            // Ngăn chặn kéo nếu click trúng cụm nút điều khiển Header (➕, 🕒, ✖)
            if (e.target.closest('.ai-header-actions')) return;
            
            isDragging = true; hasDragged = false;
            const rect = widgetWrapper.getBoundingClientRect();
            const clientX = e.type.includes('mouse') ? e.clientX : e.touches[0].clientX;
            const clientY = e.type.includes('mouse') ? e.clientY : e.touches[0].clientY;
            
            startX = clientX; startY = clientY;
            offsetX = clientX - rect.left; offsetY = clientY - rect.top;
        }
        
        function drag(e) {
            if (!isDragging) return;
            const clientX = e.type.includes('mouse') ? e.clientX : e.touches[0].clientX;
            const clientY = e.type.includes('mouse') ? e.clientY : e.touches[0].clientY;
            
            // Chỉ tính là Drag khi di chuột quá 5px
            if (Math.abs(clientX - startX) > 5 || Math.abs(clientY - startY) > 5) hasDragged = true;
            
            if (hasDragged) {
                e.preventDefault();
                let newX = clientX - offsetX; let newY = clientY - offsetY;
                // Ràng buộc giới hạn màn hình
                const maxX = window.innerWidth - widgetWrapper.offsetWidth;
                const maxY = window.innerHeight - widgetWrapper.offsetHeight;
                
                widgetWrapper.style.left = Math.max(0, Math.min(newX, maxX)) + 'px';
                widgetWrapper.style.top = Math.max(0, Math.min(newY, maxY)) + 'px';
                widgetWrapper.style.bottom = 'auto'; widgetWrapper.style.right = 'auto';
                
                adjustChatboxPosition();
            }
        }
        
        function dragEnd() { isDragging = false; }

        chatHeader.addEventListener('mousedown', dragStart); 
        chatHeader.addEventListener('touchstart', dragStart, {passive: false});
        toggleBtn.addEventListener('mousedown', dragStart); 
        toggleBtn.addEventListener('touchstart', dragStart, {passive: false});
        document.addEventListener('mousemove', drag); 
        document.addEventListener('touchmove', drag, {passive: false});
        document.addEventListener('mouseup', dragEnd); 
        document.addEventListener('touchend', dragEnd);

        toggleBtn.addEventListener('click', (e) => {
            if (hasDragged) { e.preventDefault(); return; }
            chatbox.classList.toggle('show');
        });
        
        closeBtn.addEventListener('click', () => chatbox.classList.remove('show'));
    }); 
</script>