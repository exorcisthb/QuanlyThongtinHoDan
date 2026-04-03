<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>UBND Phường Sơn Tây - Hệ thống Quản lý Tổ dân phố</title>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        :root {
            --red-primary: #DA251D;
            --red-dark: #B91C1C;
            --red-light: #EF4444;
            --gold: #FFD700;
            --gold-dark: #D4AF37;
            --navy: #1E3A5F;
            --navy-dark: #0F172A;
            --cream: #FDF8F3;
            --white: #FFFFFF;
            --gray-100: #F3F4F6;
            --gray-200: #E5E7EB;
            --gray-600: #4B5563;
            --gray-800: #1F2937;
            --shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
        }

        html { scroll-behavior: smooth; }

        body {
            font-family: 'Be Vietnam Pro', sans-serif;
            background: var(--cream);
            color: var(--gray-800);
            overflow-x: hidden;
        }

        .gov-header {
            background: linear-gradient(135deg, var(--red-primary) 0%, var(--red-dark) 100%);
            padding: 8px 0;
            text-align: center;
            color: var(--gold);
            font-size: 0.75rem;
            font-weight: 500;
            letter-spacing: 0.5px;
        }

        .navbar {
            position: fixed; top: 32px; left: 0; right: 0; z-index: 999;
            display: flex; align-items: center; justify-content: space-between;
            padding: 0 48px;
            height: 80px;
            background: var(--white);
            box-shadow: var(--shadow-lg);
            border-bottom: 3px solid var(--gold);
        }
        .nav-logo {
            display: flex; align-items: center; gap: 16px;
        }
        .nav-logo .emblem {
            width: 50px; height: 50px; border-radius: 50%;
            background: linear-gradient(135deg, var(--red-primary), var(--red-dark));
            display: grid; place-items: center;
            border: 3px solid var(--gold);
            box-shadow: 0 2px 8px rgba(218, 37, 29, 0.3);
        }
        .nav-logo .emblem i {
            color: var(--gold);
            font-size: 1.3rem;
        }
        .nav-logo-text {
            display: flex; flex-direction: column;
        }
        .nav-logo-text .line1 {
            font-size: 0.75rem; font-weight: 600;
            color: var(--red-primary); text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .nav-logo-text .line2 {
            font-size: 1.1rem; font-weight: 700;
            color: var(--navy); line-height: 1.2;
        }
        .nav-actions { display: flex; gap: 12px; align-items: center; }
        .btn {
            display: inline-flex; align-items: center; gap: 8px;
            padding: 10px 24px; border-radius: 6px;
            font-family: 'Be Vietnam Pro', sans-serif;
            font-weight: 600; font-size: 0.9rem;
            text-decoration: none; cursor: pointer;
            transition: all 0.25s ease;
            border: none;
        }
        .btn-outline {
            border: 2px solid var(--red-primary);
            color: var(--red-primary);
            background: transparent;
        }
        .btn-outline:hover { 
            background: var(--red-primary); 
            color: var(--white);
            transform: translateY(-2px);
        }
        .btn-primary {
            background: linear-gradient(135deg, var(--red-primary), var(--red-dark));
            color: var(--white);
            box-shadow: 0 4px 12px rgba(218, 37, 29, 0.35);
        }
        .btn-primary:hover { 
            transform: translateY(-2px); 
            box-shadow: 0 6px 20px rgba(218, 37, 29, 0.45);
        }

        /* HERO */
        .hero {
            min-height: 100vh;
            display: flex; align-items: center;
            padding: 140px 48px 80px;
            position: relative;
            overflow: hidden;
            background: linear-gradient(135deg, var(--navy-dark) 0%, var(--navy) 50%, #2D5A87 100%);
        }
        .hero::before {
            content: '';
            position: absolute; inset: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><circle cx="50" cy="50" r="1" fill="rgba(255,215,0,0.1)"/></svg>');
            background-size: 50px 50px;
            opacity: 0.5;
        }
        .hero-pattern {
            position: absolute; right: 0; top: 0; bottom: 0; width: 50%;
            background: linear-gradient(90deg, transparent 0%, rgba(218, 37, 29, 0.1) 100%);
        }
        .hero-content {
            position: relative; z-index: 1;
            max-width: 650px;
            animation: fadeUp 0.9s ease both;
        }
        .hero-badge {
            display: inline-flex; align-items: center; gap: 8px;
            background: rgba(255, 215, 0, 0.15);
            border: 1px solid var(--gold);
            border-radius: 50px;
            padding: 8px 20px;
            font-size: 0.8rem; font-weight: 600;
            color: var(--gold); margin-bottom: 24px;
        }
        .hero-badge i { color: var(--gold); font-size: 0.5rem; }
        .hero h1 {
            font-size: clamp(2.2rem, 4vw, 3.5rem);
            font-weight: 800; line-height: 1.2;
            color: var(--white);
            margin-bottom: 20px;
        }
        .hero h1 span { 
            color: var(--gold);
            position: relative;
        }
        .hero p {
            font-size: 1.1rem; line-height: 1.8;
            color: rgba(255,255,255,0.85);
            margin-bottom: 32px; max-width: 520px;
        }
        .hero-cta { display: flex; gap: 16px; flex-wrap: wrap; }
        .btn-gold {
            background: linear-gradient(135deg, var(--gold), var(--gold-dark));
            color: var(--navy-dark);
            font-weight: 700;
            box-shadow: 0 4px 15px rgba(255, 215, 0, 0.3);
        }
        .btn-gold:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(255, 215, 0, 0.4);
        }
        .btn-ghost-light {
            border: 2px solid rgba(255,255,255,0.4);
            color: var(--white);
            background: transparent;
        }
        .btn-ghost-light:hover {
            border-color: var(--gold);
            color: var(--gold);
            background: rgba(255, 215, 0, 0.1);
        }

        .hero-visual {
            position: absolute; right: 48px; top: 50%; transform: translateY(-50%);
            z-index: 2;
        }
        .hero-card {
            background: rgba(255,255,255,0.95);
            border-radius: 16px;
            padding: 32px;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
            width: 380px;
            border-top: 4px solid var(--red-primary);
            animation: floatY 4s ease-in-out infinite;
        }
        .hero-card-header {
            display: flex; align-items: center; gap: 12px;
            margin-bottom: 20px;
            padding-bottom: 16px;
            border-bottom: 1px solid var(--gray-200);
        }
        .hero-card-header i {
            width: 44px; height: 44px;
            background: linear-gradient(135deg, var(--red-primary), var(--red-dark));
            border-radius: 10px;
            display: grid; place-items: center;
            color: var(--white);
            font-size: 1.2rem;
        }
        .hero-card-header h3 {
            font-size: 1.1rem; font-weight: 700;
            color: var(--navy);
        }
        .hero-card-header p {
            font-size: 0.8rem; color: var(--gray-600);
            margin: 0;
        }
        .stat-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 16px;
        }
        .stat-item {
            text-align: center;
            padding: 16px 12px;
            background: var(--gray-100);
            border-radius: 12px;
            transition: all 0.3s;
        }
        .stat-item:hover {
            background: linear-gradient(135deg, var(--red-primary), var(--red-dark));
            transform: translateY(-4px);
        }
        .stat-item:hover .stat-num,
        .stat-item:hover .stat-label {
            color: var(--white);
        }
        .stat-num {
            font-size: 1.6rem; font-weight: 800;
            color: var(--red-primary);
            line-height: 1;
        }
        .stat-label {
            font-size: 0.75rem; color: var(--gray-600);
            margin-top: 6px; font-weight: 500;
        }

        /* FEATURES */
        .section { padding: 100px 48px; }
        .section-header { 
            text-align: center; 
            margin-bottom: 60px; 
            position: relative;
        }
        .section-header::before {
            content: '';
            position: absolute; top: -20px; left: 50%; transform: translateX(-50%);
            width: 60px; height: 4px;
            background: linear-gradient(90deg, var(--red-primary), var(--gold));
            border-radius: 2px;
        }
        .section-tag {
            display: inline-flex; align-items: center; gap: 8px;
            font-size: 0.85rem; font-weight: 600;
            color: var(--red-primary); margin-bottom: 12px;
            text-transform: uppercase; letter-spacing: 1px;
        }
        .section-tag i { font-size: 0.7rem; }
        .section-title {
            font-size: clamp(1.8rem, 3vw, 2.6rem);
            font-weight: 800; color: var(--navy);
            line-height: 1.3; margin-bottom: 16px;
        }
        .section-sub {
            color: var(--gray-600); font-size: 1rem;
            max-width: 600px; margin: 0 auto;
            line-height: 1.7;
        }

        .cards-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
            gap: 24px; max-width: 1200px; margin: 0 auto;
        }
        .card {
            background: var(--white);
            border-radius: 16px;
            padding: 32px;
            border: 1px solid var(--gray-200);
            box-shadow: var(--shadow);
            transition: all 0.3s ease;
            position: relative; overflow: hidden;
        }
        .card::before {
            content: '';
            position: absolute; top: 0; left: 0; right: 0;
            height: 4px;
            background: linear-gradient(90deg, var(--red-primary), var(--gold));
            transform: scaleX(0); transform-origin: left;
            transition: transform 0.35s;
        }
        .card:hover { 
            transform: translateY(-8px); 
            box-shadow: 0 20px 40px rgba(0,0,0,0.12);
        }
        .card:hover::before { transform: scaleX(1); }

        .card-icon {
            width: 60px; height: 60px; border-radius: 14px;
            background: linear-gradient(135deg, rgba(218, 37, 29, 0.1), rgba(255, 215, 0, 0.1));
            border: 2px solid rgba(218, 37, 29, 0.2);
            display: grid; place-items: center;
            font-size: 1.6rem; margin-bottom: 20px;
            color: var(--red-primary);
            transition: all 0.3s;
        }
        .card:hover .card-icon {
            background: linear-gradient(135deg, var(--red-primary), var(--red-dark));
            color: var(--white);
            border-color: var(--red-primary);
        }
        .card h3 {
            font-size: 1.2rem; font-weight: 700;
            color: var(--navy); margin-bottom: 12px;
        }
        .card p { 
            color: var(--gray-600); 
            font-size: 0.95rem; 
            line-height: 1.7; 
            margin-bottom: 20px; 
        }
        .card-link {
            display: inline-flex; align-items: center; gap: 8px;
            font-size: 0.9rem; font-weight: 600;
            color: var(--red-primary); text-decoration: none;
            transition: all 0.2s;
        }
        .card-link:hover { 
            gap: 12px; 
            color: var(--red-dark);
        }
        .card-link i { font-size: 0.8rem; }

        /* INFO SECTION */
        .info-section {
            background: linear-gradient(135deg, var(--navy) 0%, var(--navy-dark) 100%);
            position: relative;
            overflow: hidden;
        }
        .info-section::before {
            content: '';
            position: absolute; inset: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><polygon points="50,10 61,35 90,35 68,55 79,80 50,60 21,80 32,55 10,35 39,35" fill="rgba(255,215,0,0.03)"/></svg>');
            background-size: 100px 100px;
        }
        .info-section .section-title { color: var(--white); }
        .info-section .section-sub { color: rgba(255,255,255,0.7); }
        .info-section .section-tag { color: var(--gold); }
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 20px; max-width: 1000px; margin: 0 auto;
            position: relative; z-index: 1;
        }
        .info-card {
            background: rgba(255,255,255,0.05);
            border-radius: 16px; padding: 28px;
            border: 1px solid rgba(255, 215, 0, 0.2);
            backdrop-filter: blur(10px);
            transition: all 0.3s;
        }
        .info-card:hover {
            background: rgba(255, 215, 0, 0.1);
            border-color: var(--gold);
            transform: translateY(-4px);
        }
        .info-card-icon {
            width: 48px; height: 48px;
            background: rgba(255, 215, 0, 0.15);
            border-radius: 12px;
            display: grid; place-items: center;
            color: var(--gold);
            font-size: 1.3rem;
            margin-bottom: 16px;
        }
        .info-card h4 {
            color: var(--gold); font-size: 1.1rem;
            font-weight: 700; margin-bottom: 10px;
        }
        .info-card p {
            color: rgba(255,255,255,0.7);
            font-size: 0.9rem; line-height: 1.6;
        }

        /* CTA SECTION */
        .cta-section {
            padding: 100px 48px;
            background: linear-gradient(135deg, var(--red-primary) 0%, var(--red-dark) 100%);
            text-align: center; position: relative; overflow: hidden;
        }
        .cta-section::before {
            content: '';
            position: absolute; inset: 0;
            background: radial-gradient(ellipse 60% 60% at 50% 50%, rgba(255,215,0,0.15) 0%, transparent 70%);
        }
        .cta-section::after {
            content: '';
            position: absolute; top: 0; left: 0; right: 0; bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><circle cx="50" cy="50" r="40" fill="none" stroke="rgba(255,215,0,0.1)" stroke-width="0.5"/></svg>');
            background-size: 80px 80px;
        }
        .cta-content {
            position: relative; z-index: 1;
            max-width: 700px; margin: 0 auto;
        }
        .cta-section h2 {
            font-size: clamp(1.8rem, 3.5vw, 2.8rem);
            color: var(--white); font-weight: 800; margin-bottom: 16px;
        }
        .cta-section p {
            color: rgba(255,255,255,0.9); font-size: 1.1rem;
            margin-bottom: 36px; line-height: 1.7;
        }
        .cta-btns { 
            display: flex; gap: 16px; 
            justify-content: center; 
            flex-wrap: wrap; 
        }
        .btn-white {
            background: var(--white); color: var(--red-primary);
            font-weight: 700;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
        }
        .btn-white:hover { 
            background: var(--cream); 
            transform: translateY(-2px); 
            box-shadow: 0 8px 25px rgba(0,0,0,0.25);
        }
        .btn-outline-white {
            border: 2px solid rgba(255,255,255,0.5);
            color: var(--white);
            background: transparent;
        }
        .btn-outline-white:hover {
            background: rgba(255,255,255,0.15);
            border-color: var(--white);
        }

        /* FOOTER */
        .main-footer {
            background: var(--navy-dark);
            color: rgba(255,255,255,0.7);
            padding: 60px 48px 0;
        }
        .footer-grid {
            display: grid;
            grid-template-columns: 2fr 1fr 1fr 1fr;
            gap: 40px; max-width: 1200px; margin: 0 auto 40px;
        }
        .footer-brand .footer-logo {
            display: flex; align-items: center; gap: 12px;
            margin-bottom: 16px;
        }
        .footer-brand .footer-logo i {
            width: 40px; height: 40px;
            background: linear-gradient(135deg, var(--red-primary), var(--red-dark));
            border-radius: 50%;
            display: grid; place-items: center;
            color: var(--gold);
            font-size: 1rem;
            border: 2px solid var(--gold);
        }
        .footer-brand h4 {
            color: var(--white); font-size: 1.1rem; font-weight: 700;
        }
        .footer-brand p {
            font-size: 0.9rem; line-height: 1.7;
            color: rgba(255,255,255,0.6);
        }
        .footer-section h5 {
            color: var(--gold); font-size: 0.95rem; font-weight: 700;
            margin-bottom: 20px; text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .footer-section ul {
            list-style: none;
        }
        .footer-section li {
            margin-bottom: 12px;
        }
        .footer-section a {
            color: rgba(255,255,255,0.7);
            text-decoration: none;
            font-size: 0.9rem;
            transition: color 0.2s;
            display: flex; align-items: center; gap: 8px;
        }
        .footer-section a:hover {
            color: var(--gold);
        }
        .footer-section a i {
            font-size: 0.7rem;
            color: var(--red-primary);
        }
        .footer-contact p {
            display: flex; align-items: flex-start; gap: 10px;
            margin-bottom: 12px; font-size: 0.9rem;
        }
        .footer-contact i {
            color: var(--gold); margin-top: 3px;
            width: 16px;
        }
        .footer-bottom {
            border-top: 1px solid rgba(255,255,255,0.1);
            padding: 24px 48px;
            text-align: center;
            font-size: 0.85rem;
            color: rgba(255,255,255,0.5);
        }
        .footer-bottom span { color: var(--gold); }

        /* ANIMATIONS */
        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(30px); }
            to   { opacity: 1; transform: translateY(0); }
        }
        @keyframes floatY {
            0%,100% { transform: translateY(0); }
            50%      { transform: translateY(-12px); }
        }

        .animate { animation: fadeUp 0.7s ease both; }
        .delay-1 { animation-delay: 0.15s; }
        .delay-2 { animation-delay: 0.3s; }
        .delay-3 { animation-delay: 0.45s; }
        .float-animation { animation: floatY 4s ease-in-out infinite; }

        @media (max-width: 1024px) {
            .hero-visual { display: none; }
            .footer-grid { grid-template-columns: 1fr 1fr; }
        }
        @media (max-width: 768px) {
            .navbar { padding: 0 20px; height: 70px; }
            .nav-logo-text .line2 { font-size: 0.9rem; }
            .hero { padding: 120px 20px 60px; }
            .section { padding: 60px 20px; }
            .cta-section { padding: 60px 20px; }
            .cards-grid { grid-template-columns: 1fr; }
            .info-grid { grid-template-columns: 1fr; }
            .footer-grid { grid-template-columns: 1fr; gap: 30px; }
            .main-footer { padding: 40px 20px 0; }
            .footer-bottom { padding: 20px; }
        }
    </style>
