<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sửa lịch họp</title>
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
        .topbar-title{font-size:13px;font-weight:600;color:var(--muted)}
        .topbar-spacer{flex:1}
        .back-btn{display:flex;align-items:center;gap:6px;font-size:13px;font-weight:600;color:var(--muted);text-decoration:none;padding:6px 12px;border-radius:8px;border:1px solid var(--border);background:var(--surface2);transition:all .18s}
        .back-btn:hover{color:var(--text);border-color:var(--accent)}
        .main{padding-top:64px}
        .content{max-width:720px;margin:0 auto;padding:40px 32px}
        .page-header{margin-bottom:28px}
        .page-header h2{font-size:22px;font-weight:800;letter-spacing:-.4px;margin-bottom:4px}
        .page-header p{font-size:13px;color:var(--muted)}
        .alert{padding:12px 18px;border-radius:10px;font-size:13px;font-weight:500;margin-bottom:20px;display:flex;align-items:center;gap:10px}
        .alert-error{background:rgba(247,92,92,.12);border:1px solid rgba(247,92,92,.3);color:var(--danger)}
        .form-card{background:var(--surface);border:1px solid var(--border);border-radius:var(--radius);padding:32px 36px}
        .form-group{margin-bottom:22px}
        .form-row{display:grid;grid-template-columns:1fr 1fr;gap:16px;margin-bottom:22px}
        label{display:block;font-size:13px;font-weight:600;color:var(--text);margin-bottom:8px}
        label .required{color:var(--danger);margin-left:3px}
        label .hint{font-size:11px;color:var(--muted);font-weight:400;margin-left:6px}
        input[type="text"],input[type="datetime-local"],textarea,select{width:100%;padding:10px 14px;background:var(--surface2);border:1px solid var(--border);border-radius:8px;color:var(--text);font-size:13px;font-family:inherit;outline:none;transition:border-color .18s,box-shadow .18s}
        input[type="text"]:focus,input[type="datetime-local"]:focus,textarea:focus,select:focus{border-color:var(--accent);box-shadow:0 0 0 3px rgba(79,142,247,.12)}
        input::placeholder,textarea::placeholder{color:var(--muted)}
        textarea{resize:vertical;min-height:100px;line-height:1.6}
        .input-error{border-color:var(--danger)!important}
        .field-error{font-size:11px;color:var(--danger);margin-top:5px;display:none}
        .field-error.show{display:block}
        .field-error-block{font-size:11px;color:var(--danger);margin-top:6px;display:none}
        .field-error-block.show{display:block}
        .form-divider{border:none;border-top:1px solid var(--border);margin:26px 0}
        .form-section-title{font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:1px;color:var(--muted);margin-bottom:18px}
        .warn-box{background:rgba(251,191,36,.08);border:1px solid rgba(251,191,36,.25);border-radius:10px;padding:14px 16px;display:flex;gap:10px;align-items:flex-start;font-size:13px;color:var(--warn);line-height:1.6;margin-bottom:26px}
        .warn-box .wi{font-size:16px;flex-shrink:0;margin-top:1px}
        .phanloai-row{display:grid;grid-template-columns:1fr 1fr;gap:16px;margin-bottom:22px}
        .dropdown-wrap{position:relative}
        .dropdown-trigger{width:100%;padding:10px 14px;background:var(--surface2);border:1.5px solid var(--border);border-radius:8px;color:var(--text);font-size:13px;font-family:inherit;cursor:pointer;text-align:left;display:flex;align-items:center;justify-content:space-between;transition:border-color .18s;outline:none}
        .dropdown-trigger:hover,.dropdown-trigger.open{border-color:var(--accent)}
        .dropdown-trigger .dt-left{display:flex;align-items:center;gap:8px;overflow:hidden}
        .dropdown-trigger .dt-text{white-space:nowrap;overflow:hidden;text-overflow:ellipsis;max-width:200px}
        .dropdown-trigger .dt-arrow{font-size:10px;color:var(--muted);flex-shrink:0;margin-left:8px;transition:transform .2s}
        .dropdown-trigger.open .dt-arrow{transform:rotate(180deg)}
        .dropdown-panel{position:absolute;top:calc(100% + 6px);left:0;right:0;background:var(--surface2);border:1.5px solid var(--accent);border-radius:10px;z-index:300;overflow:hidden;display:none;box-shadow:0 8px 32px rgba(0,0,0,.5)}
        .dropdown-panel.open{display:block;animation:ddDown .15s ease}
        @keyframes ddDown{from{opacity:0;transform:translateY(-6px)}to{opacity:1;transform:translateY(0)}}
        .level-option{display:flex;align-items:center;gap:10px;padding:11px 14px;cursor:pointer;transition:background .15s;font-size:13px;font-weight:500;border-bottom:1px solid var(--border)}
        .level-option:last-child{border-bottom:none}
        .level-option input[type="radio"]{display:none}
        .lo-dot{width:10px;height:10px;border-radius:50%;flex-shrink:0}
        .lo-dot.normal{background:var(--accent2)}
        .lo-dot.warn{background:var(--warn)}
        .lo-dot.danger{background:var(--danger)}
        .lo-right{margin-left:auto;font-size:10px;color:var(--muted)}
        .level-option:hover{background:var(--surface)}
        .level-option.sel-normal{background:rgba(56,217,169,.1);color:var(--accent2)}
        .level-option.sel-warn{background:rgba(251,191,36,.1);color:var(--warn)}
        .level-option.sel-danger{background:rgba(247,92,92,.1);color:var(--danger)}
        .check-option{display:flex;align-items:center;gap:10px;padding:10px 14px;cursor:pointer;transition:background .15s;font-size:13px;font-weight:500;border-bottom:1px solid var(--border);user-select:none}
        .check-option:last-child{border-bottom:none}
        .check-option input[type="checkbox"]{display:none}
        .co-box{width:16px;height:16px;border-radius:4px;border:1.5px solid var(--muted);flex-shrink:0;display:flex;align-items:center;justify-content:center;font-size:10px;font-weight:700;transition:all .15s}
        .check-option:hover{background:var(--surface)}
        .check-option.checked{background:rgba(56,217,169,.08);color:var(--accent2)}
        .check-option.checked .co-box{background:var(--accent2);border-color:var(--accent2);color:#000}
        .lydo-wrap{background:rgba(247,92,92,.06);border:1px solid rgba(247,92,92,.2);border-radius:10px;padding:18px 20px;margin-top:4px}
        .lydo-wrap label{color:var(--danger)}
        .lydo-wrap textarea{background:var(--surface);border-color:rgba(247,92,92,.3);min-height:80px}
        .lydo-wrap textarea:focus{border-color:var(--danger);box-shadow:0 0 0 3px rgba(247,92,92,.1)}
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
    <a href="${pageContext.request.contextPath}/totruong/dashboard" class="topbar-logo">
        <div class="logo-icon">🏘</div>
        <div class="logo-text">Quản lý <span>Hộ dân</span></div>
    </a>
    <div class="topbar-divider"></div>
    <span class="topbar-title">Sửa lịch họp</span>
    <div class="topbar-spacer"></div>
    <a href="${pageContext.request.contextPath}/danh-sach-lich-hop" class="back-btn">← Danh sách lịch họp</a>
</header>

<main class="main">
    <div class="content">
        <div class="page-header">
            <h2>✏️ Chỉnh sửa lịch họp</h2>
            <p>Sau khi lưu, thông báo thay đổi sẽ tự động gửi đến toàn bộ chủ hộ</p>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-error">❌ ${error}</div>
        </c:if>

        <div class="warn-box">
            <span class="wi">⚠️</span>
            <span>Lịch họp <strong>không thể xóa</strong>. Mỗi lần chỉnh sửa sẽ được
            <strong>ghi lại lịch sử</strong> và thông báo đến chủ hộ. Vui lòng nhập rõ lý do.</span>
        </div>

        <div class="form-card">
            <form method="post" action="${pageContext.request.contextPath}/sua-lich-hop"
                  id="formSua" novalidate>

                <input type="hidden" name="lichHopID" value="${lichHop.lichHopID}"/>

                <%-- 1. THỜI GIAN --%>
                <div class="form-section-title">Thời gian</div>
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

                <%-- 2. PHÂN LOẠI --%>
                <div class="form-section-title">Phân loại</div>
                <div class="phanloai-row">
                    <div class="dropdown-wrap">
                        <label>Mức độ quan trọng <span class="required">*</span></label>
                        <button type="button" class="dropdown-trigger" id="triggerMucDo"
                                onclick="toggleDD('panelMucDo','triggerMucDo')">
                            <span class="dt-left">
                                <span id="mucDoIcon">🟢</span>
                                <span class="dt-text" id="mucDoText">Bình thường</span>
                            </span>
                            <span class="dt-arrow">▼</span>
                        </button>
                        <div class="dropdown-panel" id="panelMucDo">
                            <div class="level-option" id="lo-1" onclick="selectLevel(1,'normal','🟢','Bình thường')">
                                <input type="radio" name="mucDo" value="1"/>
                                <span class="lo-dot normal"></span> Bình thường
                                <span class="lo-right">Họp định kỳ</span>
                            </div>
                            <div class="level-option" id="lo-2" onclick="selectLevel(2,'warn','🟡','Quan trọng')">
                                <input type="radio" name="mucDo" value="2"/>
                                <span class="lo-dot warn"></span> Quan trọng
                                <span class="lo-right">Cần chú ý</span>
                            </div>
                            <div class="level-option" id="lo-3" onclick="selectLevel(3,'danger','🔴','Khẩn cấp')">
                                <input type="radio" name="mucDo" value="3"/>
                                <span class="lo-dot danger"></span> Khẩn cấp
                                <span class="lo-right">Ưu tiên cao</span>
                            </div>
                        </div>
                        <div class="field-error-block" id="err-mucDo">Vui lòng chọn mức độ.</div>
                    </div>

                    <div class="dropdown-wrap">
                        <label>Đối tượng tham gia <span class="required">*</span></label>
                        <button type="button" class="dropdown-trigger" id="triggerDoiTuong"
                                onclick="toggleDD('panelDoiTuong','triggerDoiTuong')">
                            <span class="dt-left">
                                <span>👥</span>
                                <span class="dt-text" id="doiTuongText">Chọn đối tượng...</span>
                            </span>
                            <span class="dt-arrow">▼</span>
                        </button>
                        <div class="dropdown-panel" id="panelDoiTuong">
                            <div class="check-option" id="co-tatca" onclick="toggleCO(this,'tatca')">
                                <input type="checkbox" name="doiTuong" value="tatca"/>
                                <span class="co-box"></span> 👥 Tất cả
                            </div>
                            <div class="check-option" id="co-chuho" onclick="toggleCO(this,'chuho')">
                                <input type="checkbox" name="doiTuong" value="chuho"/>
                                <span class="co-box"></span> 👤 Chủ hộ
                            </div>
                            <div class="check-option" id="co-thanhnien" onclick="toggleCO(this,'thanhnien')">
                                <input type="checkbox" name="doiTuong" value="thanhnien"/>
                                <span class="co-box"></span> 🧑 Thanh niên
                            </div>
                            <div class="check-option" id="co-phunu" onclick="toggleCO(this,'phunu')">
                                <input type="checkbox" name="doiTuong" value="phunu"/>
                                <span class="co-box"></span> 👩 Phụ nữ
                            </div>
                            <div class="check-option" id="co-nguoicao" onclick="toggleCO(this,'nguoicao')">
                                <input type="checkbox" name="doiTuong" value="nguoicao"/>
                                <span class="co-box"></span> 👴 Người cao tuổi
                            </div>
                        </div>
                        <div class="field-error-block" id="err-doiTuong">Vui lòng chọn ít nhất một đối tượng.</div>
                    </div>
                </div>

                <hr class="form-divider"/>

                <%-- 3. THÔNG TIN --%>
                <div class="form-section-title">Thông tin lịch họp</div>

                <div class="form-group">
                    <label for="tieuDe">Tiêu đề <span class="required">*</span></label>
                    <input type="text" id="tieuDe" name="tieuDe"
                           value="${lichHop.tieuDe}" maxlength="255"/>
                    <div class="field-error" id="err-tieuDe">Vui lòng nhập tiêu đề.</div>
                </div>

                <div class="form-group">
                    <label for="diaDiem">Địa điểm <span class="required">*</span></label>
                    <input type="text" id="diaDiem" name="diaDiem"
                           value="${lichHop.diaDiem}" maxlength="300"/>
                    <div class="field-error" id="err-diaDiem">Vui lòng nhập địa điểm.</div>
                </div>

                <div class="form-group">
                    <label for="noiDung">Nội dung <span class="hint">(không bắt buộc)</span></label>
                    <textarea id="noiDung" name="noiDung">${lichHop.noiDung}</textarea>
                </div>

                <hr class="form-divider"/>

                <%-- 4. LÝ DO SỬA — bắt buộc --%>
                <div class="lydo-wrap">
                    <label for="lyDoSua">Lý do chỉnh sửa <span class="required">*</span></label>
                    <textarea id="lyDoSua" name="lyDoSua"
                              placeholder="Nhập rõ lý do thay đổi để thông báo đến chủ hộ..."></textarea>
                    <div class="field-error" id="err-lyDoSua" style="display:none">Vui lòng nhập lý do chỉnh sửa.</div>
                </div>

                <div class="form-actions">
                    <a href="${pageContext.request.contextPath}/danh-sach-lich-hop" class="btn-cancel">Hủy</a>
                    <button type="submit" class="btn-submit" id="btnSubmit">
                        <div class="spinner" id="spinner"></div>
                        ✏️ Lưu thay đổi
                    </button>
                </div>

            </form>
        </div>
    </div>
</main>

<script>
    const initMucDo    = parseInt('${lichHop.mucDo}') || 1;
    const initDoiTuong = '${lichHop.doiTuong}' || '';

    // Format timestamp → datetime-local value
    function fmtTimestamp(ts) {
        if (!ts) return '';
        return ts.toString().substring(0, 16).replace(' ', 'T');
    }

    // Set giá trị cũ từ server
    document.getElementById('thoiGianBatDau').value  = fmtTimestamp('${lichHop.thoiGianBatDau}');
    document.getElementById('thoiGianKetThuc').value = fmtTimestamp('${lichHop.thoiGianKetThuc}');

    // Min = now (chỉ để ngăn chọn quá khứ nếu người dùng đổi giờ mới)
    (function () {
        const now = new Date();
        now.setMinutes(now.getMinutes() - now.getTimezoneOffset());
        const minVal = now.toISOString().slice(0, 16);
        document.getElementById('thoiGianBatDau').min  = minVal;
        document.getElementById('thoiGianKetThuc').min = minVal;
    })();

    document.getElementById('thoiGianBatDau').addEventListener('change', function () {
        const kt = document.getElementById('thoiGianKetThuc');
        kt.min = this.value;
        if (kt.value && kt.value <= this.value) kt.value = '';
    });

    // ── DROPDOWN ──
    function toggleDD(panelId, triggerId) {
        const panel   = document.getElementById(panelId);
        const trigger = document.getElementById(triggerId);
        const isOpen  = panel.classList.contains('open');
        closeAllDD();
        if (!isOpen) { panel.classList.add('open'); trigger.classList.add('open'); }
    }
    function closeAllDD() {
        document.querySelectorAll('.dropdown-panel').forEach(p => p.classList.remove('open'));
        document.querySelectorAll('.dropdown-trigger').forEach(b => b.classList.remove('open'));
    }
    document.addEventListener('click', function (e) {
        if (!e.target.closest('.dropdown-wrap')) closeAllDD();
    });

    // ── MỨC ĐỘ ──
    const levelMeta = {
        1: ['normal','🟢','Bình thường'],
        2: ['warn',  '🟡','Quan trọng'],
        3: ['danger','🔴','Khẩn cấp']
    };
    function selectLevel(val, type, icon, text) {
        document.querySelector('#panelMucDo input[value="' + val + '"]').checked = true;
        document.getElementById('mucDoIcon').textContent = icon;
        document.getElementById('mucDoText').textContent = text;
        [1,2,3].forEach(i => document.getElementById('lo-' + i).className = 'level-option');
        document.getElementById('lo-' + val).classList.add('sel-' + type);
        document.getElementById('err-mucDo').classList.remove('show');
        setTimeout(closeAllDD, 120);
    }
    (function () {
        const [type, icon, text] = levelMeta[initMucDo] || levelMeta[1];
        selectLevel(initMucDo, type, icon, text);
    })();

    // ── ĐỐI TƯỢNG THAM GIA ──
    const doiTuongLabels = {
        tatca:'Tất cả', chuho:'Chủ hộ', thanhnien:'Thanh niên',
        phunu:'Phụ nữ', nguoicao:'Người cao tuổi'
    };
    function toggleCO(card, key) {
        const cb  = card.querySelector('input[type="checkbox"]');
        const box = card.querySelector('.co-box');
        const next = !cb.checked;
        if (key === 'tatca' && next) {
            document.querySelectorAll('#panelDoiTuong .check-option').forEach(c => {
                if (c.id !== 'co-tatca') {
                    c.classList.remove('checked');
                    c.querySelector('input').checked = false;
                    c.querySelector('.co-box').textContent = '';
                }
            });
        } else if (key !== 'tatca' && next) {
            const tc = document.getElementById('co-tatca');
            tc.classList.remove('checked');
            tc.querySelector('input').checked = false;
            tc.querySelector('.co-box').textContent = '';
        }
        cb.checked = next;
        if (next) { card.classList.add('checked');    box.textContent = '✓'; }
        else       { card.classList.remove('checked'); box.textContent = '';  }
        updateDoiTuongText();
        document.getElementById('err-doiTuong').classList.remove('show');
    }
    function updateDoiTuongText() {
        const checked = [...document.querySelectorAll('input[name="doiTuong"]:checked')]
                            .map(i => doiTuongLabels[i.value]);
        document.getElementById('doiTuongText').textContent =
            checked.length ? checked.join(', ') : 'Chọn đối tượng...';
    }
    (function () {
        if (!initDoiTuong) return;
        initDoiTuong.split(',').forEach(key => {
            const card = document.getElementById('co-' + key.trim());
            if (card) {
                card.classList.add('checked');
                card.querySelector('input').checked = true;
                card.querySelector('.co-box').textContent = '✓';
            }
        });
        updateDoiTuongText();
    })();

    // ── VALIDATE + SUBMIT ──
    document.getElementById('formSua').addEventListener('submit', function (e) {
        let valid = true;

        function checkText(id, errId, msg) {
            const el  = document.getElementById(id);
            const err = document.getElementById(errId);
            if (!el.value.trim()) {
                el.classList.add('input-error'); err.textContent = msg; err.classList.add('show'); valid = false;
            } else {
                el.classList.remove('input-error'); err.classList.remove('show');
            }
        }

        // Thời gian bắt đầu — chỉ check không được để trống
        const bdEl  = document.getElementById('thoiGianBatDau');
        const errBd = document.getElementById('err-bd');
        if (!bdEl.value) {
            bdEl.classList.add('input-error');
            errBd.textContent = 'Vui lòng chọn thời gian bắt đầu.';
            errBd.classList.add('show'); valid = false;
        } else {
            bdEl.classList.remove('input-error'); errBd.classList.remove('show');
        }

        // Thời gian kết thúc phải sau bắt đầu
        const ktEl  = document.getElementById('thoiGianKetThuc');
        const errKt = document.getElementById('err-kt');
        if (ktEl.value && ktEl.value <= bdEl.value) {
            ktEl.classList.add('input-error');
            errKt.textContent = 'Thời gian kết thúc phải sau thời gian bắt đầu.';
            errKt.classList.add('show'); valid = false;
        } else {
            ktEl.classList.remove('input-error'); errKt.classList.remove('show');
        }

        if (!document.querySelector('input[name="mucDo"]:checked')) {
            document.getElementById('err-mucDo').classList.add('show'); valid = false;
        }
        if (!document.querySelector('input[name="doiTuong"]:checked')) {
            document.getElementById('err-doiTuong').classList.add('show'); valid = false;
        }

        checkText('tieuDe',  'err-tieuDe',  'Vui lòng nhập tiêu đề.');
        checkText('diaDiem', 'err-diaDiem', 'Vui lòng nhập địa điểm.');

        const lyDo    = document.getElementById('lyDoSua');
        const errLyDo = document.getElementById('err-lyDoSua');
        if (!lyDo.value.trim()) {
            lyDo.classList.add('input-error');
            errLyDo.style.display = 'block'; valid = false;
        } else {
            lyDo.classList.remove('input-error');
            errLyDo.style.display = 'none';
        }

        if (!valid) { e.preventDefault(); return; }
        document.getElementById('btnSubmit').disabled = true;
        document.getElementById('spinner').style.display = 'block';
    });

    ['tieuDe','diaDiem','thoiGianBatDau','lyDoSua'].forEach(function (id) {
        document.getElementById(id).addEventListener('input', function () {
            this.classList.remove('input-error');
            const err = document.getElementById('err-' + id);
            if (err) err.classList.remove('show');
        });
    });
</script>
</body>
</html>