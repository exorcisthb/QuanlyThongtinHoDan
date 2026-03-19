<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thiệp mời họp — Tổ dân phố</title>
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

        .topbar {
            position: fixed; top: 0; left: 0; right: 0; z-index: 200;
            height: 64px; background: rgba(15,17,23,.88); backdrop-filter: blur(16px);
            border-bottom: 1px solid var(--border); display: flex; align-items: center;
            padding: 0 32px; gap: 16px;
        }
        .topbar-logo { display: flex; align-items: center; gap: 10px; text-decoration: none; color: var(--text); }
        .logo-icon { width: 34px; height: 34px; border-radius: 8px; background: linear-gradient(135deg, var(--accent), var(--accent2)); display: flex; align-items: center; justify-content: center; font-size: 16px; }
        .logo-text { font-size: 14px; font-weight: 700; letter-spacing: -.3px; }
        .logo-text span { color: var(--accent); }
        .topbar-divider { width: 1px; height: 24px; background: var(--border); }
        .breadcrumb { display: flex; align-items: center; gap: 6px; font-size: 13px; color: var(--muted); }
        .breadcrumb a { color: var(--muted); text-decoration: none; transition: color .15s; }
        .breadcrumb a:hover { color: var(--text); }
        .topbar-spacer { flex: 1; }
        .btn-new { display: inline-flex; align-items: center; gap: 8px; padding: 9px 18px; border-radius: 9px; font-size: 13px; font-weight: 700; cursor: pointer; font-family: inherit; transition: all .18s; border: none; background: var(--warn); color: #000; text-decoration: none; }
        .btn-new:hover { background: #f0b429; transform: translateY(-1px); }

        .main { padding-top: 64px; }
        .content { max-width: 1200px; margin: 0 auto; padding: 36px 32px; }
        .page-header { display: flex; align-items: flex-start; justify-content: space-between; margin-bottom: 28px; gap: 16px; }
        .page-header-left h1 { font-size: 24px; font-weight: 800; letter-spacing: -.4px; margin-bottom: 4px; }
        .page-header-left h1 span { color: var(--warn); }
        .page-header-left p { font-size: 13px; color: var(--muted); }

        .toast { padding: 12px 18px; border-radius: 10px; font-size: 13px; font-weight: 600; margin-bottom: 20px; display: flex; align-items: center; gap: 10px; animation: slideIn .25s ease; }
        @keyframes slideIn { from{opacity:0;transform:translateY(-8px)} to{opacity:1;transform:translateY(0)} }
        .toast-success { background: rgba(56,217,169,.12); border: 1px solid rgba(56,217,169,.3); color: var(--accent2); }
        .toast-error   { background: rgba(247,92,92,.12);  border: 1px solid rgba(247,92,92,.3);  color: var(--danger); }

        .filter-bar { background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius); padding: 16px 20px; display: flex; gap: 12px; align-items: flex-end; flex-wrap: wrap; margin-bottom: 20px; }
        .filter-field { display: flex; flex-direction: column; gap: 5px; }
        .filter-field label { font-size: 11px; font-weight: 700; color: var(--muted); text-transform: uppercase; letter-spacing: .06em; }
        .filter-field input, .filter-field select { height: 36px; padding: 0 12px; background: var(--surface2); border: 1px solid var(--border); border-radius: 8px; font-size: 13px; color: var(--text); font-family: inherit; outline: none; transition: border-color .15s; }
        .filter-field input { min-width: 220px; }
        .filter-field input:focus, .filter-field select:focus { border-color: var(--accent); }
        .filter-field select option { background: var(--surface2); }
        .btn-filter { height: 36px; padding: 0 18px; border-radius: 8px; font-size: 13px; font-weight: 700; font-family: inherit; cursor: pointer; border: none; transition: all .15s; background: var(--accent); color: #fff; }
        .btn-filter:hover { background: #3a7ae0; }
        .btn-reset { height: 36px; padding: 0 16px; border-radius: 8px; font-size: 13px; font-weight: 600; font-family: inherit; cursor: pointer; transition: all .15s; background: transparent; border: 1px solid var(--border); color: var(--muted); text-decoration: none; display: inline-flex; align-items: center; }
        .btn-reset:hover { border-color: var(--text); color: var(--text); }

        .stats-row { display: flex; gap: 12px; margin-bottom: 20px; flex-wrap: wrap; }
        .stat-pill { background: var(--surface); border: 1px solid var(--border); border-radius: 10px; padding: 10px 18px; display: flex; align-items: center; gap: 10px; }
        .stat-pill .sp-num { font-size: 20px; font-weight: 800; }
        .stat-pill .sp-label { font-size: 11px; color: var(--muted); font-weight: 500; }
        .sp-all .sp-num { color: var(--text); }
        .sp-draft .sp-num { color: var(--muted); }
        .sp-sent .sp-num { color: var(--accent); }
        .sp-print .sp-num { color: var(--accent2); }
        .sp-cancel .sp-num { color: var(--danger); }

        .table-wrap { background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius); overflow: hidden; }
        .table-meta { padding: 14px 20px; border-bottom: 1px solid var(--border); font-size: 13px; color: var(--muted); display: flex; justify-content: space-between; align-items: center; }
        .table-meta strong { color: var(--text); }
        table { width: 100%; border-collapse: collapse; }
        thead th { background: var(--surface2); padding: 12px 16px; text-align: left; font-size: 11px; font-weight: 700; color: var(--muted); text-transform: uppercase; letter-spacing: .06em; border-bottom: 1px solid var(--border); }
        tbody tr { transition: background .12s; }
        tbody tr:hover { background: var(--surface2); }
        tbody td { padding: 14px 16px; font-size: 13px; border-bottom: 1px solid rgba(42,48,72,.6); vertical-align: middle; }
        tbody tr:last-child td { border-bottom: none; }
        .td-title { font-weight: 600; font-size: 14px; color: var(--text); }
        .td-title small { display: block; font-size: 11px; color: var(--muted); font-weight: 400; margin-top: 3px; }
        .td-lock { display: inline-flex; align-items: center; gap: 4px; font-size: 10px; color: var(--accent2); background: rgba(56,217,169,.1); padding: 2px 7px; border-radius: 100px; margin-top: 4px; font-weight: 600; }

        .badge { display: inline-flex; align-items: center; gap: 5px; padding: 4px 11px; border-radius: 100px; font-size: 11px; font-weight: 700; white-space: nowrap; }
        .badge::before { content:''; width:5px; height:5px; border-radius:50%; background:currentColor; }
        .badge-5  { background: rgba(79,142,247,.12);  color: var(--accent);  border:1px solid rgba(79,142,247,.25) }
        .badge-6  { background: rgba(56,217,169,.12);  color: var(--accent2); border:1px solid rgba(56,217,169,.25) }
        .badge-7  { background: rgba(100,116,139,.12); color: var(--muted);   border:1px solid rgba(100,116,139,.2) }
        .badge-4  { background: rgba(247,92,92,.12);   color: var(--danger);  border:1px solid rgba(247,92,92,.25) }
        .badge-8  { background: rgba(251,191,36,.12);  color: var(--warn);    border:1px solid rgba(251,191,36,.25) }
        .badge-in { background: rgba(56,217,169,.12);  color: var(--accent2); border:1px solid rgba(56,217,169,.25); font-size:10px; padding:2px 8px; border-radius:100px; font-weight:700 }

        .actions { display: flex; gap: 6px; align-items: center; }
        .act-btn { width: 32px; height: 32px; border-radius: 8px; display: flex; align-items: center; justify-content: center; font-size: 14px; cursor: pointer; transition: all .15s; border: 1px solid var(--border); background: var(--surface2); text-decoration: none; color: var(--text); }
        .act-btn:hover { background: var(--surface); border-color: var(--accent); }
        .act-btn.edit:hover  { border-color: var(--warn);    background: rgba(251,191,36,.1); }
        .act-btn.print:hover { border-color: var(--accent2); background: rgba(56,217,169,.1); }
        .act-btn.pause:hover { border-color: var(--warn);    background: rgba(251,191,36,.1); }
        .act-btn.open:hover  { border-color: var(--accent2); background: rgba(56,217,169,.1); }
        .act-btn:disabled, .act-btn.disabled { opacity: .3; cursor: not-allowed; pointer-events: none; }

        .empty-state { padding: 72px 20px; text-align: center; }
        .empty-icon { font-size: 48px; margin-bottom: 16px; opacity: .5; }
        .empty-state h3 { font-size: 16px; font-weight: 700; margin-bottom: 6px; }
        .empty-state p { font-size: 13px; color: var(--muted); }

        /* MODAL */
        .modal-overlay { position: fixed; inset: 0; background: rgba(0,0,0,.7); z-index: 500; display: none; align-items: center; justify-content: center; }
        .modal-overlay.open { display: flex; animation: fadeIn .2s ease; }
        @keyframes fadeIn { from{opacity:0} to{opacity:1} }
        .modal { background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius); padding: 32px; width: 440px; text-align: center; position: relative; }
        .modal-wide { width: 520px; text-align: left; }
        .modal-icon { font-size: 40px; margin-bottom: 16px; }
        .modal h3 { font-size: 17px; font-weight: 800; margin-bottom: 8px; }
        .modal p  { font-size: 13px; color: var(--muted); line-height: 1.6; margin-bottom: 20px; }
        .modal-actions { display: flex; gap: 10px; justify-content: center; }
        .modal-label { display: block; text-align: left; font-size: 11px; font-weight: 700; color: var(--muted); text-transform: uppercase; letter-spacing: .06em; margin-bottom: 5px; margin-top: 14px; }
        .modal-input { width: 100%; background: var(--surface2); border: 1px solid var(--border); border-radius: 8px; padding: 9px 12px; font-size: 13px; color: var(--text); font-family: inherit; outline: none; transition: border-color .15s; }
        .modal-input:focus { border-color: var(--accent2); }
        textarea.modal-input { resize: vertical; min-height: 80px; }

        .btn-confirm-pause {
            padding: 10px 24px; border-radius: 8px; font-size: 13px; font-weight: 700;
            cursor: pointer; font-family: inherit; border: none;
            background: var(--warn); color: #000; transition: all .15s;
        }
        .btn-confirm-pause:hover { background: #f0b429; }
        .btn-confirm-open {
            padding: 10px 24px; border-radius: 8px; font-size: 13px; font-weight: 700;
            cursor: pointer; font-family: inherit; border: none;
            background: var(--accent2); color: #000; transition: all .15s;
        }
        .btn-confirm-open:hover { background: #2bc99a; }
        .btn-cancel-modal { padding: 10px 24px; border-radius: 8px; font-size: 13px; font-weight: 600; cursor: pointer; font-family: inherit; transition: all .15s; background: transparent; border: 1px solid var(--border); color: var(--muted); }
        .btn-cancel-modal:hover { border-color: var(--text); color: var(--text); }
    </style>
</head>
<body>

<header class="topbar">
    <a href="${pageContext.request.contextPath}/dashboard" class="topbar-logo">
        <div class="logo-icon">🏘</div>
        <div class="logo-text">Quản lý <span>Hộ dân</span></div>
    </a>
    <div class="topbar-divider"></div>
    <div class="breadcrumb">
        <a href="${pageContext.request.contextPath}/dashboard">Trang chủ</a>
        <span style="color:var(--muted)">›</span>
        <span style="color:var(--warn);font-weight:600">Thiệp mời họp</span>
    </div>
    <div class="topbar-spacer"></div>
    <a href="${pageContext.request.contextPath}/thiepmoi/tao-moi" class="btn-new">+ Tạo thiệp mới</a>
</header>

<!-- MODAL TẠM HOÃN -->
<div class="modal-overlay" id="pauseModal">
    <div class="modal">
        <div class="modal-icon">⏸️</div>
        <h3>Tạm hoãn thiệp mời?</h3>
        <p>Thông báo <strong style="color:var(--warn)">[TẠM HOÃN]</strong> sẽ được gửi đến toàn bộ hộ dân trong tổ.</p>
        <form method="post" action="${pageContext.request.contextPath}/thiepmoi/tam-hoan">
            <input type="hidden" name="thiepMoiID" id="pauseID">
            <textarea name="ghiChuHoan" id="pauseReason" class="modal-input"
                      placeholder="Nhập lý do tạm hoãn..." required maxlength="500"></textarea>
            <div class="modal-actions" style="margin-top:16px">
                <button type="submit" class="btn-confirm-pause">Xác nhận tạm hoãn</button>
                <button type="button" class="btn-cancel-modal" onclick="closePauseModal()">Hủy bỏ</button>
            </div>
        </form>
    </div>
</div>

<!-- MODAL MỞ LẠI -->
<div class="modal-overlay" id="moLaiModal">
    <div class="modal modal-wide">
        <div class="modal-icon" style="text-align:center">🔄</div>
        <h3 style="text-align:center">Mở lại thiệp mời</h3>
        <p style="text-align:center">Cập nhật thời gian mới rồi gửi thông báo <strong style="color:var(--accent2)">[MỞ LẠI]</strong> đến hộ dân.</p>
        <form method="post" action="${pageContext.request.contextPath}/thiepmoi/mo-lai">
            <input type="hidden" name="thiepMoiID" id="moLaiID">

            <label class="modal-label">Thời gian bắt đầu mới <span style="color:var(--danger)">*</span></label>
            <input type="datetime-local" name="thoiGianBatDau" id="moLaiBatDau" class="modal-input" required>

            <label class="modal-label">Thời gian kết thúc</label>
            <input type="datetime-local" name="thoiGianKetThuc" id="moLaiKetThuc" class="modal-input">

            <label class="modal-label">Địa điểm <span style="color:var(--danger)">*</span></label>
            <input type="text" name="diaDiem" id="moLaiDiaDiem" class="modal-input"
                   required maxlength="300" placeholder="Nhập địa điểm...">

            <label class="modal-label">Nội dung</label>
            <textarea name="noiDung" id="moLaiNoiDung" class="modal-input"
                      placeholder="Nhập nội dung..."></textarea>

            <div class="modal-actions" style="margin-top:20px">
                <button type="submit" class="btn-confirm-open">Xác nhận mở lại</button>
                <button type="button" class="btn-cancel-modal" onclick="closeMoLaiModal()">Hủy bỏ</button>
            </div>
        </form>
    </div>
</div>

<main class="main">
    <div class="content">

        <div class="page-header">
            <div class="page-header-left">
                <h1>Thiệp mời <span>họp tổ</span></h1>
                <p>Quản lý thiệp mời, gửi thông báo và theo dõi trạng thái</p>
            </div>
        </div>

        <c:if test="${not empty successMsg}">
            <div class="toast toast-success">✅ ${successMsg}</div>
        </c:if>
        <c:if test="${not empty errorMsg}">
            <div class="toast toast-error">❌ ${errorMsg}</div>
        </c:if>

        <!-- STATS -->
        <div class="stats-row">
            <div class="stat-pill sp-all">
                <div><div class="sp-num">${danhSach.size()}</div><div class="sp-label">Tổng thiệp</div></div>
            </div>
            <div class="stat-pill sp-draft">
                <div>
                    <div class="sp-num">
                        <c:set var="countSap" value="0"/>
                        <c:forEach var="tm" items="${danhSach}">
                            <c:if test="${tm.trangThaiID == 5}"><c:set var="countSap" value="${countSap + 1}"/></c:if>
                        </c:forEach>${countSap}
                    </div>
                    <div class="sp-label">Sắp diễn ra</div>
                </div>
            </div>
            <div class="stat-pill sp-sent">
                <div>
                    <div class="sp-num">
                        <c:set var="countDang" value="0"/>
                        <c:forEach var="tm" items="${danhSach}">
                            <c:if test="${tm.trangThaiID == 6}"><c:set var="countDang" value="${countDang + 1}"/></c:if>
                        </c:forEach>${countDang}
                    </div>
                    <div class="sp-label">Đang diễn ra</div>
                </div>
            </div>
            <div class="stat-pill sp-print">
                <div>
                    <div class="sp-num">
                        <c:set var="countIn" value="0"/>
                        <c:forEach var="tm" items="${danhSach}">
                            <c:if test="${tm.daIn}"><c:set var="countIn" value="${countIn + 1}"/></c:if>
                        </c:forEach>${countIn}
                    </div>
                    <div class="sp-label">Đã kết thúc / In</div>
                </div>
            </div>
            <div class="stat-pill sp-cancel">
                <div>
                    <div class="sp-num">
                        <c:set var="countHuy" value="0"/>
                        <c:forEach var="tm" items="${danhSach}">
                            <c:if test="${tm.trangThaiID == 4}"><c:set var="countHuy" value="${countHuy + 1}"/></c:if>
                        </c:forEach>${countHuy}
                    </div>
                    <div class="sp-label">Đã hủy</div>
                </div>
            </div>
        </div>

        <!-- FILTER -->
        <form class="filter-bar" method="get" action="${pageContext.request.contextPath}/thiepmoi/danh-sach">
            <div class="filter-field">
                <label>Tìm kiếm</label>
                <input type="text" name="keyword" placeholder="Tên thiệp mời..." value="${keyword}">
            </div>
            <div class="filter-field">
                <label>Trạng thái</label>
                <select name="trangThaiID">
                    <option value="0">Tất cả</option>
                    <option value="5" ${trangThaiID == 5 ? 'selected' : ''}>Sắp diễn ra</option>
                    <option value="6" ${trangThaiID == 6 ? 'selected' : ''}>Đang diễn ra</option>
                    <option value="7" ${trangThaiID == 7 ? 'selected' : ''}>Đã kết thúc</option>
                    <option value="4" ${trangThaiID == 4 ? 'selected' : ''}>Đã hủy</option>
                    <option value="8" ${trangThaiID == 8 ? 'selected' : ''}>Tạm hoãn</option>
                </select>
            </div>
            <button type="submit" class="btn-filter">Lọc</button>
            <a href="${pageContext.request.contextPath}/thiepmoi/danh-sach" class="btn-reset">Xóa lọc</a>
        </form>

        <!-- TABLE -->
        <div class="table-wrap">
            <div class="table-meta">
                <span>Hiển thị <strong>${danhSach.size()}</strong> thiệp mời</span>
            </div>
            <c:choose>
                <c:when test="${empty danhSach}">
                    <div class="empty-state">
                        <div class="empty-icon">💌</div>
                        <h3>Chưa có thiệp mời nào</h3>
                        <p>Bấm <strong>+ Tạo thiệp mới</strong> để bắt đầu</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <table>
                        <thead>
                            <tr>
                                <th>#</th><th>Tiêu đề</th><th>Tổ dân phố</th>
                                <th>Thời gian họp</th><th>Địa điểm</th>
                                <th>Người tạo</th><th>Trạng thái</th><th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="tm" items="${danhSach}" varStatus="st">
                            <tr>
                                <td style="color:var(--muted);font-size:12px">${st.index + 1}</td>

                                <td>
                                    <div class="td-title">${tm.tieuDe}</div>
                                    <small>Tạo lúc: <fmt:formatDate value="${tm.ngayTao}" pattern="dd/MM/yyyy HH:mm"/></small>
                                    <c:if test="${tm.daIn}"><div class="td-lock">🔒 Đã in — không thể sửa</div></c:if>
                                </td>

                                <td style="font-size:13px">${tm.tenTo}</td>

                                <td>
                                    <div style="font-size:13px;font-weight:600">
                                        <fmt:formatDate value="${tm.thoiGianBatDau}" pattern="dd/MM/yyyy"/>
                                    </div>
                                    <div style="font-size:11px;color:var(--muted)">
                                        <fmt:formatDate value="${tm.thoiGianBatDau}" pattern="HH:mm"/>
                                        <c:if test="${not empty tm.thoiGianKetThuc}">
                                            → <fmt:formatDate value="${tm.thoiGianKetThuc}" pattern="HH:mm"/>
                                        </c:if>
                                    </div>
                                </td>

                                <td style="font-size:12px;color:var(--muted);max-width:160px">${tm.diaDiem}</td>
                                <td style="font-size:13px">${tm.tenNguoiTao}</td>

                                <td>
                                    <c:choose>
                                        <c:when test="${tm.daIn}"><span class="badge badge-in">🔒 Đã in</span></c:when>
                                        <c:when test="${tm.trangThaiID == 5}"><span class="badge badge-5">🕐 Sắp diễn ra</span></c:when>
                                        <c:when test="${tm.trangThaiID == 6}"><span class="badge badge-6">🟢 Đang diễn ra</span></c:when>
                                        <c:when test="${tm.trangThaiID == 7}"><span class="badge badge-7">✅ Đã kết thúc</span></c:when>
                                        <c:when test="${tm.trangThaiID == 4}"><span class="badge badge-4">❌ Đã hủy</span></c:when>
                                        <c:when test="${tm.trangThaiID == 8}">
                                            <span class="badge badge-8">⏸ Tạm hoãn</span>
                                            <c:if test="${not empty tm.ghiChuHoan}">
                                                <div style="font-size:11px;color:var(--muted);margin-top:4px;max-width:160px">${tm.ghiChuHoan}</div>
                                            </c:if>
                                        </c:when>
                                        <c:otherwise><span style="color:var(--muted);font-size:12px">—</span></c:otherwise>
                                    </c:choose>
                                </td>

                                <td>
                                    <div class="actions">
                                        <%-- Xem --%>
                                        <a href="${pageContext.request.contextPath}/thiepmoi/chi-tiet?id=${tm.thiepMoiID}"
                                           class="act-btn" title="Xem chi tiết">👁</a>

                                        <%-- Sửa: chỉ khi trangThaiID == 5 và chưa in --%>
                                        <c:choose>
                                            <c:when test="${!tm.daIn and tm.trangThaiID == 5}">
                                                <a href="${pageContext.request.contextPath}/thiepmoi/sua?id=${tm.thiepMoiID}"
                                                   class="act-btn edit" title="Chỉnh sửa">✏️</a>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="act-btn disabled" title="${tm.daIn ? 'Đã in — không thể sửa' : 'Không thể sửa ở trạng thái này'}">✏️</span>
                                            </c:otherwise>
                                        </c:choose>

                                        <%-- In: chỉ khi trangThaiID == 5 và chưa in --%>
                                        <c:choose>
                                            <c:when test="${!tm.daIn and tm.trangThaiID == 5}">
                                                <a href="${pageContext.request.contextPath}/thiepmoi/in?id=${tm.thiepMoiID}"
                                                   class="act-btn print" title="In thiệp">🖨️</a>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="act-btn disabled" title="${tm.daIn ? 'Đã in rồi' : 'Không thể in ở trạng thái này'}">🖨️</span>
                                            </c:otherwise>
                                        </c:choose>

                                        <%-- Tạm hoãn / Mở lại --%>
                                        <c:choose>
                                            <c:when test="${!tm.daIn and tm.trangThaiID == 5}">
                                                <button class="act-btn pause" title="Tạm hoãn"
                                                        onclick="openPauseModal(${tm.thiepMoiID})">⏸️</button>
                                            </c:when>
                                            <c:when test="${tm.trangThaiID == 8}">
                                                <button class="act-btn open" title="Mở lại thiệp"
                                                        data-id="${tm.thiepMoiID}"
                                                        data-diadiem="${tm.diaDiem}"
                                                        data-noidung="${tm.noiDung}"
                                                        onclick="openMoLaiModal(this)">🔄</button>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="act-btn disabled" title="Không thể thực hiện ở trạng thái này">⏸️</span>
                                            </c:otherwise>
                                        </c:choose>
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

<script>
    // --- Modal Tạm hoãn ---
    function openPauseModal(id) {
        document.getElementById('pauseID').value = id;
        document.getElementById('pauseReason').value = '';
        document.getElementById('pauseModal').classList.add('open');
    }
    function closePauseModal() {
        document.getElementById('pauseModal').classList.remove('open');
    }
    document.getElementById('pauseModal').addEventListener('click', function(e) {
        if (e.target === this) closePauseModal();
    });

    // --- Modal Mở lại ---
    function openMoLaiModal(btn) {
        document.getElementById('moLaiID').value      = btn.getAttribute('data-id');
        document.getElementById('moLaiDiaDiem').value = btn.getAttribute('data-diadiem') || '';
        document.getElementById('moLaiNoiDung').value = btn.getAttribute('data-noidung') || '';
        document.getElementById('moLaiBatDau').value  = '';
        document.getElementById('moLaiKetThuc').value = '';
        // min = now + 1 phút để bắt buộc > now
        const now = new Date();
        now.setMinutes(now.getMinutes() + 1);
        const minStr = now.toISOString().slice(0, 16);
        document.getElementById('moLaiBatDau').min = minStr;
        document.getElementById('moLaiKetThuc').min = minStr;
        document.getElementById('moLaiModal').classList.add('open');
    }
    function closeMoLaiModal() {
        document.getElementById('moLaiModal').classList.remove('open');
    }
    document.getElementById('moLaiModal').addEventListener('click', function(e) {
        if (e.target === this) closeMoLaiModal();
    });

    // --- Tự ẩn toast ---
    document.querySelectorAll('.toast').forEach(function(el) {
        setTimeout(function() {
            el.style.transition = 'opacity .4s';
            el.style.opacity = '0';
            setTimeout(function() { el.remove(); }, 400);
        }, 4000);
    });
</script>
</body>
</html>