</head>
<body>

<!-- GOVERNMENT HEADER -->
<div class="gov-header">
    <i class="fas fa-star" style="margin-right: 8px;"></i>
    CỔNG THÔNG TIN ĐIỆN TỬ - ỦY BAN NHÂN DÂN PHƯỜNG SƠN TÂY, THÀNH PHỐ SƠN TÂY, THÀNH PHỐ HÀ NỘI
</div>

<!-- NAVBAR -->
<nav class="navbar">
    <div class="nav-logo">
        <div class="emblem">
            <i class="fas fa-landmark"></i>
        </div>
        <div class="nav-logo-text">
            <span class="line1">Ủy ban Nhân dân</span>
            <span class="line2">PHƯỜNG SƠN TÂY</span>
        </div>
    </div>
    <div class="nav-actions">
        <a href="${pageContext.request.contextPath}/login" class="btn btn-outline">
            <i class="fas fa-sign-in-alt"></i> Đăng nhập
        </a>
        <a href="${pageContext.request.contextPath}/register" class="btn btn-primary">
            <i class="fas fa-user-plus"></i> Đăng ký
        </a>
    </div>
</nav>

<!-- HERO -->
<section class="hero">
    <div class="hero-pattern"></div>
    <div class="hero-content">
        <div class="hero-badge">
            <i class="fas fa-circle"></i>
            Hệ thống quản lý Tổ dân phố
        </div>
        <h1>Quản lý thông tin<br><span>Tổ dân phố</span><br>số hoá thông minh</h1>
        <p>Hệ thống quản lý thông tin hộ dân, cư dân và tổ dân phố trực thuộc UBND Phường Sơn Tây. Kết nối chính quyền địa phương với người dân một cách hiệu quả, minh bạch.</p>
        <div class="hero-cta">
            <a href="${pageContext.request.contextPath}/login" class="btn btn-gold">
                <i class="fas fa-rocket"></i> Bắt đầu ngay
            </a>
            <a href="#features" class="btn btn-ghost-light">
                <i class="fas fa-info-circle"></i> Tìm hiểu thêm
            </a>
        </div>
    </div>
    <div class="hero-visual">
        <div class="hero-card">
            <div class="hero-card-header">
                <i class="fas fa-chart-line"></i>
                <div>
                    <h3>Thống kê Tổ dân phố</h3>
                    <p>Tình hình cập nhật tháng 3/2025</p>
                </div>
            </div>
            <div class="stat-grid">
                <div class="stat-item">
                    <div class="stat-num">12</div>
                    <div class="stat-label">Tổ dân phố</div>
                </div>
                <div class="stat-item">
                    <div class="stat-num">3.2K</div>
                    <div class="stat-label">Hộ dân</div>
                </div>
                <div class="stat-item">
                    <div class="stat-num">12K</div>
                    <div class="stat-label">Nhân khẩu</div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- FEATURES -->
