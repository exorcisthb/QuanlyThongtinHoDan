<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Dashboard Admin - Quản lý Hộ dân</title>
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <style>
            :root {
                --bg:        #0f1117;
                --surface:   #181c27;
                --surface2:  #1f2433;
                --border:    #2a3048;
                --accent:    #4f8ef7;
                --accent2:   #38d9a9;
                --danger:    #f75c5c;
                --warn:      #fbbf24;
                --text:      #e2e8f0;
                --muted:     #64748b;
                --radius:    12px;
            }
            *, *::before, *::after {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }
            body {
                font-family: 'Be Vietnam Pro', sans-serif;
                background: var(--bg);
                color: var(--text);
                min-height: 100vh;
            }
            .layout {
                display: flex;
                min-height: 100vh;
            }
            .sidebar {
                width: 260px;
                background: var(--surface);
                border-right: 1px solid var(--border);
                display: flex;
                flex-direction: column;
                padding: 28px 16px;
                position: fixed;
                top: 0;
                left: 0;
                bottom: 0;
                z-index: 100;
            }
            .sidebar-logo {
                display: flex;
                align-items: center;
                gap: 10px;
                padding: 0 8px 28px;
                border-bottom: 1px solid var(--border);
                margin-bottom: 24px;
            }
            .logo-icon {
                width: 36px;
                height: 36px;
                border-radius: 8px;
                background: linear-gradient(135deg, var(--accent), var(--accent2));
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 18px;
            }
            .logo-text {
                font-size: 15px;
                font-weight: 700;
                letter-spacing: -.3px;
            }
            .logo-text span {
                color: var(--accent);
            }
            .sidebar-spacer {
                flex: 1;
            }
            .user-bar {
                position: relative;
                margin-top: auto;
                padding-top: 16px;
                border-top: 1px solid var(--border);
            }
            .user-bar-btn {
                display: flex;
                align-items: center;
                gap: 10px;
                width: 100%;
                padding: 10px;
                background: none;
                border: 1px solid transparent;
                border-radius: 10px;
                cursor: pointer;
                transition: all .18s;
                color: var(--text);
                font-family: inherit;
            }
            .user-bar-btn:hover {
                background: var(--surface2);
                border-color: var(--border);
            }
            .avatar {
                width: 36px;
                height: 36px;
                border-radius: 50%;
                background: linear-gradient(135deg, var(--accent), var(--accent2));
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 14px;
                font-weight: 700;
                color: #fff;
                flex-shrink: 0;
                text-transform: uppercase;
            }
            .user-bar-info {
                flex: 1;
                text-align: left;
                overflow: hidden;
            }
            .user-bar-name {
                font-size: 13px;
                font-weight: 600;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
            }
            .user-bar-role {
                font-size: 11px;
                color: var(--muted);
            }
            .user-bar-chevron {
                font-size: 16px;
                color: var(--muted);
                transition: transform .2s;
            }
            .user-bar-btn.open .user-bar-chevron {
                transform: rotate(180deg);
            }
            .user-popup {
                position: absolute;
                bottom: calc(100% + 8px);
                left: 0;
                right: 0;
                background: var(--surface2);
                border: 1px solid var(--border);
                border-radius: 12px;
                padding: 6px;
                box-shadow: 0 -8px 32px rgba(0,0,0,.4);
                display: none;
                z-index: 200;
            }
            .user-popup.open {
                display: block;
            }
            .popup-header {
                display: flex;
                align-items: center;
                gap: 10px;
                padding: 10px 10px 12px;
                border-bottom: 1px solid var(--border);
                margin-bottom: 6px;
            }
            .popup-header .avatar {
                width: 40px;
                height: 40px;
                font-size: 16px;
            }
            .popup-full-name {
                font-size: 13px;
                font-weight: 700;
            }
            .popup-email {
                font-size: 11px;
                color: var(--muted);
            }
            .badge {
                display: inline-flex;
                align-items: center;
                gap: 5px;
                font-size: 10px;
                font-weight: 600;
                padding: 2px 7px;
                border-radius: 20px;
                margin-top: 4px;
            }
            .badge.active   {
                background: rgba(56,217,169,.15);
                color: var(--accent2);
            }
            .badge.inactive {
                background: rgba(247,92,92,.15);
                color: var(--danger);
            }
            .badge::before  {
                content: '';
                width: 5px;
                height: 5px;
                border-radius: 50%;
                background: currentColor;
            }
            .popup-item {
                display: flex;
                align-items: center;
                gap: 10px;
                padding: 9px 10px;
                border-radius: 8px;
                font-size: 13px;
                font-weight: 500;
                color: var(--text);
                cursor: pointer;
                transition: background .15s;
                text-decoration: none;
            }
            .popup-item:hover {
                background: var(--surface);
            }
            .popup-item .pi-icon {
                font-size: 16px;
                width: 20px;
                text-align: center;
            }
            .popup-item.danger {
                color: var(--danger);
            }
            .popup-item.danger:hover {
                background: rgba(247,92,92,.1);
            }
            .popup-divider {
                border: none;
                border-top: 1px solid var(--border);
                margin: 6px 0;
            }
            .nav-section {
                font-size: 10px;
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: 1.2px;
                color: var(--muted);
                padding: 0 8px;
                margin-bottom: 8px;
            }
            .nav-item {
                display: flex;
                align-items: center;
                gap: 10px;
                padding: 10px 12px;
                border-radius: 8px;
                cursor: pointer;
                font-size: 14px;
                font-weight: 500;
                color: var(--muted);
                transition: all .18s;
                margin-bottom: 2px;
                user-select: none;
                border: 1px solid transparent;
                text-decoration: none;
            }
            .nav-item:hover {
                background: var(--surface2);
                color: var(--text);
            }
            .nav-item.active {
                background: rgba(79,142,247,.12);
                color: var(--accent);
                border-color: rgba(79,142,247,.25);
            }
            .nav-icon {
                font-size: 18px;
                width: 22px;
                text-align: center;
            }
            .main {
                margin-left: 260px;
                flex: 1;
                padding: 36px 40px;
                max-width: calc(100vw - 260px);
            }
            .page-header {
                margin-bottom: 32px;
            }
            .page-header h1 {
                font-size: 24px;
                font-weight: 700;
                margin-bottom: 4px;
            }
            .page-header p  {
                font-size: 14px;
                color: var(--muted);
            }
            .breadcrumb {
                font-size: 12px;
                color: var(--muted);
                margin-bottom: 8px;
            }
            .breadcrumb span {
                color: var(--accent);
            }
            .tab-panel {
                display: none;
            }
            .tab-panel.active {
                display: block;
                animation: fadeUp .25s ease;
            }
            @keyframes fadeUp {
                from {
                    opacity: 0;
                    transform: translateY(10px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }
            .card {
                background: var(--surface);
                border: 1px solid var(--border);
                border-radius: var(--radius);
                padding: 28px;
                margin-bottom: 24px;
            }
            .card-header {
                display: flex;
                align-items: center;
                gap: 12px;
                margin-bottom: 24px;
                padding-bottom: 16px;
                border-bottom: 1px solid var(--border);
            }
            .card-icon {
                width: 40px;
                height: 40px;
                border-radius: 10px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 20px;
            }
            .card-icon.blue  {
                background: rgba(79,142,247,.15);
            }
            .card-icon.green {
                background: rgba(56,217,169,.15);
            }
            .card-icon.warn  {
                background: rgba(251,191,36,.15);
            }
            .card-icon.red   {
                background: rgba(247,92,92,.15);
            }
            .card-title {
                font-size: 16px;
                font-weight: 700;
            }
            .card-sub   {
                font-size: 12px;
                color: var(--muted);
                margin-top: 2px;
            }
            .form-grid {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 18px;
            }
            .form-group {
                display: flex;
                flex-direction: column;
                gap: 6px;
            }
            .form-group.full {
                grid-column: 1 / -1;
            }
            label {
                font-size: 12px;
                font-weight: 600;
                color: var(--muted);
                text-transform: uppercase;
                letter-spacing: .6px;
            }
            input[type="text"], input[type="email"], input[type="password"], input[type="date"], select {
                background: var(--surface2);
                border: 1px solid var(--border);
                color: var(--text);
                padding: 10px 14px;
                border-radius: 8px;
                font-size: 14px;
                font-family: inherit;
                transition: border-color .18s, box-shadow .18s;
                width: 100%;
            }
            input:focus, select:focus {
                outline: none;
                border-color: var(--accent);
                box-shadow: 0 0 0 3px rgba(79,142,247,.18);
            }
            select option {
                background: var(--surface2);
            }
            .radio-group {
                display: flex;
                gap: 12px;
                flex-wrap: wrap;
            }
            .radio-option {
                display: flex;
                align-items: center;
                gap: 8px;
                background: var(--surface2);
                border: 1px solid var(--border);
                border-radius: 8px;
                padding: 10px 16px;
                cursor: pointer;
                font-size: 13px;
                font-weight: 500;
                transition: all .15s;
            }
            .radio-option input {
                width: auto;
            }
            .btn {
                display: inline-flex;
                align-items: center;
                gap: 8px;
                padding: 11px 22px;
                border-radius: 8px;
                font-size: 14px;
                font-weight: 600;
                font-family: inherit;
                border: none;
                cursor: pointer;
                transition: all .18s;
                text-decoration: none;
            }
            .btn-primary   {
                background: var(--accent);
                color: #fff;
            }
            .btn-primary:hover {
                background: #3a7de8;
                box-shadow: 0 4px 16px rgba(79,142,247,.35);
            }
            .btn-secondary {
                background: var(--surface2);
                color: var(--text);
                border: 1px solid var(--border);
            }
            .btn-secondary:hover {
                border-color: var(--accent);
                color: var(--accent);
            }
            .btn-danger    {
                background: rgba(247,92,92,.15);
                color: var(--danger);
                border: 1px solid rgba(247,92,92,.3);
            }
            .btn-danger:hover  {
                background: var(--danger);
                color: #fff;
            }
            .btn-warn      {
                background: rgba(251,191,36,.15);
                color: var(--warn);
                border: 1px solid rgba(251,191,36,.3);
            }
            .btn-warn:hover    {
                background: var(--warn);
                color: #000;
            }
            .btn-green     {
                background: rgba(56,217,169,.15);
                color: var(--accent2);
                border: 1px solid rgba(56,217,169,.3);
            }
            .btn-green:hover   {
                background: var(--accent2);
                color: #000;
            }
            .form-actions {
                display: flex;
                gap: 10px;
                margin-top: 24px;
                padding-top: 20px;
                border-top: 1px solid var(--border);
            }
            .alert {
                display: flex;
                align-items: flex-start;
                gap: 12px;
                padding: 14px 18px;
                border-radius: 8px;
                font-size: 13px;
                margin-bottom: 24px;
            }
            .alert.success {
                background: rgba(56,217,169,.1);
                border: 1px solid rgba(56,217,169,.25);
                color: var(--accent2);
            }
            .alert.error   {
                background: rgba(247,92,92,.1);
                border: 1px solid rgba(247,92,92,.25);
                color: var(--danger);
            }
            .alert-icon {
                font-size: 16px;
            }
            .maintain-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
                gap: 16px;
            }
            .maintain-card {
                background: var(--surface2);
                border: 1px solid var(--border);
                border-radius: var(--radius);
                padding: 22px;
                transition: border-color .18s;
            }
            .maintain-card:hover {
                border-color: var(--accent);
            }
            .maintain-card .mc-icon {
                font-size: 28px;
                margin-bottom: 12px;
            }
            .maintain-card h3 {
                font-size: 14px;
                font-weight: 700;
                margin-bottom: 6px;
            }
            .maintain-card p  {
                font-size: 12px;
                color: var(--muted);
                margin-bottom: 16px;
                line-height: 1.6;
            }
            .status-list {
                display: flex;
                flex-direction: column;
                gap: 10px;
            }
            .status-row {
                display: flex;
                align-items: center;
                justify-content: space-between;
                background: var(--surface2);
                border: 1px solid var(--border);
                border-radius: 8px;
                padding: 12px 16px;
            }
            .status-row .sr-label {
                font-size: 13px;
                font-weight: 500;
            }
            .status-row .sr-val   {
                font-size: 13px;
                color: var(--muted);
            }
            .pw-bar  {
                height: 4px;
                border-radius: 2px;
                background: var(--border);
                margin-top: 6px;
                overflow: hidden;
            }
            .pw-fill {
                height: 100%;
                border-radius: 2px;
                width: 0;
                transition: width .3s, background .3s;
            }
            .divider {
                border: none;
                border-top: 1px solid var(--border);
                margin: 24px 0;
            }
            .role-selector {
                display: flex;
                gap: 10px;
                margin-bottom: 24px;
            }
            .role-btn {
                flex: 1;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 10px;
                padding: 14px 20px;
                border-radius: 10px;
                border: 2px solid var(--border);
                background: var(--surface2);
                color: var(--muted);
                font-size: 14px;
                font-weight: 600;
                font-family: inherit;
                cursor: pointer;
                transition: all .2s;
            }
            .role-btn:hover {
                border-color: var(--accent);
                color: var(--text);
            }
            .role-btn.selected-totruong {
                border-color: var(--accent);
                background: rgba(79,142,247,.12);
                color: var(--accent);
            }
            .role-btn.selected-canbo   {
                border-color: var(--accent2);
                background: rgba(56,217,169,.12);
                color: var(--accent2);
            }
            .role-btn .rb-icon  {
                font-size: 20px;
            }
            .role-btn .rb-label {
                line-height: 1.2;
                text-align: left;
            }
            .role-btn .rb-sub   {
                font-size: 11px;
                font-weight: 400;
                opacity: .7;
                display: block;
            }
            .ds-toolbar {
                display: flex;
                align-items: center;
                gap: 10px;
                padding: 16px 20px;
                background: var(--surface);
                border: 1px solid var(--border);
                border-radius: var(--radius);
                margin-bottom: 16px;
            }
            .ds-search-wrap {
                position: relative;
                flex: 1;
            }
            .ds-search-icon {
                position: absolute;
                left: 12px;
                top: 50%;
                transform: translateY(-50%);
                color: var(--muted);
                pointer-events: none;
                display: flex;
            }
            .ds-search-wrap input {
                width: 100%;
                padding: 10px 14px 10px 38px;
                background: var(--surface2);
                border: 1px solid var(--border);
                border-radius: 8px;
                color: var(--text);
                font-size: 13.5px;
                font-family: inherit;
                transition: border-color .18s, box-shadow .18s;
            }
            .ds-search-wrap input:focus {
                outline: none;
                border-color: var(--accent);
                box-shadow: 0 0 0 3px rgba(79,142,247,.15);
            }
            .ds-search-wrap input::placeholder {
                color: var(--muted);
            }
            .filter-wrapper {
                position: relative;
            }
            .btn-filter {
                display: inline-flex;
                align-items: center;
                gap: 7px;
                padding: 10px 16px;
                border-radius: 8px;
                font-size: 13.5px;
                font-weight: 600;
                font-family: inherit;
                background: var(--surface2);
                color: var(--muted);
                border: 1px solid var(--border);
                cursor: pointer;
                transition: all .18s;
                white-space: nowrap;
                user-select: none;
            }
            .btn-filter:hover {
                border-color: var(--accent);
                color: var(--accent);
            }
            .btn-filter.active-filter {
                border-color: var(--accent);
                background: rgba(79,142,247,.12);
                color: var(--accent);
            }
            .filter-count {
                display: none;
                align-items: center;
                justify-content: center;
                min-width: 18px;
                height: 18px;
                padding: 0 5px;
                border-radius: 9px;
                background: var(--accent);
                color: #fff;
                font-size: 10px;
                font-weight: 700;
            }
            .btn-filter.active-filter .filter-count {
                display: inline-flex;
            }
            .filter-dropdown {
                position: absolute;
                top: calc(100% + 8px);
                right: 0;
                width: 300px;
                background: var(--surface);
                border: 1px solid var(--border);
                border-radius: 14px;
                box-shadow: 0 20px 60px rgba(0,0,0,.6);
                z-index: 600;
                display: none;
                overflow: hidden;
            }
            .filter-dropdown.open {
                display: block;
                animation: dropIn .18s cubic-bezier(.22,.68,0,1.2);
            }
            @keyframes dropIn {
                from {
                    opacity: 0;
                    transform: translateY(-8px) scale(.97);
                }
                to {
                    opacity: 1;
                    transform: translateY(0) scale(1);
                }
            }
            .fd-header {
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 14px 16px;
                border-bottom: 1px solid var(--border);
                background: var(--surface2);
            }
            .fd-title {
                font-size: 13px;
                font-weight: 700;
                color: var(--text);
                display: flex;
                align-items: center;
                gap: 7px;
            }
            .fd-title svg {
                color: var(--accent);
            }
            .fd-clear-btn {
                font-size: 11px;
                font-weight: 600;
                color: var(--danger);
                background: none;
                border: none;
                cursor: pointer;
                font-family: inherit;
                padding: 4px 8px;
                border-radius: 6px;
                transition: background .15s;
            }
            .fd-clear-btn:hover {
                background: rgba(247,92,92,.12);
            }
            .fd-section {
                padding: 14px 16px;
            }
            .fd-section + .fd-section {
                border-top: 1px solid var(--border);
            }
            .fd-section-label {
                font-size: 10px;
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: 1px;
                color: var(--muted);
                margin-bottom: 10px;
            }
            .fd-chips {
                display: flex;
                flex-wrap: wrap;
                gap: 7px;
            }
            .fd-chip {
                display: inline-flex;
                align-items: center;
                gap: 5px;
                padding: 5px 12px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 600;
                background: var(--surface2);
                border: 1px solid var(--border);
                color: var(--muted);
                cursor: pointer;
                transition: all .15s;
                user-select: none;
            }
            .fd-chip:hover {
                border-color: var(--accent);
                color: var(--text);
            }
            .fd-chip-dot {
                width: 6px;
                height: 6px;
                border-radius: 50%;
                background: currentColor;
                flex-shrink: 0;
            }
            .fd-chip.sel-all    {
                border-color: var(--accent);
                background: rgba(79,142,247,.15);
                color: var(--accent);
            }
            .fd-chip.sel-active {
                border-color: var(--accent2);
                background: rgba(56,217,169,.15);
                color: var(--accent2);
            }
            .fd-chip.sel-locked {
                border-color: var(--danger);
                background: rgba(247,92,92,.15);
                color: var(--danger);
            }
            .fd-chip.sel-to     {
                border-color: var(--accent);
                background: rgba(79,142,247,.15);
                color: var(--accent);
            }
            .fd-footer {
                display: flex;
                gap: 8px;
                padding: 12px 16px;
                border-top: 1px solid var(--border);
                background: var(--surface2);
            }
            .fd-footer .btn {
                flex: 1;
                justify-content: center;
                padding: 9px 12px;
                font-size: 13px;
            }
            .ds-stats {
                display: flex;
                gap: 12px;
                margin-bottom: 16px;
            }
            .ds-stat {
                flex: 1;
                background: var(--surface);
                border: 1px solid var(--border);
                border-radius: 10px;
                padding: 14px 18px;
                display: flex;
                align-items: center;
                gap: 12px;
            }
            .ds-stat-icon {
                width: 36px;
                height: 36px;
                border-radius: 8px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 17px;
                flex-shrink: 0;
            }
            .ds-stat-icon.blue  {
                background: rgba(79,142,247,.15);
            }
            .ds-stat-icon.green {
                background: rgba(56,217,169,.15);
            }
            .ds-stat-icon.red   {
                background: rgba(247,92,92,.15);
            }
            .ds-stat-val {
                font-size: 22px;
                font-weight: 700;
                line-height: 1;
                margin-bottom: 2px;
            }
            .ds-stat-lbl {
                font-size: 11px;
                color: var(--muted);
                font-weight: 500;
            }
            .ds-table-wrap {
                background: var(--surface);
                border: 1px solid var(--border);
                border-radius: var(--radius);
                overflow: hidden;
            }
            .ds-table {
                width: 100%;
                border-collapse: collapse;
                font-size: 13px;
            }
            .ds-table thead tr {
                background: var(--surface2);
            }
            .ds-table th {
                padding: 12px 16px;
                text-align: left;
                color: var(--muted);
                font-weight: 600;
                font-size: 11px;
                text-transform: uppercase;
                letter-spacing: .5px;
                border-bottom: 1px solid var(--border);
                white-space: nowrap;
            }
            .ds-table th.center, .ds-table td.center {
                text-align: center;
            }
            .ds-table tbody tr {
                border-bottom: 1px solid var(--border);
                transition: background .12s;
            }
            .ds-table tbody tr:last-child {
                border-bottom: none;
            }
            .ds-table tbody tr:hover {
                background: rgba(79,142,247,.04);
            }
            .ds-table td {
                padding: 13px 16px;
                vertical-align: middle;
            }
            .tt-cell {
                display: flex;
                align-items: center;
                gap: 10px;
            }
            .tt-avatar {
                width: 34px;
                height: 34px;
                border-radius: 50%;
                background: linear-gradient(135deg, var(--accent), var(--accent2));
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 13px;
                font-weight: 700;
                color: #fff;
                flex-shrink: 0;
                text-transform: uppercase;
            }
            .tt-name {
                font-weight: 600;
                font-size: 13px;
            }
            .tt-sub  {
                font-size: 11px;
                color: var(--muted);
                margin-top: 1px;
            }
            .mono {
                font-family: 'Courier New', monospace;
                font-size: 12px;
                color: var(--muted);
                letter-spacing: .3px;
            }
            .to-badge {
                display: inline-flex;
                align-items: center;
                gap: 5px;
                background: rgba(79,142,247,.12);
                color: var(--accent);
                border: 1px solid rgba(79,142,247,.25);
                padding: 3px 10px;
                border-radius: 20px;
                font-size: 11px;
                font-weight: 600;
            }
            .pill {
                font-size: 11px;
                font-weight: 600;
                padding: 4px 11px;
                border-radius: 20px;
                display: inline-flex;
                align-items: center;
                gap: 5px;
            }
            .pill::before {
                content: '';
                width: 5px;
                height: 5px;
                border-radius: 50%;
                background: currentColor;
            }
            .pill.ok   {
                background: rgba(56,217,169,.12);
                color: var(--accent2);
                border: 1px solid rgba(56,217,169,.25);
            }
            .pill.err  {
                background: rgba(247,92,92,.12);
                color: var(--danger);
                border: 1px solid rgba(247,92,92,.25);
            }
            .pill.warn {
                background: rgba(251,191,36,.12);
                color: var(--warn);
                border: 1px solid rgba(251,191,36,.25);
            }
            .ds-footer {
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 12px 18px;
                background: var(--surface2);
                border-top: 1px solid var(--border);
                font-size: 12px;
                color: var(--muted);
            }
            .ds-footer strong {
                color: var(--text);
            }
            .active-filters {
                display: flex;
                align-items: center;
                gap: 8px;
                flex-wrap: wrap;
                margin-bottom: 12px;
            }
            .af-label {
                font-size: 11px;
                color: var(--muted);
                font-weight: 600;
            }
            .af-chip {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                padding: 4px 10px;
                border-radius: 20px;
                font-size: 11px;
                font-weight: 600;
                background: rgba(79,142,247,.12);
                color: var(--accent);
                border: 1px solid rgba(79,142,247,.25);
            }
            .af-chip a {
                color: inherit;
                text-decoration: none;
                opacity: .7;
                margin-left: 2px;
                transition: opacity .15s;
            }
            .af-chip a:hover {
                opacity: 1;
            }
            .empty-state {
                text-align: center;
                padding: 60px 20px;
                color: var(--muted);
            }
            .empty-state .es-icon {
                font-size: 44px;
                margin-bottom: 14px;
            }
            .empty-state p {
                font-size: 14px;
                margin-bottom: 16px;
            }

            /* ══ DROPDOWN TRẠNG THÁI NHÂN SỰ INLINE ══ */
            .ts-wrap {
                position: relative;
                display: inline-block;
            }
            .ts-btn {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                padding: 6px 12px;
                border-radius: 20px;
                font-size: 11px;
                font-weight: 600;
                font-family: inherit;
                border: 1px solid;
                cursor: pointer;
                transition: all .15s;
                white-space: nowrap;
                user-select: none;
            }
            .ts-btn:hover {
                filter: brightness(1.18);
            }
            .ts-s1 {
                background: rgba(56,217,169,.12);
                color: var(--accent2);
                border-color: rgba(56,217,169,.35);
            }
            .ts-s2 {
                background: rgba(251,191,36,.12);
                color: var(--warn);
                border-color: rgba(251,191,36,.35);
            }
            .ts-s3 {
                background: rgba(247,92,92,.12);
                color: var(--danger);
                border-color: rgba(247,92,92,.35);
            }
            .ts-chevron {
                font-size: 9px;
                opacity: .65;
                transition: transform .18s;
                margin-left: 2px;
            }
            .ts-btn.open .ts-chevron {
                transform: rotate(180deg);
            }
            .ts-menu {
                position: absolute;
                top: calc(100% + 6px);
                left: 50%;
                transform: translateX(-50%);
                background: var(--surface);
                border: 1px solid var(--border);
                border-radius: 10px;
                padding: 5px;
                min-width: 200px;
                box-shadow: 0 16px 48px rgba(0,0,0,.55);
                z-index: 800;
                animation: dropIn .15s ease;
            }
            .ts-item {
                display: flex;
                align-items: center;
                gap: 9px;
                width: 100%;
                padding: 9px 12px;
                border-radius: 7px;
                font-size: 12px;
                font-weight: 600;
                font-family: inherit;
                background: none;
                border: none;
                cursor: pointer;
                color: var(--text);
                transition: background .12s;
                text-align: left;
            }
            .ts-item-1:hover {
                background: rgba(56,217,169,.12);
                color: var(--accent2);
            }
            .ts-item-2:hover {
                background: rgba(251,191,36,.12);
                color: var(--warn);
            }
            .ts-item-3:hover {
                background: rgba(247,92,92,.12);
                color: var(--danger);
            }

            /* ══ MODAL ĐĂNG XUẤT ══ */
            .logout-overlay { display:none; position:fixed; inset:0; z-index:9999; background:rgba(0,0,0,.7); backdrop-filter:blur(6px); align-items:center; justify-content:center; }
            .logout-overlay.show { display:flex; animation:fadeInModal .2s ease; }
            @keyframes fadeInModal { from{opacity:0} to{opacity:1} }
            .logout-box { background:var(--surface); border:1px solid var(--border); border-radius:16px; width:380px; max-width:calc(100vw - 32px); box-shadow:0 24px 64px rgba(0,0,0,.6); overflow:hidden; animation:popIn .22s cubic-bezier(.34,1.56,.64,1); }
            @keyframes popIn { from{opacity:0;transform:scale(.93) translateY(10px)} to{opacity:1;transform:none} }
            .logout-body { padding:28px 28px 20px; text-align:center; }
            .logout-ico { font-size:40px; margin-bottom:14px; }
            .logout-title { font-size:17px; font-weight:800; margin-bottom:6px; }
            .logout-sub { font-size:13px; color:var(--muted); line-height:1.5; }
            .logout-footer { padding:16px 24px 24px; display:flex; gap:10px; }
            .btn-logout-cancel { flex:1; height:40px; border-radius:10px; background:var(--surface2); border:1px solid var(--border); color:var(--muted); font-size:13px; font-weight:600; font-family:inherit; cursor:pointer; transition:all .15s; }
            .btn-logout-cancel:hover { border-color:var(--text); color:var(--text); }
            .btn-logout-confirm { flex:1; height:40px; border-radius:10px; background:var(--danger); border:none; color:#fff; font-size:13px; font-weight:700; font-family:inherit; cursor:pointer; transition:opacity .15s; }
            .btn-logout-confirm:hover { opacity:.85; }

            @media (max-width: 768px) {
                .sidebar {
                    transform: translateX(-100%);
                }
                .main {
                    margin-left: 0;
                    padding: 20px 16px;
                    max-width: 100vw;
                }
                .form-grid {
                    grid-template-columns: 1fr;
                }
                .filter-dropdown {
                    width: 280px;
                }
                .ds-stats {
                    flex-direction: column;
                }
                .role-selector {
                    flex-direction: column;
                }
            }
        </style>
    </head>
    <body>
        <div class="layout">

            <!-- SIDEBAR -->
            <aside class="sidebar">
                <div class="sidebar-logo">
                    <div class="logo-icon">🏘</div>
                    <div class="logo-text">Quản lý <span>Hộ dân</span></div>
                </div>
                <div class="nav-section">Chức năng</div>
                <div class="nav-item ${empty showDanhSach and empty showCanBo ? 'active' : ''}"
                     onclick="switchTab('tab-create', this)">
                    <span class="nav-icon">👤</span> Tạo tài khoản
                </div>
                <div class="nav-item" onclick="switchTab('tab-maintain', this)">
                    <span class="nav-icon">🔧</span> Bảo trì &amp; Sửa chữa
                </div>
                <a href="${pageContext.request.contextPath}/admin/ds_totruong"
                   class="nav-item ${not empty showDanhSach ? 'active' : ''}">
                    <span class="nav-icon">📋</span> Danh sách Tổ trưởng
                </a>
                <a href="${pageContext.request.contextPath}/admin/ds_canbophuong"
                   class="nav-item ${not empty showCanBo ? 'active' : ''}">
                    <span class="nav-icon">🏛</span> Danh sách Cán bộ phường
                </a>
                <div class="sidebar-spacer"></div>
                <div class="user-bar">
                    <div class="user-popup" id="userPopup">
                        <div class="popup-header">
                            <div class="avatar" id="avatarPopup">AD</div>
                            <div>
                                <div class="popup-full-name">${currentAdmin.ho} ${currentAdmin.ten}</div>
                                <div class="popup-email">${currentAdmin.email}</div>
                                <span class="badge ${currentAdmin.isActivated ? 'active' : 'inactive'}">
                                    ${currentAdmin.isActivated ? 'Hoạt động' : 'Chưa kích hoạt'}
                                </span>
                            </div>
                        </div>
                        <a class="popup-item" href="${pageContext.request.contextPath}/profile">
                            <span class="pi-icon">👤</span> Thông tin cá nhân
                        </a>
                        <a class="popup-item" href="${pageContext.request.contextPath}/admin/change_password">
                            <span class="pi-icon">🔑</span> Đổi mật khẩu
                        </a>
                        <hr class="popup-divider">
                        <%-- ✅ MODAL thay vì confirm() --%>
                        <div class="popup-item danger" onclick="showLogoutModal()">
                            <span class="pi-icon">🚪</span> Đăng xuất
                        </div>
                    </div>
                    <button class="user-bar-btn" id="userBarBtn" onclick="toggleUserMenu()">
                        <div class="avatar" id="avatarBtn">AD</div>
                        <div class="user-bar-info">
                            <div class="user-bar-name">${currentAdmin.ho} ${currentAdmin.ten}</div>
                            <div class="user-bar-role">Quản trị viên</div>
                        </div>
                        <span class="user-bar-chevron">⌃</span>
                    </button>
                </div>
            </aside>

            <!-- MAIN -->
            <main class="main">
                <c:if test="${not empty message}">
                    <div class="alert success"><span class="alert-icon">✅</span><span>${message}</span></div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert error"><span class="alert-icon">⚠️</span><span>${error}</span></div>
                </c:if>
                <c:if test="${not empty debugInfo}">
                    <div class="alert" style="background:rgba(251,191,36,.1); border:1px solid rgba(251,191,36,.3); color:#fbbf24; font-family:monospace; font-size:12px; word-break:break-all;">
                        <span>🔍 DEBUG: ${debugInfo}</span>
                    </div>
                </c:if>

                <!-- ══════════ TAB 1: Tạo tài khoản ══════════ -->
                <div id="tab-create" class="tab-panel ${empty showDanhSach and empty showCanBo ? 'active' : ''}">
                    <div class="page-header">
                        <div class="breadcrumb">Dashboard <span id="breadcrumbRole">/ Tạo tài khoản Tổ trưởng</span></div>
                        <h1 id="pageTitle">Tạo tài khoản</h1>
                        <p id="pageSubtitle">Chọn loại tài khoản cần tạo bên dưới</p>
                    </div>
                    <div class="role-selector">
                        <button type="button" class="role-btn selected-totruong" id="btnToTruong" onclick="switchRole('totruong')">
                            <span class="rb-icon">👤</span>
                            <span class="rb-label">Tổ trưởng<span class="rb-sub">Có CCCD &amp; Tên tổ dân phố</span></span>
                        </button>
                        <button type="button" class="role-btn" id="btnCanBo" onclick="switchRole('canbo')">
                            <span class="rb-icon">🏛</span>
                            <span class="rb-label">Cán bộ phường<span class="rb-sub">Không cần CCCD &amp; Tên tổ</span></span>
                        </button>
                    </div>
                    <div id="formToTruong" class="card">
                        <div class="card-header">
                            <div class="card-icon green">🔑</div>
                            <div><div class="card-title">Thông tin đăng nhập — Tổ trưởng</div><div class="card-sub">Mật khẩu đăng nhập hệ thống</div></div>
                        </div>
                        <form action="${pageContext.request.contextPath}/admin/create_totruong" method="post">
                            <div class="form-grid">
                                <div class="form-group">
                                    <label for="tt_email">Email *</label>
                                    <input type="email" id="tt_email" name="email" placeholder="example@email.com" value="${oldEmail}" required>
                                </div>
                                <div class="form-group"></div>
                                <div class="form-group">
                                    <label for="tt_matKhau">Mật khẩu *</label>
                                    <input type="password" id="tt_matKhau" name="matKhau" placeholder="Tối thiểu 8 ký tự" oninput="checkPw(this.value,'tt_pwFill')" required>
                                    <div class="pw-bar"><div class="pw-fill" id="tt_pwFill"></div></div>
                                </div>
                                <div class="form-group">
                                    <label for="tt_xacNhanMk">Xác nhận mật khẩu *</label>
                                    <input type="password" id="tt_xacNhanMk" name="xacNhanMk" placeholder="Nhập lại mật khẩu" required>
                                </div>
                            </div>
                            <hr class="divider">
                            <div class="card-header" style="border-bottom:none;padding-bottom:0;margin-bottom:16px;">
                                <div class="card-icon blue">📋</div>
                                <div><div class="card-title">Thông tin cá nhân</div><div class="card-sub">Thông tin định danh của Tổ trưởng</div></div>
                            </div>
                            <div class="form-grid">
                                <div class="form-group"><label for="tt_cccd">Số CCCD / CMND *</label><input type="text" id="tt_cccd" name="cccd" placeholder="VD: 001234567890" maxlength="12" value="${oldCccd}" required></div>
                                <div class="form-group"><label for="tt_ngaySinh">Ngày sinh *</label><input type="date" id="tt_ngaySinh" name="ngaySinh" value="${oldNgaySinh}" required></div>
                                <div class="form-group"><label for="tt_ho">Họ và chữ đệm *</label><input type="text" id="tt_ho" name="ho" placeholder="VD: Nguyễn Văn" value="${oldHo}" required></div>
                                <div class="form-group"><label for="tt_ten">Tên *</label><input type="text" id="tt_ten" name="ten" placeholder="VD: An" value="${oldTen}" required></div>
                                <div class="form-group"><label for="tt_sdt">Số điện thoại *</label><input type="text" id="tt_sdt" name="soDienThoai" placeholder="VD: 0901234567" maxlength="11" value="${oldSdt}" required></div>
                                <div class="form-group"><label for="tt_tenTo">Tên tổ dân phố *</label><input type="text" id="tt_tenTo" name="tenTo" placeholder="VD: Đông Sàng, Tây Mỗ..." value="${oldTenTo}" required></div>
                                <div class="form-group full">
                                    <label>Giới tính *</label>
                                    <div class="radio-group">
                                        <label class="radio-option"><input type="radio" name="gioiTinh" value="Nam" ${oldGioiTinh == 'Nam' ? 'checked' : ''} required> Nam</label>
                                        <label class="radio-option"><input type="radio" name="gioiTinh" value="Nữ" ${oldGioiTinh == 'Nữ' ? 'checked' : ''}> Nữ</label>
                                        <label class="radio-option"><input type="radio" name="gioiTinh" value="Khác" ${oldGioiTinh == 'Khác' ? 'checked' : ''}> Khác</label>
                                    </div>
                                </div>
                            </div>
                            <div class="form-actions">
                                <button type="submit" class="btn btn-primary">✅ Tạo tài khoản Tổ trưởng</button>
                                <button type="reset" class="btn btn-secondary">↩ Làm lại</button>
                            </div>
                        </form>
                    </div>
                    <div id="formCanBo" class="card" style="display:none;">
                        <div class="card-header">
                            <div class="card-icon" style="background:rgba(56,217,169,.15);">🔑</div>
                            <div><div class="card-title">Thông tin đăng nhập — Cán bộ phường</div><div class="card-sub">Mật khẩu đăng nhập hệ thống</div></div>
                        </div>
                        <form action="${pageContext.request.contextPath}/admin/create_canbophuong" method="post">
                            <div class="form-grid">
                                <div class="form-group"><label for="cb_email">Email *</label><input type="email" id="cb_email" name="email" placeholder="example@email.com" value="${oldEmail}" required></div>
                                <div class="form-group"></div>
                                <div class="form-group">
                                    <label for="cb_matKhau">Mật khẩu *</label>
                                    <input type="password" id="cb_matKhau" name="matKhau" placeholder="Tối thiểu 8 ký tự" oninput="checkPw(this.value,'cb_pwFill')" required>
                                    <div class="pw-bar"><div class="pw-fill" id="cb_pwFill"></div></div>
                                </div>
                                <div class="form-group"><label for="cb_xacNhanMk">Xác nhận mật khẩu *</label><input type="password" id="cb_xacNhanMk" name="xacNhanMk" placeholder="Nhập lại mật khẩu" required></div>
                            </div>
                            <hr class="divider">
                            <div class="card-header" style="border-bottom:none;padding-bottom:0;margin-bottom:16px;">
                                <div class="card-icon blue">📋</div>
                                <div><div class="card-title">Thông tin cá nhân</div><div class="card-sub">Thông tin định danh của Cán bộ phường</div></div>
                            </div>
                            <div class="form-grid">
                                <div class="form-group"><label for="cb_ho">Họ và chữ đệm *</label><input type="text" id="cb_ho" name="ho" placeholder="VD: Nguyễn Văn" value="${oldHo}" required></div>
                                <div class="form-group"><label for="cb_ten">Tên *</label><input type="text" id="cb_ten" name="ten" placeholder="VD: An" value="${oldTen}" required></div>
                                <div class="form-group"><label for="cb_ngaySinh">Ngày sinh *</label><input type="date" id="cb_ngaySinh" name="ngaySinh" value="${oldNgaySinh}" required></div>
                                <div class="form-group"><label for="cb_sdt">Số điện thoại *</label><input type="text" id="cb_sdt" name="soDienThoai" placeholder="VD: 0901234567" maxlength="11" value="${oldSdt}" required></div>
                                <div class="form-group full">
                                    <label>Giới tính *</label>
                                    <div class="radio-group">
                                        <label class="radio-option"><input type="radio" name="gioiTinh" value="Nam" ${oldGioiTinh == 'Nam' ? 'checked' : ''} required> Nam</label>
                                        <label class="radio-option"><input type="radio" name="gioiTinh" value="Nữ" ${oldGioiTinh == 'Nữ' ? 'checked' : ''}> Nữ</label>
                                        <label class="radio-option"><input type="radio" name="gioiTinh" value="Khác" ${oldGioiTinh == 'Khác' ? 'checked' : ''}> Khác</label>
                                    </div>
                                </div>
                            </div>
                            <div class="form-actions">
                                <button type="submit" class="btn btn-primary" style="background:var(--accent2);color:#000;">✅ Tạo tài khoản Cán bộ phường</button>
                                <button type="reset" class="btn btn-secondary">↩ Làm lại</button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- ══════════ TAB 2: Bảo trì ══════════ -->
                <div id="tab-maintain" class="tab-panel">
                    <div class="page-header">
                        <div class="breadcrumb">Dashboard <span>/ Bảo trì &amp; Sửa chữa</span></div>
                        <h1>Bảo trì &amp; Sửa chữa hệ thống</h1>
                        <p>Quản lý và thực hiện các tác vụ bảo trì hệ thống</p>
                    </div>
                    <div class="card">
                        <div class="card-header">
                            <div class="card-icon green">📊</div>
                            <div><div class="card-title">Trạng thái hệ thống</div><div class="card-sub">Tổng quan hiện trạng</div></div>
                        </div>
                        <div class="status-list">
                            <div class="status-row"><span class="sr-label">🗄 Cơ sở dữ liệu</span><span class="pill ok">Bình thường</span></div>
                            <div class="status-row"><span class="sr-label">💾 Backup gần nhất</span><span class="sr-val">${empty lastBackup ? 'Chưa có' : lastBackup}</span></div>
                            <div class="status-row"><span class="sr-label">🖥 Máy chủ</span><span class="pill ok">Đang hoạt động</span></div>
                            <div class="status-row"><span class="sr-label">📦 Phiên bản hệ thống</span><span class="sr-val">${empty appVersion ? '1.0.0' : appVersion}</span></div>
                        </div>
                    </div>
                    <div class="card">
                        <div class="card-header">
                            <div class="card-icon warn">⚙️</div>
                            <div><div class="card-title">Thực hiện bảo trì</div><div class="card-sub">Chọn loại tác vụ cần thực hiện</div></div>
                        </div>
                        <div class="maintain-grid">
                            <div class="maintain-card">
                                <div class="mc-icon">💾</div><h3>Backup cơ sở dữ liệu</h3>
                                <p>Sao lưu toàn bộ dữ liệu hiện tại của hệ thống để đảm bảo an toàn.</p>
                                <form action="${pageContext.request.contextPath}/admin/dashboard" method="post">
                                    <input type="hidden" name="action" value="maintainSystem">
                                    <input type="hidden" name="maintainType" value="backup">
                                    <button type="submit" class="btn btn-green" style="width:100%">▶ Thực hiện Backup</button>
                                </form>
                            </div>
                            <div class="maintain-card">
                                <div class="mc-icon">🔧</div><h3>Sửa chữa hệ thống</h3>
                                <p>Kiểm tra và sửa chữa các lỗi phát sinh trong quá trình vận hành.</p>
                                <form action="${pageContext.request.contextPath}/admin/dashboard" method="post">
                                    <input type="hidden" name="action" value="maintainSystem">
                                    <input type="hidden" name="maintainType" value="repair">
                                    <button type="submit" class="btn btn-warn" style="width:100%">▶ Bắt đầu sửa chữa</button>
                                </form>
                            </div>
                            <div class="maintain-card">
                                <div class="mc-icon">📝</div><h3>Cập nhật cấu hình</h3>
                                <p>Áp dụng cấu hình mới và cập nhật các tham số hệ thống.</p>
                                <form action="${pageContext.request.contextPath}/admin/dashboard" method="post">
                                    <input type="hidden" name="action" value="maintainSystem">
                                    <input type="hidden" name="maintainType" value="update">
                                    <button type="submit" class="btn btn-primary" style="width:100%">▶ Cập nhật cấu hình</button>
                                </form>
                            </div>
                            <div class="maintain-card">
                                <div class="mc-icon">🗑</div><h3>Xóa cache hệ thống</h3>
                                <p>Dọn dẹp bộ nhớ tạm để giải phóng tài nguyên và tăng hiệu năng.</p>
                                <form action="${pageContext.request.contextPath}/admin/dashboard" method="post">
                                    <input type="hidden" name="action" value="maintainSystem">
                                    <input type="hidden" name="maintainType" value="clearCache">
                                    <button type="submit" class="btn btn-danger" style="width:100%">▶ Xóa cache</button>
                                </form>
                            </div>
                        </div>
                    </div>
                    <div class="card">
                        <div class="card-header">
                            <div class="card-icon red">📋</div>
                            <div><div class="card-title">Nhật ký bảo trì</div><div class="card-sub">Lịch sử các tác vụ đã thực hiện</div></div>
                        </div>
                        <div class="status-list">
                            <c:choose>
                                <c:when test="${not empty maintenanceLogs}">
                                    <c:forEach var="log" items="${maintenanceLogs}">
                                        <div class="status-row">
                                            <span class="sr-label">${log.type}</span>
                                            <span class="sr-val">${log.timestamp}</span>
                                            <span class="pill ok">${log.status}</span>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div style="text-align:center;padding:20px;color:var(--muted);font-size:13px;">Chưa có lịch sử bảo trì nào</div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <!-- ══════════ TAB 3: DANH SÁCH TỔ TRƯỞNG ══════════ -->
                <div id="tab-danhsach" class="tab-panel ${not empty showDanhSach ? 'active' : ''}">
                    <div class="page-header">
                        <div class="breadcrumb">Dashboard <span>/ Danh sách Tổ trưởng</span></div>
                        <h1>Danh sách Tổ trưởng</h1>
                        <p>Quản lý tất cả tài khoản Tổ trưởng trong hệ thống</p>
                    </div>
                    <c:if test="${not empty danhSachToTruong}">
                        <div class="ds-stats">
                            <div class="ds-stat"><div class="ds-stat-icon blue">👥</div><div><div class="ds-stat-val">${danhSachToTruong.size()}</div><div class="ds-stat-lbl">Tổng Tổ trưởng</div></div></div>
                            <div class="ds-stat"><div class="ds-stat-icon green">✅</div><div><div class="ds-stat-val" id="statActive">0</div><div class="ds-stat-lbl">Đang công tác</div></div></div>
                            <div class="ds-stat"><div class="ds-stat-icon red">🔒</div><div><div class="ds-stat-val" id="statLocked">0</div><div class="ds-stat-lbl">Không hoạt động</div></div></div>
                        </div>
                    </c:if>
                    <form id="filterForm" action="${pageContext.request.contextPath}/admin/ds_totruong" method="get">
                        <input type="hidden" name="trangThai" id="hiddenTrangThai" value="${param.trangThai}">
                        <input type="hidden" name="toSo"      id="hiddenToSo"      value="${param.toSo}">
                        <div class="ds-toolbar">
                            <div class="ds-search-wrap">
                                <span class="ds-search-icon">
                                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
                                </span>
                                <input type="text" name="keyword" id="searchInput" value="${keyword}" placeholder="Tìm theo tên, email, SĐT, CCCD...">
                            </div>
                            <button type="submit" class="btn btn-primary" style="white-space:nowrap;">Tìm kiếm</button>
                            <div class="filter-wrapper">
                                <button type="button" id="filterBtn" class="btn-filter" onclick="toggleFilter(event)">
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.3" stroke-linecap="round" stroke-linejoin="round"><polygon points="22 3 2 3 10 12.46 10 19 14 21 14 12.46 22 3"/></svg>
                                    Bộ lọc <span class="filter-count" id="filterCount">0</span>
                                </button>
                                <div class="filter-dropdown" id="filterDropdown">
                                    <div class="fd-header">
                                        <div class="fd-title">
                                            <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polygon points="22 3 2 3 10 12.46 10 19 14 21 14 12.46 22 3"/></svg>
                                            Bộ lọc nâng cao
                                        </div>
                                        <button type="button" class="fd-clear-btn" onclick="resetFilters()">✕ Xóa tất cả</button>
                                    </div>
                                    <div class="fd-section">
                                        <div class="fd-section-label">Trạng thái tài khoản</div>
                                        <div class="fd-chips">
                                            <div class="fd-chip" id="chip-tt-"       onclick="pickTrangThai('')"><span class="fd-chip-dot"></span>Tất cả</div>
                                            <div class="fd-chip" id="chip-tt-active" onclick="pickTrangThai('active')"><span class="fd-chip-dot"></span>Hoạt động</div>
                                            <div class="fd-chip" id="chip-tt-locked" onclick="pickTrangThai('locked')"><span class="fd-chip-dot"></span>Đã khóa</div>
                                        </div>
                                    </div>
                                    <div class="fd-section">
                                        <div class="fd-section-label">Tổ dân phố</div>
                                        <div class="fd-chips" id="toChips">
                                            <div class="fd-chip" id="chip-to-" onclick="pickToSo('')"><span class="fd-chip-dot"></span>Tất cả tổ</div>
                                        </div>
                                    </div>
                                    <div class="fd-footer">
                                        <button type="button" class="btn btn-secondary" onclick="closeFilter()">Đóng</button>
                                        <button type="button" class="btn btn-primary" onclick="applyFilters()">✅ Áp dụng</button>
                                    </div>
                                </div>
                            </div>
                            <c:if test="${not empty keyword or not empty param.trangThai or not empty param.toSo}">
                                <a href="${pageContext.request.contextPath}/admin/ds_totruong" class="btn btn-secondary" style="white-space:nowrap;">✕ Xóa lọc</a>
                            </c:if>
                        </div>
                        <c:if test="${not empty param.trangThai or not empty param.toSo}">
                            <div class="active-filters">
                                <span class="af-label">Đang lọc:</span>
                                <c:if test="${not empty param.trangThai}">
                                    <span class="af-chip">Trạng thái: ${param.trangThai == 'active' ? 'Hoạt động' : 'Đã khóa'}<a href="${pageContext.request.contextPath}/admin/ds_totruong?keyword=${keyword}&toSo=${param.toSo}" title="Bỏ lọc này">✕</a></span>
                                </c:if>
                                <c:if test="${not empty param.toSo}">
                                    <span class="af-chip">Tổ: ${param.toSo}<a href="${pageContext.request.contextPath}/admin/ds_totruong?keyword=${keyword}&trangThai=${param.trangThai}" title="Bỏ lọc này">✕</a></span>
                                </c:if>
                            </div>
                        </c:if>
                    </form>
                    <div class="ds-table-wrap">
                        <c:choose>
                            <c:when test="${not empty danhSachToTruong}">
                                <table class="ds-table">
                                    <thead>
                                        <tr>
                                            <th style="width:44px;">#</th>
                                            <th>Họ tên</th>
                                            <th>CCCD</th>
                                            <th>Email</th>
                                            <th>SĐT</th>
                                            <th class="center">Tổ</th>
                                            <th>Ngày tạo</th>
                                            <th class="center">Trạng thái</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="tt" items="${danhSachToTruong}" varStatus="st">
                                            <tr>
                                                <td style="color:var(--muted);font-size:12px;">${st.index + 1}</td>
                                                <td>
                                                    <div class="tt-cell">
                                                        <div class="tt-avatar">${tt.ten.substring(0,1)}</div>
                                                        <div><div class="tt-name">${tt.ho} ${tt.ten}</div><div class="tt-sub">${tt.gioiTinh}</div></div>
                                                    </div>
                                                </td>
                                                <td><span class="mono">${tt.cccd}</span></td>
                                                <td style="font-size:12.5px;">${tt.email}</td>
                                                <td style="font-size:12.5px;">${tt.soDienThoai}</td>
                                                <td class="center">
                                                    <span class="to-badge">
                                                        <svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M3 9l9-7 9 7v11a2 2 0 01-2 2H5a2 2 0 01-2-2z"/><polyline points="9 22 9 12 15 12 15 22"/></svg>
                                                        ${empty tt.tenTo ? 'Tổ '.concat(tt.toDanPhoID.toString()) : tt.tenTo}
                                                    </span>
                                                </td>
                                                <td style="color:var(--muted);font-size:12px;white-space:nowrap;">${tt.ngayTao}</td>
                                                <%-- ✅ Cột Trạng thái: dropdown inline --%>
                                                <td class="center">
                                                    <div class="ts-wrap">
                                                        <button type="button"
                                                                class="ts-btn ts-s${tt.trangThaiNhanSu}"
                                                                id="btn-tt-${tt.nguoiDungID}"
                                                                onclick="toggleMenu('tt-${tt.nguoiDungID}', event)">
                                                            <c:choose>
                                                                <c:when test="${tt.trangThaiNhanSu == 1}">✅ Đang công tác</c:when>
                                                                <c:when test="${tt.trangThaiNhanSu == 2}">🚫 Không còn tại vị</c:when>
                                                                <c:otherwise>🪦 Đã mất / Nghỉ hưu</c:otherwise>
                                                            </c:choose>
                                                            <span class="ts-chevron">▾</span>
                                                        </button>
                                                        <div class="ts-menu" id="menu-tt-${tt.nguoiDungID}" style="display:none;">
                                                            <c:if test="${tt.trangThaiNhanSu != 1}">
                                                                <form action="${pageContext.request.contextPath}/admin/ds_totruong" method="post">
                                                                    <input type="hidden" name="action" value="toggleTrangThai">
                                                                    <input type="hidden" name="nguoiDungID" value="${tt.nguoiDungID}">
                                                                    <input type="hidden" name="trangThaiNhanSu" value="1">
                                                                    <c:if test="${not empty keyword}"><input type="hidden" name="keyword" value="${keyword}"></c:if>
                                                                        <button type="submit" class="ts-item ts-item-1">✅ Đang công tác</button>
                                                                    </form>
                                                            </c:if>
                                                            <c:if test="${tt.trangThaiNhanSu != 2}">
                                                                <form action="${pageContext.request.contextPath}/admin/ds_totruong" method="post"
                                                                      onsubmit="return confirm('Chuyển sang Không còn tại vị?\nTài khoản sẽ bị chặn đăng nhập.')">
                                                                    <input type="hidden" name="action" value="toggleTrangThai">
                                                                    <input type="hidden" name="nguoiDungID" value="${tt.nguoiDungID}">
                                                                    <input type="hidden" name="trangThaiNhanSu" value="2">
                                                                    <c:if test="${not empty keyword}"><input type="hidden" name="keyword" value="${keyword}"></c:if>
                                                                        <button type="submit" class="ts-item ts-item-2">🚫 Không còn tại vị</button>
                                                                    </form>
                                                            </c:if>
                                                            <c:if test="${tt.trangThaiNhanSu != 3}">
                                                                <form action="${pageContext.request.contextPath}/admin/ds_totruong" method="post"
                                                                      onsubmit="return confirm('Chuyển sang Đã mất / Nghỉ hưu?\nTài khoản sẽ bị đóng vĩnh viễn.')">
                                                                    <input type="hidden" name="action" value="toggleTrangThai">
                                                                    <input type="hidden" name="nguoiDungID" value="${tt.nguoiDungID}">
                                                                    <input type="hidden" name="trangThaiNhanSu" value="3">
                                                                    <c:if test="${not empty keyword}"><input type="hidden" name="keyword" value="${keyword}"></c:if>
                                                                        <button type="submit" class="ts-item ts-item-3">🪦 Đã mất / Nghỉ hưu</button>
                                                                    </form>
                                                            </c:if>
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                                <div class="ds-footer">
                                    <span>Tổng cộng <strong>${danhSachToTruong.size()} Tổ trưởng</strong>
                                        <c:if test="${not empty keyword}"> — kết quả cho "<strong style="color:var(--accent);">${keyword}</strong>"</c:if>
                                        </span>
                                        <span style="font-size:11px;">Cập nhật lần cuối: hôm nay</span>
                                    </div>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">
                                    <div class="es-icon">🔍</div>
                                    <p>${not empty keyword ? 'Không tìm thấy Tổ trưởng nào phù hợp.' : 'Chưa có Tổ trưởng nào trong hệ thống.'}</p>
                                    <c:if test="${not empty keyword}">
                                        <a href="${pageContext.request.contextPath}/admin/ds_totruong" class="btn btn-secondary">← Xem tất cả</a>
                                    </c:if>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- ══════════ TAB 4: DANH SÁCH CÁN BỘ PHƯỜNG ══════════ -->
                <div id="tab-danhsach-canbo" class="tab-panel ${not empty showCanBo ? 'active' : ''}">
                    <div class="page-header">
                        <div class="breadcrumb">Dashboard <span>/ Danh sách Cán bộ phường</span></div>
                        <h1>Danh sách Cán bộ phường</h1>
                        <p>Quản lý tất cả tài khoản Cán bộ phường trong hệ thống</p>
                    </div>
                    <c:if test="${not empty danhSachCanBo}">
                        <div class="ds-stats">
                            <div class="ds-stat"><div class="ds-stat-icon blue">👥</div><div><div class="ds-stat-val">${danhSachCanBo.size()}</div><div class="ds-stat-lbl">Tổng Cán bộ phường</div></div></div>
                            <div class="ds-stat"><div class="ds-stat-icon green">✅</div><div><div class="ds-stat-val" id="statActiveCB">0</div><div class="ds-stat-lbl">Đang công tác</div></div></div>
                            <div class="ds-stat"><div class="ds-stat-icon red">🔒</div><div><div class="ds-stat-val" id="statLockedCB">0</div><div class="ds-stat-lbl">Không hoạt động</div></div></div>
                        </div>
                    </c:if>
                    <form action="${pageContext.request.contextPath}/admin/ds_canbophuong" method="get">
                        <div class="ds-toolbar">
                            <div class="ds-search-wrap">
                                <span class="ds-search-icon">
                                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
                                </span>
                                <input type="text" name="keyword" value="${keyword}" placeholder="Tìm theo tên, email, SĐT...">
                            </div>
                            <button type="submit" class="btn btn-primary" style="white-space:nowrap;">Tìm kiếm</button>
                            <c:if test="${not empty keyword}">
                                <a href="${pageContext.request.contextPath}/admin/ds_canbophuong" class="btn btn-secondary" style="white-space:nowrap;">✕ Xóa lọc</a>
                            </c:if>
                        </div>
                    </form>
                    <div class="ds-table-wrap">
                        <c:choose>
                            <c:when test="${not empty danhSachCanBo}">
                                <table class="ds-table">
                                    <thead>
                                        <tr>
                                            <th style="width:44px;">#</th>
                                            <th>Họ tên</th>
                                            <th>Email</th>
                                            <th>SĐT</th>
                                            <th>Ngày tạo</th>
                                            <th class="center">Trạng thái</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="cb" items="${danhSachCanBo}" varStatus="st">
                                            <tr>
                                                <td style="color:var(--muted);font-size:12px;">${st.index + 1}</td>
                                                <td>
                                                    <div class="tt-cell">
                                                        <div class="tt-avatar">${cb.ten.substring(0,1)}</div>
                                                        <div><div class="tt-name">${cb.ho} ${cb.ten}</div><div class="tt-sub">${cb.gioiTinh}</div></div>
                                                    </div>
                                                </td>
                                                <td style="font-size:12.5px;">${cb.email}</td>
                                                <td style="font-size:12.5px;">${cb.soDienThoai}</td>
                                                <td style="color:var(--muted);font-size:12px;white-space:nowrap;">${cb.ngayTao}</td>
                                                <%-- ✅ Cột Trạng thái: dropdown inline --%>
                                                <td class="center">
                                                    <div class="ts-wrap">
                                                        <button type="button"
                                                                class="ts-btn ts-s${cb.trangThaiNhanSu}"
                                                                id="btn-cb-${cb.nguoiDungID}"
                                                                onclick="toggleMenu('cb-${cb.nguoiDungID}', event)">
                                                            <c:choose>
                                                                <c:when test="${cb.trangThaiNhanSu == 1}">✅ Đang công tác</c:when>
                                                                <c:when test="${cb.trangThaiNhanSu == 2}">🚫 Không còn tại vị</c:when>
                                                                <c:otherwise>🪦 Đã mất / Nghỉ hưu</c:otherwise>
                                                            </c:choose>
                                                            <span class="ts-chevron">▾</span>
                                                        </button>
                                                        <div class="ts-menu" id="menu-cb-${cb.nguoiDungID}" style="display:none;">
                                                            <c:if test="${cb.trangThaiNhanSu != 1}">
                                                                <form action="${pageContext.request.contextPath}/admin/ds_canbophuong" method="post">
                                                                    <input type="hidden" name="action" value="toggleTrangThai">
                                                                    <input type="hidden" name="nguoiDungID" value="${cb.nguoiDungID}">
                                                                    <input type="hidden" name="trangThaiNhanSu" value="1">
                                                                    <c:if test="${not empty keyword}"><input type="hidden" name="keyword" value="${keyword}"></c:if>
                                                                        <button type="submit" class="ts-item ts-item-1">✅ Đang công tác</button>
                                                                    </form>
                                                            </c:if>
                                                            <c:if test="${cb.trangThaiNhanSu != 2}">
                                                                <form action="${pageContext.request.contextPath}/admin/ds_canbophuong" method="post"
                                                                      onsubmit="return confirm('Chuyển sang Không còn tại vị?\nTài khoản sẽ bị chặn đăng nhập.')">
                                                                    <input type="hidden" name="action" value="toggleTrangThai">
                                                                    <input type="hidden" name="nguoiDungID" value="${cb.nguoiDungID}">
                                                                    <input type="hidden" name="trangThaiNhanSu" value="2">
                                                                    <c:if test="${not empty keyword}"><input type="hidden" name="keyword" value="${keyword}"></c:if>
                                                                        <button type="submit" class="ts-item ts-item-2">🚫 Không còn tại vị</button>
                                                                    </form>
                                                            </c:if>
                                                            <c:if test="${cb.trangThaiNhanSu != 3}">
                                                                <form action="${pageContext.request.contextPath}/admin/ds_canbophuong" method="post"
                                                                      onsubmit="return confirm('Chuyển sang Đã mất / Nghỉ hưu?\nTài khoản sẽ bị đóng vĩnh viễn.')">
                                                                    <input type="hidden" name="action" value="toggleTrangThai">
                                                                    <input type="hidden" name="nguoiDungID" value="${cb.nguoiDungID}">
                                                                    <input type="hidden" name="trangThaiNhanSu" value="3">
                                                                    <c:if test="${not empty keyword}"><input type="hidden" name="keyword" value="${keyword}"></c:if>
                                                                        <button type="submit" class="ts-item ts-item-3">🪦 Đã mất / Nghỉ hưu</button>
                                                                    </form>
                                                            </c:if>
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                                <div class="ds-footer">
                                    <span>Tổng cộng <strong>${danhSachCanBo.size()} Cán bộ phường</strong>
                                        <c:if test="${not empty keyword}"> — kết quả cho "<strong style="color:var(--accent);">${keyword}</strong>"</c:if>
                                        </span>
                                        <span style="font-size:11px;">Cập nhật lần cuối: hôm nay</span>
                                    </div>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">
                                    <div class="es-icon">🔍</div>
                                    <p>${not empty keyword ? 'Không tìm thấy Cán bộ phường nào phù hợp.' : 'Chưa có Cán bộ phường nào trong hệ thống.'}</p>
                                    <c:if test="${not empty keyword}">
                                        <a href="${pageContext.request.contextPath}/admin/ds_canbophuong" class="btn btn-secondary">← Xem tất cả</a>
                                    </c:if>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </main>
        </div>

        <!-- ✅ MODAL ĐĂNG XUẤT -->
        <div class="logout-overlay" id="logoutModal" onclick="if(event.target===this)hideLogoutModal()">
            <div class="logout-box">
                <div class="logout-body">
                    <div class="logout-ico">🚪</div>
                    <div class="logout-title">Đăng xuất?</div>
                    <div class="logout-sub">Bạn sẽ được đưa về trang đăng nhập.<br>Mọi phiên làm việc hiện tại sẽ kết thúc.</div>
                </div>
                <div class="logout-footer">
                    <button class="btn-logout-cancel" onclick="hideLogoutModal()">Ở lại</button>
                    <button class="btn-logout-confirm" onclick="doLogout()">🚪 Đăng xuất</button>
                </div>
            </div>
        </div>

        <script>
            /* ─── Avatar ─── */
            (function () {
                const ten = '${currentAdmin.ten}' || 'AD';
                const initials = ten.trim().substring(0, 2).toUpperCase() || 'AD';
                document.getElementById('avatarBtn').textContent = initials;
                document.getElementById('avatarPopup').textContent = initials;
            })();

            /* ─── User menu ─── */
            function toggleUserMenu() {
                const popup = document.getElementById('userPopup');
                const btn = document.getElementById('userBarBtn');
                popup.classList.toggle('open');
                btn.classList.toggle('open', popup.classList.contains('open'));
            }
            document.addEventListener('click', function (e) {
                const bar = document.querySelector('.user-bar');
                if (bar && !bar.contains(e.target)) {
                    document.getElementById('userPopup').classList.remove('open');
                    document.getElementById('userBarBtn').classList.remove('open');
                }
            });

            /* ─── Tab switch ─── */
            function switchTab(tabId, navEl) {
                document.querySelectorAll('.tab-panel').forEach(p => p.classList.remove('active'));
                document.querySelectorAll('.nav-item').forEach(n => n.classList.remove('active'));
                document.getElementById(tabId).classList.add('active');
                navEl.classList.add('active');
            }

            /* ─── Role switch ─── */
            function switchRole(role) {
                const btnTT = document.getElementById('btnToTruong');
                const btnCB = document.getElementById('btnCanBo');
                const formTT = document.getElementById('formToTruong');
                const formCB = document.getElementById('formCanBo');
                const breadcrumb = document.getElementById('breadcrumbRole');
                const title = document.getElementById('pageTitle');
                const subtitle = document.getElementById('pageSubtitle');
                if (role === 'totruong') {
                    btnTT.className = 'role-btn selected-totruong';
                    btnCB.className = 'role-btn';
                    formTT.style.display = 'block';
                    formCB.style.display = 'none';
                    breadcrumb.textContent = '/ Tạo tài khoản Tổ trưởng';
                    title.textContent = 'Tạo tài khoản Tổ trưởng';
                    subtitle.textContent = 'Điền đầy đủ thông tin để tạo tài khoản cho Tổ trưởng mới';
                } else {
                    btnTT.className = 'role-btn';
                    btnCB.className = 'role-btn selected-canbo';
                    formTT.style.display = 'none';
                    formCB.style.display = 'block';
                    breadcrumb.textContent = '/ Tạo tài khoản Cán bộ phường';
                    title.textContent = 'Tạo tài khoản Cán bộ phường';
                    subtitle.textContent = 'Điền đầy đủ thông tin để tạo tài khoản cho Cán bộ phường mới';
                }
            }

            /* ─── Password strength ─── */
            function checkPw(val, fillId) {
                const fill = document.getElementById(fillId);
                if (!fill)
                    return;
                let score = 0;
                if (val.length >= 8)
                    score++;
                if (/[A-Z]/.test(val))
                    score++;
                if (/[0-9]/.test(val))
                    score++;
                if (/[^A-Za-z0-9]/.test(val))
                    score++;
                const pct = ['0%', '30%', '55%', '80%', '100%'][score];
                const color = ['#f75c5c', '#fbbf24', '#fbbf24', '#4f8ef7', '#38d9a9'][score];
                fill.style.width = pct;
                fill.style.background = color;
            }

            /* ─── Maintain confirm ─── */
            document.querySelectorAll('.maintain-card form').forEach(form => {
                form.addEventListener('submit', function (e) {
                    const type = this.querySelector('[name=maintainType]').value;
                    const labels = {backup: 'Backup cơ sở dữ liệu', repair: 'Sửa chữa hệ thống', update: 'Cập nhật cấu hình', clearCache: 'Xóa cache hệ thống'};
                    if (!confirm('Xác nhận thực hiện: ' + labels[type] + '?'))
                        e.preventDefault();
                });
            });

            /* ─── Stat counters Tổ trưởng ─── */
            (function calcStats() {
                let active = 0, inactive = 0;
                document.querySelectorAll('#tab-danhsach .ts-btn').forEach(btn => {
                    if (btn.classList.contains('ts-s1'))
                        active++;
                    else
                        inactive++;
                });
                const sa = document.getElementById('statActive');
                const sl = document.getElementById('statLocked');
                if (sa)
                    sa.textContent = active;
                if (sl)
                    sl.textContent = inactive;
            })();

            /* ─── Stat counters Cán bộ phường ─── */
            (function calcStatsCB() {
                let active = 0, inactive = 0;
                document.querySelectorAll('#tab-danhsach-canbo .ts-btn').forEach(btn => {
                    if (btn.classList.contains('ts-s1'))
                        active++;
                    else
                        inactive++;
                });
                const sa = document.getElementById('statActiveCB');
                const sl = document.getElementById('statLockedCB');
                if (sa)
                    sa.textContent = active;
                if (sl)
                    sl.textContent = inactive;
            })();

            /* ─── Bộ lọc ─── */
            let selTrangThai = '${param.trangThai}';
            let selToSo = '${param.toSo}';

            (function buildToChips() {
                const seen = new Set();
                const container = document.getElementById('toChips');
                if (!container)
                    return;
                document.querySelectorAll('.to-badge').forEach(badge => {
                    const num = badge.textContent.trim().replace(/\s+/g, ' ').replace(/^Tổ\s*/, '').trim();
                    if (num && !seen.has(num)) {
                        seen.add(num);
                        const chip = document.createElement('div');
                        chip.className = 'fd-chip';
                        chip.id = 'chip-to-' + num;
                        chip.onclick = function () {
                            pickToSo(num);
                        };
                        chip.innerHTML = '<span class="fd-chip-dot"></span>Tổ ' + num;
                        container.appendChild(chip);
                    }
                });
                refreshChipUI();
            })();

            function toggleFilter(e) {
                e.stopPropagation();
                document.getElementById('filterDropdown').classList.toggle('open');
            }
            function closeFilter() {
                document.getElementById('filterDropdown').classList.remove('open');
            }
            document.addEventListener('click', function (e) {
                const w = document.querySelector('.filter-wrapper');
                if (w && !w.contains(e.target))
                    closeFilter();
            });
            function pickTrangThai(val) {
                selTrangThai = val;
                refreshChipUI();
            }
            function pickToSo(val) {
                selToSo = val;
                refreshChipUI();
            }
            function resetFilters() {
                selTrangThai = '';
                selToSo = '';
                refreshChipUI();
            }
            function refreshChipUI() {
                const ttMap = {'': 'sel-all', 'active': 'sel-active', 'locked': 'sel-locked'};
                ['', 'active', 'locked'].forEach(v => {
                    const el = document.getElementById('chip-tt-' + v);
                    if (el)
                        el.className = 'fd-chip' + (v === selTrangThai ? ' ' + ttMap[v] : '');
                });
                document.querySelectorAll('[id^="chip-to-"]').forEach(el => {
                    const val = el.id.replace('chip-to-', '');
                    el.className = 'fd-chip' + (val === selToSo ? ' sel-to' : '');
                });
                let count = 0;
                if (selTrangThai)
                    count++;
                if (selToSo)
                    count++;
                const badge = document.getElementById('filterCount');
                const btn = document.getElementById('filterBtn');
                if (badge)
                    badge.textContent = count;
                if (btn)
                    btn.classList.toggle('active-filter', count > 0);
            }
            function applyFilters() {
                document.getElementById('hiddenTrangThai').value = selTrangThai;
                document.getElementById('hiddenToSo').value = selToSo;
                document.getElementById('filterForm').submit();
            }

            /* ══ DROPDOWN TRẠNG THÁI NHÂN SỰ INLINE ══ */
            function toggleMenu(id, e) {
                e.stopPropagation();
                const menu = document.getElementById('menu-' + id);
                const btn = document.getElementById('btn-' + id);
                const isOpen = menu.style.display === 'block';
                // Đóng tất cả
                document.querySelectorAll('.ts-menu').forEach(m => m.style.display = 'none');
                document.querySelectorAll('.ts-btn').forEach(b => b.classList.remove('open'));
                if (!isOpen) {
                    menu.style.display = 'block';
                    btn.classList.add('open');
                }
            }
            // Đóng khi click ra ngoài
            document.addEventListener('click', function () {
                document.querySelectorAll('.ts-menu').forEach(m => m.style.display = 'none');
                document.querySelectorAll('.ts-btn').forEach(b => b.classList.remove('open'));
            });

            /* ── ✅ MODAL ĐĂNG XUẤT ── */
            function showLogoutModal() {
                document.getElementById('userPopup').classList.remove('open');
                document.getElementById('userBarBtn').classList.remove('open');
                document.getElementById('logoutModal').classList.add('show');
                document.body.style.overflow = 'hidden';
            }
            function hideLogoutModal() {
                document.getElementById('logoutModal').classList.remove('show');
                document.body.style.overflow = '';
            }
            function doLogout() {
                window.location.href = '${pageContext.request.contextPath}/logout';
            }
            document.addEventListener('keydown', function(e) {
                if (e.key === 'Escape') hideLogoutModal();
            });
        </script>
    </body>
</html>
