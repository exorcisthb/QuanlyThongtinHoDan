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
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg: #0f1117; --surface: #181c27; --surface2: #1f2433;
            --border: #2a3048; --accent: #4f8ef7; --accent2: #38d9a9;
            --danger: #f75c5c; --warn: #fbbf24; --text: #e2e8f0;
            --muted: #64748b; --radius: 14px;
        }
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Be Vietnam Pro', sans-serif; background: var(--bg); color: var(--text); min-height: 100vh; }
        .topbar { position: fixed; top: 0; left: 0; right: 0; z-index: 200; height: 64px; background: rgba(15,17,23,.88); backdrop-filter: blur(16px); border-bottom: 1px solid var(--border); display: flex; align-items: center; padding: 0 32px; gap: 16px; }
        .topbar-logo { display: flex; align-items: center; gap: 10px; text-decoration: none; color: var(--text); }
        .logo-icon { width: 34px; height: 34px; border-radius: 8px; background: linear-gradient(135deg, var(--accent), var(--accent2)); display: flex; align-items: center; justify-content: center; font-size: 16px; }
        .logo-text { font-size: 14px; font-weight: 700; }
        .logo-text span { color: var(--accent); }
        .topbar-divider { width: 1px; height: 24px; background: var(--border); }
        .breadcrumb { display: flex; align-items: center; gap: 6px; font-size: 13px; color: var(--muted); }
        .breadcrumb a { color: var(--muted); text-decoration: none; }
        .breadcrumb a:hover { color: var(--text); }
        .topbar-spacer { flex: 1; }
        .main { padding-top: 64px; }
        .content { max-width: 900px; margin: 0 auto; padding: 36px 32px; }
        .page-header { margin-bottom: 28px; }
        .page-header h1 { font-size: 24px; font-weight: 800; margin-bottom: 4px; }
        .page-header h1 span { color: var(--warn); }
        .page-header p { font-size: 13px; color: var(--muted); }

        .cards-list { display: flex; flex-direction: column; gap: 14px; }
        .thiep-card { background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius); padding: 22px 26px; display: flex; gap: 22px; align-items: flex-start; cursor: pointer; transition: border-color .15s, transform .15s; }
        .thiep-card:hover { border-color: var(--accent); transform: translateY(-2px); }
        .thiep-card.tam-hoan { border-left: 3px solid var(--warn); }
        .thiep-card.da-ket-thuc { opacity: .6; }
        .thiep-date { flex-shrink: 0; text-align: center; width: 58px; background: var(--surface2); border-radius: 10px; padding: 10px 6px; }
        .thiep-date .day { font-size: 24px; font-weight: 800; color: var(--accent); line-height: 1; }
        .thiep-date .month { font-size: 11px; color: var(--muted); font-weight: 600; margin-top: 3px; }
        .thiep-date .time { font-size: 11px; color: var(--accent2); font-weight: 600; margin-top: 5px; }
        .thiep-body { flex: 1; }
        .thiep-top { display: flex; align-items: center; gap: 10px; margin-bottom: 8px; flex-wrap: wrap; }
        .thiep-title { font-size: 15px; font-weight: 700; }
        .thiep-meta { display: flex; flex-wrap: wrap; gap: 14px; }
        .thiep-meta-item { display: flex; align-items: center; gap: 5px; font-size: 12px; color: var(--muted); }
        .thiep-hint { font-size: 11px; color: var(--muted); margin-top: 8px; font-style: italic; }

        .badge { display: inline-flex; align-items: center; gap: 5px; padding: 3px 10px; border-radius: 100px; font-size: 11px; font-weight: 700; white-space: nowrap; }
        .badge::before { content:''; width:5px; height:5px; border-radius:50%; background:currentColor; }
        .badge-5 { background: rgba(79,142,247,.12);  color: var(--accent);  border:1px solid rgba(79,142,247,.25) }
        .badge-6 { background: rgba(56,217,169,.12);  color: var(--accent2); border:1px solid rgba(56,217,169,.25) }
        .badge-7 { background: rgba(100,116,139,.12); color: var(--muted);   border:1px solid rgba(100,116,139,.2) }
        .badge-4 { background: rgba(247,92,92,.12);   color: var(--danger);  border:1px solid rgba(247,92,92,.25) }
        .badge-8 { background: rgba(251,191,36,.12);  color: var(--warn);    border:1px solid rgba(251,191,36,.25) }

        .paging { display:flex; align-items:center; justify-content:center; gap:16px; margin-top:24px; }
        .paging button { height:34px; padding:0 16px; border-radius:8px; font-size:13px; font-weight:600; font-family:inherit; cursor:pointer; background:transparent; border:1px solid var(--border); color:var(--muted); transition: all .15s; }
        .paging button:hover:not(:disabled) { border-color:var(--accent); color:var(--accent); }
        .paging button:disabled { opacity:.3; cursor:not-allowed; }
        .paging span { font-size:13px; color:var(--muted); }

        .empty-state { text-align: center; padding: 72px 20px; }
        .empty-icon { font-size: 48px; margin-bottom: 16px; opacity: .5; }
        .empty-state h3 { font-size: 16px; font-weight: 700; margin-bottom: 6px; }
        .empty-state p { font-size: 13px; color: var(--muted); }

        /* MODAL */
        .modal-overlay { position: fixed; inset: 0; background: rgba(0,0,0,.8); z-index: 500; display: none; align-items: center; justify-content: center; padding: 24px; }
        .modal-overlay.open { display: flex; animation: fadeIn .2s ease; }
        @keyframes fadeIn { from{opacity:0} to{opacity:1} }
        .thiep-popup { width: 440px; max-width: 100%; background: #fefcf8; border-radius: 4px; overflow: hidden; animation: slideUp .22s ease; position: relative; box-shadow: 0 4px 6px rgba(0,0,0,.08), 0 32px 80px rgba(0,0,0,.5); }
        @keyframes slideUp { from{transform:translateY(16px);opacity:0} to{transform:translateY(0);opacity:1} }
        .thiep-popup::before { content: ''; position: absolute; inset: 8px; border: 1.5px solid #c8a96e; pointer-events: none; z-index: 2; }
        .thiep-close { position: absolute; top: 14px; right: 14px; z-index: 10; background: rgba(0,0,0,.08); border: none; color: #555; width: 26px; height: 26px; border-radius: 50%; cursor: pointer; font-size: 13px; display: flex; align-items: center; justify-content: center; }
        .thiep-close:hover { background: rgba(0,0,0,.16); }
        .thiep-popup-header { background: #1a3464; color: #fff; text-align: center; padding: 28px 32px 22px; position: relative; }
        .thiep-popup-header::after { content: ''; position: absolute; bottom: 0; left: 0; right: 0; height: 4px; background: linear-gradient(90deg, #c8a96e 0%, #f0d596 50%, #c8a96e 100%); }
        .thiep-popup-header .gov-line1 { font-size: 11px; font-weight: 600; letter-spacing: .8px; opacity: .85; margin-bottom: 2px; }
        .thiep-popup-header .gov-line2 { font-size: 10px; opacity: .65; font-style: italic; margin-bottom: 18px; }
        .thiep-popup-header .main-title { font-family: 'Playfair Display', serif; font-size: 30px; font-weight: 700; letter-spacing: 4px; color: #f0d596; margin-bottom: 10px; }
        .thiep-popup-header .sub-title { font-size: 13px; font-weight: 500; opacity: .9; line-height: 1.5; max-width: 320px; margin: 0 auto; }
        .thiep-popup-header .divider-line { margin: 14px auto 0; width: 60px; height: 1.5px; background: #c8a96e; opacity: .7; }
        .thiep-popup-body { padding: 24px 32px; background: #fefcf8; }
        .thiep-info-row { display: flex; gap: 14px; align-items: flex-start; padding: 11px 0; border-bottom: 1px dashed #e8dcc8; }
        .thiep-info-row:last-child { border-bottom: none; }
        .thiep-info-icon { font-size: 15px; flex-shrink: 0; width: 20px; text-align: center; margin-top: 1px; }
        .thiep-info-label { font-size: 10px; font-weight: 700; color: #9a7d4a; text-transform: uppercase; letter-spacing: .08em; margin-bottom: 3px; }
        .thiep-info-value { font-size: 14px; color: #2a2a2a; line-height: 1.55; white-space: pre-line; }
        .thiep-hoan-box { margin-top: 14px; padding: 11px 14px; background: #fff8e6; border: 1px solid #e6c86e; border-radius: 6px; font-size: 13px; color: #7a5c00; }
        .thiep-hoan-box strong { display: block; margin-bottom: 3px; font-size: 11px; text-transform: uppercase; letter-spacing: .06em; }
        .thiep-popup-footer { background: #f5f0e8; border-top: 1px solid #e0d4b8; padding: 14px 32px 18px; text-align: center; }
        .thiep-popup-footer .footer-ornament { font-size: 16px; color: #c8a96e; letter-spacing: 8px; margin-bottom: 6px; }
        .thiep-popup-footer p { font-size: 12px; color: #7a6a50; font-style: italic; line-height: 1.6; }
    </style>
</head>
<body>

<header class="topbar">
    <a href="${pageContext.request.contextPath}/dashboard" class="topbar-logo">
        <div class="logo-icon">🏘</div>
        <div class="logo-text">Cổng <span>Dịch Vụ</span></div>
    </a>
    <div class="topbar-divider"></div>
    <div class="breadcrumb">
        <a href="${pageContext.request.contextPath}/dashboard">Trang chủ</a>
        <span style="color:var(--muted)">›</span>
        <span style="color:var(--warn);font-weight:600">Thiệp mời họp</span>
    </div>
    <div class="topbar-spacer"></div>
</header>

<!-- MODAL THIỆP MỜI -->
<div class="modal-overlay" id="thiepModal" onclick="if(event.target===this)closeModal()">
    <div class="thiep-popup">
        <button class="thiep-close" onclick="closeModal()">✕</button>
        <div class="thiep-popup-header">
            <div class="gov-line1">CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM</div>
            <div class="gov-line2">Độc lập – Tự do – Hạnh phúc</div>
            <div class="main-title">THIỆP MỜI</div>
            <div class="sub-title" id="modalTieuDe"></div>
            <div class="divider-line"></div>
        </div>
        <div class="thiep-popup-body">
            <div class="thiep-info-row">
                <div class="thiep-info-icon">🕐</div>
                <div><div class="thiep-info-label">Thời gian</div><div class="thiep-info-value" id="modalThoiGian"></div></div>
            </div>
            <div class="thiep-info-row">
                <div class="thiep-info-icon">📍</div>
                <div><div class="thiep-info-label">Địa điểm</div><div class="thiep-info-value" id="modalDiaDiem"></div></div>
            </div>
            <div class="thiep-info-row" id="modalNoiDungRow">
                <div class="thiep-info-icon">📋</div>
                <div><div class="thiep-info-label">Nội dung</div><div class="thiep-info-value" id="modalNoiDung"></div></div>
            </div>
            <div id="modalHoanBox" class="thiep-hoan-box" style="display:none">
                <strong>⏸ Lý do tạm hoãn</strong>
                <span id="modalGhiChuHoan"></span>
            </div>
        </div>
        <div class="thiep-popup-footer">
            <div class="footer-ornament">✦ ✦ ✦</div>
            <p>Kính mời quý hộ dân có mặt đúng giờ.<br>Trân trọng!</p>
        </div>
    </div>
</div>

<main class="main">
    <div class="content">
        <div class="page-header">
            <h1>Thiệp mời <span>họp tổ</span></h1>
            <p>Bấm vào thiệp để xem chi tiết</p>
        </div>

        <c:choose>
            <c:when test="${empty danhSach}">
                <div class="empty-state">
                    <div class="empty-icon">💌</div>
                    <h3>Chưa có thiệp mời nào</h3>
                    <p>Tổ trưởng chưa tạo thiệp mời họp nào cho tổ của bạn.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="cards-list">
                    <c:forEach var="tm" items="${danhSach}">
                        <c:set var="cardClass" value=""/>
                        <c:if test="${tm.trangThaiID == 8}"><c:set var="cardClass" value="tam-hoan"/></c:if>
                        <c:if test="${tm.trangThaiID == 7}"><c:set var="cardClass" value="da-ket-thuc"/></c:if>

                        <div class="thiep-card ${cardClass}"
                             data-thiepmoiid="${tm.thiepMoiID}"
                             data-tieude="${tm.tieuDe}"
                             data-diadiem="${tm.diaDiem}"
                             data-noidung="${tm.noiDung}"
                             data-ghichuoan="${tm.ghiChuHoan}"
                             data-trangthai="${tm.trangThaiID}"
                             data-batdau="<fmt:formatDate value='${tm.thoiGianBatDau}' pattern='HH:mm, dd/MM/yyyy'/>"
                             data-ketthuc="<fmt:formatDate value='${tm.thoiGianKetThuc}' pattern='HH:mm'/>"
                             onclick="openModal(this)">
                            <div class="thiep-date">
                                <div class="day"><fmt:formatDate value="${tm.thoiGianBatDau}" pattern="dd"/></div>
                                <div class="month">Th<fmt:formatDate value="${tm.thoiGianBatDau}" pattern="MM"/></div>
                                <div class="time"><fmt:formatDate value="${tm.thoiGianBatDau}" pattern="HH:mm"/></div>
                            </div>
                            <div class="thiep-body">
                                <div class="thiep-top">
                                    <div class="thiep-title">${tm.tieuDe}</div>
                                    <c:choose>
                                        <c:when test="${tm.trangThaiID == 5}"><span class="badge badge-5">🕐 Sắp diễn ra</span></c:when>
                                        <c:when test="${tm.trangThaiID == 6}"><span class="badge badge-6">🟢 Đang diễn ra</span></c:when>
                                        <c:when test="${tm.trangThaiID == 7}"><span class="badge badge-7">✅ Đã kết thúc</span></c:when>
                                        <c:when test="${tm.trangThaiID == 4}"><span class="badge badge-4">❌ Đã hủy</span></c:when>
                                        <c:when test="${tm.trangThaiID == 8}"><span class="badge badge-8">⏸ Tạm hoãn</span></c:when>
                                    </c:choose>
                                </div>
                                <div class="thiep-meta">
                                    <div class="thiep-meta-item">📍 ${tm.diaDiem}</div>
                                    <div class="thiep-meta-item">
                                        ⏱ <fmt:formatDate value="${tm.thoiGianBatDau}" pattern="HH:mm"/>
                                        <c:if test="${not empty tm.thoiGianKetThuc}">
                                            → <fmt:formatDate value="${tm.thoiGianKetThuc}" pattern="HH:mm"/>
                                        </c:if>
                                    </div>
                                    <div class="thiep-meta-item">👤 ${tm.tenNguoiTao}</div>
                                </div>
                                <div class="thiep-hint">Bấm để xem thiệp →</div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <div class="paging">
                    <button id="btnPrev">← Trước</button>
                    <span id="pageInfo"></span>
                    <button id="btnNext">Sau →</button>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</main>

<script>
    function openModal(card) {
        const tieuDe    = card.getAttribute('data-tieude')    || '';
        const diaDiem   = card.getAttribute('data-diadiem')   || '';
        const noiDung   = card.getAttribute('data-noidung')   || '';
        const ghiChu    = card.getAttribute('data-ghichuoan') || '';
        const trangThai = parseInt(card.getAttribute('data-trangthai')) || 0;
        const batDau    = card.getAttribute('data-batdau')    || '';
        const ketThuc   = card.getAttribute('data-ketthuc')   || '';

        document.getElementById('modalTieuDe').textContent  = tieuDe;
        document.getElementById('modalDiaDiem').textContent = diaDiem;

        let tg = batDau;
        if (ketThuc && ketThuc.trim()) tg += ' → ' + ketThuc;
        document.getElementById('modalThoiGian').textContent = tg;

        const noiDungRow = document.getElementById('modalNoiDungRow');
        if (noiDung && noiDung.trim()) {
            document.getElementById('modalNoiDung').textContent = noiDung;
            noiDungRow.style.display = 'flex';
        } else {
            noiDungRow.style.display = 'none';
        }

        const hoanBox = document.getElementById('modalHoanBox');
        if (trangThai === 8 && ghiChu) {
            document.getElementById('modalGhiChuHoan').textContent = ghiChu;
            hoanBox.style.display = 'block';
        } else {
            hoanBox.style.display = 'none';
        }

        document.getElementById('thiepModal').classList.add('open');
    }

    function closeModal() {
        document.getElementById('thiepModal').classList.remove('open');
    }

    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') closeModal();
    });

    // Phân trang
    const PAGE_SIZE  = 10;
    let currentPage  = 1;
    const allCards   = Array.from(document.querySelectorAll('.thiep-card'));
    const totalPages = Math.max(1, Math.ceil(allCards.length / PAGE_SIZE));

    function renderPage(page) {
        allCards.forEach(function(c, i) {
            c.style.display = (i >= (page - 1) * PAGE_SIZE && i < page * PAGE_SIZE) ? '' : 'none';
        });
        document.getElementById('pageInfo').textContent = 'Trang ' + page + ' / ' + totalPages;
        document.getElementById('btnPrev').disabled = page <= 1;
        document.getElementById('btnNext').disabled = page >= totalPages;
        currentPage = page;
    }

    document.getElementById('btnPrev').addEventListener('click', function() { renderPage(currentPage - 1); });
    document.getElementById('btnNext').addEventListener('click', function() { renderPage(currentPage + 1); });

    // Tự mở popup nếu có ?open=ID trong URL
    var urlParams = new URLSearchParams(window.location.search);
    var openID    = urlParams.get('open');
    if (openID) {
        var target = document.querySelector('.thiep-card[data-thiepmoiid="' + openID + '"]');
        if (target) {
            var idx        = allCards.indexOf(target);
            var targetPage = Math.floor(idx / PAGE_SIZE) + 1;
            renderPage(targetPage);
            openModal(target);
        } else {
            renderPage(1);
        }
    } else {
        renderPage(1);
    }
</script>
</body>
</html>
