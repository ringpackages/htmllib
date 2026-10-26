/*
	HTMLLib Demo 15 - Form Validation & Data
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 15: Form Validation & Data
# ------------------------------------------------------------------
? "Demo 15: Form validation & data..."

oHTML = new HTMLWriter
oHTML.setTitle("Form Validation & Data Components")
oHTML.setTheme("professional")

oHTML.addRawHTML('<div style="max-width:900px;margin:0 auto;padding:30px">')
oHTML.addHeading(1, "Form Validation & Data Components")
oHTML.addHR()

# Form with validation
oHTML.addHeading(2, "Registration Form with Live Validation")
oHTML.openFormStyled("#", "post", [:id = "regForm"])

oHTML.addInput("Full Name", "text", "fullname", [:id = "fullname"])
oHTML.addInput("Email Address", "email", "email", [:id = "email"])
oHTML.addInput("Password", "password", "password", [:id = "password"])

oHTML.addRawHTML('<label for="bio">Short Bio</label>')
oHTML.addRawHTML('<textarea id="bio" name="bio" rows="4" style="width:100%;padding:10px;border:1px solid #ccc;border-radius:4px;box-sizing:border-box;resize:vertical"></textarea>')
oHTML.addJSCharCounter("bio", "200")

oHTML.addSpacer("10px")
oHTML.addButton("Register", "submit")
oHTML.closeForm()

oHTML.addJSFormValidation("regForm", [
	["fullname", "required", "Full name is required"],
	["email", "required", "Email is required"],
	["email", "email", "Please enter a valid email address"],
	["password", "required", "Password is required"],
	["password", "minlength", "Password must be at least 8 characters", "8"]
])

oHTML.addCSSRule("#regForm", [["max-width", "500px"]])
oHTML.addCSSRule("#regForm label", [["display", "block"], ["margin-top", "15px"], ["margin-bottom", "5px"], ["font-weight", "600"]])
oHTML.addCSSRule("#regForm input, #regForm textarea", [["width", "100%"], ["padding", "10px"], ["border", "1px solid #ccc"], ["border-radius", "6px"], ["font-size", "1rem"], ["box-sizing", "border-box"]])
oHTML.addCSSRule("#regForm button", [["margin-top", "20px"], ["padding", "12px 30px"], ["background", "var(--primary)"], ["color", "#fff"], ["border", "none"], ["border-radius", "6px"], ["cursor", "pointer"], ["font-size", "1rem"]])

oHTML.addSpacer("40px")

# Searchable list
oHTML.addHeading(2, "Searchable Filter List")
oHTML.addJSFilterList("lang-list", [
	"Ring Programming Language",
	"Python - General Purpose",
	"JavaScript - Web Development",
	"C++ - Systems Programming",
	"Java - Enterprise Applications",
	"Go - Cloud Infrastructure",
	"Rust - Memory Safety",
	"Swift - iOS/macOS Development",
	"Kotlin - Android Development",
	"TypeScript - Typed JavaScript",
	"Ruby - Web Frameworks",
	"PHP - Server-side Scripting"
], [:placeholder = "Search programming languages..."])

oHTML.addSpacer("40px")

# Sortable table
oHTML.addHeading(2, "Sortable Table (click headers to sort)")
oHTML.addJSSortableTable("sort-table", [
	["Name", "Language", "Stars", "Year"],
	["RingPDFLib", "Ring", "125", "2024"],
	["Flask", "Python", "67200", "2010"],
	["Express", "JavaScript", "64800", "2010"],
	["Laravel", "PHP", "78100", "2011"],
	["Django", "Python", "79400", "2005"],
	["Spring", "Java", "56300", "2002"],
	["Rails", "Ruby", "55800", "2004"],
	["FastAPI", "Python", "78900", "2018"],
	["Gin", "Go", "78600", "2014"],
	["Actix", "Rust", "21500", "2017"],
	["HTMLLib", "Ring", "95", "2025"]
], [:striped = true, :hover = true])

oHTML.addCSSRule("#sort-table", [["width", "100%"], ["border-collapse", "collapse"]])
oHTML.addCSSRule("#sort-table th", [["background-color", "var(--primary)"], ["color", "#fff"], ["padding", "12px 14px"], ["text-align", "left"]])
oHTML.addCSSRule("#sort-table td", [["padding", "10px 14px"], ["border-bottom", "1px solid var(--border)"]])

oHTML.addRawHTML('</div>')
oHTML.save("js_demo4_forms_data.html")
? "  Created: js_demo4_forms_data.html"
