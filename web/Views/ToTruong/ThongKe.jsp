<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thống kê tổ dân phố</title>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg:#0f1117;--surface:#181c27;--surface2:#1f2433;--border:#2a3048;
            --accent:#4f8ef7;--accent2:#38d9a9;--danger:#f75c5c;--warn:#fbbf24;
            --purple:#a78bfa;--pink:#f472b6;
            --text:#e2e8f0;--muted:#64748b;--radius:14px;
        }
        *,*::before,*::after{box-sizing:border-box;margin:0;padding:0;}
        body{font-family:'Be Vietnam Pro',sans-serif;background:var(--bg);color:var(--text);min-height:100vh;}

        /* ── TOPBAR ── */
        .topbar{position:fixed;top:0;left:0;right:0;z-index:200;height:60px;
            background:rgba(15,17,23,.95);backdrop-filter:blur(16px);
            border-bottom:1px solid var(--border);
            display:flex;align-items:center;padding:0 24px;gap:14px;}
        .back-btn{display:flex;align-items:center;gap:7px;text-decoration:none;
            color:var(--muted);font-size:13px;font-weight:500;
            padding:6px 12px;border-radius:8px;border:1px solid var(--border);
            background:var(--surface2);transition:all .18s;white-space:nowrap;}
        .back-btn:hover{color:var(--text);border-color:var(--accent);}
        .topbar-info{display:flex;flex-direction:column;}
        .topbar-title{font-size:14px;font-weight:700;line-height:1.2;}
        .topbar-sub{font-size:11px;color:var(--muted);}
        .topbar-sub strong{color:var(--accent2);}
        .topbar-spacer{flex:1;}
        .year-form{display:flex;align-items:center;gap:8px;}
        .year-form label{font-size:12px;color:var(--muted);font-weight:500;}
        .year-select{background:var(--surface2);border:1px solid var(--border);
            color:var(--text);font-family:inherit;font-size:13px;font-weight:600;
            padding:6px 12px;border-radius:8px;cursor:pointer;outline:none;transition:border-color .18s;}
        .year-select:hover{border-color:var(--accent);}

        /* ── LAYOUT ── */
        .page{display:flex;padding-top:60px;min-height:100vh;}

        /* ── SIDEBAR ── */
        .sidebar{width:220px;flex-shrink:0;background:var(--surface);
            border-right:1px solid var(--border);
            position:fixed;top:60px;left:0;bottom:0;overflow-y:auto;padding:16px 12px;}
        .sidebar-section{font-size:10px;font-weight:700;text-transform:uppercase;
            letter-spacing:1.2px;color:var(--muted);padding:8px 10px 6px;margin-top:8px;}
        .sidebar-section:first-child{margin-top:0;}
        .tab-item{display:flex;align-items:center;gap:10px;padding:10px 12px;
            border-radius:10px;cursor:pointer;font-size:13px;font-weight:500;
            color:var(--muted);transition:all .15s;margin-bottom:2px;border:none;
            background:none;width:100%;text-align:left;font-family:inherit;}
        .tab-item:hover{background:var(--surface2);color:var(--text);}
        .tab-item.active{background:rgba(79,142,247,.15);color:var(--accent);font-weight:600;}
        .tab-item.active .tab-icon{opacity:1;}
        .tab-icon{font-size:16px;width:20px;text-align:center;opacity:.7;}
        .tab-badge{margin-left:auto;background:var(--surface2);border:1px solid var(--border);
            font-size:10px;font-weight:700;padding:1px 7px;border-radius:10px;color:var(--muted);}
        .tab-item.active .tab-badge{background:rgba(79,142,247,.2);border-color:rgba(79,142,247,.3);color:var(--accent);}

        /* ── MAIN CONTENT ── */
        .main-content{margin-left:220px;flex:1;padding:28px 28px 60px;}

        /* ── TAB PANELS ── */
        .tab-panel{display:none;}
        .tab-panel.active{display:block;}

        /* ── PANEL HEADER ── */
        .panel-header{margin-bottom:24px;}
        .panel-title{font-size:20px;font-weight:800;margin-bottom:4px;}
        .panel-sub{font-size:13px;color:var(--muted);}

        /* ── KPI ROW ── */
        .kpi-row{display:grid;gap:12px;margin-bottom:24px;}
        .kpi-row.col-2{grid-template-columns:repeat(2,1fr);}
        .kpi-row.col-3{grid-template-columns:repeat(3,1fr);}
        .kpi-row.col-4{grid-template-columns:repeat(4,1fr);}
        .kpi{background:var(--surface);border:1px solid var(--border);
            border-radius:var(--radius);padding:20px;}
        .kpi-top{display:flex;align-items:center;justify-content:space-between;margin-bottom:12px;}
        .kpi-icon{width:40px;height:40px;border-radius:10px;display:flex;align-items:center;
            justify-content:center;font-size:18px;}
        .kpi-icon.blue{background:rgba(79,142,247,.15);}
        .kpi-icon.green{background:rgba(56,217,169,.15);}
        .kpi-icon.warn{background:rgba(251,191,36,.15);}
        .kpi-icon.red{background:rgba(247,92,92,.15);}
        .kpi-icon.purple{background:rgba(167,139,250,.15);}
        .kpi-num{font-size:32px;font-weight:800;line-height:1;margin-bottom:4px;}
        .kpi-num.blue{color:var(--accent);}
        .kpi-num.green{color:var(--accent2);}
        .kpi-num.warn{color:var(--warn);}
        .kpi-num.red{color:var(--danger);}
        .kpi-num.purple{color:var(--purple);}
        .kpi-label{font-size:12px;color:var(--muted);font-weight:500;}

        /* ── CHART GRID ── */
        .chart-row{display:grid;gap:16px;margin-bottom:16px;}
        .chart-row.col-2{grid-template-columns:1fr 1fr;}
        .chart-row.col-3{grid-template-columns:2fr 1fr 1fr;}
        .chart-row.col-1{grid-template-columns:1fr;}
        @media(max-width:960px){.chart-row.col-2,.chart-row.col-3{grid-template-columns:1fr;}}

        /* ── CHART CARD ── */
        .chart-card{background:var(--surface);border:1px solid var(--border);
            border-radius:var(--radius);padding:20px;}
        .chart-card-header{display:flex;align-items:flex-start;justify-content:space-between;margin-bottom:16px;}
        .chart-card-title{font-size:14px;font-weight:700;margin-bottom:3px;}
        .chart-card-sub{font-size:12px;color:var(--muted);}
        .chart-wrap{position:relative;}

        /* ── LEGEND ── */
        .legend{display:flex;flex-wrap:wrap;gap:8px;margin-top:14px;}
        .legend-item{display:flex;align-items:center;gap:5px;font-size:12px;color:var(--muted);}
        .legend-dot{width:10px;height:10px;border-radius:2px;flex-shrink:0;}

        /* ── DIVIDER ── */
        .divider{height:1px;background:var(--border);margin:24px 0;}
    </style>
