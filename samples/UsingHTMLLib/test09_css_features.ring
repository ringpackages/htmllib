/*
	HTMLLib Demo 9 - CSS Features (Variables, Animations, Responsive)
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 9: CSS Features (Variables, Animations, Responsive)
# ------------------------------------------------------------------
? "Demo 9: CSS Features..."

oHTML = new HTMLWriter
oHTML.setTitle("CSS Features Demo")

# CSS Variables
oHTML.addCSSVariable("primary", "#3498db")
oHTML.addCSSVariable("secondary", "#2ecc71")
oHTML.addCSSVariable("accent", "#e74c3c")
oHTML.addCSSVariable("bg", "#f5f5f5")
oHTML.addCSSVariable("text", "#2c3e50")
oHTML.addCSSVariable("radius", "8px")

oHTML.addCSSRule("body", [
	["font-family", "Arial, sans-serif"],
	["background-color", "var(--bg)"],
	["color", "var(--text)"],
	["max-width", "800px"],
	["margin", "0 auto"],
	["padding", "20px"]
])
oHTML.addCSSRule(".demo-box", [
	["padding", "20px"],
	["margin", "10px 0"],
	["border-radius", "var(--radius)"],
	["background-color", "white"],
	["border", "2px solid var(--primary)"]
])
oHTML.addCSSRule(".animated-box", [
	["padding", "20px"],
	["margin", "10px 0"],
	["border-radius", "var(--radius)"],
	["background-color", "var(--primary)"],
	["color", "white"],
	["text-align", "center"],
	["animation", "pulse 2s ease-in-out infinite"]
])
oHTML.addCSSRule(".gradient-box", [
	["padding", "30px"],
	["border-radius", "var(--radius)"],
	["background", "linear-gradient(135deg, var(--primary), var(--secondary))"],
	["color", "white"],
	["text-align", "center"],
	["font-size", "1.2rem"]
])
oHTML.addCSSRule(".hover-card", [
	["padding", "20px"],
	["border-radius", "var(--radius)"],
	["background-color", "white"],
	["box-shadow", "0 2px 8px rgba(0,0,0,0.1)"],
	["transition", "transform 0.3s, box-shadow 0.3s"],
	["cursor", "pointer"]
])
oHTML.addCSSRule(".hover-card:hover", [
	["transform", "translateY(-5px)"],
	["box-shadow", "0 8px 25px rgba(0,0,0,0.15)"]
])

# Animation keyframes
oHTML.addKeyframes("pulse", "0% { transform: scale(1); } 50% { transform: scale(1.02); } 100% { transform: scale(1); }")

# Responsive breakpoint
oHTML.addBreakpoint("768px", ".responsive-grid { grid-template-columns: 1fr !important; }")

oHTML.addHeading(1, "CSS Features Demo")

oHTML.addHeading(2, "CSS Variables (Custom Properties)")
oHTML.addRawHTML('<div class="demo-box">This box uses <code>var(--primary)</code> for its border color and <code>var(--radius)</code> for corners.</div>')

oHTML.addHeading(2, "CSS Gradients")
oHTML.addRawHTML('<div class="gradient-box">Linear gradient using CSS variables</div>')

oHTML.addHeading(2, "CSS Animation")
oHTML.addRawHTML('<div class="animated-box">This box pulses with a CSS animation</div>')

oHTML.addHeading(2, "Hover Transitions")
oHTML.openGrid("1fr 1fr 1fr", "15px")
oHTML.addRawHTML('<div class="hover-card"><h3>Hover Me</h3><p>Cards lift up on hover with smooth transitions</p></div>')
oHTML.addRawHTML('<div class="hover-card"><h3>Hover Me</h3><p>Box shadow deepens for a floating effect</p></div>')
oHTML.addRawHTML('<div class="hover-card"><h3>Hover Me</h3><p>Pure CSS — no JavaScript needed</p></div>')
oHTML.closeGrid()

oHTML.addHeading(2, "Responsive Design")
oHTML.addParagraph("Resize your browser window to see the grid below switch from 3 columns to 1 column at 768px.")
oHTML.openDiv([:class = "responsive-grid", :style = "display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 15px"])
oHTML.addRawHTML('<div class="demo-box">Column 1</div>')
oHTML.addRawHTML('<div class="demo-box">Column 2</div>')
oHTML.addRawHTML('<div class="demo-box">Column 3</div>')
oHTML.closeDiv()

oHTML.save("demo9_css_features.html")
? "  Created: demo9_css_features.html"
