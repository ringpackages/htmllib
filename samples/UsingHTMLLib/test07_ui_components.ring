/*
	HTMLLib Demo 7 - UI Components
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 7: UI Components
# ------------------------------------------------------------------
? "Demo 7: UI Components..."

oHTML = new HTMLWriter
oHTML.setTitle("UI Components")

oHTML.addCSSRule("body", [
	["font-family", "'Segoe UI', Tahoma, sans-serif"],
	["max-width", "900px"],
	["margin", "0 auto"],
	["padding", "20px"],
	["background-color", "#f5f5f5"]
])
oHTML.addCSSRule("h2", [
	["color", "#2c3e50"],
	["border-bottom", "2px solid #3498db"],
	["padding-bottom", "8px"],
	["margin-top", "40px"]
])

# Navbar
oHTML.addNavbar("HTMLLib", [
	["Home", "/"],
	["Features", "/features"],
	["Docs", "/docs"],
	["Download", "/download"],
	["About", "/about"]
], [:bgColor = "#2c3e50", :textColor = "#ecf0f1"])

oHTML.addSpacer("30px")
oHTML.addHeading(1, "UI Components Showcase")

# Alerts
oHTML.addHeading(2, "Alerts")
oHTML.addAlert("Operation completed successfully!", :success)
oHTML.addAlert("Please review the form errors below.", :danger)
oHTML.addAlert("Your session will expire in 5 minutes.", :warning)
oHTML.addAlert("A new version is available for download.", :info)

# Badges
oHTML.addHeading(2, "Badges")
oHTML.addParagraphRaw(
	"Status: " +
	'<span style="display: inline-block; padding: 3px 8px; border-radius: 12px; font-size: 0.75rem; font-weight: 600; background-color: #28a745; color: white">Active</span> ' +
	'<span style="display: inline-block; padding: 3px 8px; border-radius: 12px; font-size: 0.75rem; font-weight: 600; background-color: #dc3545; color: white">Urgent</span> ' +
	'<span style="display: inline-block; padding: 3px 8px; border-radius: 12px; font-size: 0.75rem; font-weight: 600; background-color: #007bff; color: white">v2.0</span> ' +
	'<span style="display: inline-block; padding: 3px 8px; border-radius: 12px; font-size: 0.75rem; font-weight: 600; background-color: #ffc107; color: #333">Beta</span>'
)

# Progress Bars
oHTML.addHeading(2, "Progress Bars")
oHTML.addParagraph("Project Alpha (75%)")
oHTML.addProgressBar(75, "#28a745", "24px")
oHTML.addSpacer("10px")
oHTML.addParagraph("Project Beta (45%)")
oHTML.addProgressBar(45, "#007bff", "24px")
oHTML.addSpacer("10px")
oHTML.addParagraph("Project Gamma (90%)")
oHTML.addProgressBar(90, "#fd7e14", "24px")

# Cards
oHTML.addHeading(2, "Cards")
oHTML.openGrid("1fr 1fr 1fr", "20px")
oHTML.addCard("Ring Language", "A practical general-purpose multi-paradigm programming language designed for simplicity and power.", [:footer = '<a href="#">Learn more &rarr;</a>'])
oHTML.addCard("RingPDFLib", "Generate professional PDF documents programmatically with pure Ring code.", [:footer = '<a href="#">Learn more &rarr;</a>'])
oHTML.addCard("HTMLLib", "Create HTML/CSS pages with a clean, fluent API from Ring.", [:footer = '<a href="#">Learn more &rarr;</a>'])
oHTML.closeGrid()

# Breadcrumbs
oHTML.addHeading(2, "Breadcrumbs")
oHTML.addBreadcrumbs([
	["Home", "/"],
	["Products", "/products"],
	["Ring Language", "/products/ring"],
	["Documentation", ""]
])

# Accordion
oHTML.addHeading(2, "Accordion")
oHTML.addAccordion([
	["What is Ring?", "Ring is a practical general-purpose multi-paradigm language. It supports procedural, object-oriented, functional, and natural language programming."],
	["What is HTMLLib?", "HTMLLib is a pure Ring library for generating HTML5/CSS3 pages programmatically without any external dependencies."],
	["How do I install it?", "Install it using RingPM (ringpm install htmllib from ringpackages) then use: load " + '"htmllib.ring"']
])

# Pagination
oHTML.addHeading(2, "Pagination")
oHTML.addPagination(3, 7, "/articles")

# Tooltip
oHTML.addHeading(2, "Tooltips")
oHTML.addParagraphRaw("Hover over this ")
oHTML.addTooltip("underlined word", "This is a tooltip that appears on hover!")
oHTML.addParagraphRaw(" to see the tooltip.")

# Modal
oHTML.addHeading(2, "Modal Dialog")
oHTML.addModalButton("Open Modal", "demo-modal", [:style = "display: inline-block; padding: 10px 20px; background: #007bff; color: #fff; text-decoration: none; border-radius: 4px"])
oHTML.addModal("demo-modal", "Welcome!", "This is a CSS-only modal dialog. Click the X or outside to close.")

oHTML.save("demo7_components.html")
? "  Created: demo7_components.html"