<section class="section" id="features">
    <div class="section-header animate">
        <div class="section-tag">
            <i class="fas fa-star"></i> Chức năng chính
        </div>
        <h2 class="section-title">Dịch vụ công trực tuyến<br>dành cho cư dân</h2>
        <p class="section-sub">Hệ thống cung cấp đầy đủ công cụ để quản lý thông tin hộ dân, gửi thông báo và tra cứu dữ liệu trực tuyến.</p>
    </div>
    <div class="cards-grid">
        <div class="card animate delay-1">
            <div class="card-icon">
                <i class="fas fa-bullhorn"></i>
            </div>
            <h3>Thông báo công cộng</h3>
            <p>Nhận thông báo chính thức từ UBND phường, tổ dân phố về các vấn đề an ninh trật tự, vệ sinh môi trường và sự kiện cộng đồng.</p>
            <a href="${pageContext.request.contextPath}/thongbao" class="card-link">
                Xem thông báo <i class="fas fa-arrow-right"></i>
            </a>
        </div>
        <div class="card animate delay-2">
            <div class="card-icon">
                <i class="fas fa-home"></i>
            </div>
            <h3>Thông tin Hộ khẩu</h3>
            <p>Tra cứu chi tiết hộ khẩu gia đình, danh sách thành viên, địa chỉ cư trú và các thay đổi về nhân khẩu.</p>
            <a href="${pageContext.request.contextPath}/hodan/my" class="card-link">
                Tra cứu hộ khẩu <i class="fas fa-arrow-right"></i>
            </a>
        </div>
        <div class="card animate delay-3">
            <div class="card-icon">
                <i class="fas fa-id-card"></i>
            </div>
            <h3>Hồ sơ Cá nhân</h3>
            <p>Cập nhật thông tin cá nhân, thay đổi mật khẩu và theo dõi lịch sử các giao dịch với chính quyền địa phương.</p>
            <a href="${pageContext.request.contextPath}/" class="card-link">
                Quản lý hồ sơ <i class="fas fa-arrow-right"></i>
            </a>
        </div>

        <c:if test="${vaiTro == 'Cán bộ tổ dân phố' || vaiTro == 'Tổ trưởng'}">
        <div class="card animate">
            <div class="card-icon">
                <i class="fas fa-users-cog"></i>
            </div>
            <h3>Quản lý Hộ dân Tổ</h3>
            <p>Quản lý danh sách hộ dân trong tổ, cập nhật thông tin nhân khẩu và theo dõi biến động dân cư.</p>
            <a href="${pageContext.request.contextPath}/hodan/list" class="card-link">
                Quản lý hộ dân <i class="fas fa-arrow-right"></i>
            </a>
        </div>
        <div class="card animate delay-1">
            <div class="card-icon">
                <i class="fas fa-paper-plane"></i>
            </div>
            <h3>Gửi Thông báo</h3>
            <p>Gửi thông báo đến cư dân trong tổ dân phố qua hệ thống, hỗ trợ đính kèm file và theo dõi đã đọc.</p>
            <a href="${pageContext.request.contextPath}/thongbao/send" class="card-link">
                Gửi thông báo <i class="fas fa-arrow-right"></i>
            </a>
        </div>
        <div class="card animate delay-2">
            <div class="card-icon">
                <i class="fas fa-file-import"></i>
            </div>
            <h3>Import Dữ liệu</h3>
            <p>Nhập danh sách hộ dân và nhân khẩu mới từ file Excel theo mẫu chuẩn của UBND phường.</p>
            <a href="${pageContext.request.contextPath}/import" class="card-link">
                Import dữ liệu <i class="fas fa-arrow-right"></i>
            </a>
        </div>
        </c:if>

        <c:if test="${vaiTro == 'Admin'}">
        <div class="card animate">
            <div class="card-icon">
                <i class="fas fa-user-shield"></i>
            </div>
            <h3>Quản lý Người dùng</h3>
            <p>Quản lý tài khoản cán bộ phường, tổ trưởng và cư dân trên toàn hệ thống.</p>
            <a href="${pageContext.request.contextPath}/admin/users" class="card-link">
                Quản lý người dùng <i class="fas fa-arrow-right"></i>
            </a>
        </div>
        <div class="card animate delay-1">
            <div class="card-icon">
                <i class="fas fa-chart-pie"></i>
            </div>
            <h3>Báo cáo Thống kê</h3>
            <p>Xem báo cáo tổng hợp về dân số, hộ khẩu và hoạt động của các tổ dân phố.</p>
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="card-link">
                Xem báo cáo <i class="fas fa-arrow-right"></i>
            </a>
        </div>
        </c:if>
    </div>
