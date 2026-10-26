/*
	HTMLLib Demo 5 - Forms
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 5: Forms
# ------------------------------------------------------------------
? "Demo 5: Forms..."

oHTML = new HTMLWriter
oHTML.setTitle("Forms Demo")

oHTML.addCSSRule("body", [
	["font-family", "Arial, sans-serif"],
	["max-width", "600px"],
	["margin", "0 auto"],
	["padding", "20px"]
])
oHTML.addCSSRule("label", [
	["display", "block"],
	["margin-top", "15px"],
	["margin-bottom", "5px"],
	["font-weight", "600"],
	["color", "#333"]
])
oHTML.addCSSRule("input, select, textarea", [
	["width", "100%"],
	["padding", "10px"],
	["border", "1px solid #ccc"],
	["border-radius", "4px"],
	["font-size", "14px"],
	["box-sizing", "border-box"]
])
oHTML.addCSSRule("input:focus, select:focus, textarea:focus", [
	["border-color", "#007bff"],
	["outline", "none"],
	["box-shadow", "0 0 0 3px rgba(0,123,255,0.15)"]
])
oHTML.addCSSRule("button", [
	["margin-top", "20px"],
	["padding", "12px 24px"],
	["background-color", "#007bff"],
	["color", "white"],
	["border", "none"],
	["border-radius", "4px"],
	["font-size", "16px"],
	["cursor", "pointer"]
])
oHTML.addCSSRule("button:hover", [
	["background-color", "#0056b3"]
])
oHTML.addCSSRule("fieldset", [
	["border", "1px solid #ddd"],
	["border-radius", "8px"],
	["padding", "20px"],
	["margin-bottom", "20px"]
])
oHTML.addCSSRule("legend", [
	["font-weight", "bold"],
	["color", "#007bff"]
])

oHTML.addHeading(1, "Registration Form")

oHTML.openForm("#", "post")

oHTML.openFieldset("Personal Information")
oHTML.addInputField("Full Name", HTML_INPUT_TEXT, "fullname")
oHTML.addInputField("Email Address", HTML_INPUT_EMAIL, "email")
oHTML.addInputField("Password", HTML_INPUT_PASSWORD, "password")
oHTML.addInputField("Date of Birth", HTML_INPUT_DATE, "dob")
oHTML.addInputField("Phone", HTML_INPUT_TEL, "phone")
oHTML.closeFieldset()

oHTML.openFieldset("Preferences")
oHTML.addSelect("Country", "country", [
	["", "-- Select Country --"],
	["sa", "Saudi Arabia"],
	["us", "United States"],
	["uk", "United Kingdom"],
	["eg", "Egypt"],
	["ae", "UAE"]
])

oHTML.addParagraphRaw("<strong>Interests:</strong>")
oHTML.addCheckbox("Programming", "interests", "programming", true)
oHTML.addBreak()
oHTML.addCheckbox("Research", "interests", "research", false)
oHTML.addBreak()
oHTML.addCheckbox("Teaching", "interests", "teaching", false)

oHTML.addParagraphRaw("<strong>Experience Level:</strong>")
oHTML.addRadio("Beginner", "level", "beginner", false)
oHTML.addBreak()
oHTML.addRadio("Intermediate", "level", "intermediate", true)
oHTML.addBreak()
oHTML.addRadio("Expert", "level", "expert", false)

oHTML.addTextarea("Bio", "bio", 4, 50)
oHTML.closeFieldset()

oHTML.addButton("Register", HTML_BTN_SUBMIT)

oHTML.closeForm()

oHTML.save("demo5_forms.html")
? "  Created: demo5_forms.html"
