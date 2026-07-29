package models;

import java.sql.Timestamp;

public class ChatHistory {
    private int id;
    private int maNguoiDung;
    private String sessionId; // Thêm trường này
    private String senderRole;
    private String messageContent;
    private Timestamp createdAt;

    public ChatHistory() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getMaNguoiDung() { return maNguoiDung; }
    public void setMaNguoiDung(int maNguoiDung) { this.maNguoiDung = maNguoiDung; }

    public String getSessionId() { return sessionId; }
    public void setSessionId(String sessionId) { this.sessionId = sessionId; }

    public String getSenderRole() { return senderRole; }
    public void setSenderRole(String senderRole) { this.senderRole = senderRole; }

    public String getMessageContent() { return messageContent; }
    public void setMessageContent(String messageContent) { this.messageContent = messageContent; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}