</section>

<!-- INFO SECTION -->
<section class="section info-section">
    <div class="section-header animate">
        <div class="section-tag">
            <i class="fas fa-info-circle"></i> Về chúng tôi
        </div>
        <h2 class="section-title">Tổ dân phố Phường Sơn Tây</h2>
        <p class="section-sub">Phường Sơn Tây thuộc Thành phố Sơn Tây, Hà Nội, được chia thành 12 tổ dân phố với tổng số hơn 3,200 hộ dân.</p>
    </div>
    <div class="info-grid">
        <div class="info-card animate">
            <div class="info-card-icon">
                <i class="fas fa-map-marker-alt"></i>
            </div>
            <h4>Địa bàn quản lý</h4>
            <p>12 tổ dân phố trải rộng trên địa bàn phường Sơn Tây, bao gồm khu dân cư và các khu chức năng.</p>
        </div>
        <div class="info-card animate delay-1">
            <div class="info-card-icon">
                <i class="fas fa-users"></i>
            </div>
            <h4>Cộng đồng dân cư</h4>
            <p>Hơn 12,000 nhân khẩu sinh sống và làm việc trên địa bàn, với đa dạng các ngành nghề.</p>
        </div>
        <div class="info-card animate delay-2">
            <div class="info-card-icon">
                <i class="fas fa-gavel"></i>
            </div>
            <h4>Chính quyền địa phương</h4>
            <p>UBND Phường Sơn Tây phối hợp với các tổ trưởng tổ dân phố trong công tác quản lý hành chính.</p>
        </div>
    </div>
