<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Thông Tin Hộ dân</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;900&family=Be+Vietnam+Pro:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        :root {
            --navy:   #0D1B2A;
            --ink:    #1A2F45;
            --gold:   #C9933A;
            --gold2:  #E8B96A;
            --cream:  #F7F3EC;
            --muted:  #6B7F93;
            --white:  #FFFFFF;
            --card-bg:#FFFFFF;
            --shadow: 0 8px 40px rgba(13,27,42,.10);
        }

        html { scroll-behavior: smooth; }

        body {
            font-family: 'Be Vietnam Pro', sans-serif;
            background: var(--cream);
            color: var(--ink);
            overflow-x: hidden;
        }

        /* ─── NAVBAR ─── */
        .navbar {
            position: fixed; top: 0; left: 0; right: 0; z-index: 999;
            display: flex; align-items: center; justify-content: space-between;
            padding: 0 48px;
            height: 70px;
            background: rgba(13,27,42,.92);
            backdrop-filter: blur(14px);
            border-bottom: 1px solid rgba(201,147,58,.25);
        }
        .nav-logo {
            display: flex; align-items: center; gap: 12px;
            font-family: 'Playfair Display', serif;
            font-size: 1.25rem; color: var(--white); letter-spacing: .5px;
        }
        .nav-logo .emblem {
            width: 38px; height: 38px; border-radius: 50%;
            background: linear-gradient(135deg, var(--gold), var(--gold2));
            display: grid; place-items: center;
            font-size: 1.1rem; font-weight: 900; color: var(--navy);
        }
        .nav-actions { display: flex; gap: 12px; align-items: center; }
        .btn {
            display: inline-flex; align-items: center; gap: 6px;
            padding: 9px 22px; border-radius: 6px;
            font-family: 'Be Vietnam Pro', sans-serif;
            font-weight: 600; font-size: .88rem;
            text-decoration: none; cursor: pointer;
            transition: all .25s;
        }
        .btn-ghost {
            border: 1.5px solid rgba(255,255,255,.35);
            color: var(--white);
        }
        .btn-ghost:hover { border-color: var(--gold); color: var(--gold); }
        .btn-gold {
            background: linear-gradient(135deg, var(--gold), var(--gold2));
            color: var(--navy); border: none;
        }
        .btn-gold:hover { opacity: .88; transform: translateY(-1px); box-shadow: 0 6px 20px rgba(201,147,58,.4); }

        /* ─── HERO ─── */
        .hero {
            min-height: 100vh;
            display: flex; align-items: center;
            padding: 120px 48px 80px;
            position: relative;
            overflow: hidden;
            background: var(--navy);
        }
        .hero-bg {
            position: absolute; inset: 0; z-index: 0;
            background:
                radial-gradient(ellipse 70% 60% at 80% 40%, rgba(201,147,58,.12) 0%, transparent 65%),
                radial-gradient(ellipse 50% 50% at 10% 80%, rgba(26,47,69,.8) 0%, transparent 60%);
        }
        .hero-grid {
            position: absolute; inset: 0; z-index: 0;
            background-image:
                linear-gradient(rgba(201,147,58,.06) 1px, transparent 1px),
                linear-gradient(90deg, rgba(201,147,58,.06) 1px, transparent 1px);
            background-size: 60px 60px;
        }
        .hero-content {
            position: relative; z-index: 1;
            max-width: 680px;
            animation: fadeUp .9s ease both;
        }
        .hero-eyebrow {
            display: inline-flex; align-items: center; gap: 8px;
            font-size: .8rem; font-weight: 600; letter-spacing: 2px;
            text-transform: uppercase; color: var(--gold);
            margin-bottom: 24px;
        }
        .hero-eyebrow::before {
            content: ''; display: block;
            width: 28px; height: 2px; background: var(--gold);
        }
        .hero h1 {
            font-family: 'Playfair Display', serif;
            font-size: clamp(2.6rem, 5vw, 4.2rem);
            font-weight: 900; line-height: 1.12;
            color: var(--white);
            margin-bottom: 24px;
        }
        .hero h1 span { color: var(--gold); }
        .hero p {
            font-size: 1.05rem; line-height: 1.75;
            color: rgba(255,255,255,.65);
            margin-bottom: 40px; max-width: 520px;
        }
        .hero-cta { display: flex; gap: 14px; flex-wrap: wrap; }

        .hero-visual {
            position: absolute; right: 0; top: 0; bottom: 0; z-index: 1;
            width: 46%; display: flex; align-items: center; justify-content: center;
        }
        .hero-card-float {
            background: rgba(255,255,255,.06);
            border: 1px solid rgba(201,147,58,.2);
            border-radius: 16px;
            padding: 32px;
            backdrop-filter: blur(10px);
            animation: floatY 5s ease-in-out infinite;
            max-width: 340px; width: 100%;
        }
        .stat-row { display: flex; gap: 24px; margin-top: 20px; }
        .stat-item { flex: 1; }
        .stat-num {
            font-family: 'Playfair Display', serif;
            font-size: 2rem; font-weight: 900; color: var(--gold);
        }
        .stat-label { font-size: .78rem; color: rgba(255,255,255,.5); margin-top: 2px; }
        .stat-divider {
            width: 100%; height: 1px;
            background: rgba(201,147,58,.2);
            margin: 20px 0;
        }
        .mini-badge {
            display: inline-flex; align-items: center; gap: 6px;
            background: rgba(201,147,58,.15);
            border: 1px solid rgba(201,147,58,.3);
            border-radius: 20px; padding: 5px 12px;
            font-size: .78rem; color: var(--gold2); margin-bottom: 12px;
        }
        .mini-badge::before { content: '●'; font-size: .6rem; color: #4ade80; }

        /* ─── FEATURES ─── */
        .section { padding: 100px 48px; }
        .section-header { text-align: center; margin-bottom: 60px; }
        .section-tag {
            font-size: .78rem; font-weight: 700; letter-spacing: 2.5px;
            text-transform: uppercase; color: var(--gold);
            margin-bottom: 14px;
        }
        .section-title {
            font-family: 'Playfair Display', serif;
            font-size: clamp(1.8rem, 3.5vw, 2.8rem);
            font-weight: 900; color: var(--navy); line-height: 1.2;
        }
        .section-sub {
            color: var(--muted); font-size: .98rem;
            margin-top: 14px; max-width: 520px; margin-left: auto; margin-right: auto;
            line-height: 1.7;
        }

        .cards-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 24px; max-width: 1200px; margin: 0 auto;
        }
        .card {
            background: var(--card-bg);
            border-radius: 14px;
            padding: 36px 32px;
            border: 1px solid rgba(13,27,42,.08);
            box-shadow: var(--shadow);
            transition: transform .3s, box-shadow .3s;
            position: relative; overflow: hidden;
        }
        .card::before {
            content: '';
            position: absolute; top: 0; left: 0; right: 0;
            height: 3px;
            background: linear-gradient(90deg, var(--gold), var(--gold2));
            transform: scaleX(0); transform-origin: left;
            transition: transform .35s;
        }
        .card:hover { transform: translateY(-6px); box-shadow: 0 20px 50px rgba(13,27,42,.14); }
        .card:hover::before { transform: scaleX(1); }

        .card-icon {
            width: 52px; height: 52px; border-radius: 12px;
            background: linear-gradient(135deg, rgba(201,147,58,.12), rgba(232,185,106,.08));
            border: 1px solid rgba(201,147,58,.2);
            display: grid; place-items: center;
            font-size: 1.4rem; margin-bottom: 20px;
        }
        .card h3 {
            font-family: 'Playfair Display', serif;
            font-size: 1.2rem; font-weight: 700;
            color: var(--navy); margin-bottom: 12px;
        }
        .card p { color: var(--muted); font-size: .9rem; line-height: 1.7; margin-bottom: 24px; }
        .card-link {
            display: inline-flex; align-items: center; gap: 6px;
            font-size: .88rem; font-weight: 600;
            color: var(--gold); text-decoration: none;
            transition: gap .2s;
        }
        .card-link:hover { gap: 10px; }
        .card-link::after { content: '→'; }

        /* ─── ROLE CARDS ─── */
        .roles-section { background: var(--navy); }
        .roles-section .section-title { color: var(--white); }
        .role-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
            gap: 20px; max-width: 1000px; margin: 0 auto;
        }
        .role-card {
            border-radius: 14px; padding: 32px 28px;
            border: 1px solid rgba(201,147,58,.2);
            background: rgba(255,255,255,.04);
            transition: background .3s, transform .3s;
        }
        .role-card:hover { background: rgba(201,147,58,.08); transform: translateY(-4px); }
        .role-icon { font-size: 2rem; margin-bottom: 16px; }
        .role-card h4 {
            font-family: 'Playfair Display', serif;
            color: var(--gold2); font-size: 1.1rem; margin-bottom: 10px;
        }
        .role-card p { color: rgba(255,255,255,.55); font-size: .88rem; line-height: 1.65; }

        /* ─── CTA BANNER ─── */
        .cta-section {
            padding: 100px 48px;
            background: linear-gradient(135deg, var(--navy) 0%, #1a3a5c 100%);
            text-align: center; position: relative; overflow: hidden;
        }
        .cta-section::before {
            content: '';
            position: absolute; inset: 0;
            background: radial-gradient(ellipse 60% 60% at 50% 50%, rgba(201,147,58,.1) 0%, transparent 70%);
        }
        .cta-section h2 {
            font-family: 'Playfair Display', serif;
            font-size: clamp(1.8rem, 4vw, 3rem);
            color: var(--white); font-weight: 900; margin-bottom: 16px;
            position: relative;
        }
        .cta-section p {
            color: rgba(255,255,255,.6); font-size: 1rem;
            margin-bottom: 36px; position: relative;
        }
        .cta-btns { display: flex; gap: 14px; justify-content: center; flex-wrap: wrap; position: relative; }
        .btn-white {
            background: var(--white); color: var(--navy);
            font-weight: 700; border: none;
        }
        .btn-white:hover { background: var(--cream); transform: translateY(-2px); box-shadow: 0 8px 24px rgba(0,0,0,.2); }

        /* ─── FOOTER ─── */
        footer {
            background: #080f17;
            color: rgba(255,255,255,.4);
            text-align: center; padding: 28px 48px;
            font-size: .83rem;
            border-top: 1px solid rgba(201,147,58,.15);
        }
        footer span { color: var(--gold); }

        /* ─── ANIMATIONS ─── */
        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(30px); }
            to   { opacity: 1; transform: translateY(0); }
        }
        @keyframes floatY {
            0%,100% { transform: translateY(0); }
            50%      { transform: translateY(-16px); }
        }

        .animate { animation: fadeUp .7s ease both; }
        .delay-1 { animation-delay: .15s; }
        .delay-2 { animation-delay: .3s; }
        .delay-3 { animation-delay: .45s; }

        @media (max-width: 768px) {
            .navbar { padding: 0 20px; }
            .hero { padding: 110px 20px 60px; }
            .hero-visual { display: none; }
            .section { padding: 70px 20px; }
            .cta-section { padding: 70px 20px; }
            footer { padding: 20px; }
        }
    </style>