</head>
<body>

<header class="topbar">
    <a href="${pageContext.request.contextPath}/totruong/dashboard" class="back-btn">← Quay lại</a>
    <div class="topbar-info">
        <div class="topbar-title">📊 Thống kê tổ dân phố</div>
        <div class="topbar-sub">Tổ <strong>${tenTo}</strong></div>
    </div>
    <div class="topbar-spacer"></div>
    <form method="get" action="${pageContext.request.contextPath}/totruong/thong-ke" class="year-form">
        <label>Năm:</label>
        <select name="nam" class="year-select" onchange="this.form.submit()">
            <c:forEach var="i" begin="0" end="4">
                <c:set var="yr" value="${namHienTai - i}"/>
                <option value="${yr}" ${yr == namChon ? 'selected' : ''}>${yr}</option>
            </c:forEach>
        </select>
    </form>
</header>

<div class="page">

    <!-- ══ SIDEBAR ══════════════════════════════════════════════════ -->
    <aside class="sidebar">
        <div class="sidebar-section">Dân số</div>
        <button class="tab-item active" onclick="switchTab('hokhau', this)">
            <span class="tab-icon">🏠</span> Hộ khẩu
            <span class="tab-badge" id="badge-hokhau">${tongSoHo}</span>
        </button>
        <button class="tab-item" onclick="switchTab('nhankho', this)">
            <span class="tab-icon">👥</span> Nhân khẩu
            <span class="tab-badge" id="badge-nk">${tongNhanKhau}</span>
        </button>

        <div class="sidebar-section">Hoạt động</div>
        <button class="tab-item" onclick="switchTab('thiepmoi', this)">
            <span class="tab-icon">💌</span> Thiệp mời họp
            <span class="tab-badge" id="badge-thiep">${tongThiepMoi}</span>
        </button>
        <button class="tab-item" onclick="switchTab('phananh', this)">
            <span class="tab-icon">💬</span> Phản ánh
            <span class="tab-badge" id="badge-pa">—</span>
        </button>
    </aside>

    <!-- ══ MAIN CONTENT ══════════════════════════════════════════════ -->
    <div class="main-content">

        <!-- ══ PANEL 1: HỘ KHẨU ════════════════════════════════════ -->
        <div class="tab-panel active" id="panel-hokhau">
            <div class="panel-header">
                <div class="panel-title">🏠 Thống kê hộ khẩu</div>
                <div class="panel-sub">Phân bố trạng thái cư trú trong tổ</div>
            </div>

            <div class="kpi-row col-3">
                <div class="kpi">
                    <div class="kpi-top"><div class="kpi-icon blue">🏘</div></div>
                    <div class="kpi-num blue">${tongSoHo}</div>
                    <div class="kpi-label">Tổng số hộ</div>
                </div>
                <div class="kpi">
                    <div class="kpi-top"><div class="kpi-icon green">🏡</div></div>
                    <div class="kpi-num green" id="numThuongTru">—</div>
                    <div class="kpi-label">Thường trú</div>
                </div>
                <div class="kpi">
                    <div class="kpi-top"><div class="kpi-icon warn">📋</div></div>
                    <div class="kpi-num warn" id="numTamTru">—</div>
                    <div class="kpi-label">Tạm trú</div>
                </div>
            </div>
            <div class="kpi-row col-2">
                <div class="kpi">
                    <div class="kpi-top"><div class="kpi-icon red">🚶</div></div>
                    <div class="kpi-num red" id="numTamVang">—</div>
                    <div class="kpi-label">Tạm vắng</div>
                </div>
                <div class="kpi">
                    <div class="kpi-top"><div class="kpi-icon purple">👥</div></div>
                    <div class="kpi-num purple">${tongNhanKhau}</div>
                    <div class="kpi-label">Tổng nhân khẩu</div>
                </div>
            </div>

            <div class="chart-row col-2">
                <div class="chart-card">
                    <div class="chart-card-header">
                        <div>
                            <div class="chart-card-title">Phân bố trạng thái cư trú</div>
                            <div class="chart-card-sub">Số hộ theo từng loại cư trú</div>
                        </div>
                    </div>
                    <div class="chart-wrap"><canvas id="chartCuTru" height="260"></canvas></div>
                    <div class="legend" id="legendCuTru"></div>
                </div>
                <div class="chart-card">
                    <div class="chart-card-header">
                        <div>
                            <div class="chart-card-title">Tỉ lệ cư trú</div>
                            <div class="chart-card-sub">Thường trú / Tạm trú / Tạm vắng</div>
                        </div>
                    </div>
                    <div class="chart-wrap"><canvas id="chartCuTruDonut" height="260"></canvas></div>
                    <div class="legend" id="legendCuTruDonut"></div>
                </div>
            </div>
        </div>

        <!-- ══ PANEL 2: NHÂN KHẨU ═══════════════════════════════════ -->
        <div class="tab-panel" id="panel-nhankho">
            <div class="panel-header">
                <div class="panel-title">👥 Thống kê nhân khẩu</div>
                <div class="panel-sub">Phân bố độ tuổi và giới tính</div>
            </div>

            <div class="kpi-row col-3">
                <div class="kpi">
                    <div class="kpi-top"><div class="kpi-icon blue">👥</div></div>
                    <div class="kpi-num blue">${tongNhanKhau}</div>
                    <div class="kpi-label">Tổng nhân khẩu</div>
                </div>
                <div class="kpi">
                    <div class="kpi-top"><div class="kpi-icon green">♂</div></div>
                    <div class="kpi-num green" id="numNam">—</div>
                    <div class="kpi-label">Nam</div>
                </div>
                <div class="kpi">
                    <div class="kpi-top"><div class="kpi-icon warn">♀</div></div>
                    <div class="kpi-num warn" id="numNu">—</div>
                    <div class="kpi-label">Nữ</div>
                </div>
            </div>

            <div class="chart-row col-2">
                <div class="chart-card">
                    <div class="chart-card-header">
                        <div>
                            <div class="chart-card-title">Nhân khẩu theo nhóm tuổi</div>
                            <div class="chart-card-sub">Phân bố độ tuổi toàn tổ</div>
                        </div>
                    </div>
                    <div class="chart-wrap"><canvas id="chartNhomTuoi" height="280"></canvas></div>
                </div>
                <div class="chart-card">
                    <div class="chart-card-header">
                        <div>
                            <div class="chart-card-title">Tỉ lệ giới tính</div>
                            <div class="chart-card-sub">Nam / Nữ / Khác</div>
                        </div>
                    </div>
                    <div class="chart-wrap"><canvas id="chartGioiTinh" height="280"></canvas></div>
                    <div class="legend" id="legendGioiTinh"></div>
                </div>
            </div>
        </div>

        <!-- ══ PANEL 3: THIỆP MỜI ═══════════════════════════════════ -->
        <div class="tab-panel" id="panel-thiepmoi">
            <div class="panel-header">
                <div class="panel-title">💌 Thống kê thiệp mời họp — ${namChon}</div>
                <div class="panel-sub">Tổng hợp thiệp mời đã tạo trong năm</div>
            </div>

            <div class="kpi-row col-4">
                <div class="kpi">
                    <div class="kpi-top"><div class="kpi-icon blue">💌</div></div>
                    <div class="kpi-num blue">${tongThiepMoi}</div>
                    <div class="kpi-label">Tổng thiệp mời</div>
                </div>
                <div class="kpi">
                    <div class="kpi-top"><div class="kpi-icon green">🖨</div></div>
                    <div class="kpi-num green">${thiepDaIn}</div>
                    <div class="kpi-label">Đã in</div>
                </div>
                <div class="kpi">
                    <div class="kpi-top"><div class="kpi-icon warn">📨</div></div>
                    <div class="kpi-num warn" id="numThiepGui">—</div>
                    <div class="kpi-label">Đã gửi</div>
                </div>
                <div class="kpi">
                    <div class="kpi-top"><div class="kpi-icon red">⏸</div></div>
                    <div class="kpi-num red" id="numThiepHoan">—</div>
                    <div class="kpi-label">Tạm hoãn</div>
                </div>
            </div>

            <div class="chart-row col-2">
                <div class="chart-card">
                    <div class="chart-card-header">
                        <div>
                            <div class="chart-card-title">Số thiệp mời theo tháng</div>
                            <div class="chart-card-sub">Phân bố theo từng tháng trong năm ${namChon}</div>
                        </div>
                    </div>
                    <div class="chart-wrap"><canvas id="chartThiepThang" height="240"></canvas></div>
                </div>
                <div class="chart-card">
                    <div class="chart-card-header">
                        <div>
                            <div class="chart-card-title">Phân bố theo trạng thái</div>
                            <div class="chart-card-sub">Tỉ lệ các trạng thái thiệp năm ${namChon}</div>
                        </div>
                    </div>
                    <div class="chart-wrap"><canvas id="chartThiepTrangThai" height="240"></canvas></div>
                    <div class="legend" id="legendThiepTrangThai"></div>
                </div>
            </div>
        </div>

        <!-- ══ PANEL 4: PHẢN ÁNH ════════════════════════════════════ -->
        <div class="tab-panel" id="panel-phananh">
            <div class="panel-header">
                <div class="panel-title">💬 Thống kê phản ánh — ${namChon}</div>
                <div class="panel-sub">Tổng hợp phản ánh / kiến nghị từ hộ dân trong năm</div>
            </div>

            <div class="kpi-row col-4">
                <div class="kpi">
                    <div class="kpi-top"><div class="kpi-icon blue">📝</div></div>
                    <div class="kpi-num blue" id="numPATong">—</div>
                    <div class="kpi-label">Tổng phản ánh</div>
                </div>
                <div class="kpi">
                    <div class="kpi-top"><div class="kpi-icon green">✅</div></div>
                    <div class="kpi-num green" id="numPAGiaiQuyet">—</div>
                    <div class="kpi-label">Đã giải quyết</div>
                </div>
                <div class="kpi">
                    <div class="kpi-top"><div class="kpi-icon warn">⚙️</div></div>
                    <div class="kpi-num warn" id="numPADangXuLy">—</div>
                    <div class="kpi-label">Đang xử lý</div>
                </div>
                <div class="kpi">
                    <div class="kpi-top"><div class="kpi-icon red">⏳</div></div>
                    <div class="kpi-num red" id="numPAChoTiep">—</div>
                    <div class="kpi-label">Chờ tiếp nhận</div>
                </div>
            </div>

            <div class="chart-row col-2">
                <div class="chart-card">
                    <div class="chart-card-header">
                        <div>
                            <div class="chart-card-title">Phản ánh theo tháng</div>
                            <div class="chart-card-sub">Số lượng nhận mỗi tháng năm ${namChon}</div>
                        </div>
                    </div>
                    <div class="chart-wrap"><canvas id="chartPAThang" height="240"></canvas></div>
                </div>
                <div class="chart-card">
                    <div class="chart-card-header">
                        <div>
                            <div class="chart-card-title">Phân bố theo loại</div>
                            <div class="chart-card-sub">Các loại phản ánh năm ${namChon}</div>
                        </div>
                    </div>
                    <div class="chart-wrap"><canvas id="chartPALoai" height="240"></canvas></div>
                    <div class="legend" id="legendPALoai"></div>
                </div>
            </div>
        </div>

    </div><!-- /main-content -->
