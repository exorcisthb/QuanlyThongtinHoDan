<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.Map" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch sử thông báo</title>
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
            border-bottom: 1px solid var(--border); display: flex; align-items: center;
            padding: 0 32px; gap: 16px;
        }
        .topbar-logo { display: flex; align-items: center; gap: 10px; text-decoration: none; color: var(--text); }
        .logo-icon { width: 34px; height: 34px; border-radius: 8px; background: linear-gradient(135deg, var(--accent), var(--accent2)); display: flex; align-items: center; justify-content: center; font-size: 16px; }
        .logo-text { font-size: 14px; font-weight: 700; }
        .logo-text span { color: var(--accent); }
        .topbar-divider { width: 1px; height: 24px; background: var(--border); }
        .breadcrumb { display: flex; align-items: center; gap: 6px; font-size: 13px; color: var(--muted); }
        .breadcrumb a { color: var(--muted); text-decoration: none; transition: color .15s; }
        .breadcrumb a:hover { color: var(--text); }
        .topbar-spacer { flex: 1; }
        .btn-mark-all { height: 34px; padding: 0 16px; border-radius: 8px; font-size: 12px; font-weight: 600; font-family: inherit; cursor: pointer; background: transparent; border: 1px solid var(--border); color: var(--muted); transition: all .15s; }
        .btn-mark-all:hover { border-color: var(--accent2); color: var(--accent2); }

        /* ── MAIN ── */
        .main { padding-top: 64px; }
        .content { max-width: 760px; margin: 0 auto; padding: 36px 32px; }

        .page-header { margin-bottom: 24px; display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 12px; }
        .page-header-left h1 { font-size: 22px; font-weight: 800; margin-bottom: 3px; display: flex; align-items: center; gap: 8px; }
        .page-header-left p { font-size: 13px; color: var(--muted); }
        .badge-count { display: inline-flex; align-items: center; justify-content: center; background: var(--danger); color: #fff; font-size: 11px; font-weight: 700; min-width: 22px; height: 22px; border-radius: 11px; padding: 0 6px; }

        .notif-list { display: flex; flex-direction: column; gap: 8px; }
        .notif-item { background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius); padding: 16px 20px; display: flex; gap: 14px; align-items: flex-start; cursor: pointer; transition: background .12s, border-color .12s; }
        .notif-item:hover { background: var(--surface2); border-color: var(--accent); }
        .notif-item.unread { border-left: 3px solid var(--accent); }
        .notif-dot { width: 9px; height: 9px; border-radius: 50%; background: var(--accent); flex-shrink: 0; margin-top: 5px; transition: background .2s; }
        .notif-dot.read { background: var(--border); }
        .notif-body { flex: 1; min-width: 0; }
        .notif-title { font-size: 14px; font-weight: 600; margin-bottom: 5px; line-height: 1.4; }
        .notif-item.read .notif-title { color: var(--muted); font-weight: 500; }
        .notif-preview { font-size: 12px; color: var(--muted); line-height: 1.5; margin-bottom: 6px; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }
        .notif-meta { display: flex; align-items: center; gap: 10px; flex-wrap: wrap; }
        .notif-time { font-size: 11px; color: var(--muted); }
        .notif-tag { font-size: 10px; font-weight: 700; padding: 2px 8px; border-radius: 100px; }
        .notif-tag.hop     { background: rgba(251,191,36,.12); color: var(--warn);    border: 1px solid rgba(251,191,36,.2); }
        .notif-tag.yeucau  { background: rgba(56,217,169,.12);  color: var(--accent2); border: 1px solid rgba(56,217,169,.2); }
        .notif-tag.lichHop { background: rgba(79,142,247,.12);  color: var(--accent);  border: 1px solid rgba(79,142,247,.2); }
        .notif-arrow { font-size: 13px; color: var(--accent); opacity: 0; transition: opacity .15s; flex-shrink: 0; margin-top: 3px; }
        .notif-item:hover .notif-arrow { opacity: 1; }

        .empty-state { text-align: center; padding: 72px 20px; }
        .empty-icon { font-size: 48px; margin-bottom: 16px; opacity: .5; }
        .empty-state h3 { font-size: 16px; font-weight: 700; margin-bottom: 6px; }
        .empty-state p { font-size: 13px; color: var(--muted); }

        /* ── MODAL ── */
        .modal-overlay { display: none; position: fixed; inset: 0; z-index: 999; background: rgba(0,0,0,.65); backdrop-filter: blur(6px); align-items: center; justify-content: center; }
        .modal-overlay.show { display: flex; animation: overlayIn .2s ease; }
        @keyframes overlayIn { from{opacity:0} to{opacity:1} }
        .modal { background: var(--surface); border: 1px solid var(--border); border-radius: 16px; width: 580px; max-width: calc(100vw - 32px); max-height: 88vh; overflow-y: auto; box-shadow: 0 24px 64px rgba(0,0,0,.6); animation: modalIn .22s cubic-bezier(.34,1.56,.64,1); }
        @keyframes modalIn { from{opacity:0;transform:scale(.93) translateY(12px)} to{opacity:1;transform:none} }
        .modal-hdr { display: flex; align-items: center; justify-content: space-between; padding: 20px 26px 16px; border-bottom: 1px solid var(--border); position: sticky; top: 0; background: var(--surface); z-index: 1; }
        .mhdr-left { display: flex; align-items: center; gap: 14px; }
        .mico { width: 46px; height: 46px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 20px; flex-shrink: 0; }
        .mico.warn  { background: rgba(251,191,36,.15); }
        .mico.green { background: rgba(56,217,169,.15); }
        .mico.red   { background: rgba(247,92,92,.15); }
        .mico.blue  { background: rgba(79,142,247,.15); }
        .mtitle { font-size: 16px; font-weight: 800; }
        .msub { font-size: 12px; color: var(--muted); margin-top: 2px; }
        .mclose { width: 32px; height: 32px; border-radius: 8px; border: 1px solid var(--border); background: var(--surface2); color: var(--muted); font-size: 16px; cursor: pointer; display: flex; align-items: center; justify-content: center; transition: all .18s; }
        .mclose:hover { border-color: var(--danger); color: var(--danger); }
        .modal-body { padding: 22px 26px; }
        .modal-footer { padding: 14px 26px 22px; display: flex; gap: 10px; justify-content: flex-end; border-top: 1px solid var(--border); }
        .sec-title { font-size: 10px; font-weight: 700; color: var(--muted); text-transform: uppercase; letter-spacing: .8px; margin-bottom: 12px; padding-bottom: 8px; border-bottom: 1px solid var(--border); }
        .dgrid { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; margin-bottom: 18px; }
        .dlbl { font-size: 11px; color: var(--muted); margin-bottom: 3px; font-weight: 600; }
        .dval { font-size: 14px; font-weight: 600; }
        .dval.mono { font-family: monospace; color: var(--accent); }
        .dval.muted { color: var(--muted); font-weight: 400; font-size: 13px; }
        .full { grid-column: 1/-1; }
        .pill { display: inline-block; font-size: 11px; font-weight: 600; padding: 3px 10px; border-radius: 20px; }
        .p-tt { background: rgba(56,217,169,.15); color: var(--accent2); }
        .p-tv { background: rgba(251,191,36,.15); color: var(--warn); }
        .p-tm { background: rgba(247,92,92,.15); color: var(--danger); }
        .form-group { margin-bottom: 14px; }
        .form-label { font-size: 11px; font-weight: 700; color: var(--muted); text-transform: uppercase; letter-spacing: .5px; margin-bottom: 8px; display: block; }
        .form-textarea { width: 100%; background: var(--surface2); border: 1px solid var(--border); color: var(--text); padding: 10px 14px; border-radius: 8px; font-size: 14px; font-family: inherit; resize: vertical; min-height: 88px; transition: border-color .18s; }
        .form-textarea:focus { outline: none; border-color: var(--accent); }
        .form-textarea.red:focus { border-color: var(--danger); }
        .skeleton { background: linear-gradient(90deg,var(--surface2) 25%,var(--border) 50%,var(--surface2) 75%); background-size: 200% 100%; animation: shimmer 1.2s infinite; border-radius: 6px; height: 14px; margin-bottom: 8px; }
        @keyframes shimmer { 0%{background-position:200% 0} 100%{background-position:-200% 0} }
        .btn-m { display: inline-flex; align-items: center; gap: 8px; padding: 9px 22px; border-radius: 8px; font-size: 13px; font-weight: 700; cursor: pointer; font-family: inherit; transition: all .18s; border: none; text-decoration: none; }
        .btn-cancel { background: var(--surface2); color: var(--muted); border: 1px solid var(--border); }
        .btn-cancel:hover { background: var(--surface); color: var(--text); }
        .btn-ok { background: rgba(56,217,169,.15); color: var(--accent2); border: 1px solid rgba(56,217,169,.3); }
        .btn-ok:hover { background: var(--accent2); color: #000; }
        .btn-no { background: rgba(247,92,92,.15); color: var(--danger); border: 1px solid rgba(247,92,92,.3); }
        .btn-no:hover { background: var(--danger); color: #fff; }
        .btn-goto { background: rgba(79,142,247,.15); color: var(--accent); border: 1px solid rgba(79,142,247,.3); }
        .btn-goto:hover { background: var(--accent); color: #fff; }
        .btn-m:disabled { opacity: .5; cursor: not-allowed; }
        .toast { position: fixed; bottom: 28px; right: 28px; z-index: 9999; padding: 13px 22px; border-radius: 10px; font-size: 13px; font-weight: 600; display: none; align-items: center; gap: 10px; box-shadow: 0 8px 32px rgba(0,0,0,.4); }
        .toast.show { display: flex; animation: slideUp .25s ease; }
        .toast.success { background: rgba(56,217,169,.15); border: 1px solid rgba(56,217,169,.4); color: var(--accent2); }
        .toast.error { background: rgba(247,92,92,.15); border: 1px solid rgba(247,92,92,.4); color: var(--danger); }
        @keyframes slideUp { from{opacity:0;transform:translateY(14px)} to{opacity:1;transform:translateY(0)} }
    </style>
</head>
<body>

<%
    List<Map<String, Object>> danhSachTB =
        (List<Map<String, Object>>) request.getAttribute("danhSachThongBao");
    Integer soChuaDoc = (Integer) request.getAttribute("soChuaDoc");
    String vaiTro     = (String)  request.getAttribute("vaiTro");
    if (danhSachTB == null) danhSachTB = new java.util.ArrayList<>();
    if (soChuaDoc  == null) soChuaDoc  = 0;
    if (vaiTro     == null) vaiTro     = "";
    String ctx = request.getContextPath();

    String dashUrl;
    switch (vaiTro) {
        case "Admin":       dashUrl = ctx + "/admin/dashboard";         break;
        case "ToTruong":    dashUrl = ctx + "/totruong/dashboard";      break;
        case "CanBoPhuong": dashUrl = ctx + "/canbophuong/dashboard";   break;
        default:            dashUrl = ctx + "/dashboard";               break;
    }
%>

<header class="topbar">
    <a href="<%= dashUrl %>" class="topbar-logo">
        <div class="logo-icon">🏘</div>
        <div class="logo-text">Cổng <span>Dịch Vụ</span></div>
    </a>
    <div class="topbar-divider"></div>
    <div class="breadcrumb">
        <a href="<%= dashUrl %>">Trang chủ</a>
        <span style="color:var(--muted)">›</span>
        <span style="color:var(--warn);font-weight:600">Thông báo</span>
    </div>
    <div class="topbar-spacer"></div>
    <% if (soChuaDoc > 0) { %>
    <button class="btn-mark-all" onclick="markAllRead()">✓ Đánh dấu tất cả đã đọc</button>
    <% } %>
</header>

<main class="main">
    <div class="content">
        <div class="page-header">
            <div class="page-header-left">
                <h1>
                    Thông báo
                    <% if (soChuaDoc > 0) { %>
                    <span class="badge-count" id="badgeCount"><%= soChuaDoc %></span>
                    <% } %>
                </h1>
                <p>Toàn bộ thông báo bạn đã nhận</p>
            </div>
        </div>

        <% if (danhSachTB.isEmpty()) { %>
        <div class="empty-state">
            <div class="empty-icon">📭</div>
            <h3>Chưa có thông báo nào</h3>
            <p>Các thông báo từ tổ trưởng và cán bộ phường sẽ hiện ở đây.</p>
        </div>
        <% } else { %>
        <div class="notif-list">
            <%
                for (Map<String, Object> tb : danhSachTB) {
                    boolean daDoc     = Boolean.TRUE.equals(tb.get("daDoc"));
                    String tieuDe     = String.valueOf(tb.get("tieuDe"));
                    String noiDung    = tb.get("noiDung") != null ? String.valueOf(tb.get("noiDung")) : "";
                    String preview    = noiDung.length() > 120 ? noiDung.substring(0, 120) + "…" : noiDung;
                    String ngayGui    = String.valueOf(tb.get("ngayGui"));
                    Object tbID       = tb.get("thongBaoID");
                    Object lichHopID  = tb.get("lichHopID");
                    Object thiepMoiID = tb.get("thiepMoiID");
                    String lichHopJs  = (lichHopID  != null) ? lichHopID.toString()  : "0";
                    String thiepMoiJs = (thiepMoiID != null) ? thiepMoiID.toString() : "0";
                    String tieuDeJs   = tieuDe.replace("\\","\\\\").replace("'","\\'");

                    String tagClass = "", tagText = "";
                    String tl = tieuDe.toLowerCase();
                    if (tl.contains("thông báo họp") || tl.contains("thiệp")
                        || tl.contains("tạm hoãn") || tl.contains("mở lại")
                        || tl.contains("[cập nhật]") || tl.contains("[hủy]")) {
                        tagClass = "hop"; tagText = "Họp tổ";
                    } else if (tl.contains("[lịch họp")) {
                        tagClass = "lichHop"; tagText = "Lịch họp";
                    } else if (tl.contains("yêu cầu") || tl.contains("duyệt") || tl.contains("từ chối")) {
                        tagClass = "yeucau"; tagText = "Yêu cầu";
                    }
            %>
            <div class="notif-item <%= daDoc ? "read" : "unread" %>"
                 id="notif-<%= tbID %>"
                 onclick="clickThongBao(<%= tbID %>, this, '<%= tieuDeJs %>', <%= lichHopJs %>, <%= thiepMoiJs %>)">
                <div class="notif-dot <%= daDoc ? "read" : "" %>" id="dot-<%= tbID %>"></div>
                <div class="notif-body">
                    <div class="notif-title"><%= tieuDe %></div>
                    <% if (!preview.isEmpty()) { %>
                    <div class="notif-preview"><%= preview %></div>
                    <% } %>
                    <div class="notif-meta">
                        <span class="notif-time"><%= ngayGui %></span>
                        <% if (!tagText.isEmpty()) { %>
                        <span class="notif-tag <%= tagClass %>"><%= tagText %></span>
                        <% } %>
                    </div>
                </div>
                <span class="notif-arrow">→</span>
            </div>
            <% } %>
        </div>
        <% } %>
    </div>
</main>

<!-- ── MODAL CHI TIẾT YÊU CẦU ── -->
<div class="modal-overlay" id="modalYeuCau" onclick="if(event.target===this)closeModal()">
    <div class="modal">
        <div class="modal-hdr">
            <div class="mhdr-left">
                <div class="mico warn" id="myc_ico">📋</div>
                <div>
                    <div class="mtitle" id="myc_title">Chi tiết yêu cầu</div>
                    <div class="msub"   id="myc_sub">—</div>
                </div>
            </div>
            <button class="mclose" onclick="closeModal()">✕</button>
        </div>
        <div class="modal-body" id="myc_body">
            <div id="myc_skeleton">
                <div class="skeleton" style="width:40%;height:10px;margin-bottom:14px"></div>
                <div style="display:grid;grid-template-columns:1fr 1fr;gap:12px;margin-bottom:18px">
                    <div><div class="skeleton" style="width:60%;height:10px"></div><div class="skeleton" style="height:14px;margin-top:4px"></div></div>
                    <div><div class="skeleton" style="width:60%;height:10px"></div><div class="skeleton" style="height:14px;margin-top:4px"></div></div>
                    <div><div class="skeleton" style="width:60%;height:10px"></div><div class="skeleton" style="height:14px;margin-top:4px"></div></div>
                    <div><div class="skeleton" style="width:60%;height:10px"></div><div class="skeleton" style="height:14px;margin-top:4px"></div></div>
                    <div style="grid-column:1/-1"><div class="skeleton" style="width:40%;height:10px"></div><div class="skeleton" style="height:14px;margin-top:4px;width:90%"></div></div>
                </div>
            </div>
            <div id="myc_content" style="display:none"></div>
        </div>
        <div class="modal-footer" id="myc_footer">
            <button class="btn-m btn-cancel" onclick="closeModal()">Đóng</button>
        </div>
    </div>
</div>

<div class="toast" id="toast"></div>

<script>
    const ctx    = '<%= ctx %>';
    const role   = '<%= vaiTro %>';
    var _activeYeuCauID = null;

    /* ── Click thông báo: đánh dấu đã đọc rồi quyết định mở modal hay redirect ── */
    function clickThongBao(id, el, tieuDe, lichHopID, thiepMoiID) {
        const t = (tieuDe || '').toLowerCase();

        // Nếu là yêu cầu → mở modal chi tiết
        const isYeuCau = t.includes('yêu cầu') || t.includes('duyệt') || t.includes('từ chối')
                      || t.includes('trạng thái') || t.includes('thông tin');

        // Đánh dấu đã đọc trước
        const wasUnread = el.classList.contains('unread');
        if (wasUnread) {
            fetch(ctx + '/thong-bao', {
                method: 'POST',
                headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                body: new URLSearchParams({action: 'doc', id: id}).toString(),
                credentials: 'include'
            }).then(r => r.json()).then(data => {
                if (data.success) {
                    el.classList.remove('unread');
                    el.classList.add('read');
                    const dot = document.getElementById('dot-' + id);
                    if (dot) dot.classList.add('read');
                    el.querySelector('.notif-title').style.fontWeight = '500';
                    // Cập nhật badge
                    const badge = document.getElementById('badgeCount');
                    if (badge) {
                        let cur = Math.max(0, (parseInt(badge.textContent) || 0) - 1);
                        if (cur === 0) badge.style.display = 'none';
                        else badge.textContent = cur;
                    }
                }
            }).catch(() => {});
        }

        if (isYeuCau) {
            openModalChiTiet(id);
        } else {
            // Họp tổ, lịch họp, v.v. → redirect như cũ
            chuyenTrang(tieuDe, lichHopID, thiepMoiID);
        }
    }

    /* ── Mở modal chi tiết yêu cầu ── */
    function openModalChiTiet(thongBaoID) {
        // Reset modal
        document.getElementById('myc_ico').textContent   = '📋';
        document.getElementById('myc_ico').className     = 'mico warn';
        document.getElementById('myc_title').textContent = 'Chi tiết yêu cầu';
        document.getElementById('myc_sub').textContent   = 'Đang tải...';
        document.getElementById('myc_skeleton').style.display = '';
        document.getElementById('myc_content').style.display  = 'none';
        document.getElementById('myc_footer').innerHTML =
            '<button class="btn-m btn-cancel" onclick="closeModal()">Đóng</button>';
        document.getElementById('modalYeuCau').classList.add('show');
        document.body.style.overflow = 'hidden';

        fetch(ctx + '/yeu-cau-doi-trang-thai?action=chitiet-notif&thongBaoID=' + thongBaoID, {credentials: 'include'})
            .then(r => r.json())
            .then(function(data) {
                if (!data || !data.yeuCauID) {
                    document.getElementById('myc_skeleton').style.display = 'none';
                    document.getElementById('myc_content').style.display  = '';
                    document.getElementById('myc_content').innerHTML =
                        '<div style="text-align:center;padding:32px;color:var(--muted);font-size:13px">Không tìm thấy yêu cầu liên quan.</div>';
                    return;
                }
                _activeYeuCauID = data.yeuCauID;
                renderModalChiTiet(data);
            })
            .catch(function(err) {
                document.getElementById('myc_skeleton').style.display = 'none';
                document.getElementById('myc_content').style.display  = '';
                document.getElementById('myc_content').innerHTML =
                    '<div style="text-align:center;padding:32px;color:var(--danger);font-size:13px">⚠ Lỗi: ' + err.message + '</div>';
            });
    }

    function closeModal() {
        document.getElementById('modalYeuCau').classList.remove('show');
        document.body.style.overflow = '';
    }

    /* ── Render nội dung modal ── */
    function renderModalChiTiet(d) {
        const isCho = d.trangThaiYeuCauID === 1;
        const loai  = d.loaiYeuCau || 1;

        document.getElementById('myc_skeleton').style.display = 'none';
        document.getElementById('myc_content').style.display  = '';

        if (loai === 2) {
            document.getElementById('myc_ico').textContent   = '👤';
            document.getElementById('myc_ico').className     = 'mico blue';
            document.getElementById('myc_title').textContent = 'Yêu cầu cập nhật thông tin cá nhân';
            document.getElementById('myc_sub').textContent   = 'Người gửi: ' + (d.tenNguoiYeuCau || '—');
        } else {
            document.getElementById('myc_ico').textContent   = '📋';
            document.getElementById('myc_ico').className     = 'mico warn';
            document.getElementById('myc_title').textContent = 'Yêu cầu đổi trạng thái cư trú';
            document.getElementById('myc_sub').textContent   = 'Mã hộ: ' + (d.maHoKhau || '—') + ' · ' + (d.tenTo || '');
        }

        var formHtml = '';
        if (isCho && (role === 'CanBoPhuong' || role === 'Admin')) {
            formHtml = '<div id="form-duyet" style="display:none">'
                + '<div class="sec-title">Ghi chú duyệt</div>'
                + '<div class="form-group"><label class="form-label">Ghi chú <span style="color:var(--muted);font-weight:400">(tuỳ chọn)</span></label>'
                + '<textarea class="form-textarea" id="inp_ghichu" placeholder="Nhập ghi chú nếu cần..."></textarea></div></div>'
                + '<div id="form-tuchoi" style="display:none">'
                + '<div class="sec-title">Lý do từ chối</div>'
                + '<div class="form-group"><label class="form-label">Lý do từ chối <span style="color:var(--danger)">*</span></label>'
                + '<textarea class="form-textarea red" id="inp_lydotc" placeholder="Bắt buộc nhập lý do từ chối..."></textarea></div></div>';
        }

        var contentHtml = '';
        if (loai === 1) {
            contentHtml =
                '<div class="sec-title">Thông tin hộ</div>'
                + '<div class="dgrid">'
                + '<div><div class="dlbl">Mã hộ khẩu</div><div class="dval mono">'  + orD(d.maHoKhau)  + '</div></div>'
                + '<div><div class="dlbl">Chủ hộ</div><div class="dval">'           + orD(d.tenChuHo)  + '</div></div>'
                + '<div><div class="dlbl">Tổ dân phố</div><div class="dval">'       + orD(d.tenTo)     + '</div></div>'
                + '<div><div class="dlbl">Địa chỉ</div><div class="dval muted">'    + orD(d.diaChiHo)  + '</div></div>'
                + '</div>'
                + '<div class="sec-title">Chi tiết yêu cầu</div>'
                + '<div class="dgrid">'
                + '<div><div class="dlbl">Trạng thái cũ</div>'    + pillH(d.trangThaiCuID,  d.tenTrangThaiCu)  + '</div>'
                + '<div><div class="dlbl">→ Trạng thái mới</div>' + pillH(d.trangThaiMoiID, d.tenTrangThaiMoi) + '</div>'
                + '<div class="full"><div class="dlbl">Lý do</div><div class="dval muted">'    + orD(d.lyDoYeuCau)     + '</div></div>'
                + '<div><div class="dlbl">Ngày gửi</div><div class="dval muted">'              + orD(d.ngayTao)        + '</div></div>'
                + '<div><div class="dlbl">Tổ trưởng gửi</div><div class="dval">'              + orD(d.tenNguoiYeuCau) + '</div></div>'
                + '</div>' + formHtml;
        } else {
            var fields = [
                {label:'Họ',cu:d.ho_Cu,moi:d.ho_Moi},{label:'Tên',cu:d.ten_Cu,moi:d.ten_Moi},
                {label:'Ngày sinh',cu:d.ngaySinh_Cu,moi:d.ngaySinh_Moi},
                {label:'Giới tính',cu:d.gioiTinh_Cu,moi:d.gioiTinh_Moi},
                {label:'Email',cu:d.email_Cu,moi:d.email_Moi},
                {label:'SĐT',cu:d.sDT_Cu,moi:d.sDT_Moi},
                {label:'CCCD',cu:d.cCCD_Cu,moi:d.cCCD_Moi}
            ];
            var rows = fields.filter(f=>f.moi&&f.moi!=='null').map(f=>
                '<tr><td style="color:var(--muted);font-size:12px;padding:8px 12px;border-bottom:1px solid var(--border)">'+esc(f.label)+'</td>'
                +'<td style="padding:8px 12px;border-bottom:1px solid var(--border);text-decoration:line-through;color:var(--muted)">'+orD(f.cu)+'</td>'
                +'<td style="padding:8px 12px;border-bottom:1px solid var(--border);color:var(--accent2);font-weight:600">→ '+orD(f.moi)+'</td></tr>'
            ).join('');
            contentHtml =
                '<div class="sec-title">Người gửi</div>'
                + '<div class="dgrid">'
                + '<div><div class="dlbl">Họ tên</div><div class="dval">'          + orD(d.tenNguoiYeuCau) + '</div></div>'
                + '<div><div class="dlbl">Ngày gửi</div><div class="dval muted">'  + orD(d.ngayTao)        + '</div></div>'
                + '<div class="full"><div class="dlbl">Lý do</div><div class="dval muted">' + orD(d.lyDoYeuCau) + '</div></div>'
                + '</div>'
                + '<div class="sec-title">Thông tin muốn thay đổi</div>'
                + '<table style="width:100%;border-collapse:collapse;font-size:13px;margin-bottom:18px"><thead><tr>'
                + '<th style="padding:8px 12px;text-align:left;color:var(--muted);font-size:11px;font-weight:700;border-bottom:1px solid var(--border)">Trường</th>'
                + '<th style="padding:8px 12px;text-align:left;color:var(--muted);font-size:11px;font-weight:700;border-bottom:1px solid var(--border)">Hiện tại</th>'
                + '<th style="padding:8px 12px;text-align:left;color:var(--muted);font-size:11px;font-weight:700;border-bottom:1px solid var(--border)">Muốn đổi</th>'
                + '</tr></thead><tbody>' + (rows || '<tr><td colspan="3" style="padding:16px;text-align:center;color:var(--muted)">Không có thông tin</td></tr>')
                + '</tbody></table>' + formHtml;
        }
        document.getElementById('myc_content').innerHTML = contentHtml;
        setModalFooter(isCho && (role === 'CanBoPhuong' || role === 'Admin') ? 'chitiet' : 'readonly');
    }

    function setModalFooter(state) {
        var el = document.getElementById('myc_footer');
        var urlYC = ctx + '/yeu-cau-doi-trang-thai';
        if (state === 'readonly') {
            el.innerHTML = '<button class="btn-m btn-cancel" onclick="closeModal()">Đóng</button>'
                + '<a href="' + urlYC + '" class="btn-m btn-goto">Xem tất cả →</a>';
        } else if (state === 'chitiet') {
            el.innerHTML = '<button class="btn-m btn-cancel" onclick="closeModal()">Đóng</button>'
                + '<a href="' + urlYC + '" class="btn-m btn-goto">Xem tất cả</a>'
                + '<button class="btn-m btn-no" onclick="switchState(\'tuchoi\')">✕ Từ chối</button>'
                + '<button class="btn-m btn-ok" onclick="switchState(\'duyet\')">✓ Duyệt</button>';
        } else if (state === 'duyet') {
            el.innerHTML = '<button class="btn-m btn-cancel" onclick="switchState(\'chitiet\')">← Quay lại</button>'
                + '<button class="btn-m btn-ok" onclick="submitDuyet()" id="btnConfirmDuyet">✓ Xác nhận duyệt</button>';
        } else if (state === 'tuchoi') {
            el.innerHTML = '<button class="btn-m btn-cancel" onclick="switchState(\'chitiet\')">← Quay lại</button>'
                + '<button class="btn-m btn-no" onclick="submitTuChoi()" id="btnConfirmTC">✕ Xác nhận từ chối</button>';
        } else {
            el.innerHTML = '<button class="btn-m btn-cancel" onclick="closeModal()">Đóng</button>';
        }
    }

    function switchState(state) {
        const fDuyet  = document.getElementById('form-duyet');
        const fTuChoi = document.getElementById('form-tuchoi');
        const isCapNhat = document.getElementById('myc_title').textContent.includes('cá nhân');
        if (state === 'duyet') {
            if (fDuyet)  fDuyet.style.display  = '';
            if (fTuChoi) fTuChoi.style.display = 'none';
            setModalFooter('duyet');
            document.getElementById('myc_ico').textContent = '✓';
            document.getElementById('myc_ico').className   = 'mico green';
            document.getElementById('myc_title').textContent = isCapNhat ? 'Duyệt cập nhật thông tin cá nhân' : 'Duyệt yêu cầu cư trú';
        } else if (state === 'tuchoi') {
            if (fDuyet)  fDuyet.style.display  = 'none';
            if (fTuChoi) fTuChoi.style.display = '';
            setModalFooter('tuchoi');
            document.getElementById('myc_ico').textContent = '✕';
            document.getElementById('myc_ico').className   = 'mico red';
            document.getElementById('myc_title').textContent = isCapNhat ? 'Từ chối cập nhật thông tin cá nhân' : 'Từ chối yêu cầu cư trú';
        } else {
            if (fDuyet)  fDuyet.style.display  = 'none';
            if (fTuChoi) fTuChoi.style.display = 'none';
            setModalFooter('chitiet');
            document.getElementById('myc_ico').textContent = isCapNhat ? '👤' : '📋';
            document.getElementById('myc_ico').className   = isCapNhat ? 'mico blue' : 'mico warn';
            document.getElementById('myc_title').textContent = isCapNhat ? 'Yêu cầu cập nhật thông tin cá nhân' : 'Yêu cầu đổi trạng thái cư trú';
        }
    }

    function submitDuyet() {
        if (!_activeYeuCauID) return;
        const ghiChu = (document.getElementById('inp_ghichu')?.value || '').trim();
        const btn = document.getElementById('btnConfirmDuyet');
        btn.disabled = true; btn.textContent = 'Đang xử lý...';
        fetch(ctx + '/yeu-cau-doi-trang-thai', {
            method: 'POST', headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: new URLSearchParams({action:'duyet', yeuCauID:_activeYeuCauID, ghiChu}).toString(),
            credentials: 'include'
        }).then(r=>r.json()).then(res=>{
            if (res.success) { closeModal(); showToast('success', '✓ ' + res.message); }
            else { btn.disabled=false; btn.textContent='✓ Xác nhận duyệt'; showToast('error','✕ ' + res.message); }
        }).catch(()=>{ btn.disabled=false; btn.textContent='✓ Xác nhận duyệt'; showToast('error','✕ Lỗi kết nối'); });
    }

    function submitTuChoi() {
        if (!_activeYeuCauID) return;
        const lyDoTC = (document.getElementById('inp_lydotc')?.value || '').trim();
        if (!lyDoTC) { showToast('error','⚠ Vui lòng nhập lý do từ chối.'); return; }
        const btn = document.getElementById('btnConfirmTC');
        btn.disabled = true; btn.textContent = 'Đang xử lý...';
        fetch(ctx + '/yeu-cau-doi-trang-thai', {
            method: 'POST', headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: new URLSearchParams({action:'tuchoi', yeuCauID:_activeYeuCauID, lyDoTuChoi:lyDoTC}).toString(),
            credentials: 'include'
        }).then(r=>r.json()).then(res=>{
            if (res.success) { closeModal(); showToast('success', '✓ ' + res.message); }
            else { btn.disabled=false; btn.textContent='✕ Xác nhận từ chối'; showToast('error','✕ ' + res.message); }
        }).catch(()=>{ btn.disabled=false; btn.textContent='✕ Xác nhận từ chối'; showToast('error','✕ Lỗi kết nối'); });
    }

    /* ── Redirect cho họp tổ, lịch họp ── */
    function chuyenTrang(tieuDe, lichHopID, thiepMoiID) {
        const t = (tieuDe || '').toLowerCase();
        if (t.includes('thông báo họp') || t.includes('thiệp') || t.includes('tạm hoãn')
            || t.includes('mở lại') || t.includes('[cập nhật]') || t.includes('[hủy]')) {
            if (role === 'HoDan' || role === '') {
                location.href = ctx + '/hodan/thiepmoi' + (thiepMoiID && thiepMoiID > 0 ? '?open=' + thiepMoiID : '');
            } else {
                location.href = ctx + '/thiepmoi/danh-sach';
            }
            return;
        }
        if (t.includes('lịch họp') || (lichHopID && lichHopID > 0)) {
            if (role === 'HoDan' || role === '') {
                location.href = ctx + '/nguoidan/lich-hop' + (lichHopID > 0 ? '?id=' + lichHopID : '');
            } else {
                location.href = ctx + '/lichhop/danh-sach';
            }
        }
    }

    function markAllRead() {
        fetch(ctx + '/thong-bao', {
            method: 'POST', headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: 'action=docTatCa', credentials: 'include'
        }).then(r=>r.json()).then(data=>{
            if (data.success) {
                document.querySelectorAll('.notif-item.unread').forEach(el=>{
                    el.classList.remove('unread'); el.classList.add('read');
                    const dot = el.querySelector('.notif-dot');
                    if (dot) dot.classList.add('read');
                });
                const badge = document.getElementById('badgeCount');
                if (badge) badge.style.display = 'none';
                const btn = document.querySelector('.btn-mark-all');
                if (btn) btn.style.display = 'none';
            }
        }).catch(console.error);
    }

    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') closeModal();
    });

    /* ── Helpers ── */
    function pillH(id, label) {
        const m = {1:'p-tt',2:'p-tv',3:'p-tm'};
        return '<span class="pill '+(m[id]||'p-tt')+'">'+esc(label||'—')+'</span>';
    }
    function orD(v) { return (v && v !== 'null') ? esc(String(v)) : '—'; }
    function esc(s) {
        return String(s||'').replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');
    }
    function showToast(type, msg) {
        const t = document.getElementById('toast');
        t.className = 'toast ' + type + ' show'; t.textContent = msg;
        clearTimeout(t._t); t._t = setTimeout(()=>t.classList.remove('show'), 3500);
    }
</script>
</body>
</html>
