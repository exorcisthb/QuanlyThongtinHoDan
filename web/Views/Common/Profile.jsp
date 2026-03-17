<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hồ sơ cá nhân</title>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg: #0f1117; --surface: #181c27; --surface2: #1f2433;
            --border: #2a3048; --accent: #4f8ef7; --accent2: #38d9a9;
            --danger: #f75c5c; --warn: #fbbf24; --text: #e2e8f0; --muted: #64748b;
        }
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: 'Be Vietnam Pro', sans-serif; background: var(--bg);
            color: var(--text); min-height: 100vh;
            display: flex; align-items: center; justify-content: center; padding: 40px 16px;
        }
        .profile-wrap { width: 100%; max-width: 680px; }
        .back-link {
            display: inline-flex; align-items: center; gap: 6px;
            font-size: 13px; color: var(--muted); text-decoration: none;
            margin-bottom: 24px; transition: color .15s;
        }
        .back-link:hover { color: var(--accent); }
        .alert { display: flex; align-items: flex-start; gap: 12px; padding: 12px 16px; border-radius: 8px; font-size: 13px; margin-bottom: 24px; }
        .alert.success { background: rgba(56,217,169,.1); border: 1px solid rgba(56,217,169,.25); color: var(--accent2); }
        .alert.error   { background: rgba(247,92,92,.1);  border: 1px solid rgba(247,92,92,.25);  color: var(--danger); }
        .card { background: var(--surface); border: 1px solid var(--border); border-radius: 16px; overflow: hidden; }
        .card-top {
            padding: 36px 36px 0; display: flex; align-items: flex-end; gap: 24px;
            border-bottom: 1px solid var(--border);
        }
        .avatar-wrap { position: relative; flex-shrink: 0; margin-bottom: -28px; }
        .avatar-img {
            width: 100px; height: 100px; border-radius: 50%;
            border: 4px solid var(--surface); overflow: hidden;
            display: flex; align-items: center; justify-content: center;
            font-size: 36px; font-weight: 700; color: #fff; text-transform: uppercase;
        }
        .avatar-img img { width: 100%; height: 100%; object-fit: cover; }
        .avatar-edit {
            position: absolute; bottom: 28px; right: 0;
            width: 28px; height: 28px; border-radius: 50%;
            background: var(--accent); border: 2px solid var(--surface);
            display: flex; align-items: center; justify-content: center;
            cursor: pointer; font-size: 12px; transition: background .15s;
        }
        .avatar-edit:hover { background: #3a7de8; }
        .card-top-info { flex: 1; padding-bottom: 24px; }
        .profile-name { font-size: 22px; font-weight: 700; margin-bottom: 6px; }
        .profile-role {
            display: inline-flex; align-items: center; gap: 6px;
            font-size: 12px; font-weight: 600; padding: 3px 10px; border-radius: 20px;
        }
        .role-admin { background: rgba(79,142,247,.15);  color: var(--accent);  border: 1px solid rgba(79,142,247,.25); }
        .role-tt    { background: rgba(56,217,169,.15);  color: var(--accent2); border: 1px solid rgba(56,217,169,.25); }
        .role-cb    { background: rgba(251,191,36,.15);  color: var(--warn);    border: 1px solid rgba(251,191,36,.25); }
        .role-hd    { background: rgba(56,217,169,.15);  color: var(--accent2); border: 1px solid rgba(56,217,169,.25); }
        .card-body { padding: 40px 36px 36px; }
        .section-title {
            font-size: 11px; font-weight: 700; text-transform: uppercase;
            letter-spacing: 1px; color: var(--muted);
            margin-bottom: 16px; padding-bottom: 8px; border-bottom: 1px solid var(--border);
        }
        .info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-bottom: 28px; }
        .info-item { display: flex; flex-direction: column; gap: 4px; }
        .info-item.full { grid-column: 1 / -1; }
        .info-label { font-size: 11px; font-weight: 600; color: var(--muted); text-transform: uppercase; letter-spacing: .5px; }
        .info-value {
            font-size: 14px; font-weight: 500; color: var(--text);
            background: var(--surface2); border: 1px solid var(--border);
            border-radius: 8px; padding: 10px 14px;
        }
        .info-value.mono { font-family: 'Courier New', monospace; font-size: 13px; letter-spacing: .5px; }
        .upload-btn { display: none; }
        @media (max-width: 600px) {
            .info-grid { grid-template-columns: 1fr; }
            .card-top { flex-direction: column; align-items: center; text-align: center; padding-top: 28px; }
            .avatar-wrap { margin-bottom: -28px; }
        }
    </style>
