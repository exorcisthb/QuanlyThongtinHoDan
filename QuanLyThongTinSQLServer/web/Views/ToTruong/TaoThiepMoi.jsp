<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tạo thiệp mời — Tổ dân phố</title>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root{--bg:#0f1117;--surface:#181c27;--surface2:#1f2433;--border:#2a3048;
            --accent:#4f8ef7;--accent2:#38d9a9;--danger:#f75c5c;--warn:#fbbf24;
            --text:#e2e8f0;--muted:#64748b;--hoan:#a78bfa;--radius:14px}
        *,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
        body{font-family:'Be Vietnam Pro',sans-serif;background:var(--bg);color:var(--text);min-height:100vh}

        .topbar{position:fixed;top:0;left:0;right:0;z-index:200;height:60px;
            background:rgba(15,17,23,.92);backdrop-filter:blur(16px);
            border-bottom:1px solid var(--border);display:flex;align-items:center;padding:0 24px;gap:14px}
        .topbar-logo{display:flex;align-items:center;gap:8px;text-decoration:none;color:var(--text)}
        .logo-icon{width:30px;height:30px;border-radius:7px;
            background:linear-gradient(135deg,var(--accent),var(--accent2));
            display:flex;align-items:center;justify-content:center;font-size:14px}
        .logo-text{font-size:13px;font-weight:700}.logo-text span{color:var(--accent)}
        .divider{width:1px;height:20px;background:var(--border)}
        .breadcrumb{display:flex;align-items:center;gap:5px;font-size:12px;color:var(--muted)}
        .breadcrumb a{color:var(--muted);text-decoration:none}.breadcrumb a:hover{color:var(--text)}
        .breadcrumb .cur{color:var(--warn);font-weight:600}
        .topbar-spacer{flex:1}

        .main{padding-top:60px;height:calc(100vh - 60px);display:flex;overflow:hidden}

        .sidebar{width:220px;flex-shrink:0;border-right:1px solid var(--border);
            background:var(--surface);overflow-y:auto;padding:16px 12px}
        .sidebar-title{font-size:10px;font-weight:700;text-transform:uppercase;
            letter-spacing:.08em;color:var(--muted);margin-bottom:10px;padding:0 4px}
        .mau-item{display:flex;align-items:center;gap:10px;padding:9px 10px;
            border-radius:9px;cursor:pointer;transition:all .15s;margin-bottom:4px;
            border:1.5px solid transparent}
        .mau-item:hover{background:var(--surface2)}
        .mau-item.active{background:rgba(251,191,36,.1);border-color:var(--warn)}
        .mau-icon{font-size:18px;flex-shrink:0;width:24px;text-align:center}
        .mau-info .mau-name{font-size:12px;font-weight:700;color:var(--text);line-height:1.3}
        .mau-info .mau-sub{font-size:10px;color:var(--muted);margin-top:1px}

        .form-area{flex:1;overflow-y:auto;padding:20px 24px}
        .form-header{margin-bottom:16px}
        .form-header h1{font-size:18px;font-weight:800;letter-spacing:-.3px}
        .form-header h1 span{color:var(--warn)}
        .form-header p{font-size:12px;color:var(--muted);margin-top:3px}

        .toast{padding:10px 14px;border-radius:9px;font-size:12px;font-weight:600;
            margin-bottom:14px;display:flex;align-items:center;gap:8px}
        .toast-error{background:rgba(247,92,92,.12);border:1px solid rgba(247,92,92,.3);color:var(--danger)}

        /* NOTE TẠM HOÃN */
        .hoan-note{background:rgba(167,139,250,.07);border:1px solid rgba(167,139,250,.25);
            border-radius:10px;padding:12px 16px;display:flex;gap:10px;align-items:flex-start;
            font-size:12px;color:var(--hoan);line-height:1.6;margin-bottom:14px}
        .hoan-note .hn-icon{font-size:16px;flex-shrink:0;margin-top:1px}
        .hoan-note strong{font-weight:700}

        .fcard{background:var(--surface);border:1px solid var(--border);border-radius:var(--radius);margin-bottom:12px}
        .fcard-head{padding:12px 16px;border-bottom:1px solid var(--border);
            display:flex;align-items:center;gap:8px}
        .fcard-head .ico{width:28px;height:28px;border-radius:7px;
            display:flex;align-items:center;justify-content:center;font-size:14px}
        .ico-warn{background:rgba(251,191,36,.15)}
        .ico-blue{background:rgba(79,142,247,.15)}
        .fcard-head h3{font-size:13px;font-weight:700}
        .fcard-body{padding:16px}
        .fg{display:grid;gap:12px}
        .fg-2{grid-template-columns:1fr 1fr}
        .fg-3{grid-template-columns:1fr 1fr 1fr}
        .form-group{display:flex;flex-direction:column;gap:5px}
        label{font-size:10px;font-weight:700;color:var(--muted);text-transform:uppercase;letter-spacing:.06em}
        .req{color:var(--danger)}
        input[type=text],input[type=datetime-local],select,textarea{
            background:var(--surface2);border:1px solid var(--border);border-radius:8px;
            padding:8px 12px;font-size:13px;color:var(--text);font-family:inherit;
            outline:none;transition:border-color .15s,box-shadow .15s;width:100%}
        input:focus,select:focus,textarea:focus{
            border-color:var(--warn);box-shadow:0 0 0 3px rgba(251,191,36,.1)}
        input::placeholder,textarea::placeholder{color:var(--muted)}
        select option{background:var(--surface2)}
        textarea{resize:vertical;min-height:90px;line-height:1.6;font-size:12px}
        .char-hint{font-size:10px;color:var(--muted);text-align:right}

        .doi-tuong-wrap{display:flex;flex-wrap:wrap;gap:8px}
        .dt-tag{display:inline-flex;align-items:center;gap:5px;
            padding:5px 12px;border-radius:100px;font-size:11px;font-weight:700;
            cursor:pointer;transition:all .15s;border:1.5px solid var(--border);
            background:var(--surface2);color:var(--muted);user-select:none}
        .dt-tag:hover{border-color:var(--accent);color:var(--accent)}
        .dt-tag.on{background:rgba(79,142,247,.15);border-color:var(--accent);color:var(--accent)}
        .dt-tag input{display:none}

        .form-actions{display:flex;gap:10px;align-items:center;justify-content:flex-end;margin-top:4px;padding-bottom:20px}
        .btn-submit{display:inline-flex;align-items:center;gap:7px;padding:10px 24px;
            border-radius:9px;font-size:13px;font-weight:700;cursor:pointer;
            font-family:inherit;border:none;background:var(--warn);color:#000;transition:all .15s}
        .btn-submit:hover{background:#f0b429;transform:translateY(-1px)}
        .btn-cancel{display:inline-flex;align-items:center;gap:7px;padding:10px 18px;
            border-radius:9px;font-size:13px;font-weight:600;cursor:pointer;
            font-family:inherit;transition:all .15s;background:transparent;
            border:1px solid var(--border);color:var(--muted);text-decoration:none}
        .btn-cancel:hover{border-color:var(--text);color:var(--text)}
    </style>
</head>
<body>

<header class="topbar">
    <a href="${pageContext.request.contextPath}/dashboard" class="topbar-logo">
        <div class="logo-icon">🏘</div>
        <div class="logo-text">Quản lý <span>Hộ dân</span></div>
    </a>
    <div class="divider"></div>
    <div class="breadcrumb">
        <a href="${pageContext.request.contextPath}/dashboard">Trang chủ</a> ›
        <a href="${pageContext.request.contextPath}/thiepmoi/danh-sach">Thiệp mời</a> ›
        <span class="cur">Tạo mới</span>
    </div>
    <div class="topbar-spacer"></div>
</header>

<div class="main">

    <!-- SIDEBAR MẪU -->
    <div class="sidebar">
        <div class="sidebar-title">Chọn mẫu thiệp</div>
        <div class="mau-item active" onclick="applyMau(this,'blank')">
            <div class="mau-icon">✨</div>
            <div class="mau-info"><div class="mau-name">Tạo mới</div><div class="mau-sub">Nhập tay từ đầu</div></div>
        </div>
        <div class="mau-item" onclick="applyMau(this,'hop_thang')">
            <div class="mau-icon">📋</div>
            <div class="mau-info"><div class="mau-name">Họp định kỳ</div><div class="mau-sub">Họp tháng thường kỳ</div></div>
        </div>
        <div class="mau-item" onclick="applyMau(this,'m1_6')">
            <div class="mau-icon">🎉</div>
            <div class="mau-info"><div class="mau-name">Mừng 1/6</div><div class="mau-sub">Ngày Quốc tế Thiếu nhi</div></div>
        </div>
        <div class="mau-item" onclick="applyMau(this,'trung_thu')">
            <div class="mau-icon">🏮</div>
            <div class="mau-info"><div class="mau-name">Tết Trung Thu</div><div class="mau-sub">Vui hội trăng rằm</div></div>
        </div>
        <div class="mau-item" onclick="applyMau(this,'dang_vien')">
            <div class="mau-icon">🔴</div>
            <div class="mau-info"><div class="mau-name">Họp Đảng viên</div><div class="mau-sub">Sinh hoạt chi bộ</div></div>
        </div>
        <div class="mau-item" onclick="applyMau(this,'ve_sinh')">
            <div class="mau-icon">🧹</div>
            <div class="mau-info"><div class="mau-name">Vệ sinh môi trường</div><div class="mau-sub">Ra quân dọn dẹp</div></div>
        </div>
        <div class="mau-item" onclick="applyMau(this,'bao_cao')">
            <div class="mau-icon">📊</div>
            <div class="mau-info"><div class="mau-name">Báo cáo cuối năm</div><div class="mau-sub">Tổng kết năm</div></div>
        </div>
        <div class="mau-item" onclick="applyMau(this,'an_ninh')">
            <div class="mau-icon">🛡️</div>
            <div class="mau-info"><div class="mau-name">An ninh trật tự</div><div class="mau-sub">Phòng chống tội phạm</div></div>
        </div>
        <div class="mau-item" onclick="applyMau(this,'phong_chay')">
            <div class="mau-icon">🔥</div>
            <div class="mau-info"><div class="mau-name">PCCC</div><div class="mau-sub">Phòng cháy chữa cháy</div></div>
        </div>
        <div class="mau-item" onclick="applyMau(this,'y_te')">
            <div class="mau-icon">💊</div>
            <div class="mau-info"><div class="mau-name">Y tế – Dịch bệnh</div><div class="mau-sub">Phòng chống dịch</div></div>
        </div>
        <div class="mau-item" onclick="applyMau(this,'giao_thong')">
            <div class="mau-icon">🚦</div>
            <div class="mau-info"><div class="mau-name">An toàn giao thông</div><div class="mau-sub">Triển khai nghị quyết</div></div>
        </div>
        <div class="mau-item" onclick="applyMau(this,'le_tet')">
            <div class="mau-icon">🎊</div>
            <div class="mau-info"><div class="mau-name">Mừng lễ – Tết</div><div class="mau-sub">30/4, 2/9, Tết</div></div>
        </div>
    </div>

    <!-- FORM -->
    <div class="form-area">
        <div class="form-header">
            <h1>Tạo <span>thiệp mời</span> mới</h1>
            <p>Chọn mẫu bên trái để điền nhanh — chỉnh sửa nội dung rồi gửi</p>
        </div>

        <c:if test="${not empty errorMsg}">
            <div class="toast toast-error">❌ ${errorMsg}</div>
        </c:if>

        <%-- NOTE TẠM HOÃN / BẤT KHẢ KHÁNG --%>
        <div class="hoan-note">
            <span class="hn-icon">⏸️</span>
            <span>
                <strong>Lưu ý về tạm hoãn:</strong>
                Trong trường hợp thời tiết xấu (mưa bão, lũ lụt…) hoặc các sự kiện bất khả kháng,
                chương trình có thể được <strong>tạm hoãn</strong> sau khi tạo.
                Hệ thống sẽ tự động gửi thông báo <strong>[TẠM HOÃN]</strong> đến toàn bộ hộ dân.
                Lịch họp mới sẽ được cập nhật và thông báo lại sớm nhất.
            </span>
        </div>

        <form method="post" action="${pageContext.request.contextPath}/thiepmoi/tao-moi" id="formTao">

            <!-- THÔNG TIN CHÍNH -->
            <div class="fcard">
                <div class="fcard-head">
                    <div class="ico ico-warn">💌</div>
                    <h3>Thông tin thiệp mời</h3>
                </div>
                <div class="fcard-body">
                    <div class="fg" style="gap:10px">
                        <div class="form-group">
                            <label>Tiêu đề cuộc họp <span class="req">*</span></label>
                            <input type="text" name="tieuDe" id="tieuDe" maxlength="255"
                                   placeholder="Chọn mẫu thiệp bên trái để điền tiêu đề" required
                                   readonly style="cursor:not-allowed;opacity:.75">
                        </div>
                        <div class="fg fg-3">
                            <div class="form-group">
                                <label>Thời gian bắt đầu <span class="req">*</span></label>
                                <input type="datetime-local" name="thoiGianBatDau" id="tgbd" required
                                       oninput="updateMinKetThuc(this.value)">
                            </div>
                            <div class="form-group">
                                <label>Thời gian kết thúc</label>
                                <input type="datetime-local" name="thoiGianKetThuc" id="tgkt">
                            </div>
                            <div class="form-group">
                                <label>Tổ dân phố <span class="req">*</span></label>
                                <input type="hidden" name="toDanPhoID" value="${toDanPhoID}">
                                <input type="text" value="${tenTo}" disabled style="opacity:.6;cursor:not-allowed">
                            </div>
                        </div>
                        <div class="form-group">
                            <label>Địa điểm tổ chức</label>
                            <input type="text" name="diaDiem" id="diaDiem" maxlength="300"
                                   placeholder="VD: Nhà văn hóa tổ 5, phường Lê Đại Hành">
                        </div>
                        <div class="form-group">
                            <label>Nội dung / Chương trình họp</label>
                            <textarea name="noiDung" id="noiDung" maxlength="2000"
                                      placeholder="1. Thông báo tình hình an ninh trật tự&#10;2. ..."
                                      oninput="document.getElementById('lenNoiDung').textContent=this.value.length"></textarea>
                            <div class="char-hint"><span id="lenNoiDung">0</span>/2000</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- ĐỐI TƯỢNG THAM DỰ -->
            <div class="fcard">
                <div class="fcard-head">
                    <div class="ico ico-blue">👥</div>
                    <h3>Đối tượng tham dự</h3>
                </div>
                <div class="fcard-body">
                    <div style="font-size:11px;color:var(--muted);margin-bottom:10px">
                        Thiệp sẽ gửi thông báo đến <strong style="color:var(--accent)">toàn bộ chủ hộ</strong> trong tổ.
                        Chọn thêm đối tượng cần nhấn mạnh trong nội dung thiệp:
                    </div>
                    <div class="doi-tuong-wrap" id="doiTuongWrap">
                        <label class="dt-tag"><input type="checkbox" name="doiTuong" value="chu_ho"> 🏠 Chủ hộ</label>
                        <label class="dt-tag"><input type="checkbox" name="doiTuong" value="thanh_vien"> 👨‍👩‍👧 Toàn bộ thành viên hộ</label>
                        <label class="dt-tag"><input type="checkbox" name="doiTuong" value="dang_vien"> 🔴 Đảng viên</label>
                        <label class="dt-tag"><input type="checkbox" name="doiTuong" value="phu_nu"> 👩 Hội phụ nữ</label>
                        <label class="dt-tag"><input type="checkbox" name="doiTuong" value="cu_chien_binh"> 🎖️ Cựu chiến binh</label>
                        <label class="dt-tag"><input type="checkbox" name="doiTuong" value="thanh_nien"> 🙋 Thanh niên</label>
                        <label class="dt-tag"><input type="checkbox" name="doiTuong" value="nguoi_cao_tuoi"> 👴 Người cao tuổi</label>
                        <label class="dt-tag"><input type="checkbox" name="doiTuong" value="tre_em"> 🧒 Thiếu nhi</label>
                        <label class="dt-tag"><input type="checkbox" name="doiTuong" value="ho_ngheo"> 💙 Hộ nghèo / Khó khăn</label>
                    </div>
                </div>
            </div>

            <div class="form-actions">
                <a href="${pageContext.request.contextPath}/thiepmoi/danh-sach" class="btn-cancel">← Quay lại</a>
                <button type="submit" class="btn-submit">💌 Tạo & gửi thông báo</button>
            </div>

        </form>
    </div>
</div>

<script>
(function(){
    const now = new Date(); now.setSeconds(0,0);
    const fmt = d => d.toISOString().slice(0,16);
    document.getElementById('tgbd').min = fmt(now);
    document.getElementById('tgkt').min = fmt(now);
})();

function updateMinKetThuc(val){
    if(val) document.getElementById('tgkt').min = val;
}

const MAU = {
    blank:      {tieuDe:'',diaDiem:'',noiDung:'',tags:[]},
    hop_thang:  {tieuDe:'Họp tổ dân phố định kỳ tháng',diaDiem:'Nhà văn hóa tổ dân phố',noiDung:'1. Thông báo tình hình an ninh trật tự, vệ sinh môi trường trong tháng\n2. Triển khai các văn bản, chỉ thị của phường\n3. Thu các khoản phí theo quy định\n4. Thảo luận và giải quyết các kiến nghị của hộ dân\n5. Các vấn đề phát sinh khác',tags:['chu_ho']},
    m1_6:       {tieuDe:'Tổ chức Ngày Quốc tế Thiếu nhi 1/6',diaDiem:'Sân nhà văn hóa khu phố',noiDung:'1. Chương trình văn nghệ chào mừng Ngày Quốc tế Thiếu nhi\n2. Trao quà và phần thưởng cho các em thiếu nhi trong tổ\n3. Các trò chơi tập thể, vui chơi giải trí\n4. Phát động phong trào học tốt trong hè',tags:['chu_ho','tre_em']},
    trung_thu:  {tieuDe:'Vui hội Tết Trung Thu — Rước đèn phá cỗ',diaDiem:'Sân nhà văn hóa tổ dân phố',noiDung:'1. Chương trình văn nghệ mừng Tết Trung Thu\n2. Rước đèn quanh khu phố\n3. Phá cỗ trông trăng, phát quà cho thiếu nhi\n4. Trao học bổng khuyến học cho học sinh xuất sắc',tags:['chu_ho','tre_em','thanh_nien']},
    dang_vien:  {tieuDe:'Sinh hoạt chi bộ — Họp Đảng viên định kỳ',diaDiem:'Hội trường UBND phường',noiDung:'1. Đánh giá kết quả thực hiện Nghị quyết tháng trước\n2. Triển khai Nghị quyết, chỉ thị của cấp trên\n3. Kiểm điểm, đánh giá chất lượng Đảng viên\n4. Thảo luận công tác phát triển Đảng\n5. Phân công nhiệm vụ tháng tới',tags:['dang_vien']},
    ve_sinh:    {tieuDe:'Tổng vệ sinh môi trường — Ra quân dọn dẹp khu phố',diaDiem:'Tập trung tại đầu tổ dân phố',noiDung:'1. Phổ biến kế hoạch tổng vệ sinh, phân công khu vực\n2. Ra quân dọn dẹp vệ sinh đường phố, hẻm ngõ\n3. Thu gom rác thải, khơi thông cống rãnh\n4. Trồng cây xanh, chỉnh trang khuôn viên công cộng',tags:['chu_ho','thanh_nien']},
    bao_cao:    {tieuDe:'Họp tổng kết cuối năm — Báo cáo tình hình tổ dân phố',diaDiem:'Nhà văn hóa khu phố',noiDung:'1. Báo cáo tổng kết tình hình kinh tế – xã hội, an ninh trật tự cả năm\n2. Đánh giá kết quả thực hiện các chỉ tiêu được giao\n3. Biểu dương các hộ dân, cá nhân tiêu biểu\n4. Thông qua phương hướng, kế hoạch năm tới',tags:['chu_ho']},
    an_ninh:    {tieuDe:'Triển khai công tác đảm bảo an ninh trật tự khu phố',diaDiem:'Nhà văn hóa tổ dân phố',noiDung:'1. Thông báo tình hình an ninh trật tự, tội phạm trên địa bàn\n2. Triển khai phương án đảm bảo an ninh, phòng chống trộm cắp\n3. Vận động nhân dân tham gia tố giác tội phạm\n4. Hướng dẫn lắp đặt camera an ninh, đèn chiếu sáng\n5. Phân công lịch trực bảo vệ khu phố',tags:['chu_ho','cu_chien_binh']},
    phong_chay: {tieuDe:'Tập huấn Phòng cháy Chữa cháy và Cứu nạn Cứu hộ',diaDiem:'Sân nhà văn hóa tổ dân phố',noiDung:'1. Phổ biến kiến thức về phòng cháy chữa cháy tại hộ gia đình\n2. Hướng dẫn sử dụng bình chữa cháy xách tay\n3. Thực hành thoát hiểm khi có sự cố cháy nổ\n4. Kiểm tra công tác PCCC tại các hộ dân\n5. Giải đáp thắc mắc và ký cam kết đảm bảo PCCC',tags:['chu_ho','thanh_vien']},
    y_te:       {tieuDe:'Triển khai công tác y tế — Phòng chống dịch bệnh',diaDiem:'Nhà văn hóa tổ dân phố',noiDung:'1. Thông báo tình hình dịch bệnh trên địa bàn\n2. Hướng dẫn các biện pháp phòng chống dịch tại gia đình\n3. Vận động người dân tiêm vaccine đầy đủ\n4. Triển khai khai báo y tế điện tử\n5. Phân công lịch theo dõi sức khỏe cộng đồng',tags:['chu_ho','nguoi_cao_tuoi']},
    giao_thong: {tieuDe:'Triển khai Nghị quyết về An toàn Giao thông',diaDiem:'Nhà văn hóa tổ dân phố',noiDung:'1. Phổ biến các quy định mới về Luật Giao thông đường bộ\n2. Tuyên truyền ý thức chấp hành luật khi tham gia giao thông\n3. Vận động đội mũ bảo hiểm, không lái xe sau khi uống rượu bia\n4. Xử lý các điểm đỗ xe trái phép trong khu phố\n5. Ký cam kết thực hiện an toàn giao thông',tags:['chu_ho','thanh_nien']},
    le_tet:     {tieuDe:'Gặp mặt mừng Lễ – Tết — Chúc mừng toàn thể hộ dân',diaDiem:'Nhà văn hóa khu phố',noiDung:'1. Ôn lại truyền thống lịch sử, ý nghĩa ngày lễ lớn\n2. Văn nghệ chào mừng\n3. Trao quà, thăm hỏi các gia đình chính sách, hộ nghèo\n4. Gặp mặt thân mật, chúc Tết toàn thể bà con\n5. Thông báo lịch nghỉ lễ và kế hoạch sau Tết',tags:['chu_ho','nguoi_cao_tuoi','ho_ngheo']}
};

function applyMau(el, key) {
    document.querySelectorAll('.mau-item').forEach(i => i.classList.remove('active'));
    el.classList.add('active');
    const m = MAU[key]; if (!m) return;
    const tieuDeEl = document.getElementById('tieuDe');
    if (key === 'blank') {
        tieuDeEl.removeAttribute('readonly');
        tieuDeEl.style.cursor = '';
        tieuDeEl.style.opacity = '1';
        tieuDeEl.placeholder = 'Nhập tiêu đề hoặc chọn mẫu bên trái';
        tieuDeEl.value = '';
    } else {
        tieuDeEl.setAttribute('readonly', true);
        tieuDeEl.style.cursor = 'not-allowed';
        tieuDeEl.style.opacity = '0.75';
        tieuDeEl.value = m.tieuDe;
    }
    document.getElementById('diaDiem').value = m.diaDiem;
    document.getElementById('noiDung').value = m.noiDung;
    document.getElementById('lenNoiDung').textContent = m.noiDung.length;
    document.querySelectorAll('.dt-tag').forEach(tag => {
        tag.classList.remove('on');
        tag.querySelector('input').checked = false;
    });
    m.tags.forEach(val => {
        const inp = document.querySelector('.dt-tag input[value="'+val+'"]');
        if (inp) { inp.checked = true; inp.closest('.dt-tag').classList.add('on'); }
    });
}

document.querySelectorAll('.dt-tag').forEach(tag => {
    tag.addEventListener('click', function(e){
        e.preventDefault();
        const inp = this.querySelector('input');
        inp.checked = !inp.checked;
        this.classList.toggle('on', inp.checked);
    });
});

document.getElementById('formTao').addEventListener('submit', function(e){
    const tgbd = document.getElementById('tgbd').value;
    const tgkt = document.getElementById('tgkt').value;
    if (!tgbd) { e.preventDefault(); alert('Vui lòng chọn thời gian bắt đầu!'); return; }
    if (tgkt && tgkt <= tgbd) { e.preventDefault(); alert('Thời gian kết thúc phải sau thời gian bắt đầu!'); }
});
</script>
</body>
</html>
