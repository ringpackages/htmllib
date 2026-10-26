/*
	HTMLLib Demo 21 - Theme Showcase
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 21: Theme Showcase
# ------------------------------------------------------------------
? "Demo 21: Theme showcase..."

aThemes = ["professional", "elegant", "modern", "dark", "nature"]
for cThemeName in aThemes
	oHTML = new HTMLWriter
	oHTML.setTitle("Theme: " + cThemeName)
	oHTML.setTheme(cThemeName)

	oHTML.addRawHTML('<div style="max-width:900px;margin:0 auto;padding:30px">')
	oHTML.addHeading(1, "Theme: " + cThemeName)
	oHTML.addParagraph("This page demonstrates the " + cThemeName + " theme. All colors, fonts, and styles are automatically applied.")
	oHTML.addHR()

	oHTML.addHeading(2, "Typography")
	oHTML.addParagraph("Regular paragraph with body font. The theme system uses CSS variables for consistent styling across all elements.")
	oHTML.addBlockquote("This is a blockquote styled by the theme system.")

	oHTML.addHeading(2, "Data Table")
	oHTML.addTable([
		["Module", "Version", "Status"],
		["Core", "2.0", "Stable"],
		["GUI", "1.8", "Stable"],
		["Web", "1.5", "Beta"],
		["Mobile", "1.0", "Alpha"]
	])

	oHTML.addHeading(2, "Code Block")
	oHTML.addCodeBlock('load "htmllib.ring"' + char(10) + 'oHTML = new HTMLWriter' + char(10) + 'oHTML.setTheme("' + cThemeName + '")' + char(10) + 'oHTML.save("page.html")', "ring")

	oHTML.addRawHTML('</div>')
	oHTML.save("ext_demo2_theme_" + cThemeName + ".html")
	? "  Created: ext_demo2_theme_" + cThemeName + ".html"
next
