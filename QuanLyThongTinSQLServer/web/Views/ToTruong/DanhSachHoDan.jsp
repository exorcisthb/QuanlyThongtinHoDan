<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Danh sách hộ dân</title>
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <style>
            :root {
                --bg: #0f1117;
                --surface: #181c27;
                --surface2: #1f2433;
                --border: #2a3048;
                --accent: #4f8ef7;
                --accent2: #38d9a9;
                --danger: #f75c5c;
                --warn: #fbbf24;
                --text: #e2e8f0;
                --muted: #64748b;
                --radius: 12px;
            }
            *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
            body { font-family: 'Be Vietnam Pro', sans-serif; background: var(--bg); color: var(--text); min-height: 100vh; }

            /* ── TOPBAR ── */
            .topbar { position: fixed; top: 0; left: 0; right: 0; z-index: 200; height: 64px; background: rgba(15,17,23,.88); backdrop-filter: blur(16px); border-bottom: 1px solid var(--border); display: flex; align-items: center; padding: 0 32px; gap: 16px; }
            .topbar-logo { display: flex; align-items: center; gap: 10px; text-decoration: none; color: var(--text); }
            .logo-icon { width: 34px; height: 34px; border-radius: 8px; background: linear-gradient(135deg, var(--accent), var(--accent2)); display: flex; align-items: center; justify-content: center; font-size: 16px; }
            .logo-text { font-size: 14px; font-weight: 700; }
            .logo-text span { color: var(--accent); }
            .topbar-divider { width: 1px; height: 24px; background: var(--border); }
            .topbar-title { font-size: 13px; font-weight: 600; color: var(--muted); }
            .topbar-spacer { flex: 1; }
            .back-btn { display: flex; align-items: center; gap: 6px; padding: 7px 14px; border-radius: 8px; background: var(--surface2); border: 1px solid var(--border); color: var(--text); text-decoration: none; font-size: 13px; font-weight: 600; transition: all .18s; }
            .back-btn:hover { border-color: var(--accent); color: var(--accent); }
            .avatar-sm { width: 34px; height: 34px; border-radius: 50%; background: linear-gradient(135deg, var(--accent), var(--accent2)); display: flex; align-items: center; justify-content: center; font-size: 13px; font-weight: 700; color: #fff; text-transform: uppercase; }

            /* ── LAYOUT ── */
            .main { padding-top: 64px; }
            .content { max-width: 1200px; margin: 0 auto; padding: 36px 32px; }
            .page-header { margin-bottom: 28px; }
            .breadcrumb { font-size: 12px; color: var(--muted); margin-bottom: 8px; }
            .breadcrumb a { color: var(--accent); text-decoration: none; }
            .page-header h1 { font-size: 24px; font-weight: 800; letter-spacing: -.4px; }
            .page-header p { font-size: 14px; color: var(--muted); margin-top: 4px; }

            /* ── SEARCH + FILTER ROW ── */
            .search-filter-row { display: flex; gap: 12px; align-items: stretch; margin-bottom: 24px; }
            .search-wrap { background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius); padding: 14px 20px; display: flex; gap: 12px; align-items: center; flex: 1; }
            .search-wrap input[type=text] { flex: 1; background: var(--surface2); border: 1px solid var(--border); color: var(--text); padding: 10px 14px; border-radius: 8px; font-size: 14px; font-family: inherit; transition: border-color .18s; }
            .search-wrap input[type=text]:focus { outline: none; border-color: var(--accent); }
            .btn { display: inline-flex; align-items: center; gap: 6px; padding: 10px 20px; border-radius: 8px; font-size: 14px; font-weight: 600; font-family: inherit; border: none; cursor: pointer; text-decoration: none; transition: all .18s; }
            .btn-primary { background: var(--accent); color: #fff; }
            .btn-primary:hover { background: #3a7de8; }
            .btn-secondary { background: var(--surface2); color: var(--text); border: 1px solid var(--border); }
            .btn-secondary:hover { border-color: var(--accent); color: var(--accent); }

            /* ── SUMMARY ── */
            .summary-row { display: flex; gap: 12px; margin-bottom: 24px; flex-wrap: wrap; }
            .sum-chip { background: var(--surface); border: 1px solid var(--border); border-radius: 10px; padding: 12px 20px; display: flex; align-items: center; gap: 10px; }
            .sum-chip .sc-num { font-size: 22px; font-weight: 800; color: var(--accent); }
            .sum-chip .sc-label { font-size: 12px; color: var(--muted); }

            /* ── ACCORDION ── */
            .accordion { display: flex; flex-direction: column; gap: 12px; }
            .acc-group { background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius); overflow: hidden; }
            .acc-header { display: flex; align-items: center; justify-content: space-between; padding: 16px 20px; cursor: pointer; transition: background .18s; user-select: none; }
            .acc-header:hover { background: var(--surface2); }
            .acc-header.open { background: var(--surface2); border-bottom: 1px solid var(--border); }
            .acc-left { display: flex; align-items: center; gap: 12px; }
            .acc-road-icon { width: 36px; height: 36px; border-radius: 8px; background: rgba(79,142,247,.15); display: flex; align-items: center; justify-content: center; font-size: 16px; }
            .acc-road-name { font-size: 15px; font-weight: 700; }
            .acc-road-sub { font-size: 12px; color: var(--muted); margin-top: 2px; }
            .acc-right { display: flex; align-items: center; gap: 12px; }
            .acc-count { background: rgba(79,142,247,.15); color: var(--accent); font-size: 12px; font-weight: 700; padding: 4px 12px; border-radius: 20px; }
            .acc-chevron { font-size: 13px; color: var(--muted); transition: transform .25s; }
            .acc-header.open .acc-chevron { transform: rotate(180deg); }
            .acc-body { display: none; }
            .acc-body.open { display: block; animation: fadeIn .2s ease; }
            @keyframes fadeIn { from { opacity: 0; transform: translateY(-4px); } to { opacity: 1; transform: translateY(0); } }

            /* ── MAIN TABLE ── */
            .table-wrap { overflow-x: auto; }
            .ho-table { width: 100%; border-collapse: collapse; font-size: 13px; }
            .ho-table thead tr { background: rgba(255,255,255,.02); }
            .ho-table th { padding: 11px 16px; text-align: left; color: var(--muted); font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: .5px; border-bottom: 1px solid var(--border); white-space: nowrap; }
            .ho-table td { padding: 12px 16px; border-bottom: 1px solid rgba(42,48,72,.5); vertical-align: middle; white-space: nowrap; }
            .ho-table tbody tr.main-row:hover { background: var(--surface2); }

            /* ── EXPAND ROW THÀNH VIÊN ── */
            .tv-expand-row td { padding: 0 !important; border-bottom: 1px solid var(--border) !important; }
            .tv-expand-inner { display: none; background: rgba(10,12,20,.5); padding: 14px 20px 16px 56px; }
            .tv-expand-inner.open { display: block; animation: fadeIn .18s ease; }
            .tv-inner-table { width: 100%; border-collapse: collapse; font-size: 12px; }
            .tv-inner-table th { padding: 7px 12px; text-align: left; font-size: 10px; font-weight: 700; text-transform: uppercase; letter-spacing: .6px; color: var(--muted); border-bottom: 1px solid var(--border); white-space: nowrap; }
            .tv-inner-table td { padding: 9px 12px; color: var(--text); border-bottom: 1px solid rgba(42,48,72,.35); white-space: nowrap; }
            .tv-inner-table tbody tr:last-child td { border-bottom: none; }
            .tv-inner-table tbody tr:hover { background: rgba(255,255,255,.02); }

            .qh-badge { display: inline-block; font-size: 10px; font-weight: 700; padding: 2px 8px; border-radius: 10px; background: rgba(79,142,247,.12); color: var(--accent); }
            .qh-badge.chu { background: rgba(56,217,169,.12); color: var(--accent2); }

            /* ── NÚT SỐ THÀNH VIÊN ── */
            .tv-num { display: inline-flex; align-items: center; justify-content: center; min-width: 28px; height: 28px; padding: 0 8px; border-radius: 20px; background: var(--surface2); border: 1px solid var(--border); font-size: 12px; font-weight: 700; color: var(--accent2); cursor: pointer; transition: all .15s; white-space: nowrap; gap: 4px; }
            .tv-num:hover { background: rgba(56,217,169,.15); border-color: var(--accent2); }
            .tv-num.active { background: rgba(56,217,169,.2); border-color: var(--accent2); }

            /* ── NÚT XEM THÀNH VIÊN ── */
            .btn-tv-view { display: inline-flex; align-items: center; gap: 4px; padding: 3px 10px; border-radius: 6px; background: rgba(56,217,169,.1); color: var(--accent2); border: 1px solid rgba(56,217,169,.25); font-size: 11px; font-weight: 700; font-family: inherit; cursor: pointer; transition: all .18s; white-space: nowrap; }
            .btn-tv-view:hover { background: rgba(56,217,169,.22); border-color: var(--accent2); }

            /* ── PILLS ── */
            .pill { font-size: 11px; font-weight: 600; padding: 3px 10px; border-radius: 20px; }
            .pill.thuongtru { background: rgba(56,217,169,.15); color: var(--accent2); }
            .pill.tamtru    { background: rgba(251,191,36,.15);  color: var(--warn); }
            .pill.tamvang   { background: rgba(247,92,92,.15);   color: var(--danger); }
            .pill-active   { background: rgba(56,217,169,.15); color: var(--accent2); font-size: 11px; font-weight: 600; padding: 3px 10px; border-radius: 20px; }
            .pill-inactive { background: rgba(247,92,92,.15);  color: var(--danger);  font-size: 11px; font-weight: 600; padding: 3px 10px; border-radius: 20px; }

            .ho-avatar { width: 30px; height: 30px; border-radius: 50%; background: linear-gradient(135deg, #667eea, #764ba2); display: inline-flex; align-items: center; justify-content: center; font-size: 11px; font-weight: 700; color: #fff; margin-right: 8px; text-transform: uppercase; vertical-align: middle; flex-shrink: 0; }

            /* ── NÚT XEM HỘ ── */
            .btn-view { display: inline-flex; align-items: center; gap: 5px; padding: 5px 13px; border-radius: 7px; background: rgba(79,142,247,.12); color: var(--accent); border: 1px solid rgba(79,142,247,.3); font-size: 12px; font-weight: 700; font-family: inherit; cursor: pointer; transition: all .18s; white-space: nowrap; }
            .btn-view:hover { background: rgba(79,142,247,.25); border-color: var(--accent); }

            /* ── NÚT SỬA TRẠNG THÁI (MỚI) ── */
            .btn-edit-tt { display: inline-flex; align-items: center; gap: 4px; padding: 5px 13px; border-radius: 7px; background: rgba(251,191,36,.1); color: var(--warn); border: 1px solid rgba(251,191,36,.25); font-size: 12px; font-weight: 700; font-family: inherit; cursor: pointer; transition: all .18s; white-space: nowrap; }
            .btn-edit-tt:hover { background: rgba(251,191,36,.22); border-color: var(--warn); }

            /* ── MODAL ── */
            .modal-overlay { display: none; position: fixed; inset: 0; z-index: 999; background: rgba(0,0,0,.65); backdrop-filter: blur(6px); align-items: center; justify-content: center; }
            .modal-overlay.show { display: flex; animation: overlayIn .2s ease; }
            @keyframes overlayIn { from { opacity: 0; } to { opacity: 1; } }
            .modal { background: var(--surface); border: 1px solid var(--border); border-radius: 16px; width: 620px; max-width: calc(100vw - 32px); max-height: 88vh; overflow-y: auto; box-shadow: 0 24px 64px rgba(0,0,0,.6); animation: modalIn .22s cubic-bezier(.34,1.56,.64,1); }
            @keyframes modalIn { from { opacity: 0; transform: scale(.93) translateY(12px); } to { opacity: 1; transform: none; } }
            .modal-header { display: flex; align-items: center; justify-content: space-between; padding: 22px 28px 18px; border-bottom: 1px solid var(--border); position: sticky; top: 0; background: var(--surface); z-index: 1; }
            .modal-header-left { display: flex; align-items: center; gap: 14px; }
            .modal-big-avatar { width: 48px; height: 48px; border-radius: 12px; background: linear-gradient(135deg, #667eea, #764ba2); display: flex; align-items: center; justify-content: center; font-size: 18px; font-weight: 800; color: #fff; text-transform: uppercase; }
            .modal-title { font-size: 17px; font-weight: 800; }
            .modal-subtitle { font-size: 12px; color: var(--muted); margin-top: 2px; }
            .modal-close { width: 34px; height: 34px; border-radius: 8px; border: 1px solid var(--border); background: var(--surface2); color: var(--muted); font-size: 16px; cursor: pointer; display: flex; align-items: center; justify-content: center; transition: all .18s; flex-shrink: 0; }
            .modal-close:hover { border-color: var(--danger); color: var(--danger); }
            .modal-body { padding: 24px 28px; }
            .modal-footer { padding: 16px 28px 24px; display: flex; gap: 10px; justify-content: flex-end; border-top: 1px solid var(--border); }
            .detail-section { margin-bottom: 22px; }
            .detail-section:last-child { margin-bottom: 0; }
            .detail-section-title { font-size: 10px; font-weight: 700; color: var(--muted); text-transform: uppercase; letter-spacing: .8px; margin-bottom: 14px; padding-bottom: 8px; border-bottom: 1px solid var(--border); display: flex; align-items: center; gap: 6px; }
            .detail-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }
            .detail-label { font-size: 11px; color: var(--muted); margin-bottom: 4px; font-weight: 600; }
            .detail-value { font-size: 14px; font-weight: 600; color: var(--text); }
            .detail-value.mono { font-family: monospace; color: var(--accent); }
            .detail-value.muted { color: var(--muted); font-weight: 400; }

            /* ── FILTER ── */
            .filter-wrap { position: relative; display: flex; align-items: stretch; }
            .btn-filter { background: var(--surface); color: var(--text); border: 1px solid var(--border); display: inline-flex; align-items: center; gap: 8px; padding: 14px 20px; border-radius: var(--radius); font-size: 14px; font-weight: 600; font-family: inherit; cursor: pointer; white-space: nowrap; transition: all .18s; height: 100%; }
            .btn-filter:hover, .btn-filter.active { border-color: var(--accent); color: var(--accent); }
            .filter-badge { background: var(--accent); color: #fff; font-size: 11px; font-weight: 700; padding: 2px 7px; border-radius: 20px; margin-left: 2px; display: none; }
            .filter-badge.show { display: inline-block; }
            .filter-dropdown { display: none; position: absolute; top: calc(100% + 8px); right: 0; width: 340px; background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius); box-shadow: 0 12px 32px rgba(0,0,0,.4); z-index: 300; padding: 20px; }
            .filter-dropdown.open { display: block; animation: fadeIn .18s ease; }
            .filter-section { margin-bottom: 16px; }
            .filter-section:last-child { margin-bottom: 0; }
            .filter-label { font-size: 11px; font-weight: 700; color: var(--muted); text-transform: uppercase; letter-spacing: .5px; margin-bottom: 8px; }
            .filter-row { display: flex; gap: 8px; }
            .filter-input { flex: 1; background: var(--surface2); border: 1px solid var(--border); color: var(--text); padding: 8px 12px; border-radius: 8px; font-size: 13px; font-family: inherit; transition: border-color .18s; }
            .filter-input:focus { outline: none; border-color: var(--accent); }
            .filter-select { width: 100%; background: var(--surface2); border: 1px solid var(--border); color: var(--text); padding: 8px 12px; border-radius: 8px; font-size: 13px; font-family: inherit; cursor: pointer; transition: border-color .18s; appearance: none; }
            .filter-select:focus { outline: none; border-color: var(--accent); }
            .filter-actions { display: flex; gap: 8px; margin-top: 16px; padding-top: 16px; border-top: 1px solid var(--border); }
            .btn-sm { padding: 8px 16px; font-size: 13px; }

            /* ── FORM (modal sửa trạng thái) ── */
            .form-group { margin-bottom: 16px; }
            .form-label { font-size: 11px; font-weight: 700; color: var(--muted); text-transform: uppercase; letter-spacing: .5px; margin-bottom: 8px; display: block; }
            .form-select { width: 100%; background: var(--surface2); border: 1px solid var(--border); color: var(--text); padding: 10px 14px; border-radius: 8px; font-size: 14px; font-family: inherit; appearance: none; cursor: pointer; transition: border-color .18s; }
            .form-select:focus { outline: none; border-color: var(--accent); }
            .form-textarea { width: 100%; background: var(--surface2); border: 1px solid var(--border); color: var(--text); padding: 10px 14px; border-radius: 8px; font-size: 14px; font-family: inherit; resize: vertical; min-height: 90px; transition: border-color .18s; }
            .form-textarea:focus { outline: none; border-color: var(--accent); }

            /* ── CHẾ ĐỘ CÁ NHÂN: badge mode ── */
            .mode-badge { display: inline-flex; align-items: center; gap: 6px; background: rgba(251,191,36,.12); color: var(--warn); border: 1px solid rgba(251,191,36,.3); font-size: 12px; font-weight: 700; padding: 6px 14px; border-radius: 20px; margin-bottom: 16px; }

            /* ── TOAST ── */
            .toast { position: fixed; bottom: 28px; right: 28px; z-index: 9999; padding: 14px 22px; border-radius: 10px; font-size: 14px; font-weight: 600; display: none; align-items: center; gap: 10px; box-shadow: 0 8px 32px rgba(0,0,0,.4); }
            .toast.show { display: flex; animation: slideUp .25s ease; }
            .toast.success { background: rgba(56,217,169,.15); border: 1px solid rgba(56,217,169,.4); color: var(--accent2); }
            .toast.error   { background: rgba(247,92,92,.15);  border: 1px solid rgba(247,92,92,.4);  color: var(--danger); }
            @keyframes slideUp { from { opacity: 0; transform: translateY(16px); } to { opacity: 1; transform: translateY(0); } }

            .empty-state { text-align: center; padding: 48px; color: var(--muted); }
            .empty-state .es-icon { font-size: 40px; margin-bottom: 12px; }
        </style>
    </head>
    <body>

        <header class="topbar">
            <a href="${pageContext.request.contextPath}/totruong/dashboard" class="topbar-logo">
                <div class="logo-icon">🏘</div>
                <div class="logo-text">Quản lý <span>Hộ dân</span></div>
            </a>
            <div class="topbar-divider"></div>
            <span class="topbar-title">Danh sách hộ dân</span>
            <div class="topbar-spacer"></div>
            <a href="${pageContext.request.contextPath}/totruong/dashboard" class="back-btn">← Dashboard</a>
            <div class="avatar-sm" id="avatarTop">TT</div>
        </header>

        <main class="main">
            <div class="content">

                <div class="page-header">
                    <div class="breadcrumb">
                        <a href="${pageContext.request.contextPath}/totruong/dashboard">Dashboard</a>
                        / Danh sách hộ dân
                    </div>
                    <h1>Danh sách hộ dân</h1>
                    <p>Quản lý các hộ gia đình trong tổ dân phố</p>
                </div>

                <!-- SEARCH + FILTER -->
                <div class="search-filter-row">
                    <form class="search-wrap"
                          action="${pageContext.request.contextPath}/todan/hodan" method="get">
                        <input type="text" name="keyword" value="${keyword}"
                               placeholder="🔍 Tìm theo địa chỉ, mã hộ, tên, CCCD...">
                        <input type="hidden" name="tuoiMin"   id="h_tuoiMin"   value="${param.tuoiMin}">
                        <input type="hidden" name="tuoiMax"   id="h_tuoiMax"   value="${param.tuoiMax}">
                        <input type="hidden" name="vung"      id="h_vung"      value="${param.vung}">
                        <input type="hidden" name="chuHo"     id="h_chuHo"     value="${param.chuHo}">
                        <input type="hidden" name="kichHoat"  id="h_kichHoat"  value="${param.kichHoat}">
                        <input type="hidden" name="trangThai" id="h_trangThai" value="${param.trangThai}">
                        <button type="submit" class="btn btn-primary">Tìm kiếm</button>
                        <c:if test="${not empty keyword or not empty param.tuoiMin or not empty param.tuoiMax or not empty param.vung or not empty param.chuHo or not empty param.kichHoat or not empty param.trangThai}">
                            <a href="${pageContext.request.contextPath}/todan/hodan" class="btn btn-secondary">✕ Xóa</a>
                        </c:if>
                    </form>

                    <div class="filter-wrap">
                        <button class="btn-filter" id="filterBtn" onclick="toggleFilter(event)">
                            🎛 Lọc
                            <span class="filter-badge" id="filterBadge">0</span>
                            ▾
                        </button>
                        <div class="filter-dropdown" id="filterDropdown">
                            <div class="filter-section">
                                <div class="filter-label">📅 Tuổi thành viên</div>
                                <div class="filter-row">
                                    <input type="number" class="filter-input" id="f_tuoiMin" placeholder="Từ" min="0" max="120" value="${param.tuoiMin}">
                                    <input type="number" class="filter-input" id="f_tuoiMax" placeholder="Đến" min="0" max="120" value="${param.tuoiMax}">
                                </div>
                            </div>
                            <div class="filter-section">
                                <div class="filter-label">📍 Tuyến đường / Vùng</div>
                                <input type="text" class="filter-input" id="f_vung" placeholder="VD: Hùng Vương..." value="${param.vung}" style="width:100%">
                            </div>
                            <div class="filter-section">
                                <div class="filter-label">👤 Chủ hộ</div>
                                <select class="filter-select" id="f_chuHo">
                                    <option value="">-- Tất cả --</option>
                                    <option value="co"   ${param.chuHo == 'co'   ? 'selected' : ''}>Đã có chủ hộ</option>
                                    <option value="chua" ${param.chuHo == 'chua' ? 'selected' : ''}>Chưa có chủ hộ</option>
                                </select>
                            </div>
                            <div class="filter-section">
                                <div class="filter-label">✅ Kích hoạt tài khoản</div>
                                <select class="filter-select" id="f_kichHoat">
                                    <option value="">-- Tất cả --</option>
                                    <option value="co"   ${param.kichHoat == 'co'   ? 'selected' : ''}>Đã kích hoạt</option>
                                    <option value="chua" ${param.kichHoat == 'chua' ? 'selected' : ''}>Chưa kích hoạt</option>
                                </select>
                            </div>
                            <div class="filter-section">
                                <div class="filter-label">🏘 Trạng thái cư trú</div>
                                <select class="filter-select" id="f_trangThai">
                                    <option value="">-- Tất cả --</option>
                                    <option value="1" ${param.trangThai == '1' ? 'selected' : ''}>Thường trú</option>
                                    <option value="2" ${param.trangThai == '2' ? 'selected' : ''}>Tạm trú</option>
                                    <option value="3" ${param.trangThai == '3' ? 'selected' : ''}>Tạm vắng</option>
                                </select>
                            </div>
                            <div class="filter-actions">
                                <button class="btn btn-primary btn-sm" onclick="applyFilter()">✓ Áp dụng</button>
                                <button class="btn btn-secondary btn-sm" onclick="clearFilter()">✕ Xóa lọc</button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- SUMMARY -->
                <div class="summary-row">
                    <c:choose>
                        <c:when test="${coFilter}">
                            <div class="sum-chip">
                                <div class="sc-num">${tongSoCaNhan}</div>
                                <div class="sc-label">Người khớp filter</div>
                            </div>
                            <div class="sum-chip">
                                <div class="sc-num" style="color:var(--accent2)">${nhomCaNhan.size()}</div>
                                <div class="sc-label">Số tuyến đường</div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="sum-chip">
                                <div class="sc-num">${tongSoHo}</div>
                                <div class="sc-label">Tổng số hộ</div>
                            </div>
                            <div class="sum-chip">
                                <div class="sc-num" style="color:var(--accent2)">${nhomTheoDuong.size()}</div>
                                <div class="sc-label">Số tuyến đường</div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- ACCORDION -->
                <c:choose>

                    <%-- ══ CHẾ ĐỘ CÁ NHÂN (có filter) ══ --%>
                    <c:when test="${coFilter}">
                        <c:choose>
                            <c:when test="${not empty nhomCaNhan}">
                                <div class="mode-badge">🔍 Chế độ tìm kiếm cá nhân — xóa filter để xem danh sách hộ</div>
                                <div class="accordion">
                                    <c:forEach var="entry" items="${nhomCaNhan}" varStatus="st">
                                        <div class="acc-group">
                                            <div class="acc-header ${st.index == 0 ? 'open' : ''}" onclick="toggleAcc(this)">
                                                <div class="acc-left">
                                                    <div class="acc-road-icon">🛣</div>
                                                    <div>
                                                        <div class="acc-road-name">${entry.key}</div>
                                                        <div class="acc-road-sub">${entry.value.size()} người</div>
                                                    </div>
                                                </div>
                                                <div class="acc-right">
                                                    <span class="acc-count">${entry.value.size()} người</span>
                                                    <span class="acc-chevron">▼</span>
                                                </div>
                                            </div>
                                            <div class="acc-body ${st.index == 0 ? 'open' : ''}">
                                                <div class="table-wrap">
                                                    <table class="ho-table">
                                                        <thead>
                                                            <tr>
                                                                <th>#</th>
                                                                <th>Họ và tên</th>
                                                                <th>Quan hệ</th>
                                                                <th>Mã hộ</th>
                                                                <th>Ngày sinh</th>
                                                                <th>Tuổi</th>
                                                                <th>Giới tính</th>
                                                                <th>SĐT</th>
                                                                <th>Trạng thái hộ</th>
                                                                <th style="text-align:center;">Chi tiết</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <c:forEach var="p" items="${entry.value}" varStatus="s">
                                                                <tr class="main-row">
                                                                    <td style="color:var(--muted)">${s.index + 1}</td>
                                                                    <td>
                                                                        <div style="display:flex;align-items:center;">
                                                                            <span class="ho-avatar">${s.index + 1}</span>
                                                                            <strong>${p.hoTen}</strong>
                                                                        </div>
                                                                    </td>
                                                                    <td><span class="qh-badge ${p.quanHe == 'Chủ hộ' ? 'chu' : ''}">${p.quanHe}</span></td>
                                                                    <td style="font-family:monospace;color:var(--accent);font-weight:700">${p.maHoKhau}</td>
                                                                    <td style="color:var(--muted)">${p.ngaySinh}</td>
                                                                    <td style="color:var(--accent2);font-weight:700">${p.tuoi} t</td>
                                                                    <td>
                                                                        <c:choose>
                                                                            <c:when test="${p.gioiTinh == 'Nam'}"><span style="color:#60a5fa">♂ Nam</span></c:when>
                                                                            <c:when test="${p.gioiTinh == 'Nữ'}"><span style="color:#f472b6">♀ Nữ</span></c:when>
                                                                            <c:otherwise>—</c:otherwise>
                                                                        </c:choose>
                                                                    </td>
                                                                    <td style="color:var(--muted)">${p.soDienThoai}</td>
                                                                    <td>
                                                                        <c:choose>
                                                                            <c:when test="${p.trangThaiID == 1}"><span class="pill thuongtru">${p.tenTrangThai}</span></c:when>
                                                                            <c:when test="${p.trangThaiID == 2}"><span class="pill tamtru">${p.tenTrangThai}</span></c:when>
                                                                            <c:otherwise><span class="pill tamvang">${p.tenTrangThai}</span></c:otherwise>
                                                                        </c:choose>
                                                                    </td>
                                                                    <td style="text-align:center;">
                                                                        <button class="btn-tv-view" onclick="openTVModal({
                                                                            hoTen:    '${p.hoTen}',
                                                                            quanHe:   '${p.quanHe}',
                                                                            ngaySinh: '${p.ngaySinh}',
                                                                            tuoi:     '${p.tuoi}',
                                                                            gioiTinh: '${p.gioiTinh}',
                                                                            sdt:      '${p.soDienThoai}',
                                                                            cccd:     '${p.cccd}',
                                                                            email:    '${p.email}',
                                                                            ngayVao:  '${p.ngayVao}'
                                                                        })">👁 Xem</button>
                                                                    </td>
                                                                </tr>
                                                            </c:forEach>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">
                                    <div class="es-icon">🔍</div>
                                    <p>Không tìm thấy người nào phù hợp với điều kiện lọc.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </c:when>

                    <%-- ══ CHẾ ĐỘ HỘ (mặc định) ══ --%>
                    <c:otherwise>
                        <c:choose>
                            <c:when test="${not empty nhomTheoDuong}">
                                <div class="accordion">
                                    <c:forEach var="entry" items="${nhomTheoDuong}" varStatus="st">
                                        <div class="acc-group">
                                            <div class="acc-header ${st.index == 0 ? 'open' : ''}" onclick="toggleAcc(this)">
                                                <div class="acc-left">
                                                    <div class="acc-road-icon">🛣</div>
                                                    <div>
                                                        <div class="acc-road-name">${entry.key}</div>
                                                        <div class="acc-road-sub">${entry.value.size()} hộ gia đình</div>
                                                    </div>
                                                </div>
                                                <div class="acc-right">
                                                    <span class="acc-count">${entry.value.size()} hộ</span>
                                                    <span class="acc-chevron">▼</span>
                                                </div>
                                            </div>
                                            <div class="acc-body ${st.index == 0 ? 'open' : ''}">
                                                <div class="table-wrap">
                                                    <table class="ho-table">
                                                        <thead>
                                                            <tr>
                                                                <th>#</th>
                                                                <th>Mã hộ</th>
                                                                <th>Chủ hộ</th>
                                                                <th>Quan hệ</th>
                                                                <th style="text-align:center;">Thành viên</th>
                                                                <th>Kích hoạt</th>
                                                                <th>Trạng thái</th>
                                                                <th style="text-align:center;">Chi tiết</th>
                                                                <th style="text-align:center;">Sửa TT</th><%-- ── MỚI --%>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <c:forEach var="ho" items="${entry.value}" varStatus="s">
                                                                <tr class="main-row">
                                                                    <td style="color:var(--muted)">${s.index + 1}</td>
                                                                    <td style="font-family:monospace;color:var(--accent);font-weight:700">${ho.maHoKhau}</td>
                                                                    <td>
                                                                        <div style="display:flex;align-items:center;">
                                                                            <span class="ho-avatar">${s.index + 1}</span>
                                                                            <span>${not empty ho.tenChuHo ? ho.tenChuHo : '—'}</span>
                                                                        </div>
                                                                    </td>
                                                                    <td>
                                                                        <c:choose>
                                                                            <c:when test="${not empty ho.tenChuHo}"><span class="qh-badge chu">Chủ hộ</span></c:when>
                                                                            <c:otherwise><span style="color:var(--muted)">—</span></c:otherwise>
                                                                        </c:choose>
                                                                    </td>
                                                                    <td style="text-align:center;">
                                                                        <span class="tv-num"
                                                                              id="tvbtn-${ho.hoDanID}"
                                                                              onclick="toggleExpand('tvrow-${ho.hoDanID}', ${ho.hoDanID}, this)"
                                                                              title="Xem ${ho.soThanhVien} thành viên">
                                                                            👥 ${ho.soThanhVien}
                                                                        </span>
                                                                    </td>
                                                                    <td>
                                                                        <c:choose>
                                                                            <c:when test="${ho.daKichHoat}"><span class="pill-active">✓ Đã KH</span></c:when>
                                                                            <c:otherwise><span class="pill-inactive">✗ Chưa KH</span></c:otherwise>
                                                                        </c:choose>
                                                                    </td>
                                                                    <td>
                                                                        <c:choose>
                                                                            <c:when test="${ho.trangThaiID == 1}"><span class="pill thuongtru">${ho.tenTrangThai}</span></c:when>
                                                                            <c:when test="${ho.trangThaiID == 2}"><span class="pill tamtru">${ho.tenTrangThai}</span></c:when>
                                                                            <c:otherwise><span class="pill tamvang">${ho.tenTrangThai}</span></c:otherwise>
                                                                        </c:choose>
                                                                    </td>
                                                                    <td style="text-align:center;">
                                                                        <button class="btn-view" onclick="openModal({
                                                                            maHoKhau:    '${ho.maHoKhau}',
                                                                            tenChuHo:    '${ho.tenChuHo}',
                                                                            cccd:        '${ho.cccdChuHo}',
                                                                            ngaySinh:    '${ho.ngaySinhChuHo}',
                                                                            tuoi:        '${ho.tuoiChuHo}',
                                                                            gioiTinh:    '${ho.gioiTinhChuHo}',
                                                                            sdt:         '${ho.soDienThoaiChuHo}',
                                                                            email:       '${ho.emailChuHo}',
                                                                            soThanhVien: '${ho.soThanhVien}',
                                                                            trangThai:   '${ho.tenTrangThai}',
                                                                            trangThaiID: '${ho.trangThaiID}',
                                                                            daKichHoat:  '${ho.daKichHoat}',
                                                                            diaChi:      '${ho.diaChi}',
                                                                            ngayTao:     '${ho.ngayTao}'
                                                                        })">👁 Xem</button>
                                                                    </td>
                                                                    <%-- ── MỚI: nút sửa trạng thái --%>
                                                                    <td style="text-align:center;">
                                                                        <button class="btn-edit-tt" onclick="openSuaTrangThai({
                                                                            hoDanID:     '${ho.hoDanID}',
                                                                            maHoKhau:    '${ho.maHoKhau}',
                                                                            tenChuHo:    '${ho.tenChuHo}',
                                                                            trangThaiID: '${ho.trangThaiID}',
                                                                            trangThai:   '${ho.tenTrangThai}'
                                                                        })">✏ Sửa</button>
                                                                    </td>
                                                                </tr>

                                                                <tr class="tv-expand-row">
                                                                    <td colspan="9">
                                                                        <div class="tv-expand-inner" id="tvrow-${ho.hoDanID}">
                                                                            <table class="tv-inner-table">
                                                                                <thead>
                                                                                    <tr>
                                                                                        <th>#</th>
                                                                                        <th>Họ và tên</th>
                                                                                        <th>Quan hệ</th>
                                                                                        <th>Ngày sinh</th>
                                                                                        <th>Tuổi</th>
                                                                                        <th>Giới tính</th>
                                                                                        <th>SĐT</th>
                                                                                        <th>CCCD</th>
                                                                                        <th style="text-align:center;">Chi tiết</th>
                                                                                    </tr>
                                                                                </thead>
                                                                                <tbody id="tvbody-${ho.hoDanID}">
                                                                                    <tr><td colspan="9" style="color:var(--muted);padding:16px;text-align:center;">Đang tải...</td></tr>
                                                                                </tbody>
                                                                            </table>
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                            </c:forEach>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">
                                    <div class="es-icon">🏠</div>
                                    <p>Chưa có hộ dân nào trong tổ.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </c:otherwise>

                </c:choose>
            </div>
        </main>

        <!-- ── MODAL CHI TIẾT HỘ ── -->
        <div class="modal-overlay" id="modalOverlay" onclick="closeModalOutside(event)">
            <div class="modal" id="modalBox">
                <div class="modal-header">
                    <div class="modal-header-left">
                        <div class="modal-big-avatar" id="mAvatar">?</div>
                        <div>
                            <div class="modal-title" id="mTenChuHo">—</div>
                            <div class="modal-subtitle" id="mMaHoKhau">—</div>
                        </div>
                    </div>
                    <button class="modal-close" onclick="closeModal()">✕</button>
                </div>
                <div class="modal-body">
                    <div class="detail-section">
                        <div class="detail-section-title">🏠 Thông tin hộ khẩu</div>
                        <div class="detail-grid">
                            <div class="detail-item"><div class="detail-label">Mã hộ khẩu</div><div class="detail-value mono" id="d_maHoKhau">—</div></div>
                            <div class="detail-item"><div class="detail-label">Số thành viên</div><div class="detail-value" id="d_soThanhVien">—</div></div>
                            <div class="detail-item"><div class="detail-label">Trạng thái cư trú</div><div class="detail-value" id="d_trangThai">—</div></div>
                            <div class="detail-item"><div class="detail-label">Kích hoạt tài khoản</div><div class="detail-value" id="d_kichHoat">—</div></div>
                            <div class="detail-item" style="grid-column:1/-1;"><div class="detail-label">Địa chỉ</div><div class="detail-value" id="d_diaChi" style="white-space:normal;">—</div></div>
                            <div class="detail-item"><div class="detail-label">Ngày tạo hồ sơ</div><div class="detail-value muted" id="d_ngayTao">—</div></div>
                        </div>
                    </div>
                    <div class="detail-section">
                        <div class="detail-section-title">👤 Thông tin chủ hộ</div>
                        <div class="detail-grid">
                            <div class="detail-item"><div class="detail-label">Họ và tên</div><div class="detail-value" id="d_tenChuHo">—</div></div>
                            <div class="detail-item"><div class="detail-label">CCCD / CMND</div><div class="detail-value mono" id="d_cccd">—</div></div>
                            <div class="detail-item"><div class="detail-label">Ngày sinh</div><div class="detail-value muted" id="d_ngaySinh">—</div></div>
                            <div class="detail-item"><div class="detail-label">Tuổi</div><div class="detail-value" id="d_tuoi" style="color:var(--accent2)">—</div></div>
                            <div class="detail-item"><div class="detail-label">Giới tính</div><div class="detail-value" id="d_gioiTinh">—</div></div>
                            <div class="detail-item"><div class="detail-label">Số điện thoại</div><div class="detail-value" id="d_sdt">—</div></div>
                            <div class="detail-item" style="grid-column:1/-1;"><div class="detail-label">Email</div><div class="detail-value muted" id="d_email">—</div></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- ── MODAL CHI TIẾT THÀNH VIÊN ── -->
        <div class="modal-overlay" id="tvModalOverlay" onclick="closeTVModalOutside(event)">
            <div class="modal" id="tvModalBox">
                <div class="modal-header">
                    <div class="modal-header-left">
                        <div class="modal-big-avatar" id="tvm_avatar" style="background:linear-gradient(135deg,#38d9a9,#4f8ef7)">?</div>
                        <div>
                            <div class="modal-title" id="tvm_ten">—</div>
                            <div class="modal-subtitle" id="tvm_quanhe">—</div>
                        </div>
                    </div>
                    <button class="modal-close" onclick="closeTVModal()">✕</button>
                </div>
                <div class="modal-body">
                    <div class="detail-section">
                        <div class="detail-section-title">👤 Thông tin cá nhân</div>
                        <div class="detail-grid">
                            <div class="detail-item"><div class="detail-label">Họ và tên</div><div class="detail-value" id="tvm_hoten">—</div></div>
                            <div class="detail-item"><div class="detail-label">CCCD / CMND</div><div class="detail-value mono" id="tvm_cccd">—</div></div>
                            <div class="detail-item"><div class="detail-label">Ngày sinh</div><div class="detail-value muted" id="tvm_ngaysinh">—</div></div>
                            <div class="detail-item"><div class="detail-label">Tuổi</div><div class="detail-value" id="tvm_tuoi" style="color:var(--accent2)">—</div></div>
                            <div class="detail-item"><div class="detail-label">Giới tính</div><div class="detail-value" id="tvm_gioitinh">—</div></div>
                            <div class="detail-item"><div class="detail-label">Quan hệ với chủ hộ</div><div class="detail-value" id="tvm_quanhe2">—</div></div>
                            <div class="detail-item"><div class="detail-label">Số điện thoại</div><div class="detail-value" id="tvm_sdt">—</div></div>
                            <div class="detail-item"><div class="detail-label">Email</div><div class="detail-value muted" id="tvm_email">—</div></div>
                            <div class="detail-item"><div class="detail-label">Ngày vào hộ</div><div class="detail-value muted" id="tvm_ngayvao">—</div></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- ── MODAL SỬA TRẠNG THÁI (MỚI) ── -->
        <div class="modal-overlay" id="suaTTOverlay" onclick="closeSuaTTOutside(event)">
            <div class="modal" style="width:520px;">
                <div class="modal-header">
                    <div class="modal-header-left">
                        <div class="modal-big-avatar" style="background:linear-gradient(135deg,#fbbf24,#f75c5c)">✏</div>
                        <div>
                            <div class="modal-title" id="stt_title">Sửa trạng thái cư trú</div>
                            <div class="modal-subtitle" id="stt_sub">—</div>
                        </div>
                    </div>
                    <button class="modal-close" onclick="closeSuaTT()">✕</button>
                </div>
                <div class="modal-body">
                    <input type="hidden" id="stt_hoDanID">
                    <input type="hidden" id="stt_trangThaiCuID">

                    <div class="form-group">
                        <label class="form-label">🏘 Trạng thái hiện tại</label>
                        <div id="stt_ttHienTai" style="padding:6px 0;font-size:14px;font-weight:600;"></div>
                    </div>
                    <div class="form-group">
                        <label class="form-label">🔄 Trạng thái mới <span style="color:var(--danger)">*</span></label>
                        <select class="form-select" id="stt_ttMoi">
                            <option value="">-- Chọn trạng thái mới --</option>
                            <option value="1">Thường trú</option>
                            <option value="2">Tạm trú</option>
                            <option value="3">Tạm vắng</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="form-label">📝 Lý do yêu cầu <span style="color:var(--danger)">*</span></label>
                        <textarea class="form-textarea" id="stt_lyDo"
                                  placeholder="Nhập lý do thay đổi trạng thái cư trú..."></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button class="btn btn-secondary" onclick="closeSuaTT()">Huỷ</button>
                    <button class="btn btn-primary" onclick="submitSuaTrangThai()">📤 Gửi yêu cầu</button>
                </div>
            </div>
        </div>

        <!-- Toast -->
        <div class="toast" id="toast"></div>

        <script>
            const ctxPath = '${pageContext.request.contextPath}';

            /* ── Avatar topbar ── */
            const ten = '${currentUser.ten}' || 'TT';
            document.getElementById('avatarTop').textContent = ten.trim().substring(0, 2).toUpperCase();

            /* ── Accordion ── */
            function toggleAcc(header) {
                const body = header.nextElementSibling;
                const isOpen = header.classList.contains('open');
                header.classList.toggle('open', !isOpen);
                body.classList.toggle('open', !isOpen);
            }

            /* ── Filter ── */
            function toggleFilter(e) {
                e.stopPropagation();
                document.getElementById('filterDropdown').classList.toggle('open');
                document.getElementById('filterBtn').classList.toggle('active');
            }
            document.addEventListener('click', function(e) {
                const wrap = document.querySelector('.filter-wrap');
                if (!wrap.contains(e.target)) {
                    document.getElementById('filterDropdown').classList.remove('open');
                    document.getElementById('filterBtn').classList.remove('active');
                }
            });

            const FILTER_IDS = ['f_tuoiMin','f_tuoiMax','f_vung','f_chuHo','f_kichHoat','f_trangThai'];
            const HIDDEN_IDS = ['h_tuoiMin','h_tuoiMax','h_vung','h_chuHo','h_kichHoat','h_trangThai'];

            function updateBadge() {
                let count = 0;
                FILTER_IDS.forEach(id => { if (document.getElementById(id).value) count++; });
                const badge = document.getElementById('filterBadge');
                badge.textContent = count;
                badge.classList.toggle('show', count > 0);
            }
            FILTER_IDS.forEach(id => {
                document.getElementById(id).addEventListener('input', updateBadge);
                document.getElementById(id).addEventListener('change', updateBadge);
            });
            updateBadge();

            function applyFilter() {
                FILTER_IDS.forEach((fid, i) => {
                    document.getElementById(HIDDEN_IDS[i]).value = document.getElementById(fid).value;
                });
                document.querySelector('.search-wrap').submit();
            }
            function clearFilter() {
                FILTER_IDS.forEach(id => document.getElementById(id).value = '');
                HIDDEN_IDS.forEach(id => document.getElementById(id).value = '');
                updateBadge();
                document.querySelector('.search-wrap').submit();
            }

            /* ── Expand row thành viên ── */
            function toggleExpand(rowId, hoDanID, btn) {
                const inner = document.getElementById(rowId);
                const isOpen = inner.classList.contains('open');
                if (isOpen) {
                    inner.classList.remove('open');
                    btn.classList.remove('active');
                } else {
                    inner.classList.add('open');
                    btn.classList.add('active');
                    loadThanhVien(hoDanID);
                }
            }

            function loadThanhVien(hoDanID) {
                const tbody = document.getElementById('tvbody-' + hoDanID);
                if (tbody.dataset.loaded === 'true') return;
                tbody.innerHTML = '<tr><td colspan="9" style="color:var(--muted);padding:20px;text-align:center;">Đang tải thành viên...</td></tr>';
                fetch(ctxPath + '/totruong/thanh-vien-ho?hoDanID=' + hoDanID, { cache: 'no-cache', credentials: 'include' })
                    .then(r => { if (!r.ok) throw new Error('HTTP ' + r.status); return r.json(); })
                    .then(data => {
                        tbody.dataset.loaded = 'true';
                        if (!data || !Array.isArray(data) || data.length === 0) {
                            tbody.innerHTML = '<tr><td colspan="9" style="color:var(--muted);padding:20px;text-align:center;font-style:italic;">Chưa có thành viên nào.</td></tr>';
                            return;
                        }
                        tbody.innerHTML = data.map((m, i) => renderTVRow(m, i)).join('');
                    })
                    .catch(err => {
                        tbody.innerHTML = '<tr><td colspan="9" style="color:var(--danger);padding:20px;text-align:center;">Lỗi: ' + err.message + '</td></tr>';
                    });
            }

            function f(obj, ...keys) {
                for (const k of keys) { const v = obj[k]; if (v !== undefined && v !== null && v !== '') return v; }
                return '—';
            }
            function esc(v) {
                if (!v || v === '—') return v || '—';
                return String(v).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');
            }

            function renderTVRow(m, i) {
                const hoTen = esc(f(m,'hoTen')), quanHe = esc(f(m,'quanHe'));
                const ngaySinh = esc(f(m,'ngaySinh'));
                const tuoi = (m.tuoi && m.tuoi != 0) ? m.tuoi + ' t' : '—';
                const gt = f(m,'gioiTinh'), sdt = esc(f(m,'soDienThoai'));
                const cccd = esc(f(m,'cccd')), email = esc(f(m,'email')), ngayVao = esc(f(m,'ngayVao'));
                const isChu = quanHe === 'Chủ hộ';
                const gtHtml = gt === 'Nam' ? '<span style="color:#60a5fa">♂ Nam</span>'
                    : (gt === 'Nữ' || gt === 'Nu') ? '<span style="color:#f472b6">♀ Nữ</span>' : '—';
                const dataJson = JSON.stringify({ hoTen, quanHe, ngaySinh, tuoi: m.tuoi, gioiTinh: gt, sdt, cccd, email, ngayVao }).replace(/'/g,'&#39;');
                return '<tr>'
                    + '<td style="color:var(--muted)">' + (i+1) + '</td>'
                    + '<td><strong>' + hoTen + '</strong></td>'
                    + '<td><span class="qh-badge ' + (isChu?'chu':'') + '">' + quanHe + '</span></td>'
                    + '<td style="color:var(--muted)">' + ngaySinh + '</td>'
                    + '<td style="color:var(--accent2);font-weight:700">' + tuoi + '</td>'
                    + '<td>' + gtHtml + '</td>'
                    + '<td style="color:var(--muted)">' + sdt + '</td>'
                    + '<td style="color:var(--muted);font-family:monospace">' + cccd + '</td>'
                    + '<td style="text-align:center;"><button class="btn-tv-view" onclick=\'openTVModal(' + dataJson + ')\'>👁 Xem</button></td>'
                    + '</tr>';
            }

            /* ── Modal chi tiết thành viên ── */
            function openTVModal(m) {
                const or = v => (v && v !== 'null' && v !== '0' && v !== '—') ? v : '—';
                const name = or(m.hoTen);
                document.getElementById('tvm_avatar').textContent   = (name !== '—') ? name.trim().slice(-1).toUpperCase() : '?';
                document.getElementById('tvm_ten').textContent      = name;
                document.getElementById('tvm_quanhe').textContent   = or(m.quanHe);
                document.getElementById('tvm_hoten').textContent    = name;
                document.getElementById('tvm_cccd').textContent     = or(m.cccd);
                document.getElementById('tvm_ngaysinh').textContent = or(m.ngaySinh);
                document.getElementById('tvm_tuoi').textContent     = (m.tuoi && m.tuoi != 0) ? m.tuoi + ' tuổi' : '—';
                document.getElementById('tvm_sdt').textContent      = or(m.sdt);
                document.getElementById('tvm_email').textContent    = or(m.email);
                document.getElementById('tvm_ngayvao').textContent  = or(m.ngayVao);
                document.getElementById('tvm_quanhe2').textContent  = or(m.quanHe);
                const gt = m.gioiTinh;
                if (gt === 'Nam') document.getElementById('tvm_gioitinh').innerHTML = '<span style="color:#60a5fa">♂ Nam</span>';
                else if (gt === 'Nữ' || gt === 'Nu') document.getElementById('tvm_gioitinh').innerHTML = '<span style="color:#f472b6">♀ Nữ</span>';
                else document.getElementById('tvm_gioitinh').innerHTML = '<span style="color:var(--muted)">—</span>';
                document.getElementById('tvModalOverlay').classList.add('show');
                document.body.style.overflow = 'hidden';
            }
            function closeTVModal() { document.getElementById('tvModalOverlay').classList.remove('show'); document.body.style.overflow = ''; }
            function closeTVModalOutside(e) { if (e.target === document.getElementById('tvModalOverlay')) closeTVModal(); }

            /* ── Modal chi tiết hộ ── */
            function openModal(data) {
                const or = v => (v && v !== 'null' && v !== '0') ? v : '—';
                const name = or(data.tenChuHo);
                document.getElementById('mAvatar').textContent       = (name !== '—') ? name.trim().slice(-1).toUpperCase() : '?';
                document.getElementById('mTenChuHo').textContent     = name;
                document.getElementById('mMaHoKhau').textContent     = or(data.maHoKhau);
                document.getElementById('d_maHoKhau').textContent    = or(data.maHoKhau);
                document.getElementById('d_soThanhVien').textContent = or(data.soThanhVien);
                document.getElementById('d_diaChi').textContent      = or(data.diaChi);
                document.getElementById('d_ngayTao').textContent     = or(data.ngayTao);
                document.getElementById('d_tenChuHo').textContent    = name;
                document.getElementById('d_cccd').textContent        = or(data.cccd);
                document.getElementById('d_ngaySinh').textContent    = or(data.ngaySinh);
                document.getElementById('d_tuoi').textContent        = (data.tuoi && data.tuoi !== '0') ? data.tuoi + ' tuổi' : '—';
                document.getElementById('d_sdt').textContent         = or(data.sdt);
                document.getElementById('d_email').textContent       = or(data.email);
                const gt = data.gioiTinh;
                if (gt === 'Nam') document.getElementById('d_gioiTinh').innerHTML = '<span style="color:#60a5fa">♂ Nam</span>';
                else if (gt === 'Nữ' || gt === 'Nu') document.getElementById('d_gioiTinh').innerHTML = '<span style="color:#f472b6">♀ Nữ</span>';
                else document.getElementById('d_gioiTinh').innerHTML = '<span style="color:var(--muted)">—</span>';
                const kh = data.daKichHoat === 'true';
                document.getElementById('d_kichHoat').innerHTML = kh ? '<span class="pill-active">✓ Đã kích hoạt</span>' : '<span class="pill-inactive">✗ Chưa kích hoạt</span>';
                const ttID = data.trangThaiID;
                const ttClass = ttID === '1' ? 'thuongtru' : ttID === '2' ? 'tamtru' : 'tamvang';
                document.getElementById('d_trangThai').innerHTML = '<span class="pill ' + ttClass + '">' + or(data.trangThai) + '</span>';
                document.getElementById('modalOverlay').classList.add('show');
                document.body.style.overflow = 'hidden';
            }
            function closeModal() { document.getElementById('modalOverlay').classList.remove('show'); document.body.style.overflow = ''; }
            function closeModalOutside(e) { if (e.target === document.getElementById('modalOverlay')) closeModal(); }

            /* ── Modal sửa trạng thái (MỚI) ── */
            const PILL_MAP = {
                '1': '<span class="pill thuongtru">Thường trú</span>',
                '2': '<span class="pill tamtru">Tạm trú</span>',
                '3': '<span class="pill tamvang">Tạm vắng</span>'
            };

            function openSuaTrangThai(data) {
                document.getElementById('stt_hoDanID').value       = data.hoDanID;
                document.getElementById('stt_trangThaiCuID').value = data.trangThaiID;
                document.getElementById('stt_title').textContent   = 'Sửa trạng thái — ' + (data.tenChuHo || data.maHoKhau);
                document.getElementById('stt_sub').textContent     = 'Mã hộ: ' + data.maHoKhau;
                document.getElementById('stt_ttHienTai').innerHTML = PILL_MAP[data.trangThaiID] || data.trangThai;
                document.getElementById('stt_ttMoi').value         = '';
                document.getElementById('stt_lyDo').value          = '';
                document.getElementById('suaTTOverlay').classList.add('show');
                document.body.style.overflow = 'hidden';
            }
            function closeSuaTT() {
                document.getElementById('suaTTOverlay').classList.remove('show');
                document.body.style.overflow = '';
            }
            function closeSuaTTOutside(e) {
                if (e.target === document.getElementById('suaTTOverlay')) closeSuaTT();
            }

            function submitSuaTrangThai() {
                const hoDanID        = document.getElementById('stt_hoDanID').value;
                const trangThaiCuID  = document.getElementById('stt_trangThaiCuID').value;
                const trangThaiMoiID = document.getElementById('stt_ttMoi').value;
                const lyDo           = document.getElementById('stt_lyDo').value.trim();

                if (!trangThaiMoiID) { showToast('error', '⚠ Vui lòng chọn trạng thái mới.'); return; }
                if (trangThaiMoiID === trangThaiCuID) { showToast('error', '⚠ Trạng thái mới phải khác trạng thái hiện tại.'); return; }
                if (!lyDo) { showToast('error', '⚠ Vui lòng nhập lý do yêu cầu.'); return; }

                const params = new URLSearchParams();
                params.append('action',          'tao');
                params.append('hoDanID',         hoDanID);
                params.append('trangThaiCuID',   trangThaiCuID);
                params.append('trangThaiMoiID',  trangThaiMoiID);
                params.append('lyDo',            lyDo);

                fetch(ctxPath + '/yeu-cau-doi-trang-thai', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: params.toString(),
                    credentials: 'include'
                })
                .then(r => r.json())
                .then(res => {
                    if (res.success) {
                        closeSuaTT();
                        showToast('success', '✓ ' + res.message);
                    } else {
                        showToast('error', '✕ ' + res.message);
                    }
                })
                .catch(() => showToast('error', '✕ Lỗi kết nối, vui lòng thử lại.'));
            }

            /* ── Toast ── */
            function showToast(type, msg) {
                const t = document.getElementById('toast');
                t.className = 'toast ' + type + ' show';
                t.textContent = msg;
                clearTimeout(t._timer);
                t._timer = setTimeout(() => t.classList.remove('show'), 3500);
            }

            document.addEventListener('keydown', e => {
                if (e.key === 'Escape') { closeModal(); closeTVModal(); closeSuaTT(); }
            });
        </script>
    </body>
</html>