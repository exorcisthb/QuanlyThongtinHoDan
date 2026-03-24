<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đổi mật khẩu - Quản lý Hộ dân</title>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { box-sizing: border-box; }
        :root {
            --bg: #0f1117; --surface: #181c27; --accent: #4f8ef7; --danger: #f75c5c;
            --accent2: #38d9a9; --text: #e2e8f0; --muted: #64748b; --radius: 12px;
            --border: #2a3048; --surface2: #1f2433;
        }
        body {
            font-family: 'Be Vietnam Pro', sans-serif;
            background: var(--bg); color: var(--text);
            min-height: 100vh;
            display: flex; align-items: flex-start; justify-content: center;
            padding: 40px 16px;
        }
        .container {
            width: 100%; max-width: 480px;
            background: var(--surface); border-radius: var(--radius);
            padding: 40px 32px; border: 1px solid var(--border);
        }
        h1 { font-size: 1.8rem; margin-bottom: 8px; text-align: center; }
        p.subtitle { text-align: center; color: var(--muted); margin-bottom: 32px; }
        .form-group { margin-bottom: 20px; }
        label { display: block; margin-bottom: 8px; font-weight: 600; color: var(--muted); font-size: 0.85rem; text-transform: uppercase; letter-spacing: .5px; }

        .input-wrap { position: relative; }
        .input-wrap input {
            width: 100%; padding: 12px 44px 12px 16px;
            background: var(--surface2); border: 1px solid var(--border);
            border-radius: 8px; color: var(--text); font-size: 1rem;
            font-family: inherit; transition: border-color .2s, box-shadow .2s;
        }
        .input-wrap input:focus { outline: none; border-color: var(--accent); box-shadow: 0 0 0 3px rgba(79,142,247,.2); }
        .input-wrap input.invalid { border-color: var(--danger) !important; box-shadow: 0 0 0 3px rgba(247,92,92,.15) !important; }
        .input-wrap input.valid   { border-color: var(--accent2) !important; box-shadow: 0 0 0 3px rgba(56,217,169,.15) !important; }
        .eye-btn {
            position: absolute; right: 12px; top: 50%; transform: translateY(-50%);
            background: none; border: none; cursor: pointer;
            color: var(--muted); font-size: 16px; padding: 0; transition: color .15s;
        }
        .eye-btn:hover { color: var(--text); }

        .pw-bar  { height: 4px; border-radius: 2px; background: var(--border); margin-top: 8px; overflow: hidden; }
        .pw-fill { height: 100%; border-radius: 2px; width: 0; transition: width .3s, background .3s; }

        .rules { margin-top: 10px; display: grid; grid-template-columns: 1fr 1fr; gap: 6px; }
        .rule { display: flex; align-items: center; gap: 6px; font-size: 12px; color: var(--muted); transition: color .2s; }
        .rule.ok { color: var(--accent2); }
        .rule-icon { font-size: 13px; width: 16px; text-align: center; }

        .confirm-hint { font-size: 12px; margin-top: 6px; min-height: 18px; }

        .btn {
            width: 100%; padding: 14px; background: var(--accent); color: white;
            border: none; border-radius: 8px; font-weight: 600; cursor: pointer;
            font-size: 1rem; margin-top: 8px; font-family: inherit;
            transition: all .2s; opacity: .5; pointer-events: none;
        }
        .btn.ready { opacity: 1; pointer-events: all; }
        .btn.ready:hover { background: #3a7de8; box-shadow: 0 4px 16px rgba(79,142,247,.35); }

        .alert { padding: 14px; border-radius: 8px; margin-bottom: 24px; font-size: 0.95rem; }
        .alert.error { background: rgba(247,92,92,.15); color: var(--danger); border: 1px solid rgba(247,92,92,.3); }

        .back-link { display: block; text-align: center; margin-top: 24px; color: var(--muted); text-decoration: none; font-size: .9rem; }
        .back-link:hover { color: var(--accent); }

        hr { border: none; border-top: 1px solid var(--border); margin: 28px 0; }
    </style>
</head>
<body>
<div class="container">
    <h1>🔑 Đổi mật khẩu</h1>
    <p class="subtitle">Vui lòng nhập thông tin để thay đổi mật khẩu</p>

    <c:if test="${not empty error}">
        <div class="alert error">⚠️ ${error}</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/admin/change_password" method="post" id="pwForm">

        <div class="form-group">
            <label for="currentPassword">Mật khẩu hiện tại</label>
            <div class="input-wrap">
                <input type="password" id="currentPassword" name="currentPassword"
                       placeholder="Nhập mật khẩu hiện tại" required>
                <button type="button" class="eye-btn" onclick="togglePw('currentPassword', this)">👁</button>
            </div>
        </div>

        <hr>

        <div class="form-group">
            <label for="newPassword">Mật khẩu mới</label>
            <div class="input-wrap">
                <input type="password" id="newPassword" name="newPassword"
                       placeholder="Nhập mật khẩu mới" required
                       oninput="checkNewPw(this.value)">
                <button type="button" class="eye-btn" onclick="togglePw('newPassword', this)">👁</button>
            </div>
            <div class="pw-bar"><div class="pw-fill" id="pwFill"></div></div>
            <div class="rules">
                <div class="rule" id="r-len">  <span class="rule-icon">○</span> Ít nhất 8 ký tự</div>
                <div class="rule" id="r-upper"><span class="rule-icon">○</span> 1 chữ hoa (A-Z)</div>
                <div class="rule" id="r-num">  <span class="rule-icon">○</span> 1 chữ số (0-9)</div>
                <div class="rule" id="r-spec"> <span class="rule-icon">○</span> 1 ký tự đặc biệt</div>
            </div>
        </div>

        <div class="form-group">
            <label for="confirmPassword">Xác nhận mật khẩu mới</label>
            <div class="input-wrap">
                <input type="password" id="confirmPassword" name="confirmPassword"
                       placeholder="Nhập lại mật khẩu mới" required
                       oninput="checkConfirm(this.value)">
                <button type="button" class="eye-btn" onclick="togglePw('confirmPassword', this)">👁</button>
            </div>
            <div class="confirm-hint" id="confirmHint"></div>
        </div>

        <button type="submit" class="btn" id="submitBtn">Cập nhật mật khẩu</button>
    </form>

    <a href="${pageContext.request.contextPath}/home" class="back-link">← Quay về trang chủ</a>
</div>

<script>
    function togglePw(id, btn) {
        const inp = document.getElementById(id);
        inp.type = inp.type === 'password' ? 'text' : 'password';
        btn.textContent = inp.type === 'password' ? '👁' : '🙈';
    }

    const ruleState = { len: false, upper: false, num: false, spec: false };

    function checkNewPw(val) {
        ruleState.len   = val.length >= 8;
        ruleState.upper = /[A-Z]/.test(val);
        ruleState.num   = /[0-9]/.test(val);
        ruleState.spec  = /[^A-Za-z0-9]/.test(val);

        setRule('r-len',   ruleState.len);
        setRule('r-upper', ruleState.upper);
        setRule('r-num',   ruleState.num);
        setRule('r-spec',  ruleState.spec);

        const score = Object.values(ruleState).filter(Boolean).length;
        const pct   = ['0%', '30%', '55%', '80%', '100%'][score];
        const color = ['#f75c5c', '#fbbf24', '#fbbf24', '#4f8ef7', '#38d9a9'][score];
        document.getElementById('pwFill').style.width      = pct;
        document.getElementById('pwFill').style.background = color;

        const inp = document.getElementById('newPassword');
        inp.classList.toggle('valid',   score === 4);
        inp.classList.toggle('invalid', val.length > 0 && score < 4);

        const confirmVal = document.getElementById('confirmPassword').value;
        if (confirmVal) checkConfirm(confirmVal);

        updateSubmitBtn();
    }

    function setRule(id, ok) {
        const el = document.getElementById(id);
        el.classList.toggle('ok', ok);
        el.querySelector('.rule-icon').textContent = ok ? '✅' : '○';
    }

    function checkConfirm(val) {
        const hint   = document.getElementById('confirmHint');
        const newVal = document.getElementById('newPassword').value;
        const inp    = document.getElementById('confirmPassword');
        if (!val) { hint.textContent = ''; inp.classList.remove('valid','invalid'); updateSubmitBtn(); return; }
        const match = val === newVal;
        hint.style.color = match ? '#38d9a9' : '#f75c5c';
        hint.textContent = match ? '✅ Mật khẩu khớp' : '❌ Mật khẩu chưa khớp';
        inp.classList.toggle('valid',   match);
        inp.classList.toggle('invalid', !match);
        updateSubmitBtn();
    }

    function allValid() {
        const newVal     = document.getElementById('newPassword').value;
        const confirmVal = document.getElementById('confirmPassword').value;
        return Object.values(ruleState).every(Boolean) && newVal === confirmVal && confirmVal.length > 0;
    }

    function updateSubmitBtn() {
        document.getElementById('submitBtn').classList.toggle('ready', allValid());
    }
</script>
</body>
</html>