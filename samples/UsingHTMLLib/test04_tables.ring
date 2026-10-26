/*
	HTMLLib Demo 4 - Tables
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 4: Tables
# ------------------------------------------------------------------
? "Demo 4: Tables..."

oHTML = new HTMLWriter
oHTML.setTitle("Tables Demo")

oHTML.addCSSRule("body", [
	["font-family", "Arial, sans-serif"],
	["max-width", "900px"],
	["margin", "0 auto"],
	["padding", "20px"]
])
oHTML.addCSSRule("table", [
	["width", "100%"],
	["border-collapse", "collapse"],
	["margin-bottom", "30px"]
])
oHTML.addCSSRule("th, td", [
	["padding", "10px 15px"],
	["text-align", "left"],
	["border-bottom", "1px solid #dee2e6"]
])
oHTML.addCSSRule("th", [
	["background-color", "#343a40"],
	["color", "white"],
	["font-weight", "600"]
])

oHTML.addHeading(1, "Tables Demo")

oHTML.addHeading(2, "Simple Table")
oHTML.addTable([
	["Name", "Department", "Role", "Salary"],
	["Alice Johnson", "Engineering", "Lead Developer", "$120,000"],
	["Bob Smith", "Marketing", "Director", "$110,000"],
	["Carol White", "Sales", "Manager", "$95,000"],
	["David Brown", "Support", "Senior Agent", "$75,000"]
])

oHTML.addHeading(2, "Styled Table with Features")
oHTML.addTableStyled([
	["Product", "Category", "Price", "Stock", "Rating"],
	["Widget Pro", "Hardware", "$49.99", "1,234", "4.5/5"],
	["App Studio", "Software", "$29.99", "Unlimited", "4.8/5"],
	["Data Cloud", "Service", "$9.99/mo", "N/A", "4.2/5"],
	["Smart Hub", "Hardware", "$149.99", "567", "4.7/5"],
	["Code Editor", "Software", "Free", "Unlimited", "4.9/5"]
], [
	:class = "products-table",
	:striped = true,
	:hover = true,
	:responsive = true,
	:caption = "Product Catalog - Q4 2025"
])

oHTML.save("demo4_tables.html")
? "  Created: demo4_tables.html"