</div><!-- /page -->

<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.1/chart.umd.js"></script>
<script>
// ── Dữ liệu từ server ─────────────────────────────────────────────
const hoTheoCuTru    = ${hoTheoCuTruJson};
const nkGioiTinh     = ${nkTheoGioiTinhJson};
const nkNhomTuoi     = ${nkTheoNhomTuoiJson};
const thiepTheoThang = ${thiepTheoThangJson};
const thiepTrangThai = ${thiepTheoTrangThaiJson};
const tongHopPA      = ${tongHopPAJson};
const paTheoThang    = ${paTheoThangJson};
const paTheoLoai     = ${paTheoLoaiJson};

// ── Màu ───────────────────────────────────────────────────────────
const C = {
    blue:   '#4f8ef7', green:  '#38d9a9', warn:  '#fbbf24',
    red:    '#f75c5c', purple: '#a78bfa', pink:  '#f472b6',
    teal:   '#2dd4bf', orange: '#fb923c'
};
const PALETTE = Object.values(C);
const GRID = 'rgba(255,255,255,0.05)';
const TICK = '#64748b';

function keys(o) { return Object.keys(o); }
function vals(o) { return Object.values(o); }

function makeLegend(id, labels, colors) {
    const el = document.getElementById(id);
    if (!el) return;
    el.innerHTML = labels.map((l,i) =>
        `<span class="legend-item">
            <span class="legend-dot" style="background:${colors[i % colors.length]}"></span>${l}
        </span>`
    ).join('');
}

