/*
	HTMLLib Demo 11 - Quick HTML Function
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 11: Quick HTML Function
# ------------------------------------------------------------------
? "Demo 11: Quick HTML function..."

quickHTML("demo11_quick.html", "Quick Document", [
	[:type = "h", :level = 1, :text = "Quick HTML Generation"],
	[:type = "p", :text = "This was created using the quickHTML helper function."],
	[:type = "hr"],
	[:type = "h", :level = 2, :text = "Features"],
	[:type = "ul", :items = ["Simple API", "No boilerplate", "Quick prototyping"]],
	[:type = "h", :level = 2, :text = "Sample Data"],
	[:type = "table", :data = [
		["Language", "Year", "Creator"],
		["Ring", "2016", "Mahmoud Samir Fayed"],
		["Python", "1991", "Guido van Rossum"],
		["JavaScript", "1995", "Brendan Eich"]
	]],
	[:type = "code", :code = "? " + '"Hello from Ring!"', :language = "ring"]
])
? "  Created: demo11_quick.html"
