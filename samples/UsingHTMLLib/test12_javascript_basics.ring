/*
	HTMLLib Demo 12 - Basic JavaScript - Inline Scripts & Events
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 12: Basic JavaScript - Inline Scripts & Events
# ------------------------------------------------------------------
? "Demo 12: Basic JavaScript..."

oHTML = new HTMLWriter
oHTML.setTitle("JavaScript Basics")
oHTML.setTheme("professional")

oHTML.addRawHTML('<div style="max-width:900px;margin:0 auto;padding:30px">')
oHTML.addHeading(1, "JavaScript Integration Basics")
oHTML.addParagraph("HTMLLib provides multiple ways to embed and use JavaScript in your pages.")

# Simple inline script
oHTML.addHeading(2, "Inline Script - Alert Button")
oHTML.addClickButton("Click Me - Say Hello", "alert('Hello from Ring!')", [])
oHTML.addSpacer("15px")

# Multiple event buttons
oHTML.addHeading(2, "Event Handlers")
oHTML.addClickButton("Change Background", "document.body.style.backgroundColor='#e3f2fd'", [:style = "padding:10px 20px;margin:5px;background:#2196F3;color:#fff;border:none;border-radius:6px;cursor:pointer"])
oHTML.addClickButton("Reset Background", "document.body.style.backgroundColor=''", [:style = "padding:10px 20px;margin:5px;background:#666;color:#fff;border:none;border-radius:6px;cursor:pointer"])

oHTML.addSpacer("15px")

# DOM targeting
oHTML.addHeading(2, "DOM Targeting with IDs")
oHTML.addDivById("output-box", "This text will change...")
oHTML.addSpacer("10px")
oHTML.addClickButton("Update Text", "document.getElementById('output-box').textContent='Text updated by JavaScript at '+new Date().toLocaleTimeString()", [:style = "padding:10px 20px;background:#4CAF50;color:#fff;border:none;border-radius:6px;cursor:pointer"])
oHTML.addCSSRule("#output-box", [["padding", "15px"], ["background", "#f5f5f5"], ["border-radius", "6px"], ["border", "1px solid #ddd"], ["font-size", "1.1rem"]])

oHTML.addSpacer("15px")

# Head and body scripts
oHTML.addHeading(2, "Custom Head & Body Scripts")
oHTML.addHeadScript('function greet(name) { return "Welcome, " + name + "!"; }')
oHTML.addDivById("greet-output", "")
oHTML.addBodyScript('document.getElementById("greet-output").textContent = greet("Ring Developer");')
oHTML.addCSSRule("#greet-output", [["padding", "15px"], ["background", "#e8f5e9"], ["border-radius", "6px"], ["border-left", "4px solid #4CAF50"], ["font-weight", "bold"], ["font-size", "1.1rem"]])

oHTML.addSpacer("15px")

# Noscript
oHTML.addHeading(2, "NoScript Fallback")
oHTML.addNoScript('<div style="padding:15px;background:#fff3cd;border:1px solid #ffc107;border-radius:6px">JavaScript is disabled. Some features may not work.</div>')
oHTML.addParagraph("(The above message only appears if JavaScript is disabled)")

oHTML.addRawHTML('</div>')
oHTML.save("js_demo1_basics.html")
? "  Created: js_demo1_basics.html"