</section>

<!-- CTA -->
<section class="cta-section">
    <div class="cta-content">
        <h2><i class="fas fa-handshake" style="margin-right: 12px;"></i>Sẵn sàng tham gia?</h2>
        <p>Đăng ký tài khoản để tiếp cận các dịch vụ công trực tuyến của UBND Phường Sơn Tây. Hệ thống hỗ trợ tra cứu thông tin và nhận thông báo từ tổ dân phố.</p>
        <div class="cta-btns">
            <a href="${pageContext.request.contextPath}/register" class="btn btn-white">
                <i class="fas fa-user-plus"></i> Đăng ký tài khoản
            </a>
            <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-white">
                <i class="fas fa-sign-in-alt"></i> Đăng nhập
            </a>
        </div>
    </div>
</section>

<!-- FOOTER -->
<footer class="main-footer">
    <div class="footer-grid">
        <div class="footer-brand">
            <div class="footer-logo">
                <i class="fas fa-landmark"></i>
                <h4>UBND Phường Sơn Tây</h4>
            </div>
            <p>Hệ thống quản lý thông tin hộ dân và tổ dân phố trực thuộc UBND Phường Sơn Tây, Thành phố Sơn Tây, Hà Nội.</p>
        </div>
        <div class="footer-section">
            <h5>Liên kết</h5>
            <ul>
                <li><a href="#"><i class="fas fa-chevron-right"></i> Trang chủ</a></li>
                <li><a href="#features"><i class="fas fa-chevron-right"></i> Tính năng</a></li>
                <li><a href="${pageContext.request.contextPath}/thongbao"><i class="fas fa-chevron-right"></i> Thông báo</a></li>
                <li><a href="${pageContext.request.contextPath}/login"><i class="fas fa-chevron-right"></i> Đăng nhập</a></li>
            </ul>
        </div>
        <div class="footer-section">
            <h5>Tài khoản</h5>
            <ul>
                <li><a href="${pageContext.request.contextPath}/register"><i class="fas fa-chevron-right"></i> Đăng ký</a></li>
                <li><a href="${pageContext.request.contextPath}/login"><i class="fas fa-chevron-right"></i> Đăng nhập</a></li>
                <li><a href="#"><i class="fas fa-chevron-right"></i> Quên mật khẩu</a></li>
                <li><a href="#"><i class="fas fa-chevron-right"></i> Hướng dẫn sử dụng</a></li>
            </ul>
        </div>
        <div class="footer-section footer-contact">
            <h5>Liên hệ</h5>
            <p><i class="fas fa-map-marker-alt"></i> Số 1, Đường Phùng Khắc Khoan, Phường Sơn Tây</p>
            <p><i class="fas fa-phone"></i> (024) 3.xxx.xxxx</p>
            <p><i class="fas fa-envelope"></i> ubnd.sontay@hanoi.gov.vn</p>
            <p><i class="fas fa-clock"></i> Thứ 2 - Thứ 6: 7:30 - 17:00</p>
        </div>
    </div>
    <div class="footer-bottom">
        © 2025 <span>UBND Phường Sơn Tây</span> &nbsp;|&nbsp; Hệ thống Quản lý Tổ dân phố &nbsp;|&nbsp; Thành phố Hà Nội
    </div>
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
        if (window.scrollY > 50) {
            nav.style.boxShadow = '0 4px 20px rgba(0,0,0,0.15)';
        } else {
            nav.style.boxShadow = '0 10px 15px -3px rgba(0, 0, 0, 0.1)';
        }
    });
</script>
</body>
</html>
