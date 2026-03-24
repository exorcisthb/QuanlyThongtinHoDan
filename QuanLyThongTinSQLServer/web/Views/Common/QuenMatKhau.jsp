<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quên mật khẩu – Quản lý Hộ dân</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;900&family=Be+Vietnam+Pro:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        :root {
            --navy: #0D1B2A; --ink: #1A2F45; --gold: #C9933A;
            --gold2: #E8B96A; --cream: #F7F3EC; --muted: #6B7F93; --white: #FFFFFF;
        }
        body {
            font-family: 'Be Vietnam Pro', sans-serif;
            min-height: 100vh; background: var(--navy);
            display: flex; flex-direction: column;
        }

        .navbar {
            position: fixed; top: 0; left: 0; right: 0; z-index: 999;
            display: flex; align-items: center; justify-content: space-between;
            padding: 0 48px; height: 70px;
            background: rgba(13,27,42,.95); backdrop-filter: blur(14px);
            border-bottom: 1px solid rgba(201,147,58,.2);
        }
        .nav-logo {
            display: flex; align-items: center; gap: 12px;
            font-family: 'Playfair Display', serif; font-size: 1.2rem;
            color: var(--white); text-decoration: none;
        }
        .nav-logo .emblem {
            width: 36px; height: 36px; border-radius: 50%;
            background: linear-gradient(135deg, var(--gold), var(--gold2));
            display: grid; place-items: center;
            font-weight: 900; color: var(--navy); font-size: 1rem;
        }
        .nav-actions { display: flex; gap: 10px; }
        .btn {
            display: inline-flex; align-items: center; padding: 8px 20px;
            border-radius: 6px; font-family: 'Be Vietnam Pro', sans-serif;
            font-weight: 600; font-size: .86rem; text-decoration: none; transition: all .25s;
        }
        .btn-ghost { border: 1.5px solid rgba(255,255,255,.3); color: var(--white); }
        .btn-ghost:hover { border-color: var(--gold); color: var(--gold); }
        .btn-gold-nav { background: linear-gradient(135deg, var(--gold), var(--gold2)); color: var(--navy); border: none; }
        .btn-gold-nav:hover { opacity: .88; transform: translateY(-1px); }

        .page-body {
            flex: 1; display: grid; grid-template-columns: 1fr 1fr;
            min-height: 100vh; padding-top: 70px;
        }

        .left-panel {
            background: var(--navy); display: flex; flex-direction: column;
            justify-content: center; align-items: flex-start;
            padding: 80px 60px; position: relative; overflow: hidden;
        }
        .left-panel::before {
            content: ''; position: absolute; inset: 0;
            background:
                radial-gradient(ellipse 70% 60% at 20% 60%, rgba(201,147,58,.1) 0%, transparent 65%),
                linear-gradient(rgba(201,147,58,.04) 1px, transparent 1px),
                linear-gradient(90deg, rgba(201,147,58,.04) 1px, transparent 1px);
            background-size: auto, 50px 50px, 50px 50px;
        }
        .left-content { position: relative; z-index: 1; }
        .left-tag {
            font-size: .75rem; font-weight: 700; letter-spacing: 2.5px;
            text-transform: uppercase; color: var(--gold); margin-bottom: 20px;
            display: flex; align-items: center; gap: 8px;
        }
        .left-tag::before { content: ''; display: block; width: 24px; height: 2px; background: var(--gold); }
        .left-panel h1 {
            font-family: 'Playfair Display', serif;
            font-size: clamp(2rem, 3.5vw, 3rem);
            color: var(--white); font-weight: 900; line-height: 1.15; margin-bottom: 20px;
        }
        .left-panel h1 span { color: var(--gold); }
        .left-desc { color: rgba(255,255,255,.55); font-size: .95rem; line-height: 1.75; max-width: 400px; margin-bottom: 40px; }
        .feature-list { display: flex; flex-direction: column; gap: 14px; }
        .feature-item { display: flex; align-items: center; gap: 12px; color: rgba(255,255,255,.65); font-size: .88rem; }
        .feature-dot {
            width: 28px; height: 28px; border-radius: 8px; flex-shrink: 0;
            background: rgba(201,147,58,.15); border: 1px solid rgba(201,147,58,.3);
            display: grid; place-items: center; font-size: .9rem;
        }

        /* RIGHT PANEL */
        .right-panel {
            background: var(--cream);
            display: flex; align-items: center; justify-content: center;
            padding: 60px 48px;
        }

        .form-wrapper {
            width: 100%; max-width: 420px;
        }

        /* STEP INDICATOR */
        .steps { display: flex; align-items: center; margin-bottom: 32px; }
        .step-item {
            display: flex; align-items: center; gap: 8px;
            font-size: .78rem; font-weight: 600; color: #b0bac5; white-space: nowrap;
        }
        .step-item.active { color: var(--gold); }
        .step-item.done   { color: #4ade80; }
        .step-circle {
            width: 26px; height: 26px; border-radius: 50%;
            border: 2px solid currentColor;
            display: grid; place-items: center; font-size: .72rem; font-weight: 700; flex-shrink: 0;
            transition: all .4s;
        }
        .step-item.active .step-circle { background: var(--gold); border-color: var(--gold); color: var(--navy); }
        .step-item.done   .step-circle { background: #4ade80; border-color: #4ade80; color: var(--navy); }
        .step-line { flex: 1; height: 2px; background: #dde3ea; margin: 0 8px; transition: background .5s; }
        .step-line.done { background: #4ade80; }

        /* MESSAGES */
        .alert-error {
            background: #fff0f0; border: 1px solid #fca5a5; color: #dc2626;
            border-radius: 8px; padding: 12px 16px; font-size: .88rem;
            margin-bottom: 20px; font-weight: 500; display: none;
        }
        .alert-success {
            background: #f0fff8; border: 1px solid #6ee7b7; color: #065f46;
            border-radius: 8px; padding: 12px 16px; font-size: .88rem;
            margin-bottom: 20px; font-weight: 500; display: none;
        }

        /* SLIDE VIEWPORT — chìa khóa quan trọng */
        .slide-viewport {
            overflow: hidden;  /* cắt các slide ngoài vùng nhìn */
            width: 100%;
        }
        .slide-track {
            display: flex;
            /* Mỗi slide = 100% viewport width, track = 3 × viewport */
            transition: transform .55s cubic-bezier(.77, 0, .18, 1);
        }
        .slide-panel {
            /* Mỗi slide chiếm đúng 100% viewport */
            min-width: 100%;
            width: 100%;
            flex-shrink: 0;
        }

        /* NỘI DUNG SLIDE */
        .back-link {
            display: inline-flex; align-items: center; gap: 6px;
            font-size: .85rem; font-weight: 600; color: var(--muted);
            text-decoration: none; margin-bottom: 28px; transition: color .2s;
            cursor: pointer; background: none; border: none; padding: 0;
            font-family: 'Be Vietnam Pro', sans-serif;
        }
        .back-link:hover { color: var(--gold); }

        .form-icon {
            width: 56px; height: 56px; border-radius: 14px;
            background: linear-gradient(135deg, rgba(201,147,58,.15), rgba(232,185,106,.15));
            border: 1px solid rgba(201,147,58,.3);
            display: grid; place-items: center; font-size: 1.8rem; margin-bottom: 20px;
        }
        .form-title {
            font-family: 'Playfair Display', serif;
            font-size: 1.9rem; font-weight: 900; color: var(--navy); margin-bottom: 8px;
        }
        .form-sub { color: var(--muted); font-size: .9rem; line-height: 1.65; margin-bottom: 28px; }

        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; margin-bottom: 7px; font-weight: 600; font-size: .85rem; color: var(--ink); }
        .form-group input {
            width: 100%; padding: 13px 16px;
            border: 1.5px solid #dde3ea; border-radius: 8px;
            font-family: 'Be Vietnam Pro', sans-serif; font-size: .95rem;
            color: var(--navy); background: var(--white);
            transition: border-color .2s, box-shadow .2s; outline: none;
        }
        .form-group input:focus { border-color: var(--gold); box-shadow: 0 0 0 3px rgba(201,147,58,.12); }
        .form-group input::placeholder { color: #b0bac5; }

        .pw-wrap { position: relative; }
        .pw-wrap input { padding-right: 44px; }
        .pw-eye {
            position: absolute; right: 12px; top: 50%; transform: translateY(-50%);
            background: none; border: none; cursor: pointer;
            color: #b0bac5; font-size: 16px; padding: 0; transition: color .15s;
        }
        .pw-eye:hover { color: var(--ink); }

        .btn-submit {
            width: 100%; padding: 14px;
            background: linear-gradient(135deg, var(--gold), var(--gold2));
            color: var(--navy); border: none; border-radius: 8px;
            font-family: 'Be Vietnam Pro', sans-serif;
            font-size: 1rem; font-weight: 700; cursor: pointer;
            transition: all .25s;
            display: flex; align-items: center; justify-content: center; gap: 8px;
        }
        .btn-submit:hover { opacity: .88; transform: translateY(-2px); box-shadow: 0 8px 24px rgba(201,147,58,.35); }
        .btn-submit:disabled { opacity: .6; cursor: not-allowed; transform: none; box-shadow: none; }

        .tag-verified {
            display: none; align-items: center; gap: 6px;
            background: #f0fff8; border: 1px solid #6ee7b7; color: #065f46;
            border-radius: 20px; padding: 6px 14px;
            font-size: .85rem; font-weight: 600; margin-bottom: 20px;
        }

        .spinner {
            width: 16px; height: 16px;
            border: 2px solid rgba(13,27,42,.3); border-top-color: var(--navy);
            border-radius: 50%; animation: spin .7s linear infinite; display: none;
        }
        @keyframes spin { to { transform: rotate(360deg); } }

        @media (max-width: 768px) {
            .page-body { grid-template-columns: 1fr; }
            .left-panel { display: none; }
            .right-panel { padding: 40px 24px; }
            .navbar { padding: 0 20px; }
        }
    </style>
</head>
<body>

<nav class="navbar">
    <a href="${pageContext.request.contextPath}/" class="nav-logo">
        <div class="emblem">H</div>
        Quản lý Hộ dân
    </a>
    <div class="nav-actions">
        <a href="${pageContext.request.contextPath}/login"    class="btn btn-ghost">Đăng nhập</a>
        <a href="${pageContext.request.contextPath}/register" class="btn btn-gold-nav">Đăng ký</a>
    </div>
</nav>

<div class="page-body">

    <div class="left-panel">
        <div class="left-content">
            <div class="left-tag">Hệ thống quản lý cư dân</div>
            <h1>Khôi phục<br>tài khoản <span>của bạn</span></h1>
            <p class="left-desc">Xác minh danh tính qua 3 bước đơn giản để đặt lại mật khẩu một cách an toàn.</p>
            <div class="feature-list">
                <div class="feature-item"><div class="feature-dot">📧</div> Xác minh Gmail tài khoản</div>
                <div class="feature-item"><div class="feature-dot">🪪</div> Xác thực CCCD và số điện thoại</div>
                <div class="feature-item"><div class="feature-dot">🔐</div> Đặt mật khẩu mới an toàn</div>
            </div>
        </div>
    </div>

    <div class="right-panel">
        <div class="form-wrapper">

            <!-- STEP INDICATOR -->
            <div class="steps">
                <div class="step-item active" id="step1"><div class="step-circle">1</div>Gmail</div>
                <div class="step-line" id="line1"></div>
                <div class="step-item" id="step2"><div class="step-circle">2</div>Xác minh</div>
                <div class="step-line" id="line2"></div>
                <div class="step-item" id="step3"><div class="step-circle">3</div>Mật khẩu</div>
            </div>

            <!-- MESSAGES -->
            <div class="alert-error"   id="msgError"></div>
            <div class="alert-success" id="msgSuccess"></div>

            <!-- SLIDE VIEWPORT -->
            <div class="slide-viewport">
                <div class="slide-track" id="slideTrack">

                    <!-- SLIDE 1: GMAIL -->
                    <div class="slide-panel">
                        <a href="${pageContext.request.contextPath}/login" class="back-link">← Quay lại đăng nhập</a>
                        <div class="form-icon">📧</div>
                        <h2 class="form-title">Nhập Gmail</h2>
                        <p class="form-sub">Nhập địa chỉ Gmail đã đăng ký tài khoản để tiếp tục.</p>
                        <div class="form-group">
                            <label for="email">Địa chỉ Gmail <span style="color:#dc2626">*</span></label>
                            <input type="email" id="email" placeholder="example@gmail.com" autocomplete="off">
                        </div>
                        <button class="btn-submit" id="btnEmail" onclick="kiemTraEmail()">
                            <span id="btnEmailText">Kiểm tra tài khoản →</span>
                            <div class="spinner" id="spinnerEmail"></div>
                        </button>
                    </div>

                    <!-- SLIDE 2: CCCD + SĐT -->
                    <div class="slide-panel">
                        <button class="back-link" onclick="goToSlide(0)">← Quay lại</button>
                        <div class="tag-verified" id="tagVerified"></div>
                        <div class="form-icon">🪪</div>
                        <h2 class="form-title">Xác minh danh tính</h2>
                        <p class="form-sub">Nhập CCCD và số điện thoại để xác nhận đây là tài khoản của bạn.</p>
                        <div class="form-group">
                            <label for="cccd">Số CCCD <span style="color:#dc2626">*</span></label>
                            <input type="text" id="cccd" placeholder="12 chữ số" maxlength="12" autocomplete="off">
                        </div>
                        <div class="form-group">
                            <label for="sdt">Số điện thoại <span style="color:#dc2626">*</span></label>
                            <input type="text" id="sdt" placeholder="0xxxxxxxxx" maxlength="15" autocomplete="off">
                        </div>
                        <button class="btn-submit" id="btnXacMinh" onclick="xacMinhCCCDvaSDT()">
                            <span id="btnXacMinhText">Xác minh →</span>
                            <div class="spinner" id="spinnerXacMinh"></div>
                        </button>
                    </div>

                    <!-- SLIDE 3: MẬT KHẨU -->
                    <div class="slide-panel">
                        <div class="form-icon">🔐</div>
                        <h2 class="form-title">Mật khẩu mới</h2>
                        <p class="form-sub">Nhập mật khẩu mới cho tài khoản của bạn.</p>
                        <div class="form-group">
                            <label for="mkMoi">Mật khẩu mới <span style="color:#dc2626">*</span></label>
                            <div class="pw-wrap">
                                <input type="password" id="mkMoi" placeholder="Tối thiểu 6 ký tự">
                                <button type="button" class="pw-eye" onclick="togglePw('mkMoi',this)">👁</button>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="mkXacNhan">Xác nhận mật khẩu <span style="color:#dc2626">*</span></label>
                            <div class="pw-wrap">
                                <input type="password" id="mkXacNhan" placeholder="Nhập lại mật khẩu mới">
                                <button type="button" class="pw-eye" onclick="togglePw('mkXacNhan',this)">👁</button>
                            </div>
                        </div>
                        <button class="btn-submit" id="btnDoiMK" onclick="doiMatKhau()">
                            <span id="btnDoiMKText">Đặt lại mật khẩu ✓</span>
                            <div class="spinner" id="spinnerDoiMK"></div>
                        </button>
                    </div>

                </div>
            </div>
            <!-- /SLIDE VIEWPORT -->

        </div>
    </div>
</div>

<script>
    let resetToken   = null;
    let currentSlide = 0;

    // Tính toán translateX dựa trên width thực tế của viewport
    function goToSlide(index) {
        currentSlide = index;
        const viewport = document.querySelector('.slide-viewport');
        const w = viewport.offsetWidth;
        document.getElementById('slideTrack').style.transform = 'translateX(-' + (index * w) + 'px)';
        clearMsg();
        updateSteps(index + 1);
        setTimeout(() => {
            const panels = document.querySelectorAll('.slide-panel');
            const inputs = panels[index].querySelectorAll('input:not([disabled])');
            if (inputs.length) inputs[0].focus();
        }, 560);
    }

    // Re-calculate on resize
    window.addEventListener('resize', () => {
        const viewport = document.querySelector('.slide-viewport');
        const w = viewport.offsetWidth;
        document.getElementById('slideTrack').style.transition = 'none';
        document.getElementById('slideTrack').style.transform  = 'translateX(-' + (currentSlide * w) + 'px)';
        setTimeout(() => {
            document.getElementById('slideTrack').style.transition = 'transform .55s cubic-bezier(.77,0,.18,1)';
        }, 50);
    });

    function updateSteps(active) {
        for (let i = 1; i <= 3; i++) {
            const el = document.getElementById('step' + i);
            el.className = 'step-item' + (i < active ? ' done' : i === active ? ' active' : '');
            el.querySelector('.step-circle').innerText = i < active ? '✓' : String(i);
        }
        document.getElementById('line1').className = 'step-line' + (active > 1 ? ' done' : '');
        document.getElementById('line2').className = 'step-line' + (active > 2 ? ' done' : '');
    }

    function showError(msg) {
        const e = document.getElementById('msgError');
        e.innerText = '⚠️ ' + msg; e.style.display = 'block';
        document.getElementById('msgSuccess').style.display = 'none';
    }
    function showSuccess(msg) {
        const s = document.getElementById('msgSuccess');
        s.innerText = '✅ ' + msg; s.style.display = 'block';
        document.getElementById('msgError').style.display = 'none';
    }
    function clearMsg() {
        document.getElementById('msgError').style.display   = 'none';
        document.getElementById('msgSuccess').style.display = 'none';
    }
    function setLoading(btnId, textId, spinnerId, loading) {
        document.getElementById(btnId).disabled          = loading;
        document.getElementById(textId).style.display    = loading ? 'none'  : 'inline';
        document.getElementById(spinnerId).style.display = loading ? 'block' : 'none';
    }

    function kiemTraEmail() {
        clearMsg();
        const email = document.getElementById('email').value.trim();
        if (!email) { showError('Vui lòng nhập Gmail tài khoản.'); return; }

        setLoading('btnEmail', 'btnEmailText', 'spinnerEmail', true);

        fetch('${pageContext.request.contextPath}/quen-mat-khau?action=kiemTraEmail', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'email=' + encodeURIComponent(email)
        })
        .then(r => r.json())
        .then(data => {
            setLoading('btnEmail', 'btnEmailText', 'spinnerEmail', false);
            if (data.success) {
                const tag = document.getElementById('tagVerified');
                tag.innerHTML = '✓ ' + email;
                tag.style.display = 'inline-flex';
                goToSlide(1);
            } else {
                showError(data.message);
            }
        })
        .catch(() => {
            setLoading('btnEmail', 'btnEmailText', 'spinnerEmail', false);
            showError('Có lỗi xảy ra, vui lòng thử lại.');
        });
    }

    function xacMinhCCCDvaSDT() {
        clearMsg();
        const email = document.getElementById('email').value.trim();
        const cccd  = document.getElementById('cccd').value.trim();
        const sdt   = document.getElementById('sdt').value.trim();

        if (!cccd || !sdt)      { showError('Vui lòng nhập đầy đủ CCCD và số điện thoại.'); return; }
        if (cccd.length !== 12) { showError('CCCD phải đúng 12 chữ số.'); return; }

        setLoading('btnXacMinh', 'btnXacMinhText', 'spinnerXacMinh', true);

        fetch('${pageContext.request.contextPath}/quen-mat-khau?action=xacMinh', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'email=' + encodeURIComponent(email)
                + '&cccd=' + encodeURIComponent(cccd)
                + '&sdt='  + encodeURIComponent(sdt)
        })
        .then(r => r.json())
        .then(data => {
            setLoading('btnXacMinh', 'btnXacMinhText', 'spinnerXacMinh', false);
            if (data.success) {
                resetToken = data.token;
                goToSlide(2);
            } else {
                showError(data.message);
            }
        })
        .catch(() => {
            setLoading('btnXacMinh', 'btnXacMinhText', 'spinnerXacMinh', false);
            showError('Có lỗi xảy ra, vui lòng thử lại.');
        });
    }

    function doiMatKhau() {
        clearMsg();
        const mkMoi     = document.getElementById('mkMoi').value;
        const mkXacNhan = document.getElementById('mkXacNhan').value;

        if (!mkMoi || !mkXacNhan) { showError('Vui lòng nhập đầy đủ mật khẩu mới.'); return; }
        if (mkMoi.length < 6)     { showError('Mật khẩu phải có ít nhất 6 ký tự.'); return; }
        if (mkMoi !== mkXacNhan)  { showError('Mật khẩu xác nhận không khớp.'); return; }
        if (!resetToken)          { showError('Phiên xác minh không hợp lệ, vui lòng thử lại.'); return; }

        setLoading('btnDoiMK', 'btnDoiMKText', 'spinnerDoiMK', true);

        fetch('${pageContext.request.contextPath}/quen-mat-khau?action=doiMatKhau', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'token='           + encodeURIComponent(resetToken)
                + '&matKhauMoi='     + encodeURIComponent(mkMoi)
                + '&xacNhanMatKhau=' + encodeURIComponent(mkXacNhan)
        })
        .then(r => r.json())
        .then(data => {
            if (data.success) {
                showSuccess('Đổi mật khẩu thành công! Đang chuyển về trang đăng nhập...');
                setTimeout(() => {
                    window.location.href = '${pageContext.request.contextPath}/login?success=doiMatKhauThanhCong';
                }, 1500);
            } else {
                setLoading('btnDoiMK', 'btnDoiMKText', 'spinnerDoiMK', false);
                showError(data.message);
            }
        })
        .catch(() => {
            setLoading('btnDoiMK', 'btnDoiMKText', 'spinnerDoiMK', false);
            showError('Có lỗi xảy ra, vui lòng thử lại.');
        });
    }

    function togglePw(id, btn) {
        const inp = document.getElementById(id);
        inp.type = inp.type === 'password' ? 'text' : 'password';
        btn.textContent = inp.type === 'password' ? '👁' : '🙈';
    }

    document.addEventListener('keydown', function(e) {
        if (e.key !== 'Enter') return;
        if (currentSlide === 0) { kiemTraEmail();     return; }
        if (currentSlide === 1) { xacMinhCCCDvaSDT(); return; }
        if (currentSlide === 2) { doiMatKhau();       return; }
    });
</script>
</body>
</html>