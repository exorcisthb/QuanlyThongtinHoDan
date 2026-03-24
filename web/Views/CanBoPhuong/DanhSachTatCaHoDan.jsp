<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Danh sách hộ dân — Cán bộ phường</title>
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
            .topbar { position: fixed; top: 0; left: 0; right: 0; z-index: 200; height: 64px;
                background: rgba(15,17,23,.88); backdrop-filter: blur(16px);
                border-bottom: 1px solid var(--border);
                display: flex; align-items: center; padding: 0 32px; gap: 16px; }
            .topbar-logo { display: flex; align-items: center; gap: 10px; text-decoration: none; color: var(--text); }
            .logo-icon { width: 34px; height: 34px; border-radius: 8px;
                background: linear-gradient(135deg, var(--accent), var(--accent2));
                display: flex; align-items: center; justify-content: center; font-size: 16px; }
            .logo-text { font-size: 14px; font-weight: 700; }
            .logo-text span { color: var(--accent); }
            .topbar-divider { width: 1px; height: 24px; background: var(--border); }
            .topbar-title { font-size: 13px; font-weight: 600; color: var(--muted); }
            .topbar-spacer { flex: 1; }
            .back-btn { display: flex; align-items: center; gap: 6px; padding: 7px 14px;
                border-radius: 8px; background: var(--surface2); border: 1px solid var(--border);
                color: var(--text); text-decoration: none; font-size: 13px; font-weight: 600;
                transition: all .18s; }
            .back-btn:hover { border-color: var(--accent); color: var(--accent); }

            /* ── LAYOUT ── */
            .main { padding-top: 64px; }
            .content { max-width: 1300px; margin: 0 auto; padding: 36px 32px; }
            .page-header { margin-bottom: 28px; }
            .breadcrumb { font-size: 12px; color: var(--muted); margin-bottom: 8px; }
            .breadcrumb a { color: var(--accent); text-decoration: none; }
            .page-header h1 { font-size: 24px; font-weight: 800; letter-spacing: -.4px; }
            .page-header p { font-size: 14px; color: var(--muted); margin-top: 4px; }

            /* ── SEARCH + FILTER ROW ── */
            .search-filter-row { display: flex; gap: 12px; align-items: stretch; margin-bottom: 24px; }
            .search-wrap { background: var(--surface); border: 1px solid var(--border);
                border-radius: var(--radius); padding: 14px 20px;
                display: flex; gap: 12px; align-items: center; flex: 1; }
            .search-wrap input[type=text] { flex: 1; background: var(--surface2);
                border: 1px solid var(--border); color: var(--text);
                padding: 10px 14px; border-radius: 8px; font-size: 14px; font-family: inherit;
                transition: border-color .18s; }
            .search-wrap input[type=text]:focus { outline: none; border-color: var(--accent); }
            .btn { display: inline-flex; align-items: center; gap: 6px;
                padding: 10px 20px; border-radius: 8px; font-size: 14px;
                font-weight: 600; font-family: inherit; border: none; cursor: pointer;
                text-decoration: none; transition: all .18s; }
            .btn-primary { background: var(--accent); color: #fff; }
            .btn-primary:hover { background: #3a7de8; }
            .btn-secondary { background: var(--surface2); color: var(--text); border: 1px solid var(--border); }
            .btn-secondary:hover { border-color: var(--accent); color: var(--accent); }
            .import-btn { display: inline-flex; align-items: center; gap: 6px;
                background: var(--surface2); color: var(--accent2);
                border: 1px solid rgba(56,217,169,.4); border-radius: 8px;
                padding: 10px 18px; font-family: inherit; font-size: 14px; font-weight: 600;
                cursor: pointer; text-decoration: none; transition: all .18s; white-space: nowrap; }
            .import-btn:hover { background: rgba(56,217,169,.1); }

            /* ── FILTER DROPDOWN ── */
            .filter-wrap { position: relative; display: flex; align-items: stretch; }
            .btn-filter { background: var(--surface); color: var(--text);
                border: 1px solid var(--border);
                display: inline-flex; align-items: center; gap: 8px;
                padding: 14px 20px; border-radius: var(--radius);
                font-size: 14px; font-weight: 600; font-family: inherit;
                cursor: pointer; white-space: nowrap; transition: all .18s; height: 100%; }
            .btn-filter:hover, .btn-filter.active { border-color: var(--accent); color: var(--accent); }
            .filter-badge { background: var(--accent); color: #fff; font-size: 11px;
                font-weight: 700; padding: 2px 7px; border-radius: 20px;
                margin-left: 2px; display: none; }
            .filter-badge.show { display: inline-block; }
            .filter-dropdown { display: none; position: absolute; top: calc(100% + 8px); right: 0;
                width: 320px; background: var(--surface); border: 1px solid var(--border);
                border-radius: var(--radius); box-shadow: 0 12px 32px rgba(0,0,0,.4);
                z-index: 300; padding: 20px; }
            .filter-dropdown.open { display: block; animation: fadeIn .18s ease; }
            @keyframes fadeIn { from { opacity: 0; transform: translateY(-4px); } to { opacity: 1; transform: translateY(0); } }
            .filter-section { margin-bottom: 16px; }
            .filter-section:last-child { margin-bottom: 0; }
            .filter-label { font-size: 11px; font-weight: 700; color: var(--muted);
                text-transform: uppercase; letter-spacing: .5px; margin-bottom: 8px; }
            .filter-row { display: flex; gap: 8px; }
            .filter-input { flex: 1; background: var(--surface2); border: 1px solid var(--border);
                color: var(--text); padding: 8px 12px; border-radius: 8px;
                font-size: 13px; font-family: inherit; transition: border-color .18s; }
            .filter-input:focus { outline: none; border-color: var(--accent); }
            .filter-select { width: 100%; background: var(--surface2); border: 1px solid var(--border);
                color: var(--text); padding: 8px 12px; border-radius: 8px;
                font-size: 13px; font-family: inherit; cursor: pointer;
                transition: border-color .18s; appearance: none; }
            .filter-select:focus { outline: none; border-color: var(--accent); }
            .filter-actions { display: flex; gap: 8px; margin-top: 16px;
                padding-top: 16px; border-top: 1px solid var(--border); }
            .btn-sm { padding: 8px 16px; font-size: 13px; }

            /* ── SUMMARY ── */
            .summary-row { display: flex; gap: 12px; margin-bottom: 24px; flex-wrap: wrap; }
            .sum-chip { background: var(--surface); border: 1px solid var(--border);
                border-radius: 10px; padding: 12px 20px;
                display: flex; align-items: center; gap: 10px; }
            .sum-chip .sc-num { font-size: 22px; font-weight: 800; color: var(--accent); }
            .sum-chip .sc-label { font-size: 12px; color: var(--muted); }

            /* ── MODE BADGE ── */
            .mode-badge { display: inline-flex; align-items: center; gap: 6px;
                background: rgba(251,191,36,.12); color: var(--warn);
                border: 1px solid rgba(251,191,36,.3);
                font-size: 12px; font-weight: 700;
                padding: 6px 14px; border-radius: 20px; margin-bottom: 16px; }

            /* ── ACCORDION (Tổ) ── */
            .to-section { margin-bottom: 16px; }
            .to-header { display: flex; align-items: center; justify-content: space-between;
                padding: 16px 20px; background: var(--surface2);
                border: 1px solid var(--border);
                border-radius: var(--radius) var(--radius) 0 0;
                cursor: pointer; user-select: none; transition: background .18s; }
            .to-header:hover { background: #252a3a; }
            .to-header.collapsed { border-radius: var(--radius); }
            .to-header-left { display: flex; align-items: center; gap: 10px; }
            .to-badge { background: rgba(79,142,247,.15); color: var(--accent);
                font-size: 11px; font-weight: 700; padding: 3px 10px; border-radius: 20px; }
            .to-name { font-size: 15px; font-weight: 700; }
            .to-count { font-size: 12px; color: var(--muted); }
            .to-chevron { font-size: 12px; color: var(--muted); transition: transform .2s; }
            .to-chevron.open { transform: rotate(180deg); }
            .to-body { border: 1px solid var(--border); border-top: none;
                border-radius: 0 0 var(--radius) var(--radius); overflow: hidden; }

            /* ── ĐƯỜNG section ── */
            .duong-section { border-bottom: 1px solid var(--border); }
            .duong-section:last-child { border-bottom: none; }
            .duong-header { display: flex; align-items: center; gap: 8px;
                padding: 10px 20px; background: rgba(255,255,255,.02);
                font-size: 12px; font-weight: 700; color: var(--accent2);
                text-transform: uppercase; letter-spacing: .8px; }
            .duong-header::before { content: ''; width: 4px; height: 14px;
                background: var(--accent2); border-radius: 2px; }

            /* ── TABLE ── */
            .ho-table { width: 100%; border-collapse: collapse; font-size: 13px; }
            .ho-table thead th { padding: 10px 16px; text-align: left;
                font-size: 11px; font-weight: 700; text-transform: uppercase;
                letter-spacing: .8px; color: var(--muted);
                background: rgba(255,255,255,.02); border-bottom: 1px solid var(--border);
                white-space: nowrap; }
            .ho-table thead th.center { text-align: center; }
            .ho-table tbody tr { transition: background .15s; }
            .ho-table tbody tr.main-row:hover { background: rgba(255,255,255,.03); }
            .ho-table td { padding: 12px 16px; vertical-align: middle; white-space: nowrap; }
            .ho-table td.center { text-align: center; }
            .ho-table tbody tr:not(:last-child) td { border-bottom: 1px solid rgba(42,48,72,.6); }

            /* ── EXPAND ROW THÀNH VIÊN ── */
            .tv-expand-row td { padding: 0 !important; border-bottom: 1px solid var(--border) !important; }
            .tv-expand-inner { display: none; background: rgba(10,12,20,.5); padding: 14px 20px 16px 56px; }
            .tv-expand-inner.open { display: block; animation: fadeIn .18s ease; }
            .tv-inner-table { width: 100%; border-collapse: collapse; font-size: 12px; }
            .tv-inner-table th { padding: 7px 12px; text-align: left; font-size: 10px;
                font-weight: 700; text-transform: uppercase; letter-spacing: .6px;
                color: var(--muted); border-bottom: 1px solid var(--border); white-space: nowrap; }
            .tv-inner-table td { padding: 9px 12px; color: var(--text);
                border-bottom: 1px solid rgba(42,48,72,.35); white-space: nowrap; }
            .tv-inner-table tbody tr:last-child td { border-bottom: none; }
            .tv-inner-table tbody tr:hover { background: rgba(255,255,255,.02); }

            /* ── PILLS ── */
            .pill { font-size: 11px; font-weight: 600; padding: 3px 10px; border-radius: 20px; }
            .pill.thuongtru { background: rgba(56,217,169,.15); color: var(--accent2); }
            .pill.tamtru    { background: rgba(251,191,36,.15); color: var(--warn); }
            .pill.tamvang   { background: rgba(247,92,92,.15);  color: var(--danger); }
            .pill-active    { background: rgba(56,217,169,.15); color: var(--accent2);
                font-size: 11px; font-weight: 600; padding: 3px 10px; border-radius: 20px; }
            .pill-inactive  { background: rgba(247,92,92,.15);  color: var(--danger);
                font-size: 11px; font-weight: 600; padding: 3px 10px; border-radius: 20px; }

            .qh-badge { display: inline-block; font-size: 10px; font-weight: 700;
                padding: 2px 8px; border-radius: 10px;
                background: rgba(79,142,247,.12); color: var(--accent); }
            .qh-badge.chu { background: rgba(56,217,169,.12); color: var(--accent2); }

            .ho-avatar { width: 30px; height: 30px; border-radius: 50%;
                background: linear-gradient(135deg, #667eea, #764ba2);
                display: inline-flex; align-items: center; justify-content: center;
                font-size: 11px; font-weight: 700; color: #fff;
                margin-right: 8px; text-transform: uppercase;
                vertical-align: middle; flex-shrink: 0; }

            /* ── BUTTONS ── */
            .tv-num { display: inline-flex; align-items: center; justify-content: center;
                min-width: 28px; height: 28px; padding: 0 8px; border-radius: 20px;
                background: var(--surface2); border: 1px solid var(--border);
                font-size: 12px; font-weight: 700; color: var(--accent2);
                cursor: pointer; transition: all .15s; white-space: nowrap; gap: 4px; }
            .tv-num:hover { background: rgba(56,217,169,.15); border-color: var(--accent2); }
            .tv-num.active { background: rgba(56,217,169,.2); border-color: var(--accent2); }

            .btn-view { display: inline-flex; align-items: center; gap: 5px;
                padding: 5px 13px; border-radius: 7px;
                background: rgba(79,142,247,.12); color: var(--accent);
                border: 1px solid rgba(79,142,247,.3);
                font-size: 12px; font-weight: 700; font-family: inherit;
                cursor: pointer; transition: all .18s; white-space: nowrap; }
            .btn-view:hover { background: rgba(79,142,247,.25); border-color: var(--accent); }

            .btn-tv-view { display: inline-flex; align-items: center; gap: 4px;
                padding: 3px 10px; border-radius: 6px;
                background: rgba(56,217,169,.1); color: var(--accent2);
                border: 1px solid rgba(56,217,169,.25);
                font-size: 11px; font-weight: 700; font-family: inherit;
                cursor: pointer; transition: all .18s; white-space: nowrap; }
            .btn-tv-view:hover { background: rgba(56,217,169,.22); border-color: var(--accent2); }

            /* ── MODAL ── */
            .modal-overlay { display: none; position: fixed; inset: 0; z-index: 999;
                background: rgba(0,0,0,.65); backdrop-filter: blur(6px);
                align-items: center; justify-content: center; }
            .modal-overlay.show { display: flex; animation: overlayIn .2s ease; }
            @keyframes overlayIn { from { opacity: 0; } to { opacity: 1; } }
            .modal { background: var(--surface); border: 1px solid var(--border);
                border-radius: 16px; width: 620px; max-width: calc(100vw - 32px);
                max-height: 88vh; overflow-y: auto;
                box-shadow: 0 24px 64px rgba(0,0,0,.6);
                animation: modalIn .22s cubic-bezier(.34,1.56,.64,1); }
            @keyframes modalIn { from { opacity:0; transform:scale(.93) translateY(12px); } to { opacity:1; transform:none; } }
            .modal-header { display: flex; align-items: center; justify-content: space-between;
                padding: 22px 28px 18px; border-bottom: 1px solid var(--border);
                position: sticky; top: 0; background: var(--surface); z-index: 1; }
            .modal-header-left { display: flex; align-items: center; gap: 14px; }
            .modal-big-avatar { width: 48px; height: 48px; border-radius: 12px;
                background: linear-gradient(135deg, #667eea, #764ba2);
                display: flex; align-items: center; justify-content: center;
                font-size: 18px; font-weight: 800; color: #fff; text-transform: uppercase; }
            .modal-title { font-size: 17px; font-weight: 800; }
            .modal-subtitle { font-size: 12px; color: var(--muted); margin-top: 2px; }
            .modal-close { width: 34px; height: 34px; border-radius: 8px;
                border: 1px solid var(--border); background: var(--surface2);
                color: var(--muted); font-size: 16px; cursor: pointer;
                display: flex; align-items: center; justify-content: center;
                transition: all .18s; flex-shrink: 0; }
            .modal-close:hover { border-color: var(--danger); color: var(--danger); }
            .modal-body { padding: 24px 28px; }
            .detail-section { margin-bottom: 22px; }
            .detail-section:last-child { margin-bottom: 0; }
            .detail-section-title { font-size: 10px; font-weight: 700; color: var(--muted);
                text-transform: uppercase; letter-spacing: .8px;
                margin-bottom: 14px; padding-bottom: 8px; border-bottom: 1px solid var(--border);
                display: flex; align-items: center; gap: 6px; }
            .detail-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }
            .detail-label { font-size: 11px; color: var(--muted); margin-bottom: 4px; font-weight: 600; }
            .detail-value { font-size: 14px; font-weight: 600; color: var(--text); }
            .detail-value.mono { font-family: monospace; color: var(--accent); }
            .detail-value.muted { color: var(--muted); font-weight: 400; }

            .empty-state { text-align: center; padding: 48px; color: var(--muted); }
            .empty-state .es-icon { font-size: 40px; margin-bottom: 12px; }
        </style>
    </head>
    <body>

        <header class="topbar">
            <a href="${pageContext.request.contextPath}/canbophuong/dashboard" class="topbar-logo">
                <div class="logo-icon">🏘</div>
                <div class="logo-text">Quản lý <span>Hộ dân</span></div>
            </a>
            <div class="topbar-divider"></div>
            <span class="topbar-title">Cán bộ phường</span>
            <div class="topbar-spacer"></div>
            <a href="${pageContext.request.contextPath}/canbophuong/dashboard" class="back-btn">← Dashboard</a>
        </header>

        <main class="main">
            <div class="content">

                <div class="page-header">
                    <div class="breadcrumb">
                        <a href="${pageContext.request.contextPath}/canbophuong/dashboard">Dashboard</a>
                         Danh sách hộ dân
                    </div>
                    <h1>Danh sách hộ dân toàn phường</h1>
                    <p>Quản lý tất cả hộ khẩu theo từng tổ dân phố</p>
                </div>

                <!-- ── SEARCH + FILTER ── -->
                <div class="search-filter-row">
                    <form class="search-wrap"
                          action="${pageContext.request.contextPath}/canbophuong/hodan" method="get">
                        <input type="text" name="keyword" value="${keyword}"
                               placeholder="🔍 Tìm theo mã hộ, địa chỉ, tên chủ hộ, CCCD, tên tổ...">
                        <%-- hidden fields giữ filter state khi search --%>
                        <input type="hidden" name="tuoiMin"   id="h_tuoiMin"   value="${param.tuoiMin}">
                        <input type="hidden" name="tuoiMax"   id="h_tuoiMax"   value="${param.tuoiMax}">
                        <input type="hidden" name="kichHoat"  id="h_kichHoat"  value="${param.kichHoat}">
                        <input type="hidden" name="trangThai" id="h_trangThai" value="${param.trangThai}">

                        <button type="submit" class="btn btn-primary">Tìm kiếm</button>
                        <a href="${pageContext.request.contextPath}/canbophuong/import-hodan" class="import-btn">📥 Import</a>
                        <c:if test="${coThamSo}">
                            <a href="${pageContext.request.contextPath}/canbophuong/hodan" class="btn btn-secondary">✕ Xóa</a>
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
                                    <input type="number" class="filter-input" id="f_tuoiMin"
                                           placeholder="Từ" min="0" max="120" value="${param.tuoiMin}">
                                    <input type="number" class="filter-input" id="f_tuoiMax"
                                           placeholder="Đến" min="0" max="120" value="${param.tuoiMax}">
                                </div>
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

                <!-- ── SUMMARY ── -->
                <div class="summary-row">
                    <c:choose>
                        <c:when test="${coFilter}">
                            <div class="sum-chip">
                                <div class="sc-num">${tongSoCaNhan}</div>
                                <div class="sc-label">Người khớp filter</div>
                            </div>
                            <div class="sum-chip">
                                <div class="sc-num" style="color:var(--accent2)">${nhomCaNhan.size()}</div>
                                <div class="sc-label">Số tổ dân phố</div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="sum-chip">
                                <div class="sc-num">${tongSoHo}</div>
                                <div class="sc-label">Tổng số hộ</div>
                            </div>
                            <div class="sum-chip">
                                <div class="sc-num" style="color:var(--accent2)">${nhomTheoTo.size()}</div>
                                <div class="sc-label">Số tổ dân phố</div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- ══════════════════════════════════════════════════ -->
                <!-- CHẾ ĐỘ CÁ NHÂN (có filter)                        -->
                <!-- ══════════════════════════════════════════════════ -->
                <c:if test="${coFilter}">
                    <c:choose>
                        <c:when test="${not empty nhomCaNhan}">
                            <div class="mode-badge">🔍 Chế độ tìm kiếm cá nhân — xóa filter để xem danh sách hộ</div>

                            <c:forEach var="toEntry" items="${nhomCaNhan}" varStatus="toSt">
                                <div class="to-section">
                                    <%-- ── TẤT CẢ collapsed mặc định ── --%>
                                    <div class="to-header collapsed"
                                         onclick="toggleTo('to-cn-${toSt.index}', this)">
                                        <div class="to-header-left">
                                            <span class="to-badge">🏘 Tổ</span>
                                            <span class="to-name">${toEntry.key}</span>
                                        </div>
                                        <div style="display:flex;align-items:center;gap:12px;">
                                            <c:set var="demNguoi" value="0"/>
                                            <c:forEach var="duongEntry2" items="${toEntry.value}">
                                                <c:set var="demNguoi" value="${demNguoi + duongEntry2.value.size()}"/>
                                            </c:forEach>
                                            <span class="to-count">${demNguoi} người</span>
                                            <span class="to-chevron" id="chevron-to-cn-${toSt.index}">▼</span>
                                        </div>
                                    </div>
                                    <div class="to-body" id="to-cn-${toSt.index}" style="display:none;">
                                        <c:forEach var="duongEntry" items="${toEntry.value}">
                                            <div class="duong-section">
                                                <div class="duong-header">
                                                    ${duongEntry.key}
                                                    <span style="color:var(--muted);font-weight:500;margin-left:6px;">
                                                        — ${duongEntry.value.size()} người
                                                    </span>
                                                </div>
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
                                                            <th>Kích hoạt</th>
                                                            <th>Trạng thái hộ</th>
                                                            <th class="center">Chi tiết</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:forEach var="p" items="${duongEntry.value}" varStatus="s">
                                                            <tr class="main-row">
                                                                <td style="color:var(--muted)">${s.index + 1}</td>
                                                                <td>
                                                                    <div style="display:flex;align-items:center;">
                                                                        <%-- Avatar hiển thị số thứ tự --%>
                                                                        <span class="ho-avatar">${s.index + 1}</span>
                                                                        <strong>${p.hoTen}</strong>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <span class="qh-badge ${p.quanHe == 'Chủ hộ' ? 'chu' : ''}">
                                                                        ${p.quanHe}
                                                                    </span>
                                                                </td>
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
                                                                        <c:when test="${p.isActivated}"><span class="pill-active">✓ Đã KH</span></c:when>
                                                                        <c:otherwise><span class="pill-inactive">✗ Chưa KH</span></c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                <td>
                                                                    <c:choose>
                                                                        <c:when test="${p.trangThaiID == 1}"><span class="pill thuongtru">${p.tenTrangThai}</span></c:when>
                                                                        <c:when test="${p.trangThaiID == 2}"><span class="pill tamtru">${p.tenTrangThai}</span></c:when>
                                                                        <c:otherwise><span class="pill tamvang">${p.tenTrangThai}</span></c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                <td class="center">
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
                                        </c:forEach>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state">
                                <div class="es-icon">🔍</div>
                                <p>Không tìm thấy người nào phù hợp với điều kiện lọc.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </c:if>

                <!-- ══════════════════════════════════════════════════ -->
                <!-- CHẾ ĐỘ HỘ (mặc định, không có filter)             -->
                <!-- ══════════════════════════════════════════════════ -->
                <c:if test="${not coFilter}">
                    <c:choose>
                        <c:when test="${not empty nhomTheoTo}">
                            <c:forEach var="toEntry" items="${nhomTheoTo}" varStatus="toSt">
                                <div class="to-section">
                                    <%-- ── TẤT CẢ collapsed mặc định ── --%>
                                    <div class="to-header collapsed"
                                         onclick="toggleTo('to-${toSt.index}', this)">
                                        <div class="to-header-left">
                                            <span class="to-badge">🏘 Tổ</span>
                                            <span class="to-name">${toEntry.key}</span>
                                        </div>
                                        <div style="display:flex;align-items:center;gap:12px;">
                                            <c:set var="demHo" value="0"/>
                                            <c:forEach var="de" items="${toEntry.value}">
                                                <c:set var="demHo" value="${demHo + de.value.size()}"/>
                                            </c:forEach>
                                            <span class="to-count">${demHo} hộ</span>
                                            <span class="to-chevron" id="chevron-to-${toSt.index}">▼</span>
                                        </div>
                                    </div>
                                    <div class="to-body" id="to-${toSt.index}" style="display:none;">
                                        <c:forEach var="duongEntry" items="${toEntry.value}">
                                            <div class="duong-section">
                                                <div class="duong-header">
                                                    ${duongEntry.key}
                                                    <span style="color:var(--muted);font-weight:500;margin-left:6px;">
                                                        — ${duongEntry.value.size()} hộ
                                                    </span>
                                                </div>
                                                <table class="ho-table">
                                                    <thead>
                                                        <tr>
                                                            <th>#</th>
                                                            <th>Mã hộ / Địa chỉ</th>
                                                            <th>Chủ hộ</th>
                                                            <th>SĐT</th>
                                                            <th class="center">Thành viên</th>
                                                            <th class="center">Kích hoạt</th>
                                                            <th class="center">Trạng thái</th>
                                                            <th class="center">Chi tiết</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:forEach var="hd" items="${duongEntry.value}" varStatus="st">
                                                            <tr class="main-row">
                                                                <td style="color:var(--muted)">${st.index + 1}</td>
                                                                <td>
                                                                    <div style="display:flex;align-items:center;gap:10px;">
                                                                        <%-- Avatar hiển thị số thứ tự, không dùng fn:substring tránh lỗi Unicode --%>
                                                                        <span class="ho-avatar"
                                                                              style="border-radius:8px;background:linear-gradient(135deg,var(--accent),var(--accent2))">
                                                                            ${st.index + 1}
                                                                        </span>
                                                                        <div>
                                                                            <div style="font-family:monospace;color:var(--accent);font-weight:700">${hd.maHoKhau}</div>
                                                                            <div style="font-size:11px;color:var(--muted);margin-top:2px;">${hd.diaChi}</div>
                                                                        </div>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div style="font-weight:600">${not empty hd.tenChuHo ? hd.tenChuHo : '—'}</div>
                                                                    <c:if test="${not empty hd.cccdChuHo}">
                                                                        <div style="font-size:11px;color:var(--muted);margin-top:2px;">CCCD: ${hd.cccdChuHo}</div>
                                                                    </c:if>
                                                                </td>
                                                                <td style="color:var(--muted)">${not empty hd.soDienThoaiChuHo ? hd.soDienThoaiChuHo : '—'}</td>
                                                                <td class="center">
                                                                    <span class="tv-num"
                                                                          id="tvbtn-${hd.hoDanID}"
                                                                          onclick="toggleExpand('tvrow-${hd.hoDanID}', ${hd.hoDanID}, this)"
                                                                          title="Xem ${hd.soThanhVien} thành viên">
                                                                        👥 ${hd.soThanhVien}
                                                                    </span>
                                                                </td>
                                                                <td class="center">
                                                                    <c:choose>
                                                                        <c:when test="${hd.daKichHoat}"><span class="pill-active">✓ Đã KH</span></c:when>
                                                                        <c:otherwise><span class="pill-inactive">✗ Chưa KH</span></c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                <td class="center">
                                                                    <c:choose>
                                                                        <c:when test="${hd.trangThaiID == 1}"><span class="pill thuongtru">${hd.tenTrangThai}</span></c:when>
                                                                        <c:when test="${hd.trangThaiID == 2}"><span class="pill tamtru">${hd.tenTrangThai}</span></c:when>
                                                                        <c:otherwise><span class="pill tamvang">${hd.tenTrangThai}</span></c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                <td class="center">
                                                                    <button class="btn-view" onclick="openModal({
                                                                        maHoKhau:    '${hd.maHoKhau}',
                                                                        tenChuHo:    '${hd.tenChuHo}',
                                                                        cccd:        '${hd.cccdChuHo}',
                                                                        ngaySinh:    '${hd.ngaySinhChuHo}',
                                                                        tuoi:        '${hd.tuoiChuHo}',
                                                                        gioiTinh:    '${hd.gioiTinhChuHo}',
                                                                        sdt:         '${hd.soDienThoaiChuHo}',
                                                                        email:       '${hd.emailChuHo}',
                                                                        soThanhVien: '${hd.soThanhVien}',
                                                                        trangThai:   '${hd.tenTrangThai}',
                                                                        trangThaiID: '${hd.trangThaiID}',
                                                                        daKichHoat:  '${hd.daKichHoat}',
                                                                        diaChi:      '${hd.diaChi}',
                                                                        tenTo:       '${hd.tenTo}',
                                                                        ngayTao:     '${hd.ngayTao}'
                                                                    })">👁 Xem</button>
                                                                </td>
                                                            </tr>

                                                            <tr class="tv-expand-row">
                                                                <td colspan="8">
                                                                    <div class="tv-expand-inner" id="tvrow-${hd.hoDanID}">
                                                                        <table class="tv-inner-table">
                                                                            <thead>
                                                                                <tr>
                                                                                    <th>#</th><th>Họ và tên</th><th>Quan hệ</th>
                                                                                    <th>Ngày sinh</th><th>Tuổi</th><th>Giới tính</th>
                                                                                    <th>SĐT</th><th>CCCD</th>
                                                                                </tr>
                                                                            </thead>
                                                                            <tbody id="tvbody-${hd.hoDanID}">
                                                                                <tr><td colspan="8" style="color:var(--muted);padding:16px;text-align:center;">Đang tải...</td></tr>
                                                                            </tbody>
                                                                        </table>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state">
                                <div class="es-icon">🏠</div>
                                <p>
                                    <c:choose>
                                        <c:when test="${not empty keyword}">Không tìm thấy hộ dân nào khớp với "<strong>${keyword}</strong>"</c:when>
                                        <c:otherwise>Chưa có dữ liệu hộ dân trong hệ thống.</c:otherwise>
                                    </c:choose>
                                </p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </c:if>

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
                            <div><div class="detail-label">Mã hộ khẩu</div><div class="detail-value mono" id="d_maHoKhau">—</div></div>
                            <div><div class="detail-label">Tổ dân phố</div><div class="detail-value" id="d_tenTo">—</div></div>
                            <div><div class="detail-label">Số thành viên</div><div class="detail-value" id="d_soThanhVien">—</div></div>
                            <div><div class="detail-label">Trạng thái cư trú</div><div class="detail-value" id="d_trangThai">—</div></div>
                            <div><div class="detail-label">Kích hoạt tài khoản</div><div class="detail-value" id="d_kichHoat">—</div></div>
                            <div><div class="detail-label">Ngày tạo hồ sơ</div><div class="detail-value muted" id="d_ngayTao">—</div></div>
                            <div style="grid-column:1/-1;"><div class="detail-label">Địa chỉ</div><div class="detail-value" id="d_diaChi" style="white-space:normal;">—</div></div>
                        </div>
                    </div>
                    <div class="detail-section">
                        <div class="detail-section-title">👤 Thông tin chủ hộ</div>
                        <div class="detail-grid">
                            <div><div class="detail-label">Họ và tên</div><div class="detail-value" id="d_tenChuHo">—</div></div>
                            <div><div class="detail-label">CCCD / CMND</div><div class="detail-value mono" id="d_cccd">—</div></div>
                            <div><div class="detail-label">Ngày sinh</div><div class="detail-value muted" id="d_ngaySinh">—</div></div>
                            <div><div class="detail-label">Tuổi</div><div class="detail-value" id="d_tuoi" style="color:var(--accent2)">—</div></div>
                            <div><div class="detail-label">Giới tính</div><div class="detail-value" id="d_gioiTinh">—</div></div>
                            <div><div class="detail-label">Số điện thoại</div><div class="detail-value" id="d_sdt">—</div></div>
                            <div style="grid-column:1/-1;"><div class="detail-label">Email</div><div class="detail-value muted" id="d_email">—</div></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- ── MODAL CHI TIẾT THÀNH VIÊN (chế độ cá nhân) ── -->
        <div class="modal-overlay" id="tvModalOverlay" onclick="closeTVModalOutside(event)">
            <div class="modal" id="tvModalBox">
                <div class="modal-header">
                    <div class="modal-header-left">
                        <div class="modal-big-avatar" id="tvm_avatar"
                             style="background:linear-gradient(135deg,#38d9a9,#4f8ef7)">?</div>
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
                            <div><div class="detail-label">Họ và tên</div><div class="detail-value" id="tvm_hoten">—</div></div>
                            <div><div class="detail-label">CCCD / CMND</div><div class="detail-value mono" id="tvm_cccd">—</div></div>
                            <div><div class="detail-label">Ngày sinh</div><div class="detail-value muted" id="tvm_ngaysinh">—</div></div>
                            <div><div class="detail-label">Tuổi</div><div class="detail-value" id="tvm_tuoi" style="color:var(--accent2)">—</div></div>
                            <div><div class="detail-label">Giới tính</div><div class="detail-value" id="tvm_gioitinh">—</div></div>
                            <div><div class="detail-label">Quan hệ với chủ hộ</div><div class="detail-value" id="tvm_quanhe2">—</div></div>
                            <div><div class="detail-label">Số điện thoại</div><div class="detail-value" id="tvm_sdt">—</div></div>
                            <div><div class="detail-label">Email</div><div class="detail-value muted" id="tvm_email">—</div></div>
                            <div><div class="detail-label">Ngày vào hộ</div><div class="detail-value muted" id="tvm_ngayvao">—</div></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script>
            const ctxPath = '${pageContext.request.contextPath}';

            /* ── Accordion Tổ ── */
            function toggleTo(id, header) {
                const body = document.getElementById(id);
                const chevronId = 'chevron-' + id;
                const chevron   = document.getElementById(chevronId);
                const isOpen    = body.style.display !== 'none';
                body.style.display = isOpen ? 'none' : '';
                chevron.classList.toggle('open', !isOpen);
                header.classList.toggle('collapsed', isOpen);
            }

            /* ── Filter dropdown ── */
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

            const FILTER_IDS  = ['f_tuoiMin','f_tuoiMax','f_kichHoat','f_trangThai'];
            const HIDDEN_IDS  = ['h_tuoiMin','h_tuoiMax','h_kichHoat','h_trangThai'];

            function updateBadge() {
                let count = 0;
                FILTER_IDS.forEach(id => { if (document.getElementById(id).value) count++; });
                const badge = document.getElementById('filterBadge');
                badge.textContent = count;
                badge.classList.toggle('show', count > 0);
            }
            FILTER_IDS.forEach(id => {
                document.getElementById(id).addEventListener('input',  updateBadge);
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
                FILTER_IDS.forEach(id  => document.getElementById(id).value  = '');
                HIDDEN_IDS.forEach(hid => document.getElementById(hid).value = '');
                updateBadge();
                document.querySelector('.search-wrap').submit();
            }

            /* ── Expand thành viên (chế độ hộ) ── */
            function toggleExpand(rowId, hoDanID, btn) {
                const inner  = document.getElementById(rowId);
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
                tbody.innerHTML = '<tr><td colspan="8" style="color:var(--muted);padding:20px;text-align:center;">Đang tải thành viên...</td></tr>';
                fetch(ctxPath + '/canbophuong/thanh-vien-ho?hoDanID=' + hoDanID, { cache:'no-cache', credentials:'include' })
                    .then(r => { if (!r.ok) throw new Error('HTTP ' + r.status); return r.json(); })
                    .then(data => {
                        tbody.dataset.loaded = 'true';
                        if (!data || !Array.isArray(data) || data.length === 0) {
                            tbody.innerHTML = '<tr><td colspan="8" style="color:var(--muted);padding:20px;text-align:center;font-style:italic;">Chưa có thành viên nào.</td></tr>';
                            return;
                        }
                        tbody.innerHTML = data.map((m, i) => renderTVRow(m, i)).join('');
                    })
                    .catch(err => {
                        tbody.innerHTML = '<tr><td colspan="8" style="color:var(--danger);padding:20px;text-align:center;">Lỗi: ' + err.message + '</td></tr>';
                    });
            }

            function fv(obj, ...keys) {
                for (const k of keys) { const v = obj[k]; if (v !== undefined && v !== null && v !== '') return v; }
                return '—';
            }
            function esc(v) {
                if (!v || v === '—') return v || '—';
                return String(v).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');
            }

            function renderTVRow(m, i) {
                const hoTen    = esc(fv(m,'hoTen'));
                const quanHe   = esc(fv(m,'quanHe','TenQuanHe'));
                const ngaySinh = esc(fv(m,'ngaySinh'));
                const tuoi     = (m.tuoi && m.tuoi != 0) ? m.tuoi + ' t' : '—';
                const gt       = fv(m,'gioiTinh');
                const sdt      = esc(fv(m,'soDienThoai'));
                const cccd     = esc(fv(m,'cccd'));
                const isChu    = quanHe === 'Chủ hộ';
                const gtHtml   = gt === 'Nam'
                    ? '<span style="color:#60a5fa">♂ Nam</span>'
                    : (gt === 'Nữ' || gt === 'Nu') ? '<span style="color:#f472b6">♀ Nữ</span>' : '—';
                return '<tr>'
                    + '<td style="color:var(--muted)">' + (i+1) + '</td>'
                    + '<td><strong>' + hoTen + '</strong></td>'
                    + '<td><span class="qh-badge ' + (isChu?'chu':'') + '">' + quanHe + '</span></td>'
                    + '<td style="color:var(--muted)">' + ngaySinh + '</td>'
                    + '<td style="color:var(--accent2);font-weight:700">' + tuoi + '</td>'
                    + '<td>' + gtHtml + '</td>'
                    + '<td style="color:var(--muted)">' + sdt + '</td>'
                    + '<td style="color:var(--muted);font-family:monospace">' + cccd + '</td>'
                    + '</tr>';
            }

            /* ── Modal chi tiết thành viên (chế độ cá nhân) ── */
            function openTVModal(m) {
                const or = v => (v && v !== 'null' && v !== '0' && v !== '—') ? v : '—';
                const name = or(m.hoTen);
                document.getElementById('tvm_avatar').textContent   = name !== '—' ? name.trim().slice(-1).toUpperCase() : '?';
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
                document.getElementById('tvm_gioitinh').innerHTML =
                    gt === 'Nam' ? '<span style="color:#60a5fa">♂ Nam</span>'
                    : (gt === 'Nữ' || gt === 'Nu') ? '<span style="color:#f472b6">♀ Nữ</span>'
                    : '<span style="color:var(--muted)">—</span>';
                document.getElementById('tvModalOverlay').classList.add('show');
                document.body.style.overflow = 'hidden';
            }
            function closeTVModal() { document.getElementById('tvModalOverlay').classList.remove('show'); document.body.style.overflow = ''; }
            function closeTVModalOutside(e) { if (e.target === document.getElementById('tvModalOverlay')) closeTVModal(); }

            /* ── Modal chi tiết hộ ── */
            function openModal(data) {
                const or = v => (v && v !== 'null' && v !== '0') ? v : '—';
                const name = or(data.tenChuHo);
                document.getElementById('mAvatar').textContent       = name !== '—' ? name.trim().slice(-1).toUpperCase() : '?';
                document.getElementById('mTenChuHo').textContent     = name;
                document.getElementById('mMaHoKhau').textContent     = or(data.maHoKhau);
                document.getElementById('d_maHoKhau').textContent    = or(data.maHoKhau);
                document.getElementById('d_tenTo').textContent       = or(data.tenTo);
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
                document.getElementById('d_gioiTinh').innerHTML =
                    gt === 'Nam' ? '<span style="color:#60a5fa">♂ Nam</span>'
                    : (gt === 'Nữ' || gt === 'Nu') ? '<span style="color:#f472b6">♀ Nữ</span>'
                    : '<span style="color:var(--muted)">—</span>';
                const kh = data.daKichHoat === 'true';
                document.getElementById('d_kichHoat').innerHTML = kh
                    ? '<span class="pill-active">✓ Đã kích hoạt</span>'
                    : '<span class="pill-inactive">✗ Chưa kích hoạt</span>';
                const ttID    = data.trangThaiID;
                const ttClass = ttID === '1' ? 'thuongtru' : ttID === '2' ? 'tamtru' : 'tamvang';
                document.getElementById('d_trangThai').innerHTML = '<span class="pill ' + ttClass + '">' + or(data.trangThai) + '</span>';
                document.getElementById('modalOverlay').classList.add('show');
                document.body.style.overflow = 'hidden';
            }
            function closeModal() { document.getElementById('modalOverlay').classList.remove('show'); document.body.style.overflow = ''; }
            function closeModalOutside(e) { if (e.target === document.getElementById('modalOverlay')) closeModal(); }
            document.addEventListener('keydown', e => { if (e.key === 'Escape') { closeModal(); closeTVModal(); } });
        </script>
    </body>
</html>
