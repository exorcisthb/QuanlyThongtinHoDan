<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kết quả quét QR</title>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg:#0f1117; --surface:#181c27; --surface2:#1f2433;
            --border:#2a3048; --accent:#4f8ef7; --accent2:#38d9a9;
            --danger:#f75c5c; --warn:#fbbf24; --text:#e2e8f0; --muted:#64748b; --radius:14px;
        }
        *{box-sizing:border-box;margin:0;padding:0}
        body{font-family:'Be Vietnam Pro',sans-serif;background:var(--bg);color:var(--text);min-height:100vh;padding:40px 24px}
        .content{max-width:800px;margin:0 auto}

        .back-btn{display:inline-flex;align-items:center;gap:6px;font-size:13px;color:var(--muted);text-decoration:none;margin-bottom:24px;transition:color .15s;background:none;border:none;cursor:pointer;font-family:inherit}
        .back-btn:hover{color:var(--accent)}

        .page-header{margin-bottom:28px}
        .page-title{font-size:22px;font-weight:800;margin-bottom:4px}
        .page-sub{font-size:13px;color:var(--muted)}

        /* SCANNER INFO */
        .scanner-bar{
            background:var(--surface2);border:1px solid var(--border);
            border-radius:10px;padding:12px 18px;
            display:flex;align-items:center;gap:10px;
            font-size:12px;color:var(--muted);margin-bottom:24px;
        }
        .scanner-avatar{
            width:30px;height:30px;border-radius:50%;
            background:linear-gradient(135deg,var(--accent),var(--accent2));
            display:flex;align-items:center;justify-content:center;
            font-size:11px;font-weight:700;color:#fff;flex-shrink:0;
        }
        .scanner-name{font-weight:600;color:var(--text)}
        .scanner-time{margin-left:auto;font-size:11px}

        /* CARDS */
        .card{background:var(--surface);border:1px solid var(--border);border-radius:var(--radius);padding:24px;margin-bottom:20px}
        .card-title{font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:1px;color:var(--muted);margin-bottom:18px;display:flex;align-items:center;gap:8px}
        .card-title::after{content:'';flex:1;height:1px;background:var(--border)}

        /* INFO GRID */
        .info-grid{display:grid;grid-template-columns:1fr 1fr;gap:14px}
        .info-full{grid-column:1/-1}
        .info-item{}
        .info-label{font-size:11px;color:var(--muted);font-weight:600;text-transform:uppercase;letter-spacing:.5px;margin-bottom:4px}
        .info-val{font-size:14px;font-weight:600;color:var(--text)}

        /* BADGE */
        .badge{display:inline-block;padding:3px 10px;border-radius:20px;font-size:11px;font-weight:700}
        .badge-green{background:rgba(56,217,169,.15);color:var(--accent2)}
        .badge-blue{background:rgba(79,142,247,.15);color:var(--accent)}
        .badge-warn{background:rgba(251,191,36,.15);color:var(--warn)}
        .badge-red{background:rgba(247,92,92,.15);color:var(--danger)}

        /* TABLE */
        .table-wrap{overflow-x:auto}
        table{width:100%;border-collapse:collapse;font-size:13px}
        th{background:var(--surface2);padding:10px 14px;text-align:left;font-weight:600;color:var(--muted);font-size:11px;text-transform:uppercase;letter-spacing:.5px;border-bottom:1px solid var(--border);white-space:nowrap}
        td{padding:11px 14px;border-bottom:1px solid var(--border);color:var(--text);vertical-align:middle}
        tr:last-child td{border-bottom:none}
        tr:hover td{background:var(--surface2)}
        .chu-ho-tag{display:inline-block;background:rgba(56,217,169,.15);color:var(--accent2);font-size:10px;font-weight:700;padding:2px 7px;border-radius:20px;margin-left:6px}

        /* ERROR */
        .error-box{background:rgba(247,92,92,.1);border:1px solid rgba(247,92,92,.3);border-radius:var(--radius);padding:40px;text-align:center;color:var(--danger)}
        .error-icon{font-size:36px;margin-bottom:12px}

        /* PRINT */
        @media print {
            .back-btn, .no-print{display:none}
            body{background:#fff;color:#000;padding:20px}
            .card{border:1px solid #ddd;background:#fff}
            .scanner-bar{background:#f5f5f5;border:1px solid #ddd}
        }
    </style>
</head>
<body>
<div class="content">

    <button class="back-btn" onclick="history.back()">← Quay lại</button>

    <c:choose>
        <c:when test="${not empty error}">
            <div class="error-box">
                <div class="error-icon">⚠️</div>
                <p style="font-size:17px;font-weight:800;margin-bottom:8px">Không thể đọc mã QR</p>
                <p style="font-size:13px">${error}</p>
            </div>
        </c:when>

        <c:otherwise>
            <div class="page-header">
                <div class="page-title">Thông tin hộ dân</div>
                <div class="page-sub">Kết quả quét mã QR hộ khẩu</div>
            </div>

            <!-- NGƯỜI QUÉT -->
            <div class="scanner-bar">
                <div class="scanner-avatar">
                    ${scanner.ten.substring(scanner.ten.lastIndexOf(' ') + 1, scanner.ten.lastIndexOf(' ') + 2).toUpperCase()}
                </div>
                <div>
                    Quét bởi <span class="scanner-name">${scanner.ho} ${scanner.ten}</span>
                    — <span style="color:var(--accent2)">${scanner.tenVaiTro}</span>
                </div>
                <div class="scanner-time" id="scanTime"></div>
            </div>

            <!-- THÔNG TIN HỘ KHẨU -->
            <div class="card">
                <div class="card-title">Thông tin hộ khẩu</div>
                <div class="info-grid">
                    <div class="info-item">
                        <div class="info-label">Mã hộ khẩu</div>
                        <div class="info-val">${hoDan.maHoKhau}</div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Tổ dân phố</div>
                        <div class="info-val">${hoDan.tenTo}</div>
                    </div>
                    <div class="info-item info-full">
                        <div class="info-label">Địa chỉ</div>
                        <div class="info-val">${hoDan.diaChi}</div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Chủ hộ</div>
                        <div class="info-val">
                            ${hoDan.tenChuHo}
                            <span class="badge badge-green">Chủ hộ</span>
                        </div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Trạng thái</div>
                        <div class="info-val">
                            <span class="badge badge-green">${hoDan.tenTrangThai}</span>
                        </div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Số nhân khẩu</div>
                        <div class="info-val" style="color:var(--accent2);font-size:18px">
                            ${hoDan.soThanhVien} <span style="font-size:13px;color:var(--muted)">người</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- DANH SÁCH NHÂN KHẨU -->
            <div class="card">
                <div class="card-title">Danh sách nhân khẩu (${hoDan.soThanhVien} người)</div>
                <c:choose>
                    <c:when test="${not empty danhSachTV}">
                        <div class="table-wrap">
                            <table>
                                <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>Họ tên</th>
                                        <th>Quan hệ</th>
                                        <th>Ngày sinh</th>
                                        <th>Giới tính</th>
                                        <th>CCCD</th>
                                        <th>SĐT</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="tv" items="${danhSachTV}" varStatus="st">
                                        <tr>
                                            <td style="color:var(--muted);font-size:12px">${st.index + 1}</td>
                                            <td>
                                                <span style="font-weight:700">${tv.ho} ${tv.ten}</span>
                                                <c:if test="${tv.tenQuanHe == 'Chủ hộ' || tv.tenQuanHe == 'Chu ho'}">
                                                    <span class="chu-ho-tag">Chủ hộ</span>
                                                </c:if>
                                            </td>
                                            <td>
                                                <span class="badge badge-blue">${tv.tenQuanHe}</span>
                                            </td>
                                            <td>
                                                <fmt:formatDate value="${tv.ngaySinh}" pattern="dd/MM/yyyy"/>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${tv.gioiTinh == 'Nam'}">
                                                        <span class="badge badge-blue">Nam</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge badge-warn">Nữ</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td style="font-family:monospace;font-size:12px;color:var(--muted)">${tv.cccd}</td>
                                            <td style="font-size:12px">${tv.soDienThoai}</td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div style="padding:24px;text-align:center;color:var(--muted);font-size:13px">
                            Không có dữ liệu nhân khẩu
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- NÚT IN -->
            <div style="text-align:center;margin-top:8px" class="no-print">
                <button onclick="window.print()"
                    style="background:rgba(79,142,247,.15);color:var(--accent);border:1px solid rgba(79,142,247,.3);border-radius:8px;padding:10px 24px;font-size:13px;font-weight:600;cursor:pointer;font-family:inherit;transition:all .18s"
                    onmouseover="this.style.background='var(--accent)';this.style.color='#fff'"
                    onmouseout="this.style.background='rgba(79,142,247,.15)';this.style.color='var(--accent)'">
                    🖨️ In thông tin
                </button>
            </div>

        </c:otherwise>
    </c:choose>

</div>

<script>
    // Hiển thị thời gian quét
    document.getElementById('scanTime') &&
    (document.getElementById('scanTime').textContent =
        new Date().toLocaleString('vi-VN', {
            day:'2-digit', month:'2-digit', year:'numeric',
            hour:'2-digit', minute:'2-digit'
        }));
</script>
</body>
</html>