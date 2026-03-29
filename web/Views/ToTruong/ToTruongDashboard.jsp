<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.Map" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    List<Map<String, Object>> _dsTB = (List<Map<String, Object>>) request.getAttribute("danhSachThongBao");
    Integer _soChuaDoc = (Integer) request.getAttribute("soChuaDoc");
    if (_dsTB == null) _dsTB = new java.util.ArrayList<>();
    if (_soChuaDoc == null) _soChuaDoc = 0;
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Tổ Dân Phố</title>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg:#0f1117;--surface:#181c27;--surface2:#1f2433;--border:#2a3048;
            --accent:#4f8ef7;--accent2:#38d9a9;--danger:#f75c5c;--warn:#fbbf24;
            --text:#e2e8f0;--muted:#64748b;--radius:14px;
        }
        *,*::before,*::after{box-sizing:border-box;margin:0;padding:0;}
        body{font-family:'Be Vietnam Pro',sans-serif;background:var(--bg);color:var(--text);min-height:100vh;}
        .topbar{position:fixed;top:0;left:0;right:0;z-index:200;height:64px;background:rgba(15,17,23,.88);backdrop-filter:blur(16px);border-bottom:1px solid var(--border);display:flex;align-items:center;padding:0 32px;gap:16px;}
        .topbar-logo{display:flex;align-items:center;gap:10px;text-decoration:none;color:var(--text);}
        .logo-icon{width:34px;height:34px;border-radius:8px;background:linear-gradient(135deg,var(--accent),var(--accent2));display:flex;align-items:center;justify-content:center;font-size:16px;}
        .logo-text{font-size:14px;font-weight:700;letter-spacing:-.3px;}
        .logo-text span{color:var(--accent);}
        .topbar-divider{width:1px;height:24px;background:var(--border);}
        .topbar-title{font-size:13px;font-weight:600;color:var(--muted);}
        .topbar-spacer{flex:1;}
        .qr-scan-btn{width:38px;height:38px;border-radius:50%;background:var(--surface2);border:1px solid var(--border);display:flex;align-items:center;justify-content:center;cursor:pointer;font-size:17px;transition:all .18s;text-decoration:none;}
        .qr-scan-btn:hover{background:var(--surface);border-color:var(--accent2);}
        .bell-wrap{position:relative;}
        .bell-btn{width:38px;height:38px;border-radius:50%;background:var(--surface2);border:1px solid var(--border);display:flex;align-items:center;justify-content:center;cursor:pointer;font-size:17px;transition:all .18s;}
        .bell-btn:hover{background:var(--surface);border-color:var(--accent);}
        .bell-badge{position:absolute;top:-4px;right:-4px;background:var(--danger);color:#fff;font-size:9px;font-weight:700;width:16px;height:16px;border-radius:50%;display:flex;align-items:center;justify-content:center;border:2px solid var(--bg);animation:pulse 2s infinite;}
        @keyframes pulse{0%,100%{transform:scale(1)}50%{transform:scale(1.2)}}
        .notif-panel{position:absolute;top:calc(100% + 10px);right:0;width:320px;background:var(--surface2);border:1px solid var(--border);border-radius:var(--radius);box-shadow:0 16px 48px rgba(0,0,0,.6);display:none;z-index:400;overflow:hidden;}
        .notif-panel.open{display:block;animation:dropDown .18s ease;}
        .np-header{padding:14px 18px;border-bottom:1px solid var(--border);display:flex;align-items:center;justify-content:space-between;}
        .np-header h4{font-size:14px;font-weight:700;}
        .np-mark{font-size:11px;color:var(--accent);cursor:pointer;font-weight:500;}
        .np-list{max-height:300px;overflow-y:auto;}
        .np-item{padding:12px 18px;border-bottom:1px solid var(--border);display:flex;gap:10px;align-items:flex-start;cursor:pointer;transition:background .15s;}
        .np-item:hover{background:var(--surface);}
        .np-item.unread{border-left:3px solid var(--accent);}
        .np-dot{width:8px;height:8px;border-radius:50%;background:var(--accent);flex-shrink:0;margin-top:5px;}
        .np-dot.read{background:var(--muted);}
        .np-body p{font-size:12px;line-height:1.5;}
        .np-time{font-size:10px;color:var(--muted);margin-top:3px;}
        .np-footer{padding:10px;text-align:center;font-size:12px;color:var(--accent);cursor:pointer;border-top:1px solid var(--border);}
        .np-empty{padding:24px;text-align:center;color:var(--muted);font-size:13px;}
        .modal-overlay{position:fixed;inset:0;background:rgba(0,0,0,.7);z-index:500;display:none;align-items:center;justify-content:center;}
        .modal-overlay.open{display:flex;animation:fadeIn .2s ease;}
        @keyframes fadeIn{from{opacity:0}to{opacity:1}}
        .modal{background:var(--surface);border:1px solid var(--border);border-radius:var(--radius);padding:32px;width:420px;text-align:center;position:relative;}
        .modal-close{position:absolute;top:14px;right:16px;background:none;border:none;color:var(--muted);font-size:18px;cursor:pointer;}
        .modal-close:hover{color:var(--text);}
        .modal h3{font-size:17px;font-weight:800;margin-bottom:6px;}
        .modal p{font-size:13px;color:var(--muted);margin-bottom:24px;}
        .tab-group{display:flex;gap:8px;justify-content:center;margin-bottom:20px;}
        .tab-btn{padding:7px 18px;border-radius:8px;font-size:12px;font-weight:600;cursor:pointer;font-family:inherit;transition:all .18s;border:1px solid var(--border);background:var(--surface2);color:var(--muted);}
        .tab-btn.active{background:var(--accent);color:#fff;border-color:var(--accent);}
        .tab-content{display:none;}
        .tab-content.active{display:block;}
        .upload-area{border:2px dashed var(--border);border-radius:10px;padding:28px 20px;cursor:pointer;transition:border-color .18s;margin-bottom:12px;}
        .upload-area:hover{border-color:var(--accent2);}
        .upload-area input{display:none;}
        .upload-icon{font-size:28px;margin-bottom:8px;}
        .upload-text{font-size:13px;color:var(--muted);}
        #video{width:100%;border-radius:10px;margin-bottom:12px;display:none;}
        .scan-status{font-size:12px;color:var(--accent2);min-height:20px;margin-top:8px;}
        .scan-err{color:var(--danger);}
        .modal-btn{display:inline-flex;align-items:center;gap:8px;padding:10px 22px;border-radius:8px;font-size:13px;font-weight:600;cursor:pointer;font-family:inherit;transition:all .18s;border:none;}
        .modal-btn-green{background:rgba(56,217,169,.15);color:var(--accent2);border:1px solid rgba(56,217,169,.3);}
        .modal-btn-green:hover{background:var(--accent2);color:#000;}
        .modal-btn-muted{background:var(--surface2);color:var(--muted);border:1px solid var(--border);}
        .modal-btn-muted:hover{background:var(--surface);color:var(--text);}
        .user-menu{position:relative;}
        .avatar-btn{display:flex;align-items:center;gap:10px;background:none;border:1px solid transparent;border-radius:40px;padding:5px 14px 5px 5px;cursor:pointer;color:var(--text);font-family:inherit;transition:all .18s;}
        .avatar-btn:hover{background:var(--surface2);border-color:var(--border);}
        .avatar{width:34px;height:34px;border-radius:50%;background:linear-gradient(135deg,var(--accent),var(--accent2));display:flex;align-items:center;justify-content:center;font-size:13px;font-weight:700;color:#fff;flex-shrink:0;text-transform:uppercase;overflow:hidden;}
        .avatar img{width:100%;height:100%;object-fit:cover;}
        .avatar-info{text-align:left;}
        .avatar-name{font-size:13px;font-weight:600;line-height:1.2;}
        .avatar-role{font-size:11px;color:var(--accent2);font-weight:500;}
        .avatar-chevron{font-size:11px;color:var(--muted);transition:transform .2s;}
        .avatar-btn.open .avatar-chevron{transform:rotate(180deg);}
        .user-dropdown{position:absolute;top:calc(100% + 10px);right:0;width:250px;background:var(--surface2);border:1px solid var(--border);border-radius:var(--radius);box-shadow:0 16px 48px rgba(0,0,0,.5);display:none;z-index:300;overflow:hidden;}
        .user-dropdown.open{display:block;animation:dropDown .18s ease;}
        @keyframes dropDown{from{opacity:0;transform:translateY(-8px)}to{opacity:1;transform:translateY(0)}}
        .ud-header{padding:16px;border-bottom:1px solid var(--border);display:flex;align-items:center;gap:12px;}
        .ud-header .avatar{width:42px;height:42px;font-size:16px;}
        .ud-name{font-size:13px;font-weight:700;}
        .ud-email{font-size:11px;color:var(--muted);margin-top:2px;}
        .ud-badge{display:inline-flex;align-items:center;gap:4px;font-size:10px;font-weight:600;padding:2px 8px;border-radius:20px;margin-top:5px;background:rgba(56,217,169,.15);color:var(--accent2);}
        .ud-badge::before{content:'';width:5px;height:5px;border-radius:50%;background:currentColor;}
        .ud-item{display:flex;align-items:center;gap:10px;padding:10px 16px;font-size:13px;font-weight:500;color:var(--text);text-decoration:none;transition:background .15s;cursor:pointer;}
        .ud-item:hover{background:var(--surface);}
        .ud-item .ud-icon{font-size:16px;width:20px;text-align:center;}
        .ud-item.danger{color:var(--danger);}
        .ud-item.danger:hover{background:rgba(247,92,92,.1);}
        .ud-divider{border:none;border-top:1px solid var(--border);margin:4px 0;}
        .main{padding-top:64px;}
        .content{max-width:1200px;margin:0 auto;padding:40px 32px;}
        .hero{background:var(--surface);border:1px solid var(--border);border-radius:var(--radius);padding:32px 36px;margin-bottom:28px;display:flex;align-items:center;justify-content:space-between;position:relative;overflow:hidden;}
        .hero::before{content:'';position:absolute;top:-60px;right:-60px;width:260px;height:260px;background:radial-gradient(circle,rgba(79,142,247,.15) 0%,transparent 70%);pointer-events:none;}
        .hero-left h1{font-size:26px;font-weight:800;margin-bottom:6px;letter-spacing:-.5px;}
        .hero-left h1 span{color:var(--accent);}
        .hero-left p{font-size:14px;color:var(--muted);}
        .hero-right{display:flex;gap:16px;flex-shrink:0;}
        .stat-chip{background:var(--surface2);border:1px solid var(--border);border-radius:12px;padding:16px 22px;text-align:center;min-width:100px;}
        .stat-chip .sc-num{font-size:28px;font-weight:800;background:linear-gradient(135deg,var(--accent),var(--accent2));-webkit-background-clip:text;-webkit-text-fill-color:transparent;}
        .stat-chip .sc-label{font-size:11px;color:var(--muted);font-weight:500;margin-top:3px;}
        .section-title{font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:1.2px;color:var(--muted);margin-bottom:16px;}
        .cards-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(260px,1fr));gap:16px;margin-bottom:32px;}
        .dash-card{background:var(--surface);border:1px solid var(--border);border-radius:var(--radius);padding:24px;text-decoration:none;color:var(--text);transition:border-color .2s,transform .2s,box-shadow .2s;display:block;cursor:pointer;}
        .dash-card:hover{transform:translateY(-3px);box-shadow:0 8px 32px rgba(0,0,0,.3);}
        .dash-card.blue:hover{border-color:var(--accent);}
        .dash-card.green:hover{border-color:var(--accent2);}
        .dash-card.warn:hover{border-color:var(--warn);}
        .dash-card.red:hover{border-color:var(--danger);}
        .dc-icon{width:44px;height:44px;border-radius:12px;display:flex;align-items:center;justify-content:center;font-size:22px;margin-bottom:16px;}
        .dc-icon.blue{background:rgba(79,142,247,.15);}
        .dc-icon.green{background:rgba(56,217,169,.15);}
        .dc-icon.warn{background:rgba(251,191,36,.15);}
        .dc-icon.red{background:rgba(247,92,92,.15);}
        .dc-title{font-size:15px;font-weight:700;margin-bottom:8px;}
        .dc-desc{font-size:13px;color:var(--muted);line-height:1.6;margin-bottom:20px;}
        .dc-btn{display:inline-flex;align-items:center;gap:6px;font-size:13px;font-weight:600;padding:8px 16px;border-radius:8px;border:none;cursor:pointer;font-family:inherit;text-decoration:none;transition:all .18s;}
        .dc-btn.blue{background:rgba(79,142,247,.15);color:var(--accent);}
        .dc-btn.green{background:rgba(56,217,169,.15);color:var(--accent2);}
        .dc-btn.warn{background:rgba(251,191,36,.15);color:var(--warn);}
        .dc-btn.red{background:rgba(247,92,92,.15);color:var(--danger);}
        .dc-btn.blue:hover{background:var(--accent);color:#fff;}
        .dc-btn.green:hover{background:var(--accent2);color:#000;}
        .dc-btn.warn:hover{background:var(--warn);color:#000;}
        .dc-btn.red:hover{background:var(--danger);color:#fff;}
        .activity-card{background:var(--surface);border:1px solid var(--border);border-radius:var(--radius);overflow:hidden;}
        .ac-header{padding:20px 24px;border-bottom:1px solid var(--border);display:flex;align-items:center;justify-content:space-between;}
        .ac-header h3{font-size:15px;font-weight:700;}
        .ac-empty{padding:40px;text-align:center;color:var(--muted);font-size:13px;}
        .ac-empty .ac-empty-icon{font-size:32px;margin-bottom:10px;}
        .logout-overlay{display:none;position:fixed;inset:0;z-index:9999;background:rgba(0,0,0,.7);backdrop-filter:blur(6px);align-items:center;justify-content:center;}
        .logout-overlay.show{display:flex;animation:fadeIn .2s ease;}
        .logout-box{background:var(--surface);border:1px solid var(--border);border-radius:16px;width:380px;max-width:calc(100vw - 32px);box-shadow:0 24px 64px rgba(0,0,0,.6);overflow:hidden;animation:popIn .22s cubic-bezier(.34,1.56,.64,1);}
        @keyframes popIn{from{opacity:0;transform:scale(.93) translateY(10px)}to{opacity:1;transform:none}}
        .logout-body{padding:28px 28px 20px;text-align:center;}
        .logout-ico{font-size:40px;margin-bottom:14px;}
        .logout-title{font-size:17px;font-weight:800;margin-bottom:6px;}
        .logout-sub{font-size:13px;color:var(--muted);line-height:1.5;}
        .logout-footer{padding:16px 24px 24px;display:flex;gap:10px;}
        .btn-lo-cancel{flex:1;height:40px;border-radius:10px;background:var(--surface2);border:1px solid var(--border);color:var(--muted);font-size:13px;font-weight:600;font-family:inherit;cursor:pointer;transition:all .15s;}
        .btn-lo-cancel:hover{border-color:var(--text);color:var(--text);}
        .btn-lo-confirm{flex:1;height:40px;border-radius:10px;background:var(--danger);border:none;color:#fff;font-size:13px;font-weight:700;font-family:inherit;cursor:pointer;transition:opacity .15s;}
        .btn-lo-confirm:hover{opacity:.85;}
    </style>
</head>
<body>

<header class="topbar">
    <a href="#" class="topbar-logo">
        <div class="logo-icon">🏘</div>
        <div class="logo-text">Quản lý <span>Hộ dân</span></div>
    </a>
    <div class="topbar-divider"></div>
    <span class="topbar-title">Tổ dân phố</span>
    <div class="topbar-spacer"></div>

    <button class="qr-scan-btn" onclick="openScanModal()" title="Quét mã QR hộ dân">📷</button>

    <div class="bell-wrap" id="bellWrap">
        <button class="bell-btn" onclick="toggleNotif(event)">
            🔔
            <span class="bell-badge" id="bellCount"
                  style="<%= _soChuaDoc == 0 ? "display:none;" : "" %>">
                <%= _soChuaDoc > 99 ? "99+" : _soChuaDoc %>
            </span>
        </button>
        <div class="notif-panel" id="notifPanel">
            <div class="np-header">
                <h4>Thông báo</h4>
                <% if (_soChuaDoc > 0) { %>
                <span class="np-mark" onclick="markAllRead()">Đánh dấu đã đọc</span>
                <% } %>
            </div>
            <div class="np-list" id="notifList">
                <% if (_dsTB.isEmpty()) { %>
                <div class="np-empty">📭 Chưa có thông báo nào</div>
                <% } else {
                    int _cnt = 0;
                    for (Map<String, Object> tb : _dsTB) {
                        if (_cnt++ >= 5) break;
                        boolean _daDoc  = Boolean.TRUE.equals(tb.get("daDoc"));
                        String _tieuDe  = String.valueOf(tb.get("tieuDe"));
                        String _noidung = tb.get("noiDung") != null ? String.valueOf(tb.get("noiDung")) : "";
                        String _preview = _noidung.length() > 72 ? _noidung.substring(0,72) + "…" : _noidung;
                        String _ngayGui = String.valueOf(tb.get("ngayGui"));
                        Object _tbID    = tb.get("thongBaoID");
                        Object _lichHopID  = tb.get("lichHopID");
                        String _lichHopJs  = (_lichHopID != null) ? _lichHopID.toString() : "0";
                        String _tieuDeJs = _tieuDe.replace("\\","\\\\").replace("'","\\'");
                %>
                <div class="np-item <%= _daDoc ? "" : "unread" %>"
                     onclick="docThongBao(<%= _tbID %>, this, '<%= _tieuDeJs %>', <%= _lichHopJs %>)">
                    <div class="np-dot <%= _daDoc ? "read" : "" %>"></div>
                    <div class="np-body">
                        <p><strong><%= _tieuDe %></strong></p>
                        <% if (!_preview.isEmpty()) { %>
                        <p style="color:var(--muted);margin-top:2px"><%= _preview %></p>
                        <% } %>
                        <div class="np-time"><%= _ngayGui %></div>
                    </div>
                </div>
                <% } } %>
            </div>
            <div class="np-footer" onclick="location.href='<%= ctx %>/thong-bao/lich-su'">
                Xem tất cả thông báo
            </div>
        </div>
    </div>

    <div class="user-menu">
        <button class="avatar-btn" id="avatarBtn" onclick="toggleMenu()">
            <%-- ── FIX: render avatar từ JSP, không dùng JS textContent ── --%>
            <div class="avatar">
                <c:choose>
                    <c:when test="${not empty currentUser.avatarPath}">
                        <img src="${pageContext.request.contextPath}/${currentUser.avatarPath}" alt="avatar">
                    </c:when>
                    <c:otherwise>${currentUser.ten.substring(0,1)}</c:otherwise>
                </c:choose>
            </div>
            <div class="avatar-info">
                <div class="avatar-name">${currentUser.ho} ${currentUser.ten}</div>
                <div class="avatar-role">Tổ trưởng</div>
            </div>
            <span class="avatar-chevron">▼</span>
        </button>
        <div class="user-dropdown" id="userDropdown">
            <div class="ud-header">
                <%-- ── FIX: avatar trong dropdown ── --%>
                <div class="avatar">
                    <c:choose>
                        <c:when test="${not empty currentUser.avatarPath}">
                            <img src="${pageContext.request.contextPath}/${currentUser.avatarPath}" alt="avatar">
                        </c:when>
                        <c:otherwise>${currentUser.ten.substring(0,1)}</c:otherwise>
                    </c:choose>
                </div>
                <div>
                    <div class="ud-name">${currentUser.ho} ${currentUser.ten}</div>
                    <div class="ud-email">${currentUser.email}</div>
                    <span class="ud-badge">Đang hoạt động</span>
                </div>
            </div>
            <a class="ud-item" href="${pageContext.request.contextPath}/profile">
                <span class="ud-icon">👤</span> Thông tin cá nhân
            </a>
            <a class="ud-item" href="${pageContext.request.contextPath}/admin/change_password">
                <span class="ud-icon">🔑</span> Đổi mật khẩu
            </a>
            <hr class="ud-divider">
            <div class="ud-item danger" onclick="showLogoutModal()">
                <span class="ud-icon">🚪</span> Đăng xuất
            </div>
        </div>
    </div>
</header>

<!-- QR Modal -->
<div class="modal-overlay" id="scanModal" onclick="closeScanModalOutside(event)">
    <div class="modal">
        <button class="modal-close" onclick="closeScanModal()">✕</button>
        <h3>Quét mã QR hộ dân</h3>
        <p>Upload ảnh QR hoặc dùng camera để quét</p>
        <div class="tab-group">
            <button class="tab-btn active" onclick="switchTab('upload')">📁 Upload ảnh</button>
            <button class="tab-btn" onclick="switchTab('camera')">📷 Camera</button>
        </div>
        <div class="tab-content active" id="tab-upload">
            <div class="upload-area" onclick="document.getElementById('qrFileInput').click()">
                <input type="file" id="qrFileInput" accept="image/*" onchange="scanFromFile(event)"/>
                <div class="upload-icon">📂</div>
                <div class="upload-text">Nhấn để chọn ảnh QR<br><span style="font-size:11px">PNG, JPG, JPEG</span></div>
            </div>
        </div>
        <div class="tab-content" id="tab-camera">
            <video id="video" autoplay playsinline></video>
            <canvas id="canvas" style="display:none"></canvas>
            <button class="modal-btn modal-btn-green" onclick="startCamera()" style="margin-bottom:8px">▶ Bật camera</button>
        </div>
        <div class="scan-status" id="scanStatus"></div>
        <div style="margin-top:16px">
            <button class="modal-btn modal-btn-muted" onclick="closeScanModal()">Đóng</button>
        </div>
    </div>
</div>

<!-- MODAL ĐĂNG XUẤT -->
<div class="logout-overlay" id="logoutModal" onclick="if(event.target===this)hideLogoutModal()">
    <div class="logout-box">
        <div class="logout-body">
            <div class="logout-ico">🚪</div>
            <div class="logout-title">Đăng xuất?</div>
            <div class="logout-sub">Bạn sẽ được đưa về trang đăng nhập.<br>Mọi phiên làm việc hiện tại sẽ kết thúc.</div>
        </div>
        <div class="logout-footer">
            <button class="btn-lo-cancel" onclick="hideLogoutModal()">Ở lại</button>
            <button class="btn-lo-confirm" onclick="window.location.href='<%= ctx %>/logout'">🚪 Đăng xuất</button>
        </div>
    </div>
</div>

<main class="main">
    <div class="content">
        <div class="hero">
            <div class="hero-left">
                <h1>Xin chào, <span>${currentUser.ten}</span> 👋</h1>
                <p>Tổ dân phố <strong style="color:var(--accent2)">${not empty tenTo ? tenTo : 'của bạn'}</strong> — Chào mừng quay lại hệ thống quản lý</p>
            </div>
            <div class="hero-right">
                <div class="stat-chip"><div class="sc-num">--</div><div class="sc-label">Hộ dân</div></div>
                <div class="stat-chip"><div class="sc-num">--</div><div class="sc-label">Nhân khẩu</div></div>
                <div class="stat-chip"><div class="sc-num"><%= _soChuaDoc > 0 ? _soChuaDoc : "--" %></div><div class="sc-label">Thông báo</div></div>
            </div>
        </div>

        <div class="section-title">Chức năng chính</div>
        <div class="cards-grid">
            <a href="${pageContext.request.contextPath}/todan/hodan" class="dash-card blue">
                <div class="dc-icon blue">📋</div>
                <div class="dc-title">Quản lý hộ dân</div>
                <div class="dc-desc">Xem danh sách, thêm, sửa, xóa thông tin hộ khẩu trong tổ dân phố.</div>
                <span class="dc-btn blue">Xem danh sách →</span>
            </a>
            <a href="${pageContext.request.contextPath}/danh-sach-lich-hop" class="dash-card green">
                <div class="dc-icon green">📅</div>
                <div class="dc-title">Lịch họp tổ</div>
                <div class="dc-desc">Tạo và quản lý lịch họp tổ dân phố, thông báo đến toàn bộ chủ hộ.</div>
                <span class="dc-btn green">Xem lịch họp →</span>
            </a>
            <a href="${pageContext.request.contextPath}/thiepmoi/danh-sach" class="dash-card warn">
                <div class="dc-icon warn">💌</div>
                <div class="dc-title">Thiệp mời họp</div>
                <div class="dc-desc">Tạo và gửi thiệp mời họp theo mẫu đến toàn bộ hộ dân trong tổ.</div>
                <span class="dc-btn warn">Quản lý thiệp →</span>
            </a>
            <a href="${pageContext.request.contextPath}/totruong/phan-anh" class="dash-card red">
                <div class="dc-icon red">💬</div>
                <div class="dc-title">Phản ánh / Kiến nghị</div>
                <div class="dc-desc">Tiếp nhận và xử lý phản ánh, kiến nghị từ người dân trong tổ dân phố.</div>
                <span class="dc-btn red">Xem phản ánh →</span>
            </a>
            
        </div>

        <div class="section-title">Hoạt động gần đây</div>
        <div class="activity-card">
            <div class="ac-header"><h3>Nhật ký hoạt động</h3></div>
            <div class="ac-empty">
                <div class="ac-empty-icon">📭</div>
                <p>Chưa có hoạt động nào gần đây</p>
            </div>
        </div>
    </div>
</main>

<script src="https://cdn.jsdelivr.net/npm/jsqr@1.4.0/dist/jsQR.js"></script>
<script>
    const ctx = '<%= ctx %>';

    // ── JS initials đã bị XOÁ, avatar được render bởi JSP c:choose ở trên ──

    function toggleMenu() {
        const dd = document.getElementById('userDropdown');
        const btn = document.getElementById('avatarBtn');
        document.getElementById('notifPanel').classList.remove('open');
        const open = dd.classList.toggle('open');
        btn.classList.toggle('open', open);
    }

    function toggleNotif(e) {
        e.stopPropagation();
        document.getElementById('userDropdown').classList.remove('open');
        document.getElementById('avatarBtn').classList.remove('open');
        document.getElementById('notifPanel').classList.toggle('open');
    }

    function docThongBao(id, el, tieuDe, lichHopID) {
        const params = new URLSearchParams({ action: 'doc', id: id });
        fetch(ctx + '/thong-bao?' + params, { method: 'POST' })
            .then(r => r.json())
            .then(data => {
                if (data.success) {
                    el.classList.remove('unread');
                    const dot = el.querySelector('.np-dot');
                    if (dot) dot.classList.add('read');
                    _giamBadge(1);
                }
                _redirect(tieuDe, lichHopID);
            })
            .catch(() => _redirect(tieuDe, lichHopID));
    }

    function _redirect(tieuDe, lichHopID) {
        const t = (tieuDe || '').toLowerCase();
        if (t.includes('phản ánh') || t.includes('kiến nghị')) {
            location.href = ctx + '/totruong/phan-anh';
            return;
        }
        if (t.includes('lịch họp') || (lichHopID && lichHopID > 0)) {
            location.href = ctx + '/danh-sach-lich-hop' + (lichHopID > 0 ? '?id=' + lichHopID : '');
            return;
        }
        if (t.includes('yêu cầu') || t.includes('hộ khẩu') || t.includes('trạng thái')) {
            location.href = ctx + '/todan/hodan';
            return;
        }
        location.href = ctx + '/thong-bao/lich-su';
    }

    function markAllRead() {
        fetch(ctx + '/thong-bao?action=docTatCa', { method: 'POST' })
            .then(r => r.json())
            .then(data => {
                if (data.success) {
                    document.querySelectorAll('#notifList .np-item.unread').forEach(el => el.classList.remove('unread'));
                    document.querySelectorAll('#notifList .np-dot').forEach(d => d.classList.add('read'));
                    const badge = document.getElementById('bellCount');
                    if (badge) badge.style.display = 'none';
                }
            }).catch(console.error);
    }

    function _giamBadge(so) {
        const badge = document.getElementById('bellCount');
        if (!badge) return;
        let cur = parseInt(badge.textContent) || 0;
        cur = Math.max(0, cur - so);
        if (cur === 0) badge.style.display = 'none';
        else { badge.textContent = cur; badge.style.display = ''; }
    }

    function showLogoutModal() {
        document.getElementById('userDropdown').classList.remove('open');
        document.getElementById('avatarBtn').classList.remove('open');
        document.getElementById('logoutModal').classList.add('show');
        document.body.style.overflow = 'hidden';
    }
    function hideLogoutModal() {
        document.getElementById('logoutModal').classList.remove('show');
        document.body.style.overflow = '';
    }

    document.addEventListener('keydown', e => {
        if (e.key === 'Escape') { hideLogoutModal(); closeScanModal(); }
    });

    document.addEventListener('click', function(e) {
        if (!document.getElementById('bellWrap').contains(e.target))
            document.getElementById('notifPanel').classList.remove('open');
        if (!document.querySelector('.user-menu').contains(e.target)) {
            document.getElementById('userDropdown').classList.remove('open');
            document.getElementById('avatarBtn').classList.remove('open');
        }
    });

    // QR Scanner
    let cameraStream = null;
    function openScanModal() { document.getElementById('scanModal').classList.add('open'); }
    function closeScanModal() {
        document.getElementById('scanModal').classList.remove('open');
        stopCamera();
        document.getElementById('scanStatus').textContent = '';
        document.getElementById('qrFileInput').value = '';
    }
    function closeScanModalOutside(e) { if (e.target === document.getElementById('scanModal')) closeScanModal(); }
    function switchTab(tab) {
        document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
        document.querySelectorAll('.tab-content').forEach(c => c.classList.remove('active'));
        document.getElementById('tab-' + tab).classList.add('active');
        event.target.classList.add('active');
        if (tab !== 'camera') stopCamera();
    }
    function scanFromFile(event) {
        const file = event.target.files[0];
        if (!file) return;
        setStatus('Đang đọc mã QR...', false);
        const reader = new FileReader();
        reader.onload = function(e) {
            const img = new Image();
            img.onload = function() {
                const canvas = document.getElementById('canvas');
                canvas.width = img.width; canvas.height = img.height;
                const c = canvas.getContext('2d');
                c.drawImage(img, 0, 0);
                const imageData = c.getImageData(0, 0, canvas.width, canvas.height);
                const code = jsQR(imageData.data, canvas.width, canvas.height);
                if (code) { setStatus('✅ Tìm thấy! Đang chuyển hướng...', false); setTimeout(() => { window.location.href = code.data; }, 800); }
                else setStatus('❌ Không đọc được mã QR. Thử ảnh khác!', true);
            };
            img.src = e.target.result;
        };
        reader.readAsDataURL(file);
    }
    function startCamera() {
        const video = document.getElementById('video');
        video.style.display = 'block';
        setStatus('Đang khởi động camera...', false);
        navigator.mediaDevices.getUserMedia({ video: { facingMode: 'environment' } })
            .then(stream => { cameraStream = stream; video.srcObject = stream; video.play(); setStatus('📷 Hướng camera vào mã QR...', false); requestAnimationFrame(scanFromCamera); })
            .catch(() => setStatus('❌ Không thể truy cập camera', true));
    }
    function scanFromCamera() {
        if (!cameraStream) return;
        const video = document.getElementById('video'), canvas = document.getElementById('canvas');
        if (video.readyState === video.HAVE_ENOUGH_DATA) {
            canvas.width = video.videoWidth; canvas.height = video.videoHeight;
            const c = canvas.getContext('2d'); c.drawImage(video, 0, 0, canvas.width, canvas.height);
            const code = jsQR(c.getImageData(0,0,canvas.width,canvas.height).data, canvas.width, canvas.height);
            if (code) { setStatus('✅ Tìm thấy! Đang chuyển hướng...', false); stopCamera(); setTimeout(() => { window.location.href = code.data; }, 800); return; }
        }
        requestAnimationFrame(scanFromCamera);
    }
    function stopCamera() {
        if (cameraStream) { cameraStream.getTracks().forEach(t => t.stop()); cameraStream = null; }
        const video = document.getElementById('video'); video.style.display = 'none'; video.srcObject = null;
    }
    function setStatus(msg, isError) {
        const el = document.getElementById('scanStatus');
        el.textContent = msg; el.className = 'scan-status' + (isError ? ' scan-err' : '');
    }
</script>
</body>
</html>
