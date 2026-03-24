<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sửa thiệp mời họp</title>
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
        .breadcrumb{display:flex;align-items:center;gap:6px;font-size:13px;color:var(--muted)}
        .breadcrumb a{color:var(--muted);text-decoration:none;transition:color .15s}
        .breadcrumb a:hover{color:var(--text)}
        .breadcrumb span{color:var(--warn);font-weight:600}
        .topbar-spacer{flex:1}
        .back-btn{display:flex;align-items:center;gap:6px;font-size:13px;font-weight:600;color:var(--muted);text-decoration:none;padding:6px 14px;border-radius:8px;border:1px solid var(--border);background:var(--surface2);transition:all .18s}
        .back-btn:hover{color:var(--text);border-color:var(--accent)}
        .main{padding-top:64px}
        .content{max-width:760px;margin:0 auto;padding:40px 32px}
        .page-header{margin-bottom:28px}
        .page-header h2{font-size:22px;font-weight:800;letter-spacing:-.4px;margin-bottom:4px}
        .page-header p{font-size:13px;color:var(--muted)}
        .alert{padding:12px 18px;border-radius:10px;font-size:13px;font-weight:500;margin-bottom:20px;display:flex;align-items:center;gap:10px}
        .alert-error{background:rgba(247,92,92,.12);border:1px solid rgba(247,92,92,.3);color:var(--danger)}
        .warn-box{background:rgba(251,191,36,.08);border:1px solid rgba(251,191,36,.25);border-radius:10px;padding:14px 16px;display:flex;gap:10px;align-items:flex-start;font-size:13px;color:var(--warn);line-height:1.6;margin-bottom:20px}
        .warn-box .wi{font-size:16px;flex-shrink:0;margin-top:1px}
        .countdown-box{background:rgba(79,142,247,.08);border:1px solid rgba(79,142,247,.25);border-radius:10px;padding:14px 18px;display:flex;align-items:center;gap:14px;font-size:13px;margin-bottom:24px;transition:background .3s,border-color .3s}
        .countdown-box .cd-icon{font-size:22px}
        .countdown-box .cd-label{font-size:11px;color:var(--muted);font-weight:600;text-transform:uppercase;letter-spacing:.05em;margin-bottom:3px}
        .countdown-box .cd-time{font-size:18px;font-weight:800;color:var(--accent);font-variant-numeric:tabular-nums;letter-spacing:.03em}
        .countdown-box.soon{background:rgba(251,191,36,.08);border-color:rgba(251,191,36,.3)}
        .countdown-box.soon .cd-time{color:var(--warn)}
        .countdown-box.urgent{background:rgba(247,92,92,.08);border-color:rgba(247,92,92,.3)}
        .countdown-box.urgent .cd-time{color:var(--danger)}
        .form-card{background:var(--surface);border:1px solid var(--border);border-radius:var(--radius);padding:32px 36px}
        .form-section-title{font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:1px;color:var(--muted);margin-bottom:18px}
        .form-group{margin-bottom:22px}
        .form-row{display:grid;grid-template-columns:1fr 1fr;gap:16px;margin-bottom:22px}
        .form-divider{border:none;border-top:1px solid var(--border);margin:26px 0}
        label{display:block;font-size:13px;font-weight:600;color:var(--text);margin-bottom:8px}
        label .required{color:var(--danger);margin-left:3px}
        label .hint{font-size:11px;color:var(--muted);font-weight:400;margin-left:6px}
        .locked-badge{font-size:10px;background:rgba(100,116,139,.15);color:var(--muted);border:1px solid var(--border);padding:2px 8px;border-radius:100px;margin-left:8px;font-weight:600;letter-spacing:.03em;vertical-align:middle}
        input[type="text"],input[type="datetime-local"],textarea{width:100%;padding:10px 14px;background:var(--surface2);border:1px solid var(--border);border-radius:8px;color:var(--text);font-size:13px;font-family:inherit;outline:none;transition:border-color .18s,box-shadow .18s}
        input[type="text"]:focus,input[type="datetime-local"]:focus,textarea:focus{border-color:var(--accent);box-shadow:0 0 0 3px rgba(79,142,247,.12)}
        input::placeholder,textarea::placeholder{color:var(--muted)}
        textarea{resize:vertical;min-height:110px;line-height:1.6}
        .input-locked{background:rgba(15,17,23,.5)!important;color:var(--muted)!important;cursor:not-allowed!important;border-style:dashed!important;user-select:none}
        .input-error{border-color:var(--danger)!important}
        .field-error{font-size:11px;color:var(--danger);margin-top:5px;display:none}
        .field-error.show{display:block}
        .form-actions{display:flex;gap:12px;justify-content:flex-end;margin-top:28px;padding-top:22px;border-top:1px solid var(--border)}
        .btn-cancel{padding:10px 22px;border-radius:10px;font-size:14px;font-weight:600;font-family:inherit;cursor:pointer;border:1px solid var(--border);background:var(--surface2);color:var(--muted);text-decoration:none;display:inline-flex;align-items:center;transition:all .18s}
        .btn-cancel:hover{color:var(--text);border-color:var(--text)}
        .btn-submit{padding:10px 28px;border-radius:10px;font-size:14px;font-weight:700;font-family:inherit;cursor:pointer;border:none;background:linear-gradient(135deg,var(--warn),#e6a817);color:#000;display:inline-flex;align-items:center;gap:8px;transition:opacity .18s}
        .btn-submit:hover{opacity:.88}
        .btn-submit:disabled{opacity:.5;cursor:not-allowed}
        .spinner{width:14px;height:14px;border-radius:50%;border:2px solid rgba(0,0,0,.2);border-top-color:#000;animation:spin .7s linear infinite;display:none}
        @keyframes spin{to{transform:rotate(360deg)}}
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
        <a href="${pageContext.request.contextPath}/thiepmoi/danh-sach">Thiệp mời họp</a>
        <span style="color:var(--muted)">›</span>
        <span>Chỉnh sửa</span>
    </div>
    <div class="topbar-spacer"></div>
    <a href="${pageContext.request.contextPath}/thiepmoi/danh-sach" class="back-btn">← Quay lại</a>
</header>

<main class="main">
    <div class="content">

        <div class="page-header">
            <h2>✏️ Chỉnh sửa thiệp mời</h2>
            <p>Sau khi lưu, thông báo [CẬP NHẬT] sẽ được gửi đến toàn bộ hộ dân trong tổ</p>
        </div>

        <c:if test="${not empty errorMsg}">
            <div class="alert alert-error">❌ ${errorMsg}</div>
        </c:if>

        <div class="warn-box">
            <span class="wi">⚠️</span>
            <span>
                <strong>Tiêu đề không thể thay đổi</strong> sau khi thiệp đã tạo.
                Chỉ được phép sửa <strong>địa điểm, nội dung và thời gian</strong>,
                và chỉ khi còn <strong>hơn 30 phút</strong> trước giờ họp.
            </span>
        </div>

        <%-- Countdown --%>
        <div class="countdown-box" id="countdownBox">
            <span class="cd-icon">⏰</span>
            <div>
                <div class="cd-label">Thời gian còn lại để chỉnh sửa</div>
                <div class="cd-time" id="cdTime">Đang tính...</div>
            </div>
        </div>

        <div class="form-card">
            <form method="post" action="${pageContext.request.contextPath}/thiepmoi/sua"
                  id="formSua" novalidate>

                <input type="hidden" name="thiepMoiID" value="${thiepMoi.thiepMoiID}"/>

                <%-- THỜI GIAN --%>
                <div class="form-section-title">Thời gian họp</div>
                <div class="form-row">
                    <div>
                        <label for="thoiGianBatDau">Thời gian bắt đầu <span class="required">*</span></label>
                        <input type="datetime-local" id="thoiGianBatDau" name="thoiGianBatDau"/>
                        <div class="field-error" id="err-bd"></div>
                    </div>
                    <div>
                        <label for="thoiGianKetThuc">Thời gian kết thúc <span class="hint">(không bắt buộc)</span></label>
                        <input type="datetime-local" id="thoiGianKetThuc" name="thoiGianKetThuc"/>
                        <div class="field-error" id="err-kt"></div>
                    </div>
                </div>

                <hr class="form-divider"/>

                <%-- THÔNG TIN --%>
                <div class="form-section-title">Thông tin thiệp mời</div>

                <div class="form-group">
                    <label>Tiêu đề <span class="locked-badge">🔒 Không thể sửa</span></label>
                    <input type="text" value="${thiepMoi.tieuDe}"
                           class="input-locked" readonly tabindex="-1"/>
                    <%-- Không có name → không gửi lên server --%>
                </div>

                <div class="form-group">
                    <label for="diaDiem">Địa điểm <span class="required">*</span></label>
                    <input type="text" id="diaDiem" name="diaDiem"
                           value="${thiepMoi.diaDiem}" maxlength="300"
                           placeholder="VD: Nhà văn hóa tổ 5, phường Lê Đại Hành"/>
                    <div class="field-error" id="err-diaDiem">Vui lòng nhập địa điểm.</div>
                </div>

                <div class="form-group">
                    <label for="noiDung">Nội dung / Chương trình họp <span class="hint">(không bắt buộc)</span></label>
                    <textarea id="noiDung" name="noiDung"
                              placeholder="1. Thông báo tình hình an ninh trật tự&#10;2. ...">${thiepMoi.noiDung}</textarea>
                </div>

                <div class="form-actions">
                    <a href="${pageContext.request.contextPath}/thiepmoi/danh-sach" class="btn-cancel">Hủy</a>
                    <button type="submit" class="btn-submit" id="btnSubmit">
                        <div class="spinner" id="spinner"></div>
                        💾 Lưu thay đổi
                    </button>
                </div>

            </form>
        </div>
    </div>
</main>

<script>
    // ── Set giá trị thời gian từ server ──
    function fmtTs(ts) {
        if (!ts || ts === 'null') return '';
        return ts.toString().substring(0, 16).replace(' ', 'T');
    }

    const bdInput = document.getElementById('thoiGianBatDau');
    const ktInput = document.getElementById('thoiGianKetThuc');

    bdInput.value = fmtTs('${thiepMoi.thoiGianBatDau}');
    ktInput.value = fmtTs('${thiepMoi.thoiGianKetThuc}');

    // Min = 30 phút kể từ bây giờ
    (function () {
        const min30 = new Date(Date.now() + 30 * 60 * 1000);
        min30.setSeconds(0, 0);
        const offset = min30.getTimezoneOffset();
        const localMin = new Date(min30.getTime() - offset * 60000);
        const minVal = localMin.toISOString().slice(0, 16);
        bdInput.min = minVal;
        ktInput.min = minVal;
    })();

    bdInput.addEventListener('change', function () {
        ktInput.min = this.value;
        if (ktInput.value && ktInput.value <= this.value) ktInput.value = '';
    });

    // ── Countdown: deadline = giờ họp - 30 phút ──
    const hopTimeStr = '${thiepMoi.thoiGianBatDau}';
    const hopMs = hopTimeStr ? new Date(hopTimeStr.replace(' ', 'T')).getTime() : 0;
    const deadline = hopMs - 30 * 60 * 1000;

    function pad2(n) { return String(n).padStart(2, '0'); }

    function tick() {
        const box  = document.getElementById('countdownBox');
        const disp = document.getElementById('cdTime');
        const rem  = deadline - Date.now();

        if (!hopMs || rem <= 0) {
            disp.textContent = 'Đã hết hạn chỉnh sửa';
            box.className = 'countdown-box urgent';
            document.getElementById('btnSubmit').disabled = true;
            return;
        }

        const h = Math.floor(rem / 3600000);
        const m = Math.floor((rem % 3600000) / 60000);
        const s = Math.floor((rem % 60000) / 1000);

        disp.textContent = h > 0
            ? (h + ' giờ ' + pad2(m) + ' phút ' + pad2(s) + ' giây')
            : (pad2(m) + ' phút ' + pad2(s) + ' giây');

        box.className = 'countdown-box' +
            (rem < 10 * 60000 ? ' urgent' : rem < 60 * 60000 ? ' soon' : '');
    }

    tick();
    setInterval(tick, 1000);

    // ── Validate + submit ──
    document.getElementById('formSua').addEventListener('submit', function (e) {
        let valid = true;

        const bd    = bdInput;
        const errBd = document.getElementById('err-bd');
        if (!bd.value) {
            bd.classList.add('input-error');
            errBd.textContent = 'Vui lòng chọn thời gian bắt đầu.';
            errBd.classList.add('show'); valid = false;
        } else {
            const diffMin = (new Date(bd.value).getTime() - Date.now()) / 60000;
            if (diffMin < 30) {
                bd.classList.add('input-error');
                errBd.textContent = 'Thời gian bắt đầu phải cách hiện tại ít nhất 30 phút.';
                errBd.classList.add('show'); valid = false;
            } else {
                bd.classList.remove('input-error'); errBd.classList.remove('show');
            }
        }

        const kt    = ktInput;
        const errKt = document.getElementById('err-kt');
        if (kt.value && kt.value <= bd.value) {
            kt.classList.add('input-error');
            errKt.textContent = 'Thời gian kết thúc phải sau thời gian bắt đầu.';
            errKt.classList.add('show'); valid = false;
        } else {
            kt.classList.remove('input-error'); errKt.classList.remove('show');
        }

        const dd    = document.getElementById('diaDiem');
        const errDd = document.getElementById('err-diaDiem');
        if (!dd.value.trim()) {
            dd.classList.add('input-error'); errDd.classList.add('show'); valid = false;
        } else {
            dd.classList.remove('input-error'); errDd.classList.remove('show');
        }

        if (!valid) { e.preventDefault(); return; }
        document.getElementById('btnSubmit').disabled = true;
        document.getElementById('spinner').style.display = 'block';
    });

    // Clear lỗi khi nhập
    document.getElementById('diaDiem').addEventListener('input', function () {
        this.classList.remove('input-error');
        document.getElementById('err-diaDiem').classList.remove('show');
    });
    bdInput.addEventListener('input', function () {
        this.classList.remove('input-error');
        document.getElementById('err-bd').classList.remove('show');
    });
</script>
</body>
</html>
