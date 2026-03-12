<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh sách hộ dân</title>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg: #0f1117; --surface: #181c27; --surface2: #1f2433;
            --border: #2a3048; --accent: #4f8ef7; --accent2: #38d9a9;
            --danger: #f75c5c; --warn: #fbbf24; --text: #e2e8f0; --muted: #64748b;
            --radius: 12px;
        }
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Be Vietnam Pro', sans-serif; background: var(--bg); color: var(--text); min-height: 100vh; }

        /* TOPBAR */
        .topbar {
            position: fixed; top: 0; left: 0; right: 0; z-index: 200;
            height: 64px; background: rgba(15,17,23,.88);
            backdrop-filter: blur(16px); border-bottom: 1px solid var(--border);
            display: flex; align-items: center; padding: 0 32px; gap: 16px;
        }
        .topbar-logo { display: flex; align-items: center; gap: 10px; text-decoration: none; color: var(--text); }
        .logo-icon {
            width: 34px; height: 34px; border-radius: 8px;
            background: linear-gradient(135deg, var(--accent), var(--accent2));
            display: flex; align-items: center; justify-content: center; font-size: 16px;
        }
        .logo-text { font-size: 14px; font-weight: 700; }
        .logo-text span { color: var(--accent); }
        .topbar-divider { width: 1px; height: 24px; background: var(--border); }
        .topbar-title { font-size: 13px; font-weight: 600; color: var(--muted); }
        .topbar-spacer { flex: 1; }
        .back-btn {
            display: flex; align-items: center; gap: 6px;
            padding: 7px 14px; border-radius: 8px;
            background: var(--surface2); border: 1px solid var(--border);
            color: var(--text); text-decoration: none; font-size: 13px; font-weight: 600;
            transition: all .18s;
        }
        .back-btn:hover { border-color: var(--accent); color: var(--accent); }

        /* AVATAR */
        .avatar-sm {
            width: 34px; height: 34px; border-radius: 50%;
            background: linear-gradient(135deg, var(--accent), var(--accent2));
            display: flex; align-items: center; justify-content: center;
            font-size: 13px; font-weight: 700; color: #fff; text-transform: uppercase;
        }

        /* MAIN */
        .main { padding-top: 64px; }
        .content { max-width: 1100px; margin: 0 auto; padding: 36px 32px; }

        .page-header { margin-bottom: 28px; }
        .breadcrumb { font-size: 12px; color: var(--muted); margin-bottom: 8px; }
        .breadcrumb a { color: var(--accent); text-decoration: none; }
        .page-header h1 { font-size: 24px; font-weight: 800; letter-spacing: -.4px; }
        .page-header p  { font-size: 14px; color: var(--muted); margin-top: 4px; }

        /* SEARCH BAR */
        .search-wrap {
            background: var(--surface); border: 1px solid var(--border);
            border-radius: var(--radius); padding: 18px 24px;
            display: flex; gap: 12px; align-items: center; margin-bottom: 24px;
        }
        .search-wrap input {
            flex: 1; background: var(--surface2); border: 1px solid var(--border);
            color: var(--text); padding: 10px 14px; border-radius: 8px;
            font-size: 14px; font-family: inherit; transition: border-color .18s;
        }
        .search-wrap input:focus { outline: none; border-color: var(--accent); }
        .btn {
            display: inline-flex; align-items: center; gap: 6px;
            padding: 10px 20px; border-radius: 8px; font-size: 14px;
            font-weight: 600; font-family: inherit; border: none; cursor: pointer;
            text-decoration: none; transition: all .18s;
        }
        .btn-primary { background: var(--accent); color: #fff; }
        .btn-primary:hover { background: #3a7de8; }
        .btn-secondary {
            background: var(--surface2); color: var(--text);
            border: 1px solid var(--border);
        }
        .btn-secondary:hover { border-color: var(--accent); color: var(--accent); }

        /* SUMMARY */
        .summary-row {
            display: flex; gap: 12px; margin-bottom: 24px; flex-wrap: wrap;
        }
        .sum-chip {
            background: var(--surface); border: 1px solid var(--border);
            border-radius: 10px; padding: 12px 20px;
            display: flex; align-items: center; gap: 10px;
        }
        .sum-chip .sc-num { font-size: 22px; font-weight: 800; color: var(--accent); }
        .sum-chip .sc-label { font-size: 12px; color: var(--muted); }

        /* ACCORDION */
        .accordion { display: flex; flex-direction: column; gap: 12px; }

        .acc-group {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius);
            overflow: hidden;
        }

        .acc-header {
            display: flex; align-items: center; justify-content: space-between;
            padding: 16px 20px; cursor: pointer;
            transition: background .18s; user-select: none;
        }
        .acc-header:hover { background: var(--surface2); }
        .acc-header.open { background: var(--surface2); border-bottom: 1px solid var(--border); }

        .acc-left { display: flex; align-items: center; gap: 12px; }
        .acc-road-icon {
            width: 36px; height: 36px; border-radius: 8px;
            background: rgba(79,142,247,.15);
            display: flex; align-items: center; justify-content: center; font-size: 16px;
        }
        .acc-road-name { font-size: 15px; font-weight: 700; }
        .acc-road-sub  { font-size: 12px; color: var(--muted); margin-top: 2px; }

        .acc-right { display: flex; align-items: center; gap: 12px; }
        .acc-count {
            background: rgba(79,142,247,.15); color: var(--accent);
            font-size: 12px; font-weight: 700;
            padding: 4px 12px; border-radius: 20px;
        }
        .acc-chevron {
            font-size: 13px; color: var(--muted);
            transition: transform .25s;
        }
        .acc-header.open .acc-chevron { transform: rotate(180deg); }

        /* TABLE */
        .acc-body { display: none; }
        .acc-body.open { display: block; animation: fadeIn .2s ease; }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-4px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        .ho-table { width: 100%; border-collapse: collapse; font-size: 13px; }
        .ho-table thead tr { background: rgba(255,255,255,.02); }
        .ho-table th {
            padding: 11px 16px; text-align: left;
            color: var(--muted); font-size: 11px; font-weight: 700;
            text-transform: uppercase; letter-spacing: .5px;
            border-bottom: 1px solid var(--border);
        }
        .ho-table td {
            padding: 13px 16px; border-bottom: 1px solid rgba(42,48,72,.5);
            vertical-align: middle;
        }
        .ho-table tbody tr:last-child td { border-bottom: none; }
        .ho-table tbody tr:hover { background: var(--surface2); }

        .pill {
            font-size: 11px; font-weight: 600; padding: 3px 10px; border-radius: 20px;
        }
        .pill.thuongtru { background: rgba(56,217,169,.15); color: var(--accent2); }
        .pill.tamtru    { background: rgba(251,191,36,.15);  color: var(--warn); }
        .pill.tamvang   { background: rgba(247,92,92,.15);   color: var(--danger); }

        .ho-avatar {
            width: 30px; height: 30px; border-radius: 50%;
            background: linear-gradient(135deg, #667eea, #764ba2);
            display: inline-flex; align-items: center; justify-content: center;
            font-size: 11px; font-weight: 700; color: #fff; margin-right: 8px;
            text-transform: uppercase; vertical-align: middle;
        }

        .empty-state {
            text-align: center; padding: 48px; color: var(--muted);
        }
        .empty-state .es-icon { font-size: 40px; margin-bottom: 12px; }
    </style>
</head>
<body>

<!-- TOPBAR -->
<header class="topbar">
    <a href="${pageContext.request.contextPath}/totruong/dashboard" class="topbar-logo">
        <div class="logo-icon">🏘</div>
        <div class="logo-text">Quản lý <span>Hộ dân</span></div>
    </a>
    <div class="topbar-divider"></div>
    <span class="topbar-title">Danh sách hộ dân</span>
    <div class="topbar-spacer"></div>
    <a href="${pageContext.request.contextPath}/totruong/dashboard" class="back-btn">← Dashboard</a>
    <div class="avatar-sm" id="avatarTop">TT</div>
</header>

<main class="main">
    <div class="content">

        <div class="page-header">
            <div class="breadcrumb">
                <a href="${pageContext.request.contextPath}/totruong/dashboard">Dashboard</a>
                / Danh sách hộ dân
            </div>
            <h1>Danh sách hộ dân</h1>
            <p>Quản lý các hộ gia đình trong tổ dân phố</p>
        </div>

        <!-- SEARCH -->
        <form class="search-wrap"
              action="${pageContext.request.contextPath}/todan/hodan" method="get">
            <input type="text" name="keyword" value="${keyword}"
                   placeholder="🔍 Tìm theo địa chỉ, mã hộ khẩu, tên chủ hộ...">
            <button type="submit" class="btn btn-primary">Tìm kiếm</button>
            <c:if test="${not empty keyword}">
                <a href="${pageContext.request.contextPath}/todan/hodan"
                   class="btn btn-secondary">✕ Xóa</a>
            </c:if>
        </form>

        <!-- SUMMARY -->
        <div class="summary-row">
            <div class="sum-chip">
                <div class="sc-num">${tongSoHo}</div>
                <div class="sc-label">Tổng số hộ</div>
            </div>
            <div class="sum-chip">
                <div class="sc-num" style="color:var(--accent2)">${nhomTheoDuong.size()}</div>
                <div class="sc-label">Số tuyến đường</div>
            </div>
        </div>

        <!-- ACCORDION -->
        <c:choose>
            <c:when test="${not empty nhomTheoDuong}">
                <div class="accordion">
                    <c:forEach var="entry" items="${nhomTheoDuong}" varStatus="st">
                        <div class="acc-group">
                            <div class="acc-header ${st.index == 0 ? 'open' : ''}"
                                 onclick="toggleAcc(this)">
                                <div class="acc-left">
                                    <div class="acc-road-icon">🛣</div>
                                    <div>
                                        <div class="acc-road-name">${entry.key}</div>
                                        <div class="acc-road-sub">${entry.value.size()} hộ gia đình</div>
                                    </div>
                                </div>
                                <div class="acc-right">
                                    <span class="acc-count">${entry.value.size()} hộ</span>
                                    <span class="acc-chevron">▼</span>
                                </div>
                            </div>

                            <div class="acc-body ${st.index == 0 ? 'open' : ''}">
                                <table class="ho-table">
                                    <thead>
                                        <tr>
                                            <th>#</th>
                                            <th>Mã hộ khẩu</th>
                                            <th>Địa chỉ</th>
                                            <th>Chủ hộ</th>
                                            <th>Số thành viên</th>
                                            <th>Trạng thái</th>
                                            <th>Ngày tạo</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="ho" items="${entry.value}" varStatus="s">
                                            <tr>
                                                <td style="color:var(--muted)">${s.index + 1}</td>
                                                <td style="font-family:monospace; color:var(--accent)">
                                                    ${ho.maHoKhau}
                                                </td>
                                                <td>${ho.diaChi}</td>
                                                <td>
                                                    <span class="ho-avatar">
                                                        ${ho.tenChuHo.length() > 0 ? ho.tenChuHo.substring(ho.tenChuHo.length()-1) : '?'}
                                                    </span>
                                                    ${ho.tenChuHo}
                                                </td>
                                                <td style="text-align:center; font-weight:700">
                                                    ${ho.soThanhVien}
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${ho.trangThaiID == 1}">
                                                            <span class="pill thuongtru">${ho.tenTrangThai}</span>
                                                        </c:when>
                                                        <c:when test="${ho.trangThaiID == 2}">
                                                            <span class="pill tamtru">${ho.tenTrangThai}</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="pill tamvang">${ho.tenTrangThai}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td style="color:var(--muted); font-size:12px">
                                                    ${ho.ngayTao}
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <div class="es-icon">🏠</div>
                    <p>${not empty keyword ? 'Không tìm thấy hộ dân nào phù hợp.' : 'Chưa có hộ dân nào trong tổ.'}</p>
                </div>
            </c:otherwise>
        </c:choose>

    </div>
</main>

<script>
    // Avatar initials
    const ten = '${currentUser.ten}' || 'TT';
    document.getElementById('avatarTop').textContent = ten.trim().substring(0,2).toUpperCase();

    // Toggle accordion
    function toggleAcc(header) {
        const body = header.nextElementSibling;
        const isOpen = header.classList.contains('open');
        header.classList.toggle('open', !isOpen);
        body.classList.toggle('open', !isOpen);
    }
</script>
</body>
</html>