// ── Helpers chart ─────────────────────────────────────────────────
function barVertOpts(color) {
    return {
        responsive: true, maintainAspectRatio: false,
        plugins: { legend: { display: false } },
        scales: {
            x: { grid: { color: GRID }, ticks: { color: TICK, font: { size: 11 } } },
            y: { grid: { color: GRID }, ticks: { color: TICK, font: { size: 11 }, stepSize: 1 }, beginAtZero: true }
        }
    };
}

function barHorizOpts() {
    return {
        indexAxis: 'y',
        responsive: true, maintainAspectRatio: false,
        plugins: { legend: { display: false } },
        scales: {
            x: { grid: { color: GRID }, ticks: { color: TICK, font: { size: 11 } }, beginAtZero: true },
            y: { grid: { display: false }, ticks: { color: TICK, font: { size: 11 } } }
        }
    };
}

function donutOpts() {
    return {
        responsive: true, maintainAspectRatio: false,
        plugins: { legend: { display: false } },
        cutout: '60%'
    };
}

// ══ PANEL 1: HỘ KHẨU ─────────────────────────────────────────────
document.getElementById('numThuongTru').textContent = hoTheoCuTru['Thường trú'] || 0;
document.getElementById('numTamTru').textContent    = hoTheoCuTru['Tạm trú']    || 0;
document.getElementById('numTamVang').textContent   = hoTheoCuTru['Tạm vắng']   || 0;

