<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Thông tin hộ dân</title>
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <style>
            :root {
                --bg: #0f1117;
                --surface: #181c27;
                --surface2: #1f2433;
                --border: #2a3048;
                --accent: #4f8ef7;
                --accent2: #38d9a9;
                --danger: #f75c5c;
                --warn: #fbbf24;
                --text: #e2e8f0;
                --muted: #64748b;
                --radius: 14px;
            }
            *, *::before, *::after {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }
            body {
                font-family: 'Be Vietnam Pro', sans-serif;
                background: var(--bg);
                color: var(--text);
                min-height: 100vh;
                padding: 32px;
            }

            .page-header {
                margin-bottom: 28px;
            }
            .page-header h1 {
                font-size: 22px;
                font-weight: 800;
            }
            .page-header p  {
                font-size: 13px;
                color: var(--muted);
                margin-top: 4px;
            }

            .info-card {
                background: var(--surface);
                border: 1px solid var(--border);
                border-radius: var(--radius);
                padding: 28px;
                margin-bottom: 24px;
            }
            .card-title {
                font-size: 11px;
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: 1.2px;
                color: var(--muted);
                margin-bottom: 20px;
            }
            .info-grid {
                display: grid;
                grid-template-columns: repeat(3, 1fr);
                gap: 20px;
            }
            .info-item label {
                font-size: 11px;
                color: var(--muted);
                display: block;
                margin-bottom: 4px;
            }
            .info-item span  {
                font-size: 14px;
                font-weight: 600;
            }

            .badge {
                display: inline-flex;
                align-items: center;
                gap: 5px;
                font-size: 11px;
                font-weight: 600;
                padding: 3px 10px;
                border-radius: 20px;
            }
            .badge::before {
                content: '';
                width: 6px;
                height: 6px;
                border-radius: 50%;
                background: currentColor;
            }
            .badge-green {
                background: rgba(56,217,169,.15);
                color: var(--accent2);
            }
            .badge-warn  {
                background: rgba(251,191,36,.15);
                color: var(--warn);
            }
            .badge-danger{
                background: rgba(247,92,92,.15);
                color: var(--danger);
            }

            .table-wrap {
                overflow-x: auto;
            }
            table {
                width: 100%;
                border-collapse: collapse;
            }
            thead tr {
                border-bottom: 2px solid var(--border);
            }
            th {
                font-size: 11px;
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: .8px;
                color: var(--muted);
                padding: 12px 16px;
                text-align: left;
            }
            tbody tr {
                border-bottom: 1px solid var(--border);
                transition: background .15s;
            }
            tbody tr:hover {
                background: var(--surface2);
            }
            td {
                font-size: 13px;
                padding: 14px 16px;
            }
            td .sub {
                font-size: 11px;
                color: var(--muted);
                margin-top: 2px;
            }

            .av {
                width: 34px;
                height: 34px;
                border-radius: 50%;
                flex-shrink: 0;
                background: linear-gradient(135deg, var(--accent), var(--accent2));
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 12px;
                font-weight: 700;
                color: #fff;
            }
            .name-cell {
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .alert-box {
                background: rgba(247,92,92,.1);
                border: 1px solid var(--danger);
                border-radius: var(--radius);
                padding: 20px 24px;
                color: var(--danger);
                font-size: 14px;
                font-weight: 500;
                margin-bottom: 20px;
            }
            .empty-box {
                padding: 48px;
                text-align: center;
                color: var(--muted);
                font-size: 13px;
            }
            .empty-box .icon {
                font-size: 36px;
                margin-bottom: 12px;
            }

            /* NÚT SỬA */
            .btn-edit {
                padding: 5px 12px;
                border-radius: 6px;
                font-size: 11px;
                font-weight: 600;
                border: 1px solid var(--border);
                background: var(--surface2);
                color: var(--muted);
                cursor: pointer;
                font-family: inherit;
                transition: all .18s;
            }
            .btn-edit:hover {
                border-color: var(--accent);
                color: var(--accent);
                background: rgba(79,142,247,.1);
            }

            /* MODAL */
            .modal-overlay {
                position: fixed;
                inset: 0;
                z-index: 999;
                background: rgba(0,0,0,.65);
                backdrop-filter: blur(4px);
                display: none;
                align-items: center;
                justify-content: center;
            }
            .modal-overlay.open {
                display: flex;
                animation: fadeIn .2s ease;
            }
            @keyframes fadeIn {
                from{
                    opacity:0
                }
                to{
                    opacity:1
                }
            }
            .modal {
                background: var(--surface2);
                border: 1px solid var(--border);
                border-radius: var(--radius);
                padding: 32px;
                width: 420px;
                max-width: 95vw;
                box-shadow: 0 24px 64px rgba(0,0,0,.6);
                animation: slideUp .2s ease;
            }
            @keyframes slideUp {
                from {
                    transform: translateY(16px);
                    opacity: 0;
                }
                to   {
                    transform: translateY(0);
                    opacity: 1;
                }
            }
            .modal-title {
                font-size: 16px;
                font-weight: 800;
                margin-bottom: 6px;
            }
            .modal-sub   {
                font-size: 13px;
                color: var(--muted);
                margin-bottom: 24px;
                padding-bottom: 16px;
                border-bottom: 1px solid var(--border);
            }
            .modal-label {
                font-size: 11px;
                color: var(--muted);
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: .8px;
                margin-bottom: 8px;
                display: block;
            }
            .modal-select {
                width: 100%;
                padding: 10px 14px;
                background: var(--surface);
                border: 1px solid var(--border);
                border-radius: 8px;
                color: var(--text);
                font-family: inherit;
                font-size: 14px;
                outline: none;
                cursor: pointer;
                transition: border-color .15s;
                appearance: none;
            }
            .modal-select:focus {
                border-color: var(--accent);
            }
            .modal-actions {
                display: flex;
                gap: 10px;
                margin-top: 24px;
                justify-content: flex-end;
            }
            .btn {
                padding: 9px 20px;
                border-radius: 8px;
                font-size: 13px;
                font-weight: 600;
                border: none;
                cursor: pointer;
                font-family: inherit;
                transition: all .18s;
            }
            .btn-cancel {
                background: var(--surface);
                color: var(--muted);
                border: 1px solid var(--border);
            }
            .btn-cancel:hover {
                color: var(--text);
                border-color: var(--text);
            }
            .btn-save {
                background: var(--accent);
                color: #fff;
            }
            .btn-save:hover {
                opacity: .85;
            }

            /* TOAST */
            .toast {
                position: fixed;
                bottom: 24px;
                right: 24px;
                z-index: 9999;
                padding: 14px 20px;
                border-radius: 10px;
                font-size: 13px;
                font-weight: 600;
                box-shadow: 0 8px 24px rgba(0,0,0,.4);
                transition: opacity .4s;
                animation: toastIn .3s ease;
            }
            @keyframes toastIn {
                from{
                    transform:translateY(20px);
                    opacity:0
                }
                to{
                    transform:translateY(0);
                    opacity:1
                }
            }
            .toast-success {
                background: rgba(56,217,169,.2);
                border: 1px solid var(--accent2);
                color: var(--accent2);
            }
            .toast-error   {
                background: rgba(247,92,92,.15);
                border: 1px solid var(--danger);
                color: var(--danger);
            }

            @media (max-width: 700px) {
                .info-grid {
                    grid-template-columns: 1fr 1fr;
                }
            }
            @media (max-width: 480px) {
                .info-grid {
                    grid-template-columns: 1fr;
                }
                body {
                    padding: 16px;
                }
            }
        </style>
    </head>
    <body>

        <div class="page-header">
            <h1>🏡 Thông tin hộ dân</h1>
            <p>Thông tin hộ khẩu và danh sách nhân khẩu của bạn</p>
        </div>

        <%-- THÔNG BÁO --%>
        <c:if test="${not empty errorMsg}">
            <div class="alert-box">⚠️ ${errorMsg}</div>
        </c:if>

        <%-- NỘI DUNG CHÍNH --%>
        <c:if test="${not empty hoDan}">

            <%-- THÔNG TIN HỘ KHẨU --%>
            <div class="info-card">
                <div class="card-title">Thông tin hộ khẩu</div>
                <div class="info-grid">

                    <div class="info-item">
                        <label>Mã hộ khẩu</label>
                        <span>${hoDan.maHoKhau}</span>
                    </div>
                    <div class="info-item">
                        <label>Chủ hộ</label>
                        <span>${hoDan.tenChuHo}</span>
                    </div>
                    <div class="info-item">
                        <label>Tổ dân phố</label>
                        <span>${hoDan.tenTo}</span>
                    </div>
                    <div class="info-item">
                        <label>Địa chỉ</label>
                        <span>${hoDan.diaChi}</span>
                    </div>
                    <div class="info-item">
                        <label>Số nhân khẩu</label>
                        <span>${soNhanKhau} người</span>
                    </div>
                    <div class="info-item">
                        <label>Trạng thái</label>
                        <c:choose>
                            <c:when test="${hoDan.trangThaiID == 1}">
                                <span class="badge badge-green">${hoDan.tenTrangThai}</span>
                            </c:when>
                            <c:when test="${hoDan.trangThaiID == 2}">
                                <span class="badge badge-warn">${hoDan.tenTrangThai}</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge badge-danger">${hoDan.tenTrangThai}</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="info-item">
                        <label>Ngày tạo</label>
                        <span><fmt:formatDate value="${hoDan.ngayTao}" pattern="dd/MM/yyyy"/></span>
                    </div>

                </div>
            </div>

            <%-- DANH SÁCH NHÂN KHẨU --%>
            <div class="info-card">
                <div class="card-title">Danh sách nhân khẩu (${soNhanKhau} người)</div>

                <c:choose>
                    <c:when test="${not empty thanhVien}">
                        <div class="table-wrap">
                            <table>
                                <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>Họ và tên</th>
                                        <th>CCCD</th>
                                        <th>Ngày sinh</th>
                                        <th>Giới tính</th>
                                        <th>Quan hệ</th>
                                        <th>Số điện thoại</th>
                                        <th></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="tv" items="${thanhVien}" varStatus="st">
                                        <tr>
                                            <td>${st.index + 1}</td>
                                            <td>
                                                <div class="name-cell">
                                                    <div class="av" data-name="${tv.ho} ${tv.ten}">
                                                        ${fn:substring(tv.ten, 0, 1)}
                                                    </div>
                                                    <div>
                                                        <div>${tv.ho} ${tv.ten}</div>
                                                        <div class="sub">${tv.email}</div>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>${tv.cccd}</td>
                                            <td>
                                                <fmt:formatDate value="${tv.ngaySinh}" pattern="dd/MM/yyyy"/>
                                                <div class="sub">${tv.tuoi} tuổi</div>
                                            </td>
                                            <td>${tv.gioiTinh}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${tv.tenQuanHe == 'Chủ hộ'}">
                                                        <span class="badge badge-green">${tv.tenQuanHe}</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span>${tv.tenQuanHe}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>${tv.soDienThoai}</td>
                                            <td>
                                                <c:if test="${isChuHo and tv.nguoiDungID != currentUser.nguoiDungID}">
                                                    <button class="btn-edit"
                                                            onclick="moModal(${tv.nguoiDungID}, '${tv.ho} ${tv.ten}', '${tv.tenQuanHe}')">
                                                        ✏️ Sửa quan hệ
                                                    </button>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-box">
                            <div class="icon">👥</div>
                            <p>Chưa có nhân khẩu nào trong hộ</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

        </c:if>

        <%-- TOAST --%>
        <c:if test="${not empty successMsg}">
            <div class="toast toast-success" id="toast">✅ ${successMsg}</div>
        </c:if>
        <c:if test="${not empty errorMsg and empty hoDan}">
            <div class="toast toast-error" id="toast">⚠️ ${errorMsg}</div>
        </c:if>

        <%-- MODAL SỬA QUAN HỆ --%>
        <div class="modal-overlay" id="modalOverlay">
            <div class="modal">
                <div class="modal-title">✏️ Sửa quan hệ thành viên</div>
                <div class="modal-sub" id="modalTenNguoi">Thành viên: </div>

                <form method="post" action="${pageContext.request.contextPath}/hodan/sua-quan-he">
                    <input type="hidden" name="nguoiDungID" id="hiddenNguoiDungID"/>
                    <input type="hidden" name="hoDanID"     value="${hoDan.hoDanID}"/>

                    <label class="modal-label">Quan hệ mới</label>
                    <select name="quanHeID" id="selectQuanHe" class="modal-select">
                        <c:forEach var="qh" items="${danhSachQuanHe}">
                            <option value="${qh.quanHeID}">${qh.tenQuanHe}</option>
                        </c:forEach>
                    </select>

                    <div class="modal-actions">
                        <button type="button" class="btn btn-cancel" id="btnDong">Huỷ</button>
                        <button type="submit" class="btn btn-save">💾 Lưu thay đổi</button>
                    </div>
                </form>
            </div>
        </div>

        <script>
            // Avatar initials
            document.querySelectorAll('.av[data-name]').forEach(el => {
                const parts = (el.dataset.name || '').trim().split(' ');
                el.textContent = parts[parts.length - 1]?.[0]?.toUpperCase() || '?';
            });

            // Map tên quan hệ → ID để pre-select
            const quanHeMap = {};
            <c:forEach var="qh" items="${danhSachQuanHe}">
            quanHeMap['${qh.tenQuanHe}'] = '${qh.quanHeID}';
            </c:forEach>

            function moModal(nguoiDungID, tenNguoi, tenQuanHeHienTai) {
                document.getElementById('hiddenNguoiDungID').value = nguoiDungID;
                document.getElementById('modalTenNguoi').textContent = 'Thành viên: ' + tenNguoi;
                const sel = document.getElementById('selectQuanHe');
                const qhID = quanHeMap[tenQuanHeHienTai];
                if (qhID)
                    sel.value = qhID;
                document.getElementById('modalOverlay').classList.add('open');
            }

            function dongModal() {
                document.getElementById('modalOverlay').classList.remove('open');
            }

            document.getElementById('btnDong').addEventListener('click', dongModal);

            // Click ra ngoài modal thì đóng
            document.getElementById('modalOverlay').addEventListener('click', function (e) {
                if (e.target === this)
                    dongModal();
            });

            // Phím Escape đóng modal
            document.addEventListener('keydown', e => {
                if (e.key === 'Escape')
                    dongModal();
            });

            // Tự ẩn toast sau 3 giây
            const toast = document.getElementById('toast');
            if (toast)
                setTimeout(() => {
                    toast.style.opacity = '0';
                }, 3000);
        </script>
    </body>
</html>