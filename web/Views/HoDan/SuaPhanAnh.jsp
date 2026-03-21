<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.Map" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sửa phản ánh / Kiến nghị</title>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg:#0f1117; --surface:#181c27; --surface2:#1f2433;
            --border:#2a3048; --accent:#4f8ef7; --accent2:#38d9a9;
            --danger:#f75c5c; --warn:#fbbf24; --text:#e2e8f0;
            --muted:#64748b; --radius:14px;
        }
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Be Vietnam Pro', sans-serif; background: var(--bg); color: var(--text); min-height: 100vh; }

        .topbar { position: fixed; top: 0; left: 0; right: 0; z-index: 200; height: 64px; background: rgba(15,17,23,.88); backdrop-filter: blur(16px); border-bottom: 1px solid var(--border); display: flex; align-items: center; padding: 0 32px; gap: 16px; }
        .topbar-logo { display: flex; align-items: center; gap: 10px; text-decoration: none; color: var(--text); }
        .logo-icon { width: 34px; height: 34px; border-radius: 8px; background: linear-gradient(135deg,var(--accent),var(--accent2)); display: flex; align-items: center; justify-content: center; font-size: 16px; }
        .logo-text { font-size: 14px; font-weight: 700; }
        .logo-text span { color: var(--accent); }
        .topbar-divider { width: 1px; height: 24px; background: var(--border); }
        .breadcrumb { display: flex; align-items: center; gap: 6px; font-size: 13px; color: var(--muted); }
        .breadcrumb a { color: var(--muted); text-decoration: none; transition: color .15s; }
        .breadcrumb a:hover { color: var(--text); }
        .topbar-spacer { flex: 1; }

        .main { padding-top: 64px; }
        .content { max-width: 680px; margin: 0 auto; padding: 40px 32px 60px; }

        .form-card { background: var(--surface); border: 1px solid var(--border); border-radius: 18px; overflow: hidden; }
        .form-card-header { padding: 28px 32px 22px; border-bottom: 1px solid var(--border); display: flex; align-items: center; gap: 16px; }
        .form-ico { width: 52px; height: 52px; border-radius: 14px; background: rgba(79,142,247,.15); display: flex; align-items: center; justify-content: center; font-size: 24px; flex-shrink: 0; }
        .form-card-header h1 { font-size: 20px; font-weight: 800; margin-bottom: 4px; }
        .form-card-header p { font-size: 13px; color: var(--muted); }

        .form-body { padding: 28px 32px; }
        .form-group { margin-bottom: 22px; }
        .form-label { display: flex; align-items: center; gap: 6px; font-size: 12px; font-weight: 700; color: var(--muted); text-transform: uppercase; letter-spacing: .6px; margin-bottom: 8px; }
        .form-label .req { color: var(--danger); }

        /* Trường chỉ đọc */
        .form-readonly {
            width: 100%; background: rgba(42,48,72,.4);
            border: 1px solid var(--border); color: var(--muted);
            padding: 12px 16px; border-radius: 10px;
            font-size: 14px; font-family: inherit;
            cursor: not-allowed; display: flex; align-items: center; gap: 8px;
        }
        .readonly-badge { font-size: 10px; font-weight: 700; padding: 2px 7px; border-radius: 20px; background: rgba(100,116,139,.15); color: var(--muted); margin-left: auto; }
        .readonly-hint { font-size: 11px; color: var(--muted); margin-top: 5px; display: flex; align-items: center; gap: 4px; }

        .form-textarea { width: 100%; background: var(--surface2); border: 1px solid var(--border); color: var(--text); padding: 12px 16px; border-radius: 10px; font-size: 14px; font-family: inherit; transition: border-color .18s, box-shadow .18s; outline: none; resize: vertical; min-height: 140px; line-height: 1.6; }
        .form-textarea:focus { border-color: var(--accent); box-shadow: 0 0 0 3px rgba(79,142,247,.1); }
        .form-textarea.error { border-color: var(--danger); box-shadow: 0 0 0 3px rgba(247,92,92,.1); }
        .form-error { font-size: 11px; color: var(--danger); margin-top: 6px; display: none; }
        .form-error.show { display: block; }
        .char-count { font-size: 11px; color: var(--muted); text-align: right; margin-top: 4px; }
        .char-count.warn { color: var(--warn); }

        /* Mức độ */
        .muc-do-group { display: grid; grid-template-columns: repeat(3,1fr); gap: 10px; align-items: stretch; }
        .muc-do-outer { display: flex; flex-direction: column; }
        .muc-do-item { display: none; }
        .muc-do-label { display: flex; flex-direction: column; align-items: center; justify-content: center; gap: 6px; padding: 16px 10px; border-radius: 10px; border: 1px solid var(--border); background: var(--surface2); cursor: pointer; transition: all .15s; text-align: center; flex: 1; min-height: 110px; }
        .muc-do-label:hover { border-color: var(--accent); background: rgba(79,142,247,.05); }
        .muc-do-item:checked ~ .muc-do-label.thap { border-color: var(--muted);  background: rgba(100,116,139,.12); }
        .muc-do-item:checked ~ .muc-do-label.tb   { border-color: var(--warn);   background: rgba(251,191,36,.12); }
        .muc-do-item:checked ~ .muc-do-label.cao  { border-color: var(--danger); background: rgba(247,92,92,.12); }
        .muc-do-icon { font-size: 22px; }
        .muc-do-text { font-size: 12px; font-weight: 700; }
        .muc-do-desc { font-size: 10px; color: var(--muted); line-height: 1.4; }

        /* Ảnh */
        .anh-hien-tai { display: flex; gap: 10px; flex-wrap: wrap; margin-bottom: 14px; }
        .anh-item { position: relative; width: 90px; height: 90px; border-radius: 10px; overflow: hidden; border: 1px solid var(--border); }
        .anh-item img { width: 100%; height: 100%; object-fit: cover; }
        .anh-item.xoa-pending { opacity: .35; }
        .anh-item.xoa-pending::after { content: '🗑'; position: absolute; inset: 0; display: flex; align-items: center; justify-content: center; font-size: 22px; background: rgba(247,92,92,.3); }
        .anh-remove { position: absolute; top: 4px; right: 4px; width: 20px; height: 20px; border-radius: 50%; background: rgba(0,0,0,.7); color: #fff; font-size: 11px; border: none; cursor: pointer; display: flex; align-items: center; justify-content: center; transition: background .15s; }
        .anh-remove:hover { background: var(--danger); }
        .anh-restore { position: absolute; top: 4px; right: 4px; width: 20px; height: 20px; border-radius: 50%; background: rgba(56,217,169,.8); color: #fff; font-size: 11px; border: none; cursor: pointer; display: flex; align-items: center; justify-content: center; }

        .upload-zone { border: 2px dashed var(--border); border-radius: 12px; padding: 20px; text-align: center; cursor: pointer; transition: border-color .15s, background .15s; position: relative; overflow: hidden; }
        .upload-zone:hover, .upload-zone.dragover { border-color: var(--accent); background: rgba(79,142,247,.04); }
        .upload-zone input[type="file"] { position: absolute; inset: 0; opacity: 0; cursor: pointer; width: 100%; height: 100%; font-size: 0; }
        .upload-icon { font-size: 26px; margin-bottom: 6px; opacity: .5; }
        .upload-text { font-size: 13px; color: var(--muted); }
        .upload-text strong { color: var(--accent); }
        .upload-hint { font-size: 11px; color: var(--muted); margin-top: 3px; }

        .preview-grid { display: flex; gap: 10px; flex-wrap: wrap; margin-top: 10px; }
        .preview-item { position: relative; width: 90px; height: 90px; border-radius: 10px; overflow: hidden; border: 1px solid var(--border); }
        .preview-item img { width: 100%; height: 100%; object-fit: cover; }
        .preview-remove { position: absolute; top: 4px; right: 4px; width: 20px; height: 20px; border-radius: 50%; background: rgba(0,0,0,.7); color: #fff; font-size: 11px; border: none; cursor: pointer; display: flex; align-items: center; justify-content: center; }
        .preview-remove:hover { background: var(--danger); }

        .anh-counter { font-size: 11px; color: var(--muted); margin-bottom: 10px; }
        .anh-counter span { color: var(--accent); font-weight: 700; }

        /* Footer */
        .form-footer { padding: 20px 32px 28px; border-top: 1px solid var(--border); display: flex; align-items: center; justify-content: space-between; gap: 12px; }
        .btn-back { height: 42px; padding: 0 20px; border-radius: 10px; background: var(--surface2); border: 1px solid var(--border); color: var(--muted); font-size: 13px; font-weight: 600; font-family: inherit; cursor: pointer; transition: all .15s; display: flex; align-items: center; gap: 6px; }
        .btn-back:hover { border-color: var(--text); color: var(--text); }
        .btn-submit { height: 42px; padding: 0 28px; border-radius: 10px; background: var(--accent); border: none; color: #fff; font-size: 14px; font-weight: 700; font-family: inherit; cursor: pointer; transition: opacity .15s; display: flex; align-items: center; gap: 8px; }
        .btn-submit:hover { opacity: .88; }
        .btn-submit:disabled { opacity: .5; cursor: not-allowed; }
        .btn-submit .spinner { width: 16px; height: 16px; border: 2px solid rgba(255,255,255,.4); border-top-color: #fff; border-radius: 50%; animation: spin .6s linear infinite; display: none; }
        .btn-submit.loading .spinner { display: inline-block; }
        .btn-submit.loading .btn-text { display: none; }
        @keyframes spin { to { transform: rotate(360deg); } }

        .toast { position: fixed; bottom: 28px; right: 28px; z-index: 9999; padding: 13px 22px; border-radius: 10px; font-size: 13px; font-weight: 600; display: none; align-items: center; gap: 10px; box-shadow: 0 8px 32px rgba(0,0,0,.4); max-width: 400px; }
        .toast.show { display: flex; animation: slideUp .25s ease; }
        .toast.success { background: rgba(56,217,169,.15); border: 1px solid rgba(56,217,169,.4); color: var(--accent2); }
        .toast.error   { background: rgba(247,92,92,.15);  border: 1px solid rgba(247,92,92,.4);  color: var(--danger); }
        @keyframes slideUp { from{opacity:0;transform:translateY(14px)} to{opacity:1;transform:translateY(0)} }
    </style>
</head>
<body>

<%
    Map<String, Object> pa =
        (Map<String, Object>) request.getAttribute("phanAnh");
    List<Map<String, Object>> danhSachAnh =
        (List<Map<String, Object>>) request.getAttribute("danhSachAnh");
    if (pa == null) { response.sendRedirect(request.getContextPath() + "/hodan/phan-anh"); return; }
    if (danhSachAnh == null) danhSachAnh = new java.util.ArrayList<>();

    String ctx        = request.getContextPath();
    int    phanAnhID  = (int)    pa.get("phanAnhID");
    String tieuDe     = String.valueOf(pa.get("tieuDe"));
    String noiDung    = String.valueOf(pa.get("noiDung"));
    String tenLoai    = String.valueOf(pa.get("tenLoai"));
    int    mucDoHienTai = (int) pa.get("mucDoUuTien");
    int    soAnhHienTai = danhSachAnh.size();
%>

<header class="topbar">
    <a href="<%= ctx %>/hodan/dashboard" class="topbar-logo">
        <div class="logo-icon">🏘</div>
        <div class="logo-text">Cổng <span>Dịch Vụ</span></div>
    </a>
    <div class="topbar-divider"></div>
    <div class="breadcrumb">
        <a href="<%= ctx %>/hodan/dashboard">Trang chủ</a>
        <span>›</span>
        <a href="<%= ctx %>/hodan/phan-anh">Phản ánh / Kiến nghị</a>
        <span>›</span>
        <span style="color:var(--accent);font-weight:600">Sửa phản ánh</span>
    </div>
    <div class="topbar-spacer"></div>
</header>

<main class="main">
    <div class="content">
        <div class="form-card">

            <!-- HEADER -->
            <div class="form-card-header">
                <div class="form-ico">✏️</div>
                <div>
                    <h1>Sửa phản ánh</h1>
                    <p>Chỉ có thể chỉnh sửa nội dung, mức độ và ảnh đính kèm</p>
                </div>
            </div>

            <div class="form-body">

                <!-- Tiêu đề — CHỈ ĐỌC -->
                <div class="form-group">
                    <label class="form-label">Tiêu đề</label>
                    <div class="form-readonly">
                        <span><%= tieuDe %></span>
                        <span class="readonly-badge">🔒 Không thể sửa</span>
                    </div>
                    <div class="readonly-hint">🛈 Tiêu đề không thể thay đổi sau khi gửi</div>
                </div>

                <!-- Loại phản ánh — CHỈ ĐỌC -->
                <div class="form-group">
                    <label class="form-label">Loại phản ánh</label>
                    <div class="form-readonly">
                        <span><%= tenLoai %></span>
                        <span class="readonly-badge">🔒 Không thể sửa</span>
                    </div>
                    <div class="readonly-hint">🛈 Loại phản ánh không thể thay đổi sau khi gửi</div>
                </div>

                <!-- Mức độ ưu tiên — CÓ THỂ SỬA -->
                <div class="form-group">
                    <label class="form-label">Mức độ ưu tiên <span class="req">*</span></label>
                    <div class="muc-do-group">
                        <label class="muc-do-outer">
                            <input type="radio" name="mucDoUuTien" value="1" class="muc-do-item"
                                   <%= mucDoHienTai == 1 ? "checked" : "" %>>
                            <span class="muc-do-label thap">
                                <span class="muc-do-icon">⚪</span>
                                <span class="muc-do-text" style="color:var(--muted)">Thấp</span>
                                <span class="muc-do-desc">Không ảnh hưởng nhiều, có thể xử lý sau</span>
                            </span>
                        </label>
                        <label class="muc-do-outer">
                            <input type="radio" name="mucDoUuTien" value="2" class="muc-do-item"
                                   <%= mucDoHienTai == 2 ? "checked" : "" %>>
                            <span class="muc-do-label tb">
                                <span class="muc-do-icon">🟡</span>
                                <span class="muc-do-text" style="color:var(--warn)">Trung bình</span>
                                <span class="muc-do-desc">Cần xử lý trong thời gian sớm</span>
                            </span>
                        </label>
                        <label class="muc-do-outer">
                            <input type="radio" name="mucDoUuTien" value="3" class="muc-do-item"
                                   <%= mucDoHienTai == 3 ? "checked" : "" %>>
                            <span class="muc-do-label cao">
                                <span class="muc-do-icon">🔴</span>
                                <span class="muc-do-text" style="color:var(--danger)">Cao</span>
                                <span class="muc-do-desc">Khẩn cấp, cần xử lý ngay lập tức</span>
                            </span>
                        </label>
                    </div>
                </div>

                <!-- Nội dung chi tiết — CÓ THỂ SỬA -->
                <div class="form-group">
                    <label class="form-label">Nội dung chi tiết <span class="req">*</span></label>
                    <textarea class="form-textarea" id="noiDung"
                              maxlength="2000"
                              oninput="updateChar(this,'charNoiDung',2000)"><%= noiDung %></textarea>
                    <div class="char-count" id="charNoiDung"><%= noiDung.length() %> / 2000</div>
                    <div class="form-error" id="errNoiDung">Vui lòng nhập nội dung.</div>
                </div>

                <!-- Ảnh đính kèm — CÓ THỂ SỬA -->
                <div class="form-group">
                    <label class="form-label">Ảnh đính kèm
                        <span style="color:var(--muted);font-weight:400;text-transform:none">(tối đa 3 ảnh)</span>
                    </label>

                    <!-- Ảnh hiện tại -->
                    <% if (!danhSachAnh.isEmpty()) { %>
                    <div class="anh-counter">
                        Ảnh hiện tại: <span id="soAnhHienTai"><%= soAnhHienTai %></span> ảnh
                        — bấm 🗑 để đánh dấu xóa
                    </div>
                    <div class="anh-hien-tai" id="anhHienTai">
                        <% for (Map<String, Object> anh : danhSachAnh) {
                            int    fileID   = (int)    anh.get("fileID");
                            String duongDan = String.valueOf(anh.get("duongDan"));
                        %>
                        <div class="anh-item" id="anh-<%= fileID %>">
                            <img src="<%= ctx %>/<%= duongDan %>" alt="Ảnh phản ánh">
                            <button class="anh-remove" onclick="toggleXoaAnh(<%= fileID %>, this)"
                                    title="Đánh dấu xóa">🗑</button>
                        </div>
                        <% } %>
                    </div>
                    <% } %>

                    <!-- Thêm ảnh mới -->
                    <div id="themAnhArea">
                        <div class="upload-zone" id="dropZone">
                            <input type="file" id="fileInput" accept="image/*" multiple
                                   onchange="handleFiles(this.files)">
                            <div class="upload-icon">🖼</div>
                            <div class="upload-text">
                                Kéo thả hoặc <strong>bấm để thêm ảnh mới</strong>
                            </div>
                            <div class="upload-hint">JPG, PNG, WEBP, GIF · Tối đa 5MB / ảnh</div>
                        </div>
                        <div class="preview-grid" id="previewGrid"></div>
                    </div>
                    <div class="form-error" id="errAnh"></div>
                </div>

            </div><!-- /.form-body -->

            <div class="form-footer">
                <button class="btn-back" onclick="history.back()">← Quay lại</button>
                <button class="btn-submit" id="btnSubmit" onclick="submitForm()">
                    <span class="spinner"></span>
                    <span class="btn-text">💾 Lưu thay đổi</span>
                </button>
            </div>

        </div>
    </div>
</main>

<div class="toast" id="toast"></div>

<script>
    const CTX       = '<%= ctx %>';
    const PHAN_ANH_ID = <%= phanAnhID %>;
    const SO_ANH_HIEN_TAI = <%= soAnhHienTai %>;

    let fileIDXoa    = [];   // ID ảnh cũ muốn xóa
    let selectedFiles = []; // File mới muốn thêm

    // ── Đánh dấu xóa ảnh cũ ──
    function toggleXoaAnh(fileID, btn) {
        const item = document.getElementById('anh-' + fileID);
        const idx  = fileIDXoa.indexOf(fileID);
        if (idx === -1) {
            // Đánh dấu xóa
            fileIDXoa.push(fileID);
            item.classList.add('xoa-pending');
            btn.textContent = '↩';
            btn.title = 'Khôi phục';
            btn.className = 'anh-restore';
        } else {
            // Khôi phục
            fileIDXoa.splice(idx, 1);
            item.classList.remove('xoa-pending');
            btn.textContent = '🗑';
            btn.title = 'Đánh dấu xóa';
            btn.className = 'anh-remove';
        }
        updateAnhCounter();
    }

    function updateAnhCounter() {
        const conLai = SO_ANH_HIEN_TAI - fileIDXoa.length + selectedFiles.length;
        const el = document.getElementById('soAnhHienTai');
        if (el) el.textContent = (SO_ANH_HIEN_TAI - fileIDXoa.length);
        // Ẩn dropzone nếu đã đủ 3
        const dropZone = document.getElementById('dropZone');
        if (conLai >= 3) {
            dropZone.style.display = 'none';
        } else {
            dropZone.style.display = '';
        }
    }

    // ── Drag & Drop ──
    const dropZone = document.getElementById('dropZone');
    dropZone.addEventListener('dragover',  e => { e.preventDefault(); dropZone.classList.add('dragover'); });
    dropZone.addEventListener('dragleave', () => dropZone.classList.remove('dragover'));
    dropZone.addEventListener('drop', e => {
        e.preventDefault();
        dropZone.classList.remove('dragover');
        handleFiles(e.dataTransfer.files);
    });

    function handleFiles(files) {
        document.getElementById('errAnh').classList.remove('show');
        const conLai = (SO_ANH_HIEN_TAI - fileIDXoa.length) + selectedFiles.length;

        for (const file of files) {
            if (conLai + selectedFiles.length >= 3) {
                showErrAnh('Tổng số ảnh không được vượt quá 3.'); break;
            }
            if (!file.type.startsWith('image/')) {
                showErrAnh('Chỉ chấp nhận file ảnh (JPG, PNG, WEBP, GIF).'); continue;
            }
            if (file.size > 5 * 1024 * 1024) {
                showErrAnh('Ảnh "' + file.name + '" vượt quá 5MB.'); continue;
            }
            selectedFiles.push(file);
        }
        renderPreview();
        updateAnhCounter();
    }

    function renderPreview() {
        const grid = document.getElementById('previewGrid');
        grid.innerHTML = '';
        selectedFiles.forEach((file, idx) => {
            const url  = URL.createObjectURL(file);
            const item = document.createElement('div');
            item.className = 'preview-item';
            item.innerHTML = '<img src="' + url + '" alt="">'
                + '<button class="preview-remove" onclick="removeNewFile(' + idx + ')">✕</button>';
            grid.appendChild(item);
        });
    }

    function removeNewFile(idx) {
        selectedFiles.splice(idx, 1);
        renderPreview();
        updateAnhCounter();
        document.getElementById('errAnh').classList.remove('show');
    }

    function showErrAnh(msg) {
        const el = document.getElementById('errAnh');
        el.textContent = msg; el.classList.add('show');
    }

    // ── Đếm ký tự ──
    function updateChar(el, id, max) {
        const cnt = document.getElementById(id);
        const len = el.value.length;
        cnt.textContent = len + ' / ' + max;
        cnt.className = 'char-count' + (len > max * .9 ? ' warn' : '');
    }

    // ── Submit ──
    function submitForm() {
        const noiDung = document.getElementById('noiDung').value.trim();
        if (!noiDung) {
            const el = document.getElementById('errNoiDung');
            el.classList.add('show');
            document.getElementById('noiDung').classList.add('error');
            return;
        }
        document.getElementById('errNoiDung').classList.remove('show');
        document.getElementById('noiDung').classList.remove('error');

        const mucDoUuTien = document.querySelector('input[name="mucDoUuTien"]:checked').value;

        const btn = document.getElementById('btnSubmit');
        btn.classList.add('loading'); btn.disabled = true;

        const formData = new FormData();
        formData.append('action',      'sua');
        formData.append('phanAnhID',   PHAN_ANH_ID);
        formData.append('noiDung',     noiDung);
        formData.append('mucDoUuTien', mucDoUuTien);
        fileIDXoa.forEach(id => formData.append('fileIDXoa', id));
        selectedFiles.forEach(f => formData.append('anh', f));

        fetch(CTX + '/hodan/phan-anh', {
            method: 'POST', body: formData, credentials: 'include'
        })
        .then(r => r.json())
        .then(data => {
            if (data.success) {
                showToast('success', '✓ ' + data.message);
                setTimeout(() => { location.href = CTX + '/hodan/phan-anh'; }, 1200);
            } else {
                showToast('error', '✕ ' + data.message);
                btn.classList.remove('loading'); btn.disabled = false;
            }
        })
        .catch(() => {
            showToast('error', '✕ Lỗi kết nối. Vui lòng thử lại.');
            btn.classList.remove('loading'); btn.disabled = false;
        });
    }

    function showToast(type, msg) {
        const t = document.getElementById('toast');
        t.className = 'toast ' + type + ' show'; t.textContent = msg;
        clearTimeout(t._t); t._t = setTimeout(() => t.classList.remove('show'), 4000);
    }

    // Khởi tạo counter
    updateAnhCounter();
</script>
</body>
</html>
