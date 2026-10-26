/*
	HTMLLib Demo 20 - Bootstrap Website
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 20: Bootstrap Website
# ------------------------------------------------------------------
? "Demo 20: Bootstrap website..."

oHTML = new HTMLWriter
oHTML.setTitle("Ring Language - Official Site")
oHTML.enableBootstrap()
oHTML.enableBootstrapIcons()

# Navbar
oHTML.bsNavbar("Ring Language", "/", [
	["Home", "/", true],
	["Features", "#features", false],
	["Documentation", "#docs", false],
	["Download", "#download", false],
	["Community", "#community", false]
], "dark")

# Hero with Bootstrap
oHTML.addHero(
	"Ring Programming Language",
	"A practical general-purpose multi-paradigm language designed for simplicity and natural programming.",
	"Get Started", "#download",
	[:bgColor = "#1a1a2e", :textColor = "#ffffff", :height = "80vh"]
)

# Stats bar
oHTML.addStatsBar([
	["10,000+", "Downloads"],
	["500+", "Contributors"],
	["50+", "Libraries"],
	["99.9%", "Satisfaction"]
], [])

# Features section
oHTML.bsOpenContainer("")
oHTML.addSpacer("40px")
oHTML.addRawHTML('<h2 class="text-center mb-4">Why Choose Ring?</h2>')
oHTML.addFeatureGrid([
	["&#x1F680;", "Fast & Lightweight", "Compiled to optimized bytecode for high performance."],
	["&#x1F4DA;", "Multi-Paradigm", "Procedural, OOP, functional, and natural language support."],
	["&#x1F527;", "Rich Libraries", "Qt, OpenGL, CURL, MySQL, and many more built-in."],
	["&#x1F30D;", "Cross-Platform", "Runs on Windows, Linux, macOS, and mobile."]
], 4)

# Bootstrap cards row
oHTML.addSpacer("30px")
oHTML.addRawHTML('<h2 class="text-center mb-4">Latest Libraries</h2>')
oHTML.bsOpenRow("g-4")

oHTML.bsOpenCol("col-md-4")
oHTML.bsCard("RingPDFLib", "Generate professional PDF documents with Arabic/Unicode support, tables, images, and more.", [:footer = '<a href="#" class="btn btn-primary btn-sm">Learn More</a>'])
oHTML.bsCloseCol()

oHTML.bsOpenCol("col-md-4")
oHTML.bsCard("HTMLLib", "Create HTML5/CSS3 pages with Bootstrap, themes, responsive layouts, and components.", [:footer = '<a href="#" class="btn btn-primary btn-sm">Learn More</a>'])
oHTML.bsCloseCol()

oHTML.bsOpenCol("col-md-4")
oHTML.bsCard("RingExcelLib", "Generate .xlsx spreadsheets following OpenXML spec with formatting and charts.", [:footer = '<a href="#" class="btn btn-primary btn-sm">Learn More</a>'])
oHTML.bsCloseCol()

oHTML.bsCloseRow()

# Testimonials
oHTML.addSpacer("40px")
oHTML.addRawHTML('<h2 class="text-center mb-4">What People Say</h2>')
oHTML.bsOpenRow("g-4")
oHTML.bsOpenCol("col-md-6")
oHTML.addTestimonial("Ring is the most intuitive language I have ever used. The natural language support is incredible.", "Dr. Ahmed", "CS Professor", "")
oHTML.bsCloseCol()
oHTML.bsOpenCol("col-md-6")
oHTML.addTestimonial("We migrated our entire desktop application to Ring and saw a 40% reduction in code complexity.", "Sarah Johnson", "Lead Developer, TechCorp", "")
oHTML.bsCloseCol()
oHTML.bsCloseRow()

oHTML.bsCloseContainer()

# Footer
oHTML.addPageFooter(
	"Copyright 2025 Ring Language. All rights reserved.",
	[["Documentation", "/docs"], ["GitHub", "https://github.com"], ["License", "/license"]],
	[:bgColor = "#1a1a2e"]
)

oHTML.save("ext_demo1_bootstrap.html")
? "  Created: ext_demo1_bootstrap.html"
