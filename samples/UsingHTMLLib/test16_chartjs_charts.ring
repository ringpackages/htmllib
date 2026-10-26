/*
	HTMLLib Demo 16 - Charts with Chart.js
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 16: Charts with Chart.js
# ------------------------------------------------------------------
? "Demo 16: Charts..."

oHTML = new HTMLWriter
oHTML.setTitle("Charts & Data Visualization")
oHTML.setTheme("modern")
oHTML.enableChartJS()

oHTML.addRawHTML('<div style="max-width:1000px;margin:0 auto;padding:30px">')
oHTML.addHeading(1, "Charts & Data Visualization")
oHTML.addParagraph("Built-in Chart.js integration for beautiful data visualization.")
oHTML.addHR()

# Bar chart
oHTML.addHeading(2, "Bar Chart - Monthly Downloads")
oHTML.addJSChart("barChart", "bar",
	["Jan", "Feb", "Mar", "Apr", "May", "Jun"],
	[
		["RingPDFLib", [120, 190, 300, 500, 600, 800], "#6c5ce7"],
		["HTMLLib", [80, 150, 250, 400, 550, 750], "#fd79a8"],
		["RingExcelLib", [50, 100, 180, 300, 420, 580], "#00b894"]
	],
	[:title = "Library Downloads (2025)", :height = "350px"])

oHTML.addSpacer("40px")

# Line chart
oHTML.addHeading(2, "Line Chart - Performance Metrics")
oHTML.addJSChart("lineChart", "line",
	["Week 1", "Week 2", "Week 3", "Week 4", "Week 5", "Week 6", "Week 7", "Week 8"],
	[
		["Response Time (ms)", [45, 42, 38, 35, 33, 30, 28, 25], "#e74c3c"],
		["Throughput (req/s)", [100, 120, 150, 180, 200, 230, 250, 280], "#3498db"]
	],
	[:title = "API Performance Over Time"])

oHTML.addSpacer("40px")

# Doughnut chart
oHTML.addHeading(2, "Doughnut Chart - Language Distribution")
oHTML.addJSChart("doughnutChart", "doughnut",
	["Ring", "Python", "JavaScript", "Java", "Other"],
	[
		["Usage", [35, 25, 20, 12, 8], ["#6c5ce7", "#00b894", "#fdcb6e", "#e17055", "#dfe6e9"]]
	],
	[:title = "Programming Language Distribution"])

oHTML.addSpacer("40px")

# Pie chart
oHTML.addHeading(2, "Pie Chart - Project Status")
oHTML.addJSChart("pieChart", "pie",
	["Completed", "In Progress", "Planned", "On Hold"],
	[
		["Tasks", [12, 5, 8, 2], ["#2ecc71", "#3498db", "#f39c12", "#e74c3c"]]
	],
	[:title = "Project Task Status"])

oHTML.addRawHTML('</div>')
oHTML.save("js_demo5_charts.html")
? "  Created: js_demo5_charts.html"
