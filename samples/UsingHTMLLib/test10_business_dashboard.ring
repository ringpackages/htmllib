/*
	HTMLLib Demo 10 - Business Dashboard
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 10: Business Dashboard
# ------------------------------------------------------------------
? "Demo 10: Business dashboard..."

oHTML = new HTMLWriter
oHTML.setTitle("Business Dashboard")
oHTML.setDescription("Q4 2025 Performance Dashboard")

oHTML.addCSSVariable("primary", "#4a90d9")
oHTML.addCSSVariable("success", "#27ae60")
oHTML.addCSSVariable("warning", "#f39c12")
oHTML.addCSSVariable("danger", "#e74c3c")

oHTML.addCSSRule("*", [["margin", "0"], ["padding", "0"], ["box-sizing", "border-box"]])
oHTML.addCSSRule("body", [
	["font-family", "'Segoe UI', Roboto, sans-serif"],
	["background-color", "#f0f2f5"],
	["color", "#333"]
])
oHTML.addCSSRule(".dashboard", [
	["max-width", "1200px"],
	["margin", "0 auto"],
	["padding", "20px"]
])
oHTML.addCSSRule(".kpi-grid", [
	["display", "grid"],
	["grid-template-columns", "repeat(4, 1fr)"],
	["gap", "20px"],
	["margin-bottom", "30px"]
])
oHTML.addCSSRule(".kpi-card", [
	["background-color", "#fff"],
	["border-radius", "12px"],
	["padding", "24px"],
	["box-shadow", "0 2px 8px rgba(0,0,0,0.08)"]
])
oHTML.addCSSRule(".kpi-label", [
	["font-size", "0.85rem"],
	["color", "#888"],
	["text-transform", "uppercase"],
	["letter-spacing", "0.5px"]
])
oHTML.addCSSRule(".kpi-value", [
	["font-size", "2rem"],
	["font-weight", "700"],
	["margin", "8px 0"]
])
oHTML.addCSSRule(".kpi-change", [
	["font-size", "0.9rem"]
])
oHTML.addCSSRule(".positive", [["color", "var(--success)"]])
oHTML.addCSSRule(".negative", [["color", "var(--danger)"]])
oHTML.addCSSRule(".content-grid", [
	["display", "grid"],
	["grid-template-columns", "2fr 1fr"],
	["gap", "20px"]
])
oHTML.addCSSRule(".panel", [
	["background-color", "#fff"],
	["border-radius", "12px"],
	["padding", "24px"],
	["box-shadow", "0 2px 8px rgba(0,0,0,0.08)"]
])
oHTML.addCSSRule(".panel h3", [
	["margin-bottom", "16px"],
	["color", "#2c3e50"]
])
oHTML.addCSSRule("table", [
	["width", "100%"],
	["border-collapse", "collapse"]
])
oHTML.addCSSRule("th, td", [
	["padding", "10px 12px"],
	["text-align", "left"],
	["border-bottom", "1px solid #eee"]
])
oHTML.addCSSRule("th", [
	["font-weight", "600"],
	["color", "#666"],
	["font-size", "0.85rem"],
	["text-transform", "uppercase"]
])

oHTML.addBreakpoint("768px", ".kpi-grid { grid-template-columns: 1fr 1fr; } .content-grid { grid-template-columns: 1fr; }")

# Navbar
oHTML.addNavbar("Dashboard", [
	["Overview", "#"],
	["Analytics", "#"],
	["Reports", "#"],
	["Settings", "#"]
], [:bgColor = "#1a1a2e", :textColor = "#eee"])

# Dashboard content
oHTML.openDiv([:class = "dashboard"])
oHTML.addRawHTML('<h1 style="margin: 20px 0 5px; font-size: 1.8rem; color: #1a1a2e">Q4 2025 Performance</h1>')
oHTML.addRawHTML('<p style="color: #888; margin-bottom: 25px">Last updated: January 28, 2026</p>')

# KPI Cards
oHTML.openDiv([:class = "kpi-grid"])
oHTML.addRawHTML('<div class="kpi-card"><div class="kpi-label">Revenue</div><div class="kpi-value" style="color: var(--primary)">$2.4M</div><div class="kpi-change positive">+24% from Q3</div></div>')
oHTML.addRawHTML('<div class="kpi-card"><div class="kpi-label">Customers</div><div class="kpi-value" style="color: var(--success)">12,450</div><div class="kpi-change positive">+18% from Q3</div></div>')
oHTML.addRawHTML('<div class="kpi-card"><div class="kpi-label">Churn Rate</div><div class="kpi-value" style="color: var(--warning)">3.2%</div><div class="kpi-change negative">+0.5% from Q3</div></div>')
oHTML.addRawHTML('<div class="kpi-card"><div class="kpi-label">MRR</div><div class="kpi-value" style="color: var(--primary)">$186K</div><div class="kpi-change positive">+12% from Q3</div></div>')
oHTML.closeDiv()

# Main content area
oHTML.openDiv([:class = "content-grid"])

# Left panel - table
oHTML.openDiv([:class = "panel"])
oHTML.addRawHTML("<h3>Department Performance</h3>")
oHTML.addTable([
	["Department", "Revenue", "Target", "Status"],
	["Engineering", "$890K", "$800K", "Exceeded"],
	["Sales", "$720K", "$700K", "Exceeded"],
	["Marketing", "$340K", "$400K", "Below"],
	["Support", "$450K", "$450K", "On Target"]
])
oHTML.closeDiv()

# Right panel - activity
oHTML.openDiv([:class = "panel"])
oHTML.addRawHTML("<h3>Recent Activity</h3>")
oHTML.addList([
	"New enterprise deal closed ($150K)",
	"Product v3.2 deployed to production",
	"Marketing campaign launched",
	"Support team expanded (+3 agents)",
	"Q1 2026 planning completed"
])
oHTML.closeDiv()

oHTML.closeDiv() # content-grid
oHTML.closeDiv() # dashboard

oHTML.save("demo10_dashboard.html")
? "  Created: demo10_dashboard.html"