</head>
<body>

<!-- NAVBAR -->
<nav class="navbar">
    <div class="nav-logo">
        <div class="emblem">H</div>
        Quản lý Thông Tin Hộ dân
    </div>
    <div class="nav-actions">
        <a href="${pageContext.request.contextPath}/login" class="btn btn-ghost">Đăng nhập</a>
        <a href="${pageContext.request.contextPath}/register" class="btn btn-gold">Đăng ký</a>
    </div>
</nav>

<!-- HERO -->
<section class="hero">
    <div class="hero-bg"></div>
    <div class="hero-grid"></div>
    <div class="hero-content">
        <div class="hero-eyebrow">Hệ thống quản lý Thông tin hộ dân dân</div>
        <h1>Kết nối<br><span>cộng đồng</span><br>thông minh</h1>
        <p>Nền tảng số hoá quản lý hộ dân – kết nối cư dân, tổ dân phố và chính quyền địa phương một cách hiệu quả và minh bạch.</p>
        <div class="hero-cta">
            <a href="${pageContext.request.contextPath}/login" class="btn btn-gold">Bắt đầu ngay</a>
            <a href="#features" class="btn btn-ghost">Khám phá thêm</a>
        </div>
    </div>
    <div class="hero-visual">
        <div class="hero-card-float">
            <div class="mini-badge">Hệ thống đang hoạt động</div>
            <div style="color:rgba(255,255,255,.8); font-size:.9rem; line-height:1.6;">
                Quản lý toàn bộ thông tin hộ dân, thông báo và lịch sử cư trú trong một nền tảng duy nhất.
            </div>
            <div class="stat-divider"></div>
            <div class="stat-row">
                <div class="stat-item">
                    <div class="stat-num">1.2K+</div>
                    <div class="stat-label">Hộ dân</div>
                </div>
                <div class="stat-item">
                    <div class="stat-num">48</div>
                    <div class="stat-label">Tổ dân phố</div>
                </div>
                <div class="stat-item">
                    <div class="stat-num">99%</div>
                    <div class="stat-label">Uptime</div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- FEATURES -->