// Bar đứng — so sánh số hộ
new Chart(document.getElementById('chartCuTru'), {
    type: 'bar',
    data: {
        labels: keys(hoTheoCuTru),
        datasets: [{
            data: vals(hoTheoCuTru),
            backgroundColor: [C.blue, C.warn, C.red],
            borderRadius: 8, barThickness: 48
        }]
    },
    options: barVertOpts()
});
makeLegend('legendCuTru', keys(hoTheoCuTru), [C.blue, C.warn, C.red]);

// Donut — tỉ lệ
new Chart(document.getElementById('chartCuTruDonut'), {
    type: 'doughnut',
    data: {
        labels: keys(hoTheoCuTru),
        datasets: [{ data: vals(hoTheoCuTru), backgroundColor: [C.blue, C.warn, C.red], borderWidth: 0, hoverOffset: 8 }]
    },
    options: donutOpts()
});
makeLegend('legendCuTruDonut', keys(hoTheoCuTru), [C.blue, C.warn, C.red]);

// ══ PANEL 2: NHÂN KHẨU ───────────────────────────────────────────
document.getElementById('numNam').textContent = nkGioiTinh['Nam'] || 0;
document.getElementById('numNu').textContent  = nkGioiTinh['Nữ']  || 0;

// Bar ngang — nhóm tuổi (phù hợp vì nhãn dài)
new Chart(document.getElementById('chartNhomTuoi'), {
    type: 'bar',
    data: {
        labels: keys(nkNhomTuoi),
        datasets: [{
            data: vals(nkNhomTuoi),
            backgroundColor: PALETTE,
            borderRadius: 6, barThickness: 26
        }]
    },
    options: barHorizOpts()
});

