<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Phản ánh chuyển cấp - Cán bộ phường</title>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root{--bg:#0f1117;--surface:#181c27;--surface2:#1f2433;--border:#2a3048;--accent:#4f8ef7;--accent2:#38d9a9;--danger:#f75c5c;--warn:#fbbf24;--text:#e2e8f0;--muted:#64748b;--radius:14px;}
        *,*::before,*::after{box-sizing:border-box;margin:0;padding:0;}
        body{font-family:'Be Vietnam Pro',sans-serif;background:var(--bg);color:var(--text);min-height:100vh;}
        .topbar{position:fixed;top:0;left:0;right:0;z-index:200;height:64px;background:rgba(15,17,23,.88);backdrop-filter:blur(16px);border-bottom:1px solid var(--border);display:flex;align-items:center;padding:0 32px;gap:16px;}
        .topbar-logo{display:flex;align-items:center;gap:10px;text-decoration:none;color:var(--text);}
        .logo-icon{width:34px;height:34px;border-radius:8px;background:linear-gradient(135deg,var(--accent),var(--accent2));display:flex;align-items:center;justify-content:center;font-size:16px;}
        .logo-text{font-size:14px;font-weight:700;letter-spacing:-.3px;}
        .logo-text span{color:var(--accent);}
        .topbar-divider{width:1px;height:24px;background:var(--border);}
        .topbar-spacer{flex:1;}
        .topbar-nav{display:flex;gap:4px;}
        .tn-item{display:flex;align-items:center;gap:7px;padding:7px 14px;border-radius:8px;font-size:13px;font-weight:500;color:var(--muted);text-decoration:none;transition:all .15s;border:1px solid transparent;}
        .tn-item:hover{background:var(--surface2);color:var(--text);}
        .tn-item.active{background:rgba(79,142,247,.12);color:var(--accent);border-color:rgba(79,142,247,.25);}
        .user-menu{position:relative;}
        .avatar-btn{display:flex;align-items:center;gap:10px;background:none;border:1px solid transparent;border-radius:40px;padding:5px 14px 5px 5px;cursor:pointer;color:var(--text);font-family:inherit;transition:all .18s;}
        .avatar-btn:hover{background:var(--surface2);border-color:var(--border);}
        .avatar{width:34px;height:34px;border-radius:50%;background:linear-gradient(135deg,var(--accent),var(--accent2));display:flex;align-items:center;justify-content:center;font-size:13px;font-weight:700;color:#fff;flex-shrink:0;}
        .avatar-name{font-size:13px;font-weight:600;line-height:1.2;}
        .avatar-role{font-size:11px;color:var(--accent2);font-weight:500;}
        .avatar-chevron{font-size:11px;color:var(--muted);transition:transform .2s;}
        .avatar-btn.open .avatar-chevron{transform:rotate(180deg);}
        .user-dropdown{position:absolute;top:calc(100% + 10px);right:0;width:260px;background:var(--surface2);border:1px solid var(--border);border-radius:var(--radius);box-shadow:0 16px 48px rgba(0,0,0,.5);display:none;z-index:300;overflow:hidden;}
        .user-dropdown.open{display:block;animation:dropDown .18s ease;}
        @keyframes dropDown{from{opacity:0;transform:translateY(-8px)}to{opacity:1;transform:translateY(0)}}
        .ud-header{padding:16px;border-bottom:1px solid var(--border);display:flex;align-items:center;gap:12px;}
        .ud-header .avatar{width:42px;height:42px;font-size:16px;}
        .ud-name{font-size:13px;font-weight:700;}
        .ud-email{font-size:11px;color:var(--muted);margin-top:2px;}
        .ud-badge{display:inline-flex;align-items:center;gap:4px;font-size:10px;font-weight:600;padding:2px 8px;border-radius:20px;margin-top:5px;background:rgba(56,217,169,.15);color:var(--accent2);}
        .ud-badge::before{content:'';width:5px;height:5px;border-radius:50%;background:currentColor;}
        .ud-section{font-size:9px;font-weight:700;text-transform:uppercase;letter-spacing:1px;color:var(--muted);padding:10px 16px 4px;}
        .ud-item{display:flex;align-items:center;gap:10px;padding:9px 16px;font-size:13px;font-weight:500;color:var(--text);text-decoration:none;transition:background .15s;cursor:pointer;}
        .ud-item:hover{background:var(--surface);}
        .ud-item .ud-icon{font-size:15px;width:20px;text-align:center;}
        .ud-item.danger{color:var(--danger);}
        .ud-item.danger:hover{background:rgba(247,92,92,.1);}
        .ud-divider{border:none;border-top:1px solid var(--border);margin:4px 0;}
        .main{padding-top:64px;}
        .content{max-width:1280px;margin:0 auto;padding:36px 32px;}
        .page-header{margin-bottom:28px;}
        .breadcrumb{font-size:12px;color:var(--muted);margin-bottom:8px;}
        .breadcrumb span{color:var(--accent);}
        .page-header h1{font-size:24px;font-weight:800;margin-bottom:4px;}
        .page-header p{font-size:14px;color:var(--muted);}
        .alert{display:flex;align-items:flex-start;gap:12px;padding:14px 18px;border-radius:10px;font-size:13px;margin-bottom:22px;}
        .alert.success{background:rgba(56,217,169,.1);border:1px solid rgba(56,217,169,.25);color:var(--accent2);}
        .alert.error{background:rgba(247,92,92,.1);border:1px solid rgba(247,92,92,.25);color:var(--danger);}
        .stats-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:14px;margin-bottom:26px;}
        .stat-card{background:var(--surface);border:1px solid var(--border);border-radius:var(--radius);padding:20px;display:flex;align-items:center;gap:14px;transition:border-color .18s;text-decoration:none;color:inherit;}
        .stat-card:hover{border-color:var(--accent);}
        .stat-icon{width:44px;height:44px;border-radius:12px;display:flex;align-items:center;justify-content:center;font-size:20px;flex-shrink:0;}
        .si-blue{background:rgba(79,142,247,.15);}.si-warn{background:rgba(251,191,36,.15);}.si-green{background:rgba(56,217,169,.15);}
        .stat-val{font-size:26px;font-weight:800;line-height:1;margin-bottom:2px;}
        .stat-lbl{font-size:11px;color:var(--muted);font-weight:500;}
        .sv-blue{color:var(--accent);}.sv-warn{color:var(--warn);}.sv-green{color:var(--accent2);}
        .filter-bar{display:flex;align-items:center;gap:10px;background:var(--surface);border:1px solid var(--border);border-radius:var(--radius);padding:14px 18px;margin-bottom:14px;flex-wrap:wrap;}
        .search-wrap{position:relative;flex:1;min-width:200px;}
        .search-wrap svg{position:absolute;left:11px;top:50%;transform:translateY(-50%);color:var(--muted);pointer-events:none;}
        .search-wrap input{width:100%;padding:9px 12px 9px 36px;background:var(--surface2);border:1px solid var(--border);border-radius:8px;color:var(--text);font-size:13.5px;font-family:inherit;}
        .search-wrap input:focus{outline:none;border-color:var(--accent);box-shadow:0 0 0 3px rgba(79,142,247,.15);}
        .search-wrap input::placeholder{color:var(--muted);}
        .sel{background:var(--surface2);border:1px solid var(--border);color:var(--text);padding:9px 12px;border-radius:8px;font-size:13px;font-family:inherit;cursor:pointer;}
        .sel:focus{outline:none;border-color:var(--accent);}
        .btn{display:inline-flex;align-items:center;gap:7px;padding:9px 20px;border-radius:8px;font-size:13px;font-weight:600;font-family:inherit;border:none;cursor:pointer;transition:all .18s;text-decoration:none;white-space:nowrap;}
        .btn-primary{background:var(--accent);color:#fff;}.btn-primary:hover{background:#3a7de8;}
        .btn-secondary{background:var(--surface2);color:var(--text);border:1px solid var(--border);}.btn-secondary:hover{border-color:var(--accent);color:var(--accent);}
        .active-chips{display:flex;gap:8px;flex-wrap:wrap;margin-bottom:12px;align-items:center;}
        .chip-label{font-size:11px;color:var(--muted);font-weight:600;}
        .chip{display:inline-flex;align-items:center;gap:6px;padding:4px 10px;border-radius:20px;font-size:11px;font-weight:600;background:rgba(79,142,247,.12);color:var(--accent);border:1px solid rgba(79,142,247,.25);}
        .chip a{color:inherit;text-decoration:none;opacity:.7;margin-left:2px;}.chip a:hover{opacity:1;}
        .table-wrap{background:var(--surface);border:1px solid var(--border);border-radius:var(--radius);overflow:visible;}
        table{width:100%;border-collapse:collapse;font-size:13px;}
        thead tr{background:var(--surface2);}
        th{padding:12px 16px;text-align:left;color:var(--muted);font-size:11px;font-weight:600;text-transform:uppercase;letter-spacing:.5px;border-bottom:1px solid var(--border);white-space:nowrap;}
        th.center,td.center{text-align:center;}
        tbody tr{border-bottom:1px solid var(--border);transition:background .12s;}
        tbody tr:last-child{border-bottom:none;}
        tbody tr:hover{background:rgba(79,142,247,.04);}
        td{padding:13px 16px;vertical-align:middle;}
        .pill{display:inline-flex;align-items:center;gap:5px;font-size:11px;font-weight:600;padding:4px 10px;border-radius:20px;white-space:nowrap;}
        .pill::before{content:'';width:5px;height:5px;border-radius:50%;background:currentColor;}
        .pill.blue{background:rgba(79,142,247,.12);color:var(--accent);border:1px solid rgba(79,142,247,.25);}
        .pill.ok{background:rgba(56,217,169,.12);color:var(--accent2);border:1px solid rgba(56,217,169,.25);}
        .pill.warn{background:rgba(251,191,36,.12);color:var(--warn);border:1px solid rgba(251,191,36,.25);}
        .pill.err{background:rgba(247,92,92,.12);color:var(--danger);border:1px solid rgba(247,92,92,.25);}
        .pill.purple{background:rgba(167,139,250,.12);color:#a78bfa;border:1px solid rgba(167,139,250,.25);}
        .user-cell{display:flex;align-items:center;gap:9px;}
        .mini-av{width:30px;height:30px;border-radius:50%;background:linear-gradient(135deg,var(--accent),var(--accent2));display:flex;align-items:center;justify-content:center;font-size:11px;font-weight:700;color:#fff;flex-shrink:0;}
        .to-badge{display:inline-flex;align-items:center;gap:5px;background:rgba(56,217,169,.1);color:var(--accent2);border:1px solid rgba(56,217,169,.2);padding:3px 10px;border-radius:20px;font-size:11px;font-weight:600;}
        .act-wrap{display:inline-flex;gap:6px;align-items:center;flex-wrap:wrap;justify-content:center;}
        .act-btn{display:inline-flex;align-items:center;gap:5px;padding:7px 13px;background:var(--surface2);border:1px solid var(--border);border-radius:8px;font-size:12px;font-weight:600;font-family:inherit;color:var(--text);cursor:pointer;transition:all .15s;}
        .act-btn:hover{border-color:var(--accent);color:var(--accent);}
        .act-btn.detail{background:rgba(79,142,247,.08);border-color:rgba(79,142,247,.25);color:var(--accent);}
        .act-btn.detail:hover{background:rgba(79,142,247,.18);}
        .act-menu-wrap{position:relative;display:inline-block;}
        .act-menu{position:fixed;background:var(--surface);border:1px solid var(--border);border-radius:10px;padding:5px;min-width:210px;box-shadow:0 16px 48px rgba(0,0,0,.55);z-index:700;display:none;}
        .act-menu.open{display:block;animation:dropIn .15s ease;}
        @keyframes dropIn{from{opacity:0;transform:translateY(-6px)}to{opacity:1;transform:translateY(0)}}
        .act-sep{border:none;border-top:1px solid var(--border);margin:4px 0;}
        .act-item{display:flex;align-items:center;gap:9px;width:100%;padding:9px 12px;border-radius:7px;font-size:12px;font-weight:600;font-family:inherit;background:none;border:none;cursor:pointer;color:var(--text);transition:background .12s;text-align:left;}
        .act-item.g:hover{background:rgba(56,217,169,.12);color:var(--accent2);}
        .act-item.b:hover{background:rgba(79,142,247,.12);color:var(--accent);}
        .table-footer{display:flex;align-items:center;justify-content:space-between;padding:12px 18px;background:var(--surface2);border-top:1px solid var(--border);border-bottom-left-radius:var(--radius);border-bottom-right-radius:var(--radius);font-size:12px;color:var(--muted);}
        .table-footer strong{color:var(--text);}
        .empty-state{padding:64px 20px;text-align:center;color:var(--muted);}
        .empty-state .ei{font-size:48px;margin-bottom:14px;}
        .empty-state p{font-size:14px;margin-bottom:18px;}

        /* ── MODAL CHUNG ── */
        .modal-overlay{display:none;position:fixed;inset:0;z-index:9000;background:rgba(0,0,0,.72);backdrop-filter:blur(6px);align-items:center;justify-content:center;}
        .modal-overlay.show{display:flex;animation:mfade .2s ease;}
        @keyframes mfade{from{opacity:0}to{opacity:1}}
        .modal-box{background:var(--surface);border:1px solid var(--border);border-radius:16px;width:460px;max-width:calc(100vw - 32px);box-shadow:0 24px 64px rgba(0,0,0,.6);overflow:hidden;animation:mpop .22s cubic-bezier(.34,1.56,.64,1);}
        @keyframes mpop{from{opacity:0;transform:scale(.93) translateY(10px)}to{opacity:1;transform:none}}
        .modal-head{padding:22px 24px 4px;}
        .modal-icon{font-size:32px;margin-bottom:10px;}
        .modal-title{font-size:16px;font-weight:800;margin-bottom:4px;}
        .modal-sub{font-size:12px;color:var(--muted);background:var(--surface2);border:1px solid var(--border);border-radius:8px;padding:8px 12px;margin-top:10px;line-height:1.5;}
        .modal-body{padding:16px 24px;}
        .modal-body label{font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:.6px;color:var(--muted);display:block;margin-bottom:6px;}
        .modal-body textarea{width:100%;background:var(--surface2);border:1px solid var(--border);color:var(--text);padding:10px 12px;border-radius:8px;font-size:13px;font-family:inherit;resize:vertical;min-height:90px;}
        .modal-body textarea:focus{outline:none;border-color:var(--accent);box-shadow:0 0 0 3px rgba(79,142,247,.15);}
        .modal-foot{display:flex;gap:10px;padding:4px 24px 22px;}
        .modal-foot .btn{flex:1;justify-content:center;}
        .btn-ok{background:var(--accent2);color:#000;}.btn-ok:hover{opacity:.88;}

        /* ── MODAL CHI TIẾT ── */
        .modal-detail{width:740px;max-width:calc(100vw - 32px);max-height:90vh;display:flex;flex-direction:column;}
        .detail-scroll{overflow-y:auto;flex:1;}
        .detail-head{padding:24px 28px 16px;border-bottom:1px solid var(--border);}
        .detail-head-top{display:flex;align-items:flex-start;justify-content:space-between;gap:16px;margin-bottom:14px;}
        .detail-title{font-size:18px;font-weight:800;line-height:1.3;flex:1;}
        .detail-close{width:32px;height:32px;border-radius:50%;background:var(--surface2);border:1px solid var(--border);display:flex;align-items:center;justify-content:center;cursor:pointer;font-size:16px;color:var(--muted);flex-shrink:0;transition:all .15s;}
        .detail-close:hover{color:var(--text);border-color:var(--text);}
        .detail-meta{display:flex;flex-wrap:wrap;gap:8px;align-items:center;}
        .detail-body{padding:20px 28px;}
        .detail-section{margin-bottom:20px;}
        .detail-section-title{font-size:10px;font-weight:700;text-transform:uppercase;letter-spacing:1px;color:var(--muted);margin-bottom:10px;padding-bottom:6px;border-bottom:1px solid var(--border);}
        .detail-grid{display:grid;grid-template-columns:1fr 1fr;gap:12px;}
        .detail-field{display:flex;flex-direction:column;gap:4px;}
        .detail-field label{font-size:11px;color:var(--muted);font-weight:600;}
        .detail-field span{font-size:13px;font-weight:500;}
        .detail-noidung{background:var(--surface2);border:1px solid var(--border);border-radius:8px;padding:12px 14px;font-size:13px;line-height:1.7;}
        .detail-lichsu{display:flex;flex-direction:column;}
        .ls-item{display:flex;gap:14px;padding:10px 0;border-bottom:1px solid var(--border);}
        .ls-item:last-child{border-bottom:none;}
        .ls-dot{width:8px;height:8px;border-radius:50%;background:var(--accent);flex-shrink:0;margin-top:5px;}
        .ls-time{font-size:11px;color:var(--muted);white-space:nowrap;min-width:140px;}
        .ls-content{flex:1;}
        .ls-action{font-size:12px;font-weight:700;margin-bottom:2px;}
        .ls-note{font-size:12px;color:var(--muted);}
        .ls-person{font-size:11px;color:var(--accent);margin-top:2px;}
        .detail-actions{padding:16px 28px;border-top:1px solid var(--border);display:flex;flex-wrap:wrap;gap:8px;align-items:center;}
        .detail-actions-label{font-size:10px;font-weight:700;text-transform:uppercase;letter-spacing:.8px;color:var(--muted);width:100%;margin-bottom:2px;}
        .inline-panel{display:none;padding:0 28px 20px;}
        .inline-panel.show{display:block;animation:mfade .15s ease;}
        .inline-panel-inner{background:var(--surface2);border:1px solid var(--border);border-radius:10px;padding:16px;}
        .inline-panel-inner label{font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:.6px;color:var(--muted);display:block;margin-bottom:8px;}
        .inline-panel-inner textarea{width:100%;background:var(--surface);border:1px solid var(--border);color:var(--text);padding:10px 12px;border-radius:8px;font-size:13px;font-family:inherit;resize:vertical;min-height:80px;}
        .inline-panel-inner textarea:focus{outline:none;border-color:var(--accent);}
        .inline-panel-inner .btn-row{display:flex;gap:8px;margin-top:10px;}

        .logout-overlay{display:none;position:fixed;inset:0;z-index:9999;background:rgba(0,0,0,.72);backdrop-filter:blur(6px);align-items:center;justify-content:center;}
        .logout-overlay.show{display:flex;animation:mfade .2s ease;}
        .logout-box{background:var(--surface);border:1px solid var(--border);border-radius:16px;width:380px;max-width:calc(100vw - 32px);box-shadow:0 24px 64px rgba(0,0,0,.6);overflow:hidden;animation:mpop .22s cubic-bezier(.34,1.56,.64,1);}
        .logout-body{padding:28px 28px 20px;text-align:center;}
        .logout-ico{font-size:40px;margin-bottom:14px;}
        .logout-title{font-size:17px;font-weight:800;margin-bottom:6px;}
        .logout-sub{font-size:13px;color:var(--muted);line-height:1.5;}
        .logout-foot{display:flex;gap:10px;padding:0 24px 24px;}
        .btn-lc{flex:1;height:40px;border-radius:10px;background:var(--surface2);border:1px solid var(--border);color:var(--muted);font-size:13px;font-weight:600;font-family:inherit;cursor:pointer;}
        .btn-lc:hover{border-color:var(--text);color:var(--text);}
        .btn-lx{flex:1;height:40px;border-radius:10px;background:var(--danger);border:none;color:#fff;font-size:13px;font-weight:700;font-family:inherit;cursor:pointer;}
        .btn-lx:hover{opacity:.85;}
        @media(max-width:900px){.stats-grid{grid-template-columns:1fr 1fr;}}
        @media(max-width:768px){.topbar-nav{display:none;}.content{padding:20px 16px;}.stats-grid{grid-template-columns:1fr;}.filter-bar{flex-wrap:wrap;}.detail-grid{grid-template-columns:1fr;}}
    </style>
</head>
<body>

<header class="topbar">
    <a href="${pageContext.request.contextPath}/canbophuong/dashboard" class="topbar-logo">
        <div class="logo-icon">🏘</div>
        <div class="logo-text">Quản lý <span>Hộ dân</span></div>
    </a>
    <div class="topbar-divider"></div>
    <nav class="topbar-nav">
        <a href="${pageContext.request.contextPath}/canbophuong/dashboard" class="tn-item">🏠 Tổng quan</a>
        <a href="${pageContext.request.contextPath}/canbophuong/phan-anh"  class="tn-item active">💬 Phản ánh</a>
        <a href="${pageContext.request.contextPath}/canbophuong/hodan"     class="tn-item">🏡 Hộ dân</a>
        <a href="${pageContext.request.contextPath}/thong-bao/lich-su"     class="tn-item">🔔 Thông báo</a>
    </nav>
    <div class="topbar-spacer"></div>
    <div class="user-menu">
        <button class="avatar-btn" id="avatarBtn" onclick="toggleMenu()">
            <div class="avatar" id="avatarInitials">CB</div>
            <div><div class="avatar-name">${nguoiDung.ho} ${nguoiDung.ten}</div><div class="avatar-role">Cán bộ phường</div></div>
            <span class="avatar-chevron">▼</span>
        </button>
        <div class="user-dropdown" id="userDropdown">
            <div class="ud-header">
                <div class="avatar" id="avatarInitials2">CB</div>
                <div><div class="ud-name">${nguoiDung.ho} ${nguoiDung.ten}</div><div class="ud-email">${nguoiDung.email}</div><span class="ud-badge">Đang hoạt động</span></div>
            </div>
            <div class="ud-section">Tài khoản</div>
            <a class="ud-item" href="${pageContext.request.contextPath}/profile"><span class="ud-icon">👤</span> Thông tin cá nhân</a>
            <a class="ud-item" href="${pageContext.request.contextPath}/change_password"><span class="ud-icon">🔑</span> Đổi mật khẩu</a>
            <hr class="ud-divider">
            <div class="ud-item danger" onclick="showLogoutModal()"><span class="ud-icon">🚪</span> Đăng xuất</div>
        </div>
    </div>
</header>

<main class="main">
<div class="content">

    <c:if test="${not empty sessionScope.message}">
        <div class="alert success">✅ &nbsp;${sessionScope.message}</div>
        <c:remove var="message" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.error}">
        <div class="alert error">⚠️ &nbsp;${sessionScope.error}</div>
        <c:remove var="error" scope="session"/>
    </c:if>

    <div class="page-header">
        <div class="breadcrumb">Cán bộ phường <span>/ Phản ánh chuyển cấp</span></div>
        <h1>Danh sách Phản ánh chuyển cấp</h1>
        <p>Tất cả phản ánh từ các tổ dân phố chuyển lên phường để giải quyết</p>
    </div>

    <div class="stats-grid">
        <a href="${pageContext.request.contextPath}/canbophuong/phan-anh" class="stat-card">
            <div class="stat-icon si-blue">📋</div>
            <div><div class="stat-val sv-blue">${tongTat}</div><div class="stat-lbl">Tổng phản ánh</div></div>
        </a>
        <a href="?trangThai=3" class="stat-card">
            <div class="stat-icon si-warn">⏳</div>
            <div><div class="stat-val sv-warn">${soChuaXuLy}</div><div class="stat-lbl">Chờ giải quyết</div></div>
        </a>
        <a href="?trangThai=4" class="stat-card">
            <div class="stat-icon si-green">✅</div>
            <div><div class="stat-val sv-green">${soGiaiQuyet}</div><div class="stat-lbl">Đã giải quyết</div></div>
        </a>
    </div>

    <form action="${pageContext.request.contextPath}/canbophuong/phan-anh" method="get">
        <div class="filter-bar">
            <div class="search-wrap">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
                <input type="text" name="keyword" value="${keyword}" placeholder="Tìm theo tiêu đề, người gửi, tên tổ...">
            </div>
            <select name="trangThai" class="sel">
                <option value="">Tất cả trạng thái</option>
                <option value="3" ${trangThaiFilter=='3'?'selected':''}>⏳ Chờ giải quyết</option>
                <option value="4" ${trangThaiFilter=='4'?'selected':''}>✅ Đã giải quyết</option>
            </select>
            <select name="mucDo" class="sel">
                <option value="">Tất cả mức độ</option>
                <option value="3" ${mucDoFilter=='3'?'selected':''}>⬆ Cao</option>
                <option value="2" ${mucDoFilter=='2'?'selected':''}>➡ Trung bình</option>
                <option value="1" ${mucDoFilter=='1'?'selected':''}>⬇ Thấp</option>
            </select>
            <select name="toDanPho" class="sel">
                <option value="">Tất cả tổ</option>
                <c:forEach var="tenTo" items="${danhSachTo}">
                    <option value="${tenTo}" ${toDanPhoFilter==tenTo?'selected':''}>${tenTo}</option>
                </c:forEach>
            </select>
            <button type="submit" class="btn btn-primary">🔍 Tìm kiếm</button>
            <c:if test="${not empty keyword or not empty trangThaiFilter or not empty mucDoFilter or not empty toDanPhoFilter}">
                <a href="${pageContext.request.contextPath}/canbophuong/phan-anh" class="btn btn-secondary">✕ Xóa lọc</a>
            </c:if>
        </div>
    </form>

    <c:if test="${not empty trangThaiFilter or not empty toDanPhoFilter or not empty mucDoFilter}">
        <div class="active-chips">
            <span class="chip-label">Đang lọc:</span>
            <c:if test="${not empty trangThaiFilter}">
                <span class="chip">Trạng thái: ${trangThaiFilter=='3'?'Chờ giải quyết':'Đã giải quyết'}
                    <a href="?keyword=${keyword}&mucDo=${mucDoFilter}&toDanPho=${toDanPhoFilter}">✕</a></span>
            </c:if>
            <c:if test="${not empty toDanPhoFilter}">
                <span class="chip">Tổ: ${toDanPhoFilter}
                    <a href="?keyword=${keyword}&trangThai=${trangThaiFilter}&mucDo=${mucDoFilter}">✕</a></span>
            </c:if>
            <c:if test="${not empty mucDoFilter}">
                <span class="chip">Mức độ: <c:choose><c:when test="${mucDoFilter=='1'}">Thấp</c:when><c:when test="${mucDoFilter=='2'}">Trung bình</c:when><c:otherwise>Cao</c:otherwise></c:choose>
                    <a href="?keyword=${keyword}&trangThai=${trangThaiFilter}&toDanPho=${toDanPhoFilter}">✕</a></span>
            </c:if>
        </div>
    </c:if>

    <div class="table-wrap">
        <c:choose>
        <c:when test="${not empty danhSachPhanAnh}">
            <table>
                <thead>
                    <tr>
                        <th style="width:42px">#</th>
                        <th>Tiêu đề / Loại</th>
                        <th>Người gửi</th>
                        <th class="center">Tổ dân phố</th>
                        <th class="center">Mức độ</th>
                        <th class="center">Trạng thái</th>
                        <th>Ngày gửi</th>
                        <th class="center">Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                <c:forEach var="pa" items="${danhSachPhanAnh}" varStatus="st">
                    <c:set var="ttID"  value="${pa.trangThaiID}"/>
                    <c:set var="mucDo" value="${pa.mucDoUuTien}"/>
                    <c:set var="paID"  value="${pa.phanAnhID}"/>
                    <tr>
                        <td style="color:var(--muted);font-size:12px">${st.index+1}</td>
                        <td style="max-width:240px">
                            <div style="font-weight:600;font-size:13px;line-height:1.4">${pa.tieuDe}</div>
                            <div style="margin-top:4px"><span class="pill blue" style="font-size:10px;padding:2px 8px">${pa.tenLoai}</span></div>
                        </td>
                        <td>
                            <div class="user-cell">
                                <div class="mini-av">
                                    <c:choose>
                                        <c:when test="${not empty pa.tenNguoiGui}">${pa.tenNguoiGui.substring(pa.tenNguoiGui.length()-1).toUpperCase()}</c:when>
                                        <c:otherwise>?</c:otherwise>
                                    </c:choose>
                                </div>
                                <span style="font-weight:600;font-size:13px">${pa.tenNguoiGui}</span>
                            </div>
                        </td>
                        <td class="center"><span class="to-badge">🏘 ${pa.tenToDanPho}</span></td>
                        <td class="center">
                            <c:choose>
                                <c:when test="${mucDo==1}"><span class="pill ok">⬇ Thấp</span></c:when>
                                <c:when test="${mucDo==2}"><span class="pill warn">➡ Trung bình</span></c:when>
                                <c:when test="${mucDo==3}"><span class="pill err">⬆ Cao</span></c:when>
                                <c:otherwise><span class="pill">${pa.tenMucDo}</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td class="center">
                            <c:choose>
                                <c:when test="${ttID==3}"><span class="pill purple">⏳ Chờ giải quyết</span></c:when>
                                <c:when test="${ttID==4}"><span class="pill ok">✅ Đã giải quyết</span></c:when>
                                <c:otherwise><span class="pill">${pa.tenTrangThai}</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td style="color:var(--muted);font-size:12px;white-space:nowrap">${pa.ngayTao}</td>
                        <td class="center">
                            <div class="act-wrap">
                                <%-- Nút chi tiết — luôn hiển thị --%>
                                <button type="button" class="act-btn detail"
                                        data-id="${paID}"
                                        data-title="${pa.tieuDe}"
                                        data-loai="${pa.tenLoai}"
                                        data-nguoigui="${pa.tenNguoiGui}"
                                        data-ngay="${pa.ngayTao}"
                                        data-ttid="${ttID}"
                                        data-mucdo="${mucDo}"
                                        data-noidung="${pa.noiDung}"
                                        data-tentt="${pa.tenTrangThai}"
                                        data-tento="${pa.tenToDanPho}"
                                        onclick="xemChiTiet(this)">
                                    🔍 Chi tiết
                                </button>
                                <%-- Nút thao tác nhanh bên ngoài (chỉ TT=3) --%>
                                <c:if test="${ttID==3}">
                                    <div class="act-menu-wrap">
                                        <button type="button" class="act-btn" onclick="toggleAct('act-${paID}',event)">Thao tác ▾</button>
                                        <div class="act-menu" id="act-${paID}">
                                            <button type="button" class="act-item g"
                                                    onclick="openModal('giaiQuyet','${paID}','${pa.tieuDe}')">✅ Giải quyết</button>
                                            <hr class="act-sep">
                                            <button type="button" class="act-item b"
                                                    onclick="openModal('phanHoi','${paID}','${pa.tieuDe}')">💬 Gửi phản hồi</button>
                                        </div>
                                    </div>
                                </c:if>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
            <div class="table-footer">
                <span>Hiển thị <strong>${total}</strong> / <strong>${tongTat}</strong> phản ánh
                    <c:if test="${not empty keyword}"> — kết quả cho "<strong style="color:var(--accent)">${keyword}</strong>"</c:if>
                </span>
                <span style="font-size:11px">Từ tất cả tổ dân phố</span>
            </div>
        </c:when>
        <c:otherwise>
            <div class="empty-state">
                <div class="ei">💬</div>
                <p>${not empty keyword or not empty trangThaiFilter or not empty toDanPhoFilter ? 'Không tìm thấy phản ánh nào phù hợp.' : 'Chưa có phản ánh nào được chuyển cấp lên phường.'}</p>
                <c:if test="${not empty keyword or not empty trangThaiFilter or not empty toDanPhoFilter}">
                    <a href="${pageContext.request.contextPath}/canbophuong/phan-anh" class="btn btn-secondary">← Xem tất cả</a>
                </c:if>
            </div>
        </c:otherwise>
        </c:choose>
    </div>
</div>
</main>

<!-- ══ MODAL CHI TIẾT ══════════════════════════════════════════════ -->
<div class="modal-overlay" id="m-chiTiet" onclick="if(event.target===this)closeDetail()">
    <div class="modal-box modal-detail">
        <div class="detail-scroll">
            <div class="detail-head">
                <div class="detail-head-top">
                    <div class="detail-title" id="dt-title">—</div>
                    <button class="detail-close" onclick="closeDetail()">✕</button>
                </div>
                <div class="detail-meta" id="dt-meta"></div>
            </div>
            <div class="detail-body">
                <div class="detail-section">
                    <div class="detail-section-title">Thông tin phản ánh</div>
                    <div class="detail-grid">
                        <div class="detail-field"><label>Người gửi</label><span id="dt-nguoigui">—</span></div>
                        <div class="detail-field"><label>Loại phản ánh</label><span id="dt-loai">—</span></div>
                        <div class="detail-field"><label>Mức độ ưu tiên</label><span id="dt-mucdo">—</span></div>
                        <div class="detail-field"><label>Ngày gửi</label><span id="dt-ngay">—</span></div>
                        <div class="detail-field"><label>Tổ dân phố</label><span id="dt-tento">—</span></div>
                        <div class="detail-field"><label>Trạng thái</label><span id="dt-trangthai">—</span></div>
                    </div>
                </div>
                <div class="detail-section">
                    <div class="detail-section-title">Nội dung phản ánh</div>
                    <div class="detail-noidung" id="dt-noidung">—</div>
                </div>
                <div class="detail-section">
                    <div class="detail-section-title">Lịch sử xử lý</div>
                    <div class="detail-lichsu" id="dt-lichsu">
                        <div style="color:var(--muted);font-size:13px;padding:8px 0">Đang tải...</div>
                    </div>
                </div>
            </div>
            <div class="detail-actions" id="dt-actions"></div>
            <div class="inline-panel" id="inline-panel">
                <div class="inline-panel-inner">
                    <form id="inline-form" action="${pageContext.request.contextPath}/canbophuong/phan-anh" method="post">
                        <input type="hidden" name="action"    id="inline-action">
                        <input type="hidden" name="phanAnhID" id="inline-id">
                        <input type="hidden" name="keyword"   value="${keyword}">
                        <input type="hidden" name="trangThai" value="${trangThaiFilter}">
                        <input type="hidden" name="mucDo"     value="${mucDoFilter}">
                        <input type="hidden" name="toDanPho"  value="${toDanPhoFilter}">
                        <label id="inline-label">Nội dung</label>
                        <textarea id="inline-textarea" name="ketQua" placeholder="" required rows="3"></textarea>
                        <div class="btn-row">
                            <button type="button" class="btn btn-secondary" onclick="closeInlinePanel()">Hủy</button>
                            <button type="submit" id="inline-submit" class="btn btn-ok">Xác nhận</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- ══ MODAL GIẢI QUYẾT ══ -->
<div class="modal-overlay" id="m-giaiQuyet" onclick="if(event.target===this)closeModal('giaiQuyet')">
    <div class="modal-box">
        <div class="modal-head"><div class="modal-icon">✅</div><div class="modal-title">Giải quyết phản ánh</div><div class="modal-sub" id="sub-giaiQuyet"></div></div>
        <form action="${pageContext.request.contextPath}/canbophuong/phan-anh" method="post">
            <input type="hidden" name="action" value="giaiQuyet"><input type="hidden" name="phanAnhID" id="id-giaiQuyet">
            <input type="hidden" name="keyword" value="${keyword}"><input type="hidden" name="trangThai" value="${trangThaiFilter}">
            <input type="hidden" name="mucDo" value="${mucDoFilter}"><input type="hidden" name="toDanPho" value="${toDanPhoFilter}">
            <div class="modal-body"><label>Kết quả giải quyết *</label><textarea name="ketQua" placeholder="Mô tả kết quả và biện pháp đã thực hiện..." required></textarea></div>
            <div class="modal-foot"><button type="button" class="btn btn-secondary" onclick="closeModal('giaiQuyet')">Hủy</button><button type="submit" class="btn btn-ok">✅ Xác nhận giải quyết</button></div>
        </form>
    </div>
</div>

<!-- ══ MODAL PHẢN HỒI ══ -->
<div class="modal-overlay" id="m-phanHoi" onclick="if(event.target===this)closeModal('phanHoi')">
    <div class="modal-box">
        <div class="modal-head"><div class="modal-icon">💬</div><div class="modal-title">Gửi phản hồi đến người dân</div><div class="modal-sub" id="sub-phanHoi"></div></div>
        <form action="${pageContext.request.contextPath}/canbophuong/phan-anh" method="post">
            <input type="hidden" name="action" value="phanHoi"><input type="hidden" name="phanAnhID" id="id-phanHoi">
            <input type="hidden" name="keyword" value="${keyword}"><input type="hidden" name="trangThai" value="${trangThaiFilter}">
            <input type="hidden" name="mucDo" value="${mucDoFilter}"><input type="hidden" name="toDanPho" value="${toDanPhoFilter}">
            <div class="modal-body"><label>Nội dung phản hồi *</label><textarea name="noiDungPhanHoi" placeholder="Nhập nội dung phản hồi đến người dân..." required></textarea></div>
            <div class="modal-foot"><button type="button" class="btn btn-secondary" onclick="closeModal('phanHoi')">Hủy</button><button type="submit" class="btn btn-ok">💬 Gửi phản hồi</button></div>
        </form>
    </div>
</div>

<!-- ══ LOGOUT ══ -->
<div class="logout-overlay" id="logoutModal" onclick="if(event.target===this)hideLogoutModal()">
    <div class="logout-box">
        <div class="logout-body"><div class="logout-ico">🚪</div><div class="logout-title">Đăng xuất?</div><div class="logout-sub">Bạn sẽ được đưa về trang đăng nhập.<br>Mọi phiên làm việc hiện tại sẽ kết thúc.</div></div>
        <div class="logout-foot">
            <button class="btn-lc" onclick="hideLogoutModal()">Ở lại</button>
            <button class="btn-lx" onclick="window.location.href='${pageContext.request.contextPath}/logout'">🚪 Đăng xuất</button>
        </div>
    </div>
</div>

<script>
var CTX = '${pageContext.request.contextPath}';
var KW  = '${keyword}';
var TT_F = '${trangThaiFilter}';
var MD_F = '${mucDoFilter}';
var TO_F = '${toDanPhoFilter}';

(function(){
    var ten = '${nguoiDung.ten}' || 'CB';
    var s = ten.trim().split(' ').map(function(w){return w[0];}).slice(-2).join('').toUpperCase() || 'CB';
    document.getElementById('avatarInitials').textContent  = s;
    document.getElementById('avatarInitials2').textContent = s;
})();

function toggleMenu(){
    var dd=document.getElementById('userDropdown'),btn=document.getElementById('avatarBtn');
    var open=dd.classList.toggle('open');btn.classList.toggle('open',open);
}
document.addEventListener('click',function(e){
    if(!document.querySelector('.user-menu').contains(e.target)){
        document.getElementById('userDropdown').classList.remove('open');
        document.getElementById('avatarBtn').classList.remove('open');
    }
});

function toggleAct(id,e){
    e.stopPropagation();
    var menu=document.getElementById(id),isOpen=menu.classList.contains('open');
    document.querySelectorAll('.act-menu').forEach(function(m){m.classList.remove('open');});
    if(!isOpen){
        var rect=e.currentTarget.getBoundingClientRect();
        menu.style.top=(rect.bottom+6)+'px';
        menu.style.left=Math.max(8,rect.right-210)+'px';
        menu.classList.add('open');
    }
}
document.addEventListener('click',function(){
    document.querySelectorAll('.act-menu').forEach(function(m){m.classList.remove('open');});
});

function openModal(type,id,title){
    document.getElementById('id-'+type).value=id;
    document.getElementById('sub-'+type).textContent=title;
    document.getElementById('m-'+type).classList.add('show');
    document.body.style.overflow='hidden';
}
function closeModal(type){
    document.getElementById('m-'+type).classList.remove('show');
    document.body.style.overflow='';
}

// ── Modal chi tiết ─────────────────────────────────────────────────
var PILL = {
    3:['purple','⏳ Chờ giải quyết'],
    4:['ok','✅ Đã giải quyết']
};
var MUCD = {1:['ok','⬇ Thấp'],2:['warn','➡ Trung bình'],3:['err','⬆ Cao']};
var ACT_LABEL = {
    TIEP_NHAN:'Tiếp nhận',CHINH_SUA:'Chỉnh sửa',HUY:'Hủy',
    GIAI_QUYET:'Giải quyết',TU_CHOI:'Từ chối',SPAM:'Đánh dấu Spam',
    CHUYEN_CAP:'Chuyển cấp',BINH_LUAN:'Phản hồi',THU_HOI:'Thu hồi'
};

function xemChiTiet(btn) {
    var d = btn.dataset;
    var ttID  = parseInt(d.ttid);
    var mucDo = parseInt(d.mucdo);
    closeInlinePanel();

    document.getElementById('dt-title').textContent = d.title;

    var p = PILL[ttID] || ['purple', d.tentt];
    var m = MUCD[mucDo] || ['gray','—'];
    document.getElementById('dt-meta').innerHTML =
        '<span class="pill ' + p[0] + '">' + p[1] + '</span>'
        + '<span class="pill ' + m[0] + '">' + m[1] + '</span>'
        + '<span class="to-badge">🏘 ' + (d.tento||'—') + '</span>';

    document.getElementById('dt-nguoigui').textContent  = d.nguoigui || '—';
    document.getElementById('dt-loai').textContent      = d.loai     || '—';
    document.getElementById('dt-ngay').textContent      = d.ngay     || '—';
    document.getElementById('dt-tento').textContent     = d.tento    || '—';
    document.getElementById('dt-trangthai').innerHTML   = '<span class="pill ' + p[0] + '">' + p[1] + '</span>';
    document.getElementById('dt-mucdo').innerHTML       = '<span class="pill ' + m[0] + '">' + m[1] + '</span>';
    document.getElementById('dt-noidung').textContent   = d.noidung  || '(Không có nội dung)';

    loadLichSu(d.id);
    renderActions(ttID, d.id);

    document.getElementById('m-chiTiet').classList.add('show');
    document.body.style.overflow = 'hidden';
}

function loadLichSu(id) {
    var el = document.getElementById('dt-lichsu');
    el.innerHTML = '<div style="color:var(--muted);font-size:13px;padding:8px 0">Đang tải...</div>';
    fetch(CTX + '/canbophuong/phan-anh?action=lichSu&phanAnhID=' + id)
        .then(function(r){ return r.json(); })
        .then(function(data) {
            if (!data || !data.length) {
                el.innerHTML = '<div style="color:var(--muted);font-size:13px;padding:8px 0">Chưa có lịch sử.</div>';
                return;
            }
            el.innerHTML = data.map(function(ls) {
                return '<div class="ls-item">'
                    + '<div class="ls-dot"></div>'
                    + '<div>'
                    + '<div class="ls-time">' + (ls.thoiGian || '') + '</div>'
                    + '<div class="ls-action">' + (ACT_LABEL[ls.hanhDong] || ls.hanhDong) + '</div>'
                    + (ls.ghiChu ? '<div class="ls-note">' + ls.ghiChu + '</div>' : '')
                    + '<div class="ls-person">👤 ' + (ls.tenNguoiThucHien || '—') + '</div>'
                    + '</div>'
                    + '</div>';
            }).join('');
        })
        .catch(function() {
            el.innerHTML = '<div style="color:var(--muted);font-size:13px;padding:8px 0">Không thể tải lịch sử.</div>';
        });
}

function renderActions(ttID, id) {
    var el = document.getElementById('dt-actions');
    if (ttID == 3) {
        el.innerHTML =
            '<div class="detail-actions-label">Thao tác</div>'
            + '<button class="btn" style="background:rgba(56,217,169,.15);color:var(--accent2);border:1px solid rgba(56,217,169,.3)"'
            + ' onclick="showInlinePanel(\'giaiQuyet\',\'' + id + '\',\'ketQua\',\'Kết quả giải quyết\',\'✅ Xác nhận giải quyết\',\'btn-ok\')">✅ Giải quyết</button>'
            + '<button class="btn" style="background:rgba(79,142,247,.1);color:var(--accent);border:1px solid rgba(79,142,247,.3)"'
            + ' onclick="showInlinePanel(\'phanHoi\',\'' + id + '\',\'noiDungPhanHoi\',\'Nội dung phản hồi\',\'💬 Gửi phản hồi\',\'btn-ok\')">💬 Gửi phản hồi</button>';
    } else {
        el.innerHTML = '<div style="font-size:13px;color:var(--muted);padding:4px 0;width:100%">Phản ánh này không có thao tác khả dụng.</div>';
    }
}

function showInlinePanel(action, id, fieldName, labelText, btnText, btnClass) {
    closeInlinePanel();
    document.getElementById('inline-action').value = action;
    document.getElementById('inline-id').value     = id;
    document.getElementById('inline-label').textContent = labelText + ' *';
    var ta = document.getElementById('inline-textarea');
    ta.name        = fieldName;
    ta.value       = '';
    ta.placeholder = 'Nhập ' + labelText.toLowerCase() + '...';
    var sub = document.getElementById('inline-submit');
    sub.textContent = btnText;
    sub.className   = 'btn ' + btnClass;
    document.getElementById('inline-panel').classList.add('show');
    setTimeout(function(){ ta.focus(); }, 100);
}

function closeInlinePanel() {
    document.getElementById('inline-panel').classList.remove('show');
}

function closeDetail() {
    document.getElementById('m-chiTiet').classList.remove('show');
    document.body.style.overflow = '';
    closeInlinePanel();
}

function showLogoutModal(){
    document.getElementById('userDropdown').classList.remove('open');
    document.getElementById('avatarBtn').classList.remove('open');
    document.getElementById('logoutModal').classList.add('show');
    document.body.style.overflow='hidden';
}
function hideLogoutModal(){
    document.getElementById('logoutModal').classList.remove('show');
    document.body.style.overflow='';
}

document.addEventListener('keydown',function(e){
    if(e.key!=='Escape')return;
    ['giaiQuyet','phanHoi'].forEach(function(t){closeModal(t);});
    closeDetail();
    hideLogoutModal();
});
</script>
</body>
</html>
