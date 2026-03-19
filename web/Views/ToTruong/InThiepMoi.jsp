<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>In thiệp mời</title>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root{--bg:#0f1117;--surface:#181c27;--surface2:#1f2433;--border:#2a3048;
            --accent:#4f8ef7;--accent2:#38d9a9;--danger:#f75c5c;--warn:#fbbf24;
            --text:#e2e8f0;--muted:#64748b;--radius:14px}
        *{box-sizing:border-box;margin:0;padding:0}
        body{font-family:'Be Vietnam Pro',sans-serif;background:var(--bg);color:var(--text);min-height:100vh}

        /* TOPBAR — ẩn khi in */
        .topbar{position:fixed;top:0;left:0;right:0;z-index:200;height:60px;
            background:rgba(15,17,23,.95);backdrop-filter:blur(16px);
            border-bottom:1px solid var(--border);display:flex;align-items:center;padding:0 24px;gap:14px}
        .logo{display:flex;align-items:center;gap:8px;text-decoration:none;color:var(--text)}
        .logo-icon{width:30px;height:30px;border-radius:7px;
            background:linear-gradient(135deg,var(--accent),var(--accent2));
            display:flex;align-items:center;justify-content:center;font-size:14px}
        .logo-text{font-size:13px;font-weight:700}.logo-text span{color:var(--accent)}
        .divider{width:1px;height:20px;background:var(--border)}
        .breadcrumb{display:flex;align-items:center;gap:5px;font-size:12px;color:var(--muted)}
        .breadcrumb a{color:var(--muted);text-decoration:none}.breadcrumb a:hover{color:var(--text)}
        .breadcrumb .cur{color:var(--warn);font-weight:600}
        .spacer{flex:1}

        /* LAYOUT */
        .main{padding-top:60px;display:flex;height:calc(100vh - 60px);overflow:hidden}

        /* CỘT TRÁI — CÀI ĐẶT IN */
        .print-panel{width:300px;flex-shrink:0;border-right:1px solid var(--border);
            background:var(--surface);overflow-y:auto;padding:20px 16px}
        .panel-title{font-size:11px;font-weight:700;text-transform:uppercase;
            letter-spacing:.08em;color:var(--muted);margin-bottom:16px}

        .setting-group{margin-bottom:20px}
        .setting-label{font-size:11px;font-weight:700;color:var(--muted);
            text-transform:uppercase;letter-spacing:.06em;margin-bottom:8px;display:block}
        .setting-label span{color:var(--text);font-weight:400;text-transform:none;letter-spacing:0}

        input[type=number],select{
            width:100%;padding:9px 12px;background:var(--surface2);
            border:1px solid var(--border);border-radius:8px;
            font-size:13px;color:var(--text);font-family:inherit;outline:none;
            transition:border-color .15s}
        input[type=number]:focus,select:focus{border-color:var(--warn)}
        select option{background:var(--surface2)}

        .qty-wrap{display:flex;align-items:center;gap:8px}
        .qty-btn{width:32px;height:32px;border-radius:7px;border:1px solid var(--border);
            background:var(--surface2);color:var(--text);font-size:18px;cursor:pointer;
            display:flex;align-items:center;justify-content:center;transition:all .15s;flex-shrink:0}
        .qty-btn:hover{border-color:var(--warn);color:var(--warn)}
        .qty-input{text-align:center;font-size:16px;font-weight:700}

        .layout-grid{display:grid;grid-template-columns:1fr 1fr;gap:8px}
        .layout-opt{padding:10px 8px;border-radius:8px;border:1.5px solid var(--border);
            background:var(--surface2);cursor:pointer;transition:all .15s;text-align:center}
        .layout-opt:hover{border-color:var(--warn)}
        .layout-opt.active{border-color:var(--warn);background:rgba(251,191,36,.1)}
        .layout-opt .lo-icon{font-size:20px;margin-bottom:4px}
        .layout-opt .lo-name{font-size:11px;font-weight:700;color:var(--text)}
        .layout-opt .lo-sub{font-size:10px;color:var(--muted)}

        .divider-line{border:none;border-top:1px solid var(--border);margin:16px 0}

        .info-box{background:var(--surface2);border:1px solid var(--border);
            border-radius:8px;padding:12px;font-size:12px;line-height:1.8}
        .info-box .ib-row{display:flex;justify-content:space-between}
        .info-box .ib-label{color:var(--muted)}
        .info-box .ib-val{font-weight:600;color:var(--text)}

        .btn-print{width:100%;padding:12px;border-radius:9px;border:none;
            background:var(--warn);color:#000;font-size:14px;font-weight:800;
            cursor:pointer;font-family:inherit;transition:all .15s;margin-top:16px;
            display:flex;align-items:center;justify-content:center;gap:8px}
        .btn-print:hover{background:#f0b429;transform:translateY(-1px)}
        .btn-back{width:100%;padding:10px;border-radius:9px;
            border:1px solid var(--border);background:transparent;
            color:var(--muted);font-size:13px;font-weight:600;
            cursor:pointer;font-family:inherit;transition:all .15s;margin-top:8px;
            text-decoration:none;display:flex;align-items:center;justify-content:center;gap:6px}
        .btn-back:hover{border-color:var(--text);color:var(--text)}

        /* CỘT PHẢI — PREVIEW */
        .preview-area{flex:1;overflow-y:auto;background:var(--surface2);padding:24px;
            display:flex;flex-direction:column;align-items:center;gap:20px}
        .preview-label{font-size:11px;font-weight:700;text-transform:uppercase;
            letter-spacing:.08em;color:var(--muted);margin-bottom:8px;
            width:100%;max-width:680px}

        /* THIỆP THỰC — dùng khi in */
        .thiep{background:#fff;color:#1a1a2e;border-radius:4px;
            font-family:'Be Vietnam Pro',sans-serif;position:relative;
            box-shadow:0 4px 24px rgba(0,0,0,.4)}

        /* Kích thước theo layout */
        .thiep.a4-1{width:680px;padding:40px 48px}
        .thiep.a4-2{width:320px;padding:24px 28px}
        .thiep.a5-1{width:500px;padding:28px 36px}
        .thiep.a5-2{width:240px;padding:18px 22px}

        .thiep-quoc-hieu{text-align:center;font-size:11px;font-weight:600;
            color:#666;text-transform:uppercase;letter-spacing:.05em;margin-bottom:2px}
        .thiep-doc-lap{text-align:center;font-size:12px;font-weight:700;
            color:#444;margin-bottom:16px;padding-bottom:12px;border-bottom:1.5px solid #ddd}
        .thiep-title{text-align:center;font-size:28px;font-weight:800;
            color:#c8901a;letter-spacing:2px;margin-bottom:6px}
        .thiep-subtitle{text-align:center;font-size:14px;font-weight:600;
            color:#222;margin-bottom:20px}
        .thiep-row{display:flex;gap:8px;padding:8px 0;
            border-bottom:1px solid #f0f0f0;font-size:13px}
        .thiep-row:last-of-type{border:none}
        .thiep-lbl{color:#888;min-width:120px;font-weight:600;flex-shrink:0}
        .thiep-val{color:#111;font-weight:500;line-height:1.6}
        .thiep-footer{text-align:center;margin-top:20px;padding-top:16px;
            border-top:1px solid #e8e8e8;font-size:12px;color:#888;font-style:italic}
        .thiep-sign{display:flex;justify-content:flex-end;margin-top:32px}
        .thiep-sign-box{text-align:center;min-width:180px}
        .thiep-sign-title{font-size:13px;font-weight:700;margin-bottom:48px}
        .thiep-sign-name{font-size:14px;font-weight:800}

        /* Nhỏ hơn cho layout 2 cột */
        .thiep.a4-2 .thiep-title,.thiep.a5-2 .thiep-title{font-size:20px}
        .thiep.a4-2 .thiep-subtitle,.thiep.a5-2 .thiep-subtitle{font-size:12px}
        .thiep.a4-2 .thiep-row,.thiep.a5-2 .thiep-row{font-size:11px}
        .thiep.a4-2 .thiep-lbl,.thiep.a5-2 .thiep-lbl{min-width:90px}
        .thiep.a4-2 .thiep-sign-title,.thiep.a5-2 .thiep-sign-title{margin-bottom:32px}

        /* ===== PRINT STYLES ===== */
        @media print {
            body *{visibility:hidden}
            .print-content,.print-content *{visibility:visible}
            .print-content{
                position:fixed;inset:0;
                background:#fff;
                display:flex;
                flex-wrap:wrap;
                align-items:flex-start;
                padding:10mm;
                gap:8mm;
            }
            .thiep{
                box-shadow:none!important;
                border-radius:0!important;
                page-break-inside:avoid;
            }
            /* 1 thiệp/trang */
            .print-1up .thiep{width:190mm;padding:20mm}
            /* 2 thiệp/trang ngang */
            .print-2up .thiep{width:93mm;padding:12mm}
            /* A5 1 thiệp/trang */
            .print-a5-1up .thiep{width:138mm;padding:15mm}
            /* A5 2 thiệp/trang */
            .print-a5-2up .thiep{width:67mm;padding:8mm}
        }
    </style>
</head>
<body>

<header class="topbar">
    <a href="${pageContext.request.contextPath}/dashboard" class="logo">
        <div class="logo-icon">🏘</div>
        <div class="logo-text">Quản lý <span>Hộ dân</span></div>
    </a>
    <div class="divider"></div>
    <div class="breadcrumb">
        <a href="${pageContext.request.contextPath}/thiepmoi/danh-sach">Thiệp mời</a> ›
        <a href="${pageContext.request.contextPath}/thiepmoi/chi-tiet?id=${thiep.thiepMoiID}">Chi tiết</a> ›
        <span class="cur">In thiệp</span>
    </div>
    <div class="spacer"></div>
</header>

<div class="main">

    <!-- CÀI ĐẶT IN -->
    <div class="print-panel">
        <div class="panel-title">⚙️ Cài đặt in</div>

        <!-- Số lượng -->
        <div class="setting-group">
            <span class="setting-label">Số lượng bản in</span>
            <div class="qty-wrap">
                <button class="qty-btn" onclick="changeQty(-1)">−</button>
                <input type="number" id="soLuong" class="qty-input" value="1" min="1" max="999"
                       oninput="updateInfo()">
                <button class="qty-btn" onclick="changeQty(1)">+</button>
            </div>
        </div>

        <!-- Khổ giấy -->
        <div class="setting-group">
            <span class="setting-label">Khổ giấy</span>
            <select id="khoGiay" onchange="updateLayout()">
                <option value="a4">A4 (210 × 297 mm)</option>
                <option value="a5">A5 (148 × 210 mm)</option>
            </select>
        </div>

        <!-- Bố cục -->
        <div class="setting-group">
            <span class="setting-label">Bố cục trang</span>
            <div class="layout-grid">
                <div class="layout-opt active" onclick="selectLayout(this,'1up')" data-layout="1up">
                    <div class="lo-icon">📄</div>
                    <div class="lo-name">1 thiệp/trang</div>
                    <div class="lo-sub">In to, rõ ràng</div>
                </div>
                <div class="layout-opt" onclick="selectLayout(this,'2up')" data-layout="2up">
                    <div class="lo-icon">📑</div>
                    <div class="lo-name">2 thiệp/trang</div>
                    <div class="lo-sub">Tiết kiệm giấy</div>
                </div>
            </div>
        </div>

        <hr class="divider-line">

        <!-- Thông tin tóm tắt -->
        <div class="info-box">
            <div class="ib-row"><span class="ib-label">Số lượng</span><span class="ib-val" id="infoSoLuong">1 bản</span></div>
            <div class="ib-row"><span class="ib-label">Khổ giấy</span><span class="ib-val" id="infoKho">A4</span></div>
            <div class="ib-row"><span class="ib-label">Bố cục</span><span class="ib-val" id="infoBoCuc">1 thiệp/trang</span></div>
            <div class="ib-row"><span class="ib-label">Số tờ cần</span><span class="ib-val" id="infoSoTo">1 tờ</span></div>
        </div>

        <button class="btn-print" onclick="doPrint()">🖨️ In ngay</button>
        <a href="${pageContext.request.contextPath}/thiepmoi/chi-tiet?id=${thiep.thiepMoiID}" class="btn-back">← Quay lại</a>
    </div>

    <!-- PREVIEW -->
    <div class="preview-area" id="previewArea">
        <div class="preview-label">Xem trước — cuộn để xem tất cả bản in</div>
        <div id="printContent" class="print-content"></div>
    </div>
</div>

<%-- Dữ liệu thiệp truyền sang JS --%>
<script>
const THIEP = {
    tieuDe:   '${thiep.tieuDe}',
    diaDiem:  '${thiep.diaDiem}',
    noiDung:  `${thiep.noiDung}`,
    nguoiTao: '${thiep.tenNguoiTao}',
    tenTo:    '${thiep.tenTo}',
    tgbd:     '<fmt:formatDate value="${thiep.thoiGianBatDau}" pattern="HH:mm — dd/MM/yyyy"/>',
    tgkt:     '<c:choose><c:when test="${not empty thiep.thoiGianKetThuc}"><fmt:formatDate value="${thiep.thoiGianKetThuc}" pattern="HH:mm — dd/MM/yyyy"/></c:when><c:otherwise></c:otherwise></c:choose>'
};

let currentLayout = '1up';
let currentKho    = 'a4';

function row(lbl, val) {
    return '<div class="thiep-row"><span class="thiep-lbl">' + lbl + '</span><span class="thiep-val">' + val + '</span></div>';
}

function thiepHTML(cls) {
    var html = '';
    html += '<div class="thiep ' + cls + '">';
    html += '<div class="thiep-quoc-hieu">Cộng hòa Xã hội Chủ nghĩa Việt Nam</div>';
    html += '<div class="thiep-doc-lap">Độc lập — Tự do — Hạnh phúc</div>';
    html += '<div class="thiep-title">THIỆP MỜI</div>';
    html += '<div class="thiep-subtitle">' + THIEP.tieuDe + '</div>';
    html += row('🏘 Tổ dân phố:', THIEP.tenTo);
    html += row('🕐 Thời gian:', THIEP.tgbd);
    if (THIEP.tgkt) html += row('⏱ Kết thúc:', THIEP.tgkt);
    html += row('📍 Địa điểm:', THIEP.diaDiem || '—');
    html += '<div class="thiep-row"><span class="thiep-lbl">📋 Nội dung:</span><span class="thiep-val" style="white-space:pre-line">' + (THIEP.noiDung || '—') + '</span></div>';
    html += '<div class="thiep-footer">Kính mời quý hộ dân có mặt đúng giờ. Trân trọng!</div>';
    html += '<div class="thiep-sign"><div class="thiep-sign-box">';
    html += '<div class="thiep-sign-title">Tổ trưởng tổ dân phố</div>';
    html += '<div class="thiep-sign-name">' + THIEP.nguoiTao + '</div>';
    html += '</div></div></div>';
    return html;
}

function getCls() {
    return currentKho + '-' + (currentLayout === '1up' ? '1' : '2');
}

function renderPreview() {
    const qty = parseInt(document.getElementById('soLuong').value) || 1;
    const cls = getCls();
    let html = '';
    for (let i = 0; i < Math.min(qty, 20); i++) html += thiepHTML(cls); // preview tối đa 20
    if (qty > 20) html += `<div style="color:var(--muted);font-size:13px;padding:20px;text-align:center">... và ${qty - 20} bản nữa khi in</div>`;
    document.getElementById('printContent').innerHTML = html;
    updateInfo();
}

function updateInfo() {
    const qty    = parseInt(document.getElementById('soLuong').value) || 1;
    const perPg  = currentLayout === '2up' ? 2 : 1;
    const sheets = Math.ceil(qty / perPg);
    document.getElementById('infoSoLuong').textContent = qty + ' bản';
    document.getElementById('infoKho').textContent     = currentKho.toUpperCase();
    document.getElementById('infoBoCuc').textContent   = currentLayout === '2up' ? '2 thiệp/trang' : '1 thiệp/trang';
    document.getElementById('infoSoTo').textContent    = sheets + ' tờ';
    renderPreview();
}

function selectLayout(el, layout) {
    document.querySelectorAll('.layout-opt').forEach(o => o.classList.remove('active'));
    el.classList.add('active');
    currentLayout = layout;
    updateInfo();
}

function updateLayout() {
    currentKho = document.getElementById('khoGiay').value;
    updateInfo();
}

function changeQty(delta) {
    const el  = document.getElementById('soLuong');
    const val = Math.max(1, Math.min(999, (parseInt(el.value) || 1) + delta));
    el.value  = val;
    updateInfo();
}

function doPrint() {
    // Render đủ số lượng trước khi in
    const qty = parseInt(document.getElementById('soLuong').value) || 1;
    const cls = getCls();
    const printClass = 'print-' + currentKho + '-' + (currentLayout === '2up' ? '2up' : '1up');
    let html = '';
    for (let i = 0; i < qty; i++) html += thiepHTML(cls);
    const pc = document.getElementById('printContent');
    pc.innerHTML = html;
    pc.className = 'print-content ' + printClass;
    setTimeout(() => window.print(), 150);
}

// Khởi tạo
renderPreview();
</script>
</body>
</html>
