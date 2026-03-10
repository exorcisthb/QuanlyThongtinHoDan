<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Admin - Quản lý Hộ dân</title>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg:        #0f1117;
            --surface:   #181c27;
            --surface2:  #1f2433;
            --border:    #2a3048;
            --accent:    #4f8ef7;
            --accent2:   #38d9a9;
            --danger:    #f75c5c;
            --warn:      #fbbf24;
            --text:      #e2e8f0;
            --muted:     #64748b;
            --radius:    12px;
        }

        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Be Vietnam Pro', sans-serif;
            background: var(--bg);
            color: var(--text);
            min-height: 100vh;
        }

        /* ── Sidebar ── */
        .layout { display: flex; min-height: 100vh; }

        .sidebar {
            width: 260px;
            background: var(--surface);
            border-right: 1px solid var(--border);
            display: flex;
            flex-direction: column;
            padding: 28px 16px;
            position: fixed;
            top: 0; left: 0; bottom: 0;
            z-index: 100;
        }

        .sidebar-logo {
            display: flex; align-items: center; gap: 10px;
            padding: 0 8px 28px;
            border-bottom: 1px solid var(--border);
            margin-bottom: 24px;
        }
        .logo-icon {
            width: 36px; height: 36px; border-radius: 8px;
            background: linear-gradient(135deg, var(--accent), var(--accent2));
            display: flex; align-items: center; justify-content: center;
            font-size: 18px;
        }
        .logo-text { font-size: 15px; font-weight: 700; letter-spacing: -.3px; }
        .logo-text span { color: var(--accent); }

        /* Sidebar spacer */
        .sidebar-spacer { flex: 1; }

        /* ── User profile bar (bottom of sidebar) ── */
        .user-bar {
            position: relative;
            margin-top: auto;
            padding-top: 16px;
            border-top: 1px solid var(--border);
        }
        .user-bar-btn {
            display: flex; align-items: center; gap: 10px;
            width: 100%; padding: 10px 10px;
            background: none; border: 1px solid transparent;
            border-radius: 10px; cursor: pointer;
            transition: all .18s; color: var(--text);
            font-family: inherit;
        }
        .user-bar-btn:hover {
            background: var(--surface2);
            border-color: var(--border);
        }
        .avatar {
            width: 36px; height: 36px; border-radius: 50%;
            background: linear-gradient(135deg, var(--accent), var(--accent2));
            display: flex; align-items: center; justify-content: center;
            font-size: 14px; font-weight: 700; color: #fff;
            flex-shrink: 0; text-transform: uppercase;
        }
        .user-bar-info { flex: 1; text-align: left; overflow: hidden; }
        .user-bar-name  { font-size: 13px; font-weight: 600; white-space: nowrap;
            overflow: hidden; text-overflow: ellipsis; }
        .user-bar-role  { font-size: 11px; color: var(--muted); }
        .user-bar-chevron { font-size: 16px; color: var(--muted); transition: transform .2s; }
        .user-bar-btn.open .user-bar-chevron { transform: rotate(180deg); }

        /* Popup menu */
        .user-popup {
            position: absolute;
            bottom: calc(100% + 8px);
            left: 0; right: 0;
            background: var(--surface2);
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 6px;
            box-shadow: 0 -8px 32px rgba(0,0,0,.4);
            display: none;
            z-index: 200;
            animation: popUp .18s ease;
        }
        .user-popup.open { display: block; }
        @keyframes popUp {
            from { opacity: 0; transform: translateY(8px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        /* Popup header */
        .popup-header {
            display: flex; align-items: center; gap: 10px;
            padding: 10px 10px 12px;
            border-bottom: 1px solid var(--border);
            margin-bottom: 6px;
        }
        .popup-header .avatar { width: 40px; height: 40px; font-size: 16px; }
        .popup-full-name { font-size: 13px; font-weight: 700; }
        .popup-email     { font-size: 11px; color: var(--muted); }
        .badge {
            display: inline-flex; align-items: center; gap: 5px;
            font-size: 10px; font-weight: 600;
            padding: 2px 7px; border-radius: 20px; margin-top: 4px;
        }
        .badge.active   { background: rgba(56,217,169,.15); color: var(--accent2); }
        .badge.inactive { background: rgba(247,92,92,.15);  color: var(--danger); }
        .badge::before  { content: ''; width: 5px; height: 5px; border-radius: 50%; background: currentColor; }

        /* Popup items */
        .popup-item {
            display: flex; align-items: center; gap: 10px;
            padding: 9px 10px; border-radius: 8px;
            font-size: 13px; font-weight: 500; color: var(--text);
            cursor: pointer; transition: background .15s;
            text-decoration: none;
        }
        .popup-item:hover { background: var(--surface); }
        .popup-item .pi-icon { font-size: 16px; width: 20px; text-align: center; }
        .popup-item.danger   { color: var(--danger); }
        .popup-item.danger:hover { background: rgba(247,92,92,.1); }
        .popup-divider { border: none; border-top: 1px solid var(--border); margin: 6px 0; }

        /* Nav */
        .nav-section { font-size: 10px; font-weight: 700; text-transform: uppercase;
            letter-spacing: 1.2px; color: var(--muted); padding: 0 8px; margin-bottom: 8px; }
        .nav-item {
            display: flex; align-items: center; gap: 10px;
            padding: 10px 12px; border-radius: 8px;
            cursor: pointer; font-size: 14px; font-weight: 500;
            color: var(--muted); transition: all .18s;
            margin-bottom: 2px; user-select: none;
            border: 1px solid transparent;
        }
        .nav-item:hover { background: var(--surface2); color: var(--text); }
        .nav-item.active {
            background: rgba(79,142,247,.12);
            color: var(--accent);
            border-color: rgba(79,142,247,.25);
        }
        .nav-icon { font-size: 18px; width: 22px; text-align: center; }

        /* ── Main ── */
        .main {
            margin-left: 260px;
            flex: 1;
            padding: 36px 40px;
            max-width: calc(100vw - 260px);
        }

        .page-header { margin-bottom: 32px; }
        .page-header h1 { font-size: 24px; font-weight: 700; margin-bottom: 4px; }
        .page-header p  { font-size: 14px; color: var(--muted); }
        .breadcrumb { font-size: 12px; color: var(--muted); margin-bottom: 8px; }
        .breadcrumb span { color: var(--accent); }

        /* ── Tab panels ── */
        .tab-panel { display: none; }
        .tab-panel.active { display: block; animation: fadeUp .25s ease; }

        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(10px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        /* ── Cards ── */
        .card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius);
            padding: 28px;
            margin-bottom: 24px;
        }
        .card-header {
            display: flex; align-items: center; gap: 12px;
            margin-bottom: 24px; padding-bottom: 16px;
            border-bottom: 1px solid var(--border);
        }
        .card-icon {
            width: 40px; height: 40px; border-radius: 10px;
            display: flex; align-items: center; justify-content: center;
            font-size: 20px;
        }
        .card-icon.blue  { background: rgba(79,142,247,.15); }
        .card-icon.green { background: rgba(56,217,169,.15); }
        .card-icon.warn  { background: rgba(251,191,36,.15); }
        .card-icon.red   { background: rgba(247,92,92,.15);  }
        .card-title { font-size: 16px; font-weight: 700; }
        .card-sub   { font-size: 12px; color: var(--muted); margin-top: 2px; }

        /* ── Form elements ── */
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 18px; }
        .form-group { display: flex; flex-direction: column; gap: 6px; }
        .form-group.full { grid-column: 1 / -1; }

        label { font-size: 12px; font-weight: 600; color: var(--muted);
            text-transform: uppercase; letter-spacing: .6px; }

        input[type="text"],
        input[type="email"],
        input[type="password"],
        input[type="date"],
        select {
            background: var(--surface2);
            border: 1px solid var(--border);
            color: var(--text);
            padding: 10px 14px;
            border-radius: 8px;
            font-size: 14px;
            font-family: inherit;
            transition: border-color .18s, box-shadow .18s;
            width: 100%;
        }
        input:focus, select:focus {
            outline: none;
            border-color: var(--accent);
            box-shadow: 0 0 0 3px rgba(79,142,247,.18);
        }
        select option { background: var(--surface2); }

        /* Radio group */
        .radio-group { display: flex; gap: 12px; flex-wrap: wrap; }
        .radio-option {
            display: flex; align-items: center; gap: 8px;
            background: var(--surface2); border: 1px solid var(--border);
            border-radius: 8px; padding: 10px 16px;
            cursor: pointer; font-size: 13px; font-weight: 500;
            transition: all .15s;
        }
        .radio-option input { width: auto; }
        .radio-option:has(input:checked {
            border-color: var(--accent);
            background: rgba(79,142,247,.1);
            color: var(--accent);
        }

        /* Buttons */
        .btn {
            display: inline-flex; align-items: center; gap: 8px;
            padding: 11px 22px; border-radius: 8px;
            font-size: 14px; font-weight: 600; font-family: inherit;
            border: none; cursor: pointer; transition: all .18s;
        }
        .btn-primary   { background: var(--accent); color: #fff; }
        .btn-primary:hover { background: #3a7de8; box-shadow: 0 4px 16px rgba(79,142,247,.35); }
        .btn-secondary { background: var(--surface2); color: var(--text); border: 1px solid var(--border); }
        .btn-secondary:hover { border-color: var(--accent); color: var(--accent); }
        .btn-danger    { background: rgba(247,92,92,.15); color: var(--danger); border: 1px solid rgba(247,92,92,.3); }
        .btn-danger:hover  { background: var(--danger); color: #fff; }
        .btn-warn      { background: rgba(251,191,36,.15); color: var(--warn); border: 1px solid rgba(251,191,36,.3); }
        .btn-warn:hover    { background: var(--warn); color: #000; }
        .btn-green     { background: rgba(56,217,169,.15); color: var(--accent2); border: 1px solid rgba(56,217,169,.3); }
        .btn-green:hover   { background: var(--accent2); color: #000; }

        .form-actions { display: flex; gap: 10px; margin-top: 24px; padding-top: 20px; border-top: 1px solid var(--border); }

        /* ── Alert ── */
        .alert {
            display: flex; align-items: flex-start; gap: 12px;
            padding: 14px 18px; border-radius: 8px;
            font-size: 13px; margin-bottom: 24px;
        }
        .alert.success { background: rgba(56,217,169,.1); border: 1px solid rgba(56,217,169,.25); color: var(--accent2); }
        .alert.error   { background: rgba(247,92,92,.1);  border: 1px solid rgba(247,92,92,.25);  color: var(--danger); }
        .alert-icon { font-size: 16px; }

        /* ── Maintenance cards ── */
        .maintain-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(260px, 1fr)); gap: 16px; }
        .maintain-card {
            background: var(--surface2);
            border: 1px solid var(--border);
            border-radius: var(--radius);
            padding: 22px;
            transition: border-color .18s;
        }
        .maintain-card:hover { border-color: var(--accent); }
        .maintain-card .mc-icon { font-size: 28px; margin-bottom: 12px; }
        .maintain-card h3 { font-size: 14px; font-weight: 700; margin-bottom: 6px; }
        .maintain-card p  { font-size: 12px; color: var(--muted); margin-bottom: 16px; line-height: 1.6; }

        /* ── Status list ── */
        .status-list { display: flex; flex-direction: column; gap: 10px; }
        .status-row {
            display: flex; align-items: center; justify-content: space-between;
            background: var(--surface2); border: 1px solid var(--border);
            border-radius: 8px; padding: 12px 16px;
        }
        .status-row .sr-label { font-size: 13px; font-weight: 500; }
        .status-row .sr-val   { font-size: 13px; color: var(--muted); }
        .pill {
            font-size: 11px; font-weight: 600; padding: 3px 10px;
            border-radius: 20px;
        }
        .pill.ok   { background: rgba(56,217,169,.15); color: var(--accent2); }
        .pill.warn { background: rgba(251,191,36,.15);  color: var(--warn); }
        .pill.err  { background: rgba(247,92,92,.15);   color: var(--danger); }

        /* ── Password strength ── */
        .pw-bar  { height: 4px; border-radius: 2px; background: var(--border); margin-top: 6px; overflow: hidden; }
        .pw-fill { height: 100%; border-radius: 2px; width: 0; transition: width .3s, background .3s; }

        /* Divider */
        .divider { border: none; border-top: 1px solid var(--border); margin: 24px 0; }

        @media (max-width: 768px) {
            .sidebar { transform: translateX(-100%); }
            .main { margin-left: 0; padding: 20px 16px; max-width: 100vw; }
            .form-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
<div class="layout">

    <!-- ═══════════════ SIDEBAR ═══════════════ -->
    <aside class="sidebar">
        <div class="sidebar-logo">
            <div class="logo-icon">🏘</div>
            <div class="logo-text">Quản lý <span>Hộ dân</span></div>
        </div>

        <!-- Navigation -->
        <div class="nav-section">Chức năng</div>

        <div class="nav-item active" onclick="switchTab('tab-create', this)">
            <span class="nav-icon">👤</span>
            Tạo tài khoản Tổ trưởng
        </div>

        <div class="nav-item" onclick="switchTab('tab-maintain', this)">
            <span class="nav-icon">🔧</span>
            Bảo trì &amp; Sửa chữa
        </div>

        <div class="sidebar-spacer"></div>

        <!-- ── User bar (góc dưới, giống ChatGPT) ── -->
        <div class="user-bar">
            <!-- Popup hiện phía trên -->
            <div class="user-popup" id="userPopup">
                <div class="popup-header">
                    <div class="avatar" id="avatarPopup">AD</div>
                    <div>
                        <div class="popup-full-name">${currentAdmin.ho} ${currentAdmin.ten}</div>
                        <div class="popup-email">${currentAdmin.email}</div>
                        <span class="badge ${currentAdmin.isActivated ? 'active' : 'inactive'}">
                            ${currentAdmin.isActivated ? 'Hoạt động' : 'Chưa kích hoạt'}
                        </span>
                    </div>
                </div>

                <a class="popup-item" href="${pageContext.request.contextPath}/admin/profile">
                    <span class="pi-icon">👤</span> Thông tin cá nhân
                </a>
                <a class="popup-item" href="${pageContext.request.contextPath}/admin/change_password">
                    <span class="pi-icon">🔑</span> Đổi mật khẩu
                </a>
                <a class="popup-item" href="${pageContext.request.contextPath}/admin/settings">
                    <span class="pi-icon">⚙️</span> Cài đặt
                </a>

                <hr class="popup-divider">

                <a class="popup-item danger"
                   href="${pageContext.request.contextPath}/"
                   onclick="return confirm('Bạn có chắc muốn đăng xuất?')">
                    <span class="pi-icon">🚪</span> Đăng xuất
                </a>
            </div>

            <!-- Nút trigger -->
            <button class="user-bar-btn" id="userBarBtn" onclick="toggleUserMenu()">
                <div class="avatar" id="avatarBtn">AD</div>
                <div class="user-bar-info">
                    <div class="user-bar-name">${currentAdmin.ho} ${currentAdmin.ten}</div>
                    <div class="user-bar-role">Quản trị viên</div>
                </div>
                <span class="user-bar-chevron">⌃</span>
            </button>
        </div>
    </aside>

    <!-- ═══════════════ MAIN ═══════════════ -->
    <main class="main">

        <c:if test="${not empty message}">
            <div class="alert success">
                <span class="alert-icon">✅</span>
                <span>${message}</span>
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert error">
                <span class="alert-icon">⚠️</span>
                <span>${error}</span>
            </div>
        </c:if>

        <!-- ══════════ TAB 1: Tạo tài khoản ══════════ -->
        <div id="tab-create" class="tab-panel active">
            <div class="page-header">
                <div class="breadcrumb">Dashboard <span>/ Tạo tài khoản</span></div>
                <h1>Tạo tài khoản Tổ trưởng</h1>
                <p>Điền đầy đủ thông tin để tạo tài khoản cho Tổ trưởng mới</p>
            </div>

            <div class="card">
                <div class="card-header">
                    <div class="card-icon blue">📋</div>
                    <div>
                        <div class="card-title">Thông tin cá nhân</div>
                        <div class="card-sub">Thông tin định danh của Tổ trưởng</div>
                    </div>
                </div>

                <form action="${pageContext.request.contextPath}/admin/dashboard" method="post">
                    <input type="hidden" name="action" value="createToTruong">
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="cccd">Số CCCD / CMND *</label>
                            <input type="text" id="cccd" name="cccd" placeholder="VD: 001234567890" maxlength="12" required>
                        </div>
                        <div class="form-group">
                            <label for="ngaySinh">Ngày sinh *</label>
                            <input type="date" id="ngaySinh" name="ngaySinh" required>
                        </div>
                        <div class="form-group">
                            <label for="ho">Họ và chữ đệm *</label>
                            <input type="text" id="ho" name="ho" placeholder="VD: Nguyễn Văn" required>
                        </div>
                        <div class="form-group">
                            <label for="ten">Tên *</label>
                            <input type="text" id="ten" name="ten" placeholder="VD: An" required>
                        </div>
                        <div class="form-group">
                            <label for="email">Email *</label>
                            <input type="email" id="email" name="email" placeholder="example@email.com" required>
                        </div>
                        <div class="form-group">
                            <label for="soDienThoai">Số điện thoại *</label>
                            <input type="text" id="soDienThoai" name="soDienThoai" placeholder="VD: 0901234567" maxlength="11" required>
                        </div>
                        <div class="form-group full">
                            <label>Giới tính *</label>
                            <div class="radio-group">
                                <label class="radio-option"><input type="radio" name="gioiTinh" value="Nam" required> Nam</label>
                                <label class="radio-option"><input type="radio" name="gioiTinh" value="Nu"> Nữ</label>
                                <label class="radio-option"><input type="radio" name="gioiTinh" value="Khac"> Khác</label>
                            </div>
                        </div>
                    </div>

                    <hr class="divider">

                    <div class="card-header" style="border-bottom:none; padding-bottom:0; margin-bottom:16px;">
                        <div class="card-icon green">🔑</div>
                        <div>
                            <div class="card-title">Thông tin đăng nhập</div>
                            <div class="card-sub">Tên đăng nhập và mật khẩu cho tài khoản</div>
                        </div>
                    </div>

                    <div class="form-grid">
                        <div class="form-group">
                            <label for="tenDangNhap">Tên đăng nhập *</label>
                            <input type="text" id="tenDangNhap" name="tenDangNhap" placeholder="VD: toTruong01" required>
                        </div>
                        <div class="form-group">
                            <label for="toSo">Tổ số *</label>
                            <input type="text" id="toSo" name="toSo" placeholder="VD: 01" required>
                        </div>
                        <div class="form-group">
                            <label for="matKhau">Mật khẩu *</label>
                            <input type="password" id="matKhau" name="matKhau"
                                   placeholder="Tối thiểu 8 ký tự"
                                   oninput="checkPw(this.value)" required>
                            <div class="pw-bar"><div class="pw-fill" id="pwFill"></div></div>
                        </div>
                        <div class="form-group">
                            <label for="xacNhanMk">Xác nhận mật khẩu *</label>
                            <input type="password" id="xacNhanMk" name="xacNhanMk" placeholder="Nhập lại mật khẩu" required>
                        </div>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary">✅ Tạo tài khoản</button>
                        <button type="reset"  class="btn btn-secondary">↩ Làm lại</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- ══════════ TAB 2: Bảo trì ══════════ -->
        <div id="tab-maintain" class="tab-panel">
            <div class="page-header">
                <div class="breadcrumb">Dashboard <span>/ Bảo trì &amp; Sửa chữa</span></div>
                <h1>Bảo trì &amp; Sửa chữa hệ thống</h1>
                <p>Quản lý và thực hiện các tác vụ bảo trì hệ thống</p>
            </div>

            <div class="card">
                <div class="card-header">
                    <div class="card-icon green">📊</div>
                    <div>
                        <div class="card-title">Trạng thái hệ thống</div>
                        <div class="card-sub">Tổng quan hiện trạng</div>
                    </div>
                </div>
                <div class="status-list">
                    <div class="status-row">
                        <span class="sr-label">🗄 Cơ sở dữ liệu</span>
                        <span class="pill ok">Bình thường</span>
                    </div>
                    <div class="status-row">
                        <span class="sr-label">💾 Backup gần nhất</span>
                        <span class="sr-val">${empty lastBackup ? 'Chưa có' : lastBackup}</span>
                    </div>
                    <div class="status-row">
                        <span class="sr-label">🖥 Máy chủ</span>
                        <span class="pill ok">Đang hoạt động</span>
                    </div>
                    <div class="status-row">
                        <span class="sr-label">📦 Phiên bản hệ thống</span>
                        <span class="sr-val">${empty appVersion ? '1.0.0' : appVersion}</span>
                    </div>
                </div>
            </div>

            <div class="card">
                <div class="card-header">
                    <div class="card-icon warn">⚙️</div>
                    <div>
                        <div class="card-title">Thực hiện bảo trì</div>
                        <div class="card-sub">Chọn loại tác vụ cần thực hiện</div>
                    </div>
                </div>
                <div class="maintain-grid">
                    <div class="maintain-card">
                        <div class="mc-icon">💾</div>
                        <h3>Backup cơ sở dữ liệu</h3>
                        <p>Sao lưu toàn bộ dữ liệu hiện tại của hệ thống để đảm bảo an toàn.</p>
                        <form action="${pageContext.request.contextPath}/admin/dashboard" method="post">
                            <input type="hidden" name="action" value="maintainSystem">
                            <input type="hidden" name="maintainType" value="backup">
                            <button type="submit" class="btn btn-green" style="width:100%">▶ Thực hiện Backup</button>
                        </form>
                    </div>
                    <div class="maintain-card">
                        <div class="mc-icon">🔧</div>
                        <h3>Sửa chữa hệ thống</h3>
                        <p>Kiểm tra và sửa chữa các lỗi phát sinh trong quá trình vận hành.</p>
                        <form action="${pageContext.request.contextPath}/admin/dashboard" method="post">
                            <input type="hidden" name="action" value="maintainSystem">
                            <input type="hidden" name="maintainType" value="repair">
                            <button type="submit" class="btn btn-warn" style="width:100%">▶ Bắt đầu sửa chữa</button>
                        </form>
                    </div>
                    <div class="maintain-card">
                        <div class="mc-icon">📝</div>
                        <h3>Cập nhật cấu hình</h3>
                        <p>Áp dụng cấu hình mới và cập nhật các tham số hệ thống.</p>
                        <form action="${pageContext.request.contextPath}/admin/dashboard" method="post">
                            <input type="hidden" name="action" value="maintainSystem">
                            <input type="hidden" name="maintainType" value="update">
                            <button type="submit" class="btn btn-primary" style="width:100%">▶ Cập nhật cấu hình</button>
                        </form>
                    </div>
                    <div class="maintain-card">
                        <div class="mc-icon">🗑</div>
                        <h3>Xóa cache hệ thống</h3>
                        <p>Dọn dẹp bộ nhớ tạm để giải phóng tài nguyên và tăng hiệu năng.</p>
                        <form action="${pageContext.request.contextPath}/admin/dashboard" method="post">
                            <input type="hidden" name="action" value="maintainSystem">
                            <input type="hidden" name="maintainType" value="clearCache">
                            <button type="submit" class="btn btn-danger" style="width:100%">▶ Xóa cache</button>
                        </form>
                    </div>
                </div>
            </div>

            <div class="card">
                <div class="card-header">
                    <div class="card-icon red">📋</div>
                    <div>
                        <div class="card-title">Nhật ký bảo trì</div>
                        <div class="card-sub">Lịch sử các tác vụ đã thực hiện</div>
                    </div>
                </div>
                <div class="status-list">
                    <c:choose>
                        <c:when test="${not empty maintenanceLogs}">
                            <c:forEach var="log" items="${maintenanceLogs}">
                                <div class="status-row">
                                    <span class="sr-label">${log.type}</span>
                                    <span class="sr-val">${log.timestamp}</span>
                                    <span class="pill ok">${log.status}</span>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div style="text-align:center; padding:20px; color:var(--muted); font-size:13px;">
                                Chưa có lịch sử bảo trì nào
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

    </main>
</div>

<script>
    // Avatar: lấy 2 chữ đầu tên
    (function() {
        const ten = '${currentAdmin.ten}' || 'AD';
        const initials = ten.trim().substring(0, 2).toUpperCase() || 'AD';
        document.getElementById('avatarBtn').textContent   = initials;
        document.getElementById('avatarPopup').textContent = initials;
    })();

    // Toggle user menu
    function toggleUserMenu() {
        const popup = document.getElementById('userPopup');
        const btn   = document.getElementById('userBarBtn');
        const isOpen = popup.classList.toggle('open');
        btn.classList.toggle('open', isOpen);
    }

    // Đóng khi click ra ngoài
    document.addEventListener('click', function(e) {
        const bar = document.querySelector('.user-bar');
        if (!bar.contains(e.target)) {
            document.getElementById('userPopup').classList.remove('open');
            document.getElementById('userBarBtn').classList.remove('open');
        }
    });

    // Chuyển tab
    function switchTab(tabId, navEl) {
        document.querySelectorAll('.tab-panel').forEach(p => p.classList.remove('active'));
        document.querySelectorAll('.nav-item').forEach(n => n.classList.remove('active'));
        document.getElementById(tabId).classList.add('active');
        navEl.classList.add('active');
    }

    // Độ mạnh mật khẩu
    function checkPw(val) {
        const fill = document.getElementById('pwFill');
        let score = 0;
        if (val.length >= 8)           score++;
        if (/[A-Z]/.test(val))         score++;
        if (/[0-9]/.test(val))         score++;
        if (/[^A-Za-z0-9]/.test(val))  score++;
        const pct   = ['0%','30%','55%','80%','100%'][score];
        const color = ['#f75c5c','#fbbf24','#fbbf24','#4f8ef7','#38d9a9'][score];
        fill.style.width      = pct;
        fill.style.background = color;
    }

    // Xác nhận trước khi bảo trì
    document.querySelectorAll('.maintain-card form').forEach(form => {
        form.addEventListener('submit', function(e) {
            const type = this.querySelector('[name=maintainType]').value;
            const labels = {
                backup:     'Backup cơ sở dữ liệu',
                repair:     'Sửa chữa hệ thống',
                update:     'Cập nhật cấu hình',
                clearCache: 'Xóa cache hệ thống'
            };
            if (!confirm('Xác nhận thực hiện: ' + labels[type] + '?')) {
                e.preventDefault();
            }
        });
    });
</script>
</body>
</html>