</head>
<body>
<div class="profile-wrap">

    <%-- ✅ Back link — khớp đúng TenVaiTro trong DB --%>
    <c:choose>
        <c:when test="${profile.tenVaiTro == 'Admin'}">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="back-link">← Quay lại Dashboard</a>
        </c:when>
        <c:when test="${profile.tenVaiTro == 'ToTruong'}">
            <a href="${pageContext.request.contextPath}/totruong/dashboard" class="back-link">← Quay lại Dashboard</a>
        </c:when>
        <c:when test="${profile.tenVaiTro == 'CanBoPhuong'}">
            <a href="${pageContext.request.contextPath}/canbophuong/dashboard" class="back-link">← Quay lại Dashboard</a>
        </c:when>
        <c:otherwise>
            <a href="${pageContext.request.contextPath}/hodan/dashboard" class="back-link">← Quay lại Dashboard</a>
        </c:otherwise>
    </c:choose>

    <c:if test="${not empty message}">
        <div class="alert success">✅ ${message}</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert error">⚠️ ${error}</div>
    </c:if>

    <div class="card">
        <%-- Gradient card-top theo role --%>
        <c:choose>
            <c:when test="${profile.tenVaiTro == 'Admin'}">
                <div class="card-top" style="background:linear-gradient(135deg,rgba(79,142,247,.18),rgba(56,217,169,.08));">
            </c:when>
            <c:when test="${profile.tenVaiTro == 'ToTruong'}">
                <div class="card-top" style="background:linear-gradient(135deg,rgba(56,217,169,.15),rgba(79,142,247,.08));">
            </c:when>
            <c:when test="${profile.tenVaiTro == 'CanBoPhuong'}">
                <div class="card-top" style="background:linear-gradient(135deg,rgba(251,191,36,.12),rgba(79,142,247,.08));">
            </c:when>
            <c:otherwise>
                <div class="card-top" style="background:linear-gradient(135deg,rgba(56,217,169,.12),rgba(79,142,247,.06));">
            </c:otherwise>
        </c:choose>

            <div class="avatar-wrap">
                <%-- Gradient avatar theo role --%>
                <c:choose>
                    <c:when test="${profile.tenVaiTro == 'Admin'}">
                        <div class="avatar-img" style="background:linear-gradient(135deg,var(--accent),var(--accent2));">
                    </c:when>
                    <c:when test="${profile.tenVaiTro == 'CanBoPhuong'}">
                        <div class="avatar-img" style="background:linear-gradient(135deg,var(--warn),var(--accent));">
                    </c:when>
                    <c:otherwise>
                        <div class="avatar-img" style="background:linear-gradient(135deg,var(--accent2),var(--accent));">
                    </c:otherwise>
                </c:choose>
                    <c:choose>
                        <c:when test="${not empty profile.avatarPath}">
                            <img src="${pageContext.request.contextPath}/${profile.avatarPath}" alt="avatar">
                        </c:when>
                        <c:otherwise>${profile.ten.substring(0,1)}</c:otherwise>
                    </c:choose>
                </div>
                <form action="${pageContext.request.contextPath}/profile"
                      method="post" enctype="multipart/form-data" id="avatarForm">
                    <input type="file" name="avatar" id="avatarInput" class="upload-btn"
                           accept="image/*" onchange="document.getElementById('avatarForm').submit()">
                    <div class="avatar-edit" onclick="document.getElementById('avatarInput').click()" title="Đổi ảnh">✎</div>
                </form>
            </div>

            <div class="card-top-info">
                <div class="profile-name">${profile.ho} ${profile.ten}</div>
                <%-- Badge role --%>
                <c:choose>
                    <c:when test="${profile.tenVaiTro == 'Admin'}">
                        <span class="profile-role role-admin">🛡 Quản trị viên</span>
                    </c:when>
                    <c:when test="${profile.tenVaiTro == 'ToTruong'}">
                        <span class="profile-role role-tt">🏘 Tổ trưởng</span>
                    </c:when>
                    <c:when test="${profile.tenVaiTro == 'CanBoPhuong'}">
                        <span class="profile-role role-cb">🏛 Cán bộ phường</span>
                    </c:when>
                    <c:otherwise>
                        <span class="profile-role role-hd">🏠 Hộ dân</span>
                    </c:otherwise>
                </c:choose>
            </div>
        </div><%-- end card-top --%>

        <div class="card-body">
            <div class="section-title">Thông tin cá nhân</div>
            <div class="info-grid">
                <div class="info-item">
                    <div class="info-label">Họ và chữ đệm</div>
                    <div class="info-value">${profile.ho}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">Tên</div>
                    <div class="info-value">${profile.ten}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">Giới tính</div>
                    <div class="info-value">${empty profile.gioiTinh ? '—' : profile.gioiTinh}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">Ngày sinh</div>
                    <div class="info-value">${empty profile.ngaySinh ? '—' : profile.ngaySinh}</div>
                </div>

                <%-- CCCD: chỉ hiện với ToTruong và HoDan --%>
                <c:if test="${profile.tenVaiTro == 'ToTruong' or profile.tenVaiTro == 'HoDan'}">
                    <div class="info-item full">
                        <div class="info-label">Số CCCD / CMND</div>
                        <div class="info-value mono">${empty profile.cccd ? '—' : profile.cccd}</div>
                    </div>
                </c:if>

                <div class="info-item full">
                    <div class="info-label">Email</div>
                    <div class="info-value">${empty profile.email ? '—' : profile.email}</div>
                </div>
                <div class="info-item full">
                    <div class="info-label">Số điện thoại</div>
                    <div class="info-value">${empty profile.soDienThoai ? '—' : profile.soDienThoai}</div>
                </div>
            </div>

            <div class="section-title">Thông tin tài khoản</div>
            <div class="info-grid">
                <div class="info-item">
                    <div class="info-label">Vai trò</div>
                    <div class="info-value">${profile.tenVaiTro}</div>
                </div>

                <%-- Tổ dân phố: chỉ hiện với ToTruong và HoDan --%>
                <c:if test="${profile.tenVaiTro == 'ToTruong' or profile.tenVaiTro == 'HoDan'}">
                    <div class="info-item">
                        <div class="info-label">Tổ dân phố</div>
                       <div class="info-value">${empty profile.tenTo ? '—' : profile.tenTo}</div>
                    </div>
                </c:if>

                <div class="info-item">
                    <div class="info-label">Ngày tạo tài khoản</div>
                    <div class="info-value">${profile.ngayTao}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">Trạng thái</div>
                    <div class="info-value">${profile.isActivated ? '✅ Đang hoạt động' : '🔒 Chưa kích hoạt'}</div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>