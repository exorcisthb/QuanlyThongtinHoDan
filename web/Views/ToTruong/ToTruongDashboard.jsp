<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Tổ Dân Phố</title>
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

        /* ── TOPBAR ── */
        .topbar {
            position: fixed; top: 0; left: 0; right: 0; z-index: 200;
            height: 64px;
            background: rgba(15,17,23,.88);
            backdrop-filter: blur(16px);
            border-bottom: 1px solid var(--border);
            display: flex; align-items: center;
            padding: 0 32px; gap: 16px;
        }
        .topbar-logo { display: flex; align-items: center; gap: 10px; text-decoration: none; color: var(--text); }
        .logo-icon {
            width: 34px; height: 34px; border-radius: 8px;
            background: linear-gradient(135deg, var(--accent), var(--accent2));
            display: flex; align-items: center; justify-content: center; font-size: 16px;
        }
        .logo-text { font-size: 14px; font-weight: 700; letter-spacing: -.3px; }
        .logo-text span { color: var(--accent); }
        .topbar-divider { width: 1px; height: 24px; background: var(--border); }
        .topbar-title { font-size: 13px; font-weight: 600; color: var(--muted); }
        .topbar-spacer { flex: 1; }

        /* ── USER AVATAR MENU ── */
        .user-menu { position: relative; }
        .avatar-btn {
            display: flex; align-items: center; gap: 10px;
            background: none; border: 1px solid transparent;
            border-radius: 40px; padding: 5px 14px 5px 5px;
            cursor: pointer; color: var(--text);
            font-family: inherit; transition: all .18s;
        }
        .avatar-btn:hover { background: var(--surface2); border-color: var(--border); }
        .avatar {
            width: 34px; height: 34px; border-radius: 50%;
            background: linear-gradient(135deg, var(--accent), var(--accent2));
            display: flex; align-items: center; justify-content: center;
            font-size: 13px; font-weight: 700; color: #fff;
            flex-shrink: 0; text-transform: uppercase;
        }
        .avatar-info { text-align: left; }
        .avatar-name { font-size: 13px; font-weight: 600; line-height: 1.2; }
        .avatar-role { font-size: 11px; color: var(--accent2); font-weight: 500; }
        .avatar-chevron { font-size: 11px; color: var(--muted); transition: transform .2s; }
        .avatar-btn.open .avatar-chevron { transform: rotate(180deg); }

        .user-dropdown {
            position: absolute; top: calc(100% + 10px); right: 0;
            width: 250px;
            background: var(--surface2);
            border: 1px solid var(--border);
            border-radius: var(--radius);
            box-shadow: 0 16px 48px rgba(0,0,0,.5);
            display: none; z-index: 300;
            overflow: hidden;
        }
        .user-dropdown.open { display: block; animation: dropDown .18s ease; }
        @keyframes dropDown {
            from { opacity: 0; transform: translateY(-8px); }
            to   { opacity: 1; transform: translateY(0); }
        }
        .ud-header {
            padding: 16px; border-bottom: 1px solid var(--border);
            display: flex; align-items: center; gap: 12px;
        }
        .ud-header .avatar { width: 42px; height: 42px; font-size: 16px; }
        .ud-name  { font-size: 13px; font-weight: 700; }
        .ud-email { font-size: 11px; color: var(--muted); margin-top: 2px; }
        .ud-badge {
            display: inline-flex; align-items: center; gap: 4px;
            font-size: 10px; font-weight: 600;
            padding: 2px 8px; border-radius: 20px; margin-top: 5px;
            background: rgba(56,217,169,.15); color: var(--accent2);
        }
        .ud-badge::before { content:''; width:5px; height:5px; border-radius:50%; background:currentColor; }
        .ud-item {
            display: flex; align-items: center; gap: 10px;
            padding: 10px 16px; font-size: 13px; font-weight: 500;
            color: var(--text); text-decoration: none; transition: background .15s;
        }
        .ud-item:hover { background: var(--surface); }
        .ud-item .ud-icon { font-size: 16px; width: 20px; text-align: center; }
        .ud-item.danger { color: var(--danger); }
        .ud-item.danger:hover { background: rgba(247,92,92,.1); }
        .ud-divider { border: none; border-top: 1px solid var(--border); margin: 4px 0; }

        /* ── MAIN ── */
        .main { padding-top: 64px; }
        .content { max-width: 1200px; margin: 0 auto; padding: 40px 32px; }

        /* ── HERO ── */
        .hero {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius);
            padding: 32px 36px;
            margin-bottom: 28px;
            display: flex; align-items: center; justify-content: space-between;
            position: relative; overflow: hidden;
        }
        .hero::before {
            content: '';
            position: absolute; top: -60px; right: -60px;
            width: 260px; height: 260px;
            background: radial-gradient(circle, rgba(79,142,247,.15) 0%, transparent 70%);
            pointer-events: none;
        }
        .hero::after {
            content: '';
            position: absolute; bottom: -50px; right: 200px;
            width: 180px; height: 180px;
            background: radial-gradient(circle, rgba(56,217,169,.1) 0%, transparent 70%);
            pointer-events: none;
        }
        .hero-left h1 { font-size: 26px; font-weight: 800; margin-bottom: 6px; letter-spacing: -.5px; }
        .hero-left h1 span { color: var(--accent); }
        .hero-left p { font-size: 14px; color: var(--muted); }
        .hero-right { display: flex; gap: 16px; flex-shrink: 0; }
        .stat-chip {
            background: var(--surface2); border: 1px solid var(--border);
            border-radius: 12px; padding: 16px 22px; text-align: center; min-width: 100px;
        }
        .stat-chip .sc-num {
            font-size: 28px; font-weight: 800;
            background: linear-gradient(135deg, var(--accent), var(--accent2));
            -webkit-background-clip: text; -webkit-text-fill-color: transparent;
        }
        .stat-chip .sc-label { font-size: 11px; color: var(--muted); font-weight: 500; margin-top: 3px; }

        /* ── CARDS ── */
        .section-title {
            font-size: 11px; font-weight: 700; text-transform: uppercase;
            letter-spacing: 1.2px; color: var(--muted); margin-bottom: 16px;
        }
        .cards-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
            gap: 16px; margin-bottom: 32px;
        }
        .dash-card {
            background: var(--surface); border: 1px solid var(--border);
            border-radius: var(--radius); padding: 24px;
            text-decoration: none; color: var(--text);
            transition: border-color .2s, transform .2s, box-shadow .2s;
            display: block; cursor: pointer;
        }
        .dash-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 32px rgba(0,0,0,.3);
        }
        .dash-card.blue:hover  { border-color: var(--accent); }
        .dash-card.green:hover { border-color: var(--accent2); }
        .dash-card.warn:hover  { border-color: var(--warn); }
        .dash-card.red:hover   { border-color: var(--danger); }

        .dc-icon {
            width: 44px; height: 44px; border-radius: 12px;
            display: flex; align-items: center; justify-content: center;
            font-size: 22px; margin-bottom: 16px;
        }
        .dc-icon.blue  { background: rgba(79,142,247,.15); }
        .dc-icon.green { background: rgba(56,217,169,.15); }
        .dc-icon.warn  { background: rgba(251,191,36,.15); }
        .dc-icon.red   { background: rgba(247,92,92,.15); }

        .dc-title { font-size: 15px; font-weight: 700; margin-bottom: 8px; }
        .dc-desc  { font-size: 13px; color: var(--muted); line-height: 1.6; margin-bottom: 20px; }
        .dc-btn {
            display: inline-flex; align-items: center; gap: 6px;
            font-size: 13px; font-weight: 600; padding: 8px 16px;
            border-radius: 8px; border: none; cursor: pointer;
            font-family: inherit; text-decoration: none; transition: all .18s;
        }
        .dc-btn.blue  { background: rgba(79,142,247,.15);  color: var(--accent);  }
        .dc-btn.green { background: rgba(56,217,169,.15);  color: var(--accent2); }
        .dc-btn.warn  { background: rgba(251,191,36,.15);  color: var(--warn);    }
        .dc-btn.red   { background: rgba(247,92,92,.15);   color: var(--danger);  }
        .dc-btn.blue:hover  { background: var(--accent);  color: #fff; }
        .dc-btn.green:hover { background: var(--accent2); color: #000; }
        .dc-btn.warn:hover  { background: var(--warn);    color: #000; }
        .dc-btn.red:hover   { background: var(--danger);  color: #fff; }

        /* ── RECENT ACTIVITY ── */
        .activity-card {
            background: var(--surface); border: 1px solid var(--border);
            border-radius: var(--radius); overflow: hidden;
        }
        .ac-header {
            padding: 20px 24px; border-bottom: 1px solid var(--border);
            display: flex; align-items: center; justify-content: space-between;
        }
        .ac-header h3 { font-size: 15px; font-weight: 700; }
        .ac-empty { padding: 40px; text-align: center; color: var(--muted); font-size: 13px; }
        .ac-empty .ac-empty-icon { font-size: 32px; margin-bottom: 10px; }
    </style>
</head>
<body>

<!-- ═══════════ TOPBAR ═══════════ -->
<header class="topbar">
    <a href="#" class="topbar-logo">
        <div class="logo-icon">🏘</div>
        <div class="logo-text">Quản lý <span>Hộ dân</span></div>
    </a>
    <div class="topbar-divider"></div>
    <span class="topbar-title">Tổ dân phố</span>
    <div class="topbar-spacer"></div>

    <!-- Avatar + Dropdown -->
    <div class="user-menu">
        <button class="avatar-btn" id="avatarBtn" onclick="toggleMenu()">
            <div class="avatar" id="avatarInitials">TT</div>
            <div class="avatar-info">
                <div class="avatar-name">${currentUser.ho} ${currentUser.ten}</div>
                <div class="avatar-role">Tổ trưởng</div>
            </div>
            <span class="avatar-chevron">▼</span>
        </button>

        <div class="user-dropdown" id="userDropdown">
            <div class="ud-header">
                <div class="avatar" id="avatarInitials2">TT</div>
                <div>
                    <div class="ud-name">${currentUser.ho} ${currentUser.ten}</div>
                    <div class="ud-email">${currentUser.email}</div>
                    <span class="ud-badge">Đang hoạt động</span>
                </div>
            </div>
            <a class="ud-item" href="${pageContext.request.contextPath}/profile">
                <span class="ud-icon">👤</span> Thông tin cá nhân
            </a>
            <a class="ud-item" href="${pageContext.request.contextPath}/change_password">
                <span class="ud-icon">🔑</span> Đổi mật khẩu
            </a>
            <a class="ud-item" href="#">
                <span class="ud-icon">⚙️</span> Cài đặt
            </a>
            <hr class="ud-divider">
            <a class="ud-item danger" href="${pageContext.request.contextPath}/"
               onclick="return confirm('Bạn có chắc muốn đăng xuất?')">
                <span class="ud-icon">🚪</span> Đăng xuất
            </a>
        </div>
    </div>
</header>

<!-- ═══════════ MAIN ═══════════ -->
<main class="main">
    <div class="content">

        <!-- HERO -->
        <div class="hero">
            <div class="hero-left">
                <h1>Xin chào, <span>${currentUser.ten}</span> 👋</h1>
                <p>Tổ dân phố <strong style="color:var(--accent2)">${not empty tenTo ? tenTo : 'của bạn'}</strong> — Chào mừng quay lại hệ thống quản lý</p>
            </div>
            <div class="hero-right">
                <div class="stat-chip">
                    <div class="sc-num">--</div>
                    <div class="sc-label">Hộ dân</div>
                </div>
                <div class="stat-chip">
                    <div class="sc-num">--</div>
                    <div class="sc-label">Nhân khẩu</div>
                </div>
                <div class="stat-chip">
                    <div class="sc-num">--</div>
                    <div class="sc-label">Thông báo</div>
                </div>
            </div>
        </div>

        <!-- CHỨC NĂNG -->
        <div class="section-title">Chức năng chính</div>
        <div class="cards-grid">
            <a href="${pageContext.request.contextPath}/todan/hodan" class="dash-card blue">
                <div class="dc-icon blue">📋</div>
                <div class="dc-title">Quản lý hộ dân</div>
                <div class="dc-desc">Xem danh sách, thêm, sửa, xóa thông tin hộ khẩu trong tổ dân phố.</div>
                <span class="dc-btn blue">Xem danh sách →</span>
            </a>
            <a href="#" class="dash-card green">
                <div class="dc-icon green">📊</div>
                <div class="dc-title">Thống kê tổ</div>
                <div class="dc-desc">Số hộ, số nhân khẩu, tình trạng tạm trú, tạm vắng trong tổ.</div>
                <span class="dc-btn green">Xem thống kê →</span>
            </a>
            <a href="#" class="dash-card warn">
                <div class="dc-icon warn">📢</div>
                <div class="dc-title">Thông báo</div>
                <div class="dc-desc">Gửi thông báo khẩn cấp, thu phí, lịch họp tổ đến các hộ dân.</div>
                <span class="dc-btn warn">Tạo thông báo →</span>
            </a>
            <a href="#" class="dash-card red">
                <div class="dc-icon red">📝</div>
                <div class="dc-title">Báo cáo</div>
                <div class="dc-desc">Lập báo cáo định kỳ gửi lên cấp trên về tình hình tổ dân phố.</div>
                <span class="dc-btn red">Tạo báo cáo →</span>
            </a>
        </div>

        <!-- HOẠT ĐỘNG GẦN ĐÂY -->
        <div class="section-title">Hoạt động gần đây</div>
        <div class="activity-card">
            <div class="ac-header">
                <h3>Nhật ký hoạt động</h3>
            </div>
            <div class="ac-empty">
                <div class="ac-empty-icon">📭</div>
                <p>Chưa có hoạt động nào gần đây</p>
            </div>
        </div>

    </div>
</main>

<script>
    // Avatar initials
    (function() {
        const ten = '${currentUser.ten}' || 'TT';
        const initials = ten.trim().substring(0, 2).toUpperCase();
        document.getElementById('avatarInitials').textContent  = initials;
        document.getElementById('avatarInitials2').textContent = initials;
    })();

    // Toggle dropdown
    function toggleMenu() {
        const dd  = document.getElementById('userDropdown');
        const btn = document.getElementById('avatarBtn');
        const open = dd.classList.toggle('open');
        btn.classList.toggle('open', open);
    }

    // Đóng khi click ngoài
    document.addEventListener('click', function(e) {
        const menu = document.querySelector('.user-menu');
        if (!menu.contains(e.target)) {
            document.getElementById('userDropdown').classList.remove('open');
            document.getElementById('avatarBtn').classList.remove('open');
        }
    });
</script>
</body>
</html>