<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết thiệp mời</title>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root{--bg:#0f1117;--surface:#181c27;--surface2:#1f2433;--border:#2a3048;
            --accent:#4f8ef7;--accent2:#38d9a9;--danger:#f75c5c;--warn:#fbbf24;
            --text:#e2e8f0;--muted:#64748b;--radius:14px}
        *,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
        body{font-family:'Be Vietnam Pro',sans-serif;background:var(--bg);color:var(--text);min-height:100vh}

        .topbar{position:fixed;top:0;left:0;right:0;z-index:200;height:60px;
            background:rgba(15,17,23,.92);backdrop-filter:blur(16px);
            border-bottom:1px solid var(--border);display:flex;align-items:center;padding:0 24px;gap:14px}
        .topbar-logo{display:flex;align-items:center;gap:8px;text-decoration:none;color:var(--text)}
        .logo-icon{width:30px;height:30px;border-radius:7px;
            background:linear-gradient(135deg,var(--accent),var(--accent2));
            display:flex;align-items:center;justify-content:center;font-size:14px}
        .logo-text{font-size:13px;font-weight:700}.logo-text span{color:var(--accent)}
        .topbar-div{width:1px;height:20px;background:var(--border)}
        .breadcrumb{display:flex;align-items:center;gap:5px;font-size:12px;color:var(--muted)}
        .breadcrumb a{color:var(--muted);text-decoration:none}.breadcrumb a:hover{color:var(--text)}
        .breadcrumb .cur{color:var(--warn);font-weight:600}
        .topbar-spacer{flex:1}

        .main{padding-top:60px}
        .content{max-width:860px;margin:0 auto;padding:28px 24px}

        /* TOAST */
        .toast{padding:10px 16px;border-radius:9px;font-size:13px;font-weight:600;
            margin-bottom:16px;display:flex;align-items:center;gap:8px}
        .toast-success{background:rgba(56,217,169,.12);border:1px solid rgba(56,217,169,.3);color:var(--accent2)}
        .toast-error{background:rgba(247,92,92,.12);border:1px solid rgba(247,92,92,.3);color:var(--danger)}

        /* HEADER ROW */
        .page-header{display:flex;align-items:flex-start;justify-content:space-between;
            margin-bottom:20px;gap:12px}
        .page-header-left h1{font-size:20px;font-weight:800;letter-spacing:-.3px;margin-bottom:4px}
        .page-header-left h1 span{color:var(--warn)}
        .page-header-left p{font-size:12px;color:var(--muted)}
        .btn-row{display:flex;gap:8px;flex-shrink:0}

        /* BUTTONS */
        .btn{display:inline-flex;align-items:center;gap:6px;padding:9px 18px;
            border-radius:8px;font-size:13px;font-weight:700;cursor:pointer;
            font-family:inherit;border:none;transition:all .15s;text-decoration:none}
        .btn-warn{background:var(--warn);color:#000}.btn-warn:hover{background:#f0b429}
        .btn-outline{background:transparent;border:1px solid var(--border);color:var(--muted)}
        .btn-outline:hover{border-color:var(--text);color:var(--text)}
        .btn-danger{background:rgba(247,92,92,.15);color:var(--danger);border:1px solid rgba(247,92,92,.3)}
        .btn-danger:hover{background:var(--danger);color:#fff}
        .btn-edit{background:rgba(251,191,36,.15);color:var(--warn);border:1px solid rgba(251,191,36,.3)}
        .btn-edit:hover{background:var(--warn);color:#000}
        .btn:disabled{opacity:.4;cursor:not-allowed;pointer-events:none}

        /* BADGE KHÓA */
        .locked-notice{display:inline-flex;align-items:center;gap:6px;
            padding:6px 14px;border-radius:8px;font-size:12px;font-weight:700;
            background:rgba(56,217,169,.1);border:1px solid rgba(56,217,169,.3);color:var(--accent2)}

        /* CARD */
        .card{background:var(--surface);border:1px solid var(--border);
            border-radius:var(--radius);margin-bottom:14px;overflow:hidden}
        .card-head{padding:14px 20px;border-bottom:1px solid var(--border);
            display:flex;align-items:center;gap:10px}
        .card-ico{width:32px;height:32px;border-radius:8px;
            display:flex;align-items:center;justify-content:center;font-size:16px}
        .ico-warn{background:rgba(251,191,36,.15)}
        .ico-blue{background:rgba(79,142,247,.15)}
        .ico-green{background:rgba(56,217,169,.15)}
        .card-head h3{font-size:14px;font-weight:700}
        .card-body{padding:20px}

        /* INFO GRID */
        .info-grid{display:grid;grid-template-columns:1fr 1fr;gap:0}
        .info-row{padding:11px 0;border-bottom:1px solid rgba(42,48,72,.5);display:flex;flex-direction:column;gap:3px}
        .info-row:last-child{border:none}
        .info-row.full{grid-column:1/-1}
        .info-label{font-size:10px;font-weight:700;text-transform:uppercase;letter-spacing:.06em;color:var(--muted)}
        .info-val{font-size:14px;font-weight:500;color:var(--text);line-height:1.5;white-space:pre-line}
        .info-val.muted{color:var(--muted);font-style:italic;font-size:13px}

        /* BADGE */
        .badge{display:inline-flex;align-items:center;gap:4px;padding:4px 11px;
            border-radius:100px;font-size:11px;font-weight:700}
        .badge::before{content:'';width:5px;height:5px;border-radius:50%;background:currentColor}
        .badge-1{background:rgba(100,116,139,.15);color:var(--muted)}
        .badge-2{background:rgba(79,142,247,.15);color:var(--accent)}
        .badge-3{background:rgba(56,217,169,.15);color:var(--accent2)}
        .badge-4{background:rgba(247,92,92,.15);color:var(--danger)}

        /* TAG đối tượng */
        .tag{display:inline-flex;align-items:center;gap:4px;padding:3px 10px;
            border-radius:100px;font-size:11px;font-weight:600;
            background:rgba(79,142,247,.1);color:var(--accent);border:1px solid rgba(79,142,247,.2);
            margin:3px 4px 3px 0}

        /* THIỆP IN — chỉ hiện khi print */
        .print-area{display:none}
        @media print{
            body *{visibility:hidden}
            .print-area,.print-area *{visibility:visible}
            .print-area{display:block!important;position:fixed;inset:0;
                background:#fff;padding:40px;font-family:'Be Vietnam Pro',sans-serif}
            .p-quoc-hieu{text-align:center;font-size:12px;color:#555;text-transform:uppercase;letter-spacing:.05em;margin-bottom:4px}
            .p-doc-lap{text-align:center;font-size:13px;font-weight:700;color:#333;margin-bottom:20px}
            .p-title{text-align:center;font-size:26px;font-weight:800;color:#c8901a;letter-spacing:2px;margin-bottom:6px}
            .p-subtitle{text-align:center;font-size:15px;font-weight:600;color:#222;margin-bottom:24px}
            .p-row{display:flex;gap:8px;padding:8px 0;border-bottom:1px solid #eee;font-size:13px}
            .p-row:last-of-type{border:none}
            .p-lbl{min-width:130px;color:#666;font-weight:600;flex-shrink:0}
            .p-val{color:#111;font-weight:500;white-space:pre-line}
            .p-footer{text-align:center;margin-top:32px;font-size:12px;color:#888;font-style:italic;border-top:1px solid #eee;padding-top:16px}
            .p-sign{display:flex;justify-content:flex-end;margin-top:40px;font-size:13px;text-align:center}
            .p-sign-box{min-width:200px}
            .p-sign-title{font-weight:700;margin-bottom:60px}
            .p-sign-name{font-weight:700;font-size:14px}
        }
    </style>
</head>
<body>

<header class="topbar">
    <a href="${pageContext.request.contextPath}/totruong/dashboard" class="topbar-logo">
        <div class="logo-icon">🏘</div>
        <div class="logo-text">Quản lý <span>Hộ dân</span></div>
    </a>
    <div class="topbar-div"></div>
    <div class="breadcrumb">
        <a href="${pageContext.request.contextPath}/totruong/dashboard">Trang chủ</a> ›
        <a href="${pageContext.request.contextPath}/thiepmoi/danh-sach">Thiệp mời</a> ›
        <span class="cur">Chi tiết</span>
    </div>
    <div class="topbar-spacer"></div>
</header>

<!-- VÙNG IN (ẩn trên màn hình, hiện khi Ctrl+P) -->
<div class="print-area">
    <div class="p-quoc-hieu">Cộng hòa Xã hội Chủ nghĩa Việt Nam</div>
    <div class="p-doc-lap">Độc lập — Tự do — Hạnh phúc</div>
    <div class="p-title">THIỆP MỜI</div>
    <div class="p-subtitle">${thiep.tieuDe}</div>
    <div class="p-row"><span class="p-lbl">Tổ dân phố:</span><span class="p-val">${thiep.tenTo}</span></div>
    <div class="p-row">
        <span class="p-lbl">Thời gian bắt đầu:</span>
        <span class="p-val"><fmt:formatDate value="${thiep.thoiGianBatDau}" pattern="HH:mm — dd/MM/yyyy"/></span>
    </div>
    <c:if test="${not empty thiep.thoiGianKetThuc}">
    <div class="p-row">
        <span class="p-lbl">Thời gian kết thúc:</span>
        <span class="p-val"><fmt:formatDate value="${thiep.thoiGianKetThuc}" pattern="HH:mm — dd/MM/yyyy"/></span>
    </div>
    </c:if>
    <div class="p-row"><span class="p-lbl">Địa điểm:</span><span class="p-val">${thiep.diaDiem}</span></div>
    <div class="p-row"><span class="p-lbl">Nội dung:</span><span class="p-val">${thiep.noiDung}</span></div>
    <div class="p-footer">Kính mời quý hộ dân có mặt đúng giờ. Trân trọng!</div>
    <div class="p-sign">
        <div class="p-sign-box">
            <div class="p-sign-title">Tổ trưởng tổ dân phố</div>
            <div class="p-sign-name">${thiep.tenNguoiTao}</div>
        </div>
    </div>
</div>

<main class="main">
<div class="content">

    <!-- TOAST -->
    <c:if test="${not empty successMsg}">
        <div class="toast toast-success">✅ ${successMsg}</div>
    </c:if>
    <c:if test="${not empty errorMsg}">
        <div class="toast toast-error">❌ ${errorMsg}</div>
    </c:if>

    <!-- HEADER -->
    <div class="page-header">
        <div class="page-header-left">
            <h1>Chi tiết <span>thiệp mời</span></h1>
            <p>Xem thông tin và thực hiện thao tác với thiệp mời</p>
        </div>
        <div class="btn-row">
            <a href="${pageContext.request.contextPath}/thiepmoi/danh-sach" class="btn btn-outline">← Quay lại</a>

            <c:choose>
                <c:when test="${thiep.daIn}">
                    <span class="locked-notice">🔒 Đã in — không thể sửa/xóa</span>
                    <button class="btn btn-warn" onclick="window.print()">🖨️ In lại thiệp</button>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/thiepmoi/sua?id=${thiep.thiepMoiID}"
                       class="btn btn-edit">✏️ Sửa thiệp</a>

                    <!-- NÚT IN — xác nhận trước khi khóa -->
                    <button class="btn btn-warn" onclick="confirmIn()">🖨️ In thiệp</button>

                    <!-- NÚT XÓA -->
                    <button class="btn btn-danger" onclick="confirmXoa()">🗑️ Xóa</button>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- FORM ẨN ĐỂ POST IN -->
    <form id="formIn" method="post" action="${pageContext.request.contextPath}/thiepmoi/chi-tiet" style="display:none">
        <input type="hidden" name="thiepMoiID" value="${thiep.thiepMoiID}">
    </form>

    <!-- FORM ẨN ĐỂ POST XÓA -->
    <form id="formXoa" method="post" action="${pageContext.request.contextPath}/thiepmoi/xoa" style="display:none">
        <input type="hidden" name="thiepMoiID" value="${thiep.thiepMoiID}">
    </form>

    <!-- LAYOUT 2 CỘT: INFO TRÁI + PREVIEW PHẢI -->
    <div style="display:grid;grid-template-columns:1fr 420px;gap:14px;align-items:start">

        <!-- CỘT TRÁI: THÔNG TIN -->
        <div class="card">
            <div class="card-head">
                <div class="card-ico ico-warn">💌</div>
                <h3>Thông tin thiệp mời</h3>
                <span style="margin-left:auto">
                    <span class="badge badge-${thiep.trangThaiID}">${thiep.tenTrangThai}</span>
                </span>
            </div>
            <div class="card-body" style="padding:0">
                <table style="width:100%;border-collapse:collapse;font-size:13px">
                    <tr style="border-bottom:1px solid rgba(42,48,72,.5)">
                        <td style="padding:10px 16px;color:var(--muted);font-size:10px;font-weight:700;text-transform:uppercase;letter-spacing:.06em;width:120px;vertical-align:top">Tiêu đề</td>
                        <td style="padding:10px 16px;font-weight:600;color:var(--text)">${thiep.tieuDe}</td>
                    </tr>
                    <tr style="border-bottom:1px solid rgba(42,48,72,.5)">
                        <td style="padding:10px 16px;color:var(--muted);font-size:10px;font-weight:700;text-transform:uppercase;letter-spacing:.06em;vertical-align:top">Tổ dân phố</td>
                        <td style="padding:10px 16px;color:var(--text)">${thiep.tenTo}</td>
                    </tr>
                    <tr style="border-bottom:1px solid rgba(42,48,72,.5)">
                        <td style="padding:10px 16px;color:var(--muted);font-size:10px;font-weight:700;text-transform:uppercase;letter-spacing:.06em;vertical-align:top">Người tạo</td>
                        <td style="padding:10px 16px;color:var(--text)">${thiep.tenNguoiTao}</td>
                    </tr>
                    <tr style="border-bottom:1px solid rgba(42,48,72,.5)">
                        <td style="padding:10px 16px;color:var(--muted);font-size:10px;font-weight:700;text-transform:uppercase;letter-spacing:.06em;vertical-align:top">Bắt đầu</td>
                        <td style="padding:10px 16px;color:var(--text)"><fmt:formatDate value="${thiep.thoiGianBatDau}" pattern="HH:mm — dd/MM/yyyy"/></td>
                    </tr>
                    <tr style="border-bottom:1px solid rgba(42,48,72,.5)">
                        <td style="padding:10px 16px;color:var(--muted);font-size:10px;font-weight:700;text-transform:uppercase;letter-spacing:.06em;vertical-align:top">Kết thúc</td>
                        <td style="padding:10px 16px;color:var(--text)">
                            <c:choose>
                                <c:when test="${not empty thiep.thoiGianKetThuc}"><fmt:formatDate value="${thiep.thoiGianKetThuc}" pattern="HH:mm — dd/MM/yyyy"/></c:when>
                                <c:otherwise><span style="color:var(--muted);font-style:italic">Không xác định</span></c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                    <tr style="border-bottom:1px solid rgba(42,48,72,.5)">
                        <td style="padding:10px 16px;color:var(--muted);font-size:10px;font-weight:700;text-transform:uppercase;letter-spacing:.06em;vertical-align:top">Địa điểm</td>
                        <td style="padding:10px 16px;color:var(--text)">
                            <c:choose>
                                <c:when test="${not empty thiep.diaDiem}">${thiep.diaDiem}</c:when>
                                <c:otherwise><span style="color:var(--muted);font-style:italic">Chưa có địa điểm</span></c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                    <tr style="border-bottom:1px solid rgba(42,48,72,.5)">
                        <td style="padding:10px 16px;color:var(--muted);font-size:10px;font-weight:700;text-transform:uppercase;letter-spacing:.06em;vertical-align:top">Nội dung</td>
                        <td style="padding:10px 16px;color:var(--text);white-space:pre-line;line-height:1.7">
                            <c:choose>
                                <c:when test="${not empty thiep.noiDung}">${thiep.noiDung}</c:when>
                                <c:otherwise><span style="color:var(--muted);font-style:italic">Chưa có nội dung</span></c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding:10px 16px;color:var(--muted);font-size:10px;font-weight:700;text-transform:uppercase;letter-spacing:.06em;vertical-align:top">Ngày tạo</td>
                        <td style="padding:10px 16px;color:var(--muted);font-size:12px"><fmt:formatDate value="${thiep.ngayTao}" pattern="HH:mm — dd/MM/yyyy"/></td>
                    </tr>
                    <c:if test="${thiep.daIn}">
                    <tr style="border-top:1px solid rgba(42,48,72,.5)">
                        <td style="padding:10px 16px;color:var(--muted);font-size:10px;font-weight:700;text-transform:uppercase;letter-spacing:.06em;vertical-align:top">Thời gian in</td>
                        <td style="padding:10px 16px;color:var(--accent2);font-size:12px"><fmt:formatDate value="${thiep.thoiGianIn}" pattern="HH:mm — dd/MM/yyyy"/></td>
                    </tr>
                    </c:if>
                </table>
            </div>
        </div>

        <!-- CỘT PHẢI: PREVIEW THIỆP -->
        <div class="card" style="position:sticky;top:72px">
            <div class="card-head">
                <div class="card-ico ico-green">👁</div>
                <h3>Xem trước</h3>
            </div>
            <div class="card-body" style="background:var(--surface2);padding:16px">
                <div style="background:#fff;color:#1a1a2e;border-radius:8px;padding:20px 22px;
                            font-family:'Be Vietnam Pro',sans-serif;font-size:12px">
                    <div style="text-align:center;border-bottom:1.5px solid #e8e8e8;padding-bottom:10px;margin-bottom:14px">
                        <div style="font-size:9px;font-weight:600;color:#777;text-transform:uppercase;letter-spacing:.05em">Cộng hòa XHCN Việt Nam</div>
                        <div style="font-size:18px;font-weight:800;color:#c8901a;letter-spacing:1px;margin:4px 0 2px">THIỆP MỜI</div>
                        <div style="font-size:11px;font-weight:600;color:#333;line-height:1.4">${thiep.tieuDe}</div>
                    </div>
                    <div style="display:flex;gap:6px;padding:6px 0;border-bottom:1px solid #f0f0f0">
                        <span style="color:#888;min-width:80px;font-weight:600;flex-shrink:0;font-size:11px">🕐 Thời gian</span>
                        <span style="color:#222;font-weight:500;font-size:11px"><fmt:formatDate value="${thiep.thoiGianBatDau}" pattern="HH:mm dd/MM/yyyy"/></span>
                    </div>
                    <div style="display:flex;gap:6px;padding:6px 0;border-bottom:1px solid #f0f0f0">
                        <span style="color:#888;min-width:80px;font-weight:600;flex-shrink:0;font-size:11px">📍 Địa điểm</span>
                        <span style="color:#222;font-weight:500;font-size:11px">${not empty thiep.diaDiem ? thiep.diaDiem : '—'}</span>
                    </div>
                    <div style="display:flex;gap:6px;padding:6px 0">
                        <span style="color:#888;min-width:80px;font-weight:600;flex-shrink:0;font-size:11px">📋 Nội dung</span>
                        <span style="color:#222;font-weight:500;font-size:11px;white-space:pre-line;line-height:1.6">${not empty thiep.noiDung ? thiep.noiDung : '—'}</span>
                    </div>
                    <div style="text-align:center;margin-top:14px;padding-top:10px;border-top:1px solid #e8e8e8;font-size:10px;color:#888;font-style:italic">
                        Kính mời quý hộ dân có mặt đúng giờ. Trân trọng!
                    </div>
                </div>
            </div>
        </div>

    </div>

</div>
</main>

<script>
function confirmIn() {
    if (!confirm('Sau khi in, thiệp sẽ bị KHÓA và không thể sửa hoặc xóa.\n\nTiếp tục in?')) return;
    // Submit form in → server ghi log rồi redirect về đây
    document.getElementById('formIn').submit();
    // Sau khi server xử lý xong thì window.print() sẽ được gọi qua flag
}

function confirmXoa() {
    if (!confirm('Xóa thiệp này sẽ gửi thông báo [HỦY] đến toàn bộ hộ dân.\n\nXác nhận xóa?')) return;
    document.getElementById('formXoa').submit();
}

// Nếu vừa in thành công (server redirect về với flag) thì tự mở hộp thoại in
<c:if test="${thiep.daIn and not empty successMsg}">
    window.onload = function(){ window.print(); };
</c:if>
</script>
</body>
</html>