<section class="section" id="features">
    <div class="section-header animate">
        <div class="section-tag">Tính năng</div>
        <h2 class="section-title">Mọi thứ bạn cần<br>trong một hệ thống</h2>
        <p class="section-sub">Từ quản lý hộ khẩu đến gửi thông báo, chúng tôi cung cấp đầy đủ công cụ cho mọi cấp quản lý.</p>
    </div>
    <div class="cards-grid">
        <div class="card animate delay-1">
            <div class="card-icon">📢</div>
            <h3>Thông báo & Tin tức</h3>
            <p>Nhận thông báo mới nhất từ tổ dân phố và chính quyền theo thời gian thực. Không bỏ lỡ bất kỳ thông tin quan trọng nào.</p>
            <a href="${pageContext.request.contextPath}/thongbao" class="card-link">Xem ngay</a>
        </div>
        <div class="card animate delay-2">
            <div class="card-icon">🏠</div>
            <h3>Thông tin Hộ khẩu</h3>
            <p>Tra cứu chi tiết hộ khẩu, danh sách thành viên gia đình và trạng thái cư trú một cách nhanh chóng và chính xác.</p>
            <a href="${pageContext.request.contextPath}/hodan/my" class="card-link">Xem hộ khẩu</a>
        </div>
        <div class="card animate delay-3">
            <div class="card-icon">👤</div>
            <h3>Hồ sơ Cá nhân</h3>
            <p>Cập nhật thông tin cá nhân, thay đổi mật khẩu và theo dõi lịch sử hoạt động của tài khoản.</p>
            <a href="${pageContext.request.contextPath}/" class="card-link">Hồ sơ của tôi</a>
        </div>

        <c:if test="${vaiTro == 'Cán bộ tổ dân phố' || vaiTro == 'Tổ trưởng'}">
        <div class="card animate">
            <div class="card-icon">📋</div>
            <h3>Quản lý Hộ dân Tổ</h3>
            <p>Xem, thêm và cập nhật thông tin hộ dân trong tổ của bạn một cách dễ dàng.</p>
            <a href="${pageContext.request.contextPath}/hodan/list" class="card-link">Quản lý hộ dân</a>
        </div>
        <div class="card animate delay-1">
            <div class="card-icon">📨</div>
            <h3>Gửi Thông báo</h3>
            <p>Gửi thông báo khẩn cấp hoặc định kỳ đến cư dân trong tổ nhanh chóng và hiệu quả.</p>
            <a href="${pageContext.request.contextPath}/thongbao/send" class="card-link">Gửi thông báo</a>
        </div>
        <div class="card animate delay-2">
            <div class="card-icon">📥</div>
            <h3>Import Danh sách</h3>
            <p>Nhập danh sách cư dân mới hàng loạt từ file Excel hoặc CSV, tiết kiệm thời gian nhập liệu.</p>
            <a href="${pageContext.request.contextPath}/import" class="card-link">Import dữ liệu</a>
        </div>
        </c:if>

        <c:if test="${vaiTro == 'Admin'}">
        <div class="card animate">
            <div class="card-icon">⚙️</div>
            <h3>Quản lý Người dùng</h3>
            <p>Xem, thêm, sửa và xóa tài khoản admin, tổ trưởng và cư dân trên toàn hệ thống.</p>
            <a href="${pageContext.request.contextPath}/admin/users" class="card-link">Quản lý người dùng</a>
        </div>
        <div class="card animate delay-1">
            <div class="card-icon">📊</div>
            <h3>Dashboard Quản trị</h3>
            <p>Xem thống kê tổng quan, báo cáo và các chỉ số hoạt động của toàn bộ hệ thống.</p>
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="card-link">Dashboard</a>
        </div>
        </c:if>
    </div>
