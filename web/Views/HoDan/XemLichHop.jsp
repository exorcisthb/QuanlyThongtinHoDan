<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.Map, java.sql.Timestamp, java.text.SimpleDateFormat" %>
<%@ page import="com.fasterxml.jackson.databind.ObjectMapper" %>
<%
    List<Map<String, Object>> danhSach = (List<Map<String, Object>>) request.getAttribute("danhSachLichHop");
    Map<String, Object>       chiTiet   = (Map<String, Object>)       request.getAttribute("chiTietLichHop");
    List<Map<String, Object>> lichSuSua = (List<Map<String, Object>>) request.getAttribute("lichSuSua");
    if (lichSuSua == null) lichSuSua = new java.util.ArrayList<>();
    String filterTrangThai = (String) request.getAttribute("filterTrangThai");
    String filterTuNgay    = (String) request.getAttribute("filterTuNgay");
    String filterDenNgay   = (String) request.getAttribute("filterDenNgay");
    String errorMsg        = (String) request.getAttribute("errorMsg");
    SimpleDateFormat sdf   = new SimpleDateFormat("dd/MM/yyyy HH:mm");

    if (filterTrangThai == null) filterTrangThai = "";
    if (filterTuNgay    == null) filterTuNgay    = "";
    if (filterDenNgay   == null) filterDenNgay   = "";

    String[] tenTrangThai   = {"", "Sắp diễn ra", "Đang họp", "Kết thúc", "Đã hủy"};
    String[] emojiTrangThai = {"", "📌", "🟢", "✅", "❌"};
    String[] tenMucDo       = {"", "Bình thường", "Quan trọng", "Khẩn cấp"};
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch Họp Tổ Dân Phố</title>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg:       #0f1117;
            --surface:  #181c27;
            --surface2: #1f2433;
            --surface3: #252a3a;
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
            position: fixed; top: 0; left: 0; right: 0; z-index: 100;
            height: 60px; background: rgba(15,17,23,.92);
            backdrop-filter: blur(16px); border-bottom: 1px solid var(--border);
            display: flex; align-items: center; padding: 0 28px; gap: 14px;
        }
        .back-btn {
            display: flex; align-items: center; gap: 7px;
            background: var(--surface2); border: 1px solid var(--border);
            color: var(--text); text-decoration: none;
            padding: 7px 14px; border-radius: 9px;
            font-size: 13px; font-weight: 600; transition: border-color .15s;
        }
        .back-btn:hover { border-color: var(--accent); }
        .topbar-div { width: 1px; height: 22px; background: var(--border); }
        .topbar-icon {
            width: 30px; height: 30px; border-radius: 8px;
            background: linear-gradient(135deg, var(--accent2), var(--accent));
            display: flex; align-items: center; justify-content: center; font-size: 15px;
        }
        .topbar-title { font-size: 15px; font-weight: 700; }
        .topbar-spacer { flex: 1; }
        .count-chip {
            background: var(--surface2); border: 1px solid var(--border);
            padding: 5px 14px; border-radius: 20px;
            font-size: 12px; font-weight: 600; color: var(--accent2);
        }

        /* ── LAYOUT 2 CỘT ── */
        .layout {
            display: grid;
            grid-template-columns: 340px 1fr;
            min-height: calc(100vh - 60px);
            margin-top: 60px;
        }

        /* ── PANEL TRÁI ── */
        .panel-left {
            border-right: 1px solid var(--border);
            display: flex; flex-direction: column;
            height: calc(100vh - 60px);
            position: sticky; top: 60px; overflow: hidden;
        }
        .filter-bar {
            padding: 14px 16px; border-bottom: 1px solid var(--border);
            background: var(--surface); flex-shrink: 0;
        }
        .filter-title {
            font-size: 11px; font-weight: 700; text-transform: uppercase;
            letter-spacing: .8px; color: var(--muted); margin-bottom: 10px;
        }
        .filter-bar form { display: flex; flex-direction: column; gap: 8px; }
        .filter-row { display: flex; gap: 8px; }
        .fg { display: flex; flex-direction: column; gap: 4px; flex: 1; }
        .fg label { font-size: 10px; font-weight: 700; text-transform: uppercase; letter-spacing: .6px; color: var(--muted); }
        .fg select, .fg input[type="date"] {
            background: var(--surface2); border: 1px solid var(--border);
            color: var(--text); padding: 7px 10px; border-radius: 8px;
            font-size: 12px; font-family: inherit; width: 100%;
        }
        .fg select:focus, .fg input:focus { outline: none; border-color: var(--accent); }
        .filter-actions { display: flex; gap: 8px; }
        .btn-loc {
            flex: 1; background: var(--accent); color: #fff; border: none;
            padding: 8px; border-radius: 8px; font-size: 12px; font-weight: 700;
            cursor: pointer; font-family: inherit;
        }
        .btn-loc:hover { background: #3a7de0; }
        .btn-reset {
            background: var(--surface2); border: 1px solid var(--border);
            color: var(--muted); padding: 8px 12px; border-radius: 8px;
            font-size: 13px; text-decoration: none; display: flex; align-items: center;
        }
        .btn-reset:hover { border-color: var(--muted); }

        .list-scroll {
            flex: 1; overflow-y: auto; padding: 12px;
            display: flex; flex-direction: column; gap: 8px;
        }
        .list-scroll::-webkit-scrollbar { width: 4px; }
        .list-scroll::-webkit-scrollbar-thumb { background: var(--border); border-radius: 4px; }

        /* Card danh sách */
        .lh-card {
            background: var(--surface); border: 1px solid var(--border);
            border-radius: 12px; overflow: hidden;
            text-decoration: none; color: var(--text);
            display: block; transition: border-color .15s, background .15s;
            position: relative;
        }
        .lh-card::before {
            content: ''; position: absolute; left: 0; top: 0; bottom: 0;
            width: 3px; border-radius: 3px 0 0 3px;
        }
        .lh-card.tt-1::before { background: #fbbf24; }
        .lh-card.tt-2::before { background: #10b981; }
        .lh-card.tt-3::before { background: #6b7280; }
        .lh-card.tt-4::before { background: #f75c5c; }
        .lh-card:hover, .lh-card.active { background: var(--surface2); border-color: var(--accent); }

        .lh-card-body { padding: 13px 14px 13px 17px; }
        .lh-card-top { display: flex; align-items: flex-start; justify-content: space-between; gap: 8px; margin-bottom: 6px; }
        .lh-card-title { font-size: 13px; font-weight: 700; line-height: 1.4; flex: 1; }
        .badge-tt { font-size: 10px; font-weight: 700; padding: 2px 8px; border-radius: 20px; white-space: nowrap; flex-shrink: 0; }
        .btt-1 { background: rgba(251,191,36,.15); color: #fbbf24; }
        .btt-2 { background: rgba(16,185,129,.15); color: #10b981; }
        .btt-3 { background: rgba(107,114,128,.15); color: #9ca3af; }
        .btt-4 { background: rgba(247,92,92,.15); color: #f75c5c; }
        .lh-card-meta { font-size: 11px; color: var(--muted); display: flex; flex-direction: column; gap: 3px; }
        .lh-card-meta span { display: flex; align-items: center; gap: 6px; }

        .empty-list {
            display: flex; flex-direction: column; align-items: center;
            justify-content: center; padding: 60px 20px;
            color: var(--muted); text-align: center; gap: 10px;
        }
        .empty-list .ei { font-size: 40px; }
        .empty-list p { font-size: 13px; }

        /* ── PANEL PHẢI ── */
        .panel-right { overflow-y: auto; padding: 32px; background: var(--bg); }
        .panel-right::-webkit-scrollbar { width: 6px; }
        .panel-right::-webkit-scrollbar-thumb { background: var(--border); border-radius: 4px; }

        /* Placeholder */
        .placeholder {
            display: flex; flex-direction: column; align-items: center;
            justify-content: center; min-height: 60vh; gap: 14px;
            color: var(--muted); text-align: center;
        }
        .placeholder .ph-icon { font-size: 60px; opacity: .25; animation: float 3s ease-in-out infinite; }
        @keyframes float { 0%,100%{transform:translateY(0)} 50%{transform:translateY(-10px)} }
        .placeholder h3 { font-size: 18px; font-weight: 700; color: var(--text); opacity: .3; }
        .placeholder p  { font-size: 13px; opacity: .4; }

        /* Detail card */
        .detail-card {
            background: var(--surface); border: 1px solid var(--border);
            border-radius: 18px; overflow: hidden;
            animation: fadeIn .2s ease;
        }
        @keyframes fadeIn { from{opacity:0;transform:translateY(10px)} to{opacity:1;transform:translateY(0)} }

        .detail-banner { padding: 28px 32px 24px; position: relative; overflow: hidden; }
        .detail-banner::after {
            content:''; position:absolute; right:-40px; top:-40px;
            width:200px; height:200px; border-radius:50%;
            background:rgba(255,255,255,.03); pointer-events:none;
        }
        .db-badges { display: flex; align-items: center; gap: 10px; margin-bottom: 14px; flex-wrap: wrap; }
        .db-badge-tt { font-size: 12px; font-weight: 700; padding: 5px 14px; border-radius: 20px; }
        .db-badge-md { font-size: 11px; font-weight: 700; padding: 4px 12px; border-radius: 20px; }
        .md-1 { background: rgba(56,217,169,.15); color: var(--accent2); }
        .md-2 { background: rgba(251,191,36,.15); color: var(--warn); }
        .md-3 { background: rgba(247,92,92,.15); color: var(--danger); }
        .db-to { font-size: 11px; color: var(--muted); }
        .detail-banner h1 { font-size: 22px; font-weight: 800; line-height: 1.35; }

        .detail-body { padding: 28px 32px; }

        .sec-heading {
            font-size: 11px; font-weight: 700; text-transform: uppercase;
            letter-spacing: 1px; color: var(--muted); margin-bottom: 12px;
            padding-bottom: 8px; border-bottom: 1px solid var(--border);
        }

        .time-row { display: flex; align-items: center; gap: 10px; flex-wrap: wrap; margin-bottom: 28px; }
        .time-block {
            background: var(--surface2); border: 1px solid var(--border);
            border-radius: 10px; padding: 10px 16px; text-align: center; flex: 1; min-width: 120px;
        }
        .tb-label { font-size: 10px; color: var(--muted); font-weight: 700; text-transform: uppercase; letter-spacing: .6px; }
        .tb-val   { font-size: 14px; font-weight: 700; margin-top: 4px; color: var(--accent2); }
        .time-arrow { color: var(--muted); font-size: 18px; flex-shrink: 0; }

        .info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 14px; margin-bottom: 28px; }
        .info-item { background: var(--surface2); border: 1px solid var(--border); border-radius: 12px; padding: 14px 16px; }
        .info-item.full { grid-column: 1 / -1; }
        .ii-label { font-size: 10px; font-weight: 700; text-transform: uppercase; letter-spacing: .7px; color: var(--muted); margin-bottom: 6px; }
        .ii-val   { font-size: 14px; font-weight: 600; line-height: 1.4; }

        .content-box {
            background: var(--surface2); border: 1px solid var(--border);
            border-radius: 12px; padding: 18px 20px;
            font-size: 14px; line-height: 1.75; white-space: pre-wrap;
        }
        .content-box.empty { color: var(--muted); font-style: italic; }

        .alert-bar {
            background: rgba(247,92,92,.1); border: 1px solid rgba(247,92,92,.25);
            border-radius: 12px; padding: 12px 16px; margin-bottom: 16px;
            color: var(--danger); font-size: 13px; font-weight: 500;
        }

        @media (max-width: 768px) {
            .layout { grid-template-columns: 1fr; }
            .panel-left { height: auto; position: static; }
            .info-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>

<header class="topbar">
    <a href="${pageContext.request.contextPath}/hodan/dashboard" class="back-btn">← Quay lại</a>
    <div class="topbar-div"></div>
    <div class="topbar-icon">📅</div>
    <div class="topbar-title">Lịch Họp Tổ Dân Phố</div>
    <div class="topbar-spacer"></div>
    <div class="count-chip"><%= danhSach != null ? danhSach.size() : 0 %> lịch họp</div>
</header>

<div class="layout">

    <!-- ══ PANEL TRÁI: DANH SÁCH ══ -->
    <aside class="panel-left">
        <div class="filter-bar">
            <div class="filter-title">🔍 Lọc lịch họp</div>
            <form method="get" action="${pageContext.request.contextPath}/nguoidan/lich-hop">
                <div class="filter-row">
                    <div class="fg">
                        <label>Trạng thái</label>
                        <select name="trangThai">
                            <option value="">Tất cả</option>
                            <option value="1" <%= "1".equals(filterTrangThai) ? "selected" : "" %>>📌 Sắp diễn ra</option>
                            <option value="2" <%= "2".equals(filterTrangThai) ? "selected" : "" %>>🟢 Đang họp</option>
                            <option value="3" <%= "3".equals(filterTrangThai) ? "selected" : "" %>>✅ Kết thúc</option>
                            <option value="4" <%= "4".equals(filterTrangThai) ? "selected" : "" %>>❌ Đã hủy</option>
                        </select>
                    </div>
                </div>
                <div class="filter-row">
                    <div class="fg">
                        <label>Từ ngày</label>
                        <input type="date" name="tuNgay" value="<%= filterTuNgay %>">
                    </div>
                    <div class="fg">
                        <label>Đến ngày</label>
                        <input type="date" name="denNgay" value="<%= filterDenNgay %>">
                    </div>
                </div>
                <div class="filter-actions">
                    <button type="submit" class="btn-loc">🔍 Lọc</button>
                    <a href="${pageContext.request.contextPath}/nguoidan/lich-hop" class="btn-reset">↺</a>
                </div>
            </form>
        </div>

        <div class="list-scroll">
            <% if (errorMsg != null) { %>
            <div class="alert-bar">⚠️ <%= errorMsg %></div>
            <% } %>

            <% if (danhSach == null || danhSach.isEmpty()) { %>
            <div class="empty-list">
                <div class="ei">📭</div>
                <p>Không có lịch họp nào phù hợp.</p>
            </div>
            <% } else {
                Integer selectedID = chiTiet != null ? (Integer) chiTiet.get("lichHopID") : null;
                for (Map<String, Object> lh : danhSach) {
                    int tt    = (Integer) lh.get("trangThai");
                    int mucDo = lh.get("mucDo") != null ? (Integer) lh.get("mucDo") : 1;
                    int id    = (Integer) lh.get("lichHopID");
                    Timestamp bd  = (Timestamp) lh.get("thoiGianBatDau");
                    boolean active = selectedID != null && selectedID == id;
            %>
            <a href="${pageContext.request.contextPath}/nguoidan/lich-hop?id=<%= id %>&trangThai=<%= filterTrangThai %>&tuNgay=<%= filterTuNgay %>&denNgay=<%= filterDenNgay %>"
               class="lh-card tt-<%= tt %> <%= active ? "active" : "" %>">
                <div class="lh-card-body">
                    <div class="lh-card-top">
                        <div class="lh-card-title"><%= lh.get("tieuDe") %></div>
                        <span class="badge-tt btt-<%= tt %>"><%= emojiTrangThai[tt] %> <%= tenTrangThai[tt] %></span>
                    </div>
                    <div class="lh-card-meta">
                        <span>📍 <%= lh.get("diaDiem") != null ? lh.get("diaDiem") : "Chưa xác định" %></span>
                        <span>🕐 <%= bd != null ? sdf.format(bd) : "---" %></span>
                        <% if (mucDo == 3) { %><span>🔴 Khẩn cấp</span>
                        <% } else if (mucDo == 2) { %><span>🟡 Quan trọng</span><% } %>
                    </div>
                </div>
            </a>
            <% } } %>
        </div>
    </aside>

    <!-- ══ PANEL PHẢI: CHI TIẾT ══ -->
    <main class="panel-right">
        <% if (chiTiet == null) { %>
        <div class="placeholder">
            <div class="ph-icon">📋</div>
            <h3>Chọn một lịch họp</h3>
            <p>Nhấn vào lịch họp bên trái để xem chi tiết</p>
        </div>

        <% } else {
            int tt    = (Integer) chiTiet.get("trangThai");
            int mucDo = chiTiet.get("mucDo") != null ? (Integer) chiTiet.get("mucDo") : 1;
            Timestamp bd  = (Timestamp) chiTiet.get("thoiGianBatDau");
            Timestamp kt  = (Timestamp) chiTiet.get("thoiGianKetThuc");
            String noiDung = (String) chiTiet.get("noiDung");

            String[] bannerBg = {"",
                "linear-gradient(135deg,#1a1200,#2d1f00)",
                "linear-gradient(135deg,#001a10,#002d1f)",
                "linear-gradient(135deg,#12141a,#1c2030)",
                "linear-gradient(135deg,#1a0000,#2d0000)"
            };
            String[] ttColors = {"","#fbbf24","#10b981","#6b7280","#f75c5c"};
        %>
        <div class="detail-card">

            <div class="detail-banner" style="background:<%= (tt>=1&&tt<=4) ? bannerBg[tt] : bannerBg[3] %>;">
                <div class="db-badges">
                    <span class="db-badge-tt"
                          style="background:rgba(255,255,255,.08);color:<%= (tt>=1&&tt<=4) ? ttColors[tt] : "#aaa" %>;">
                        <%= emojiTrangThai[tt] %> <%= tenTrangThai[tt] %>
                    </span>
                    <% if (mucDo >= 1 && mucDo <= 3) { %>
                    <span class="db-badge-md md-<%= mucDo %>"><%= tenMucDo[mucDo] %></span>
                    <% } %>
                    <% if (chiTiet.get("tenTo") != null) { %>
                    <span class="db-to">🏘 <%= chiTiet.get("tenTo") %></span>
                    <% } %>
                </div>
                <h1><%= chiTiet.get("tieuDe") %></h1>
            </div>

            <div class="detail-body">

                <div class="sec-heading">⏱ Thời gian</div>
                <div class="time-row">
                    <div class="time-block">
                        <div class="tb-label">Bắt đầu</div>
                        <div class="tb-val"><%= bd != null ? sdf.format(bd) : "---" %></div>
                    </div>
                    <% if (kt != null) { %>
                    <div class="time-arrow">→</div>
                    <div class="time-block">
                        <div class="tb-label">Kết thúc</div>
                        <div class="tb-val"><%= sdf.format(kt) %></div>
                    </div>
                    <% } %>
                </div>

                <div class="sec-heading" style="margin-top:4px;">📌 Thông tin</div>
                <div class="info-grid">
                    <div class="info-item">
                        <div class="ii-label">📍 Địa điểm</div>
                        <div class="ii-val"><%= chiTiet.get("diaDiem") != null ? chiTiet.get("diaDiem") : "Chưa xác định" %></div>
                    </div>
                    <div class="info-item">
                        <div class="ii-label">👤 Người tạo</div>
                        <div class="ii-val"><%= chiTiet.get("nguoiTao") %></div>
                    </div>
                    <% if (chiTiet.get("doiTuong") != null) { %>
                    <div class="info-item">
                        <div class="ii-label">👥 Đối tượng</div>
                        <div class="ii-val"><%= chiTiet.get("doiTuong") %></div>
                    </div>
                    <% } %>
                    <div class="info-item">
                        <div class="ii-label">📅 Ngày tạo</div>
                        <div class="ii-val"><%
                            Timestamp ngayTao = (Timestamp) chiTiet.get("ngayTao");
                            out.print(ngayTao != null ? sdf.format(ngayTao) : "---");
                        %></div>
                    </div>
                </div>

                <div class="sec-heading">📝 Nội dung cuộc họp</div>
                <div class="content-box <%= (noiDung == null || noiDung.trim().isEmpty()) ? "empty" : "" %>"><%=
                    (noiDung != null && !noiDung.trim().isEmpty()) ? noiDung : "Chưa có nội dung mô tả."
                %></div>

                <div class="sec-heading" style="margin-top:24px;">🕐 Lịch sử chỉnh sửa</div>
                <% if (lichSuSua.isEmpty()) { %>
                <div style="background:var(--surface2);border:1px solid var(--border);border-radius:12px;padding:24px;text-align:center;color:var(--muted);font-size:13px;">
                    📋 Lịch họp này chưa được chỉnh sửa lần nào.
                </div>
                <% } else { %>
                <div style="position:relative;padding-left:24px;display:flex;flex-direction:column;gap:0;">
                    <div style="position:absolute;left:7px;top:6px;bottom:6px;width:2px;background:var(--border);border-radius:2px;"></div>
                    <%
                    String[][] fields = {
                        {"tieuDe","Tiêu đề"},{"diaDiem","Địa điểm"},
                        {"thoiGianBatDau","Giờ bắt đầu"},{"thoiGianKetThuc","Giờ kết thúc"},
                        {"noiDung","Nội dung"},{"doiTuong","Đối tượng"},{"mucDo","Mức độ"}
                    };
                    for (Map<String, Object> ls : lichSuSua) {
                        Timestamp tgSua   = (Timestamp) ls.get("thoiGianSua");
                        String lyDo       = (String) ls.get("lyDoSua");
                        String snapshot   = (String) ls.get("noiDungThayDoi");
                        String nguoiSua_  = (String) ls.get("nguoiSua");
                        Map<String, Object> truoc_ = null, sau_ = null;
                        if (snapshot != null && snapshot.startsWith("{")) {
                            try {
                                ObjectMapper om_ = new ObjectMapper();
                                Map<String, Object> snap_ = om_.readValue(snapshot, Map.class);
                                truoc_ = (Map<String, Object>) snap_.get("truoc");
                                sau_   = (Map<String, Object>) snap_.get("sau");
                            } catch (Exception ignored_) {}
                        }
                    %>
                    <div style="position:relative;padding-bottom:18px;">
                        <div style="position:absolute;left:-21px;top:4px;width:14px;height:14px;border-radius:50%;background:var(--surface2);border:2px solid var(--accent);display:flex;align-items:center;justify-content:center;">
                            <div style="width:5px;height:5px;border-radius:50%;background:var(--accent);"></div>
                        </div>
                        <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:6px;flex-wrap:wrap;gap:4px;">
                            <span style="font-size:13px;font-weight:700;">👤 <%= nguoiSua_ != null ? nguoiSua_ : "---" %></span>
                            <span style="font-size:11px;color:var(--muted);"><%= tgSua != null ? sdf.format(tgSua) : "---" %></span>
                        </div>
                        <% if (lyDo != null && !lyDo.trim().isEmpty()) { %>
                        <div style="font-size:12px;color:var(--accent2);background:rgba(56,217,169,.08);border:1px solid rgba(56,217,169,.2);border-radius:7px;padding:5px 10px;margin-bottom:8px;font-style:italic;">
                            💬 "<%= lyDo %>"
                        </div>
                        <% } %>
                        <% if (truoc_ != null && sau_ != null) {
                            boolean coDiff_ = false;
                            for (String[] f_ : fields) {
                                String vT_ = truoc_.get(f_[0])!=null?truoc_.get(f_[0]).toString():"";
                                String vS_ = sau_.get(f_[0])!=null?sau_.get(f_[0]).toString():"";
                                if (!vT_.equals(vS_)) { coDiff_=true; break; }
                            }
                            if (coDiff_) { %>
                        <table style="width:100%;border-collapse:collapse;font-size:12px;margin-top:4px;">
                            <thead>
                                <tr>
                                    <th style="text-align:left;padding:6px 10px;background:var(--surface3);color:var(--muted);font-size:10px;font-weight:700;text-transform:uppercase;letter-spacing:.6px;border-radius:8px 0 0 0;">Trường</th>
                                    <th style="text-align:left;padding:6px 10px;background:var(--surface3);color:var(--muted);font-size:10px;font-weight:700;text-transform:uppercase;letter-spacing:.6px;">Trước</th>
                                    <th style="text-align:left;padding:6px 10px;background:var(--surface3);color:var(--muted);font-size:10px;font-weight:700;text-transform:uppercase;letter-spacing:.6px;border-radius:0 8px 0 0;">Sau</th>
                                </tr>
                            </thead>
                            <tbody>
                            <% for (String[] f_ : fields) {
                                String vT_ = truoc_.get(f_[0])!=null?truoc_.get(f_[0]).toString():"";
                                String vS_ = sau_.get(f_[0])!=null?sau_.get(f_[0]).toString():"";
                                if (!vT_.equals(vS_)) { %>
                                <tr>
                                    <td style="padding:7px 10px;border-top:1px solid var(--border);color:var(--muted);font-weight:600;"><%= f_[1] %></td>
                                    <td style="padding:7px 10px;border-top:1px solid var(--border);color:var(--danger);text-decoration:line-through;opacity:.8;"><%= vT_.isEmpty()?"—":vT_ %></td>
                                    <td style="padding:7px 10px;border-top:1px solid var(--border);color:var(--accent2);font-weight:600;"><%= vS_.isEmpty()?"—":vS_ %></td>
                                </tr>
                            <% } } %>
                            </tbody>
                        </table>
                        <% } } %>
                    </div>
                    <% } %>
                </div>
                <% } %>


            </div>
        </div>
        <% } %>
    </main>

</div>

<script>
    const active = document.querySelector('.lh-card.active');
    if (active) active.scrollIntoView({ block: 'center', behavior: 'smooth' });
</script>
</body>
</html>
