/*
	HTMLLib Demo 22 - Bootstrap Components Showcase
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 22: Bootstrap Components Showcase
# ------------------------------------------------------------------
? "Demo 22: Bootstrap components..."

oHTML = new HTMLWriter
oHTML.setTitle("Bootstrap Components")
oHTML.enableBootstrap()
oHTML.enableBootstrapIcons()

oHTML.bsNavbar("Components", "/", [["Home", "/", false], ["Components", "#", true]], "primary")

oHTML.bsOpenContainer("")
oHTML.addSpacer("20px")
oHTML.addRawHTML('<h1 class="mb-4">Bootstrap Components</h1>')

# Alerts
oHTML.addRawHTML('<h2 class="mt-4 mb-3">Alerts</h2>')
oHTML.bsAlert("This is a success alert - well done!", "success", true)
oHTML.bsAlert("Warning! Something needs your attention.", "warning", true)
oHTML.bsAlert("An error occurred. Please try again.", "danger", true)
oHTML.bsAlert("Here is some useful information.", "info", false)

# Buttons
oHTML.addRawHTML('<h2 class="mt-4 mb-3">Buttons</h2>')
oHTML.addRawHTML('<div class="d-flex gap-2 flex-wrap mb-3">')
oHTML.bsButton("Primary", "primary", "")
oHTML.bsButton("Success", "success", "")
oHTML.bsButton("Danger", "danger", "")
oHTML.bsButton("Warning", "warning", "")
oHTML.bsButton("Info", "info", "")
oHTML.bsButton("Dark", "dark", "")
oHTML.addRawHTML('</div>')
oHTML.addRawHTML('<div class="d-flex gap-2 flex-wrap mb-3">')
oHTML.bsOutlineButton("Primary", "primary", "")
oHTML.bsOutlineButton("Success", "success", "")
oHTML.bsOutlineButton("Danger", "danger", "")
oHTML.addRawHTML('</div>')
oHTML.addRawHTML('<div class="d-flex gap-2 flex-wrap">')
oHTML.bsButton("Large", "primary", "lg")
oHTML.bsButton("Normal", "primary", "")
oHTML.bsButton("Small", "primary", "sm")
oHTML.addRawHTML('</div>')

# Badges
oHTML.addRawHTML('<h2 class="mt-4 mb-3">Badges</h2>')
oHTML.addRawHTML('<div class="d-flex gap-2 flex-wrap">')
oHTML.bsBadge("Primary", "primary")
oHTML.bsBadge("Success", "success")
oHTML.bsBadge("Danger", "danger")
oHTML.bsBadge("Warning", "warning")
oHTML.bsBadge("Info", "info")
oHTML.bsBadge("Dark", "dark")
oHTML.addRawHTML('</div>')

# Progress bars
oHTML.addRawHTML('<h2 class="mt-4 mb-3">Progress Bars</h2>')
oHTML.bsProgress(75, "success", false, false)
oHTML.addSpacer("10px")
oHTML.bsProgress(50, "info", true, false)
oHTML.addSpacer("10px")
oHTML.bsProgress(90, "danger", true, true)

# Table
oHTML.addRawHTML('<h2 class="mt-4 mb-3">Table</h2>')
oHTML.bsTable([
	["#", "Name", "Department", "Role", "Status"],
	["1", "Alice Johnson", "Engineering", "Lead Developer", "Active"],
	["2", "Bob Smith", "Marketing", "Director", "Active"],
	["3", "Carol White", "Sales", "Manager", "On Leave"],
	["4", "David Brown", "Support", "Senior Agent", "Active"],
	["5", "Eve Davis", "Engineering", "Junior Dev", "Active"]
], [:striped = true, :hover = true, :bordered = true, :responsive = true])

# Accordion
oHTML.addRawHTML('<h2 class="mt-4 mb-3">Accordion</h2>')
oHTML.bsAccordion("faq", [
	["What is Ring?", "Ring is a practical general-purpose multi-paradigm programming language designed for creating applications in various domains."],
	["What is HTMLLib?", "HTMLLib is a pure Ring library for generating HTML5/CSS3 pages programmatically with optional Bootstrap support."],
	["How do I install it?", "Install it using RingPM (ringpm install htmllib from ringpackages) then add: load htmllib.ring"]
])

# Modal
oHTML.addRawHTML('<h2 class="mt-4 mb-3">Modal Dialog</h2>')
oHTML.bsModalButton("Open Demo Modal", "demoModal", "primary", "")
oHTML.bsModal("demoModal", "Welcome to HTMLLib", "<p>This modal was generated using <code>bsModal()</code> method.</p><p>It supports all Bootstrap modal features: sizes, centered, headers, footers.</p>", [:centered = true, :footer = '<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button><button type="button" class="btn btn-primary">Save</button>'])

# List Group
oHTML.addRawHTML('<h2 class="mt-4 mb-3">List Group</h2>')
oHTML.bsListGroup(["First item", "Second item", "Third item", "Fourth item", "Fifth item"], [:flush = true])

# Breadcrumb
oHTML.addRawHTML('<h2 class="mt-4 mb-3">Breadcrumb</h2>')
oHTML.bsBreadcrumb([["Home", "/"], ["Library", "/lib"], ["HTMLLib", "/lib/html"], ["Components", ""]])

# Pagination
oHTML.addRawHTML('<h2 class="mt-4 mb-3">Pagination</h2>')
oHTML.bsPagination(3, 8, "/articles")

# Spinners
oHTML.addRawHTML('<h2 class="mt-4 mb-3">Spinners</h2>')
oHTML.addRawHTML('<div class="d-flex gap-3">')
oHTML.bsSpinner("border", "primary")
oHTML.bsSpinner("border", "success")
oHTML.bsSpinner("border", "danger")
oHTML.bsSpinner("grow", "warning")
oHTML.bsSpinner("grow", "info")
oHTML.addRawHTML('</div>')

# Toast
oHTML.addRawHTML('<h2 class="mt-4 mb-3">Toast</h2>')
oHTML.bsToast("Notification", "Your document has been saved successfully.", "Just now")

# Form
oHTML.addRawHTML('<h2 class="mt-4 mb-3">Bootstrap Form</h2>')
oHTML.openForm("#", "post")
oHTML.bsFormGroup("Full Name", "text", "fullname", "Enter your name")
oHTML.bsFormGroup("Email", "email", "email", "name@example.com")
oHTML.bsFormSelect("Country", "country", [
	["", "Select country"],
	["sa", "Saudi Arabia"],
	["us", "United States"],
	["uk", "United Kingdom"]
])
oHTML.bsFormTextarea("Message", "message", 4)
oHTML.bsButton("Submit", "primary", "lg")
oHTML.closeForm()

oHTML.bsCloseContainer()
oHTML.addSpacer("40px")
oHTML.save("ext_demo3_bs_components.html")
? "  Created: ext_demo3_bs_components.html"