</section>

<!-- ROLES -->
<section class="section roles-section">
    <div class="section-header animate">
        <div class="section-tag" style="color:var(--gold2)">Đối tượng sử dụng</div>
        <h2 class="section-title">Dành cho tất cả mọi người</h2>
        <p class="section-sub" style="color:rgba(255,255,255,.5)">Hệ thống được thiết kế phù hợp cho từng vai trò với quyền hạn riêng biệt.</p>
    </div>
    <div class="role-grid">
        <div class="role-card animate">
            <div class="role-icon">🏘️</div>
            <h4>Cư dân</h4>
            <p>Tra cứu hộ khẩu, nhận thông báo từ tổ dân phố và cập nhật hồ sơ cá nhân.</p>
        </div>
        <div class="role-card animate delay-1">
            <div class="role-icon">🗂️</div>
            <h4>Tổ trưởng / Cán bộ</h4>
            <p>Quản lý hộ dân trong tổ, gửi thông báo và nhập dữ liệu cư dân mới.</p>
        </div>
        <div class="role-card animate delay-2">
            <div class="role-icon">🛡️</div>
            <h4>Quản trị viên</h4>
            <p>Toàn quyền quản lý hệ thống, người dùng và xem báo cáo thống kê tổng quan.</p>
        </div>
    </div>
