/*
	HTMLLib Demo 18 - Full Interactive Application
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 18: Full Interactive Application
# ------------------------------------------------------------------
? "Demo 18: Full interactive application..."

oHTML = new HTMLWriter
oHTML.setTitle("Ring Language Hub")
oHTML.enableBootstrap()
oHTML.enableBootstrapIcons()
oHTML.enableChartJS()
oHTML.addJSNotification([:position = "top-right"])
oHTML.addJSScrollProgress([:color = "#6c5ce7"])

# Navbar
oHTML.bsNavbar("Ring Hub", "#top", [
	["Home", "#top", true],
	["Features", "#features", false],
	["Stats", "#stats", false],
	["Resources", "#resources", false],
	["Contact", "#contact", false]
], "dark")

# Hero
oHTML.addRawHTML('<a id="top"></a>')
oHTML.addHero("Ring Language Hub", "Your central resource for the Ring Programming Language ecosystem", "Explore Features", "#features", [:bgColor = "#6c5ce7", :height = "75vh"])

# Stats with animated numbers
oHTML.addRawHTML('<div id="stats" style="display:flex;justify-content:space-around;flex-wrap:wrap;text-align:center;padding:50px 20px;background:#f8f9fa">')
oHTML.addRawHTML('<div style="padding:15px">')
oHTML.addJSAnimatedNumber("s1", "10500", [:suffix = "+", :style = "font-size:2.8rem;font-weight:700;color:#6c5ce7;display:block"])
oHTML.addRawHTML('<div style="color:#666;font-size:0.95rem">Downloads</div></div>')
oHTML.addRawHTML('<div style="padding:15px">')
oHTML.addJSAnimatedNumber("s2", "523", [:suffix = "", :style = "font-size:2.8rem;font-weight:700;color:#00b894;display:block"])
oHTML.addRawHTML('<div style="color:#666;font-size:0.95rem">Contributors</div></div>')
oHTML.addRawHTML('<div style="padding:15px">')
oHTML.addJSAnimatedNumber("s3", "48", [:suffix = "+", :style = "font-size:2.8rem;font-weight:700;color:#fd79a8;display:block"])
oHTML.addRawHTML('<div style="color:#666;font-size:0.95rem">Libraries</div></div>')
oHTML.addRawHTML('<div style="padding:15px">')
oHTML.addJSAnimatedNumber("s4", "99", [:prefix = "", :suffix = "%", :style = "font-size:2.8rem;font-weight:700;color:#fdcb6e;display:block"])
oHTML.addRawHTML('<div style="color:#666;font-size:0.95rem">Satisfaction</div></div>')
oHTML.addRawHTML('</div>')

# Features section
oHTML.addRawHTML('<div id="features" style="max-width:1100px;margin:0 auto;padding:50px 20px">')
oHTML.addRawHTML('<h2 class="text-center mb-4">Features</h2>')
oHTML.addJSTabs("feat-tabs", [
	["Libraries", '<div class="p-3"><h4>Rich Library Ecosystem</h4><p>Ring comes with powerful libraries for PDF generation, HTML creation, Excel output, Qt GUI, OpenGL, networking, and more.</p><ul><li><strong>RingPDFLib</strong> - Professional PDF documents with Arabic support</li><li><strong>HTMLLib</strong> - HTML5/CSS3/JS page generation with Bootstrap</li><li><strong>RingExcelLib</strong> - OpenXML .xlsx spreadsheets</li><li><strong>RingQt</strong> - Cross-platform GUI applications</li></ul></div>'],
	["Languages", '<div class="p-3"><h4>Multi-Paradigm Design</h4><p>Ring supports procedural, object-oriented, functional, and natural language programming styles, letting you choose the best approach for each task.</p></div>'],
	["Community", '<div class="p-3"><h4>Active Community</h4><p>Join our growing community of developers, researchers, and enthusiasts. Contribute to open-source projects and share your Ring creations.</p></div>']
])

# Chart
oHTML.addSpacer("40px")
oHTML.addRawHTML('<h3 class="text-center mb-3">Library Growth</h3>')
oHTML.addJSChart("growthChart", "line",
	["2020", "2021", "2022", "2023", "2024", "2025"],
	[
		["Downloads", [500, 1200, 3000, 5500, 8000, 10500], "#6c5ce7"],
		["Contributors", [50, 120, 210, 340, 450, 523], "#00b894"]
	],
	[:title = "Ring Ecosystem Growth"])
oHTML.addRawHTML('</div>')

# Resources with sortable table
oHTML.addRawHTML('<div id="resources" style="max-width:1100px;margin:0 auto;padding:50px 20px">')
oHTML.addRawHTML('<h2 class="text-center mb-4">Library Resources</h2>')
oHTML.addJSSortableTable("res-table", [
	["Library", "Version", "Size (KB)", "Status"],
	["RingPDFLib", "2.1.0", "85", "Stable"],
	["HTMLLib", "1.1.0", "92", "Stable"],
	["RingExcelLib", "1.0.0", "65", "Stable"],
	["RingTUILib", "0.9.0", "48", "Beta"],
	["RingChartLib", "0.5.0", "35", "Alpha"],
	["RingMarkdown", "0.3.0", "22", "Alpha"]
], [:striped = true, :hover = true, :class = "table table-striped table-hover"])
oHTML.addRawHTML('</div>')

# Contact section
oHTML.addRawHTML('<div id="contact" style="max-width:600px;margin:0 auto;padding:50px 20px">')
oHTML.addRawHTML('<h2 class="text-center mb-4">Get in Touch</h2>')
oHTML.openFormStyled("#", "post", [:id = "contactForm"])
oHTML.bsFormGroup("Your Name", "text", "name", "Enter your name")
oHTML.bsFormGroup("Email Address", "email", "email", "name@example.com")
oHTML.bsFormTextarea("Message", "message", 5)
oHTML.bsButton("Send Message", "primary", "lg")
oHTML.closeForm()

oHTML.addJSFormValidation("contactForm", [
	["name", "required", "Please enter your name"],
	["email", "required", "Email is required"],
	["email", "email", "Please enter a valid email"],
	["message", "required", "Please enter a message"]
])

oHTML.addRawHTML('</div>')

# Footer
oHTML.addPageFooter(
	"Copyright 2025 Ring Language Hub. Built with HTMLLib.",
	[["Documentation", "#"], ["GitHub", "#"], ["Community", "#"]],
	[:bgColor = "#1a1a2e"]
)

# JS features
oHTML.addJSBackToTop([:bg = "#6c5ce7"])
oHTML.addJSSmoothScroll()

oHTML.save("js_demo7_fullapp.html")
? "  Created: js_demo7_fullapp.html"
