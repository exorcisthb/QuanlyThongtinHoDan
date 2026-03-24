<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Import Hộ Dân</title>
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
                --radius: 12px;
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
            }

            .topbar {
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                z-index: 200;
                height: 64px;
                background: rgba(15,17,23,.88);
                backdrop-filter: blur(16px);
                border-bottom: 1px solid var(--border);
                display: flex;
                align-items: center;
                padding: 0 32px;
                gap: 16px;
            }
            .topbar-logo {
                display: flex;
                align-items: center;
                gap: 10px;
                text-decoration: none;
                color: var(--text);
            }
            .logo-icon {
                width: 34px;
                height: 34px;
                border-radius: 8px;
                background: linear-gradient(135deg, var(--accent), var(--accent2));
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 16px;
            }
            .logo-text {
                font-size: 14px;
                font-weight: 700;
            }
            .logo-text span {
                color: var(--accent);
            }
            .topbar-divider {
                width: 1px;
                height: 24px;
                background: var(--border);
            }
            .topbar-title {
                font-size: 13px;
                font-weight: 600;
                color: var(--muted);
            }
            .topbar-spacer {
                flex: 1;
            }
            .back-btn {
                display: flex;
                align-items: center;
                gap: 6px;
                padding: 7px 14px;
                border-radius: 8px;
                background: var(--surface2);
                border: 1px solid var(--border);
                color: var(--text);
                text-decoration: none;
                font-size: 13px;
                font-weight: 600;
                transition: all .18s;
            }
            .back-btn:hover {
                border-color: var(--accent);
                color: var(--accent);
            }
            .avatar-sm {
                width: 34px;
                height: 34px;
                border-radius: 50%;
                background: linear-gradient(135deg, var(--accent), var(--accent2));
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 13px;
                font-weight: 700;
                color: #fff;
                text-transform: uppercase;
            }

            .main {
                padding-top: 64px;
            }
            .content {
                max-width: 820px;
                margin: 0 auto;
                padding: 40px 32px;
            }

            .page-header {
                margin-bottom: 32px;
            }
            .breadcrumb {
                font-size: 12px;
                color: var(--muted);
                margin-bottom: 8px;
            }
            .breadcrumb a {
                color: var(--accent);
                text-decoration: none;
            }
            .page-header h1 {
                font-size: 24px;
                font-weight: 800;
                letter-spacing: -.4px;
            }
            .page-header p {
                font-size: 14px;
                color: var(--muted);
                margin-top: 4px;
            }

            .card {
                background: var(--surface);
                border: 1px solid var(--border);
                border-radius: var(--radius);
                padding: 28px;
                margin-bottom: 20px;
            }
            .card-title {
                font-size: 15px;
                font-weight: 700;
                margin-bottom: 20px;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .btn {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                padding: 10px 22px;
                border-radius: 8px;
                font-size: 14px;
                font-weight: 600;
                font-family: inherit;
                border: none;
                cursor: pointer;
                text-decoration: none;
                transition: all .18s;
            }
            .btn-primary {
                background: var(--accent);
                color: #fff;
            }
            .btn-primary:hover {
                background: #3a7de8;
            }
            .btn-primary:disabled {
                opacity: .45;
                cursor: not-allowed;
            }
            .btn-secondary {
                background: var(--surface2);
                color: var(--text);
                border: 1px solid var(--border);
            }
            .btn-secondary:hover {
                border-color: var(--accent);
                color: var(--accent);
            }
            .btn-green {
                background: #16a34a;
                color: #fff;
            }
            .btn-green:hover {
                background: #15803d;
            }

            .loading-overlay {
                display: none;
                position: fixed;
                inset: 0;
                background: rgba(15,17,23,.7);
                backdrop-filter: blur(4px);
                z-index: 999;
                align-items: center;
                justify-content: center;
                flex-direction: column;
                gap: 16px;
            }
            .loading-overlay.show {
                display: flex;
            }
            .spinner {
                width: 48px;
                height: 48px;
                border: 4px solid var(--border);
                border-top-color: var(--accent);
                border-radius: 50%;
                animation: spin .8s linear infinite;
            }
            @keyframes spin {
                to {
                    transform: rotate(360deg);
                }
            }
            .loading-text {
                font-size: 14px;
                font-weight: 600;
                color: var(--muted);
            }

            .alert {
                border-radius: 10px;
                padding: 14px 18px;
                margin-bottom: 20px;
                font-size: 14px;
                display: flex;
                align-items: flex-start;
                gap: 10px;
            }
            .alert-danger  {
                background: rgba(247,92,92,.1);
                border: 1px solid rgba(247,92,92,.3);
                color: var(--danger);
            }
            .alert-success {
                background: rgba(56,217,169,.1);
                border: 1px solid rgba(56,217,169,.3);
                color: var(--accent2);
            }
            .alert-icon {
                font-size: 18px;
                flex-shrink: 0;
            }

            .result-stats {
                display: flex;
                gap: 12px;
                margin-bottom: 20px;
                flex-wrap: wrap;
            }
            .stat-chip {
                flex: 1;
                min-width: 110px;
                background: var(--surface2);
                border: 1px solid var(--border);
                border-radius: 10px;
                padding: 16px 20px;
                text-align: center;
            }
            .stat-chip .num {
                font-size: 30px;
                font-weight: 800;
            }
            .stat-chip .lbl {
                font-size: 12px;
                color: var(--muted);
                margin-top: 3px;
            }
            .num-total   {
                color: var(--accent);
            }
            .num-success {
                color: var(--accent2);
            }
            .num-fail    {
                color: var(--danger);
            }

            .error-list-title {
                font-size: 13px;
                font-weight: 700;
                color: var(--danger);
                margin-bottom: 10px;
            }
            .error-scroll {
                max-height: 240px;
                overflow-y: auto;
                padding-right: 4px;
            }
            .error-scroll::-webkit-scrollbar {
                width: 4px;
            }
            .error-scroll::-webkit-scrollbar-track {
                background: var(--surface2);
                border-radius: 4px;
            }
            .error-scroll::-webkit-scrollbar-thumb {
                background: var(--border);
                border-radius: 4px;
            }
            .error-item {
                background: rgba(247,92,92,.06);
                border: 1px solid rgba(247,92,92,.18);
                border-radius: 8px;
                padding: 9px 14px;
                margin-bottom: 6px;
                font-size: 13px;
                display: flex;
                align-items: flex-start;
                gap: 8px;
            }
            .error-item::before {
                content: '⚠';
                color: var(--danger);
                flex-shrink: 0;
            }

            /* FILE INPUT ROW */
            .file-row {
                display: flex;
                align-items: center;
                gap: 14px;
                flex-wrap: wrap;
            }
            .file-label {
                display: inline-flex;
                align-items: center;
                gap: 8px;
                background: var(--surface2);
                border: 1px solid var(--border);
                padding: 9px 18px;
                border-radius: 8px;
                cursor: pointer;
                font-size: 14px;
                font-weight: 600;
                color: var(--text);
                transition: all .18s;
                white-space: nowrap;
            }
            .file-label:hover {
                border-color: var(--accent);
                color: var(--accent);
            }
            .file-name {
                font-size: 14px;
                color: var(--muted);
                flex: 1;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
            }

            /* CHÚ Ý */
            .note-list {
                font-size: 14px;
                color: var(--muted);
                line-height: 2.2;
            }
            .note-list p::before {
                content: '— ';
            }

            /* BẢNG CỘT */
            .data-table {
                width: 100%;
                border-collapse: collapse;
                font-size: 13px;
                margin-top: 14px;
            }
            .data-table th {
                padding: 9px 14px;
                text-align: left;
                color: var(--muted);
                font-size: 11px;
                font-weight: 700;
                text-transform: uppercase;
                border-bottom: 1px solid var(--border);
                background: rgba(255,255,255,.02);
            }
            .data-table td {
                padding: 10px 14px;
                border-bottom: 1px solid rgba(42,48,72,.4);
            }
            .data-table tbody tr:last-child td {
                border-bottom: none;
            }
            .col-tag {
                background: var(--surface2);
                border: 1px solid var(--border);
                border-radius: 5px;
                padding: 2px 8px;
                font-family: monospace;
                font-size: 12px;
                color: var(--accent);
            }
            .req {
                color: var(--danger);
                font-weight: 700;
            }

            .divider {
                border: none;
                border-top: 1px solid var(--border);
                margin: 20px 0;
            }
        </style>
    </head>
    <body>
        <%-- DEBUG PANEL - XÓA SAU KHI TEST XONG --%>
        <div style="
             position:fixed; bottom:16px; right:16px; z-index:9999;
             background:#0a0e1a; border:1px solid #f75c5c;
             border-radius:10px; padding:16px 20px; font-size:12px;
             font-family:monospace; color:#e2e8f0; max-width:420px;
             box-shadow: 0 8px 24px rgba(0,0,0,.5);">
            <div style="color:#f75c5c; font-weight:700; margin-bottom:10px;">🐛 DEBUG PANEL</div>

            <div><span style="color:#64748b">currentUser:</span>
                <span style="color:#38d9a9">${sessionScope.currentUser != null ? 'CÓ' : 'NULL ⚠'}</span>
            </div>
            <div><span style="color:#64748b">tên user:</span>
                <span style="color:#4f8ef7">${sessionScope.currentUser.ho} ${sessionScope.currentUser.ten}</span>
            </div>
            <div><span style="color:#64748b">toDanPhoID:</span>
                <span style="color:#fbbf24">${sessionScope.currentUser.toDanPhoID}</span>
            </div>
            <div><span style="color:#64748b">vaiTroID:</span>
                <span style="color:#fbbf24">${sessionScope.currentUser.vaiTroID}</span>
            </div>

            <div style="margin-top:8px; border-top:1px solid #2a3048; padding-top:8px;">
                <span style="color:#64748b">importResult:</span>
                <span style="color:${not empty importResult ? '#38d9a9' : '#f75c5c'}">
                    ${not empty importResult ? 'CÓ DỮ LIỆU' : 'TRỐNG ⚠'}
                </span>
            </div>
            <div><span style="color:#64748b">fileName:</span>
                <span style="color:#4f8ef7">${not empty fileName ? fileName : 'TRỐNG ⚠'}</span>
            </div>
            <div><span style="color:#64748b">errorMsg:</span>
                <span style="color:#f75c5c">${not empty errorMsg ? errorMsg : 'không có'}</span>
            </div>

            <div style="margin-top:8px; border-top:1px solid #2a3048; padding-top:8px;">
                <span style="color:#64748b">request method:</span>
                <span style="color:#fbbf24"><%= request.getMethod() %></span>
            </div>
            <div><span style="color:#64748b">content-type:</span>
                <span style="color:#fbbf24" style="word-break:break-all"><%= request.getContentType() != null ? request.getContentType().substring(0, Math.min(40, request.getContentType().length())) : "null" %></span>
            </div>
            <div><span style="color:#64748b">session id:</span>
                <span style="color:#64748b"><%= session.getId().substring(0,12) %>...</span>
            </div>
        </div>
        <!-- LOADING -->
        <div class="loading-overlay" id="loadingOverlay">
            <div class="spinner"></div>
            <div class="loading-text">Đang xử lý file...</div>
        </div>

        <!-- TOPBAR -->
        <header class="topbar">
            <a href="${pageContext.request.contextPath}/canbophuong/dashboard" class="topbar-logo">
                <div class="logo-icon">🏘</div>
                <div class="logo-text">Quản lý <span>Hộ dân</span></div>
            </a>
            <div class="topbar-divider"></div>
            <span class="topbar-title">Import Hộ Dân</span>
            <div class="topbar-spacer"></div>
            <a href="${pageContext.request.contextPath}/canbophuong/hodan" class="back-btn">← Danh sách hộ dân</a>
            <div class="avatar-sm" id="avatarTop">TT</div>
        </header>

        <main class="main">
            <div class="content">

                <div class="page-header">
                    <div class="breadcrumb">
                        <a href="${pageContext.request.contextPath}/canbophuong/dashboard">Dashboard</a> /
                        <a href="${pageContext.request.contextPath}/canbophuong/hodan">Hộ dân</a> /
                        Import Excel
                    </div>
                    <h1>📥 Import hộ dân từ Excel</h1>
                    <p>Thêm hàng loạt hộ dân vào hệ thống từ file .xlsx</p>
                </div>

                <!-- ALERT LỖI CHUNG -->
                <c:if test="${not empty errorMsg}">
                    <div class="alert alert-danger">
                        <span class="alert-icon">✕</span>
                        <span>${errorMsg}</span>
                    </div>
                </c:if>

                <!-- KẾT QUẢ IMPORT -->
                <c:if test="${not empty importResult}">
                    <div class="card">
                        <div class="card-title">📊 Kết quả import — <span style="color:var(--accent)">${fileName}</span></div>
                        <div class="result-stats">
                            <div class="stat-chip">
                                <div class="num num-total">${importResult.total}</div>
                                <div class="lbl">Tổng dòng</div>
                            </div>
                            <div class="stat-chip">
                                <div class="num num-success">${importResult.success}</div>
                                <div class="lbl">Thành công</div>
                            </div>
                            <div class="stat-chip">
                                <div class="num num-fail">${importResult.errors.size()}</div>
                                <div class="lbl">Lỗi</div>
                            </div>
                        </div>
                        <c:if test="${importResult.success > 0}">
                            <div class="alert alert-success">
                                <span class="alert-icon">✓</span>
                                <span>Đã import thành công <strong>${importResult.success}</strong> hộ dân vào hệ thống.</span>
                            </div>
                        </c:if>
                        <c:if test="${not empty importResult.errors}">
                            <div class="error-list-title">⚠ ${importResult.errors.size()} dòng có lỗi</div>
                            <div class="error-scroll">
                                <c:forEach var="err" items="${importResult.errors}">
                                    <div class="error-item">${err}</div>
                                </c:forEach>
                            </div>
                        </c:if>
                        <div style="margin-top:16px; display:flex; gap:10px;">
                            <a href="${pageContext.request.contextPath}/canbophuong/hodan" class="btn btn-primary">→ Xem danh sách hộ dân</a>
                            <a href="${pageContext.request.contextPath}/canbophuong/import-hodan" class="btn btn-secondary">↺ Import thêm</a>
                        </div>
                    </div>
                </c:if>

                <!-- UPLOAD FORM -->
                <div class="card">
                    <div class="card-title">📁 Import dữ liệu Hộ Dân</div>
                    <form action="${pageContext.request.contextPath}/canbophuong/import-hodan"
                          method="post" enctype="multipart/form-data" id="importForm">
                        <div class="file-row">
                            <label class="file-label">
                                📎 Chọn file
                                <input type="file" name="excelFile" id="excelFile"
                                       accept=".xlsx,.xls" style="display:none"
                                       onchange="onFileChange(this)">
                            </label>
                            <span class="file-name" id="fileNameDisplay">Chưa chọn file</span>
                            <button type="submit" class="btn btn-primary" id="submitBtn"
                                    disabled onclick="showLoading()">
                                💾 Lưu lại
                            </button>
                        </div>
                    </form>
                </div>

                <!-- CHÚ Ý -->
                <div class="card">
                    <div class="card-title">⚠ Chú ý</div>
                    <div class="note-list">
                        <p>Biểu mẫu File Import kèm theo. Chỉ chấp nhận định dạng file <strong style="color:var(--text)">.xlsx</strong> — dung lượng tối đa <strong style="color:var(--text)">5MB</strong>.</p>
                        <p>Nếu quá trình import xuất hiện lỗi hoặc dữ liệu trùng lặp, sẽ có thông báo trên màn hình.</p>
                        <p>Sau khi Import phải kiểm tra lại số liệu đã import trên hệ thống.</p>
                        <p>Dữ liệu chuẩn hóa theo Bảng thông tin phía dưới.</p>
                        <p>Các vấn đề khác vui lòng liên hệ Quản trị hệ thống để được hỗ trợ.</p>
                    </div>

                    <hr class="divider">

                    <div style="font-size:13px; color:var(--muted); margin-bottom:12px;">Biểu mẫu File Import</div>
                    <div style="display:flex; gap:10px; flex-wrap:wrap;">
                        <a href="${pageContext.request.contextPath}/Víews/CanBoPhuong/mau-import-hodan.xlsx"
                           class="btn btn-primary">📄 File mẫu</a>
                        <a href="${pageContext.request.contextPath}/canbophuong/hodan"
                           class="btn btn-green">🏠 Danh sách hộ dân</a>
                    </div>

                    <hr class="divider">

                    <div style="font-size:13px; font-weight:700; color:var(--accent); margin-bottom:12px;">
                        Cấu trúc cột — Sheet đầu tiên, dòng 1 là header, dữ liệu từ dòng 2
                    </div>
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Cột</th>
                                <th>Tên header</th>
                                <th>Mô tả</th>
                                <th>Bắt buộc</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><span class="col-tag">A</span></td>
                                <td>MaHoKhau</td>
                                <td style="color:var(--muted)">Mã hộ khẩu — phải duy nhất trong hệ thống</td>
                                <td><span class="req">✓ Bắt buộc</span></td>
                            </tr>
                            <tr>
                                <td><span class="col-tag">B</span></td>
                                <td>DiaChi</td>
                                <td style="color:var(--muted)">Địa chỉ đầy đủ — VD: 12 Hùng Vương, Phường 1</td>
                                <td><span class="req">✓ Bắt buộc</span></td>
                            </tr>
                        </tbody>
                    </table>
                    <p style="font-size:12px; color:var(--muted); margin-top:14px;">
                        💡 Các hộ có mã hộ khẩu trùng sẽ bị bỏ qua và báo lỗi. Trạng thái mặc định là <strong>Thường trú</strong>.
                    </p>
                </div>

            </div>
        </main>

        <script>
    const ten = '${currentUser.ten}' || 'TT';
    document.getElementById('avatarTop').textContent = ten.trim().substring(0, 2).toUpperCase();

    function showLoading() {
        setTimeout(() => document.getElementById('loadingOverlay').classList.add('show'), 10);
    }

    function onFileChange(input) {
        const file = input.files[0];
        if (!file)
            return;
        const display = document.getElementById('fileNameDisplay');
        display.textContent = file.name + '  (' + (file.size / 1024).toFixed(1) + ' KB)';
        display.style.color = 'var(--accent2)';
        document.getElementById('submitBtn').disabled = false;
    }
        </script>
    </body>
</html>