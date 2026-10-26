/*
	HTMLLib Demo 6 - Layout (Flexbox and Grid)
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 6: Layout (Flexbox and Grid)
# ------------------------------------------------------------------
? "Demo 6: Layouts..."

oHTML = new HTMLWriter
oHTML.setTitle("Layout Demo")

oHTML.addCSSRule("body", [
	["font-family", "Arial, sans-serif"],
	["padding", "20px"],
	["background-color", "#f0f2f5"]
])
oHTML.addCSSRule(".box", [
	["padding", "20px"],
	["background-color", "#fff"],
	["border-radius", "8px"],
	["border", "1px solid #e0e0e0"],
	["text-align", "center"]
])
oHTML.addCSSRule("h1, h2", [
	["color", "#2c3e50"]
])

oHTML.addHeading(1, "Layout Demo")

oHTML.addHeading(2, "Flexbox Row")
oHTML.openFlex(HTML_FLEX_ROW, HTML_JUSTIFY_BETWEEN, HTML_ALIGN_ITEMS_CENTER)
	oHTML.addRawHTML('<div class="box" style="flex: 1; margin: 5px">Box 1</div>')
	oHTML.addRawHTML('<div class="box" style="flex: 1; margin: 5px">Box 2</div>')
	oHTML.addRawHTML('<div class="box" style="flex: 1; margin: 5px">Box 3</div>')
	oHTML.addRawHTML('<div class="box" style="flex: 1; margin: 5px">Box 4</div>')
oHTML.closeFlex()

oHTML.addSpacer("20px")

oHTML.addHeading(2, "CSS Grid (3 Columns)")
oHTML.openGrid("1fr 1fr 1fr", "15px")
	oHTML.addRawHTML('<div class="box">Grid Item 1</div>')
	oHTML.addRawHTML('<div class="box">Grid Item 2</div>')
	oHTML.addRawHTML('<div class="box">Grid Item 3</div>')
	oHTML.addRawHTML('<div class="box">Grid Item 4</div>')
	oHTML.addRawHTML('<div class="box">Grid Item 5</div>')
	oHTML.addRawHTML('<div class="box">Grid Item 6</div>')
oHTML.closeGrid()

oHTML.addSpacer("20px")

oHTML.addHeading(2, "Two-Column Layout")
oHTML.openTwoColumns("2fr", "1fr", "20px")
	oHTML.addRawHTML('<div class="box"><h3>Main Content</h3><p>This is the primary content area taking 2/3 of the width.</p></div>')
	oHTML.addRawHTML('<div class="box"><h3>Sidebar</h3><p>This is the sidebar taking 1/3 of the width.</p></div>')
oHTML.closeTwoColumns()

oHTML.save("demo6_layout.html")
? "  Created: demo6_layout.html"
