/*
	HTMLLib Demo 19 - Embedding external JS files
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 19: Embedding external JS files
# ------------------------------------------------------------------
? "Demo 19: External JS files..."

oHTML = new HTMLWriter
oHTML.setTitle("External JavaScript Files")
oHTML.setTheme("professional")

oHTML.addRawHTML('<div style="max-width:900px;margin:0 auto;padding:30px">')
oHTML.addHeading(1, "Working with External JavaScript Files")
oHTML.addParagraph("HTMLLib supports multiple ways to include JavaScript:")
oHTML.addHR()

oHTML.addHeading(2, "1. External Script Files (addScript)")
oHTML.addCodeBlock('oHTML.addScript("js/app.js")' + char(10) +
				 'oHTML.addScript("https://cdn.example.com/lib.min.js")', "ring")
oHTML.addParagraph("Generates: <script src='...'></script> at end of body")

oHTML.addSpacer("20px")

oHTML.addHeading(2, "2. Head Scripts (addHeadScript)")
oHTML.addCodeBlock('oHTML.addHeadScript("' + char(10) +
				 '  var CONFIG = {' + char(10) +
				 '    apiUrl: ' + char(34) + "https://api.example.com" + char(34) + "," + char(10) +
				 '    debug: false' + char(10) +
				 '  };' + char(10) +
				 '")', "ring")
oHTML.addParagraph("Places JavaScript in the <head> section, runs before body loads.")

oHTML.addSpacer("20px")

oHTML.addHeading(2, "3. Body Scripts (addBodyScript)")
oHTML.addCodeBlock('oHTML.addBodyScript("' + char(10) +
				 '  document.addEventListener(' + char(34) + "DOMContentLoaded" + char(34) + ", function() {" + char(10) +
				 '    console.log(' + char(34) + "Page loaded!" + char(34) + ");" + char(10) +
				 '  });' + char(10) +
				 '")', "ring")
oHTML.addParagraph("Placed before </body>, runs after all HTML content is parsed.")

oHTML.addSpacer("20px")

oHTML.addHeading(2, "4. Inline Scripts (addInlineScript)")
oHTML.addCodeBlock('oHTML.addInlineScript("' + char(10) +
				 '  console.log(' + char(34) + "Inline script executed" + char(34) + ");" + char(10) +
				 '")', "ring")
oHTML.addParagraph("Placed at the current position in the body content flow.")

oHTML.addSpacer("20px")

oHTML.addHeading(2, "5. ES6 Modules (addModuleScript)")
oHTML.addCodeBlock('oHTML.addModuleScript("' + char(10) +
				 "  import { createApp } from './app.js';" + char(10) +
				 '  createApp();' + char(10) +
				 '")', "ring")
oHTML.addParagraph('Generates: <script type="module">...</script>')

oHTML.addSpacer("20px")

oHTML.addHeading(2, "6. CDN Libraries")
oHTML.addCodeBlock('oHTML.enableChartJS()                 # Chart.js' + char(10) +
				 'oHTML.enableHighlightJS()              # Highlight.js' + char(10) +
				 'oHTML.enableBootstrap()                # Bootstrap 5 JS' + char(10) +
				 'oHTML.addScript("https://unpkg.com/alpinejs")  # Alpine.js', "ring")
oHTML.addParagraph("Framework CDN links are injected automatically in the correct order.")

oHTML.addSpacer("20px")

# Live example
oHTML.addHeading(2, "Live Example: Custom Inline Script")
oHTML.addDivById("clock", "")
oHTML.addCSSRule("#clock", [["font-size", "2rem"], ["font-weight", "700"], ["color", "var(--primary)"], ["padding", "20px"], ["text-align", "center"], ["background", "var(--bg-alt,#f5f5f5)"], ["border-radius", "8px"]])
oHTML.addInlineScript('setInterval(function(){ document.getElementById("clock").textContent = new Date().toLocaleTimeString(); }, 1000);')
oHTML.addParagraph("The clock above is powered by a simple inline setInterval script.")

oHTML.addRawHTML('</div>')
oHTML.save("js_demo8_external.html")
? "  Created: js_demo8_external.html"
