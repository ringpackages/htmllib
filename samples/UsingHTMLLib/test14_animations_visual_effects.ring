/*
	HTMLLib Demo 14 - Animations & Visual Effects
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 14: Animations & Visual Effects
# ------------------------------------------------------------------
? "Demo 14: Animations & effects..."

oHTML = new HTMLWriter
oHTML.setTitle("Animations & Effects")
oHTML.setTheme("elegant")

# Scroll progress bar
oHTML.addJSScrollProgress([:color = "#e94560", :height = "3px"])

oHTML.addRawHTML('<div style="max-width:900px;margin:0 auto;padding:30px">')
oHTML.addHeading(1, "Animations & Visual Effects")
oHTML.addParagraph("Scroll down to see effects. The red progress bar at the top tracks scroll position.")
oHTML.addHR()

# Typing effect
oHTML.addHeading(2, "Typing Animation")
oHTML.addJSTypingEffect("typing-demo", "Welcome to HTMLLib - the most powerful HTML generation library for Ring!", [:speed = "45", :style = "font-size:1.3rem;min-height:40px;color:var(--primary)"])

oHTML.addSpacer("30px")

# Animated numbers
oHTML.addHeading(2, "Animated Numbers (scroll into view)")
oHTML.addRawHTML('<div style="display:flex;justify-content:space-around;flex-wrap:wrap;text-align:center;padding:20px 0">')
oHTML.addRawHTML('<div style="padding:10px">')
oHTML.addJSAnimatedNumber("stat1", "2500", [:prefix = "", :suffix = "+", :style = "font-size:3rem;font-weight:700;color:#e94560;display:block"])
oHTML.addRawHTML('<div style="color:var(--text-muted)">Downloads</div></div>')
oHTML.addRawHTML('<div style="padding:10px">')
oHTML.addJSAnimatedNumber("stat2", "98", [:prefix = "", :suffix = "%", :style = "font-size:3rem;font-weight:700;color:#2ecc71;display:block"])
oHTML.addRawHTML('<div style="color:var(--text-muted)">Satisfaction</div></div>')
oHTML.addRawHTML('<div style="padding:10px">')
oHTML.addJSAnimatedNumber("stat3", "150", [:prefix = "", :suffix = "", :style = "font-size:3rem;font-weight:700;color:#3498db;display:block"])
oHTML.addRawHTML('<div style="color:var(--text-muted)">Contributors</div></div>')
oHTML.addRawHTML('<div style="padding:10px">')
oHTML.addJSAnimatedNumber("stat4", "45", [:prefix = "", :suffix = "+", :style = "font-size:3rem;font-weight:700;color:#f39c12;display:block"])
oHTML.addRawHTML('<div style="color:var(--text-muted)">Libraries</div></div>')
oHTML.addRawHTML('</div>')

oHTML.addSpacer("30px")

# Countdown
oHTML.addHeading(2, "Countdown Timer")
oHTML.addParagraph("Counting down to January 1, 2027:")
oHTML.addJSCountdown("countdown1", "2027-01-01T00:00:00", [])

oHTML.addSpacer("30px")

# Copy to clipboard
oHTML.addHeading(2, "Copy to Clipboard")
oHTML.addRawHTML('<div style="display:flex;gap:10px;flex-wrap:wrap;align-items:center">')
oHTML.addJSCopyButton("Copy Install Command", "load " + char(34) + "htmllib.ring" + char(34), [:style = "padding:10px 20px;cursor:pointer;border:1px solid var(--accent);border-radius:6px;background:var(--accent);color:#fff;font-size:0.95rem"])
oHTML.addJSCopyButton("Copy Email", "contact@ringlang.net", [:style = "padding:10px 20px;cursor:pointer;border:1px solid #ddd;border-radius:6px;background:#fff"])
oHTML.addRawHTML('</div>')

oHTML.addSpacer("30px")

# Tooltips
oHTML.addHeading(2, "JavaScript Tooltips")
oHTML.addParagraph("Hover over the highlighted words:")
oHTML.addRawHTML('<p>HTMLLib supports ')
oHTML.addJSTooltip("Bootstrap 5", "Optional Bootstrap CSS/JS from CDN", [:position = "top"])
oHTML.addRawHTML(', ')
oHTML.addJSTooltip("6 built-in themes", "professional, elegant, modern, dark, nature, arabic", [:position = "top"])
oHTML.addRawHTML(', and ')
oHTML.addJSTooltip("Chart.js integration", "Create bar, line, pie, and doughnut charts", [:position = "top"])
oHTML.addRawHTML('.</p>')

# Long content for scrolling (to show scroll progress)
for nIndex = 1 to 3
	oHTML.addSpacer("50px")
	oHTML.addParagraph("Scroll further to see the progress bar update. This section provides enough content to demonstrate the scroll tracking feature. The progress bar at the top of the page fills as you scroll through the document.")
next

oHTML.addRawHTML('</div>')

# Back to top
oHTML.addJSBackToTop([])

oHTML.save("js_demo3_effects.html")
? "  Created: js_demo3_effects.html"
