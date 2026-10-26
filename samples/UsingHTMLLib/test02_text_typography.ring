/*
	HTMLLib Demo 2 - Text Elements and Typography
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 2: Text Elements and Typography
# ------------------------------------------------------------------
? "Demo 2: Text elements..."

oHTML = new HTMLWriter
oHTML.setTitle("Typography Showcase")
oHTML.setDescription("Demonstrating text elements in HTMLLib")

# Add a clean stylesheet
oHTML.addCSSRule("body", [
	["font-family", "'Segoe UI', Tahoma, Geneva, Verdana, sans-serif"],
	["line-height", "1.6"],
	["max-width", "800px"],
	["margin", "0 auto"],
	["padding", "20px"],
	["color", "#333"]
])

oHTML.addHeading(1, "Typography Showcase")
oHTML.addHR()

oHTML.addHeading(2, "Headings")
oHTML.addHeading(1, "Heading 1")
oHTML.addHeading(2, "Heading 2")
oHTML.addHeading(3, "Heading 3")
oHTML.addHeading(4, "Heading 4")
oHTML.addHeading(5, "Heading 5")
oHTML.addHeading(6, "Heading 6")

oHTML.addHeading(2, "Text Formatting")
oHTML.addBold("Bold text")
oHTML.addBreak()
oHTML.addItalic("Italic text")
oHTML.addBreak()
oHTML.addUnderline("Underlined text")
oHTML.addBreak()
oHTML.addStrikethrough("Strikethrough text")
oHTML.addBreak()
oHTML.addSmall("Small text")
oHTML.addBreak()
oHTML.addMark("Highlighted text")
oHTML.addBreak()
oHTML.addParagraphRaw("H<sub>2</sub>O and E=mc<sup>2</sup>")
oHTML.addBreak()
oHTML.addAbbr("HTML", "HyperText Markup Language")

oHTML.addHeading(2, "Paragraphs")
oHTML.addParagraph("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris.")

oHTML.addBlockquoteStyled("The only way to do great work is to love what you do.", [:style = "border-left: 4px solid #007bff; padding-left: 16px; color: #555; font-style: italic"])

oHTML.addHeading(2, "Code")
oHTML.addCodeBlock('load "htmllib.ring"

oHTML = new HTMLWriter
oHTML.setTitle("My Page")
oHTML.addHeading(1, "Hello!")
oHTML.save("page.html")', "ring")

oHTML.save("demo2_typography.html")
? "  Created: demo2_typography.html"
