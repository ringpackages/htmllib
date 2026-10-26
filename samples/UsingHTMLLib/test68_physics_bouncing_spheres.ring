/*
	HTMLLib Demo 68 - Physics - Bouncing Spheres
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 68: Physics - Bouncing Spheres
# ------------------------------------------------------------------
? "Demo 68: Physics - Bouncing Spheres..."

oHTML = new HTMLWriter
oHTML.setTitle("Physics - Bouncing Spheres")
oHTML.enableThreeJS()
oHTML.enableOrbitControls()
oHTML.enablePhysics()
oHTML.addCSSRule("body", [["margin", "0"], ["overflow", "hidden"]])

oHTML.threeJSScene("phys3", [:fullscreen = true, :bg = "0x0a0a1a", :camZ = "14", :camY = "6"])

oHTML.threeJSPhysicsWorld("phys3", [:gravityY = "-9.82"])

oHTML.threeJSPhysicsGround("phys3", [:visible = true, :color = "0x1a1a2e", :size = "30", :restitution = "0.8"])
oHTML.threeJSGridHelper("phys3", [:size = "30", :divisions = "30", :color1 = "0x333355", :color2 = "0x444466"])

# Multiple bouncing spheres at different heights
oHTML.threeJSSphere("phys3", "bs1", [:x = "-3", :y = "8", :color = "0xff6b6b", :radius = "0.6", :segments = "32"])
oHTML.threeJSPhysicsBody("phys3", "bs1", "sphere", [:mass = "1", :restitution = "0.85", :radius = "0.6"])

oHTML.threeJSSphere("phys3", "bs2", [:x = "-1", :y = "10", :color = "0xffd93d", :radius = "0.6", :segments = "32"])
oHTML.threeJSPhysicsBody("phys3", "bs2", "sphere", [:mass = "1", :restitution = "0.85", :radius = "0.6"])

oHTML.threeJSSphere("phys3", "bs3", [:x = "1", :y = "12", :color = "0x6bcb77", :radius = "0.6", :segments = "32"])
oHTML.threeJSPhysicsBody("phys3", "bs3", "sphere", [:mass = "1", :restitution = "0.85", :radius = "0.6"])

oHTML.threeJSSphere("phys3", "bs4", [:x = "3", :y = "14", :color = "0x4d96ff", :radius = "0.6", :segments = "32"])
oHTML.threeJSPhysicsBody("phys3", "bs4", "sphere", [:mass = "1", :restitution = "0.85", :radius = "0.6"])

oHTML.threeJSSphere("phys3", "bs5", [:x = "0", :y = "16", :color = "0xc05cff", :radius = "0.8", :segments = "32"])
oHTML.threeJSPhysicsBody("phys3", "bs5", "sphere", [:mass = "2", :restitution = "0.9", :radius = "0.8"])

oHTML.threeJSAmbientLight("phys3", [:intensity = "0.4"])
oHTML.threeJSPointLight("phys3", "ph3Lt", [:x = "0", :y = "15", :z = "5", :intensity = "0.8"])

oHTML.threeJSOrbitControls("phys3", [:damping = true])

oHTML.threeJSOverlay("phys3", "<div style='background:rgba(0,0,0,0.7);padding:15px 20px;border-radius:10px'><div style='color:#ff6b6b;font-weight:bold;font-size:1.1rem'>Bouncing Spheres</div><div style='font-size:0.75rem;color:#aaa;margin-top:8px;line-height:1.6'>High restitution (0.85-0.9)<br>Watch the energy transfer!</div></div>", [:position = "top-left"])

oHTML.threeJSAnimate("phys3")
oHTML.save("phys_demo3_bounce.html")
? "  Created: phys_demo3_bounce.html"
