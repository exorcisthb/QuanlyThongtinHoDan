<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch họp tổ dân phố</title>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg:#0f1117; --surface:#181c27; --surface2:#1f2433;
            --border:#2a3048; --accent:#4f8ef7; --accent2:#38d9a9;
            --danger:#f75c5c; --warn:#fbbf24; --text:#e2e8f0; --muted:#64748b; --radius:14px;
        }
        *,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
        body{font-family:'Be Vietnam Pro',sans-serif;background:var(--bg);color:var(--text);min-height:100vh}
        .topbar{position:fixed;top:0;left:0;right:0;z-index:200;height:64px;background:rgba(15,17,23,.88);backdrop-filter:blur(16px);border-bottom:1px solid var(--border);display:flex;align-items:center;padding:0 32px;gap:16px}
        .topbar-logo{display:flex;align-items:center;gap:10px;text-decoration:none;color:var(--text)}
        .logo-icon{width:34px;height:34px;border-radius:8px;background:linear-gradient(135deg,var(--accent),var(--accent2));display:flex;align-items:center;justify-content:center;font-size:16px}
        .logo-text{font-size:14px;font-weight:700;letter-spacing:-.3px}
        .logo-text span{color:var(--accent)}
        .topbar-divider{width:1px;height:24px;background:var(--border)}
        .topbar-title{font-size:13px;font-weight:600;color:var(--muted)}
        .topbar-spacer{flex:1}
        .back-btn{display:flex;align-items:center;gap:6px;font-size:13px;font-weight:600;color:var(--muted);text-decoration:none;padding:6px 12px;border-radius:8px;border:1px solid var(--border);background:var(--surface2);transition:all .18s}
        .back-btn:hover{color:var(--text);border-color:var(--accent)}
        .main{padding-top:64px}
        .content{max-width:1200px;margin:0 auto;padding:36px 32px}
        .page-header{display:flex;align-items:center;justify-content:space-between;margin-bottom:28px;gap:16px;flex-wrap:wrap}
        .page-header-left h2{font-size:22px;font-weight:800;letter-spacing:-.4px}
        .page-header-left p{font-size:13px;color:var(--muted);margin-top:4px}
        .btn-create{display:inline-flex;align-items:center;gap:8px;padding:10px 22px;border-radius:10px;background:linear-gradient(135deg,var(--accent),#3a7bd5);color:#fff;font-size:14px;font-weight:700;border:none;cursor:pointer;font-family:inherit;text-decoration:none;transition:opacity .18s;white-space:nowrap}
        .btn-create:hover{opacity:.88}
        .filter-bar{background:var(--surface);border:1px solid var(--border);border-radius:var(--radius);padding:18px 20px;display:flex;gap:12px;align-items:center;flex-wrap:wrap;margin-bottom:20px}
        .search-wrap{flex:1;min-width:220px;position:relative}
        .search-wrap input{width:100%;padding:9px 14px 9px 38px;background:var(--surface2);border:1px solid var(--border);border-radius:8px;color:var(--text);font-size:13px;font-family:inherit;outline:none;transition:border-color .18s}
        .search-wrap input:focus{border-color:var(--accent)}
        .search-wrap input::placeholder{color:var(--muted)}
        .search-icon{position:absolute;left:12px;top:50%;transform:translateY(-50%);font-size:15px;pointer-events:none}
        .filter-select{padding:9px 14px;background:var(--surface2);border:1px solid var(--border);border-radius:8px;color:var(--text);font-size:13px;font-family:inherit;outline:none;cursor:pointer;transition:border-color .18s;min-width:160px}
        .filter-select:focus{border-color:var(--accent)}
        .filter-select option{background:var(--surface2)}
        .btn-filter{padding:9px 18px;border-radius:8px;font-size:13px;font-weight:600;font-family:inherit;cursor:pointer;border:1px solid var(--border);background:var(--surface2);color:var(--text);transition:all .18s;white-space:nowrap}
        .btn-filter:hover{border-color:var(--accent);color:var(--accent)}
        .btn-reset{padding:9px 14px;border-radius:8px;font-size:13px;font-weight:600;font-family:inherit;cursor:pointer;border:1px solid var(--border);background:transparent;color:var(--muted);transition:all .18s}
        .btn-reset:hover{color:var(--danger);border-color:var(--danger)}
        .summary-row{display:flex;gap:10px;margin-bottom:20px;flex-wrap:wrap}
        .sum-chip{padding:6px 14px;border-radius:20px;font-size:12px;font-weight:600;border:1px solid var(--border);background:var(--surface2);cursor:pointer;transition:all .18s;color:var(--muted)}
        .sum-chip:hover,.sum-chip.active{color:var(--text);border-color:var(--accent2);background:rgba(56,217,169,.1)}
        .sum-chip .chip-count{display:inline-flex;align-items:center;justify-content:center;background:var(--surface);border-radius:10px;font-size:11px;padding:1px 7px;margin-left:6px;font-weight:700}
        .table-card{background:var(--surface);border:1px solid var(--border);border-radius:var(--radius);overflow:hidden}
        .table-card-header{padding:18px 24px;border-bottom:1px solid var(--border);display:flex;align-items:center;justify-content:space-between}
        .table-card-header h3{font-size:15px;font-weight:700}
        .total-count{font-size:12px;color:var(--muted)}
        table{width:100%;border-collapse:collapse}
        thead tr{background:var(--surface2)}
        thead th{padding:12px 18px;text-align:left;font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:.8px;color:var(--muted);white-space:nowrap}
        tbody tr{border-top:1px solid var(--border);transition:background .15s}
        tbody tr:hover{background:var(--surface2)}
        tbody td{padding:14px 18px;font-size:13px;vertical-align:middle}
        .td-title{font-weight:600;color:var(--text);margin-bottom:3px}
        .td-sub{font-size:11px;color:var(--muted)}
        .badge{display:inline-flex;align-items:center;gap:5px;padding:4px 10px;border-radius:20px;font-size:11px;font-weight:700;white-space:nowrap}
        .badge::before{content:'';width:6px;height:6px;border-radius:50%;background:currentColor}
        .badge-blue  {background:rgba(79,142,247,.15); color:var(--accent)}
        .badge-green {background:rgba(56,217,169,.15); color:var(--accent2)}
        .badge-gray  {background:rgba(100,116,139,.15);color:var(--muted)}
        .badge-red   {background:rgba(247,92,92,.15);  color:var(--danger)}
        .badge-warn  {background:rgba(251,191,36,.15); color:var(--warn)}
        /* FIX: thêm flex-wrap để nút không tràn */
        .action-wrap{display:flex;gap:6px;flex-wrap:wrap}
        .act-btn{padding:6px 12px;border-radius:7px;font-size:12px;font-weight:600;cursor:pointer;font-family:inherit;border:1px solid var(--border);background:var(--surface2);color:var(--muted);text-decoration:none;transition:all .18s;white-space:nowrap}
        .act-btn:hover{color:var(--text);border-color:var(--accent2)}
        .act-btn.edit:hover{color:var(--warn);border-color:var(--warn)}
        .act-btn.disabled{opacity:.4;cursor:not-allowed;pointer-events:none}
        .empty-state{padding:60px 20px;text-align:center;color:var(--muted)}
        .empty-icon{font-size:40px;margin-bottom:12px}
        .empty-state p{font-size:14px;margin-bottom:16px}
        .alert{padding:12px 18px;border-radius:10px;font-size:13px;font-weight:500;margin-bottom:20px;display:flex;align-items:center;gap:10px}
        .alert-success{background:rgba(56,217,169,.12);border:1px solid rgba(56,217,169,.3);color:var(--accent2)}
        .alert-error  {background:rgba(247,92,92,.12); border:1px solid rgba(247,92,92,.3); color:var(--danger)}

        /* ── MODAL CHI TIẾT ── */
        .modal-overlay{position:fixed;inset:0;background:rgba(0,0,0,.7);z-index:500;display:none;align-items:flex-start;justify-content:center;padding:40px 20px;overflow-y:auto}
        .modal-overlay.open{display:flex;animation:fadeIn .2s ease}
        @keyframes fadeIn{from{opacity:0}to{opacity:1}}
        .modal{background:var(--surface);border:1px solid var(--border);border-radius:var(--radius);width:100%;max-width:780px;position:relative;margin:auto}
        .modal-header{padding:20px 24px;border-bottom:1px solid var(--border);display:flex;align-items:center;justify-content:space-between}
        .modal-header h3{font-size:17px;font-weight:800}
        .modal-close{background:none;border:none;color:var(--muted);font-size:20px;cursor:pointer;transition:color .15s;padding:4px 8px}
        .modal-close:hover{color:var(--text)}
        .modal-body{padding:24px}
        .modal-section{margin-bottom:24px}
        .modal-section:last-child{margin-bottom:0}
        .modal-section-title{font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:1px;color:var(--muted);margin-bottom:14px;padding-bottom:8px;border-bottom:1px solid var(--border)}
        .info-grid{display:grid;grid-template-columns:1fr 1fr;gap:12px}
        .ii-label{font-size:11px;color:var(--muted);margin-bottom:3px}
        .ii-val{font-size:13px;font-weight:500}
        .read-table{width:100%;border-collapse:collapse;font-size:13px}
        .read-table th{text-align:left;padding:8px 12px;font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:.6px;color:var(--muted);background:var(--surface2)}
        .read-table td{padding:10px 12px;border-top:1px solid var(--border)}
        .dot-read{display:inline-flex;align-items:center;gap:5px;font-size:12px;font-weight:600}
        .dot-read::before{content:'';width:7px;height:7px;border-radius:50%;background:currentColor}
        .dot-read.yes{color:var(--accent2)}
        .dot-read.no{color:var(--muted)}
        .timeline{position:relative;padding-left:20px}
        .timeline::before{content:'';position:absolute;left:6px;top:0;bottom:0;width:1px;background:var(--border)}
        .tl-item{position:relative;margin-bottom:20px}
        .tl-item:last-child{margin-bottom:0}
        .tl-dot{position:absolute;left:-17px;top:4px;width:10px;height:10px;border-radius:50%;background:var(--accent);border:2px solid var(--surface)}
        .tl-time{font-size:11px;color:var(--muted);margin-bottom:4px}
        .tl-who{font-size:13px;font-weight:600;margin-bottom:4px}
        .tl-reason{font-size:12px;color:var(--warn);margin-bottom:8px}
        .tl-diff{background:var(--surface2);border:1px solid var(--border);border-radius:8px;padding:10px 14px;font-size:12px}
        .diff-row{display:flex;gap:8px;margin-bottom:4px;align-items:flex-start}
        .diff-row:last-child{margin-bottom:0}
        .diff-key{color:var(--muted);min-width:110px;flex-shrink:0}
        .diff-old{color:var(--danger);text-decoration:line-through;margin-right:6px}
        .diff-new{color:var(--accent2)}
        .no-history{text-align:center;color:var(--muted);font-size:13px;padding:20px 0}
    </style>
</head>
<body>

<header class="topbar">
    <a href="${pageContext.request.contextPath}/totruong/dashboard" class="topbar-logo">
        <div class="logo-icon">🏘</div>
        <div class="logo-text">Quản lý <span>Hộ dân</span></div>
    </a>
    <div class="topbar-divider"></div>
    <span class="topbar-title">Lịch họp tổ</span>
    <div class="topbar-spacer"></div>
    <a href="${pageContext.request.contextPath}/totruong/dashboard" class="back-btn">← Về dashboard</a>
</header>

<main class="main">
    <div class="content">

        <c:if test="${not empty thanhCong}">
            <div class="alert alert-success">✅ ${thanhCong}</div>
            <c:remove var="thanhCong" scope="session"/>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-error">❌ ${error}</div>
        </c:if>

        <div class="page-header">
            <div class="page-header-left">
                <h2>📅 Lịch họp tổ dân phố</h2>
                <p>Quản lý toàn bộ lịch họp — tạo mới và chỉnh sửa, thông báo tự động đến chủ hộ</p>
            </div>
            <a href="${pageContext.request.contextPath}/tao-lich-hop" class="btn-create">+ Tạo lịch họp</a>
        </div>

        <form method="get" action="${pageContext.request.contextPath}/danh-sach-lich-hop" id="filterForm">
            <div class="filter-bar">
                <div class="search-wrap">
                    <span class="search-icon">🔍</span>
                    <input type="text" name="keyword" placeholder="Tìm theo tiêu đề, địa điểm..."
                           value="${param.keyword}"/>
                </div>
                <select name="trangThai" class="filter-select">
                    <option value="">Tất cả trạng thái</option>
                    <option value="1" ${param.trangThai == '1' ? 'selected' : ''}>Sắp diễn ra</option>
                    <option value="2" ${param.trangThai == '2' ? 'selected' : ''}>Đang diễn ra</option>
                    <option value="3" ${param.trangThai == '3' ? 'selected' : ''}>Đã kết thúc</option>
                    <option value="4" ${param.trangThai == '4' ? 'selected' : ''}>Đã hủy</option>
                </select>
                <input type="month" name="thang" class="filter-select"
                       value="${param.thang}" style="min-width:140px"/>
                <button type="submit" class="btn-filter">🔍 Lọc</button>
                <button type="button" class="btn-reset" onclick="resetFilter()">✕ Xóa lọc</button>
            </div>
        </form>

        <div class="summary-row">
            <c:set var="demSap"  value="0"/>
            <c:set var="demDang" value="0"/>
            <c:set var="demXong" value="0"/>
            <c:forEach var="lh" items="${danhSachLichHop}">
                <c:if test="${lh.trangThai == 1}"><c:set var="demSap"  value="${demSap  + 1}"/></c:if>
                <c:if test="${lh.trangThai == 2}"><c:set var="demDang" value="${demDang + 1}"/></c:if>
                <c:if test="${lh.trangThai == 3}"><c:set var="demXong" value="${demXong + 1}"/></c:if>
            </c:forEach>
            <div class="sum-chip active">Tất cả <span class="chip-count">${danhSachLichHop.size()}</span></div>
            <div class="sum-chip">Sắp diễn ra  <span class="chip-count">${demSap}</span></div>
            <div class="sum-chip">Đang diễn ra <span class="chip-count">${demDang}</span></div>
            <div class="sum-chip">Đã kết thúc  <span class="chip-count">${demXong}</span></div>
        </div>

        <div class="table-card">
            <div class="table-card-header">
                <h3>Danh sách lịch họp</h3>
                <span class="total-count">Tổng: ${danhSachLichHop.size()} lịch họp</span>
            </div>

            <c:choose>
                <c:when test="${empty danhSachLichHop}">
                    <div class="empty-state">
                        <div class="empty-icon">📭</div>
                        <p>Chưa có lịch họp nào. Hãy tạo lịch họp đầu tiên!</p>
                        <a href="${pageContext.request.contextPath}/tao-lich-hop" class="btn-create">+ Tạo lịch họp</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <table>
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Tiêu đề</th>
                                <th>Địa điểm</th>
                                <th>Thời gian bắt đầu</th>
                                <th>Thời gian kết thúc</th>
                                <th>Mức độ</th>
                                <th>Trạng thái</th>
                                <th>Người tạo</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="lh" items="${danhSachLichHop}" varStatus="st">
                                <tr>
                                    <td style="color:var(--muted);font-size:12px">${st.index + 1}</td>
                                    <td>
                                        <div class="td-title">${lh.tieuDe}</div>
                                        <c:if test="${not empty lh.noiDung}">
                                            <div class="td-sub">${lh.noiDung}</div>
                                        </c:if>
                                    </td>
                                    <td>${lh.diaDiem}</td>
                                    <td style="white-space:nowrap">${lh.thoiGianBatDau}</td>
                                    <td style="white-space:nowrap;color:var(--muted)">
                                        <c:choose>
                                            <c:when test="${not empty lh.thoiGianKetThuc}">${lh.thoiGianKetThuc}</c:when>
                                            <c:otherwise>—</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${lh.mucDo == 1}"><span class="badge badge-green">🟢 Bình thường</span></c:when>
                                            <c:when test="${lh.mucDo == 2}"><span class="badge badge-warn">🟡 Quan trọng</span></c:when>
                                            <c:when test="${lh.mucDo == 3}"><span class="badge badge-red">🔴 Khẩn cấp</span></c:when>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${lh.trangThai == 1}"><span class="badge badge-blue">Sắp diễn ra</span></c:when>
                                            <c:when test="${lh.trangThai == 2}"><span class="badge badge-green">Đang diễn ra</span></c:when>
                                            <c:when test="${lh.trangThai == 3}"><span class="badge badge-gray">Đã kết thúc</span></c:when>
                                            <c:when test="${lh.trangThai == 4}"><span class="badge badge-red">Đã hủy</span></c:when>
                                        </c:choose>
                                    </td>
                                    <td style="color:var(--muted)">${lh.nguoiTao}</td>
                                    <td>
                                        <div class="action-wrap">
                                            <c:choose>
                                                <c:when test="${lh.trangThai == 1}">
                                                    <a href="${pageContext.request.contextPath}/sua-lich-hop?id=${lh.lichHopID}"
                                                       class="act-btn edit">✏️ Sửa</a>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="act-btn disabled" title="Không thể sửa khi đã bắt đầu hoặc kết thúc">✏️ Sửa</span>
                                                </c:otherwise>
                                            </c:choose>
                                            <a href="javascript:void(0)"
                                               onclick="xemChiTiet(${lh.lichHopID})"
                                               class="act-btn">👁 Chi tiết</a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</main>

<!-- MODAL CHI TIẾT -->
<div class="modal-overlay" id="modalChiTiet" onclick="closeModalOutside(event)">
    <div class="modal">
        <div class="modal-header">
            <h3 id="modalTieuDe">Chi tiết lịch họp</h3>
            <button class="modal-close" onclick="closeModal()">✕</button>
        </div>
        <div class="modal-body" id="modalBody">
            <div style="text-align:center;padding:40px;color:var(--muted)">⏳ Đang tải...</div>
        </div>
    </div>
</div>

<script>
    function resetFilter() {
        window.location.href = '${pageContext.request.contextPath}/danh-sach-lich-hop';
    }

    function xemChiTiet(lichHopID) {
        document.getElementById('modalChiTiet').classList.add('open');
        document.getElementById('modalBody').innerHTML =
            '<div style="text-align:center;padding:40px;color:var(--muted)">⏳ Đang tải...</div>';

        fetch('${pageContext.request.contextPath}/chi-tiet-lich-hop?id=' + lichHopID + '&ajax=true')
            .then(r => r.json())
            .then(data => renderModal(data))
            .catch(() => {
                document.getElementById('modalBody').innerHTML =
                    '<div style="text-align:center;padding:40px;color:var(--danger)">❌ Không thể tải dữ liệu.</div>';
            });
    }

    function closeModal() {
        document.getElementById('modalChiTiet').classList.remove('open');
    }
    function closeModalOutside(e) {
        if (e.target === document.getElementById('modalChiTiet')) closeModal();
    }
    document.addEventListener('keydown', e => { if (e.key === 'Escape') closeModal(); });

    // FIX: dùng String key để tránh lỗi lookup number vs string
    const mucDoLabel = {'1':'🟢 Bình thường', '2':'🟡 Quan trọng', '3':'🔴 Khẩn cấp'};
    const ttLabel    = {'1':'Sắp diễn ra', '2':'Đang diễn ra', '3':'Đã kết thúc', '4':'Đã hủy'};
    const ttClass    = {'1':'badge-blue', '2':'badge-green', '3':'badge-gray', '4':'badge-red'};
    const doiTuongMap = {
        tatca:'Tất cả', chuho:'Chủ hộ', thanhnien:'Thanh niên',
        phunu:'Phụ nữ', nguoicao:'Người cao tuổi'
    };

    function renderModal(data) {
        const lh     = data.lichHop;
        const lichSu = data.lichSu  || [];
        const docTB  = data.docTB   || [];

        document.getElementById('modalTieuDe').textContent = lh.tieuDe || 'Chi tiết lịch họp';

        const doiTuong = (lh.doiTuong || '').split(',')
            .map(k => doiTuongMap[k.trim()] || k).filter(Boolean).join(', ');

        // FIX: ép về String khi lookup để tránh lỗi number key
        const ttKey = String(lh.trangThai);
        const mdKey = String(lh.mucDo);

        let html = `
        <div class="modal-section">
            <div class="modal-section-title">Thông tin lịch họp</div>
            <div class="info-grid">
                <div><div class="ii-label">Địa điểm</div><div class="ii-val">${lh.diaDiem || '—'}</div></div>
                <div><div class="ii-label">Trạng thái</div><div class="ii-val"><span class="badge ${ttClass[ttKey] || ''}">${ttLabel[ttKey] || '—'}</span></div></div>
                <div><div class="ii-label">Thời gian bắt đầu</div><div class="ii-val">${lh.thoiGianBatDau || '—'}</div></div>
                <div><div class="ii-label">Thời gian kết thúc</div><div class="ii-val">${lh.thoiGianKetThuc || '—'}</div></div>
                <div><div class="ii-label">Mức độ</div><div class="ii-val">${mucDoLabel[mdKey] || '—'}</div></div>
                <div><div class="ii-label">Đối tượng tham gia</div><div class="ii-val">${doiTuong || '—'}</div></div>
                <div style="grid-column:1/-1"><div class="ii-label">Nội dung</div><div class="ii-val">${lh.noiDung || '—'}</div></div>
                <div><div class="ii-label">Người tạo</div><div class="ii-val">${lh.nguoiTao || '—'}</div></div>
                <div><div class="ii-label">Ngày tạo</div><div class="ii-val">${lh.ngayTao || '—'}</div></div>
            </div>
        </div>`;

        // Trạng thái đọc thông báo
        if (docTB.length > 0) {
            const daDoc   = docTB.filter(r => r.daDoc === true).length;
            const chuaDoc = docTB.length - daDoc;
            html += `
            <div class="modal-section">
                <div class="modal-section-title">
                    Thông báo —
                    <span style="color:var(--accent2)">${daDoc} đã đọc</span> /
                    <span style="color:var(--muted)">${chuaDoc} chưa đọc</span>
                </div>
                <table class="read-table">
                    <thead><tr><th>Chủ hộ</th><th>Số điện thoại</th><th>Trạng thái</th><th>Thời gian đọc</th></tr></thead>
                    <tbody>`;
            docTB.forEach(r => {
                const daDocRow = r.daDoc === true;
                html += `<tr>
                    <td>${r.chuHo || '—'}</td>
                    <td style="color:var(--muted)">${r.soDienThoai || '—'}</td>
                    <td><span class="dot-read ${daDocRow ? 'yes' : 'no'}">${daDocRow ? 'Đã đọc' : 'Chưa đọc'}</span></td>
                    <td style="color:var(--muted);font-size:12px">${r.thoiGianDoc || '—'}</td>
                </tr>`;
            });
            html += `</tbody></table></div>`;
        }

        // Lịch sử chỉnh sửa
        html += `
        <div class="modal-section">
            <div class="modal-section-title">Lịch sử chỉnh sửa (${lichSu.length} lần)</div>`;
        if (lichSu.length === 0) {
            html += `<div class="no-history">📋 Chưa có lần chỉnh sửa nào</div>`;
        } else {
            const keyLabel = {
                tieuDe:'Tiêu đề', noiDung:'Nội dung', diaDiem:'Địa điểm',
                thoiGianBatDau:'Giờ bắt đầu', thoiGianKetThuc:'Giờ kết thúc',
                mucDo:'Mức độ', doiTuong:'Đối tượng'
            };
            html += `<div class="timeline">`;
            lichSu.forEach(ls => {
                let diffHtml = '';
                try {
                    const snap  = JSON.parse(ls.noiDungThayDoi);
                    const truoc = snap.truoc || {};
                    const sau   = snap.sau   || {};
                    Object.keys(keyLabel).forEach(k => {
                        const ov = String(truoc[k] ?? '');
                        const nv = String(sau[k]   ?? '');
                        if (ov !== nv) {
                            diffHtml += '<div class="diff-row">'
                                      + '<span class="diff-key">' + keyLabel[k] + '</span>'
                                      + '<span class="diff-old">' + (ov || '—') + '</span>'
                                      + '<span>→</span>'
                                      + '<span class="diff-new">' + (nv || '—') + '</span>'
                                      + '</div>';
                        }
                    });
                } catch(e) {
                    diffHtml = '<span style="color:var(--muted)">Không thể hiển thị chi tiết</span>';
                }
                html += '<div class="tl-item">'
                      + '<div class="tl-dot"></div>'
                      + '<div class="tl-time">' + (ls.thoiGianSua || '') + '</div>'
                      + '<div class="tl-who">✏️ ' + (ls.nguoiSua || '') + '</div>'
                      + '<div class="tl-reason">💬 ' + (ls.lyDoSua || '') + '</div>'
                      + (diffHtml ? '<div class="tl-diff">' + diffHtml + '</div>' : '')
                      + '</div>';
            });
            html += `</div>`;
        }
        html += `</div>`;

        document.getElementById('modalBody').innerHTML = html;
    }
</script>
</body>
</html>
