<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.Map" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Người Dân</title>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg:       #0f1117;
            --surface:  #181c27;
            --surface2: #1f2433;
            --border:   #2a3048;
            --accent:   #4f8ef7;
            --accent2:  #38d9a9;
            --danger:   #f75c5c;
            --warn:     #fbbf24;
            --text:     #e2e8f0;
            --muted:    #64748b;
            --radius:   14px;
        }
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Be Vietnam Pro', sans-serif; background: var(--bg); color: var(--text); min-height: 100vh; }

        .topbar { position: fixed; top: 0; left: 0; right: 0; z-index: 200; height: 64px; background: rgba(15,17,23,.88); backdrop-filter: blur(16px); border-bottom: 1px solid var(--border); display: flex; align-items: center; padding: 0 32px; gap: 16px; }
        .topbar-logo { display: flex; align-items: center; gap: 10px; text-decoration: none; color: var(--text); }
        .logo-icon { width: 34px; height: 34px; border-radius: 8px; background: linear-gradient(135deg, var(--accent), var(--accent2)); display: flex; align-items: center; justify-content: center; font-size: 16px; }
        .logo-text { font-size: 14px; font-weight: 700; letter-spacing: -.3px; }
        .logo-text span { color: var(--accent); }
        .topbar-divider { width: 1px; height: 24px; background: var(--border); }
        .topbar-title { font-size: 13px; font-weight: 600; color: var(--muted); }
        .topbar-spacer { flex: 1; }
        .qr-btn { width: 38px; height: 38px; border-radius: 50%; background: var(--surface2); border: 1px solid var(--border); display: flex; align-items: center; justify-content: center; font-size: 17px; transition: all .18s; text-decoration: none; cursor: pointer; }
        .qr-btn:hover { background: var(--surface); border-color: var(--accent2); }
        .bell-wrap { position: relative; }
        .bell-btn { width: 38px; height: 38px; border-radius: 50%; background: var(--surface2); border: 1px solid var(--border); display: flex; align-items: center; justify-content: center; cursor: pointer; font-size: 17px; transition: all .18s; }
        .bell-btn:hover { background: var(--surface); border-color: var(--accent); }
        .bell-badge { position: absolute; top: -4px; right: -4px; background: var(--danger); color: #fff; font-size: 9px; font-weight: 700; width: 16px; height: 16px; border-radius: 50%; display: flex; align-items: center; justify-content: center; border: 2px solid var(--bg); animation: pulse 2s infinite; }
        @keyframes pulse { 0%,100%{transform:scale(1)} 50%{transform:scale(1.2)} }
        .notif-panel { position: absolute; top: calc(100% + 10px); right: 0; width: 320px; background: var(--surface2); border: 1px solid var(--border); border-radius: var(--radius); box-shadow: 0 16px 48px rgba(0,0,0,.6); display: none; z-index: 400; overflow: hidden; }
        .notif-panel.open { display: block; animation: dropDown .18s ease; }
        .np-header { padding: 14px 18px; border-bottom: 1px solid var(--border); display: flex; align-items: center; justify-content: space-between; }
        .np-header h4 { font-size: 14px; font-weight: 700; }
        .np-mark { font-size: 11px; color: var(--accent); cursor: pointer; font-weight: 500; }
        .np-list { max-height: 300px; overflow-y: auto; }
        .np-item { padding: 12px 18px; border-bottom: 1px solid var(--border); display: flex; gap: 10px; align-items: flex-start; cursor: pointer; transition: background .15s; }
        .np-item:hover { background: var(--surface); }
        .np-item.unread { border-left: 3px solid var(--accent); }
        .np-dot { width: 8px; height: 8px; border-radius: 50%; background: var(--accent); flex-shrink: 0; margin-top: 5px; }
        .np-dot.read { background: var(--muted); }
        .np-body p { font-size: 12px; line-height: 1.5; }
        .np-time { font-size: 10px; color: var(--muted); margin-top: 3px; }
        .np-empty { padding: 28px; text-align: center; color: var(--muted); font-size: 13px; }
        .np-footer { padding: 10px; text-align: center; font-size: 12px; color: var(--accent); cursor: pointer; border-top: 1px solid var(--border); }
        .user-menu { position: relative; }
        .avatar-btn { display: flex; align-items: center; gap: 10px; background: none; border: 1px solid transparent; border-radius: 40px; padding: 5px 14px 5px 5px; cursor: pointer; color: var(--text); font-family: inherit; transition: all .18s; }
        .avatar-btn:hover { background: var(--surface2); border-color: var(--border); }
        .avatar { width: 34px; height: 34px; border-radius: 50%; background: linear-gradient(135deg, var(--accent), var(--accent2)); display: flex; align-items: center; justify-content: center; font-size: 13px; font-weight: 700; color: #fff; flex-shrink: 0; overflow: hidden; }
        .avatar img { width: 100%; height: 100%; object-fit: cover; }
        .avatar-info { text-align: left; }
        .avatar-name { font-size: 13px; font-weight: 600; line-height: 1.2; }
        .avatar-role { font-size: 11px; color: var(--accent2); font-weight: 500; }
        .avatar-chevron { font-size: 11px; color: var(--muted); transition: transform .2s; }
        .avatar-btn.open .avatar-chevron { transform: rotate(180deg); }
        .user-dropdown { position: absolute; top: calc(100% + 10px); right: 0; width: 260px; background: var(--surface2); border: 1px solid var(--border); border-radius: var(--radius); box-shadow: 0 16px 48px rgba(0,0,0,.5); display: none; z-index: 300; overflow: hidden; }
        .user-dropdown.open { display: block; animation: dropDown .18s ease; }
        @keyframes dropDown { from { opacity:0; transform:translateY(-8px); } to { opacity:1; transform:translateY(0); } }
        .ud-header { padding: 16px; border-bottom: 1px solid var(--border); display: flex; align-items: center; gap: 12px; }
        .ud-header .avatar { width: 42px; height: 42px; font-size: 16px; }
        .ud-name  { font-size: 13px; font-weight: 700; }
        .ud-email { font-size: 11px; color: var(--muted); margin-top: 2px; }
        .ud-badge { display: inline-flex; align-items: center; gap: 4px; font-size: 10px; font-weight: 600; padding: 2px 8px; border-radius: 20px; margin-top: 5px; background: rgba(56,217,169,.15); color: var(--accent2); }
        .ud-badge::before { content:''; width:5px; height:5px; border-radius:50%; background:currentColor; }
        .ud-section { font-size: 9px; font-weight: 700; text-transform: uppercase; letter-spacing: 1px; color: var(--muted); padding: 10px 16px 4px; }
        .ud-item { display: flex; align-items: center; gap: 10px; padding: 9px 16px; font-size: 13px; font-weight: 500; color: var(--text); text-decoration: none; transition: background .15s; cursor: pointer; }
        .ud-item:hover { background: var(--surface); }
        .ud-item .ud-icon { font-size: 15px; width: 20px; text-align: center; }
        .ud-item.danger { color: var(--danger); }
        .ud-item.danger:hover { background: rgba(247,92,92,.1); }
        .ud-divider { border: none; border-top: 1px solid var(--border); margin: 4px 0; }
        .main { padding-top: 64px; }
        .content { max-width: 1200px; margin: 0 auto; padding: 40px 32px; }
        .hero { background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius); padding: 32px 36px; margin-bottom: 28px; display: flex; align-items: center; justify-content: space-between; position: relative; overflow: hidden; }
        .hero::before { content: ''; position: absolute; top: -60px; right: -60px; width: 260px; height: 260px; background: radial-gradient(circle, rgba(79,142,247,.15) 0%, transparent 70%); pointer-events: none; }
        .hero-left h1 { font-size: 26px; font-weight: 800; margin-bottom: 6px; }
        .hero-left h1 span { color: var(--accent); }
        .hero-left p { font-size: 14px; color: var(--muted); }
        .hero-right { display: flex; gap: 16px; flex-shrink: 0; }
        .stat-chip { background: var(--surface2); border: 1px solid var(--border); border-radius: 12px; padding: 16px 22px; text-align: center; min-width: 100px; }
        .stat-chip .sc-num { font-size: 28px; font-weight: 800; color: var(--accent); }
        .stat-chip .sc-label { font-size: 11px; color: var(--muted); margin-top: 3px; }
        .section-title { font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: 1.2px; color: var(--muted); margin-bottom: 16px; }
        .cards-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 16px; margin-bottom: 32px; }
        .dash-card { background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius); padding: 28px; text-decoration: none; color: var(--text); transition: border-color .2s, transform .2s; display: block; cursor: pointer; }
        .dash-card:hover { transform: translateY(-3px); }
        .dash-card.blue:hover   { border-color: var(--accent); }
        .dash-card.green:hover  { border-color: var(--accent2); }
        .dash-card.warn:hover   { border-color: var(--warn); }
        .dash-card.danger:hover { border-color: var(--danger); }
        .dc-icon { width: 44px; height: 44px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 22px; margin-bottom: 14px; }
        .dc-icon.blue   { background: rgba(79,142,247,.15); }
        .dc-icon.green  { background: rgba(56,217,169,.15); }
        .dc-icon.warn   { background: rgba(251,191,36,.15); }
        .dc-icon.danger { background: rgba(247,92,92,.15); }
        .dc-title { font-size: 15px; font-weight: 700; margin-bottom: 8px; }
        .dc-desc  { font-size: 13px; color: var(--muted); line-height: 1.6; margin-bottom: 18px; }
        .dc-btn { display: inline-flex; align-items: center; gap: 6px; font-size: 12px; font-weight: 600; padding: 8px 16px; border-radius: 8px; border: none; cursor: pointer; font-family: inherit; text-decoration: none; transition: all .18s; }
        .dc-btn.blue   { background: rgba(79,142,247,.15); color: var(--accent); }
        .dc-btn.green  { background: rgba(56,217,169,.15); color: var(--accent2); }
        .dc-btn.warn   { background: rgba(251,191,36,.15); color: var(--warn); }
        .dc-btn.danger { background: rgba(247,92,92,.15); color: var(--danger); }
        .dc-btn.blue:hover   { background: var(--accent);  color: #fff; }
        .dc-btn.green:hover  { background: var(--accent2); color: #000; }
        .dc-btn.warn:hover   { background: var(--warn);    color: #000; }
        .dc-btn.danger:hover { background: var(--danger);  color: #fff; }
        .activity-card { background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius); overflow: hidden; }
        .ac-header { padding: 20px 24px; border-bottom: 1px solid var(--border); display: flex; align-items: center; justify-content: space-between; }
        .ac-header h3 { font-size: 15px; font-weight: 700; }
        .ac-empty { padding: 40px; text-align: center; color: var(--muted); font-size: 13px; }
        .ac-empty-icon { font-size: 32px; margin-bottom: 10px; }
        .logout-overlay { display:none; position:fixed; inset:0; z-index:9999; background:rgba(0,0,0,.7); backdrop-filter:blur(6px); align-items:center; justify-content:center; }
        .logout-overlay.show { display:flex; animation:fadeIn .2s ease; }
        @keyframes fadeIn { from{opacity:0} to{opacity:1} }
        .logout-box { background:var(--surface); border:1px solid var(--border); border-radius:16px; width:380px; max-width:calc(100vw - 32px); box-shadow:0 24px 64px rgba(0,0,0,.6); overflow:hidden; animation:popIn .22s cubic-bezier(.34,1.56,.64,1); }
        @keyframes popIn { from{opacity:0;transform:scale(.93) translateY(10px)} to{opacity:1;transform:none} }
        .logout-body { padding:28px 28px 20px; text-align:center; }
        .logout-ico { font-size:40px; margin-bottom:14px; }
        .logout-title { font-size:17px; font-weight:800; margin-bottom:6px; }
        .logout-sub { font-size:13px; color:var(--muted); line-height:1.5; }
        .logout-footer { padding:16px 24px 24px; display:flex; gap:10px; }
        .btn-logout-cancel { flex:1; height:40px; border-radius:10px; background:var(--surface2); border:1px solid var(--border); color:var(--muted); font-size:13px; font-weight:600; font-family:inherit; cursor:pointer; transition:all .15s; }
        .btn-logout-cancel:hover { border-color:var(--text); color:var(--text); }
        .btn-logout-confirm { flex:1; height:40px; border-radius:10px; background:var(--danger); border:none; color:#fff; font-size:13px; font-weight:700; font-family:inherit; cursor:pointer; transition:opacity .15s; }
        .btn-logout-confirm:hover { opacity:.85; }
        .yc-overlay { display:none; position:fixed; inset:0; z-index:9998; background:rgba(0,0,0,.75); backdrop-filter:blur(8px); align-items:center; justify-content:center; padding:16px; }
        .yc-overlay.show { display:flex; animation:fadeIn .2s ease; }
        .yc-box { background:var(--surface); border:1px solid var(--border); border-radius:18px; width:600px; max-width:100%; max-height:90vh; overflow-y:auto; box-shadow:0 32px 80px rgba(0,0,0,.7); animation:popIn .22s cubic-bezier(.34,1.56,.64,1); }
        .yc-box::-webkit-scrollbar { width:5px; }
        .yc-box::-webkit-scrollbar-track { background:transparent; }
        .yc-box::-webkit-scrollbar-thumb { background:var(--border); border-radius:4px; }
        .yc-header { padding:24px 28px 0; display:flex; align-items:flex-start; justify-content:space-between; gap:12px; }
        .yc-header-left { display:flex; align-items:center; gap:14px; }
        .yc-icon-wrap { width:52px; height:52px; border-radius:14px; display:flex; align-items:center; justify-content:center; font-size:24px; flex-shrink:0; }
        .yc-icon-wrap.approved { background:rgba(56,217,169,.15); border:1px solid rgba(56,217,169,.2); }
        .yc-icon-wrap.rejected { background:rgba(247,92,92,.15); border:1px solid rgba(247,92,92,.2); }
        .yc-icon-wrap.pending  { background:rgba(251,191,36,.15); border:1px solid rgba(251,191,36,.2); }
        .yc-htitle { font-size:16px; font-weight:800; margin-bottom:4px; }
        .yc-subtitle { font-size:12px; color:var(--muted); }
        .yc-close { width:32px; height:32px; border-radius:50%; background:var(--surface2); border:1px solid var(--border); cursor:pointer; font-size:14px; color:var(--muted); display:flex; align-items:center; justify-content:center; flex-shrink:0; margin-top:2px; transition:all .15s; font-family:inherit; }
        .yc-close:hover { background:rgba(247,92,92,.1); border-color:var(--danger); color:var(--danger); }
        .yc-body { padding:20px 28px 4px; }
        .yc-status-bar { display:flex; align-items:center; gap:10px; margin-bottom:20px; padding:12px 16px; border-radius:10px; font-size:13px; font-weight:600; }
        .yc-status-bar.approved { background:rgba(56,217,169,.08); border:1px solid rgba(56,217,169,.2); color:var(--accent2); }
        .yc-status-bar.rejected { background:rgba(247,92,92,.08); border:1px solid rgba(247,92,92,.2); color:var(--danger); }
        .yc-status-bar.pending  { background:rgba(251,191,36,.08); border:1px solid rgba(251,191,36,.2); color:var(--warn); }
        .yc-status-icon { font-size:16px; }
        .yc-status-info { flex:1; }
        .yc-status-label { font-size:13px; font-weight:700; }
        .yc-status-meta  { font-size:11px; font-weight:400; opacity:.75; margin-top:1px; }
        .yc-section-lbl { font-size:10px; font-weight:700; text-transform:uppercase; letter-spacing:1px; color:var(--muted); margin-bottom:10px; margin-top:20px; padding-bottom:6px; border-bottom:1px solid var(--border); }
        .yc-field { background:var(--surface2); border:1px solid var(--border); border-radius:10px; padding:12px 14px; }
        .yc-field-label { font-size:10px; color:var(--muted); font-weight:600; text-transform:uppercase; letter-spacing:.8px; margin-bottom:5px; }
        .yc-field-val { font-size:13px; font-weight:600; color:var(--text); line-height:1.4; }
        .yc-change-badge { display:inline-flex; align-items:center; gap:5px; font-size:10px; font-weight:600; padding:2px 8px; border-radius:20px; background:rgba(56,217,169,.1); color:var(--accent2); border:1px solid rgba(56,217,169,.2); margin-top:4px; }
        .yc-note-box { background:var(--surface2); border-radius:10px; padding:14px 16px; font-size:13px; line-height:1.7; color:var(--text); margin-top:6px; border:1px solid var(--border); }
        .yc-note-box.accent  { border-left:3px solid var(--accent); }
        .yc-note-box.accent2 { border-left:3px solid var(--accent2); }
        .yc-note-box.danger  { border-left:3px solid var(--danger); }
        .yc-loading { padding:48px; text-align:center; color:var(--muted); }
        .yc-spinner { width:32px; height:32px; border:3px solid var(--border); border-top-color:var(--accent); border-radius:50%; animation:spin .7s linear infinite; margin:0 auto 14px; }
        @keyframes spin { to { transform:rotate(360deg); } }
        .yc-error { padding:32px 28px; text-align:center; }
        .yc-error-ico { font-size:36px; margin-bottom:12px; }
        .yc-error-msg { font-size:14px; color:var(--muted); }
        .yc-footer { padding:16px 28px 24px; display:flex; gap:10px; justify-content:flex-end; border-top:1px solid var(--border); margin-top:20px; }
        .yc-btn { height:38px; padding:0 20px; border-radius:10px; font-size:13px; font-weight:600; font-family:inherit; cursor:pointer; transition:all .15s; border:none; }
        .yc-btn.secondary { background:var(--surface2); border:1px solid var(--border); color:var(--muted); }
        .yc-btn.secondary:hover { border-color:var(--text); color:var(--text); }
        .yc-btn.primary { background:var(--accent); color:#fff; }
        .yc-btn.primary:hover { opacity:.85; }
        @media (max-width: 600px) {
            .cards-grid { grid-template-columns: 1fr; }
            .hero { flex-direction: column; gap: 20px; }
            .yc-box { border-radius:14px; }
        }
    </style>
</head>
<body>

<%
    List<Map<String, Object>> danhSachTB =
        (List<Map<String, Object>>) request.getAttribute("danhSachThongBao");
    Integer soChuaDoc = (Integer) request.getAttribute("soChuaDoc");
    if (danhSachTB == null) danhSachTB = new java.util.ArrayList<>();
    if (soChuaDoc  == null) soChuaDoc  = 0;
    String ctx = request.getContextPath();
%>

<header class="topbar">
    <a href="<%= ctx %>/hodan/dashboard" class="topbar-logo">
        <div class="logo-icon">🏘</div>
        <div class="logo-text">Cổng <span>Dịch Vụ</span></div>
    </a>
    <div class="topbar-divider"></div>
    <span class="topbar-title">Người dân</span>
    <div class="topbar-spacer"></div>

    <a href="<%= ctx %>/hodan/qr" class="qr-btn" title="QR cá nhân">📲</a>

    <div class="bell-wrap" id="bellWrap">
        <button class="bell-btn" onclick="toggleNotif(event)">
            🔔
            <span class="bell-badge" id="bellCount"
                  style="<%= soChuaDoc == 0 ? "display:none;" : "" %>">
                <%= soChuaDoc > 99 ? "99+" : soChuaDoc %>
            </span>
        </button>
        <div class="notif-panel" id="notifPanel">
            <div class="np-header">
                <h4>Thông báo</h4>
                <% if (soChuaDoc > 0) { %>
                <span class="np-mark" onclick="markAllRead()">Đánh dấu đã đọc</span>
                <% } %>
            </div>
            <div class="np-list" id="notifList">
                <% if (danhSachTB.isEmpty()) { %>
                <div class="np-empty">📭 Chưa có thông báo nào</div>
                <% } else {
                    int _cnt = 0;
                    for (Map<String, Object> tb : danhSachTB) {
                        if (_cnt++ >= 5) break;
                        boolean daDoc   = Boolean.TRUE.equals(tb.get("daDoc"));
                        String tieuDe   = String.valueOf(tb.get("tieuDe"));
                        String noiDungR = tb.get("noiDung") != null ? String.valueOf(tb.get("noiDung")) : "";
                        String preview  = noiDungR.length() > 72 ? noiDungR.substring(0, 72) + "…" : noiDungR;
                        String ngayGui  = String.valueOf(tb.get("ngayGui"));
                        Object tbID     = tb.get("thongBaoID");
                        String tieuDeJs = tieuDe.replace("\\", "\\\\").replace("'", "\\'");
                        Object lichHopID   = tb.get("lichHopID");
                        String lichHopIdJs = (lichHopID != null) ? lichHopID.toString() : "0";
                %>
                <div class="np-item <%= daDoc ? "" : "unread" %>"
                     onclick="docThongBao(<%= tbID %>, this, '<%= tieuDeJs %>', <%= lichHopIdJs %>)">
                    <div class="np-dot <%= daDoc ? "read" : "" %>"></div>
                    <div class="np-body">
                        <p><strong><%= tieuDe %></strong></p>
                        <% if (!preview.isEmpty()) { %>
                        <p style="color:var(--muted);margin-top:2px;"><%= preview %></p>
                        <% } %>
                        <div class="np-time"><%= ngayGui %></div>
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
                <div class="avatar-role">Người dân</div>
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
            <div class="ud-section">Hộ dân & Cá nhân</div>
            <a class="ud-item" href="<%= ctx %>/hodan/ho-dan">
                <span class="ud-icon">🏡</span> Thông tin hộ dân
            </a>
            <a class="ud-item" href="<%= ctx %>/profile">
                <span class="ud-icon">👤</span> Thông tin cá nhân
            </a>
            <div class="ud-section">Tài khoản</div>
            <a class="ud-item" href="<%= ctx %>/admin/change_password">
                <span class="ud-icon">🔑</span> Đổi mật khẩu
            </a>
            <hr class="ud-divider">
            <div class="ud-item danger" onclick="showLogoutModal()">
                <span class="ud-icon">🚪</span> Đăng xuất
            </div>
        </div>
    </div>
</header>

<main class="main">
    <div class="content">
        <div class="hero">
            <div class="hero-left">
                <h1>Xin chào, <span>${currentUser.ten}</span> 👋</h1>
                <p>Chào mừng bạn đến với cổng dịch vụ người dân — Tổ dân phố
                   <strong style="color:var(--accent2)">${not empty tenTo ? tenTo : 'của bạn'}</strong></p>
            </div>
            <div class="hero-right">
                <div class="stat-chip">
                    <div class="sc-num">${soNhanKhau != null ? soNhanKhau : '--'}</div>
                    <div class="sc-label">Nhân khẩu</div>
                </div>
                <div class="stat-chip">
                    <div class="sc-num" style="color:var(--accent2)">${soYeuCau != null ? soYeuCau : '--'}</div>
                    <div class="sc-label">Yêu cầu</div>
                </div>
            </div>
        </div>

        <div class="section-title">Chức năng chính</div>
        <div class="cards-grid">
            <a href="<%= ctx %>/nguoidan/lich-hop" class="dash-card green">
                <div class="dc-icon green">📅</div>
                <div class="dc-title">Lịch họp tổ dân phố</div>
                <div class="dc-desc">Theo dõi lịch họp định kỳ, thông tin cuộc họp sắp tới của tổ.</div>
                <span class="dc-btn green">Xem lịch →</span>
            </a>
            <a href="<%= ctx %>/hodan/phan-anh" class="dash-card danger">
                <div class="dc-icon danger">💬</div>
                <div class="dc-title">Phản ánh / Kiến nghị</div>
                <div class="dc-desc">Gửi phản ánh, kiến nghị đến tổ trưởng hoặc cán bộ phường.</div>
                <span class="dc-btn danger">Gửi phản ánh →</span>
            </a>
            <a href="<%= ctx %>/hodan/thiepmoi" class="dash-card warn">
                <div class="dc-icon warn">💌</div>
                <div class="dc-title">Thiệp mời họp</div>
                <div class="dc-desc">Xem danh sách thiệp mời họp tổ dân phố, thời gian và địa điểm tổ chức.</div>
                <span class="dc-btn warn">Xem thiệp mời →</span>
            </a>
        </div>

        <div class="section-title">Hoạt động gần đây</div>
        <div class="activity-card">
            <div class="ac-header"><h3>Nhật ký hoạt động</h3></div>
            <c:choose>
                <c:when test="${not empty hoatDong}">
                    <c:forEach var="hd" items="${hoatDong}">
                        <div style="padding:14px 24px;border-bottom:1px solid var(--border);display:flex;gap:12px;align-items:center;">
                            <span style="font-size:18px;">${hd.icon}</span>
                            <div>
                                <div style="font-size:13px;font-weight:600;">${hd.tieuDe}</div>
                                <div style="font-size:11px;color:var(--muted);margin-top:2px;">${hd.thoiGian}</div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="ac-empty">
                        <div class="ac-empty-icon">📭</div>
                        <p>Chưa có hoạt động nào gần đây</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</main>

<!-- MODAL ĐĂNG XUẤT -->
<div class="logout-overlay" id="logoutModal" onclick="if(event.target===this)hideLogoutModal()">
    <div class="logout-box">
        <div class="logout-body">
            <div class="logout-ico">🚪</div>
            <div class="logout-title">Đăng xuất?</div>
            <div class="logout-sub">Bạn sẽ được đưa về trang đăng nhập.<br>Mọi phiên làm việc hiện tại sẽ kết thúc.</div>
        </div>
        <div class="logout-footer">
            <button class="btn-logout-cancel" onclick="hideLogoutModal()">Ở lại</button>
            <button class="btn-logout-confirm" onclick="doLogout()">🚪 Đăng xuất</button>
        </div>
    </div>
</div>

<!-- MODAL YÊU CẦU CẬP NHẬT THÔNG TIN -->
<div class="yc-overlay" id="ycModal" onclick="if(event.target===this)hideYcModal()">
    <div class="yc-box" id="ycBox"></div>
</div>

<script>
    const CTX = '<%= ctx %>';

    // ── User menu ──
    function toggleMenu() {
        const dd  = document.getElementById('userDropdown');
        const btn = document.getElementById('avatarBtn');
        document.getElementById('notifPanel').classList.remove('open');
        const open = dd.classList.toggle('open');
        btn.classList.toggle('open', open);
    }

    // ── Notif panel ──
    function toggleNotif(e) {
        e.stopPropagation();
        const panel = document.getElementById('notifPanel');
        document.getElementById('userDropdown').classList.remove('open');
        document.getElementById('avatarBtn').classList.remove('open');
        panel.classList.toggle('open');
    }

    function docThongBao(id, el, tieuDe, lichHopID) {
        const params = new URLSearchParams({ action: 'doc', id: id });
        fetch(CTX + '/thong-bao?' + params, { method: 'POST' })
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
        if (!tieuDe) return;
        const t = tieuDe.toLowerCase();
        if (t.includes('thông báo họp') || t.includes('thiệp') || t.includes('tạm hoãn')
            || t.includes('mở lại') || t.includes('[cập nhật]') || t.includes('[hủy]')) {
            location.href = CTX + '/hodan/thiepmoi';
        } else if (t.includes('lịch họp') && lichHopID && lichHopID > 0) {
            location.href = CTX + '/nguoidan/lich-hop?id=' + lichHopID;
        } else if (t.includes('lịch họp')) {
            location.href = CTX + '/nguoidan/lich-hop';
        } else if (t.includes('yêu cầu') || t.includes('hộ khẩu') || t.includes('cập nhật thông tin')) {
            document.getElementById('notifPanel').classList.remove('open');
            showYcModal();
        } else if (t.includes('phản ánh') || t.includes('kiến nghị')) {
            location.href = CTX + '/hodan/phan-anh';
        } else {
            location.href = CTX + '/thong-bao/lich-su';
        }
    }

    function markAllRead() {
        fetch(CTX + '/thong-bao?action=docTatCa', { method: 'POST' })
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
        let cur = Math.max(0, (parseInt(badge.textContent) || 0) - so);
        if (cur === 0) badge.style.display = 'none';
        else { badge.textContent = cur; badge.style.display = ''; }
    }

    // ── MODAL ĐĂNG XUẤT ──
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
    function doLogout() { window.location.href = CTX + '/logout'; }

    // ── MODAL YÊU CẦU CẬP NHẬT ──
    function showYcModal() {
        const box = document.getElementById('ycBox');
        box.innerHTML = '<div class="yc-loading"><div class="yc-spinner"></div>'
            + '<div style="font-size:13px;font-weight:500;">Đang tải thông tin yêu cầu...</div></div>';
        document.getElementById('ycModal').classList.add('show');
        document.body.style.overflow = 'hidden';

        fetch(CTX + '/hodan/yeu-cau-cap-nhat')
            .then(r => r.json())
            .then(data => {
                const arr  = Array.isArray(data) ? data : [data];
                const item = arr.find(x => x && x.loaiYeuCau == 2) || arr[0];
                if (!item) { renderYcError('Không tìm thấy yêu cầu nào.'); return; }
                renderYcModal(item);
            })
            .catch(() => renderYcError('Không thể tải dữ liệu. Vui lòng thử lại.'));
    }

    function hideYcModal() {
        document.getElementById('ycModal').classList.remove('show');
        document.body.style.overflow = '';
    }

    function renderYcError(msg) {
        document.getElementById('ycBox').innerHTML =
            '<div class="yc-header" style="padding:24px 28px;">'
            + '<div class="yc-header-left"><div class="yc-icon-wrap rejected">⚠️</div>'
            + '<div><div class="yc-htitle">Lỗi tải dữ liệu</div></div></div>'
            + '<button class="yc-close" onclick="hideYcModal()">✕</button></div>'
            + '<div class="yc-error"><div class="yc-error-ico">📭</div>'
            + '<div class="yc-error-msg">' + msg + '</div></div>'
            + '<div class="yc-footer"><button class="yc-btn secondary" onclick="hideYcModal()">Đóng</button></div>';
    }

    function renderYcModal(d) {
        const fmtDate = s => {
            if (!s || s === 'null' || s === 'undefined') return null;
            try {
                return new Date(s).toLocaleString('vi-VN', {
                    day:'2-digit', month:'2-digit', year:'numeric',
                    hour:'2-digit', minute:'2-digit'
                });
            } catch(e) { return s; }
        };
        const ok = v => v && v !== 'null' && v !== 'undefined' && String(v).trim() !== '';
        const stMap = {
            1: { cls:'pending',  icon:'⏳', label:'Đang chờ xử lý',    meta:'Yêu cầu chưa được cán bộ phường xử lý' },
            2: { cls:'approved', icon:'✅', label:'Đã được duyệt',      meta:'Thông tin cá nhân đã được cập nhật thành công' },
            3: { cls:'rejected', icon:'❌', label:'Yêu cầu bị từ chối', meta:'Thông tin không thay đổi — xem lý do từ chối bên dưới' },
            4: { cls:'rejected', icon:'🚫', label:'Đã huỷ',             meta:'Yêu cầu này đã bị huỷ' },
        };
        const st = stMap[d.trangThaiYeuCauID] || stMap[1];
        const fields = [
            { label:'Họ và chữ đệm', cu: d.ho_Cu,       moi: d.ho_Moi },
            { label:'Tên',           cu: d.ten_Cu,       moi: d.ten_Moi },
            { label:'Giới tính',     cu: d.gioiTinh_Cu,  moi: d.gioiTinh_Moi },
            { label:'Email',         cu: d.email_Cu,     moi: d.email_Moi },
            { label:'Số điện thoại', cu: d.sDT_Cu,       moi: d.sDT_Moi },
        ].filter(f => ok(f.cu));
        const anyChange = fields.some(f => ok(f.moi) && f.moi !== f.cu);
        const colTpl = anyChange ? '120px 1fr 1fr' : '120px 1fr';
        const tblHdr = anyChange
            ? '<div style="display:grid;grid-template-columns:' + colTpl + ';gap:8px;padding:8px 0;border-bottom:2px solid var(--border);margin-bottom:2px;"><div style="font-size:10px;font-weight:700;color:var(--muted);text-transform:uppercase;letter-spacing:.8px;">Trường</div><div style="font-size:10px;font-weight:700;color:var(--muted);text-transform:uppercase;letter-spacing:.8px;">Thông tin cũ</div><div style="font-size:10px;font-weight:700;color:var(--accent2);text-transform:uppercase;letter-spacing:.8px;">Thông tin mới ✦</div></div>'
            : '<div style="display:grid;grid-template-columns:' + colTpl + ';gap:8px;padding:8px 0;border-bottom:2px solid var(--border);margin-bottom:2px;"><div style="font-size:10px;font-weight:700;color:var(--muted);text-transform:uppercase;letter-spacing:.8px;">Trường</div><div style="font-size:10px;font-weight:700;color:var(--muted);text-transform:uppercase;letter-spacing:.8px;">Thông tin hiện tại</div></div>';
        const tblRows = fields.map(f => {
            const changed = ok(f.moi) && f.moi !== f.cu;
            const cuCell = '<div style="padding:9px 12px;background:var(--surface);border-radius:8px;font-size:13px;' + (changed ? 'text-decoration:line-through;color:var(--muted);' : 'font-weight:500;color:var(--text);') + '">' + (f.cu || '—') + '</div>';
            const moiCell = anyChange ? '<div style="padding:9px 12px;border-radius:8px;border:1px solid ' + (changed ? 'rgba(56,217,169,.3);background:rgba(56,217,169,.07)' : 'transparent;background:var(--surface)') + ';">' + (changed ? '<div style="font-size:13px;font-weight:700;color:var(--accent2);">' + f.moi + '</div><span class="yc-change-badge">✦ Đã thay đổi</span>' : '<div style="font-size:12px;color:var(--muted);font-style:italic;">Không đổi</div>') + '</div>' : '';
            return '<div style="display:grid;grid-template-columns:' + colTpl + ';gap:8px;padding:5px 0;border-bottom:1px solid rgba(42,48,72,.5);"><div style="font-size:11px;font-weight:600;color:var(--muted);display:flex;align-items:center;padding:0 2px;">' + f.label + '</div>' + cuCell + moiCell + '</div>';
        }).join('');
        const tableHtml = fields.length ? '<div class="yc-section-lbl">Thông tin cá nhân</div><div style="background:var(--surface2);border:1px solid var(--border);border-radius:12px;padding:10px 14px;">' + tblHdr + tblRows + '</div>' : '';
        const metaHtml = '<div class="yc-section-lbl">Thông tin xử lý</div><div style="display:grid;grid-template-columns:1fr 1fr;gap:8px;"><div class="yc-field"><div class="yc-field-label">Người yêu cầu</div><div class="yc-field-val">' + (d.tenNguoiYeuCau || '—') + '</div></div><div class="yc-field"><div class="yc-field-label">Ngày gửi</div><div class="yc-field-val">' + (fmtDate(d.ngayTao) || '—') + '</div></div>' + (ok(d.tenNguoiDuyet) ? '<div class="yc-field"><div class="yc-field-label">Người duyệt</div><div class="yc-field-val">' + d.tenNguoiDuyet + '</div></div>' : '') + (fmtDate(d.ngayDuyet) ? '<div class="yc-field"><div class="yc-field-label">Ngày duyệt</div><div class="yc-field-val">' + fmtDate(d.ngayDuyet) + '</div></div>' : '') + '</div>';
        const noteCls = st.cls === 'approved' ? 'accent2' : st.cls === 'rejected' ? 'danger' : 'accent';
        const lyDo   = ok(d.lyDoYeuCau)  ? d.lyDoYeuCau  : null;
        const ghiChu = ok(d.ghiChuDuyet) ? d.ghiChuDuyet : null;
        const bottomHtml = (lyDo || ghiChu) ? '<div style="display:grid;grid-template-columns:' + (lyDo && ghiChu ? '1fr 1fr' : '1fr') + ';gap:12px;margin-top:4px;">' + (lyDo ? '<div><div class="yc-section-lbl">Lý do yêu cầu</div><div class="yc-note-box accent">' + lyDo + '</div></div>' : '') + (ghiChu ? '<div><div class="yc-section-lbl">Ghi chú duyệt</div><div class="yc-note-box ' + noteCls + '">' + ghiChu + '</div></div>' : '') + '</div>' : '';
        document.getElementById('ycBox').innerHTML =
            '<div class="yc-header"><div class="yc-header-left"><div class="yc-icon-wrap ' + st.cls + '">' + st.icon + '</div><div><div class="yc-htitle">Yêu cầu #' + (d.yeuCauID || '') + '</div><div class="yc-subtitle">Cập nhật thông tin cá nhân</div></div></div><button class="yc-close" onclick="hideYcModal()">✕</button></div>'
            + '<div class="yc-body"><div class="yc-status-bar ' + st.cls + '"><span class="yc-status-icon">' + st.icon + '</span><div class="yc-status-info"><div class="yc-status-label">' + st.label + '</div><div class="yc-status-meta">' + st.meta + '</div></div></div>'
            + metaHtml + tableHtml + bottomHtml + '</div>'
            + '<div class="yc-footer"><button class="yc-btn secondary" onclick="hideYcModal()">Đóng</button><button class="yc-btn primary" onclick="location.href=CTX+\'/profile\'">Xem hồ sơ →</button></div>';
    }

    document.addEventListener('keydown', e => {
        if (e.key === 'Escape') { hideLogoutModal(); hideYcModal(); }
    });

    document.addEventListener('click', function(e) {
        if (!document.getElementById('bellWrap').contains(e.target))
            document.getElementById('notifPanel').classList.remove('open');
        if (!document.querySelector('.user-menu').contains(e.target)) {
            document.getElementById('userDropdown').classList.remove('open');
            document.getElementById('avatarBtn').classList.remove('open');
        }
    });
</script>
</body>
</html>
