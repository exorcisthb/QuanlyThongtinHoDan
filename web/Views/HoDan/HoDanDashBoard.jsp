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
        .avatar { width: 34px; height: 34px; border-radius: 50%; background: linear-gradient(135deg, var(--accent), var(--accent2)); display: flex; align-items: center; justify-content: center; font-size: 13px; font-weight: 700; color: #fff; flex-shrink: 0; }
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

        /* ── MODAL ĐĂNG XUẤT ── */
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

        @media (max-width: 600px) { .cards-grid { grid-template-columns: 1fr; } .hero { flex-direction: column; gap: 20px; } }
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
            <div class="np-footer"
                 onclick="location.href='<%= ctx %>/thong-bao/lich-su'">
                Xem tất cả thông báo
            </div>
        </div>
    </div>

    <div class="user-menu">
        <button class="avatar-btn" id="avatarBtn" onclick="toggleMenu()">
            <div class="avatar" id="avatarInitials">ND</div>
            <div class="avatar-info">
                <div class="avatar-name">${currentUser.ho} ${currentUser.ten}</div>
                <div class="avatar-role">Người dân</div>
            </div>
            <span class="avatar-chevron">▼</span>
        </button>
        <div class="user-dropdown" id="userDropdown">
            <div class="ud-header">
                <div class="avatar" id="avatarInitials2">ND</div>
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
            <a class="ud-item" href="<%= ctx %>/hodan/sua-profile">
                <span class="ud-icon">✏️</span> Thêm quan hệ
            </a>
            <div class="ud-section">Tài khoản</div>
            <a class="ud-item" href="<%= ctx %>/admin/change_password">
                <span class="ud-icon">🔑</span> Đổi mật khẩu
            </a>
            <hr class="ud-divider">
            <%-- ✅ SỬA: gọi modal thay vì href trực tiếp --%>
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

<!-- ✅ MODAL ĐĂNG XUẤT -->
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

<script>
    const CTX = '<%= ctx %>';

    // ── Avatar initials ──
    (function() {
        const ten = '${currentUser.ten}' || 'ND';
        const initials = ten.trim().split(' ').map(w => w[0]).slice(-2).join('').toUpperCase();
        document.getElementById('avatarInitials').textContent  = initials || 'ND';
        document.getElementById('avatarInitials2').textContent = initials || 'ND';
    })();

    // ── User menu ──
    function toggleMenu() {
        const dd  = document.getElementById('userDropdown');
        const btn = document.getElementById('avatarBtn');
        document.getElementById('notifPanel').classList.remove('open');
        const open = dd.classList.toggle('open');
        btn.classList.toggle('open', open);
    }

    // ── Notif ──
    function toggleNotif(e) {
        e.stopPropagation();
        const panel = document.getElementById('notifPanel');
        document.getElementById('userDropdown').classList.remove('open');
        document.getElementById('avatarBtn').classList.remove('open');
        panel.classList.toggle('open');
    }

    // ── Thông báo ──
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
        } else if (t.includes('yêu cầu') || t.includes('hộ khẩu')) {
            location.href = CTX + '/hodan/yeu-cau-cap-nhat';
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

    // ── ✅ MODAL ĐĂNG XUẤT ──
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
    function doLogout() {
        // Gọi servlet logout để invalidate session đúng cách
        window.location.href = CTX + '/logout';
    }

    document.addEventListener('keydown', e => { if (e.key === 'Escape') hideLogoutModal(); });

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
