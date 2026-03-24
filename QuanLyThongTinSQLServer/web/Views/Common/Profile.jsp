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
            --radius: 14px;
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

        /* ── NÚT SỬA CỐ ĐỊNH GÓC DƯỚI ── */
        .fab-edit {
            position: fixed; bottom: 32px; right: 32px; z-index: 100;
            display: flex; align-items: center; gap: 10px;
            background: linear-gradient(135deg, var(--accent), var(--accent2));
            color: #fff; border: none; border-radius: 50px;
            padding: 14px 24px; font-size: 14px; font-weight: 700;
            font-family: inherit; cursor: pointer;
            box-shadow: 0 8px 32px rgba(79,142,247,.4);
            transition: all .2s;
        }
        .fab-edit:hover { transform: translateY(-3px); box-shadow: 0 12px 40px rgba(79,142,247,.5); }

        /* ── MODAL ── */
        .modal-overlay {
            display: none; position: fixed; inset: 0; z-index: 999;
            background: rgba(0,0,0,.65); backdrop-filter: blur(6px);
            align-items: center; justify-content: center;
        }
        .modal-overlay.show { display: flex; animation: overlayIn .2s ease; }
        @keyframes overlayIn { from { opacity: 0; } to { opacity: 1; } }
        .modal {
            background: var(--surface); border: 1px solid var(--border);
            border-radius: 16px; width: 620px; max-width: calc(100vw - 32px);
            max-height: 90vh; overflow-y: auto;
            box-shadow: 0 24px 64px rgba(0,0,0,.6);
            animation: modalIn .22s cubic-bezier(.34,1.56,.64,1);
        }
        @keyframes modalIn {
            from { opacity: 0; transform: scale(.93) translateY(12px); }
            to   { opacity: 1; transform: none; }
        }
        .modal-hdr {
            display: flex; align-items: center; justify-content: space-between;
            padding: 20px 26px 16px; border-bottom: 1px solid var(--border);
            position: sticky; top: 0; background: var(--surface); z-index: 1;
        }
        .modal-hdr-left { display: flex; align-items: center; gap: 14px; }
        .modal-ico {
            width: 46px; height: 46px; border-radius: 12px;
            background: rgba(79,142,247,.15);
            display: flex; align-items: center; justify-content: center; font-size: 20px;
        }
        .modal-title { font-size: 16px; font-weight: 800; }
        .modal-sub   { font-size: 12px; color: var(--muted); margin-top: 2px; }
        .modal-close {
            width: 32px; height: 32px; border-radius: 8px;
            border: 1px solid var(--border); background: var(--surface2);
            color: var(--muted); font-size: 16px; cursor: pointer;
            display: flex; align-items: center; justify-content: center; transition: all .18s;
        }
        .modal-close:hover { border-color: var(--danger); color: var(--danger); }
        .modal-body { padding: 22px 26px; }
        .modal-footer {
            padding: 14px 26px 22px; display: flex; gap: 10px;
            justify-content: flex-end; border-top: 1px solid var(--border);
        }

        /* ── FORM ── */
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 14px; margin-bottom: 18px; }
        .form-item { display: flex; flex-direction: column; gap: 6px; }
        .form-item.full { grid-column: 1 / -1; }
        .form-label {
            font-size: 11px; font-weight: 700; color: var(--muted);
            text-transform: uppercase; letter-spacing: .5px;
        }
        .form-label span { color: var(--muted); font-weight: 400; text-transform: none; }
        .form-input, .form-select, .form-textarea {
            background: var(--surface2); border: 1px solid var(--border);
            color: var(--text); padding: 10px 14px; border-radius: 8px;
            font-size: 14px; font-family: inherit; transition: border-color .18s; width: 100%;
        }
        .form-input:focus, .form-select:focus, .form-textarea:focus {
            outline: none; border-color: var(--accent);
        }
        .form-textarea { resize: vertical; min-height: 88px; }
        .form-hint { font-size: 11px; color: var(--muted); margin-top: 2px; }
        .form-select option { background: var(--surface2); }

        /* ── BUTTONS ── */
        .btn {
            display: inline-flex; align-items: center; gap: 8px;
            padding: 10px 22px; border-radius: 8px; font-size: 13px;
            font-weight: 700; cursor: pointer; font-family: inherit;
            transition: all .18s; border: none;
        }
        .btn-cancel { background: var(--surface2); color: var(--muted); border: 1px solid var(--border); }
        .btn-cancel:hover { background: var(--surface); color: var(--text); }
        .btn-submit {
            background: linear-gradient(135deg, var(--accent), var(--accent2));
            color: #fff;
        }
        .btn-submit:hover { opacity: .9; transform: translateY(-1px); }
        .btn-submit:disabled { opacity: .5; cursor: not-allowed; transform: none; }

        /* ── CHECKBOX FIELDS ── */
        .fields-check { display: grid; grid-template-columns: 1fr 1fr; gap: 8px; margin-bottom: 18px; }
        .field-check {
            display: flex; align-items: center; gap: 8px;
            padding: 8px 12px; border-radius: 8px; border: 1px solid var(--border);
            background: var(--surface2); cursor: pointer; transition: all .15s;
            font-size: 13px; font-weight: 500;
        }
        .field-check:hover { border-color: var(--accent); }
        .field-check input[type=checkbox] { accent-color: var(--accent); width: 15px; height: 15px; }
        .field-check.checked { border-color: var(--accent); background: rgba(79,142,247,.08); color: var(--accent); }

        /* ── TOAST ── */
        .toast {
            position: fixed; bottom: 28px; left: 50%; transform: translateX(-50%);
            z-index: 9999; padding: 13px 22px; border-radius: 10px;
            font-size: 13px; font-weight: 600; display: none; align-items: center;
            gap: 10px; box-shadow: 0 8px 32px rgba(0,0,0,.4); white-space: nowrap;
        }
        .toast.show { display: flex; animation: slideUp .25s ease; }
        .toast.success { background: rgba(56,217,169,.15); border: 1px solid rgba(56,217,169,.4); color: var(--accent2); }
        .toast.error   { background: rgba(247,92,92,.15);  border: 1px solid rgba(247,92,92,.4);  color: var(--danger); }
        @keyframes slideUp { from { opacity: 0; transform: translateX(-50%) translateY(14px); } to { opacity: 1; transform: translateX(-50%) translateY(0); } }

        @media (max-width: 600px) {
            .info-grid, .form-grid, .fields-check { grid-template-columns: 1fr; }
            .card-top { flex-direction: column; align-items: center; text-align: center; padding-top: 28px; }
            .fab-edit { bottom: 20px; right: 20px; padding: 12px 18px; font-size: 13px; }
        }
    </style>
