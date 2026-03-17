<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký – Quản lý Hộ dân</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;900&family=Be+Vietnam+Pro:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        :root {
            --navy:  #0D1B2A; --ink: #1A2F45;
            --gold:  #C9933A; --gold2: #E8B96A;
            --cream: #F7F3EC; --muted: #6B7F93; --white: #FFFFFF;
        }
        body { font-family: 'Be Vietnam Pro', sans-serif; min-height: 100vh; background: var(--navy); display: flex; flex-direction: column; }

        .navbar {
            position: fixed; top: 0; left: 0; right: 0; z-index: 999;
            display: flex; align-items: center; justify-content: space-between;
            padding: 0 48px; height: 70px;
            background: rgba(13,27,42,.95); backdrop-filter: blur(14px);
            border-bottom: 1px solid rgba(201,147,58,.2);
        }
        .nav-logo { display: flex; align-items: center; gap: 12px; font-family: 'Playfair Display', serif; font-size: 1.2rem; color: var(--white); text-decoration: none; }
        .nav-logo .emblem { width: 36px; height: 36px; border-radius: 50%; background: linear-gradient(135deg, var(--gold), var(--gold2)); display: grid; place-items: center; font-weight: 900; color: var(--navy); font-size: 1rem; }
        .nav-actions { display: flex; gap: 10px; }
        .btn { display: inline-flex; align-items: center; padding: 8px 20px; border-radius: 6px; font-family: 'Be Vietnam Pro', sans-serif; font-weight: 600; font-size: .86rem; text-decoration: none; transition: all .25s; }
        .btn-ghost { border: 1.5px solid rgba(255,255,255,.3); color: var(--white); }
        .btn-ghost:hover { border-color: var(--gold); color: var(--gold); }
        .btn-gold { background: linear-gradient(135deg, var(--gold), var(--gold2)); color: var(--navy); border: none; }
        .btn-gold:hover { opacity: .88; transform: translateY(-1px); }

        .page-body { flex: 1; display: grid; grid-template-columns: 1fr 1.6fr; min-height: 100vh; padding-top: 70px; }

        .left-panel { background: var(--navy); display: flex; flex-direction: column; justify-content: center; align-items: flex-start; padding: 80px 56px; position: relative; overflow: hidden; }
        .left-panel::before { content: ''; position: absolute; inset: 0; background: radial-gradient(ellipse 70% 60% at 20% 60%, rgba(201,147,58,.1) 0%, transparent 65%), linear-gradient(rgba(201,147,58,.04) 1px, transparent 1px), linear-gradient(90deg, rgba(201,147,58,.04) 1px, transparent 1px); background-size: auto, 50px 50px, 50px 50px; }
        .left-content { position: relative; z-index: 1; }
        .left-tag { font-size: .75rem; font-weight: 700; letter-spacing: 2.5px; text-transform: uppercase; color: var(--gold); margin-bottom: 20px; display: flex; align-items: center; gap: 8px; }
        .left-tag::before { content: ''; display: block; width: 24px; height: 2px; background: var(--gold); }
        .left-panel h1 { font-family: 'Playfair Display', serif; font-size: clamp(1.8rem, 3vw, 2.8rem); color: var(--white); font-weight: 900; line-height: 1.2; margin-bottom: 18px; }
        .left-panel h1 span { color: var(--gold); }
        .left-panel p { color: rgba(255,255,255,.5); font-size: .9rem; line-height: 1.75; max-width: 360px; margin-bottom: 36px; }
        .step-list { display: flex; flex-direction: column; gap: 16px; }
        .step-item { display: flex; align-items: flex-start; gap: 14px; }
        .step-num { width: 28px; height: 28px; border-radius: 50%; flex-shrink: 0; background: linear-gradient(135deg, var(--gold), var(--gold2)); display: grid; place-items: center; font-size: .75rem; font-weight: 800; color: var(--navy); }
        .step-text { color: rgba(255,255,255,.6); font-size: .87rem; line-height: 1.55; padding-top: 4px; }
        .step-text strong { color: rgba(255,255,255,.85); display: block; font-weight: 600; }

        .right-panel { background: var(--cream); display: flex; align-items: center; justify-content: center; padding: 50px 56px; }
        .register-box { width: 100%; max-width: 560px; animation: fadeUp .7s ease both; }
        .register-box-header { margin-bottom: 28px; }
        .register-box-header h2 { font-family: 'Playfair Display', serif; font-size: 1.9rem; font-weight: 900; color: var(--navy); margin-bottom: 8px; }
        .register-box-header p { color: var(--muted); font-size: .9rem; }

        .field-section { font-size: .72rem; font-weight: 700; letter-spacing: 2px; text-transform: uppercase; color: var(--gold); margin: 24px 0 14px; display: flex; align-items: center; gap: 10px; }
        .field-section::after { content: ''; flex: 1; height: 1px; background: linear-gradient(90deg, rgba(201,147,58,.3), transparent); }

        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 14px; }
        .form-group { display: flex; flex-direction: column; }
        .form-group.full { grid-column: 1 / -1; }
        .form-group label { font-weight: 600; font-size: .82rem; color: var(--ink); margin-bottom: 6px; letter-spacing: .3px; }
        .form-group label .req { color: var(--gold); margin-left: 2px; }
        .form-group input { padding: 12px 14px; border: 1.5px solid #dde3ea; border-radius: 8px; font-family: 'Be Vietnam Pro', sans-serif; font-size: .92rem; color: var(--navy); background: var(--white); transition: border-color .2s, box-shadow .2s; outline: none; }
        .form-group input:focus { border-color: var(--gold); box-shadow: 0 0 0 3px rgba(201,147,58,.12); }
        .form-group input::placeholder { color: #b5bfc9; }
        .form-group input.is-error { border-color: #e74c3c; background: #fff8f8; }
        .field-error { font-size: .78rem; color: #dc2626; margin-top: 5px; display: flex; align-items: center; gap: 4px; }
        .field-error::before { content: '⚠'; font-size: .75rem; }
        .pw-wrap { position: relative; }
        .pw-wrap input { padding-right: 44px; }
        .pw-eye { position: absolute; right: 12px; top: 50%; transform: translateY(-50%); background: none; border: none; cursor: pointer; color: #b0bac5; font-size: 16px; padding: 0; transition: color .15s; }
        .pw-eye:hover { color: var(--ink); }
        .error-msg { background: #fff0f0; border: 1px solid #fca5a5; color: #dc2626; border-radius: 8px; padding: 12px 16px; font-size: .88rem; margin-bottom: 20px; font-weight: 500; line-height: 1.6; }
        .hint-text { font-size: .78rem; color: var(--muted); margin-top: 5px; }
        .btn-submit { width: 100%; padding: 14px; background: linear-gradient(135deg, var(--gold), var(--gold2)); color: var(--navy); border: none; border-radius: 8px; font-family: 'Be Vietnam Pro', sans-serif; font-size: 1rem; font-weight: 700; cursor: pointer; transition: all .25s; margin-top: 24px; }
        .btn-submit:hover { opacity: .88; transform: translateY(-2px); box-shadow: 0 8px 24px rgba(201,147,58,.35); }
        .register-footer { text-align: center; margin-top: 24px; font-size: .88rem; color: var(--muted); }
        .register-footer a { color: var(--gold); font-weight: 600; text-decoration: none; }
        .register-footer a:hover { text-decoration: underline; }

        /* ── SUCCESS OVERLAY ── */
        .success-overlay {
            position: fixed; inset: 0; z-index: 9999;
            background: rgba(13,27,42,.85); backdrop-filter: blur(8px);
            display: flex; align-items: center; justify-content: center;
            animation: fadeIn .3s ease;
        }
        .success-card {
            background: var(--cream); border-radius: 24px;
            padding: 52px 44px; max-width: 420px; width: 90%;
            text-align: center;
            box-shadow: 0 40px 100px rgba(0,0,0,.45);
            animation: popUp .45s cubic-bezier(.34,1.56,.64,1) both;
        }
        .success-icon-wrap {
            width: 80px; height: 80px; border-radius: 50%;
            margin: 0 auto 24px;
            background: linear-gradient(135deg, var(--gold), var(--gold2));
            display: grid; place-items: center;
            font-size: 2.2rem; color: var(--navy);
            box-shadow: 0 12px 32px rgba(201,147,58,.4);
        }
        .success-card h3 {
            font-family: 'Playfair Display', serif;
            font-size: 1.75rem; font-weight: 900;
            color: var(--navy); margin-bottom: 12px;
        }
        .success-card .welcome-text {
            color: var(--muted); font-size: .92rem;
            line-height: 1.7; margin-bottom: 6px;
        }
        .success-card .name {
            color: var(--gold); font-weight: 700; font-size: 1rem;
        }
        .success-card .sub-text {
            color: var(--muted); font-size: .84rem;
            margin-bottom: 0;
        }
        .countdown-wrap {
            margin: 22px 0 10px;
        }
        .countdown-bar-bg {
            background: #e4ddd3; border-radius: 99px;
            height: 6px; overflow: hidden; margin-bottom: 10px;
        }
        .countdown-bar {
            height: 100%;
            background: linear-gradient(90deg, var(--gold), var(--gold2));
            border-radius: 99px;
            animation: shrink 3s linear forwards;
        }
        .countdown-label {
            font-size: .8rem; color: var(--muted);
        }
        .countdown-label span { color: var(--gold); font-weight: 700; }
        .btn-go-login {
            display: flex; align-items: center; justify-content: center;
            width: 100%; padding: 14px; margin-top: 16px;
            background: linear-gradient(135deg, var(--gold), var(--gold2));
            color: var(--navy); border: none; border-radius: 10px;
            font-family: 'Be Vietnam Pro', sans-serif;
            font-size: .95rem; font-weight: 700;
            cursor: pointer; text-decoration: none;
            transition: opacity .2s, transform .2s;
        }
        .btn-go-login:hover { opacity: .88; transform: translateY(-1px); }

        @keyframes fadeUp { from { opacity: 0; transform: translateY(24px); } to { opacity: 1; transform: translateY(0); } }
        @keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }
        @keyframes popUp { from { opacity: 0; transform: scale(.8) translateY(24px); } to { opacity: 1; transform: scale(1) translateY(0); } }
        @keyframes shrink { from { width: 100%; } to { width: 0%; } }

        @media (max-width: 900px) { .page-body { grid-template-columns: 1fr; } .left-panel { display: none; } .right-panel { padding: 40px 24px; } .navbar { padding: 0 20px; } }
        @media (max-width: 480px) { .form-grid { grid-template-columns: 1fr; } .form-group.full { grid-column: 1; } .success-card { padding: 40px 28px; } }
    </style>
</head>
<body>

<%-- ── SUCCESS OVERLAY (chỉ hiện khi đăng ký thành công) ── --%>
<c:if test="${dangKyThanhCong}">
<div class="success-overlay" id="successOverlay">
    <div class="success-card">
        <div class="success-icon-wrap">✓</div>
        <h3>Đăng ký thành công!</h3>
        <p class="welcome-text">
            Chào mừng <span class="name">${tenNguoiDung}</span><br>
            đã tham gia hệ thống quản lý hộ dân.
        </p>
        <p class="sub-text">Tài khoản của bạn đã được kích hoạt.</p>
        <div class="countdown-wrap">
            <div class="countdown-bar-bg">
                <div class="countdown-bar"></div>
            </div>
            <p class="countdown-label">
                Tự động chuyển sang đăng nhập sau <span id="cdNum">3</span> giây...
            </p>
        </div>
        <a href="${pageContext.request.contextPath}/login" class="btn-go-login">
            Đăng nhập ngay →
        </a>
    </div>
</div>
<script>
    let s = 3;
    const el = document.getElementById('cdNum');
    const iv = setInterval(() => {
        s--;
        if (el) el.textContent = s;
        if (s <= 0) {
            clearInterval(iv);
            window.location.href = '${pageContext.request.contextPath}/login';
        }
    }, 1000);
</script>
</c:if>

<nav class="navbar">
    <a href="${pageContext.request.contextPath}/" class="nav-logo">
        <div class="emblem">H</div>
        Quản lý Hộ dân
    </a>
    <div class="nav-actions">
        <a href="${pageContext.request.contextPath}/login" class="btn btn-ghost">Đăng nhập</a>
        <a href="${pageContext.request.contextPath}/register" class="btn btn-gold">Đăng ký</a>
    </div>
</nav>

<div class="page-body">

    <div class="left-panel">
        <div class="left-content">
            <div class="left-tag">Tạo tài khoản mới</div>
            <h1>Tham gia<br><span>cộng đồng</span><br>hôm nay</h1>
            <p>Chỉ mất vài phút để đăng ký và bắt đầu trải nghiệm hệ thống quản lý hộ dân hiện đại.</p>
            <div class="step-list">
                <div class="step-item">
                    <div class="step-num">1</div>
                    <div class="step-text"><strong>Tài khoản đăng nhập</strong>Gmail và mật khẩu để đăng nhập</div>
                </div>
                <div class="step-item">
                    <div class="step-num">2</div>
                    <div class="step-text"><strong>Xác minh danh tính</strong>CCCD, họ tên, ngày sinh và số điện thoại</div>
                </div>
                <div class="step-item">
                    <div class="step-num">3</div>
                    <div class="step-text"><strong>Hoàn tất</strong>Hệ thống tự điền thông tin từ dữ liệu phường</div>
                </div>
            </div>
        </div>
    </div>

    <div class="right-panel">
        <div class="register-box">
            <div class="register-box-header">
                <h2>Tạo tài khoản</h2>
                <p>Thông tin phải khớp với dữ liệu đã được phường đăng ký</p>
            </div>

            <c:if test="${not empty error}">
                <div class="error-msg">⚠️ ${error}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/register" method="post" novalidate>

                <div class="field-section">Tài khoản đăng nhập</div>
                <div class="form-grid">

                    <div class="form-group full">
                        <label for="email">Gmail <span class="req">*</span></label>
                        <input type="email" id="email" name="email"
                               placeholder="example@gmail.com"
                               value="${not empty oldEmail ? oldEmail : ''}"
                               class="${not empty errEmail ? 'is-error' : ''}" required>
                        <c:if test="${not empty errEmail}">
                            <span class="field-error">${errEmail}</span>
                        </c:if>
                    </div>

                    <div class="form-group">
                        <label for="matKhau">Mật khẩu <span class="req">*</span></label>
                        <div class="pw-wrap">
                            <input type="password" id="matKhau" name="matKhau"
                                   placeholder="Tối thiểu 6 ký tự"
                                   class="${not empty errMatKhau ? 'is-error' : ''}" required>
                            <button type="button" class="pw-eye" onclick="togglePw('matKhau',this)">👁</button>
                        </div>
                        <c:if test="${not empty errMatKhau}">
                            <span class="field-error">${errMatKhau}</span>
                        </c:if>
                    </div>

                    <div class="form-group">
                        <label for="xacNhanMatKhau">Xác nhận mật khẩu <span class="req">*</span></label>
                        <div class="pw-wrap">
                            <input type="password" id="xacNhanMatKhau" name="xacNhanMatKhau"
                                   placeholder="Nhập lại mật khẩu"
                                   class="${not empty errXacNhan ? 'is-error' : ''}" required>
                            <button type="button" class="pw-eye" onclick="togglePw('xacNhanMatKhau',this)">👁</button>
                        </div>
                        <c:if test="${not empty errXacNhan}">
                            <span class="field-error">${errXacNhan}</span>
                        </c:if>
                    </div>

                </div>

                <div class="field-section">Xác minh danh tính</div>
                <p class="hint-text" style="margin-bottom:14px;">
                    Nhập đúng thông tin đã được cán bộ phường đăng ký vào hệ thống.
                </p>
                <div class="form-grid">

                    <div class="form-group full">
                        <label for="cccd">Số CCCD <span class="req">*</span></label>
                        <input type="text" id="cccd" name="cccd"
                               placeholder="12 chữ số" maxlength="12"
                               value="${not empty oldCccd ? oldCccd : ''}"
                               class="${not empty errCccd ? 'is-error' : ''}" required>
                        <c:if test="${not empty errCccd}">
                            <span class="field-error">${errCccd}</span>
                        </c:if>
                        <c:if test="${empty errCccd}">
                            <span class="hint-text">CCCD sẽ được dùng làm khóa xác minh các thông tin bên dưới</span>
                        </c:if>
                    </div>

                    <div class="form-group">
                        <label for="ho">Họ <span class="req">*</span></label>
                        <input type="text" id="ho" name="ho"
                               placeholder="Nguyễn"
                               value="${not empty oldHo ? oldHo : ''}"
                               class="${not empty errHo ? 'is-error' : ''}" required>
                        <c:if test="${not empty errHo}">
                            <span class="field-error">${errHo}</span>
                        </c:if>
                    </div>

                    <div class="form-group">
                        <label for="ten">Tên <span class="req">*</span></label>
                        <input type="text" id="ten" name="ten"
                               placeholder="Văn A"
                               value="${not empty oldTen ? oldTen : ''}"
                               class="${not empty errTen ? 'is-error' : ''}" required>
                        <c:if test="${not empty errTen}">
                            <span class="field-error">${errTen}</span>
                        </c:if>
                    </div>

                    <div class="form-group">
                        <label for="ngaySinh">Ngày sinh <span class="req">*</span></label>
                        <input type="date" id="ngaySinh" name="ngaySinh"
                               value="${not empty oldNgaySinh ? oldNgaySinh : ''}"
                               class="${not empty errNgaySinh ? 'is-error' : ''}" required>
                        <c:if test="${not empty errNgaySinh}">
                            <span class="field-error">${errNgaySinh}</span>
                        </c:if>
                    </div>

                    <div class="form-group">
                        <label for="soDienThoai">Số điện thoại <span class="req">*</span></label>
                        <input type="text" id="soDienThoai" name="soDienThoai"
                               placeholder="0xxxxxxxxx" maxlength="11"
                               value="${not empty oldSdt ? oldSdt : ''}"
                               class="${not empty errSdt ? 'is-error' : ''}" required>
                        <c:if test="${not empty errSdt}">
                            <span class="field-error">${errSdt}</span>
                        </c:if>
                    </div>

                </div>

                <button type="submit" class="btn-submit">Tạo tài khoản</button>
            </form>

            <div class="register-footer">
                Đã có tài khoản?
                <a href="${pageContext.request.contextPath}/login">Đăng nhập ngay</a>
            </div>
        </div>
    </div>
</div>

<script>
    function togglePw(id, btn) {
        const inp = document.getElementById(id);
        inp.type = inp.type === 'password' ? 'text' : 'password';
        btn.textContent = inp.type === 'password' ? '👁' : '🙈';
    }
</script>
</body>
</html>