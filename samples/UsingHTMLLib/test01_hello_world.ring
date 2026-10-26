/*
	HTMLLib Demo 1 - Hello World
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 1: Hello World
# ------------------------------------------------------------------
? "Demo 1: Hello World..."

oHTML = new HTMLWriter
oHTML.setTitle("Hello World")
oHTML.setAuthor("HTMLLib Demo")

oHTML.addHeading(1, "Hello, HTML World!")
oHTML.addParagraph("This page was generated using HTMLLib.")
oHTML.addParagraph("A pure Ring implementation with no dependencies.")

oHTML.save("demo1_hello.html")
? "  Created: demo1_hello.html"
