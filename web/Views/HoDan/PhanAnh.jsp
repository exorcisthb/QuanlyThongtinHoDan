<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.Map" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Phản ánh / Kiến nghị</title>
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
            height: 64px; background: rgba(15,17,23,.88); backdrop-filter: blur(16px);
            border-bottom: 1px solid var(--border);
            display: flex; align-items: center; padding: 0 32px; gap: 16px;
        }
        .topbar-logo { display: flex; align-items: center; gap: 10px; text-decoration: none; color: var(--text); }
        .logo-icon { width: 34px; height: 34px; border-radius: 8px; background: linear-gradient(135deg,var(--accent),var(--accent2)); display: flex; align-items: center; justify-content: center; font-size: 16px; }
        .logo-text { font-size: 14px; font-weight: 700; }
        .logo-text span { color: var(--accent); }
        .topbar-divider { width: 1px; height: 24px; background: var(--border); }
        .breadcrumb { display: flex; align-items: center; gap: 6px; font-size: 13px; color: var(--muted); }
        .breadcrumb a { color: var(--muted); text-decoration: none; transition: color .15s; }
        .breadcrumb a:hover { color: var(--text); }
        .topbar-spacer { flex: 1; }
        .btn-new {
            height: 36px; padding: 0 18px; border-radius: 8px;
            background: var(--danger); color: #fff;
            font-size: 13px; font-weight: 700; font-family: inherit;
            border: none; cursor: pointer; display: flex; align-items: center; gap: 6px;
            transition: opacity .15s;
        }
        .btn-new:hover { opacity: .85; }

        /* ── MAIN ── */
        .main { padding-top: 64px; }
        .content { max-width: 900px; margin: 0 auto; padding: 36px 32px; }

        /* ── PAGE HEADER ── */
        .page-header { margin-bottom: 28px; display: flex; align-items: flex-start; justify-content: space-between; gap: 16px; flex-wrap: wrap; }
        .page-header-left h1 { font-size: 22px; font-weight: 800; margin-bottom: 4px; display: flex; align-items: center; gap: 10px; }
        .page-header-left p { font-size: 13px; color: var(--muted); }

        /* ── STAT CHIPS ── */
        .stats-row { display: flex; gap: 12px; margin-bottom: 24px; flex-wrap: wrap; }
        .stat-chip {
            background: var(--surface); border: 1px solid var(--border);
            border-radius: 10px; padding: 12px 18px;
            display: flex; align-items: center; gap: 10px; cursor: pointer;
            transition: border-color .15s;
        }
        .stat-chip:hover { border-color: var(--accent); }
        .stat-chip.active-filter { border-color: var(--accent); background: rgba(79,142,247,.08); }
        .sc-num { font-size: 20px; font-weight: 800; }
        .sc-num.all    { background: linear-gradient(135deg,var(--accent),var(--accent2)); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }
        .sc-num.cho    { color: var(--muted); }
        .sc-num.xu-ly  { color: var(--warn); }
        .sc-num.chuyen { color: var(--accent); }
        .sc-num.xong   { color: var(--accent2); }
        .sc-num.tu-choi{ color: var(--danger); }
        .sc-label { font-size: 11px; color: var(--muted); font-weight: 500; }

        /* ── FILTER BAR ── */
        .filter-bar { display: flex; align-items: center; gap: 8px; margin-bottom: 20px; flex-wrap: wrap; }
        .filter-tab {
            padding: 5px 14px; border-radius: 20px;
            border: 1px solid var(--border); background: var(--surface2);
            font-size: 12px; font-weight: 600; color: var(--muted);
            cursor: pointer; font-family: inherit; transition: all .15s;
        }
        .filter-tab:hover { border-color: var(--accent); color: var(--text); }
        .filter-tab.active { background: var(--accent); color: #fff; border-color: var(--accent); }

        /* ── DANH SÁCH PHẢN ÁNH ── */
        .pa-list { display: flex; flex-direction: column; gap: 12px; }

        .pa-card {
            background: var(--surface); border: 1px solid var(--border);
            border-radius: var(--radius); padding: 20px 22px;
            cursor: pointer; transition: border-color .15s, background .15s;
            position: relative; overflow: hidden;
        }
        .pa-card:hover { border-color: var(--accent); background: var(--surface2); }
        .pa-card.spam { opacity: .55; }

        /* Đường kẻ trái theo mức độ */
        .pa-card.muc-cao   { border-left: 3px solid var(--danger); }
        .pa-card.muc-tb    { border-left: 3px solid var(--warn); }
        .pa-card.muc-thap  { border-left: 3px solid var(--muted); }

        .pa-card-top { display: flex; align-items: flex-start; justify-content: space-between; gap: 12px; margin-bottom: 10px; }
        .pa-tieu-de { font-size: 15px; font-weight: 700; line-height: 1.4; flex: 1; }
        .pa-badges  { display: flex; align-items: center; gap: 6px; flex-shrink: 0; }

        .badge {
            display: inline-flex; align-items: center; gap: 4px;
            font-size: 10px; font-weight: 700; padding: 3px 9px;
            border-radius: 20px; white-space: nowrap;
        }
        .badge-cho    { background: rgba(100,116,139,.15); color: var(--muted);   border: 1px solid rgba(100,116,139,.25); }
        .badge-xuLy   { background: rgba(251,191,36,.12);  color: var(--warn);    border: 1px solid rgba(251,191,36,.25); }
        .badge-chuyen { background: rgba(79,142,247,.12);  color: var(--accent);  border: 1px solid rgba(79,142,247,.25); }
        .badge-xong   { background: rgba(56,217,169,.12);  color: var(--accent2); border: 1px solid rgba(56,217,169,.25); }
        .badge-tuChoi { background: rgba(247,92,92,.12);   color: var(--danger);  border: 1px solid rgba(247,92,92,.25); }
        .badge-spam   { background: rgba(247,92,92,.08);   color: var(--danger);  border: 1px solid rgba(247,92,92,.15); }
        .badge-huy    { background: rgba(100,116,139,.1);  color: var(--muted);   border: 1px solid rgba(100,116,139,.2); }

        .badge-loai   { background: rgba(79,142,247,.1);   color: var(--accent);  border: 1px solid rgba(79,142,247,.2); }
        .badge-cao    { background: rgba(247,92,92,.12);   color: var(--danger);  border: 1px solid rgba(247,92,92,.2); }
        .badge-tb     { background: rgba(251,191,36,.12);  color: var(--warn);    border: 1px solid rgba(251,191,36,.2); }
        .badge-thap   { background: rgba(100,116,139,.12); color: var(--muted);   border: 1px solid rgba(100,116,139,.2); }

        .pa-noi-dung {
            font-size: 13px; color: var(--muted); line-height: 1.6;
            display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;
            margin-bottom: 12px;
        }
        .pa-meta { display: flex; align-items: center; gap: 14px; flex-wrap: wrap; }
        .pa-meta-item { font-size: 11px; color: var(--muted); display: flex; align-items: center; gap: 4px; }
        .pa-anh-preview { display: flex; gap: 6px; margin-top: 10px; }
        .pa-anh-thumb {
            width: 52px; height: 52px; border-radius: 8px; object-fit: cover;
            border: 1px solid var(--border);
        }
        .pa-arrow { position: absolute; right: 20px; top: 50%; transform: translateY(-50%); font-size: 14px; color: var(--accent); opacity: 0; transition: opacity .15s; }
        .pa-card:hover .pa-arrow { opacity: 1; }

        /* ── EMPTY STATE ── */
        .empty-state { text-align: center; padding: 72px 20px; }
        .empty-icon { font-size: 52px; margin-bottom: 16px; opacity: .4; }
        .empty-state h3 { font-size: 17px; font-weight: 700; margin-bottom: 8px; }
        .empty-state p { font-size: 13px; color: var(--muted); margin-bottom: 24px; }

        /* ── MODAL CHI TIẾT ── */
        .modal-overlay {
            display: none; position: fixed; inset: 0; z-index: 999;
            background: rgba(0,0,0,.65); backdrop-filter: blur(6px);
            align-items: center; justify-content: center;
        }
        .modal-overlay.show { display: flex; animation: overlayIn .2s ease; }
        @keyframes overlayIn { from{opacity:0} to{opacity:1} }
        .modal {
            background: var(--surface); border: 1px solid var(--border);
            border-radius: 16px; width: 640px; max-width: calc(100vw - 32px);
            max-height: 90vh; display: flex; flex-direction: column;
            box-shadow: 0 24px 64px rgba(0,0,0,.6);
            animation: modalIn .22s cubic-bezier(.34,1.56,.64,1);
        }
        @keyframes modalIn { from{opacity:0;transform:scale(.93) translateY(12px)} to{opacity:1;transform:none} }
        .modal-hdr {
            padding: 20px 24px 16px; border-bottom: 1px solid var(--border);
            display: flex; align-items: center; justify-content: space-between;
            flex-shrink: 0;
        }
        .mhdr-left { display: flex; align-items: center; gap: 12px; }
        .mico { width: 44px; height: 44px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 20px; background: rgba(247,92,92,.15); flex-shrink: 0; }
        .mtitle { font-size: 16px; font-weight: 800; }
        .msub   { font-size: 12px; color: var(--muted); margin-top: 2px; }
        .mclose { width: 32px; height: 32px; border-radius: 8px; border: 1px solid var(--border); background: var(--surface2); color: var(--muted); font-size: 16px; cursor: pointer; display: flex; align-items: center; justify-content: center; transition: all .18s; }
        .mclose:hover { border-color: var(--danger); color: var(--danger); }
        .modal-body { padding: 22px 24px; overflow-y: auto; flex: 1; }
        .modal-body::-webkit-scrollbar { width: 4px; }
        .modal-body::-webkit-scrollbar-thumb { background: var(--border); border-radius: 2px; }
        .modal-footer { padding: 14px 24px 20px; border-top: 1px solid var(--border); display: flex; gap: 10px; justify-content: flex-end; flex-shrink: 0; }

        .sec-title { font-size: 10px; font-weight: 700; color: var(--muted); text-transform: uppercase; letter-spacing: .8px; margin-bottom: 12px; padding-bottom: 8px; border-bottom: 1px solid var(--border); }
        .dgrid { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; margin-bottom: 18px; }
        .dlbl  { font-size: 11px; color: var(--muted); margin-bottom: 3px; font-weight: 600; }
        .dval  { font-size: 13px; font-weight: 600; }
        .dval.muted { color: var(--muted); font-weight: 400; }
        .full  { grid-column: 1/-1; }

        /* Nội dung phản ánh */
        .noi-dung-box {
            background: var(--surface2); border: 1px solid var(--border);
            border-radius: 10px; padding: 14px 16px;
            font-size: 13px; color: var(--text); line-height: 1.7;
            white-space: pre-wrap; margin-bottom: 18px;
        }

        /* Ảnh */
        .anh-grid { display: flex; gap: 10px; flex-wrap: wrap; margin-bottom: 18px; }
        .anh-item {
            width: 100px; height: 100px; border-radius: 10px;
            object-fit: cover; border: 1px solid var(--border);
            cursor: zoom-in; transition: transform .15s;
        }
        .anh-item:hover { transform: scale(1.04); }

        /* Timeline lịch sử */
        .timeline { position: relative; padding-left: 24px; margin-bottom: 4px; }
        .timeline::before { content:''; position:absolute; left:7px; top:6px; bottom:0; width:2px; background:var(--border); }
        .tl-item { position: relative; margin-bottom: 16px; }
        .tl-dot { position:absolute; left:-24px; top:4px; width:14px; height:14px; border-radius:50%; border:2px solid var(--border); background:var(--surface2); display:flex; align-items:center; justify-content:center; font-size:8px; }
        .tl-dot.done  { background:var(--accent2); border-color:var(--accent2); }
        .tl-dot.warn  { background:var(--warn);    border-color:var(--warn); }
        .tl-dot.bad   { background:var(--danger);  border-color:var(--danger); }
        .tl-dot.blue  { background:var(--accent);  border-color:var(--accent); }
        .tl-title { font-size: 12px; font-weight: 700; margin-bottom: 2px; }
        .tl-body  { font-size: 12px; color: var(--muted); line-height: 1.5; }
        .tl-time  { font-size: 10px; color: var(--muted); margin-top: 3px; }

        /* Buttons */
        .btn-m { display: inline-flex; align-items: center; gap: 6px; padding: 8px 20px; border-radius: 8px; font-size: 13px; font-weight: 700; cursor: pointer; font-family: inherit; transition: all .18s; border: none; }
        .btn-cancel { background: var(--surface2); color: var(--muted); border: 1px solid var(--border); }
        .btn-cancel:hover { background: var(--surface); color: var(--text); }
        .btn-edit   { background: rgba(79,142,247,.15); color: var(--accent); border: 1px solid rgba(79,142,247,.3); }
        .btn-edit:hover { background: var(--accent); color: #fff; }
        .btn-huy    { background: rgba(247,92,92,.12); color: var(--danger); border: 1px solid rgba(247,92,92,.3); }
        .btn-huy:hover { background: var(--danger); color: #fff; }

        /* Toast */
        .toast { position:fixed; bottom:28px; right:28px; z-index:9999; padding:12px 20px; border-radius:10px; font-size:13px; font-weight:600; display:none; align-items:center; gap:10px; box-shadow:0 8px 32px rgba(0,0,0,.4); }
        .toast.show { display:flex; animation:slideUp .25s ease; }
        .toast.success { background:rgba(56,217,169,.15); border:1px solid rgba(56,217,169,.4); color:var(--accent2); }
        .toast.error   { background:rgba(247,92,92,.15);  border:1px solid rgba(247,92,92,.4);  color:var(--danger); }
        @keyframes slideUp { from{opacity:0;transform:translateY(14px)} to{opacity:1;transform:translateY(0)} }

        /* Lightbox ảnh */
        .lightbox { display:none; position:fixed; inset:0; z-index:1999; background:rgba(0,0,0,.92); align-items:center; justify-content:center; }
        .lightbox.show { display:flex; }
        .lightbox img { max-width:90vw; max-height:90vh; border-radius:10px; }
        .lightbox-close { position:absolute; top:20px; right:24px; color:#fff; font-size:28px; cursor:pointer; }

        @media(max-width:600px) { .dgrid { grid-template-columns:1fr; } }
    </style>
</head>
<body>

<%
    List<Map<String, Object>> danhSachPA =
        (List<Map<String, Object>>) request.getAttribute("danhSachPhanAnh");
    if (danhSachPA == null) danhSachPA = new java.util.ArrayList<>();
    String ctx = request.getContextPath();
%>

<header class="topbar">
    <a href="<%= ctx %>/hodan/dashboard" class="topbar-logo">
        <div class="logo-icon">🏘</div>
        <div class="logo-text">Cổng <span>Dịch Vụ</span></div>
    </a>
    <div class="topbar-divider"></div>
    <div class="breadcrumb">
        <a href="<%= ctx %>/hodan/dashboard">Trang chủ</a>
        <span>›</span>
        <span style="color:var(--danger);font-weight:600">Phản ánh / Kiến nghị</span>
    </div>
    <div class="topbar-spacer"></div>
    <button class="btn-new" onclick="location.href='<%= ctx %>/hodan/gui-phan-anh'">
        ＋ Gửi phản ánh mới
    </button>
</header>

<main class="main">
    <div class="content">

        <!-- PAGE HEADER -->
        <div class="page-header">
            <div class="page-header-left">
                <h1>💬 Phản ánh / Kiến nghị</h1>
                <p>Danh sách phản ánh bạn đã gửi đến tổ trưởng và cán bộ phường</p>
            </div>
        </div>

        <%
            // Tính số lượng theo trạng thái
            int totalAll = danhSachPA.size();
            int totalCho = 0, totalXuLy = 0, totalChuyen = 0, totalXong = 0, totalTuChoi = 0;
            for (Map<String, Object> pa : danhSachPA) {
                int tt = (int) pa.get("trangThaiID");
                if      (tt == 1) totalCho++;
                else if (tt == 2) totalXuLy++;
                else if (tt == 3) totalChuyen++;
                else if (tt == 4) totalXong++;
                else if (tt == 5) totalTuChoi++;
            }
        %>

        <!-- STAT CHIPS -->
        <div class="stats-row">
            <div class="stat-chip active-filter" onclick="filterPA('all', this)">
                <div><div class="sc-num all"><%= totalAll %></div><div class="sc-label">Tất cả</div></div>
            </div>
            <div class="stat-chip" onclick="filterPA('1', this)">
                <div><div class="sc-num cho"><%= totalCho %></div><div class="sc-label">Chờ tiếp nhận</div></div>
            </div>
            <div class="stat-chip" onclick="filterPA('2', this)">
                <div><div class="sc-num xu-ly"><%= totalXuLy %></div><div class="sc-label">Đang xử lý</div></div>
            </div>
            <div class="stat-chip" onclick="filterPA('3', this)">
                <div><div class="sc-num chuyen"><%= totalChuyen %></div><div class="sc-label">Chuyển cấp</div></div>
            </div>
            <div class="stat-chip" onclick="filterPA('4', this)">
                <div><div class="sc-num xong"><%= totalXong %></div><div class="sc-label">Đã giải quyết</div></div>
            </div>
            <div class="stat-chip" onclick="filterPA('5', this)">
                <div><div class="sc-num tu-choi"><%= totalTuChoi %></div><div class="sc-label">Từ chối</div></div>
            </div>
        </div>

        <!-- FILTER TABS theo mức độ -->
        <div class="filter-bar">
            <span style="font-size:11px;color:var(--muted);font-weight:600;">Mức độ:</span>
            <button class="filter-tab active" onclick="filterMucDo('all', this)">Tất cả</button>
            <button class="filter-tab" onclick="filterMucDo('3', this)">🔴 Cao</button>
            <button class="filter-tab" onclick="filterMucDo('2', this)">🟡 Trung bình</button>
            <button class="filter-tab" onclick="filterMucDo('1', this)">⚪ Thấp</button>
        </div>

        <!-- DANH SÁCH -->
        <% if (danhSachPA.isEmpty()) { %>
        <div class="empty-state">
            <div class="empty-icon">📭</div>
            <h3>Chưa có phản ánh nào</h3>
            <p>Bạn chưa gửi phản ánh nào. Hãy gửi phản ánh đầu tiên của bạn!</p>
            <button class="btn-new" onclick="location.href='<%= ctx %>/hodan/gui-phan-anh'" style="margin:0 auto;">
                ＋ Gửi phản ánh mới
            </button>
        </div>
        <% } else { %>
        <div class="pa-list" id="paList">
            <%
                for (Map<String, Object> pa : danhSachPA) {
                    int    phanAnhID  = (int)    pa.get("phanAnhID");
                    String tieuDe     = String.valueOf(pa.get("tieuDe"));
                    String noiDung    = pa.get("noiDung") != null ? String.valueOf(pa.get("noiDung")) : "";
                    int    trangThaiID= (int)    pa.get("trangThaiID");
                    String tenTT      = String.valueOf(pa.get("tenTrangThai"));
                    String tenLoai    = String.valueOf(pa.get("tenLoai"));
                    int    mucDo      = (int)    pa.get("mucDoUuTien");
                    boolean daChuyenCap = (boolean) pa.get("daChuyenCap");
                    boolean isSpam    = (boolean) pa.get("isSpam");
                    String ngayTao    = String.valueOf(pa.get("ngayTao"));

                    // Badge trạng thái
                    String badgeClass, badgeText;
                    switch (trangThaiID) {
                        case 1: badgeClass="badge-cho";     badgeText="Chờ tiếp nhận"; break;
                        case 2: badgeClass="badge-xuLy";    badgeText="Đang xử lý";    break;
                        case 3: badgeClass="badge-chuyen";  badgeText="Chuyển cấp trên"; break;
                        case 4: badgeClass="badge-xong";    badgeText="Đã giải quyết"; break;
                        case 5: badgeClass="badge-tuChoi";  badgeText="Từ chối";        break;
                        case 6: badgeClass="badge-spam";    badgeText="Spam";           break;
                        case 7: badgeClass="badge-huy";     badgeText="Đã hủy";         break;
                        default: badgeClass="badge-cho";    badgeText=tenTT;
                    }

                    // Badge mức độ
                    String mucDoClass, mucDoText, cardMucDoClass;
                    switch (mucDo) {
                        case 3: mucDoClass="badge-cao"; mucDoText="🔴 Cao";       cardMucDoClass="muc-cao"; break;
                        case 1: mucDoClass="badge-thap"; mucDoText="⚪ Thấp";     cardMucDoClass="muc-thap"; break;
                        default: mucDoClass="badge-tb"; mucDoText="🟡 Trung bình"; cardMucDoClass="muc-tb";
                    }

                    String tieuDeJs = tieuDe.replace("\\","\\\\").replace("'","\\'");
            %>
            <div class="pa-card <%= cardMucDoClass %> <%= isSpam ? "spam" : "" %>"
                 data-tt="<%= trangThaiID %>"
                 data-muc="<%= mucDo %>"
                 onclick="xemChiTiet(<%= phanAnhID %>)">

                <div class="pa-card-top">
                    <div class="pa-tieu-de"><%= tieuDe %></div>
                    <div class="pa-badges">
                        <span class="badge <%= badgeClass %>"><%= badgeText %></span>
                        <span class="badge badge-loai"><%= tenLoai %></span>
                        <span class="badge <%= mucDoClass %>"><%= mucDoText %></span>
                    </div>
                </div>

                <div class="pa-noi-dung"><%= noiDung %></div>

                <div class="pa-meta">
                    <span class="pa-meta-item">🕐 <%= ngayTao %></span>
                    <% if (daChuyenCap) { %>
                    <span class="pa-meta-item" style="color:var(--accent)">⬆ Đã chuyển cán bộ</span>
                    <% } %>
                </div>
                <span class="pa-arrow">→</span>
            </div>
            <% } %>
        </div>
        <% } %>
    </div>
</main>

<!-- ── MODAL CHI TIẾT ── -->
<div class="modal-overlay" id="modalChiTiet" onclick="if(event.target===this)closeModal()">
    <div class="modal">
        <div class="modal-hdr">
            <div class="mhdr-left">
                <div class="mico" id="mIco">💬</div>
                <div>
                    <div class="mtitle" id="mTitle">Chi tiết phản ánh</div>
                    <div class="msub"   id="mSub">—</div>
                </div>
            </div>
            <button class="mclose" onclick="closeModal()">✕</button>
        </div>
        <div class="modal-body" id="mBody">
            <div id="mSkeleton" style="padding:8px 0">
                <div style="height:12px;width:40%;background:var(--surface2);border-radius:6px;margin-bottom:10px;animation:shimmer 1.2s infinite"></div>
                <div style="height:12px;width:70%;background:var(--surface2);border-radius:6px;margin-bottom:10px;animation:shimmer 1.2s infinite"></div>
                <div style="height:80px;background:var(--surface2);border-radius:10px;animation:shimmer 1.2s infinite"></div>
            </div>
            <div id="mContent" style="display:none"></div>
        </div>
        <div class="modal-footer" id="mFooter">
            <button class="btn-m btn-cancel" onclick="closeModal()">Đóng</button>
        </div>
    </div>
</div>


<!-- ── MODAL XÁC NHẬN HỦY ── -->
<div class="huy-overlay" id="modalHuy" onclick="if(event.target===this)closeHuy()">
    <div class="huy-box">
        <div class="huy-hdr">
            <div class="huy-ico">🗑</div>
            <div>
                <div class="huy-title">Hủy phản ánh</div>
                <div class="huy-sub">Hành động này không thể hoàn tác</div>
            </div>
        </div>
        <div class="huy-body">
            <label class="huy-label">Lý do hủy <span style="color:var(--danger)">*</span></label>
            <textarea class="huy-textarea" id="huyLyDo"
                      placeholder="Nhập lý do bạn muốn hủy phản ánh này..."></textarea>
            <div class="huy-err" id="huyErr">Vui lòng nhập lý do hủy.</div>
        </div>
        <div class="huy-footer">
            <button class="btn-m btn-cancel" onclick="closeHuy()">Không, giữ lại</button>
            <button class="btn-m btn-huy" id="btnConfirmHuy" onclick="confirmHuy()">🗑 Xác nhận hủy</button>
        </div>
    </div>
</div>

<!-- Lightbox ảnh -->
<div class="lightbox" id="lightbox" onclick="this.classList.remove('show')">
    <span class="lightbox-close">✕</span>
    <img id="lightboxImg" src="" alt="">
</div>

<style>

        /* ── MODAL HỦY ── */
        .huy-overlay { display:none; position:fixed; inset:0; z-index:1100; background:rgba(0,0,0,.7); backdrop-filter:blur(6px); align-items:center; justify-content:center; }
        .huy-overlay.show { display:flex; animation:overlayIn .2s ease; }
        .huy-box { background:var(--surface); border:1px solid var(--border); border-radius:16px; width:440px; max-width:calc(100vw - 32px); box-shadow:0 24px 64px rgba(0,0,0,.6); animation:modalIn .22s cubic-bezier(.34,1.56,.64,1); overflow:hidden; }
        .huy-hdr { padding:20px 24px 16px; display:flex; align-items:center; gap:12px; border-bottom:1px solid var(--border); }
        .huy-ico { width:44px; height:44px; border-radius:12px; background:rgba(247,92,92,.15); display:flex; align-items:center; justify-content:center; font-size:20px; flex-shrink:0; }
        .huy-title { font-size:16px; font-weight:800; }
        .huy-sub   { font-size:12px; color:var(--muted); margin-top:2px; }
        .huy-body  { padding:20px 24px; }
        .huy-label { font-size:11px; font-weight:700; color:var(--muted); text-transform:uppercase; letter-spacing:.5px; margin-bottom:8px; display:block; }
        .huy-textarea { width:100%; background:var(--surface2); border:1px solid var(--border); color:var(--text); padding:10px 14px; border-radius:10px; font-size:14px; font-family:inherit; resize:none; height:90px; transition:border-color .18s; outline:none; line-height:1.6; }
        .huy-textarea:focus { border-color:var(--danger); box-shadow:0 0 0 3px rgba(247,92,92,.1); }
        .huy-textarea.err { border-color:var(--danger); }
        .huy-err { font-size:11px; color:var(--danger); margin-top:5px; display:none; }
        .huy-err.show { display:block; }
        .huy-footer { padding:14px 24px 20px; border-top:1px solid var(--border); display:flex; gap:10px; justify-content:flex-end; }

        @keyframes shimmer {
    0%  { opacity: 1; }
    50% { opacity: .4; }
    100%{ opacity: 1; }
}
</style>

<div class="toast" id="toast"></div>

<script>
    const CTX = '<%= ctx %>';
    let _activePA = null;

    // ── FILTER THEO TRẠNG THÁI ──
    function filterPA(tt, el) {
        document.querySelectorAll('.stats-row .stat-chip').forEach(c => c.classList.remove('active-filter'));
        if (el) el.classList.add('active-filter');
        document.querySelectorAll('.pa-card').forEach(card => {
            const match = tt === 'all' || card.dataset.tt === tt;
            card.style.display = match && checkMucDo(card) ? '' : 'none';
        });
    }

    // ── FILTER THEO MỨC ĐỘ ──
    let _curMucDo = 'all';
    function filterMucDo(muc, el) {
        _curMucDo = muc;
        document.querySelectorAll('.filter-bar .filter-tab').forEach(b => b.classList.remove('active'));
        if (el) el.classList.add('active');
        document.querySelectorAll('.pa-card').forEach(card => {
            const matchMuc = muc === 'all' || card.dataset.muc === muc;
            card.style.display = matchMuc ? '' : 'none';
        });
    }

    function checkMucDo(card) {
        return _curMucDo === 'all' || card.dataset.muc === _curMucDo;
    }

    // ── XEM CHI TIẾT ──
    function xemChiTiet(phanAnhID) {
        _activePA = phanAnhID;
        // Reset modal
        document.getElementById('mTitle').textContent = 'Đang tải...';
        document.getElementById('mSub').textContent   = '';
        document.getElementById('mSkeleton').style.display = '';
        document.getElementById('mContent').style.display  = 'none';
        document.getElementById('mFooter').innerHTML =
            '<button class="btn-m btn-cancel" onclick="closeModal()">Đóng</button>';
        document.getElementById('modalChiTiet').classList.add('show');
        document.body.style.overflow = 'hidden';

        fetch(CTX + '/hodan/phan-anh?action=chiTiet&id=' + phanAnhID, {credentials:'include'})
            .then(r => r.json())
            .then(data => {
                if (!data || !data.phanAnhID) {
                    showError('Không tìm thấy phản ánh.');
                    return;
                }
                renderChiTiet(data);
            })
            .catch(err => showError('Lỗi: ' + err.message));
    }

    function renderChiTiet(d) {
        document.getElementById('mTitle').textContent = d.tieuDe || 'Chi tiết phản ánh';
        document.getElementById('mSub').textContent   = d.tenLoai + ' · ' + (d.tenMucDo || '');
        document.getElementById('mSkeleton').style.display = 'none';
        document.getElementById('mContent').style.display  = '';

        const tt = d.trangThaiID;

        // ── Nội dung chi tiết ──
        let html = '';

        // Thông tin chính
        html += '<div class="sec-title">Thông tin phản ánh</div>';
        html += '<div class="dgrid">';
        html += '<div><div class="dlbl">Loại</div><div class="dval">' + esc(d.tenLoai) + '</div></div>';
        html += '<div><div class="dlbl">Mức độ</div><div class="dval">' + esc(d.tenMucDo) + '</div></div>';
        html += '<div><div class="dlbl">Trạng thái</div><div class="dval">' + badgeHtml(tt, d.tenTrangThai) + '</div></div>';
        html += '<div><div class="dlbl">Ngày gửi</div><div class="dval muted">' + esc(d.ngayTao) + '</div></div>';
        if (d.tenNguoiXuLy) {
            html += '<div><div class="dlbl">Người xử lý</div><div class="dval">' + esc(d.tenNguoiXuLy) + '</div></div>';
        }
        html += '</div>';

        // Nội dung
        html += '<div class="sec-title">Nội dung</div>';
        html += '<div class="noi-dung-box">' + esc(d.noiDung) + '</div>';

        // Ảnh đính kèm
        if (d.danhSachAnh && d.danhSachAnh.length > 0) {
            html += '<div class="sec-title">Ảnh đính kèm</div>';
            html += '<div class="anh-grid">';
            d.danhSachAnh.forEach(a => {
                html += '<img class="anh-item" src="' + CTX + '/' + esc(a.duongDan) + '" '
                      + 'onclick="xemAnh(event, \'' + esc(a.duongDan) + '\')" alt="Ảnh phản ánh">';
            });
            html += '</div>';
        }

        // Lý do từ chối / hủy
        if (d.lyDoTuChoiHuy) {
            html += '<div class="sec-title">Lý do</div>';
            html += '<div class="noi-dung-box" style="color:var(--danger)">' + esc(d.lyDoTuChoiHuy) + '</div>';
        }

        // Lịch sử xử lý
        if (d.lichSuXuLy && d.lichSuXuLy.length > 0) {
            html += '<div class="sec-title">Lịch sử xử lý</div>';
            html += '<div class="timeline">';
            d.lichSuXuLy.forEach(log => {
                const dotClass = dotClassFromHanhDong(log.hanhDong);
                html += '<div class="tl-item">';
                html += '<div class="tl-dot ' + dotClass + '"></div>';
                html += '<div class="tl-title">' + tenHanhDong(log.hanhDong) + '</div>';
                if (log.ghiChu) html += '<div class="tl-body">' + esc(log.ghiChu) + '</div>';
                html += '<div class="tl-time">👤 ' + esc(log.tenNguoiThucHien) + ' &nbsp;·&nbsp; 🕐 ' + esc(log.thoiGian) + '</div>';
                html += '</div>';
            });
            html += '</div>';
        }

        document.getElementById('mContent').innerHTML = html;

        // Footer buttons — chỉ hiện nếu được phép
        renderFooter(tt, d.daChuyenCap);
    }

    function renderFooter(tt, daChuyenCap) {
        let html = '<button class="btn-m btn-cancel" onclick="closeModal()">Đóng</button>';
        // Được sửa: mọi trạng thái trừ 4,5,6,7
        if (tt !== 4 && tt !== 5 && tt !== 6 && tt !== 7) {
            html += '<button class="btn-m btn-edit" onclick="suaPhanAnh(' + _activePA + ')">✏ Sửa</button>';
        }
        // Được hủy: chỉ khi chưa chuyển cấp và chưa kết thúc
        if (!daChuyenCap && tt !== 4 && tt !== 5 && tt !== 6 && tt !== 7) {
            html += '<button class="btn-m btn-huy" onclick="huyPhanAnh(' + _activePA + ')">🗑 Hủy</button>';
        }
        document.getElementById('mFooter').innerHTML = html;
    }

    // ── HỦY PHẢN ÁNH ──
    let _huyID = null;
    function huyPhanAnh(id) {
        _huyID = id;
        document.getElementById('huyLyDo').value = '';
        document.getElementById('huyErr').classList.remove('show');
        document.getElementById('huyLyDo').classList.remove('err');
        document.getElementById('modalHuy').classList.add('show');
        document.body.style.overflow = 'hidden';
        setTimeout(() => document.getElementById('huyLyDo').focus(), 100);
    }
    function closeHuy() {
        document.getElementById('modalHuy').classList.remove('show');
        document.body.style.overflow = '';
    }
    function confirmHuy() {
        const lyDo = document.getElementById('huyLyDo').value.trim();
        if (!lyDo) {
            document.getElementById('huyErr').classList.add('show');
            document.getElementById('huyLyDo').classList.add('err');
            return;
        }
        const btn = document.getElementById('btnConfirmHuy');
        btn.disabled = true; btn.textContent = 'Đang xử lý...';
        fetch(CTX + '/hodan/phan-anh', {
            method: 'POST', headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: new URLSearchParams({action:'huy', phanAnhID: _huyID, lyDo: lyDo}).toString(),
            credentials: 'include'
        }).then(r => r.json()).then(res => {
            btn.disabled = false; btn.textContent = '🗑 Xác nhận hủy';
            if (res.success) {
                closeHuy();
                closeModal();
                showToast('success', '✓ ' + res.message);
                setTimeout(() => location.reload(), 1200);
            } else {
                showToast('error', '✕ ' + res.message);
            }
        }).catch(() => {
            btn.disabled = false; btn.textContent = '🗑 Xác nhận hủy';
            showToast('error', '✕ Lỗi kết nối');
        });
    }

    // ── SỬA PHẢN ÁNH ──
    function suaPhanAnh(id) {
        closeModal();
        location.href = CTX + '/hodan/sua-phan-anh?id=' + id;
    }

    // ── LIGHTBOX ──
    function xemAnh(e, duongDan) {
        e.stopPropagation();
        document.getElementById('lightboxImg').src = CTX + '/' + duongDan;
        document.getElementById('lightbox').classList.add('show');
    }

    function closeModal() {
        document.getElementById('modalChiTiet').classList.remove('show');
        document.body.style.overflow = '';
    }

    function showError(msg) {
        document.getElementById('mSkeleton').style.display = 'none';
        document.getElementById('mContent').style.display  = '';
        document.getElementById('mContent').innerHTML =
            '<div style="text-align:center;padding:32px;color:var(--danger);font-size:13px">⚠ ' + msg + '</div>';
    }

    document.addEventListener('keydown', e => { if (e.key === 'Escape') closeModal(); });

    // ── HELPERS ──
    function badgeHtml(tt, tenTT) {
        const map = {
            1:['badge-cho','Chờ tiếp nhận'], 2:['badge-xuLy','Đang xử lý'],
            3:['badge-chuyen','Chuyển cấp trên'], 4:['badge-xong','Đã giải quyết'],
            5:['badge-tuChoi','Từ chối'], 6:['badge-spam','Spam'], 7:['badge-huy','Đã hủy']
        };
        const [cls, lbl] = map[tt] || ['badge-cho', tenTT];
        return '<span class="badge ' + cls + '">' + lbl + '</span>';
    }
    function dotClassFromHanhDong(h) {
        return {GIAI_QUYET:'done', TIEP_NHAN:'blue', CHUYEN_CAP:'blue',
                TU_CHOI:'bad', SPAM:'bad', HUY:'bad', CHINH_SUA:'warn', THU_HOI:'warn', BINH_LUAN:''}[h] || '';
    }
    function tenHanhDong(h) {
        return {TIEP_NHAN:'Tiếp nhận', CHUYEN_CAP:'Chuyển cấp trên', GIAI_QUYET:'Đã giải quyết',
                TU_CHOI:'Từ chối', SPAM:'Đánh dấu spam', HUY:'Hộ dân hủy',
                CHINH_SUA:'Hộ dân chỉnh sửa', THU_HOI:'Thu hồi', BINH_LUAN:'Bình luận'}[h] || h;
    }
    function esc(s) {
        return String(s||'').replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');
    }
    function showToast(type, msg) {
        const t = document.getElementById('toast');
        t.className = 'toast ' + type + ' show'; t.textContent = msg;
        clearTimeout(t._t); t._t = setTimeout(() => t.classList.remove('show'), 3500);
    }
</script>
</body>
</html>
