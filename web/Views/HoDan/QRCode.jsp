<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mã QR Hộ Khẩu</title>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg:#0f1117; --surface:#181c27; --surface2:#1f2433;
            --border:#2a3048; --accent:#4f8ef7; --accent2:#38d9a9;
            --danger:#f75c5c; --text:#e2e8f0; --muted:#64748b; --radius:14px;
        }
        *{box-sizing:border-box;margin:0;padding:0}
        body{font-family:'Be Vietnam Pro',sans-serif;background:var(--bg);color:var(--text);min-height:100vh;display:flex;align-items:center;justify-content:center;padding:32px}
        .card{background:var(--surface);border:1px solid var(--border);border-radius:var(--radius);padding:40px;text-align:center;max-width:440px;width:100%}
        .back-btn{display:inline-flex;align-items:center;gap:6px;font-size:13px;color:var(--muted);text-decoration:none;margin-bottom:28px;transition:color .15s}
        .back-btn:hover{color:var(--accent)}
        h2{font-size:20px;font-weight:800;margin-bottom:6px}
        .sub{font-size:13px;color:var(--muted);margin-bottom:28px;line-height:1.6}
        .qr-wrap{background:#fff;border-radius:12px;padding:16px;display:inline-block;margin-bottom:24px}
        .qr-wrap img{display:block;width:240px;height:240px}
        .btn-group{display:flex;gap:10px;justify-content:center;flex-wrap:wrap;margin-bottom:14px}
        .btn{display:inline-flex;align-items:center;gap:8px;border-radius:8px;padding:10px 22px;font-size:13px;font-weight:600;cursor:pointer;font-family:inherit;transition:all .18s;text-decoration:none;border:none}
        .btn-primary{background:rgba(79,142,247,.15);color:var(--accent);border:1px solid rgba(79,142,247,.3)}
        .btn-primary:hover{background:var(--accent);color:#fff}
        .btn-danger{background:rgba(247,92,92,.1);color:var(--danger);border:1px solid rgba(247,92,92,.3)}
        .btn-danger:hover{background:var(--danger);color:#fff}
        .btn-green{background:rgba(56,217,169,.1);color:var(--accent2);border:1px solid rgba(56,217,169,.3)}
        .btn-green:hover{background:var(--accent2);color:#000}
        .error-box{background:rgba(247,92,92,.1);border:1px solid rgba(247,92,92,.3);border-radius:10px;padding:20px;color:var(--danger);font-size:13px}
        .notice{font-size:11px;color:var(--muted);line-height:1.6;padding:10px 14px;background:var(--surface2);border-radius:8px;border:1px solid var(--border)}
        /* TEST LINK BOX */
        .test-box{margin-top:16px;background:var(--surface2);border:1px dashed var(--border);border-radius:8px;padding:12px 14px;text-align:left}
        .test-box-title{font-size:10px;font-weight:700;color:var(--warn, #fbbf24);text-transform:uppercase;letter-spacing:.8px;margin-bottom:8px}
        .test-link{font-size:11px;color:var(--muted);word-break:break-all;line-height:1.6;margin-bottom:8px}
        .copy-btn{font-size:11px;color:var(--accent);cursor:pointer;font-weight:600;background:none;border:none;font-family:inherit;padding:0}
        .copy-btn:hover{text-decoration:underline}
        .copied{color:var(--accent2) !important}
    </style>
</head>
<body>
<div class="card">
    <a href="${pageContext.request.contextPath}/hodan/dashboard" class="back-btn">← Về trang chủ</a>
    <h2>Mã QR Hộ Khẩu</h2>
    <p class="sub">
        Chủ hộ: <strong style="color:var(--accent2)">${hoDan.tenChuHo}</strong><br>
        Cho tổ trưởng quét để xem thông tin hộ khẩu
    </p>

    <c:choose>
        <c:when test="${not empty error}">
            <div class="error-box">
                <div style="font-size:28px;margin-bottom:10px">⚠️</div>
                <p style="font-weight:700;margin-bottom:6px">Không thể tạo mã QR</p>
                <p>${error}</p>
            </div>
        </c:when>
        <c:otherwise>
            <div class="qr-wrap">
                <img src="data:image/png;base64,${qrBase64}" alt="QR Code" id="qrImg"/>
            </div>

            <div class="btn-group">
                <button class="btn btn-primary" onclick="downloadQR()">⬇ Tải QR về máy</button>
                <form method="post" action="${pageContext.request.contextPath}/hodan/qr"
                      onsubmit="return confirm('Tạo mã QR mới sẽ vô hiệu mã cũ. Tiếp tục?')">
                    <input type="hidden" name="action" value="reset"/>
                    <button type="submit" class="btn btn-danger">🔄 Tạo mã mới</button>
                </form>
            </div>

            <div class="notice">
                💡 Đây là mã QR chung của cả hộ. Tất cả thành viên trong hộ đều dùng chung mã này.
            </div>

            <!-- TEST BOX — dùng khi chưa deploy, đăng nhập bằng tài khoản tổ trưởng rồi mở link này -->
            <div class="test-box">
                <div class="test-box-title">🧪 Test (chưa deploy)</div>
                <div class="test-link" id="testLink">${scanUrl}</div>
                <button class="copy-btn" id="copyBtn" onclick="copyLink()">📋 Copy link để test</button>
            </div>

        </c:otherwise>
    </c:choose>
</div>

<script>
    function downloadQR() {
        const img = document.getElementById('qrImg');
        const a   = document.createElement('a');
        a.href     = img.src;
        a.download = 'QR_HoKhau_${hoDan.maHoKhau}.png';
        a.click();
    }

    function copyLink() {
        const link = document.getElementById('testLink').innerText;
        navigator.clipboard.writeText(link).then(() => {
            const btn = document.getElementById('copyBtn');
            btn.textContent = '✅ Đã copy!';
            btn.classList.add('copied');
            setTimeout(() => {
                btn.textContent = '📋 Copy link để test';
                btn.classList.remove('copied');
            }, 2000);
        });
    }
</script>
</body>
</html>