</section>

<!-- CTA -->
<section class="cta-section">
    <h2>Sẵn sàng bắt đầu?</h2>
    <p>Đăng ký tài khoản miễn phí và trải nghiệm hệ thống quản lý hộ dân hiện đại nhất.</p>
    <div class="cta-btns">
        <a href="${pageContext.request.contextPath}/register" class="btn btn-white">Đăng ký ngay</a>
        <a href="${pageContext.request.contextPath}/login" class="btn btn-ghost">Đăng nhập</a>
    </div>
</section>

<!-- FOOTER -->
<footer>
    © 2025 <span>Hệ thống Quản lý Hộ dân – Hà Nội</span> &nbsp;|&nbsp; Hỗ trợ: admin@quanlyhodan.vn
</footer>

<script>
    // Scroll animation
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(e => {
            if (e.isIntersecting) {
                e.target.style.animationPlayState = 'running';
                e.target.style.opacity = '1';
            }
        });
    }, { threshold: 0.12 });

    document.querySelectorAll('.animate').forEach(el => {
        el.style.opacity = '0';
        el.style.animationPlayState = 'paused';
        observer.observe(el);
    });

    // Navbar scroll effect
    window.addEventListener('scroll', () => {
        const nav = document.querySelector('.navbar');
        nav.style.background = window.scrollY > 40
            ? 'rgba(8,15,23,.97)'
            : 'rgba(13,27,42,.92)';
    });
</script>
</body>
</html>