// Donut — giới tính
new Chart(document.getElementById('chartGioiTinh'), {
    type: 'doughnut',
    data: {
        labels: keys(nkGioiTinh),
        datasets: [{ data: vals(nkGioiTinh), backgroundColor: [C.blue, C.pink, C.warn], borderWidth: 0, hoverOffset: 8 }]
    },
    options: donutOpts()
});
makeLegend('legendGioiTinh', keys(nkGioiTinh), [C.blue, C.pink, C.warn]);

// ══ PANEL 3: THIỆP MỜI ───────────────────────────────────────────
document.getElementById('numThiepGui').textContent  = thiepTrangThai['Đã gửi']   || 0;
document.getElementById('numThiepHoan').textContent = thiepTrangThai['Tạm hoãn'] || 0;

// Badge sidebar
document.getElementById('badge-thiep').textContent = '${tongThiepMoi}';

// Bar đứng — theo tháng
new Chart(document.getElementById('chartThiepThang'), {
    type: 'bar',
    data: {
        labels: keys(thiepTheoThang),
        datasets: [{
            label: 'Thiệp mời',
            data: vals(thiepTheoThang),
            backgroundColor: 'rgba(79,142,247,0.75)',
            borderRadius: 6, hoverBackgroundColor: C.blue
        }]
    },
    options: barVertOpts(C.blue)
});

// Donut — theo trạng thái
new Chart(document.getElementById('chartThiepTrangThai'), {
    type: 'doughnut',
    data: {
        labels: keys(thiepTrangThai),
        datasets: [{ data: vals(thiepTrangThai), backgroundColor: PALETTE, borderWidth: 0, hoverOffset: 8 }]
    },
    options: donutOpts()
});
makeLegend('legendThiepTrangThai', keys(thiepTrangThai), PALETTE);

// ══ PANEL 4: PHẢN ÁNH ────────────────────────────────────────────
const paTong = tongHopPA['Tong'] || 0;
document.getElementById('numPATong').textContent      = paTong;
document.getElementById('numPAGiaiQuyet').textContent = tongHopPA['DaGiaiQuyet'] || 0;
document.getElementById('numPADangXuLy').textContent  = tongHopPA['DangXuLy']    || 0;
document.getElementById('numPAChoTiep').textContent   = tongHopPA['ChoTiepNhan'] || 0;
document.getElementById('badge-pa').textContent       = paTong;

// Bar đứng — theo tháng
new Chart(document.getElementById('chartPAThang'), {
    type: 'bar',
    data: {
        labels: keys(paTheoThang),
        datasets: [{
            label: 'Phản ánh',
            data: vals(paTheoThang),
            backgroundColor: 'rgba(247,92,92,0.7)',
            borderRadius: 6, hoverBackgroundColor: C.red
        }]
    },
    options: barVertOpts(C.red)
});

// Bar ngang — theo loại (nhãn dài)
new Chart(document.getElementById('chartPALoai'), {
    type: 'bar',
    data: {
        labels: keys(paTheoLoai),
        datasets: [{
            data: vals(paTheoLoai),
            backgroundColor: keys(paTheoLoai).map((_,i) => PALETTE[i % PALETTE.length]),
            borderRadius: 6, barThickness: 24
        }]
    },
    options: barHorizOpts()
});
makeLegend('legendPALoai', keys(paTheoLoai), PALETTE);

// ══ SWITCH TAB ────────────────────────────────────────────────────
function switchTab(name, btn) {
    document.querySelectorAll('.tab-panel').forEach(p => p.classList.remove('active'));
    document.querySelectorAll('.tab-item').forEach(b => b.classList.remove('active'));
    document.getElementById('panel-' + name).classList.add('active');
    btn.classList.add('active');
}
</script>
</body>
</html>
