/*
	HTMLLib Demo 17 - Notifications & Dark Mode
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 17: Notifications & Dark Mode
# ------------------------------------------------------------------
? "Demo 17: Notifications & dark mode..."

oHTML = new HTMLWriter
oHTML.setTitle("Notifications & Dark Mode")
oHTML.setTheme("professional")

# Enable notification system
oHTML.addJSNotification([:position = "top-right"])

oHTML.addRawHTML('<div style="max-width:900px;margin:0 auto;padding:30px">')
oHTML.addHeading(1, "Notifications & Dark Mode")
oHTML.addHR()

# Notification buttons
oHTML.addHeading(2, "Toast Notifications")
oHTML.addParagraph("Click to trigger different notification types:")
oHTML.addRawHTML('<div style="display:flex;gap:10px;flex-wrap:wrap;margin:15px 0">')
oHTML.addClickButton("Success", "notify('Operation completed successfully!','success')", [:style = "padding:10px 20px;background:#27ae60;color:#fff;border:none;border-radius:6px;cursor:pointer"])
oHTML.addClickButton("Error", "notify('Something went wrong!','danger')", [:style = "padding:10px 20px;background:#e74c3c;color:#fff;border:none;border-radius:6px;cursor:pointer"])
oHTML.addClickButton("Warning", "notify('Please check your input','warning')", [:style = "padding:10px 20px;background:#f39c12;color:#fff;border:none;border-radius:6px;cursor:pointer"])
oHTML.addClickButton("Info", "notify('New version available','info')", [:style = "padding:10px 20px;background:#3498db;color:#fff;border:none;border-radius:6px;cursor:pointer"])
oHTML.addRawHTML('</div>')

oHTML.addSpacer("30px")

# Dark mode toggle
oHTML.addHeading(2, "Dark Mode Toggle")
oHTML.addParagraph("Click the button in the bottom-left corner to toggle dark mode:")
oHTML.addJSDarkModeToggle([])

oHTML.addSpacer("30px")

# Image slideshow
oHTML.addHeading(2, "Image Slideshow")
oHTML.addParagraph("Auto-advancing slideshow with navigation arrows and dot indicators:")
oHTML.addJSSlideshow("gallery1", [
	["https://picsum.photos/900/400?random=1", "Nature landscape 1"],
	["https://picsum.photos/900/400?random=2", "Nature landscape 2"],
	["https://picsum.photos/900/400?random=3", "Nature landscape 3"],
	["https://picsum.photos/900/400?random=4", "Nature landscape 4"]
], [:interval = "4000", :height = "350px"])

oHTML.addRawHTML('</div>')
oHTML.save("js_demo6_notify_dark.html")
? "  Created: js_demo6_notify_dark.html"
