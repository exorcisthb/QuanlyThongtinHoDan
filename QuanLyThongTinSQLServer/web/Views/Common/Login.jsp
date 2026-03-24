<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đăng nhập – Quản lý Hộ dân</title>
        <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;900&family=Be+Vietnam+Pro:wght@300;400;500;600&display=swap" rel="stylesheet">
        <style>
            *, *::before, *::after {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }

            :root {
                --navy:  #0D1B2A;
                --ink:   #1A2F45;
                --gold:  #C9933A;
                --gold2: #E8B96A;
                --cream: #F7F3EC;
                --muted: #6B7F93;
                --white: #FFFFFF;
            }

            body {
                font-family: 'Be Vietnam Pro', sans-serif;
                min-height: 100vh;
                background: var(--navy);
                display: flex;
                flex-direction: column;
            }

            /* ── NAVBAR ── */
            .navbar {
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                z-index: 999;
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 0 48px;
                height: 70px;
                background: rgba(13,27,42,.95);
                backdrop-filter: blur(14px);
                border-bottom: 1px solid rgba(201,147,58,.2);
            }
            .nav-logo {
                display: flex;
                align-items: center;
                gap: 12px;
                font-family: 'Playfair Display', serif;
                font-size: 1.2rem;
                color: var(--white);
                text-decoration: none;
            }
            .nav-logo .emblem {
                width: 36px;
                height: 36px;
                border-radius: 50%;
                background: linear-gradient(135deg, var(--gold), var(--gold2));
                display: grid;
                place-items: center;
                font-weight: 900;
                color: var(--navy);
                font-size: 1rem;
            }
            .nav-actions {
                display: flex;
                gap: 10px;
            }
            .btn {
                display: inline-flex;
                align-items: center;
                padding: 8px 20px;
                border-radius: 6px;
                font-family: 'Be Vietnam Pro', sans-serif;
                font-weight: 600;
                font-size: .86rem;
                text-decoration: none;
                transition: all .25s;
            }
            .btn-ghost {
                border: 1.5px solid rgba(255,255,255,.3);
                color: var(--white);
            }
            .btn-ghost:hover {
                border-color: var(--gold);
                color: var(--gold);
            }
            .btn-gold {
                background: linear-gradient(135deg, var(--gold), var(--gold2));
                color: var(--navy);
                border: none;
            }
            .btn-gold:hover {
                opacity: .88;
                transform: translateY(-1px);
            }

            /* ── LAYOUT ── */
            .page-body {
                flex: 1;
                display: grid;
                grid-template-columns: 1fr 1fr;
                min-height: 100vh;
                padding-top: 70px;
            }

            /* Left panel */
            .left-panel {
                background: var(--navy);
                display: flex;
                flex-direction: column;
                justify-content: center;
                align-items: flex-start;
                padding: 80px 60px;
                position: relative;
                overflow: hidden;
            }
            .left-panel::before {
                content: '';
                position: absolute;
                inset: 0;
                background:
                    radial-gradient(ellipse 70% 60% at 20% 60%, rgba(201,147,58,.1) 0%, transparent 65%),
                    linear-gradient(rgba(201,147,58,.04) 1px, transparent 1px),
                    linear-gradient(90deg, rgba(201,147,58,.04) 1px, transparent 1px);
                background-size: auto, 50px 50px, 50px 50px;
            }
            .left-content {
                position: relative;
                z-index: 1;
            }
            .left-tag {
                font-size: .75rem;
                font-weight: 700;
                letter-spacing: 2.5px;
                text-transform: uppercase;
                color: var(--gold);
                margin-bottom: 20px;
                display: flex;
                align-items: center;
                gap: 8px;
            }
            .left-tag::before {
                content: '';
                display: block;
                width: 24px;
                height: 2px;
                background: var(--gold);
            }
            .left-panel h1 {
                font-family: 'Playfair Display', serif;
                font-size: clamp(2rem, 3.5vw, 3rem);
                color: var(--white);
                font-weight: 900;
                line-height: 1.15;
                margin-bottom: 20px;
            }
            .left-panel h1 span {
                color: var(--gold);
            }
            .left-panel p {
                color: rgba(255,255,255,.55);
                font-size: .95rem;
                line-height: 1.75;
                max-width: 400px;
                margin-bottom: 40px;
            }
            .feature-list {
                display: flex;
                flex-direction: column;
                gap: 14px;
            }
            .feature-item {
                display: flex;
                align-items: center;
                gap: 12px;
                color: rgba(255,255,255,.65);
                font-size: .88rem;
            }
            .feature-dot {
                width: 28px;
                height: 28px;
                border-radius: 8px;
                flex-shrink: 0;
                background: rgba(201,147,58,.15);
                border: 1px solid rgba(201,147,58,.3);
                display: grid;
                place-items: center;
                font-size: .9rem;
            }

            /* Right panel */
            .right-panel {
                background: var(--cream);
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 60px 48px;
            }
            .login-box {
                width: 100%;
                max-width: 420px;
                animation: fadeUp .7s ease both;
            }
            .login-box-header {
                margin-bottom: 36px;
            }
            .login-box-header h2 {
                font-family: 'Playfair Display', serif;
                font-size: 1.9rem;
                font-weight: 900;
                color: var(--navy);
                margin-bottom: 8px;
            }
            .login-box-header p {
                color: var(--muted);
                font-size: .9rem;
            }

            /* Form */
            .form-group {
                margin-bottom: 20px;
            }
            .form-group label {
                display: block;
                margin-bottom: 7px;
                font-weight: 600;
                font-size: .85rem;
                color: var(--ink);
                letter-spacing: .3px;
            }
            .form-row {
                display: flex;
                align-items: center;
                justify-content: space-between;
                margin-bottom: 7px;
            }
            .form-row label {
                margin-bottom: 0;
            }
            .forgot-link {
                font-size: .8rem;
                font-weight: 600;
                color: var(--gold);
                text-decoration: none;
                transition: opacity .2s;
            }
            .forgot-link:hover {
                opacity: .75;
                text-decoration: underline;
            }

            .form-group input {
                width: 100%;
                padding: 13px 16px;
                border: 1.5px solid #dde3ea;
                border-radius: 8px;
                font-family: 'Be Vietnam Pro', sans-serif;
                font-size: .95rem;
                color: var(--navy);
                background: var(--white);
                transition: border-color .2s, box-shadow .2s;
                outline: none;
            }
            .form-group input:focus {
                border-color: var(--gold);
                box-shadow: 0 0 0 3px rgba(201,147,58,.12);
            }
            .form-group input::placeholder {
                color: #b0bac5;
            }

            /* ── Password wrap ── */
            .pw-wrap {
                position: relative;
            }
            .pw-wrap input {
                padding-right: 44px;
            }
            .pw-eye {
                position: absolute;
                right: 12px;
                top: 50%;
                transform: translateY(-50%);
                background: none;
                border: none;
                cursor: pointer;
                color: #b0bac5;
                font-size: 16px;
                padding: 0;
                transition: color .15s;
            }
            .pw-eye:hover {
                color: var(--ink);
            }

            .btn-submit {
                width: 100%;
                padding: 14px;
                background: linear-gradient(135deg, var(--gold), var(--gold2));
                color: var(--navy);
                border: none;
                border-radius: 8px;
                font-family: 'Be Vietnam Pro', sans-serif;
                font-size: 1rem;
                font-weight: 700;
                cursor: pointer;
                transition: all .25s;
                margin-top: 4px;
            }
            .btn-submit:hover {
                opacity: .88;
                transform: translateY(-2px);
                box-shadow: 0 8px 24px rgba(201,147,58,.35);
            }

            .divider {
                display: flex;
                align-items: center;
                gap: 12px;
                margin: 24px 0;
                color: var(--muted);
                font-size: .82rem;
            }
            .divider::before, .divider::after {
                content: '';
                flex: 1;
                height: 1px;
                background: #dde3ea;
            }

            .google-btn {
                width: 100%;
                padding: 13px;
                background: var(--white);
                border: 1.5px solid #dde3ea;
                border-radius: 8px;
                font-family: 'Be Vietnam Pro', sans-serif;
                font-size: .92rem;
                font-weight: 600;
                color: var(--ink);
                cursor: pointer;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 10px;
                text-decoration: none;
                transition: all .25s;
            }
            .google-btn:hover {
                border-color: #aab4bf;
                box-shadow: 0 4px 16px rgba(0,0,0,.08);
                transform: translateY(-1px);
            }
            .google-icon {
                width: 18px;
                height: 18px;
            }

            .error-msg {
                background: #fff0f0;
                border: 1px solid #fca5a5;
                color: #dc2626;
                border-radius: 8px;
                padding: 12px 16px;
                font-size: .88rem;
                margin-bottom: 20px;
                font-weight: 500;
            }
            .success-msg {
                background: #f0fff8;
                border: 1px solid #6ee7b7;
                color: #065f46;
                border-radius: 8px;
                padding: 12px 16px;
                font-size: .88rem;
                margin-bottom: 20px;
                font-weight: 500;
            }

            .login-footer {
                text-align: center;
                margin-top: 28px;
                font-size: .88rem;
                color: var(--muted);
            }
            .login-footer a {
                color: var(--gold);
                font-weight: 600;
                text-decoration: none;
            }
            .login-footer a:hover {
                text-decoration: underline;
            }

            /* ══════════════════════════════════
               MODAL QUÊN MẬT KHẨU
            ══════════════════════════════════ */
            .modal-overlay {
                position: fixed;
                inset: 0;
                z-index: 2000;
                background: rgba(13,27,42,.75);
                backdrop-filter: blur(6px);
                display: flex;
                align-items: center;
                justify-content: center;
                opacity: 0;
                pointer-events: none;
                transition: opacity .25s;
            }
            .modal-overlay.open {
                opacity: 1;
                pointer-events: all;
            }
            .modal {
                background: var(--cream);
                border-radius: 16px;
                padding: 40px 36px;
                width: 100%;
                max-width: 420px;
                position: relative;
                transform: translateY(20px);
                transition: transform .25s;
                box-shadow: 0 32px 80px rgba(0,0,0,.35);
            }
            .modal-overlay.open .modal {
                transform: translateY(0);
            }

            .modal-close {
                position: absolute;
                top: 16px;
                right: 16px;
                width: 32px;
                height: 32px;
                border-radius: 8px;
                background: none;
                border: 1.5px solid #dde3ea;
                font-size: 1rem;
                cursor: pointer;
                color: var(--muted);
                display: grid;
                place-items: center;
                transition: all .2s;
            }
            .modal-close:hover {
                border-color: var(--gold);
                color: var(--gold);
            }

            .modal-icon {
                width: 52px;
                height: 52px;
                border-radius: 14px;
                background: linear-gradient(135deg, rgba(201,147,58,.15), rgba(232,185,106,.15));
                border: 1px solid rgba(201,147,58,.3);
                display: grid;
                place-items: center;
                font-size: 1.6rem;
                margin-bottom: 20px;
            }
            .modal h3 {
                font-family: 'Playfair Display', serif;
                font-size: 1.5rem;
                font-weight: 900;
                color: var(--navy);
                margin-bottom: 8px;
            }
            .modal p {
                color: var(--muted);
                font-size: .88rem;
                line-height: 1.65;
                margin-bottom: 24px;
            }
            .modal .form-group {
                margin-bottom: 16px;
            }
            .modal .form-group label {
                display: block;
                margin-bottom: 7px;
                font-weight: 600;
                font-size: .85rem;
                color: var(--ink);
            }
            .modal .form-group input {
                width: 100%;
                padding: 13px 16px;
                border: 1.5px solid #dde3ea;
                border-radius: 8px;
                font-family: 'Be Vietnam Pro', sans-serif;
                font-size: .95rem;
                color: var(--navy);
                background: var(--white);
                transition: border-color .2s, box-shadow .2s;
                outline: none;
            }
            .modal .form-group input:focus {
                border-color: var(--gold);
                box-shadow: 0 0 0 3px rgba(201,147,58,.12);
            }
            .modal .form-group input::placeholder {
                color: #b0bac5;
            }
            .modal-hint {
                font-size: .8rem;
                color: var(--muted);
                margin-top: 6px;
                line-height: 1.5;
            }
            .modal-actions {
                display: flex;
                gap: 10px;
                margin-top: 24px;
            }
            .btn-modal-cancel {
                flex: 1;
                padding: 13px;
                background: var(--white);
                border: 1.5px solid #dde3ea;
                border-radius: 8px;
                font-family: 'Be Vietnam Pro', sans-serif;
                font-size: .92rem;
                font-weight: 600;
                color: var(--ink);
                cursor: pointer;
                transition: all .2s;
            }
            .btn-modal-cancel:hover {
                border-color: #aab4bf;
            }
            .btn-modal-submit {
                flex: 2;
                padding: 13px;
                background: linear-gradient(135deg, var(--gold), var(--gold2));
                color: var(--navy);
                border: none;
                border-radius: 8px;
                font-family: 'Be Vietnam Pro', sans-serif;
                font-size: .95rem;
                font-weight: 700;
                cursor: pointer;
                transition: all .25s;
            }
            .btn-modal-submit:hover {
                opacity: .88;
                transform: translateY(-1px);
                box-shadow: 0 6px 20px rgba(201,147,58,.3);
            }

            .modal-success {
                text-align: center;
                padding: 10px 0 6px;
            }
            .modal-success .success-icon {
                font-size: 3rem;
                margin-bottom: 14px;
                display: block;
                animation: popIn .4s ease;
            }
            .modal-success h4 {
                font-family: 'Playfair Display', serif;
                font-size: 1.3rem;
                color: var(--navy);
                margin-bottom: 8px;
            }
            .modal-success p {
                color: var(--muted);
                font-size: .88rem;
                line-height: 1.65;
                margin-bottom: 20px;
            }
            .btn-modal-done {
                width: 100%;
                padding: 13px;
                background: linear-gradient(135deg, var(--gold), var(--gold2));
                color: var(--navy);
                border: none;
                border-radius: 8px;
                font-family: 'Be Vietnam Pro', sans-serif;
                font-size: .95rem;
                font-weight: 700;
                cursor: pointer;
                transition: all .25s;
            }
            .btn-modal-done:hover {
                opacity: .88;
            }

            @keyframes fadeUp {
                from {
                    opacity: 0;
                    transform: translateY(24px);
                }
                to   {
                    opacity: 1;
                    transform: translateY(0);
                }
            }
            @keyframes popIn {
                from {
                    transform: scale(.5);
                    opacity: 0;
                }
                to   {
                    transform: scale(1);
                    opacity: 1;
                }
            }

            @media (max-width: 768px) {
                .page-body {
                    grid-template-columns: 1fr;
                }
                .left-panel {
                    display: none;
                }
                .right-panel {
                    padding: 40px 24px;
                }
                .navbar {
                    padding: 0 20px;
                }
                .modal {
                    padding: 32px 24px;
                    margin: 16px;
                }
            }
        </style>
    </head>
    <body>

        <!-- NAVBAR -->
        <nav class="navbar">
            <a href="${pageContext.request.contextPath}/" class="nav-logo">
                <div class="emblem">H</div>
                Quản lý Hộ dân
            </a>
            <div class="nav-actions">
                <a href="${pageContext.request.contextPath}/login"    class="btn btn-ghost">Đăng nhập</a>
                <a href="${pageContext.request.contextPath}/register" class="btn btn-gold">Đăng ký</a>
            </div>
        </nav>

        <div class="page-body">

            <!-- LEFT PANEL -->
            <div class="left-panel">
                <div class="left-content">
                    <div class="left-tag">Hệ thống quản lý cư dân</div>
                    <h1>Chào mừng<br>trở lại <span>hệ thống</span></h1>
                    <p>Đăng nhập để truy cập thông tin hộ khẩu, thông báo từ tổ dân phố và các tiện ích quản lý cư dân.</p>
                    <div class="feature-list">
                        <div class="feature-item">
                            <div class="feature-dot">🏠</div>
                            Tra cứu thông tin hộ khẩu nhanh chóng
                        </div>
                        <div class="feature-item">
                            <div class="feature-dot">📢</div>
                            Nhận thông báo theo thời gian thực
                        </div>
                        <div class="feature-item">
                            <div class="feature-dot">🔒</div>
                            Bảo mật dữ liệu cư dân tuyệt đối
                        </div>
                    </div>
                </div>
            </div>

            <!-- RIGHT PANEL -->
            <div class="right-panel">
                <div class="login-box">
                    <div class="login-box-header">
                        <h2>Đăng nhập</h2>
                        <p>Nhập thông tin tài khoản của bạn để tiếp tục</p>
                    </div>

                    <c:if test="${not empty error}">
                        <div class="error-msg">⚠️ ${error}</div>
                    </c:if>
                    <c:if test="${not empty resetSuccess}">
                        <div class="success-msg">✅ ${resetSuccess}</div>
                    </c:if>
                    <c:if test="${param.msg == 'password_changed'}">
                        <div class="success-msg">✅ Đổi mật khẩu thành công! Vui lòng đăng nhập lại.</div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/login" method="post">
                        <div class="form-group">
                            <label for="email">Gmail</label>
                            <input type="email" id="email" name="email"
                                   placeholder="example@gmail.com" required autofocus>
                        </div>
                        <div class="form-group">
                            <label for="matKhau">Mật khẩu</label>
                            <div class="pw-wrap">
                                <input type="password" id="matKhau" name="matKhau"
                                       placeholder="Nhập mật khẩu..." required>
                                <button type="button" class="pw-eye" onclick="toggleLoginPw(this)">👁</button>
                            </div>
                        </div>
                        <button type="submit" class="btn-submit">Đăng nhập</button>

                        <a href="${pageContext.request.contextPath}/quen-mat-khau" class="forgot-link" style="display:inline-block; margin-top:12px;">
                            Quên mật khẩu?
                        </a>
                    </form>

                    <div class="divider">hoặc</div>

                    <a href="${pageContext.request.contextPath}/oauth2/authorization/google" class="google-btn">
                        <img src="https://www.google.com/favicon.ico" alt="Google" class="google-icon">
                        Đăng nhập bằng Google
                    </a>

                    <div class="login-footer">
                        Chưa có tài khoản?
                        <a href="${pageContext.request.contextPath}/register">Đăng ký ngay</a>
                    </div>
                </div>
            </div>

        </div>

        <!-- MODAL QUÊN MẬT KHẨU -->
        <div class="modal-overlay" id="forgotOverlay" onclick="closeForgotOutside(event)">
            <div class="modal" id="forgotModal">
                <button class="modal-close" onclick="closeForgot()" title="Đóng">✕</button>

                <div id="forgotForm">
                    <div class="modal-icon">🔑</div>
                    <h3>Quên mật khẩu?</h3>
                    <p>Nhập địa chỉ email đã đăng ký. Chúng tôi sẽ gửi cho bạn đường dẫn để đặt lại mật khẩu.</p>

                    <form action="${pageContext.request.contextPath}/quen-mat-khau" method="post"
                          onsubmit="handleForgotSubmit(event)">
                        <div class="form-group">
                            <label for="resetEmail">Địa chỉ email</label>
                            <input type="email" id="resetEmail" name="resetEmail"
                                   placeholder="example@gmail.com" required>
                            <div class="modal-hint">
                                📬 Email đặt lại mật khẩu sẽ được gửi trong vài giây.
                            </div>
                        </div>
                        <div class="modal-actions">
                            <button type="button" class="btn-modal-cancel" onclick="closeForgot()">Huỷ</button>
                            <button type="submit" class="btn-modal-submit" id="forgotSubmitBtn">Gửi email đặt lại</button>
                        </div>
                    </form>
                </div>

                <div id="forgotDone" style="display:none">
                    <div class="modal-success">
                        <span class="success-icon">📩</span>
                        <h4>Kiểm tra hộp thư!</h4>
                        <p>
                            Chúng tôi đã gửi link đặt lại mật khẩu đến email của bạn.<br>
                            Link có hiệu lực trong <strong>15 phút</strong>.
                            Nếu không thấy, hãy kiểm tra thư mục <em>Spam</em>.
                        </p>
                        <button class="btn-modal-done" onclick="closeForgot()">Đã hiểu, đóng lại</button>
                    </div>
                </div>
            </div>
        </div>

        <script>
            function toggleLoginPw(btn) {
                const inp = document.getElementById('matKhau');
                inp.type = inp.type === 'password' ? 'text' : 'password';
                btn.textContent = inp.type === 'password' ? '👁' : '🙈';
            }

            function openForgot(e) {
                e.preventDefault();
                document.getElementById('forgotOverlay').classList.add('open');
                document.getElementById('resetEmail').focus();
                document.getElementById('forgotForm').style.display = 'block';
                document.getElementById('forgotDone').style.display = 'none';
            }

            function closeForgot() {
                document.getElementById('forgotOverlay').classList.remove('open');
            }

            function closeForgotOutside(e) {
                if (e.target === document.getElementById('forgotOverlay'))
                    closeForgot();
            }

            document.addEventListener('keydown', function (e) {
                if (e.key === 'Escape')
                    closeForgot();
            });

            function handleForgotSubmit(e) {
                /*
                 e.preventDefault();
                 const email = document.getElementById('resetEmail').value;
                 const btn   = document.getElementById('forgotSubmitBtn');
                 btn.textContent = 'Đang gửi...';
                 btn.disabled = true;
                 fetch('${pageContext.request.contextPath}/quen-mat-khau', {
                 method: 'POST',
                 headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                 body: 'resetEmail=' + encodeURIComponent(email)
                 }).then(() => {
                 document.getElementById('forgotForm').style.display = 'none';
                 document.getElementById('forgotDone').style.display  = 'block';
                 }).catch(() => {
                 btn.textContent = 'Gửi email đặt lại';
                 btn.disabled = false;
                 alert('Có lỗi xảy ra, vui lòng thử lại.');
                 });
                 */
            }
        </script>
    </body>
</html>