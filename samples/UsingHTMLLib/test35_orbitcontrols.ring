/*
	HTMLLib Demo 35 - OrbitControls
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 35: OrbitControls
# ------------------------------------------------------------------
? "Demo 35: OrbitControls..."

oHTML = new HTMLWriter
oHTML.setTitle("Orbit Controls")
oHTML.enableThreeJS()
oHTML.enableOrbitControls()
oHTML.addCSSRule("body", [["margin", "0"], ["overflow", "hidden"]])

oHTML.threeJSScene("orb", [:fullscreen = true, :bg = "0x0a0a1a", :camZ = "6", :camY = "3"])

# Central object
oHTML.threeJSTorusKnot("orb", "central", [:color = "0x6c5ce7", :radius = "1.2", :tube = "0.4", :metalness = "0.8", :roughness = "0.2"])
oHTML.threeJSAutoRotate("orb", "central", [:speedY = "0.3"])

# Surrounding small spheres
oHTML.threeJSSphere("orb", "s1", [:x = "3", :y = "0", :z = "0", :color = "0x00cec9", :radius = "0.3", :segments = "16"])
oHTML.threeJSSphere("orb", "s2", [:x = "-3", :y = "0", :z = "0", :color = "0xff6b6b", :radius = "0.3", :segments = "16"])
oHTML.threeJSSphere("orb", "s3", [:x = "0", :y = "0", :z = "3", :color = "0xffd900", :radius = "0.3", :segments = "16"])
oHTML.threeJSSphere("orb", "s4", [:x = "0", :y = "0", :z = "-3", :color = "0x55efc4", :radius = "0.3", :segments = "16"])

oHTML.threeJSGridHelper("orb", [:size = "20", :divisions = "20", :color1 = "0x222233", :color2 = "0x333344"])

oHTML.threeJSAmbientLight("orb", [:intensity = "0.3"])
oHTML.threeJSPointLight("orb", "pl", [:x = "5", :y = "5", :z = "5", :intensity = "0.8"])

# OrbitControls with constraints
oHTML.threeJSOrbitControls("orb", [
	:damping = true, :dampingFactor = "0.08",
	:autoRotate = true, :autoRotateSpeed = "1.0",
	:minDistance = "2", :maxDistance = "15",
	:maxPolarAngle = "1.5"
])

oHTML.threeJSOverlay("orb", "<div style='background:rgba(0,0,0,0.7);padding:12px 18px;border-radius:10px'><div style='color:#6c5ce7;font-weight:bold'>OrbitControls</div><div style='font-size:0.7rem;color:#aaa;margin-top:5px;line-height:1.6'>Left drag &mdash; Orbit<br>Right drag &mdash; Pan<br>Scroll &mdash; Zoom<br>Auto-rotate enabled</div></div>", [:position = "top-left"])

oHTML.threeJSAnimate("orb")
oHTML.save("adv_demo3_orbit.html")
? "  Created: adv_demo3_orbit.html"
