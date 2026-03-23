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
        .si-blue{background:rgba(79,142,247,.15);}
        .si-warn{background:rgba(251,191,36,.15);}
        .si-green{background:rgba(56,217,169,.15);}
        .stat-val{font-size:26px;font-weight:800;line-height:1;margin-bottom:2px;}
        .stat-lbl{font-size:11px;color:var(--muted);font-weight:500;}
        .sv-blue{color:var(--accent);}
        .sv-warn{color:var(--warn);}
        .sv-green{color:var(--accent2);}
        .filter-bar{display:flex;align-items:center;gap:10px;background:var(--surface);border:1px solid var(--border);border-radius:var(--radius);padding:14px 18px;margin-bottom:14px;flex-wrap:wrap;}
        .search-wrap{position:relative;flex:1;min-width:200px;}
        .search-wrap svg{position:absolute;left:11px;top:50%;transform:translateY(-50%);color:var(--muted);pointer-events:none;}
        .search-wrap input{width:100%;padding:9px 12px 9px 36px;background:var(--surface2);border:1px solid var(--border);border-radius:8px;color:var(--text);font-size:13.5px;font-family:inherit;}
        .search-wrap input:focus{outline:none;border-color:var(--accent);box-shadow:0 0 0 3px rgba(79,142,247,.15);}
        .search-wrap input::placeholder{color:var(--muted);}
        .sel{background:var(--surface2);border:1px solid var(--border);color:var(--text);padding:9px 12px;border-radius:8px;font-size:13px;font-family:inherit;cursor:pointer;}
        .sel:focus{outline:none;border-color:var(--accent);}
        .sel option{background:var(--surface2);}
        .btn{display:inline-flex;align-items:center;gap:7px;padding:9px 20px;border-radius:8px;font-size:13px;font-weight:600;font-family:inherit;border:none;cursor:pointer;transition:all .18s;text-decoration:none;white-space:nowrap;}
        .btn-primary{background:var(--accent);color:#fff;}
        .btn-primary:hover{background:#3a7de8;}
        .btn-secondary{background:var(--surface2);color:var(--text);border:1px solid var(--border);}
        .btn-secondary:hover{border-color:var(--accent);color:var(--accent);}
        .active-chips{display:flex;gap:8px;flex-wrap:wrap;margin-bottom:12px;align-items:center;}
        .chip-label{font-size:11px;color:var(--muted);font-weight:600;}
        .chip{display:inline-flex;align-items:center;gap:6px;padding:4px 10px;border-radius:20px;font-size:11px;font-weight:600;background:rgba(79,142,247,.12);color:var(--accent);border:1px solid rgba(79,142,247,.25);}
        .chip a{color:inherit;text-decoration:none;opacity:.7;margin-left:2px;}
        .chip a:hover{opacity:1;}
        .table-wrap{background:var(--surface);border:1px solid var(--border);border-radius:var(--radius);overflow:hidden;}
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
        .act-wrap{position:relative;display:inline-block;}
        .act-btn{display:inline-flex;align-items:center;gap:5px;padding:7px 13px;background:var(--surface2);border:1px solid var(--border);border-radius:8px;font-size:12px;font-weight:600;font-family:inherit;color:var(--text);cursor:pointer;transition:all .15s;}
        .act-btn:hover{border-color:var(--accent);color:var(--accent);}
        .act-menu{position:absolute;right:0;top:calc(100% + 6px);background:var(--surface);border:1px solid var(--border);border-radius:10px;padding:5px;min-width:210px;box-shadow:0 16px 48px rgba(0,0,0,.55);z-index:700;display:none;}
        .act-menu.open{display:block;animation:dropIn .15s ease;}
        @keyframes dropIn{from{opacity:0;transform:translateY(-6px)}to{opacity:1;transform:translateY(0)}}
        .act-sep{border:none;border-top:1px solid var(--border);margin:4px 0;}
        .act-item{display:flex;align-items:center;gap:9px;width:100%;padding:9px 12px;border-radius:7px;font-size:12px;font-weight:600;font-family:inherit;background:none;border:none;cursor:pointer;color:var(--text);transition:background .12s;text-align:left;}
        .act-item.g:hover{background:rgba(56,217,169,.12);color:var(--accent2);}
        .act-item.b:hover{background:rgba(79,142,247,.12);color:var(--accent);}
        .table-footer{display:flex;align-items:center;justify-content:space-between;padding:12px 18px;background:var(--surface2);border-top:1px solid var(--border);font-size:12px;color:var(--muted);}
        .table-footer strong{color:var(--text);}
        .empty-state{padding:64px 20px;text-align:center;color:var(--muted);}
        .empty-state .ei{font-size:48px;margin-bottom:14px;}
        .empty-state p{font-size:14px;margin-bottom:18px;}
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
        .btn-ok{background:var(--accent2);color:#000;}
        .btn-ok:hover{opacity:.88;}
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
        @media(max-width:768px){.topbar-nav{display:none;}.content{padding:20px 16px;}.stats-grid{grid-template-columns:1fr;}.filter-bar{flex-wrap:wrap;}}
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
        <a href="${pageContext.request.contextPath}/canbophuong/dashboard"  class="tn-item">🏠 Tổng quan</a>
        <a href="${pageContext.request.contextPath}/canbophuong/phan-anh"   class="tn-item active">💬 Phản ánh</a>
        <a href="${pageContext.request.contextPath}/canbophuong/hodan"      class="tn-item">🏡 Hộ dân</a>
        <a href="${pageContext.request.contextPath}/thong-bao/lich-su"      class="tn-item">🔔 Thông báo</a>
    </nav>
    <div class="topbar-spacer"></div>
    <div class="user-menu">
        <button class="avatar-btn" id="avatarBtn" onclick="toggleMenu()">
            <div class="avatar" id="avatarInitials">CB</div>
            <div>
                <div class="avatar-name">${nguoiDung.ho} ${nguoiDung.ten}</div>
                <div class="avatar-role">Cán bộ phường</div>
            </div>
            <span class="avatar-chevron">▼</span>
        </button>
        <div class="user-dropdown" id="userDropdown">
            <div class="ud-header">
                <div class="avatar" id="avatarInitials2">CB</div>
                <div>
                    <div class="ud-name">${nguoiDung.ho} ${nguoiDung.ten}</div>
                    <div class="ud-email">${nguoiDung.email}</div>
                    <span class="ud-badge">Đang hoạt động</span>
                </div>
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
                <option value="3" ${trangThaiFilter=='3' ? 'selected':''}>⏳ Chờ giải quyết</option>
                <option value="4" ${trangThaiFilter=='4' ? 'selected':''}>✅ Đã giải quyết</option>
            </select>
            <select name="mucDo" class="sel">
                <option value="">Tất cả mức độ</option>
                <option value="3" ${mucDoFilter=='3' ? 'selected':''}>⬆ Cao</option>
                <option value="2" ${mucDoFilter=='2' ? 'selected':''}>➡ Trung bình</option>
                <option value="1" ${mucDoFilter=='1' ? 'selected':''}>⬇ Thấp</option>
            </select>
            <select name="toDanPho" class="sel">
                <option value="">Tất cả tổ</option>
                <c:forEach var="tenTo" items="${danhSachTo}">
                    <option value="${tenTo}" ${toDanPhoFilter == tenTo ? 'selected':''}>${tenTo}</option>
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
                <span class="chip">Trạng thái: ${trangThaiFilter=='3' ? 'Chờ giải quyết' : 'Đã giải quyết'}
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
                    <c:set var="td"    value="${pa.tieuDe}"/>
                    <tr>
                        <td style="color:var(--muted);font-size:12px">${st.index + 1}</td>
                        <td style="max-width:240px">
                            <div style="font-weight:600;font-size:13px;line-height:1.4">${td}</div>
                            <div style="margin-top:4px">
                                <span class="pill blue" style="font-size:10px;padding:2px 8px">${pa.tenLoai}</span>
                            </div>
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
                                <c:when test="${mucDo == 1}"><span class="pill ok">⬇ Thấp</span></c:when>
                                <c:when test="${mucDo == 2}"><span class="pill warn">➡ Trung bình</span></c:when>
                                <c:when test="${mucDo == 3}"><span class="pill err">⬆ Cao</span></c:when>
                                <c:otherwise><span class="pill">${pa.tenMucDo}</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td class="center">
                            <c:choose>
                                <c:when test="${ttID == 3}"><span class="pill purple">⏳ Chờ giải quyết</span></c:when>
                                <c:when test="${ttID == 4}"><span class="pill ok">✅ Đã giải quyết</span></c:when>
                                <c:otherwise><span class="pill">${pa.tenTrangThai}</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td style="color:var(--muted);font-size:12px;white-space:nowrap">${pa.ngayTao}</td>
                        <td class="center">
                            <c:choose>
                            <%-- TT=3: Chờ giải quyết — hiện dropdown Giải quyết + Gửi phản hồi --%>
                            <c:when test="${ttID == 3}">
                                <div class="act-wrap">
                                    <button type="button" class="act-btn" onclick="toggleAct('act-${paID}', event)">
                                        Thao tác ▾
                                    </button>
                                    <div class="act-menu" id="act-${paID}">
                                        <button type="button" class="act-item g"
                                                data-id="${paID}" data-title="${td}"
                                                onclick="openModal('giaiQuyet',this.dataset.id,this.dataset.title)">
                                            ✅ Giải quyết
                                        </button>
                                        <hr class="act-sep">
                                        <button type="button" class="act-item b"
                                                data-id="${paID}" data-title="${td}"
                                                onclick="openModal('phanHoi',this.dataset.id,this.dataset.title)">
                                            💬 Gửi phản hồi
                                        </button>
                                    </div>
                                </div>
                            </c:when>
                            <%-- TT=4: Đã giải quyết — không thao tác gì thêm --%>
                            <c:when test="${ttID == 4}">
                                <span style="font-size:12px;color:var(--muted)">—</span>
                            </c:when>
                            <c:otherwise>
                                <span style="font-size:12px;color:var(--muted)">—</span>
                            </c:otherwise>
                            </c:choose>
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
                <p>${not empty keyword or not empty trangThaiFilter or not empty toDanPhoFilter
                    ? 'Không tìm thấy phản ánh nào phù hợp.'
                    : 'Chưa có phản ánh nào được chuyển cấp lên phường.'}</p>
                <c:if test="${not empty keyword or not empty trangThaiFilter or not empty toDanPhoFilter}">
                    <a href="${pageContext.request.contextPath}/canbophuong/phan-anh" class="btn btn-secondary">← Xem tất cả</a>
                </c:if>
            </div>
        </c:otherwise>
        </c:choose>
    </div>

</div>
</main>

<!-- MODAL GIAI QUYET -->
<div class="modal-overlay" id="m-giaiQuyet" onclick="if(event.target===this)closeModal('giaiQuyet')">
    <div class="modal-box">
        <div class="modal-head">
            <div class="modal-icon">✅</div>
            <div class="modal-title">Giải quyết phản ánh</div>
            <div class="modal-sub" id="sub-giaiQuyet"></div>
        </div>
        <form action="${pageContext.request.contextPath}/canbophuong/phan-anh" method="post">
            <input type="hidden" name="action"    value="giaiQuyet">
            <input type="hidden" name="phanAnhID" id="id-giaiQuyet">
            <input type="hidden" name="keyword"   value="${keyword}">
            <input type="hidden" name="trangThai" value="${trangThaiFilter}">
            <input type="hidden" name="mucDo"     value="${mucDoFilter}">
            <input type="hidden" name="toDanPho"  value="${toDanPhoFilter}">
            <div class="modal-body">
                <label>Kết quả giải quyết <span style="color:var(--danger)">*</span></label>
                <textarea name="ketQua" placeholder="Mô tả kết quả và biện pháp đã thực hiện..." required></textarea>
            </div>
            <div class="modal-foot">
                <button type="button" class="btn btn-secondary" onclick="closeModal('giaiQuyet')">Hủy</button>
                <button type="submit" class="btn btn-ok">✅ Xác nhận giải quyết</button>
            </div>
        </form>
    </div>
</div>

<!-- MODAL GỬI PHẢN HỒI -->
<div class="modal-overlay" id="m-phanHoi" onclick="if(event.target===this)closeModal('phanHoi')">
    <div class="modal-box">
        <div class="modal-head">
            <div class="modal-icon">💬</div>
            <div class="modal-title">Gửi phản hồi đến người dân</div>
            <div class="modal-sub" id="sub-phanHoi"></div>
        </div>
        <form action="${pageContext.request.contextPath}/canbophuong/phan-anh" method="post">
            <input type="hidden" name="action"    value="phanHoi">
            <input type="hidden" name="phanAnhID" id="id-phanHoi">
            <input type="hidden" name="keyword"   value="${keyword}">
            <input type="hidden" name="trangThai" value="${trangThaiFilter}">
            <input type="hidden" name="mucDo"     value="${mucDoFilter}">
            <input type="hidden" name="toDanPho"  value="${toDanPhoFilter}">
            <div class="modal-body">
                <label>Nội dung phản hồi <span style="color:var(--danger)">*</span></label>
                <textarea name="noiDungPhanHoi" placeholder="Nhập nội dung phản hồi đến người dân..." required></textarea>
            </div>
            <div class="modal-foot">
                <button type="button" class="btn btn-secondary" onclick="closeModal('phanHoi')">Hủy</button>
                <button type="submit" class="btn btn-ok">💬 Gửi phản hồi</button>
            </div>
        </form>
    </div>
</div>

<!-- LOGOUT MODAL -->
<div class="logout-overlay" id="logoutModal" onclick="if(event.target===this)hideLogoutModal()">
    <div class="logout-box">
        <div class="logout-body">
            <div class="logout-ico">🚪</div>
            <div class="logout-title">Đăng xuất?</div>
            <div class="logout-sub">Bạn sẽ được đưa về trang đăng nhập.<br>Mọi phiên làm việc hiện tại sẽ kết thúc.</div>
        </div>
        <div class="logout-foot">
            <button class="btn-lc" onclick="hideLogoutModal()">Ở lại</button>
            <button class="btn-lx" onclick="window.location.href='${pageContext.request.contextPath}/logout'">🚪 Đăng xuất</button>
        </div>
    </div>
</div>

<script>
    (function() {
        const ten = '${nguoiDung.ten}' || 'CB';
        const s = ten.trim().split(' ').map(w => w[0]).slice(-2).join('').toUpperCase() || 'CB';
        document.getElementById('avatarInitials').textContent  = s;
        document.getElementById('avatarInitials2').textContent = s;
    })();

    function toggleMenu() {
        const dd = document.getElementById('userDropdown');
        const btn = document.getElementById('avatarBtn');
        const open = dd.classList.toggle('open');
        btn.classList.toggle('open', open);
    }
    document.addEventListener('click', e => {
        if (!document.querySelector('.user-menu').contains(e.target)) {
            document.getElementById('userDropdown').classList.remove('open');
            document.getElementById('avatarBtn').classList.remove('open');
        }
    });

    function toggleAct(id, e) {
        e.stopPropagation();
        const isOpen = document.getElementById(id).classList.contains('open');
        document.querySelectorAll('.act-menu').forEach(m => m.classList.remove('open'));
        if (!isOpen) document.getElementById(id).classList.add('open');
    }
    document.addEventListener('click', () => {
        document.querySelectorAll('.act-menu').forEach(m => m.classList.remove('open'));
    });

    function openModal(type, id, title) {
        document.getElementById('id-'  + type).value       = id;
        document.getElementById('sub-' + type).textContent = title;
        document.getElementById('m-'   + type).classList.add('show');
        document.body.style.overflow = 'hidden';
    }
    function closeModal(type) {
        document.getElementById('m-' + type).classList.remove('show');
        document.body.style.overflow = '';
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
        if (e.key !== 'Escape') return;
        ['giaiQuyet','phanHoi'].forEach(t => closeModal(t));
        hideLogoutModal();
    });
</script>
</body>
</html>
