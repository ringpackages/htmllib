/*
	HTMLLib Demo 3 - Lists
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 3: Lists
# ------------------------------------------------------------------
? "Demo 3: Lists..."

oHTML = new HTMLWriter
oHTML.setTitle("Lists Demo")

oHTML.addCSSRule("body", [
	["font-family", "Arial, sans-serif"],
	["max-width", "700px"],
	["margin", "0 auto"],
	["padding", "20px"]
])

oHTML.addHeading(1, "Lists Demo")

oHTML.addHeading(2, "Unordered List")
oHTML.addList(["Apple", "Banana", "Cherry", "Date", "Elderberry"])

oHTML.addHeading(2, "Ordered List")
oHTML.addOrderedList(["First step: Plan", "Second step: Code", "Third step: Test", "Fourth step: Deploy"])

oHTML.addHeading(2, "Definition List")
oHTML.addDefList([
	["Ring", "A practical general-purpose multi-paradigm language"],
	["HTML", "HyperText Markup Language for web pages"],
	["CSS", "Cascading Style Sheets for styling"]
])

oHTML.addHeading(2, "Styled List")
oHTML.addListStyled(
	["Custom styled item one", "Custom styled item two", "Custom styled item three"],
	[:class = "custom-list", :style = "list-style-type: square; color: #2c3e50"]
)

oHTML.save("demo3_lists.html")
? "  Created: demo3_lists.html"