</head>
<body>
<div class="profile-wrap">

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
        </div>

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

<%-- ── NÚT SỬA - CHỈ HIỆN VỚI HỘ DÂN ── --%>
<c:if test="${profile.tenVaiTro == 'HoDan'}">
    <button class="fab-edit" onclick="openModal()">✏️ Yêu cầu cập nhật thông tin</button>

    <%-- ── MODAL FORM YÊU CẦU CẬP NHẬT ── --%>
    <div class="modal-overlay" id="modalCapNhat" onclick="closeMOutside(event)">
        <div class="modal">
            <div class="modal-hdr">
                <div class="modal-hdr-left">
                    <div class="modal-ico">✏️</div>
                    <div>
                        <div class="modal-title">Yêu cầu cập nhật thông tin</div>
                        <div class="modal-sub">Chọn các trường muốn thay đổi và nhập lý do</div>
                    </div>
                </div>
                <button class="modal-close" onclick="closeModal()">✕</button>
            </div>

            <div class="modal-body">
                <%-- BƯỚC 1: Chọn trường muốn sửa --%>
                <div class="section-title" id="step1Title">Bước 1 — Chọn thông tin muốn cập nhật</div>
                <div class="fields-check" id="fieldsCheck">
                    <label class="field-check" id="lbl_ho">
                        <input type="checkbox" value="ho" onchange="toggleField(this)"> 👤 Họ và chữ đệm
                    </label>
                    <label class="field-check" id="lbl_ten">
                        <input type="checkbox" value="ten" onchange="toggleField(this)"> 👤 Tên
                    </label>
                    <label class="field-check" id="lbl_ngaySinh">
                        <input type="checkbox" value="ngaySinh" onchange="toggleField(this)"> 🎂 Ngày sinh
                    </label>
                    <label class="field-check" id="lbl_gioiTinh">
                        <input type="checkbox" value="gioiTinh" onchange="toggleField(this)"> ⚧ Giới tính
                    </label>
                    <label class="field-check" id="lbl_email">
                        <input type="checkbox" value="email" onchange="toggleField(this)"> 📧 Email
                    </label>
                    <label class="field-check" id="lbl_soDienThoai">
                        <input type="checkbox" value="soDienThoai" onchange="toggleField(this)"> 📱 Số điện thoại
                    </label>
                    <label class="field-check" id="lbl_cccd">
                        <input type="checkbox" value="cccd" onchange="toggleField(this)"> 🪪 Số CCCD
                    </label>
                </div>

                <%-- BƯỚC 2: Nhập giá trị mới (hiện động theo checkbox) --%>
                <div id="fieldsForm" style="display:none">
                    <div class="section-title">Bước 2 — Nhập thông tin mới</div>
                    <div class="form-grid">
                        <div class="form-item" id="field_ho" style="display:none">
                            <label class="form-label">Họ và chữ đệm mới</label>
                            <input type="text" class="form-input" id="inp_ho"
                                   placeholder="${profile.ho}" value="">
                        </div>
                        <div class="form-item" id="field_ten" style="display:none">
                            <label class="form-label">Tên mới</label>
                            <input type="text" class="form-input" id="inp_ten"
                                   placeholder="${profile.ten}" value="">
                        </div>
                        <div class="form-item" id="field_ngaySinh" style="display:none">
                            <label class="form-label">Ngày sinh mới</label>
                            <input type="date" class="form-input" id="inp_ngaySinh">
                        </div>
                        <div class="form-item" id="field_gioiTinh" style="display:none">
                            <label class="form-label">Giới tính mới</label>
                            <select class="form-select" id="inp_gioiTinh">
                                <option value="">-- Chọn --</option>
                                <option value="Nam">Nam</option>
                                <option value="Nữ">Nữ</option>
                                <option value="Khác">Khác</option>
                            </select>
                        </div>
                        <div class="form-item" id="field_email" style="display:none">
                            <label class="form-label">Email mới</label>
                            <input type="email" class="form-input" id="inp_email"
                                   placeholder="${profile.email}" value="">
                        </div>
                        <div class="form-item" id="field_soDienThoai" style="display:none">
                            <label class="form-label">Số điện thoại mới</label>
                            <input type="text" class="form-input" id="inp_soDienThoai"
                                   placeholder="${profile.soDienThoai}" value="">
                        </div>
                        <div class="form-item full" id="field_cccd" style="display:none">
                            <label class="form-label">Số CCCD mới</label>
                            <input type="text" class="form-input" id="inp_cccd"
                                   placeholder="${profile.cccd}" maxlength="12">
                        </div>
                    </div>
                </div>

                <%-- LÝ DO (luôn hiện) --%>
                <div class="section-title">Lý do yêu cầu cập nhật <span style="color:var(--danger)">*</span></div>
                <div class="form-item">
                    <textarea class="form-textarea" id="inp_lyDo"
                              placeholder="Nhập lý do bạn muốn cập nhật thông tin..."></textarea>
                    <div class="form-hint">Bắt buộc — cán bộ phường sẽ dựa vào lý do này để xét duyệt</div>
                </div>
            </div>

            <div class="modal-footer">
                <button class="btn btn-cancel" onclick="closeModal()">Huỷ</button>
                <button class="btn btn-submit" id="btnSubmit" onclick="submitYeuCau()">
                    📨 Gửi yêu cầu
                </button>
            </div>
        </div>
    </div>

    <div class="toast" id="toast"></div>

    <script>
        const CTX = '${pageContext.request.contextPath}';

        function openModal() {
            document.getElementById('modalCapNhat').classList.add('show');
            document.body.style.overflow = 'hidden';
        }
        function closeModal() {
            document.getElementById('modalCapNhat').classList.remove('show');
            document.body.style.overflow = '';
        }
        function closeMOutside(e) {
            if (e.target === document.getElementById('modalCapNhat')) closeModal();
        }
        document.addEventListener('keydown', e => { if (e.key === 'Escape') closeModal(); });

        // Toggle hiện/ẩn field input khi check/uncheck
        function toggleField(cb) {
            const field = document.getElementById('field_' + cb.value);
            const lbl   = document.getElementById('lbl_'   + cb.value);
            if (field) field.style.display = cb.checked ? '' : 'none';
            if (lbl)   lbl.classList.toggle('checked', cb.checked);

            // Hiện/ẩn section bước 2
            const anyChecked = document.querySelectorAll('#fieldsCheck input:checked').length > 0;
            document.getElementById('fieldsForm').style.display = anyChecked ? '' : 'none';
        }

        // Gửi yêu cầu
        function submitYeuCau() {
            const lyDo = document.getElementById('inp_lyDo').value.trim();
            if (!lyDo) { showToast('error', '⚠ Vui lòng nhập lý do cập nhật.'); return; }

            const checked = document.querySelectorAll('#fieldsCheck input:checked');
            if (checked.length === 0) { showToast('error', '⚠ Vui lòng chọn ít nhất 1 trường muốn cập nhật.'); return; }

            // Validate từng field đã chọn
            let valid = true;
            checked.forEach(cb => {
                const inp = document.getElementById('inp_' + cb.value);
                if (inp && !inp.value.trim()) {
                    showToast('error', '⚠ Vui lòng nhập giá trị mới cho: ' + cb.value);
                    valid = false;
                }
            });
            if (!valid) return;

            const btn = document.getElementById('btnSubmit');
            btn.disabled = true;
            btn.textContent = '⏳ Đang gửi...';

            const params = new URLSearchParams();
            params.append('action', 'tao');
            params.append('lyDo', lyDo);

            // Chỉ gửi các field được chọn
            checked.forEach(cb => {
                const inp = document.getElementById('inp_' + cb.value);
                if (inp) params.append(cb.value, inp.value.trim());
            });

            fetch(CTX + '/hodan/yeu-cau-cap-nhat', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: params.toString(),
                credentials: 'include'
            })
            .then(r => r.json())
            .then(res => {
                btn.disabled = false;
                btn.textContent = '📨 Gửi yêu cầu';
                if (res.success) {
                    closeModal();
                    showToast('success', '✅ ' + res.message);
                    resetForm();
                } else {
                    showToast('error', '✕ ' + res.message);
                }
            })
            .catch(() => {
                btn.disabled = false;
                btn.textContent = '📨 Gửi yêu cầu';
                showToast('error', '✕ Lỗi kết nối, vui lòng thử lại.');
            });
        }

        function resetForm() {
            document.getElementById('inp_lyDo').value = '';
            document.querySelectorAll('#fieldsCheck input').forEach(cb => {
                cb.checked = false;
                const lbl = document.getElementById('lbl_' + cb.value);
                if (lbl) lbl.classList.remove('checked');
            });
            document.querySelectorAll('.form-item[id^="field_"]').forEach(f => f.style.display = 'none');
            document.getElementById('fieldsForm').style.display = 'none';
            document.querySelectorAll('.form-input, .form-select').forEach(i => i.value = '');
        }

        function showToast(type, msg) {
            const t = document.getElementById('toast');
            t.className = 'toast ' + type + ' show';
            t.textContent = msg;
            clearTimeout(t._t);
            t._t = setTimeout(() => t.classList.remove('show'), 3500);
        }
    </script>
</c:if>

</body>
</html>