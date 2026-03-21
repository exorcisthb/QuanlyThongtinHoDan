<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Dashboard Cán bộ phường</title>
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <style>
            :root{
                --bg:#0f1117;
                --surface:#181c27;
                --surface2:#1f2433;
                --border:#2a3048;
                --accent:#4f8ef7;
                --accent2:#38d9a9;
                --danger:#f75c5c;
                --warn:#fbbf24;
                --text:#e2e8f0;
                --muted:#64748b;
                --radius:14px;
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
            .bell-wrap{position:relative}
            .bell-btn{width:38px;height:38px;border-radius:50%;background:var(--surface2);border:1px solid var(--border);display:flex;align-items:center;justify-content:center;cursor:pointer;font-size:17px;transition:all .18s}
            .bell-btn:hover{background:var(--surface);border-color:var(--accent)}
            .bell-badge{position:absolute;top:-4px;right:-4px;background:var(--danger);color:#fff;font-size:9px;font-weight:700;width:16px;height:16px;border-radius:50%;display:flex;align-items:center;justify-content:center;border:2px solid var(--bg);animation:pulse 2s infinite}
            .bell-badge.hidden{display:none}
            @keyframes pulse{0%,100%{transform:scale(1)}50%{transform:scale(1.2)}}
            .notif-panel{position:absolute;top:calc(100% + 10px);right:0;width:360px;background:var(--surface2);border:1px solid var(--border);border-radius:var(--radius);box-shadow:0 16px 48px rgba(0,0,0,.6);display:none;z-index:400;overflow:hidden}
            .notif-panel.open{display:block;animation:dropDown .18s ease}
            @keyframes dropDown{from{opacity:0;transform:translateY(-8px)}to{opacity:1;transform:translateY(0)}}
            .np-header{padding:14px 18px;border-bottom:1px solid var(--border);display:flex;align-items:center;justify-content:space-between}
            .np-header h4{font-size:14px;font-weight:700}
            .np-actions{display:flex;align-items:center;gap:10px}
            .np-mark{font-size:11px;color:var(--accent);cursor:pointer;font-weight:500}
            .np-mark:hover{text-decoration:underline}
            .np-all{font-size:11px;color:var(--muted);cursor:pointer;font-weight:500;text-decoration:none}
            .np-all:hover{color:var(--text)}
            .np-footer{border-top:1px solid var(--border);padding:11px 18px;text-align:center}
            .np-footer a{font-size:12px;font-weight:600;color:var(--accent);cursor:pointer;transition:color .15s;text-decoration:none;display:block}
            .np-footer a:hover{color:var(--accent2);text-decoration:underline}
            .np-list{max-height:340px;overflow-y:auto}
            .np-list::-webkit-scrollbar{width:4px}
            .np-list::-webkit-scrollbar-thumb{background:var(--border);border-radius:2px}
            .np-item{padding:13px 18px;border-bottom:1px solid var(--border);display:flex;gap:10px;align-items:flex-start;cursor:pointer;transition:background .15s;position:relative}
            .np-item:hover{background:var(--surface)}
            .np-item:last-child{border-bottom:none}
            .np-item.unread{border-left:3px solid var(--accent);padding-left:15px}
            .np-item.unread:hover{background:rgba(79,142,247,.06)}
            .np-dot{width:8px;height:8px;border-radius:50%;background:var(--accent);flex-shrink:0;margin-top:5px}
            .np-dot.read{background:var(--muted)}
            .np-body{flex:1;min-width:0}
            .np-tag{display:inline-block;font-size:9px;font-weight:700;padding:1px 7px;border-radius:10px;margin-bottom:4px;text-transform:uppercase;letter-spacing:.4px}
            .np-tag.yeucau{background:rgba(251,191,36,.15);color:var(--warn)}
            .np-tag.duyet{background:rgba(56,217,169,.15);color:var(--accent2)}
            .np-tag.hethong{background:rgba(79,142,247,.15);color:var(--accent)}
            .np-title{font-size:12px;line-height:1.5;color:var(--text)}
            .np-item.unread .np-title{font-weight:600}
            .np-noidung{font-size:11px;color:var(--muted);margin-top:2px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
            .np-time{font-size:10px;color:var(--muted);margin-top:4px;display:flex;align-items:center;gap:6px}
            .np-arrow{font-size:11px;color:var(--accent);opacity:0;transition:opacity .15s;margin-left:auto;flex-shrink:0;margin-top:5px}
            .np-item:hover .np-arrow{opacity:1}
            .np-status{padding:28px;text-align:center;color:var(--muted);font-size:13px}
            .np-spinner{display:inline-block;width:16px;height:16px;border:2px solid var(--border);border-top-color:var(--accent);border-radius:50%;animation:spin .6s linear infinite;margin-right:8px;vertical-align:middle}
            @keyframes spin{to{transform:rotate(360deg)}}
            .user-menu{position:relative}
            .avatar-btn{display:flex;align-items:center;gap:10px;background:none;border:1px solid transparent;border-radius:40px;padding:5px 14px 5px 5px;cursor:pointer;color:var(--text);font-family:inherit;transition:all .18s}
            .avatar-btn:hover{background:var(--surface2);border-color:var(--border)}
            .avatar{width:34px;height:34px;border-radius:50%;background:linear-gradient(135deg,var(--accent),var(--accent2));display:flex;align-items:center;justify-content:center;font-size:13px;font-weight:700;color:#fff;flex-shrink:0;text-transform:uppercase;overflow:hidden}
            .avatar img{width:100%;height:100%;object-fit:cover}
            .avatar-name{font-size:13px;font-weight:600;line-height:1.2}
            .avatar-role{font-size:11px;color:var(--accent2);font-weight:500}
            .avatar-chevron{font-size:11px;color:var(--muted);transition:transform .2s}
            .avatar-btn.open .avatar-chevron{transform:rotate(180deg)}
            .user-dropdown{position:absolute;top:calc(100% + 10px);right:0;width:250px;background:var(--surface2);border:1px solid var(--border);border-radius:var(--radius);box-shadow:0 16px 48px rgba(0,0,0,.5);display:none;z-index:300;overflow:hidden}
            .user-dropdown.open{display:block;animation:dropDown .18s ease}
            .ud-header{padding:16px;border-bottom:1px solid var(--border);display:flex;align-items:center;gap:12px}
            .ud-header .avatar{width:42px;height:42px;font-size:16px}
            .ud-name{font-size:13px;font-weight:700}
            .ud-email{font-size:11px;color:var(--muted);margin-top:2px}
            .ud-badge{display:inline-flex;align-items:center;gap:4px;font-size:10px;font-weight:600;padding:2px 8px;border-radius:20px;margin-top:5px;background:rgba(56,217,169,.15);color:var(--accent2)}
            .ud-badge::before{content:'';width:5px;height:5px;border-radius:50%;background:currentColor}
            .ud-item{display:flex;align-items:center;gap:10px;padding:10px 16px;font-size:13px;font-weight:500;color:var(--text);text-decoration:none;transition:background .15s}
            .ud-item:hover{background:var(--surface)}
            .ud-item .ud-icon{font-size:16px;width:20px;text-align:center}
            .ud-item.danger{color:var(--danger)}
            .ud-item.danger:hover{background:rgba(247,92,92,.1)}
            .ud-divider{border:none;border-top:1px solid var(--border);margin:4px 0}
            .main{padding-top:64px}
            .content{max-width:1200px;margin:0 auto;padding:40px 32px}
            .hero{background:var(--surface);border:1px solid var(--border);border-radius:var(--radius);padding:32px 36px;margin-bottom:28px;display:flex;align-items:center;justify-content:space-between;position:relative;overflow:hidden}
            .hero::before{content:'';position:absolute;top:-60px;right:-60px;width:260px;height:260px;background:radial-gradient(circle,rgba(79,142,247,.15) 0%,transparent 70%);pointer-events:none}
            .hero::after{content:'';position:absolute;bottom:-50px;right:200px;width:180px;height:180px;background:radial-gradient(circle,rgba(56,217,169,.1) 0%,transparent 70%);pointer-events:none}
            .hero-left h1{font-size:26px;font-weight:800;margin-bottom:6px;letter-spacing:-.5px}
            .hero-left h1 span{color:var(--accent)}
            .hero-left p{font-size:14px;color:var(--muted)}
            .hero-right{display:flex;gap:16px;flex-shrink:0}
            .stat-chip{background:var(--surface2);border:1px solid var(--border);border-radius:12px;padding:16px 22px;text-align:center;min-width:110px}
            .stat-chip .sc-num{font-size:28px;font-weight:800;background:linear-gradient(135deg,var(--accent),var(--accent2));-webkit-background-clip:text;-webkit-text-fill-color:transparent}
            .stat-chip .sc-num.warn{background:none;-webkit-text-fill-color:var(--warn);color:var(--warn)}
            .stat-chip .sc-label{font-size:11px;color:var(--muted);font-weight:500;margin-top:3px}
            .section-title{font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:1.2px;color:var(--muted);margin-bottom:16px}
            .cards-grid{display:grid;grid-template-columns:repeat(2,1fr);gap:16px;margin-bottom:32px}
            .dash-card{background:var(--surface);border:1px solid var(--border);border-radius:var(--radius);padding:36px 32px;text-decoration:none;color:var(--text);transition:border-color .2s,transform .2s,box-shadow .2s;display:block;cursor:pointer}
            .dash-card:hover{transform:translateY(-3px);box-shadow:0 8px 32px rgba(0,0,0,.3)}
            .dash-card.blue:hover{border-color:var(--accent)}
            .dash-card.green:hover{border-color:var(--accent2)}
            .dash-card.orange:hover{border-color:var(--warn)}
            .dc-icon{width:52px;height:52px;border-radius:14px;display:flex;align-items:center;justify-content:center;font-size:26px;margin-bottom:18px}
            .dc-icon.blue{background:rgba(79,142,247,.15)}
            .dc-icon.green{background:rgba(56,217,169,.15)}
            .dc-icon.orange{background:rgba(251,191,36,.12)}
            .dc-title{font-size:17px;font-weight:700;margin-bottom:10px}
            .dc-desc{font-size:14px;color:var(--muted);line-height:1.7;margin-bottom:24px}
            .dc-btn{display:inline-flex;align-items:center;gap:6px;font-size:14px;font-weight:600;padding:10px 20px;border-radius:8px;border:none;cursor:pointer;font-family:inherit;text-decoration:none;transition:all .18s}
            .dc-btn.blue{background:rgba(79,142,247,.15);color:var(--accent)}
            .dc-btn.green{background:rgba(56,217,169,.15);color:var(--accent2)}
            .dc-btn.orange{background:rgba(251,191,36,.12);color:var(--warn)}
            .dc-btn.blue:hover{background:var(--accent);color:#fff}
            .dc-btn.green:hover{background:var(--accent2);color:#000}
            .dc-btn.orange:hover{background:var(--warn);color:#000}
            .activity-card{background:var(--surface);border:1px solid var(--border);border-radius:var(--radius);overflow:hidden}
            .ac-header{padding:20px 24px;border-bottom:1px solid var(--border);display:flex;align-items:center;justify-content:space-between}
            .ac-header h3{font-size:15px;font-weight:700}
            .ac-empty{padding:40px;text-align:center;color:var(--muted);font-size:13px}
            .ac-empty .ac-empty-icon{font-size:32px;margin-bottom:10px}
            @media(max-width:768px){.cards-grid{grid-template-columns:1fr}.hero{flex-direction:column;gap:20px}}
            .pill-cho{background:rgba(251,191,36,.15);color:var(--warn);font-size:11px;font-weight:600;padding:3px 10px;border-radius:20px;display:inline-flex;align-items:center;gap:4px}
            .pill-cho::before{content:'';width:5px;height:5px;border-radius:50%;background:var(--warn)}
            .pill-ok{background:rgba(56,217,169,.15);color:var(--accent2);font-size:11px;font-weight:600;padding:3px 10px;border-radius:20px;display:inline-flex;align-items:center;gap:4px}
            .pill-ok::before{content:'';width:5px;height:5px;border-radius:50%;background:var(--accent2)}
            .pill-no{background:rgba(247,92,92,.15);color:var(--danger);font-size:11px;font-weight:600;padding:3px 10px;border-radius:20px;display:inline-flex;align-items:center;gap:4px}
            .pill-no::before{content:'';width:5px;height:5px;border-radius:50%;background:var(--danger)}
            .pill-tt{background:rgba(56,217,169,.15);color:var(--accent2);font-size:11px;font-weight:600;padding:2px 8px;border-radius:20px}
            .pill-tv{background:rgba(251,191,36,.15);color:var(--warn);font-size:11px;font-weight:600;padding:2px 8px;border-radius:20px}
            .pill-tm{background:rgba(247,92,92,.15);color:var(--danger);font-size:11px;font-weight:600;padding:2px 8px;border-radius:20px}
            .btn-yc-duyet{padding:4px 12px;border-radius:6px;background:rgba(56,217,169,.1);color:var(--accent2);border:1px solid rgba(56,217,169,.25);font-size:11px;font-weight:600;font-family:inherit;cursor:pointer;transition:all .15s}
            .btn-yc-duyet:hover{background:rgba(56,217,169,.22)}
            .btn-yc-tc{padding:4px 12px;border-radius:6px;background:rgba(247,92,92,.1);color:var(--danger);border:1px solid rgba(247,92,92,.25);font-size:11px;font-weight:600;font-family:inherit;cursor:pointer;transition:all .15s}
            .btn-yc-tc:hover{background:rgba(247,92,92,.22)}
            .modal-overlay{display:none;position:fixed;inset:0;z-index:999;background:rgba(0,0,0,.65);backdrop-filter:blur(6px);align-items:center;justify-content:center}
            .modal-overlay.show{display:flex;animation:overlayIn .2s ease}
            @keyframes overlayIn{from{opacity:0}to{opacity:1}}
            .modal{background:var(--surface);border:1px solid var(--border);border-radius:16px;width:580px;max-width:calc(100vw - 32px);max-height:88vh;overflow-y:auto;box-shadow:0 24px 64px rgba(0,0,0,.6);animation:modalIn .22s cubic-bezier(.34,1.56,.64,1)}
            @keyframes modalIn{from{opacity:0;transform:scale(.93) translateY(12px)}to{opacity:1;transform:none}}
            .modal.modal-wide{width:1000px}
            .modal-hdr{display:flex;align-items:center;justify-content:space-between;padding:20px 26px 16px;border-bottom:1px solid var(--border);position:sticky;top:0;background:var(--surface);z-index:1}
            .mhdr-left{display:flex;align-items:center;gap:14px}
            .mico{width:46px;height:46px;border-radius:12px;display:flex;align-items:center;justify-content:center;font-size:20px;flex-shrink:0}
            .mico.warn{background:rgba(251,191,36,.15)}
            .mico.green{background:rgba(56,217,169,.15)}
            .mico.red{background:rgba(247,92,92,.15)}
            .mico.blue{background:rgba(79,142,247,.15)}
            .mtitle{font-size:16px;font-weight:800}
            .msub{font-size:12px;color:var(--muted);margin-top:2px}
            .mclose{width:32px;height:32px;border-radius:8px;border:1px solid var(--border);background:var(--surface2);color:var(--muted);font-size:16px;cursor:pointer;display:flex;align-items:center;justify-content:center;transition:all .18s}
            .mclose:hover{border-color:var(--danger);color:var(--danger)}
            .modal-body{padding:22px 26px}
            .modal-footer{padding:14px 26px 22px;display:flex;gap:10px;justify-content:flex-end;border-top:1px solid var(--border)}
            .modal-body-list{padding:0}
            .ml-type-tabs{display:flex;border-bottom:1px solid var(--border)}
            .ml-type-tab{flex:1;padding:13px 20px;text-align:center;font-size:13px;font-weight:600;cursor:pointer;color:var(--muted);border:none;background:none;font-family:inherit;border-bottom:2px solid transparent;transition:all .18s}
            .ml-type-tab:hover{color:var(--text);background:var(--surface2)}
            .ml-type-tab.active{color:var(--accent);border-bottom-color:var(--accent);background:rgba(79,142,247,.05)}
            .ml-type-tab.active.tab2{color:var(--accent2);border-bottom-color:var(--accent2);background:rgba(56,217,169,.05)}
            .sec-title{font-size:10px;font-weight:700;color:var(--muted);text-transform:uppercase;letter-spacing:.8px;margin-bottom:12px;padding-bottom:8px;border-bottom:1px solid var(--border)}
            .dgrid{display:grid;grid-template-columns:1fr 1fr;gap:12px;margin-bottom:18px}
            .dlbl{font-size:11px;color:var(--muted);margin-bottom:3px;font-weight:600}
            .dval{font-size:14px;font-weight:600}
            .dval.mono{font-family:monospace;color:var(--accent)}
            .dval.muted{color:var(--muted);font-weight:400;font-size:13px}
            .full{grid-column:1/-1}
            .pill{display:inline-block;font-size:11px;font-weight:600;padding:3px 10px;border-radius:20px}
            .p-tt{background:rgba(56,217,169,.15);color:var(--accent2)}
            .p-tv{background:rgba(251,191,36,.15);color:var(--warn)}
            .p-tm{background:rgba(247,92,92,.15);color:var(--danger)}
            .form-group{margin-bottom:14px}
            .form-label{font-size:11px;font-weight:700;color:var(--muted);text-transform:uppercase;letter-spacing:.5px;margin-bottom:8px;display:block}
            .form-textarea{width:100%;background:var(--surface2);border:1px solid var(--border);color:var(--text);padding:10px 14px;border-radius:8px;font-size:14px;font-family:inherit;resize:vertical;min-height:88px;transition:border-color .18s}
            .form-textarea:focus{outline:none;border-color:var(--accent)}
            .form-textarea.red:focus{border-color:var(--danger)}
            .skeleton{background:linear-gradient(90deg,var(--surface2) 25%,var(--border) 50%,var(--surface2) 75%);background-size:200% 100%;animation:shimmer 1.2s infinite;border-radius:6px;height:14px;margin-bottom:8px}
            @keyframes shimmer{0%{background-position:200% 0}100%{background-position:-200% 0}}
            .btn-m{display:inline-flex;align-items:center;gap:8px;padding:9px 22px;border-radius:8px;font-size:13px;font-weight:700;cursor:pointer;font-family:inherit;transition:all .18s;border:none}
            .btn-cancel{background:var(--surface2);color:var(--muted);border:1px solid var(--border)}
            .btn-cancel:hover{background:var(--surface);color:var(--text)}
            .btn-ok{background:rgba(56,217,169,.15);color:var(--accent2);border:1px solid rgba(56,217,169,.3)}
            .btn-ok:hover{background:var(--accent2);color:#000}
            .btn-no{background:rgba(247,92,92,.15);color:var(--danger);border:1px solid rgba(247,92,92,.3)}
            .btn-no:hover{background:var(--danger);color:#fff}
            .btn-goto{background:rgba(79,142,247,.15);color:var(--accent);border:1px solid rgba(79,142,247,.3)}
            .btn-goto:hover{background:var(--accent);color:#fff}
            .btn-m:disabled{opacity:.5;cursor:not-allowed}
            .ml-summary{display:grid;grid-template-columns:repeat(4,1fr);border-bottom:1px solid var(--border)}
            .ml-stat{padding:16px 20px;text-align:center;border-right:1px solid var(--border);cursor:pointer;transition:background .15s}
            .ml-stat:last-child{border-right:none}
            .ml-stat:hover{background:var(--surface2)}
            .ml-stat.active{background:var(--surface2)}
            .ml-stat-num{font-size:22px;font-weight:800;line-height:1}
            .ml-stat-num.all{background:linear-gradient(135deg,var(--accent),var(--accent2));-webkit-background-clip:text;-webkit-text-fill-color:transparent}
            .ml-stat-num.cho{color:var(--warn)}
            .ml-stat-num.ok{color:var(--accent2)}
            .ml-stat-num.no{color:var(--danger)}
            .ml-stat-lbl{font-size:10px;color:var(--muted);margin-top:3px;font-weight:500}
            .ml-toolbar{padding:12px 20px;border-bottom:1px solid var(--border);display:flex;align-items:center;gap:10px;flex-wrap:wrap}
            .ml-toolbar-title{font-size:13px;font-weight:700}
            .ml-tabs{display:flex;gap:6px}
            .ml-tab{padding:4px 12px;border-radius:20px;border:1px solid var(--border);background:var(--surface2);font-size:11px;font-weight:600;cursor:pointer;color:var(--muted);font-family:inherit;transition:all .15s}
            .ml-tab:hover{border-color:var(--accent);color:var(--text)}
            .ml-tab.active{background:var(--accent);color:#fff;border-color:var(--accent)}
            .ml-goto{margin-left:auto;font-size:12px;color:var(--accent);text-decoration:none;font-weight:600;white-space:nowrap}
            .ml-goto:hover{text-decoration:underline}
            .ml-scroll{overflow-x:auto;max-height:420px;overflow-y:auto}
            .ml-scroll::-webkit-scrollbar{width:4px;height:4px}
            .ml-scroll::-webkit-scrollbar-thumb{background:var(--border);border-radius:2px}
            .ml-table{width:100%;border-collapse:collapse;font-size:13px}
            .ml-table th{padding:9px 14px;text-align:left;color:var(--muted);font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:.5px;border-bottom:1px solid var(--border);white-space:nowrap;background:rgba(255,255,255,.02);position:sticky;top:0;z-index:1}
            .ml-table td{padding:10px 14px;border-bottom:1px solid rgba(42,48,72,.5);vertical-align:middle;white-space:nowrap}
            .ml-table tbody tr:hover td{background:var(--surface2)}
            .ml-table tbody tr:last-child td{border-bottom:none}
            .ml-loading{padding:32px;text-align:center;color:var(--muted);font-size:13px}
            .ml-empty{padding:32px;text-align:center;color:var(--muted);font-size:13px}
            .toast{position:fixed;bottom:28px;right:28px;z-index:9999;padding:13px 22px;border-radius:10px;font-size:13px;font-weight:600;display:none;align-items:center;gap:10px;box-shadow:0 8px 32px rgba(0,0,0,.4);max-width:400px}
            .toast.show{display:flex;animation:slideUp .25s ease}
            .toast.success{background:rgba(56,217,169,.15);border:1px solid rgba(56,217,169,.4);color:var(--accent2)}
            .toast.error{background:rgba(247,92,92,.15);border:1px solid rgba(247,92,92,.4);color:var(--danger)}
            @keyframes slideUp{from{opacity:0;transform:translateY(14px)}to{opacity:1;transform:translateY(0)}}

            /* ══ MODAL THÔNG BÁO TOÀN BỘ ══ */
            .modal-tb{background:var(--surface);border:1px solid var(--border);border-radius:16px;width:640px;max-width:calc(100vw - 32px);max-height:88vh;display:flex;flex-direction:column;box-shadow:0 24px 64px rgba(0,0,0,.6);animation:modalIn .22s cubic-bezier(.34,1.56,.64,1)}
            .tb-hdr{padding:20px 24px 16px;border-bottom:1px solid var(--border);display:flex;align-items:center;justify-content:space-between;flex-shrink:0}
            .tb-hdr-left{display:flex;align-items:center;gap:12px}
            .tb-hdr-ico{width:44px;height:44px;border-radius:12px;background:rgba(79,142,247,.15);display:flex;align-items:center;justify-content:center;font-size:20px;flex-shrink:0}
            .tb-hdr-title{font-size:16px;font-weight:800}
            .tb-hdr-sub{font-size:12px;color:var(--muted);margin-top:2px}
            .tb-toolbar{padding:12px 20px;border-bottom:1px solid var(--border);display:flex;align-items:center;gap:10px;flex-wrap:wrap;flex-shrink:0}
            .tb-filter-tabs{display:flex;gap:6px}
            .tb-ftab{padding:4px 12px;border-radius:20px;border:1px solid var(--border);background:var(--surface2);font-size:11px;font-weight:600;cursor:pointer;color:var(--muted);font-family:inherit;transition:all .15s}
            .tb-ftab:hover{border-color:var(--accent);color:var(--text)}
            .tb-ftab.active{background:var(--accent);color:#fff;border-color:var(--accent)}
            .tb-mark-all{margin-left:auto;font-size:11px;color:var(--accent2);cursor:pointer;font-weight:600;border:none;background:none;font-family:inherit;padding:0}
            .tb-mark-all:hover{text-decoration:underline}
            .tb-list{flex:1;overflow-y:auto;min-height:0}
            .tb-list::-webkit-scrollbar{width:4px}
            .tb-list::-webkit-scrollbar-thumb{background:var(--border);border-radius:2px}
            .tb-item{padding:16px 22px;border-bottom:1px solid var(--border);display:flex;gap:14px;align-items:flex-start;cursor:pointer;transition:background .12s}
            .tb-item:hover{background:var(--surface2)}
            .tb-item:last-child{border-bottom:none}
            .tb-item.unread{border-left:3px solid var(--accent);padding-left:19px}
            .tb-item.unread:hover{background:rgba(79,142,247,.05)}
            .tb-dot{width:9px;height:9px;border-radius:50%;background:var(--accent);flex-shrink:0;margin-top:5px;transition:background .2s}
            .tb-dot.read{background:var(--border)}
            .tb-body{flex:1;min-width:0}
            .tb-tag{display:inline-block;font-size:9px;font-weight:700;padding:1px 7px;border-radius:10px;margin-bottom:5px;text-transform:uppercase;letter-spacing:.4px}
            .tb-tag.yeucau{background:rgba(251,191,36,.15);color:var(--warn)}
            .tb-tag.duyet{background:rgba(56,217,169,.15);color:var(--accent2)}
            .tb-tag.hethong{background:rgba(79,142,247,.15);color:var(--accent)}
            .tb-title{font-size:13px;font-weight:500;line-height:1.45;color:var(--muted);margin-bottom:5px}
            .tb-item.unread .tb-title{font-weight:700;color:var(--text)}
            .tb-preview{font-size:12px;color:var(--muted);line-height:1.5;margin-bottom:6px;display:-webkit-box;-webkit-line-clamp:2;-webkit-box-orient:vertical;overflow:hidden}
            .tb-meta{display:flex;align-items:center;gap:10px;flex-wrap:wrap}
            .tb-time{font-size:11px;color:var(--muted)}
            .tb-sender{font-size:11px;color:var(--muted)}
            .tb-arrow{font-size:12px;color:var(--accent);opacity:0;transition:opacity .15s;flex-shrink:0;margin-top:4px}
            .tb-item:hover .tb-arrow{opacity:1}
            .tb-empty{padding:60px 20px;text-align:center;color:var(--muted)}
            .tb-empty-ico{font-size:40px;margin-bottom:14px;opacity:.5}
            .tb-empty p{font-size:13px}
            .tb-footer{padding:14px 24px;border-top:1px solid var(--border);display:flex;gap:10px;justify-content:flex-end;flex-shrink:0}

            /* ══ MODAL ĐĂNG XUẤT ══ */
            .logout-overlay{display:none;position:fixed;inset:0;z-index:9999;background:rgba(0,0,0,.7);backdrop-filter:blur(6px);align-items:center;justify-content:center}
            .logout-overlay.show{display:flex;animation:fadeIn .2s ease}
            @keyframes fadeIn{from{opacity:0}to{opacity:1}}
            .logout-box,.tc-box{background:var(--surface);border:1px solid var(--border);border-radius:16px;width:380px;max-width:calc(100vw - 32px);box-shadow:0 24px 64px rgba(0,0,0,.6);overflow:hidden;animation:popIn .22s cubic-bezier(.34,1.56,.64,1)}
            .tc-box{width:440px}
            @keyframes popIn{from{opacity:0;transform:scale(.93) translateY(10px)}to{opacity:1;transform:none}}
            .logout-body{padding:28px 28px 20px;text-align:center}
            .logout-ico{font-size:40px;margin-bottom:14px}
            .logout-title{font-size:17px;font-weight:800;margin-bottom:6px}
            .logout-sub{font-size:13px;color:var(--muted);line-height:1.5}
            .logout-footer,.tc-footer{padding:16px 24px 24px;display:flex;gap:10px}
            .btn-lo-cancel,.btn-tc-cancel{flex:1;height:40px;border-radius:10px;background:var(--surface2);border:1px solid var(--border);color:var(--muted);font-size:13px;font-weight:600;font-family:inherit;cursor:pointer;transition:all .15s}
            .btn-lo-cancel:hover,.btn-tc-cancel:hover{border-color:var(--text);color:var(--text)}
            .btn-lo-confirm{flex:1;height:40px;border-radius:10px;background:var(--danger);border:none;color:#fff;font-size:13px;font-weight:700;font-family:inherit;cursor:pointer;transition:opacity .15s}
            .btn-lo-confirm:hover{opacity:.85}
            .btn-tc-confirm{flex:1;height:40px;border-radius:10px;background:rgba(247,92,92,.15);border:1px solid rgba(247,92,92,.3);color:var(--danger);font-size:13px;font-weight:700;font-family:inherit;cursor:pointer;transition:all .15s}
            .btn-tc-confirm:hover{background:var(--danger);color:#fff}
            .btn-tc-confirm:disabled{opacity:.5;cursor:not-allowed}
            /* tc body */
            .tc-hdr{padding:20px 24px 16px;display:flex;align-items:center;gap:12px;border-bottom:1px solid var(--border)}
            .tc-ico{width:44px;height:44px;border-radius:12px;background:rgba(247,92,92,.15);display:flex;align-items:center;justify-content:center;font-size:20px;flex-shrink:0}
            .tc-title{font-size:15px;font-weight:800}
            .tc-sub{font-size:12px;color:var(--muted);margin-top:2px}
            .tc-body{padding:18px 24px 4px}
            .tc-label{font-size:11px;font-weight:700;color:var(--muted);text-transform:uppercase;letter-spacing:.5px;margin-bottom:8px;display:block}
            .tc-textarea{width:100%;background:var(--surface2);border:1px solid var(--border);color:var(--text);padding:10px 14px;border-radius:10px;font-size:14px;font-family:inherit;resize:none;height:88px;transition:border-color .18s;outline:none;line-height:1.6}
            .tc-textarea:focus{border-color:var(--danger);box-shadow:0 0 0 3px rgba(247,92,92,.1)}
            .tc-textarea.err{border-color:var(--danger)}
            .tc-err{font-size:11px;color:var(--danger);margin-top:5px;margin-bottom:0;display:none}
            .tc-err.show{display:block}
        </style>
    </head>
    <body>

        <header class="topbar">
            <a href="${pageContext.request.contextPath}/canbophuong/dashboard" class="topbar-logo">
                <div class="logo-icon">🏘</div>
                <div class="logo-text">Quản lý <span>Hộ dân</span></div>
            </a>
            <div class="topbar-divider"></div>
            <span class="topbar-title">Cán bộ phường</span>
            <div class="topbar-spacer"></div>

            <div class="bell-wrap" id="bellWrap">
                <button class="bell-btn" onclick="toggleNotif(event)" title="Thông báo">
                    🔔
                    <span class="bell-badge hidden" id="bellBadge">0</span>
                </button>
                <div class="notif-panel" id="notifPanel">
                    <div class="np-header">
                        <h4>Thông báo</h4>
                        <div class="np-actions">
                            <span class="np-mark" onclick="markAllRead()">Đánh dấu đã đọc</span>
                            <a href="${pageContext.request.contextPath}/thong-bao/lich-su" class="np-all">Xem tất cả →</a>
                        </div>
                    </div>
                    <div class="np-list" id="notifList">
                        <div class="np-status"><span class="np-spinner"></span>Đang tải...</div>
                    </div>
                    <div class="np-footer">
                        <a href="${pageContext.request.contextPath}/thong-bao/lich-su">Xem tất cả thông báo</a>
                    </div>
                </div>
            </div>

            <div class="user-menu">
                <button class="avatar-btn" id="avatarBtn" onclick="toggleMenu()">
                    <div class="avatar">
                        <c:choose>
                            <c:when test="${not empty currentUser.avatarPath}">
                                <img src="${pageContext.request.contextPath}/${currentUser.avatarPath}" alt="avatar">
                            </c:when>
                            <c:otherwise>${currentUser.ten.substring(0,1)}</c:otherwise>
                        </c:choose>
                    </div>
                    <div class="avatar-info">
                        <div class="avatar-name">${currentUser.ho} ${currentUser.ten}</div>
                        <div class="avatar-role">Cán bộ phường</div>
                    </div>
                    <span class="avatar-chevron">▼</span>
                </button>
                <div class="user-dropdown" id="userDropdown">
                    <div class="ud-header">
                        <div class="avatar">
                            <c:choose>
                                <c:when test="${not empty currentUser.avatarPath}">
                                    <img src="${pageContext.request.contextPath}/${currentUser.avatarPath}" alt="avatar">
                                </c:when>
                                <c:otherwise>${currentUser.ten.substring(0,1)}</c:otherwise>
                            </c:choose>
                        </div>
                        <div>
                            <div class="ud-name">${currentUser.ho} ${currentUser.ten}</div>
                            <div class="ud-email">${currentUser.email}</div>
                            <span class="ud-badge">Đang hoạt động</span>
                        </div>
                    </div>
                    <a class="ud-item" href="${pageContext.request.contextPath}/profile"><span class="ud-icon">👤</span> Thông tin cá nhân</a>
                    <a class="ud-item" href="${pageContext.request.contextPath}/change_password"><span class="ud-icon">🔑</span> Đổi mật khẩu</a>
                    <hr class="ud-divider">
                    <div class="ud-item danger" onclick="showLogoutModal()">
                        <span class="ud-icon">🚪</span> Đăng xuất
                    </div>
                </div>
            </div>
        </header>

        <main class="main">
            <div class="content">
                <div class="hero">
                    <div class="hero-left">
                        <h1>Xin chào, <span>${currentUser.ten}</span> 👋</h1>
                        <p>Cán bộ phường — Chào mừng quay lại hệ thống quản lý</p>
                    </div>
                    <div class="hero-right">
                        <div class="stat-chip">
                            <div class="sc-num">--</div>
                            <div class="sc-label">Hộ dân</div>
                        </div>
                        <div class="stat-chip">
                            <div class="sc-num">--</div>
                            <div class="sc-label">Nhân khẩu</div>
                        </div>
                        <div class="stat-chip">
                            <div class="sc-num warn" id="statChoDuyet">--</div>
                            <div class="sc-label">Chờ duyệt</div>
                        </div>
                    </div>
                </div>

                <div class="section-title">Chức năng chính</div>
                <div class="cards-grid">
                    <a href="${pageContext.request.contextPath}/canbophuong/hodan" class="dash-card blue">
                        <div class="dc-icon blue">&#x1F4CB;</div>
                        <div class="dc-title">Quản lý hộ dân</div>
                        <div class="dc-desc">Xem danh sách, thêm, sửa, xóa thông tin hộ khẩu trong toàn phường.</div>
                        <span class="dc-btn blue">Xem danh sách &#8594;</span>
                    </a>
                    <div class="dash-card green" onclick="openModalYCList()">
                        <div class="dc-icon green">&#x1F4DD;</div>
                        <div class="dc-title">Duyệt yêu cầu</div>
                        <div class="dc-desc">Xem xét và xử lý các yêu cầu từ tổ trưởng và hộ dân.</div>
                        <span class="dc-btn green">Xem yêu cầu &#8594;</span>
                    </div>
                </div>

                <div class="section-title">Hoạt động gần đây</div>
                <div class="activity-card">
                    <div class="ac-header"><h3>Nhật ký hoạt động</h3></div>
                    <div class="ac-empty">
                        <div class="ac-empty-icon">📭</div>
                        <p>Chưa có hoạt động nào gần đây</p>
                    </div>
                </div>
            </div>
        </main>

        <!-- ══ MODAL TẤT CẢ THÔNG BÁO ══ -->
        <div class="modal-overlay" id="modalTatCaTB" onclick="if(event.target===this)closeM('modalTatCaTB')">
            <div class="modal-tb">
                <div class="tb-hdr">
                    <div class="tb-hdr-left">
                        <div class="tb-hdr-ico">🔔</div>
                        <div>
                            <div class="tb-hdr-title">Tất cả thông báo</div>
                            <div class="tb-hdr-sub" id="tbSub">Đang tải...</div>
                        </div>
                    </div>
                    <button class="mclose" onclick="closeM('modalTatCaTB')">✕</button>
                </div>
                <div class="tb-toolbar">
                    <div class="tb-filter-tabs">
                        <button class="tb-ftab active" data-f="all"    onclick="tbFilter('all',this)">Tất cả</button>
                        <button class="tb-ftab"        data-f="unread" onclick="tbFilter('unread',this)">Chưa đọc</button>
                        <button class="tb-ftab"        data-f="read"   onclick="tbFilter('read',this)">Đã đọc</button>
                    </div>
                    <button class="tb-mark-all" id="tbMarkAllBtn" onclick="tbMarkAllRead()">✓ Đánh dấu tất cả đã đọc</button>
                </div>
                <div class="tb-list" id="tbList">
                    <div class="tb-empty" id="tbLoading">
                        <div class="tb-empty-ico">⏳</div>
                        <p><span class="np-spinner"></span> Đang tải...</p>
                    </div>
                </div>
                <div class="tb-footer">
                    <button class="btn-m btn-cancel" onclick="closeM('modalTatCaTB')">Đóng</button>
                    <a href="${pageContext.request.contextPath}/thong-bao" class="btn-m btn-goto">Trang lịch sử đầy đủ &#8594;</a>
                </div>
            </div>
        </div>

        <!-- MODAL DANH SÁCH YÊU CẦU -->
        <div class="modal-overlay" id="modalYCList" onclick="closeMOutside(event, 'modalYCList')">
            <div class="modal modal-wide">
                <div class="modal-hdr">
                    <div class="mhdr-left">
                        <div class="mico green" id="mlIco">📋</div>
                        <div>
                            <div class="mtitle" id="mlTitle">Danh sách yêu cầu</div>
                            <div class="msub" id="mlSub">Đang tải...</div>
                        </div>
                    </div>
                    <button class="mclose" onclick="closeM('modalYCList')">✕</button>
                </div>
                <div class="modal-body modal-body-list">
                    <div class="ml-type-tabs">
                        <button class="ml-type-tab active" id="typeTab1" onclick="mlTypeFilter(1)">🏠 Cư trú</button>
                        <button class="ml-type-tab tab2"   id="typeTab2" onclick="mlTypeFilter(2)">👤 Thông tin cá nhân</button>
                    </div>
                    <div class="ml-summary" id="mlSummary">
                        <div class="ml-stat"><div class="ml-stat-num all" id="ml_total">--</div><div class="ml-stat-lbl">Tổng</div></div>
                        <div class="ml-stat"><div class="ml-stat-num cho"  id="ml_cho">--</div><div class="ml-stat-lbl">⏳ Chờ duyệt</div></div>
                        <div class="ml-stat"><div class="ml-stat-num ok"   id="ml_ok">--</div><div class="ml-stat-lbl">✅ Đã duyệt</div></div>
                        <div class="ml-stat"><div class="ml-stat-num no"   id="ml_no">--</div><div class="ml-stat-lbl">❌ Từ chối</div></div>
                    </div>
                    <div class="ml-toolbar">
                        <span class="ml-toolbar-title">Yêu cầu</span>
                        <div class="ml-tabs" id="mlTabs">
                            <button class="ml-tab active" data-filter="all"    onclick="mlFilter('all', this)">Tất cả</button>
                            <button class="ml-tab"         data-filter="cho"    onclick="mlFilter('cho', this)">⏳ Chờ duyệt</button>
                            <button class="ml-tab"         data-filter="duyet"  onclick="mlFilter('duyet', this)">✅ Đã duyệt</button>
                            <button class="ml-tab"         data-filter="tuchoi" onclick="mlFilter('tuchoi', this)">❌ Từ chối</button>
                        </div>
                        <a href="${pageContext.request.contextPath}/yeu-cau-doi-trang-thai" class="ml-goto">Trang đầy đủ &#8594;</a>
                    </div>
                    <div class="ml-scroll">
                        <div class="ml-loading" id="mlLoading"><span class="np-spinner"></span> Đang tải dữ liệu...</div>
                        <table class="ml-table" id="mlTable" style="display:none">
                            <thead id="mlThead"><tr>
                                <th>Mã hộ</th><th>Chủ hộ</th><th>Tổ</th>
                                <th>Cũ → Mới</th><th>Ngày gửi</th><th>Trạng thái</th>
                                <th style="text-align:center">Thao tác</th>
                            </tr></thead>
                            <tbody id="mlTbody"></tbody>
                        </table>
                        <div class="ml-empty" id="mlEmpty" style="display:none">Không có yêu cầu nào</div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button class="btn-m btn-cancel" onclick="closeM('modalYCList')">Đóng</button>
                    <a href="${pageContext.request.contextPath}/yeu-cau-doi-trang-thai" class="btn-m btn-goto">Xem trang đầy đủ &#8594;</a>
                </div>
            </div>
        </div>

        <!-- MODAL CHI TIẾT YÊU CẦU -->
        <div class="modal-overlay" id="modalYeuCau" onclick="closeMOutside(event, 'modalYeuCau')">
            <div class="modal" id="modalYeuCauBox">
                <div class="modal-hdr">
                    <div class="mhdr-left">
                        <div class="mico warn" id="myc_ico">📋</div>
                        <div>
                            <div class="mtitle" id="myc_title">Chi tiết yêu cầu</div>
                            <div class="msub" id="myc_sub">—</div>
                        </div>
                    </div>
                    <button class="mclose" onclick="closeM('modalYeuCau')">✕</button>
                </div>
                <div class="modal-body" id="myc_body">
                    <div id="myc_skeleton">
                        <div class="skeleton" style="width:40%;height:10px;margin-bottom:14px"></div>
                        <div style="display:grid;grid-template-columns:1fr 1fr;gap:12px;margin-bottom:18px">
                            <div><div class="skeleton" style="width:60%;height:10px"></div><div class="skeleton" style="height:14px;margin-top:4px"></div></div>
                            <div><div class="skeleton" style="width:60%;height:10px"></div><div class="skeleton" style="height:14px;margin-top:4px"></div></div>
                            <div><div class="skeleton" style="width:60%;height:10px"></div><div class="skeleton" style="height:14px;margin-top:4px"></div></div>
                            <div><div class="skeleton" style="width:60%;height:10px"></div><div class="skeleton" style="height:14px;margin-top:4px"></div></div>
                            <div style="grid-column:1/-1"><div class="skeleton" style="width:40%;height:10px"></div><div class="skeleton" style="height:14px;margin-top:4px;width:90%"></div></div>
                        </div>
                    </div>
                    <div id="myc_content" style="display:none"></div>
                </div>
                <div class="modal-footer" id="myc_footer">
                    <button class="btn-m btn-cancel" onclick="closeM('modalYeuCau')">Đóng</button>
                </div>
            </div>
        </div>

        <!-- ══ MODAL ĐĂNG XUẤT ══ -->
        <div class="logout-overlay" id="logoutModal" onclick="if(event.target===this)hideLogoutModal()">
            <div class="logout-box">
                <div class="logout-body">
                    <div class="logout-ico">🚪</div>
                    <div class="logout-title">Đăng xuất?</div>
                    <div class="logout-sub">Bạn sẽ được đưa về trang đăng nhập.<br>Mọi phiên làm việc hiện tại sẽ kết thúc.</div>
                </div>
                <div class="logout-footer">
                    <button class="btn-lo-cancel" onclick="hideLogoutModal()">Ở lại</button>
                    <button class="btn-lo-confirm" onclick="window.location.href=CTX+'/logout'">🚪 Đăng xuất</button>
                </div>
            </div>
        </div>

        <!-- ══ MODAL TỪ CHỐI YÊU CẦU ══ -->
        <div class="logout-overlay" id="modalTuChoi" onclick="if(event.target===this)closeTuChoi()">
            <div class="tc-box">
                <div class="tc-hdr">
                    <div class="tc-ico">✕</div>
                    <div>
                        <div class="tc-title">Từ chối yêu cầu</div>
                        <div class="tc-sub">Hộ dân sẽ được thông báo lý do từ chối</div>
                    </div>
                </div>
                <div class="tc-body">
                    <label class="tc-label">Lý do từ chối <span style="color:var(--danger)">*</span></label>
                    <textarea class="tc-textarea" id="tcLyDo" placeholder="Nhập lý do từ chối yêu cầu này..."></textarea>
                    <div class="tc-err" id="tcErr">Vui lòng nhập lý do từ chối.</div>
                </div>
                <div class="tc-footer">
                    <button class="btn-tc-cancel" onclick="closeTuChoi()">Hủy bỏ</button>
                    <button class="btn-tc-confirm" id="btnConfirmTC2" onclick="confirmTuChoi()">✕ Xác nhận từ chối</button>
                </div>
            </div>
        </div>

        <div class="toast" id="toast"></div>

        <script>
    const CTX = '${pageContext.request.contextPath}';
    let notifLoaded  = false;
    let _activeYeuCauID = null;
    var _mlData   = [];
    var _mlFilter = 'all';
    var _mlLoaded = false;
    var _mlType   = 1;

    /* ══ ALL-NOTIFICATIONS MODAL ══ */
    var _tbData      = [];
    var _tbLoaded    = false;
    var _tbFilter    = 'all';

    function openModalTatCaThongBao() {
        openM('modalTatCaTB');
        if (_tbLoaded) {
            renderTbList(_tbFilter);
            return;
        }
        document.getElementById('tbList').innerHTML =
            '<div class="tb-empty" id="tbLoading"><div class="tb-empty-ico">⏳</div><p><span class="np-spinner"></span> Đang tải...</p></div>';
        fetch(CTX + '/thong-bao?action=list', {credentials: 'include'})
            .then(function(r) { if (!r.ok) throw new Error('HTTP ' + r.status); return r.json(); })
            .then(function(data) {
                _tbData   = data.danhSach || [];
                _tbLoaded = true;
                var chuaDoc = (data.chuaDoc || 0);
                document.getElementById('tbSub').textContent =
                    _tbData.length + ' thông báo · ' + chuaDoc + ' chưa đọc';
                document.getElementById('tbMarkAllBtn').style.display = chuaDoc > 0 ? '' : 'none';
                renderTbList('all');
                updateBadge(chuaDoc);
            })
            .catch(function(err) {
                document.getElementById('tbList').innerHTML =
                    '<div class="tb-empty"><div class="tb-empty-ico">⚠️</div><p>Lỗi: ' + err.message + '</p></div>';
            });
    }

    function tbFilter(f, btn) {
        _tbFilter = f;
        document.querySelectorAll('.tb-ftab').forEach(function(b) { b.classList.remove('active'); });
        if (btn) btn.classList.add('active');
        renderTbList(f);
    }

    function renderTbList(filter) {
        var list = _tbData;
        if (filter === 'unread') list = _tbData.filter(function(n) { return !n.daDoc; });
        else if (filter === 'read')  list = _tbData.filter(function(n) { return  n.daDoc; });

        var el = document.getElementById('tbList');
        if (!list.length) {
            el.innerHTML = '<div class="tb-empty"><div class="tb-empty-ico">📭</div><p>'
                + (filter === 'unread' ? 'Không có thông báo chưa đọc' : 'Không có thông báo nào') + '</p></div>';
            return;
        }
        el.innerHTML = list.map(function(n) {
            var tag     = detectTag(n.tieuDe);
            var time    = formatTime(n.ngayGui);
            var unread  = !n.daDoc;
            var preview = (n.noiDung || '').substring(0, 100) + ((n.noiDung||'').length > 100 ? '…' : '');
            var sender  = n.tenNguoiGui ? '· ' + esc(n.tenNguoiGui) : '';
            return '<div class="tb-item ' + (unread ? 'unread' : '') + '"'
                + ' id="tbitem-' + n.thongBaoID + '"'
                + ' onclick="tbClickItem(' + n.thongBaoID + ',' + unread + ')">'
                + '<div class="tb-dot ' + (unread ? '' : 'read') + '" id="tbdot-' + n.thongBaoID + '"></div>'
                + '<div class="tb-body">'
                + '<div class="tb-tag ' + tag.cls + '">' + tag.label + '</div>'
                + '<div class="tb-title">' + esc(n.tieuDe) + '</div>'
                + (preview ? '<div class="tb-preview">' + esc(preview) + '</div>' : '')
                + '<div class="tb-meta"><span class="tb-time">' + time + '</span>'
                + (sender ? '<span class="tb-sender">' + sender + '</span>' : '')
                + '</div></div>'
                + '<span class="tb-arrow">→</span></div>';
        }).join('');
    }

    function tbClickItem(id, isUnread) {
        if (isUnread) {
            fetch(CTX + '/thong-bao', {
                method: 'POST', headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                body: new URLSearchParams({action: 'doc', id: id}).toString(), credentials: 'include'
            }).then(r => r.json()).then(function() {
                var item = document.getElementById('tbitem-' + id);
                var dot  = document.getElementById('tbdot-'  + id);
                if (item) { item.classList.remove('unread'); }
                if (dot)  { dot.classList.add('read'); }
                // sync _tbData
                var entry = _tbData.find(function(n){ return n.thongBaoID == id; });
                if (entry) entry.daDoc = true;
                // update badge
                var remaining = _tbData.filter(function(n){ return !n.daDoc; }).length;
                updateBadge(remaining);
                document.getElementById('tbSub').textContent =
                    _tbData.length + ' thông báo · ' + remaining + ' chưa đọc';
                if (remaining === 0) document.getElementById('tbMarkAllBtn').style.display = 'none';
                // sync notif panel
                var nitem = document.getElementById('nitem-' + id);
                var ndot  = document.getElementById('ndot-'  + id);
                if (nitem) nitem.classList.remove('unread');
                if (ndot)  ndot.classList.add('read');
            }).catch(function(){});
        }
    }

    function tbMarkAllRead() {
        fetch(CTX + '/thong-bao', {
            method: 'POST', headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: 'action=docTatCa', credentials: 'include'
        }).then(r => r.json()).then(function(data) {
            if (data.success) {
                _tbData.forEach(function(n){ n.daDoc = true; });
                renderTbList(_tbFilter);
                updateBadge(0);
                document.getElementById('tbMarkAllBtn').style.display = 'none';
                document.getElementById('tbSub').textContent = _tbData.length + ' thông báo · 0 chưa đọc';
                // sync notif panel
                document.querySelectorAll('.np-item.unread').forEach(function(el){ el.classList.remove('unread'); });
                document.querySelectorAll('.np-dot').forEach(function(d){ d.classList.add('read'); });
                notifLoaded = false;
                showToast('success', '✓ Đã đánh dấu tất cả đã đọc');
            }
        }).catch(function(){});
    }

    /* ══ BELL ══ */

    function showLogoutModal() {
        closeUserMenu();
        document.getElementById('logoutModal').classList.add('show');
        document.body.style.overflow = 'hidden';
    }
    function hideLogoutModal() {
        document.getElementById('logoutModal').classList.remove('show');
        document.body.style.overflow = '';
    }
    function closeUserMenu() {
        var dd = document.getElementById('userDropdown');
        var btn = document.getElementById('avatarBtn');
        if (dd) dd.classList.remove('open');
        if (btn) btn.classList.remove('open');
    }

    function toggleNotif(e) {
        if (e) e.stopPropagation();
        closeUserMenu();
        var panel = document.getElementById('notifPanel');
        var isOpen = panel.classList.toggle('open');
        if (isOpen && !notifLoaded) loadNotifs();
    }

    function loadNotifs() {
        var listEl = document.getElementById('notifList');
        if (listEl) listEl.innerHTML = '<div class="np-status"><span class="np-spinner"></span>Đang tải...</div>';
        fetch(CTX + '/thong-bao?action=list', {credentials: 'include'})
                .then(function(r) { if (!r.ok) throw new Error('HTTP ' + r.status); return r.json(); })
                .then(function(data) {
                    notifLoaded = true;
                    _tbData = data.danhSach || [];
                    _tbLoaded = true;
                    renderNotifs(data.danhSach || []);
                    updateBadge(data.chuaDoc || 0);
                })
                .catch(function(err) {
                    if (listEl) listEl.innerHTML = '<div class="np-status">⚠ Lỗi: ' + err.message + '</div>';
                });
    }

    function renderNotifs(list) {
        const el = document.getElementById('notifList');
        if (!list.length) { el.innerHTML = '<div class="np-status">📭 Chưa có thông báo nào</div>'; return; }
        el.innerHTML = list.slice(0, 15).map(function(n) {
            var tag    = detectTag(n.tieuDe);
            var time   = formatTime(n.ngayGui);
            var unread = !n.daDoc;
            var noiDung = (n.noiDung || '').substring(0, 60) + ((n.noiDung || '').length > 60 ? '...' : '');
            var guiHtml = n.tenNguoiGui ? '<span>·</span><span>' + esc(n.tenNguoiGui) + '</span>' : '';
            return '<div class="np-item ' + (unread ? 'unread' : '') + '"'
                + ' id="nitem-' + n.thongBaoID + '"'
                + ' onclick="clickNotif(' + n.thongBaoID + ', ' + unread + ')">'
                + '<div class="np-dot ' + (unread ? '' : 'read') + '" id="ndot-' + n.thongBaoID + '"></div>'
                + '<div class="np-body">'
                + '<div class="np-tag ' + tag.cls + '">' + tag.label + '</div>'
                + '<div class="np-title">' + esc(n.tieuDe) + '</div>'
                + '<div class="np-noidung">' + esc(noiDung) + '</div>'
                + '<div class="np-time"><span>' + time + '</span>' + guiHtml + '</div>'
                + '</div><span class="np-arrow">→</span></div>';
        }).join('');
    }

    function detectTag(t) {
        if (!t) return {cls: 'hethong', label: 'Hệ thống'};
        const s = t.toLowerCase();
        if (s.includes('yêu cầu') || s.includes('trạng thái') || s.includes('thông tin'))
            return {cls: 'yeucau', label: 'Yêu cầu'};
        if (s.includes('duyệt') || s.includes('chấp thuận'))
            return {cls: 'duyet', label: 'Duyệt'};
        return {cls: 'hethong', label: 'Hệ thống'};
    }

    function clickNotif(thongBaoID, isUnread) {
        document.getElementById('notifPanel').classList.remove('open');
        if (isUnread) {
            fetch(CTX + '/thong-bao', {
                method: 'POST', headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                body: new URLSearchParams({action: 'doc', id: thongBaoID}).toString(), credentials: 'include'
            }).then(r => r.json()).then(() => {
                var item = document.getElementById('nitem-' + thongBaoID);
                var dot  = document.getElementById('ndot-'  + thongBaoID);
                if (item) item.classList.remove('unread');
                if (dot)  dot.classList.add('read');
                updateBadge(Math.max(0, (parseInt(document.getElementById('bellBadge').textContent) || 0) - 1));
                // sync _tbData
                var entry = _tbData.find(function(n){ return n.thongBaoID == thongBaoID; });
                if (entry) entry.daDoc = true;
            }).catch(() => {});
        }
        openModalChiTiet(thongBaoID);
    }

    function openModalChiTiet(thongBaoID) {
        document.getElementById('myc_ico').textContent   = '📋';
        document.getElementById('myc_ico').className     = 'mico warn';
        document.getElementById('myc_title').textContent = 'Chi tiết yêu cầu';
        document.getElementById('myc_sub').textContent   = 'Đang tải...';
        document.getElementById('myc_skeleton').style.display = '';
        document.getElementById('myc_content').style.display  = 'none';
        document.getElementById('myc_footer').innerHTML =
                '<button class="btn-m btn-cancel" onclick="closeM(\'modalYeuCau\')">Đóng</button>';
        openM('modalYeuCau');

        fetch(CTX + '/yeu-cau-doi-trang-thai?action=chitiet-notif&thongBaoID=' + thongBaoID, {credentials: 'include'})
                .then(r => r.json())
                .then(function(data) {
                    if (!data || !data.yeuCauID) {
                        document.getElementById('myc_skeleton').style.display = 'none';
                        document.getElementById('myc_content').style.display  = '';
                        document.getElementById('myc_content').innerHTML =
                            '<div style="text-align:center;padding:32px;color:var(--muted);font-size:13px">Không tìm thấy yêu cầu liên quan.</div>';
                        return;
                    }
                    _activeYeuCauID = data.yeuCauID;
                    renderModalChiTiet(data);
                })
                .catch(function(err) {
                    document.getElementById('myc_skeleton').style.display = 'none';
                    document.getElementById('myc_content').style.display  = '';
                    document.getElementById('myc_content').innerHTML =
                        '<div style="text-align:center;padding:32px;color:var(--danger);font-size:13px">⚠ Lỗi: ' + err.message + '</div>';
                });
    }

    function fetchYeuCauJSON() {
        return fetch(CTX + '/yeu-cau-doi-trang-thai?format=json', {credentials: 'include'})
                .then(function(r) {
                    var ct = r.headers.get('content-type') || '';
                    if (ct.indexOf('json') >= 0) return r.json();
                    return r.text().then(function(html) { return parseYCFromHTML(html); });
                });
    }

    function parseYCFromHTML(html) {
        var parser = new DOMParser();
        var doc = parser.parseFromString(html, 'text/html');
        var rows = doc.querySelectorAll('tbody tr[data-search]');
        var result = [];
        rows.forEach(function(tr, idx) {
            var cells   = tr.querySelectorAll('td');
            if (cells.length < 9) return;
            var ttYCEl  = cells[8].querySelector('[class^="badge"]');
            var ttYC    = ttYCEl ? ttYCEl.className.replace('badge-', '') : 'cho';
            var ttCuEl  = cells[4].querySelector('.pill');
            var ttMoiEl = cells[5].querySelector('.pill');
            result.push({
                yeuCauID:        parseInt(tr.getAttribute('data-id') || (idx + 1)),
                loaiYeuCau:      parseInt(tr.getAttribute('data-loai') || 1),
                maHoKhau:        cells[1].textContent.trim(),
                tenChuHo:        cells[2].textContent.trim(),
                tenTo:           cells[3].textContent.trim(),
                tenTrangThaiCu:  ttCuEl  ? ttCuEl.textContent.trim()  : cells[4].textContent.trim(),
                tenTrangThaiMoi: ttMoiEl ? ttMoiEl.textContent.trim() : cells[5].textContent.trim(),
                trangThaiCuID:   ttCuEl  ? getPillID(ttCuEl.className)  : 1,
                trangThaiMoiID:  ttMoiEl ? getPillID(ttMoiEl.className) : 3,
                ngayTao:         cells[7].textContent.trim(),
                ttYC:            ttYC
            });
        });
        return result;
    }

    function getPillID(cls) {
        if (cls.indexOf('p-tt') >= 0) return 1;
        if (cls.indexOf('p-tv') >= 0) return 2;
        return 3;
    }

    function mlTypeFilter(type) {
        _mlType   = type;
        _mlFilter = 'all';
        document.getElementById('typeTab1').classList.toggle('active', type === 1);
        document.getElementById('typeTab2').classList.toggle('active', type === 2);
        var ico   = document.getElementById('mlIco');
        var title = document.getElementById('mlTitle');
        if (type === 2) {
            ico.textContent = '👤'; ico.className = 'mico blue';
            title.textContent = 'Yêu cầu cập nhật thông tin cá nhân';
        } else {
            ico.textContent = '📋'; ico.className = 'mico green';
            title.textContent = 'Yêu cầu đổi trạng thái cư trú';
        }
        updateTableHeader();
        var filteredByType = _mlData.filter(function(r) { return (r.loaiYeuCau || 1) === _mlType; });
        renderMLSummary(filteredByType);
        renderMLTable('all');
    }

    function updateTableHeader() {
        var thead = document.getElementById('mlThead');
        if (_mlType === 2) {
            thead.innerHTML = '<tr><th>Người gửi</th><th>Tổ</th><th>Thông tin thay đổi</th><th>Ngày gửi</th><th>Trạng thái</th><th style="text-align:center">Thao tác</th></tr>';
        } else {
            thead.innerHTML = '<tr><th>Mã hộ</th><th>Chủ hộ</th><th>Tổ</th><th>Cũ → Mới</th><th>Ngày gửi</th><th>Trạng thái</th><th style="text-align:center">Thao tác</th></tr>';
        }
    }

    function renderMLSummary(list) {
        var cho    = list.filter(function(r) { return r.ttYC === 'cho';    }).length;
        var duyet  = list.filter(function(r) { return r.ttYC === 'duyet';  }).length;
        var tuchoi = list.filter(function(r) { return r.ttYC === 'tuchoi'; }).length;
        document.getElementById('ml_total').textContent = list.length;
        document.getElementById('ml_cho').textContent   = cho;
        document.getElementById('ml_ok').textContent    = duyet;
        document.getElementById('ml_no').textContent    = tuchoi;
        document.getElementById('mlSub').textContent    = list.length + ' yêu cầu · ' + cho + ' chờ duyệt';
        var totalCho = _mlData.filter(function(r) { return r.ttYC === 'cho'; }).length;
        document.getElementById('statChoDuyet').textContent = totalCho > 0 ? totalCho : '0';
        var cells   = document.querySelectorAll('#mlSummary .ml-stat');
        var filters = ['all', 'cho', 'duyet', 'tuchoi'];
        cells.forEach(function(c, i) {
            c.setAttribute('onclick', "mlFilter('" + filters[i] + "', this)");
            c.setAttribute('data-filter', filters[i]);
        });
    }

    function renderMLTable(filter) {
        _mlFilter = filter;
        var byType   = _mlData.filter(function(r) { return (r.loaiYeuCau || 1) === _mlType; });
        var filtered = filter === 'all' ? byType : byType.filter(function(r) { return r.ttYC === filter; });
        var tbody = document.getElementById('mlTbody');
        var empty = document.getElementById('mlEmpty');
        var tbl   = document.getElementById('mlTable');
        document.querySelectorAll('#mlTabs .ml-tab').forEach(function(b) { b.classList.remove('active'); });
        var activeTab = document.querySelector('#mlTabs .ml-tab[data-filter="' + filter + '"]');
        if (activeTab) activeTab.classList.add('active');
        document.querySelectorAll('#mlSummary .ml-stat').forEach(function(s) { s.classList.remove('active'); });
        var activeStat = document.querySelector('#mlSummary .ml-stat[data-filter="' + filter + '"]');
        if (activeStat) activeStat.classList.add('active');
        if (!filtered.length) { tbl.style.display='none'; empty.style.display=''; empty.textContent='Không có yêu cầu nào'; return; }
        tbl.style.display=''; empty.style.display='none';
        tbody.innerHTML = filtered.map(function(r) {
            var ttYC    = r.ttYC.replace('badge-', '');
            var ttBadge = ttYC === 'cho'    ? '<span class="pill-cho">Chờ duyệt</span>'
                        : ttYC === 'duyet'  ? '<span class="pill-ok">Đã duyệt</span>'
                        : ttYC === 'tuchoi' ? '<span class="pill-no">Từ chối</span>'
                        : '<span style="color:var(--muted);font-size:11px">Đã huỷ</span>';
            var actBtns = ttYC === 'cho'
                ? '<div style="display:flex;gap:6px;justify-content:center">'
                + '<button class="btn-yc-duyet" onclick="mlQuickDuyet(' + r.yeuCauID + ')">✓ Duyệt</button>'
                + '<button class="btn-yc-tc"    onclick="mlQuickTuChoi(' + r.yeuCauID + ')">✕ Từ chối</button>'
                + '</div>'
                : '<span style="font-size:11px;color:var(--muted)">—</span>';
            if (_mlType === 2) {
                var fields = [];
                if (r.ho_Moi)        fields.push('Họ');
                if (r.ten_Moi)       fields.push('Tên');
                if (r.ngaySinh_Moi)  fields.push('Ngày sinh');
                if (r.gioiTinh_Moi)  fields.push('Giới tính');
                if (r.email_Moi)     fields.push('Email');
                if (r.sDT_Moi)       fields.push('SĐT');
                if (r.cCCD_Moi)      fields.push('CCCD');
                var fieldStr = fields.length ? fields.join(', ') : '—';
                return '<tr id="mlrow-' + r.yeuCauID + '">'
                    + '<td><strong>' + esc(r.tenNguoiYeuCau || r.tenChuHo || '—') + '</strong></td>'
                    + '<td style="color:var(--muted)">' + esc(r.tenTo || '—') + '</td>'
                    + '<td style="color:var(--accent2);font-size:12px">' + esc(fieldStr) + '</td>'
                    + '<td style="color:var(--muted);font-size:12px">' + esc(r.ngayTao) + '</td>'
                    + '<td>' + ttBadge + '</td>'
                    + '<td style="text-align:center">' + actBtns + '</td>'
                    + '</tr>';
            } else {
                var pillCu  = pillTT(r.trangThaiCuID,  r.tenTrangThaiCu);
                var pillMoi = pillTT(r.trangThaiMoiID, r.tenTrangThaiMoi);
                return '<tr id="mlrow-' + r.yeuCauID + '">'
                    + '<td style="font-family:monospace;color:var(--accent);font-weight:600">' + esc(r.maHoKhau) + '</td>'
                    + '<td><strong>' + esc(r.tenChuHo) + '</strong></td>'
                    + '<td style="color:var(--muted)">' + esc(r.tenTo) + '</td>'
                    + '<td>' + pillCu + ' → ' + pillMoi + '</td>'
                    + '<td style="color:var(--muted);font-size:12px">' + esc(r.ngayTao) + '</td>'
                    + '<td>' + ttBadge + '</td>'
                    + '<td style="text-align:center">' + actBtns + '</td>'
                    + '</tr>';
            }
        }).join('');
    }

    function pillTT(id, label) {
        var cls = id === 1 ? 'pill-tt' : id === 2 ? 'pill-tv' : 'pill-tm';
        return '<span class="' + cls + '">' + esc(label || '—') + '</span>';
    }

    function mlFilter(f, btn) { renderMLTable(f); }

    function mlQuickDuyet(yeuCauID) {
        if (!confirm('Xác nhận duyệt yêu cầu #' + yeuCauID + '?')) return;
        fetch(CTX + '/yeu-cau-doi-trang-thai', {
            method: 'POST', headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: new URLSearchParams({action: 'duyet', yeuCauID: yeuCauID, ghiChu: ''}).toString(),
            credentials: 'include'
        }).then(r => r.json()).then(function(res) {
            if (res.success) { showToast('success', '✓ ' + res.message); _mlLoaded=false; notifLoaded=false; _tbLoaded=false; setTimeout(reloadAllData, 400); }
            else showToast('error', '✕ ' + res.message);
        }).catch(() => showToast('error', '✕ Lỗi kết nối'));
    }

    let _tcYeuCauID = null;
    function mlQuickTuChoi(yeuCauID) {
        _tcYeuCauID = yeuCauID;
        document.getElementById('tcLyDo').value = '';
        document.getElementById('tcErr').classList.remove('show');
        document.getElementById('tcLyDo').classList.remove('err');
        document.getElementById('modalTuChoi').classList.add('show');
        document.body.style.overflow = 'hidden';
        setTimeout(() => document.getElementById('tcLyDo').focus(), 100);
    }
    function closeTuChoi() {
        document.getElementById('modalTuChoi').classList.remove('show');
        document.body.style.overflow = '';
    }
    function confirmTuChoi() {
        const ly = document.getElementById('tcLyDo').value.trim();
        if (!ly) {
            document.getElementById('tcErr').classList.add('show');
            document.getElementById('tcLyDo').classList.add('err');
            return;
        }
        const btn = document.getElementById('btnConfirmTC2');
        btn.disabled = true; btn.textContent = 'Đang xử lý...';
        fetch(CTX + '/yeu-cau-doi-trang-thai', {
            method: 'POST', headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: new URLSearchParams({action: 'tuchoi', yeuCauID: _tcYeuCauID, lyDoTuChoi: ly}).toString(),
            credentials: 'include'
        }).then(r => r.json()).then(function(res) {
            btn.disabled = false; btn.textContent = '✕ Xác nhận từ chối';
            closeTuChoi();
            if (res.success) { showToast('success', '✓ ' + res.message); _mlLoaded=false; notifLoaded=false; _tbLoaded=false; setTimeout(reloadAllData, 400); }
            else showToast('error', '✕ ' + res.message);
        }).catch(() => { btn.disabled=false; btn.textContent='✕ Xác nhận từ chối'; showToast('error', '✕ Lỗi kết nối'); });
    }

    function reloadAllData() {
        fetchYeuCauJSON().then(function(list) {
            _mlData = list; _mlLoaded = true;
            var byType = list.filter(function(r) { return (r.loaiYeuCau||1) === _mlType; });
            if (document.getElementById('modalYCList').classList.contains('show')) {
                renderMLSummary(byType); renderMLTable(_mlFilter);
                document.getElementById('mlLoading').style.display = 'none';
                document.getElementById('mlTable').style.display   = '';
            } else {
                var totalCho = list.filter(function(r) { return r.ttYC === 'cho'; }).length;
                document.getElementById('statChoDuyet').textContent = totalCho > 0 ? totalCho : '0';
            }
            pollBadge();
        }).catch(() => {});
    }

    /* ══ MODAL CHI TIẾT ══ */
    function renderModalChiTiet(d) {
        const isCho = d.trangThaiYeuCauID === 1;
        const loai  = d.loaiYeuCau || 1;
        document.getElementById('myc_skeleton').style.display = 'none';
        document.getElementById('myc_content').style.display  = '';
        if (loai === 2) {
            document.getElementById('myc_ico').textContent   = '👤';
            document.getElementById('myc_ico').className     = 'mico blue';
            document.getElementById('myc_title').textContent = 'Yêu cầu cập nhật thông tin cá nhân';
            document.getElementById('myc_sub').textContent   = 'Người gửi: ' + (d.tenNguoiYeuCau || '—');
        } else {
            document.getElementById('myc_ico').textContent   = '📋';
            document.getElementById('myc_ico').className     = 'mico warn';
            document.getElementById('myc_title').textContent = 'Yêu cầu đổi trạng thái cư trú';
            document.getElementById('myc_sub').textContent   = 'Mã hộ: ' + (d.maHoKhau || '—') + ' · ' + (d.tenTo || '');
        }
        var formHtml = '';
        if (isCho) {
            formHtml = '<div id="form-duyet" style="display:none"><div class="sec-title">Ghi chú duyệt</div>'
                + '<div class="form-group"><label class="form-label">Ghi chú <span style="color:var(--muted);font-weight:400">(tuỳ chọn)</span></label>'
                + '<textarea class="form-textarea" id="inp_ghichu" placeholder="Nhập ghi chú nếu cần..."></textarea></div></div>'
                + '<div id="form-tuchoi" style="display:none"><div class="sec-title">Lý do từ chối</div>'
                + '<div class="form-group"><label class="form-label">Lý do từ chối <span style="color:var(--danger)">*</span></label>'
                + '<textarea class="form-textarea red" id="inp_lydotc" placeholder="Bắt buộc nhập lý do từ chối..."></textarea></div></div>';
        }
        var contentHtml = '';
        if (loai === 1) {
            contentHtml = '<div class="sec-title">Thông tin hộ</div><div class="dgrid">'
                + '<div><div class="dlbl">Mã hộ khẩu</div><div class="dval mono">' + orD(d.maHoKhau) + '</div></div>'
                + '<div><div class="dlbl">Chủ hộ</div><div class="dval">' + orD(d.tenChuHo) + '</div></div>'
                + '<div><div class="dlbl">Tổ dân phố</div><div class="dval">' + orD(d.tenTo) + '</div></div>'
                + '<div><div class="dlbl">Địa chỉ</div><div class="dval muted">' + orD(d.diaChiHo) + '</div></div>'
                + '</div><div class="sec-title">Chi tiết yêu cầu</div><div class="dgrid">'
                + '<div><div class="dlbl">Trạng thái cũ</div>' + pillH(d.trangThaiCuID, d.tenTrangThaiCu) + '</div>'
                + '<div><div class="dlbl">→ Trạng thái mới</div>' + pillH(d.trangThaiMoiID, d.tenTrangThaiMoi) + '</div>'
                + '<div class="full"><div class="dlbl">Lý do</div><div class="dval muted">' + orD(d.lyDoYeuCau) + '</div></div>'
                + '<div><div class="dlbl">Ngày gửi</div><div class="dval muted">' + orD(d.ngayTao) + '</div></div>'
                + '<div><div class="dlbl">Tổ trưởng gửi</div><div class="dval">' + orD(d.tenNguoiYeuCau) + '</div></div>'
                + '</div>' + formHtml;
        } else {
            var fields = [
                {label:'Họ',cu:d.ho_Cu,moi:d.ho_Moi},{label:'Tên',cu:d.ten_Cu,moi:d.ten_Moi},
                {label:'Ngày sinh',cu:d.ngaySinh_Cu,moi:d.ngaySinh_Moi},{label:'Giới tính',cu:d.gioiTinh_Cu,moi:d.gioiTinh_Moi},
                {label:'Email',cu:d.email_Cu,moi:d.email_Moi},{label:'Số điện thoại',cu:d.sDT_Cu,moi:d.sDT_Moi},
                {label:'CCCD',cu:d.cCCD_Cu,moi:d.cCCD_Moi}
            ];
            var changedRows = fields.filter(function(f){return f.moi&&f.moi!=='null';})
                .map(function(f){
                    return '<tr><td style="color:var(--muted);font-size:12px;padding:8px 12px;border-bottom:1px solid var(--border)">'+esc(f.label)+'</td>'
                        +'<td style="padding:8px 12px;border-bottom:1px solid var(--border);text-decoration:line-through;color:var(--muted)">'+orD(f.cu)+'</td>'
                        +'<td style="padding:8px 12px;border-bottom:1px solid var(--border);color:var(--accent2);font-weight:600">→ '+orD(f.moi)+'</td></tr>';
                }).join('');
            contentHtml = '<div class="sec-title">Thông tin người gửi</div><div class="dgrid">'
                + '<div><div class="dlbl">Họ tên</div><div class="dval">' + orD(d.tenNguoiYeuCau) + '</div></div>'
                + '<div><div class="dlbl">Ngày gửi</div><div class="dval muted">' + orD(d.ngayTao) + '</div></div>'
                + '<div class="full"><div class="dlbl">Lý do</div><div class="dval muted">' + orD(d.lyDoYeuCau) + '</div></div>'
                + '</div><div class="sec-title">Thông tin muốn thay đổi</div>'
                + '<table style="width:100%;border-collapse:collapse;font-size:13px;margin-bottom:18px"><thead><tr>'
                + '<th style="padding:8px 12px;text-align:left;color:var(--muted);font-size:11px;font-weight:700;border-bottom:1px solid var(--border)">Trường</th>'
                + '<th style="padding:8px 12px;text-align:left;color:var(--muted);font-size:11px;font-weight:700;border-bottom:1px solid var(--border)">Hiện tại</th>'
                + '<th style="padding:8px 12px;text-align:left;color:var(--muted);font-size:11px;font-weight:700;border-bottom:1px solid var(--border)">Muốn đổi thành</th>'
                + '</tr></thead><tbody>' + (changedRows||'<tr><td colspan="3" style="padding:16px;text-align:center;color:var(--muted)">Không có thông tin</td></tr>') + '</tbody></table>' + formHtml;
        }
        document.getElementById('myc_content').innerHTML = contentHtml;
        setModalFooter(isCho ? 'chitiet' : 'readonly');
    }

    function setModalFooter(state) {
        var el    = document.getElementById('myc_footer');
        var urlYC = CTX + '/yeu-cau-doi-trang-thai';
        if (state==='loading') { el.innerHTML='<button class="btn-m btn-cancel" onclick="closeM(\'modalYeuCau\')">Đóng</button>'; }
        else if (state==='readonly') { el.innerHTML='<button class="btn-m btn-cancel" onclick="closeM(\'modalYeuCau\')">Đóng</button><a href="'+urlYC+'" class="btn-m btn-goto">Xem toàn bộ →</a>'; }
        else if (state==='chitiet') { el.innerHTML='<button class="btn-m btn-cancel" onclick="closeM(\'modalYeuCau\')">Đóng</button><a href="'+urlYC+'" class="btn-m btn-goto">Xem tất cả</a><button class="btn-m btn-no" onclick="switchState(\'tuchoi\')">✕ Từ chối</button><button class="btn-m btn-ok" onclick="switchState(\'duyet\')">✓ Duyệt</button>'; }
        else if (state==='duyet') { el.innerHTML='<button class="btn-m btn-cancel" onclick="switchState(\'chitiet\')">← Quay lại</button><button class="btn-m btn-ok" onclick="submitDuyet()" id="btnConfirmDuyet">✓ Xác nhận duyệt</button>'; }
        else if (state==='tuchoi') { el.innerHTML='<button class="btn-m btn-cancel" onclick="switchState(\'chitiet\')">← Quay lại</button><button class="btn-m btn-no" onclick="submitTuChoi()" id="btnConfirmTC">✕ Xác nhận từ chối</button>'; }
    }

    function switchState(state) {
        const fDuyet=document.getElementById('form-duyet');
        const fTuChoi=document.getElementById('form-tuchoi');
        const isCapNhat=document.getElementById('myc_title').textContent.includes('cá nhân');
        if (state==='duyet') {
            if(fDuyet)fDuyet.style.display=''; if(fTuChoi)fTuChoi.style.display='none'; setModalFooter('duyet');
            document.getElementById('myc_ico').textContent='✓'; document.getElementById('myc_ico').className='mico green';
            document.getElementById('myc_title').textContent=isCapNhat?'Duyệt cập nhật thông tin cá nhân':'Duyệt yêu cầu cư trú';
        } else if (state==='tuchoi') {
            if(fDuyet)fDuyet.style.display='none'; if(fTuChoi)fTuChoi.style.display=''; setModalFooter('tuchoi');
            document.getElementById('myc_ico').textContent='✕'; document.getElementById('myc_ico').className='mico red';
            document.getElementById('myc_title').textContent=isCapNhat?'Từ chối cập nhật thông tin cá nhân':'Từ chối yêu cầu cư trú';
        } else {
            if(fDuyet)fDuyet.style.display='none'; if(fTuChoi)fTuChoi.style.display='none'; setModalFooter('chitiet');
            document.getElementById('myc_ico').textContent=isCapNhat?'👤':'📋';
            document.getElementById('myc_ico').className=isCapNhat?'mico blue':'mico warn';
            document.getElementById('myc_title').textContent=isCapNhat?'Yêu cầu cập nhật thông tin cá nhân':'Yêu cầu đổi trạng thái cư trú';
        }
    }

    function submitDuyet() {
        if(!_activeYeuCauID) return;
        const ghiChu=(document.getElementById('inp_ghichu')?.value||'').trim();
        const btn=document.getElementById('btnConfirmDuyet');
        btn.disabled=true; btn.textContent='Đang xử lý...';
        fetch(CTX+'/yeu-cau-doi-trang-thai',{method:'POST',headers:{'Content-Type':'application/x-www-form-urlencoded'},
            body:new URLSearchParams({action:'duyet',yeuCauID:_activeYeuCauID,ghiChu}).toString(),credentials:'include'
        }).then(r=>r.json()).then(res=>{
            if(res.success){closeM('modalYeuCau');showToast('success','✓ '+res.message);notifLoaded=false;_mlLoaded=false;_tbLoaded=false;setTimeout(reloadAllData,400);}
            else{btn.disabled=false;btn.textContent='✓ Xác nhận duyệt';showToast('error','✕ '+res.message);}
        }).catch(()=>{btn.disabled=false;btn.textContent='✓ Xác nhận duyệt';showToast('error','✕ Lỗi kết nối');});
    }

    function submitTuChoi() {
        if(!_activeYeuCauID) return;
        const lyDoTC=(document.getElementById('inp_lydotc')?.value||'').trim();
        if(!lyDoTC){showToast('error','⚠ Vui lòng nhập lý do từ chối.');return;}
        const btn=document.getElementById('btnConfirmTC');
        btn.disabled=true; btn.textContent='Đang xử lý...';
        fetch(CTX+'/yeu-cau-doi-trang-thai',{method:'POST',headers:{'Content-Type':'application/x-www-form-urlencoded'},
            body:new URLSearchParams({action:'tuchoi',yeuCauID:_activeYeuCauID,lyDoTuChoi:lyDoTC}).toString(),credentials:'include'
        }).then(r=>r.json()).then(res=>{
            if(res.success){closeM('modalYeuCau');showToast('success','✓ '+res.message);notifLoaded=false;_mlLoaded=false;_tbLoaded=false;setTimeout(reloadAllData,400);}
            else{btn.disabled=false;btn.textContent='✕ Xác nhận từ chối';showToast('error','✕ '+res.message);}
        }).catch(()=>{btn.disabled=false;btn.textContent='✕ Xác nhận từ chối';showToast('error','✕ Lỗi kết nối');});
    }

    /* ══ BADGE ══ */
    function markAllRead() {
        fetch(CTX+'/thong-bao',{method:'POST',headers:{'Content-Type':'application/x-www-form-urlencoded'},
            body:'action=docTatCa',credentials:'include'
        }).then(r=>r.json()).then(()=>{
            document.querySelectorAll('.np-item.unread').forEach(el=>el.classList.remove('unread'));
            document.querySelectorAll('.np-dot').forEach(d=>d.classList.add('read'));
            _tbData.forEach(function(n){n.daDoc=true;}); _tbLoaded=false;
            updateBadge(0); notifLoaded=false;
        }).catch(()=>{});
    }

    function updateBadge(count) {
        const b=document.getElementById('bellBadge');
        if(count>0){b.textContent=count>99?'99+':count;b.classList.remove('hidden');}
        else b.classList.add('hidden');
        document.getElementById('statChoDuyet').textContent=count>0?count:'0';
    }

    function pollBadge() {
        fetch(CTX+'/thong-bao?action=demChuaDoc',{credentials:'include'})
            .then(r=>r.json()).then(d=>updateBadge(d.chuaDoc||0)).catch(()=>{});
    }
    pollBadge();
    setInterval(pollBadge,60000);

    /* ══ USER MENU ══ */
    function toggleMenu() {
        document.getElementById('notifPanel').classList.remove('open');
        const dd=document.getElementById('userDropdown'),btn=document.getElementById('avatarBtn');
        const open=dd.classList.toggle('open');
        btn.classList.toggle('open',open);
    }
    document.addEventListener('click',function(e){
        var bellWrap=document.getElementById('bellWrap');
        var userMenu=document.querySelector('.user-menu');
        if(bellWrap&&!bellWrap.contains(e.target))document.getElementById('notifPanel').classList.remove('open');
        if(userMenu&&!userMenu.contains(e.target))closeUserMenu();
    });

    /* ══ MODAL HELPERS ══ */
    function openM(id){document.getElementById(id).classList.add('show');document.body.style.overflow='hidden';}
    function closeM(id){document.getElementById(id).classList.remove('show');document.body.style.overflow='';}
    function closeMOutside(e,id){if(e.target===document.getElementById(id))closeM(id);}
    document.addEventListener('keydown',function(e){
        if(e.key==='Escape'){closeM('modalYeuCau');closeM('modalYCList');closeM('modalTatCaTB');hideLogoutModal();closeTuChoi();}
    });

    /* ══ HELPERS ══ */
    function pillH(id,label){const m={1:'p-tt',2:'p-tv',3:'p-tm'};return '<span class="pill '+(m[id]||'p-tt')+'">'+esc(label||'—')+'</span>';}
    function orD(v){return(v&&v!=='null')?esc(String(v)):'—';}
    function esc(s){return String(s||'').replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');}
    function formatTime(d){
        if(!d)return'';
        try{
            const diff=Math.floor((Date.now()-new Date(d))/1000);
            if(diff<60)return'Vừa xong';
            if(diff<3600)return Math.floor(diff/60)+' phút trước';
            if(diff<86400)return Math.floor(diff/3600)+' giờ trước';
            if(diff<604800)return Math.floor(diff/86400)+' ngày trước';
            return new Date(d).toLocaleDateString('vi-VN');
        }catch(e){return d;}
    }
    function showToast(type,msg){
        const t=document.getElementById('toast');
        t.className='toast '+type+' show';t.textContent=msg;
        clearTimeout(t._t);t._t=setTimeout(()=>t.classList.remove('show'),3500);
    }

    function openModalYCList(callback) {
        _mlType=1; _mlFilter='all';
        document.getElementById('typeTab1').classList.add('active');
        document.getElementById('typeTab2').classList.remove('active');
        document.getElementById('mlIco').textContent='📋'; document.getElementById('mlIco').className='mico green';
        document.getElementById('mlTitle').textContent='Yêu cầu đổi trạng thái cư trú';
        updateTableHeader(); openM('modalYCList');
        if(_mlLoaded&&_mlData.length>0){
            var byType=_mlData.filter(function(r){return(r.loaiYeuCau||1)===_mlType;});
            renderMLSummary(byType); renderMLTable('all');
            document.getElementById('mlLoading').style.display='none';
            document.getElementById('mlTable').style.display='';
            if(callback)callback(); return;
        }
        document.getElementById('mlLoading').style.display='';
        document.getElementById('mlLoading').innerHTML='<span class="np-spinner"></span> Đang tải dữ liệu...';
        document.getElementById('mlTable').style.display='none';
        document.getElementById('mlEmpty').style.display='none';
        fetchYeuCauJSON().then(function(list){
            _mlData=list;_mlLoaded=true;
            var byType=list.filter(function(r){return(r.loaiYeuCau||1)===_mlType;});
            renderMLSummary(byType); renderMLTable('all');
            document.getElementById('mlLoading').style.display='none';
            document.getElementById('mlTable').style.display='';
            if(callback)callback();
        }).catch(function(err){
            document.getElementById('mlLoading').innerHTML='⚠ Không thể tải dữ liệu: '+err.message;
        });
    }
        </script>
    </body>
</html>
