/*
	HTMLLib Demo 78 - Extrude Geometry
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 78: Extrude Geometry
# ------------------------------------------------------------------
? "Demo 78: Extrude Geometry..."

oHTML = new HTMLWriter
oHTML.setTitle("Extrude Geometry")
oHTML.enableThreeJS()
oHTML.enableOrbitControls()
oHTML.addCSSRule("body", [["margin", "0"], ["overflow", "hidden"]])

oHTML.threeJSScene("ext1", [:fullscreen = true, :bg = "0x0a0a1a", :camZ = "10", :camY = "5"])

# Star shape (extruded)
aStarPoints = []
for nIndex = 0 to 9
	nAngle = nIndex * 3.14159 * 2 / 10 - 3.14159/2
	if nIndex % 2 = 0
		nRow = 1.5
	else
		nRow = 0.7
	ok
	add(aStarPoints, [string(cos(nAngle) * nRow), string(sin(nAngle) * nRow)])
next

oHTML.threeJSExtrude("ext1", "star1", aStarPoints, [
	:depth = "0.5",
	:bevelEnabled = true,
	:bevelThickness = "0.08",
	:bevelSize = "0.05",
	:color = "0xffd700",
	:metalness = "0.7",
	:roughness = "0.2",
	:x = "-3.5", :y = "2"
])

# Heart shape (extruded)
aHeartPoints = []
add(aHeartPoints, ["0", "-1.5"])
add(aHeartPoints, ["-0.8", "-0.5"])
add(aHeartPoints, ["-1.2", "0.3"])
add(aHeartPoints, ["-1", "0.9"])
add(aHeartPoints, ["-0.5", "1.2"])
add(aHeartPoints, ["0", "0.7"])
add(aHeartPoints, ["0.5", "1.2"])
add(aHeartPoints, ["1", "0.9"])
add(aHeartPoints, ["1.2", "0.3"])
add(aHeartPoints, ["0.8", "-0.5"])

oHTML.threeJSExtrude("ext1", "heart1", aHeartPoints, [
	:depth = "0.3",
	:bevelEnabled = true,
	:bevelThickness = "0.05",
	:color = "0xe74c3c",
	:metalness = "0.5",
	:roughness = "0.3",
	:x = "0", :y = "2"
])

# Arrow shape (extruded)
aArrowPoints = []
add(aArrowPoints, ["0", "1.2"])
add(aArrowPoints, ["0.8", "0"])
add(aArrowPoints, ["0.3", "0"])
add(aArrowPoints, ["0.3", "-1.2"])
add(aArrowPoints, ["-0.3", "-1.2"])
add(aArrowPoints, ["-0.3", "0"])
add(aArrowPoints, ["-0.8", "0"])

oHTML.threeJSExtrude("ext1", "arrow1", aArrowPoints, [
	:depth = "0.4",
	:bevelEnabled = true,
	:bevelThickness = "0.05",
	:color = "0x3498db",
	:metalness = "0.5",
	:roughness = "0.3",
	:x = "3.5", :y = "2"
])

oHTML.threeJSPlane("ext1", "extFloor", [:w = "20", :h = "20", :color = "0x1a1a2e", :rx = "-1.5708"])
oHTML.threeJSGridHelper("ext1", [:size = "20", :divisions = "20", :color1 = "0x333344", :color2 = "0x444455"])

# Gentle rotation
oHTML.threeJSOnAnimate("ext1", "
  star1.rotation.y += 0.4 * delta;
  heart1.rotation.y += 0.3 * delta;
  arrow1.rotation.y += 0.5 * delta;
")

oHTML.threeJSAmbientLight("ext1", [:intensity = "0.3"])
oHTML.threeJSDirectionalLight("ext1", "extLt", [:x = "5", :y = "8", :z = "5", :intensity = "0.8"])
oHTML.threeJSPointLight("ext1", "extPt", [:x = "0", :y = "5", :z = "3", :intensity = "0.4", :color = "0xffd700"])

oHTML.threeJSOrbitControls("ext1", [:damping = true])

oHTML.threeJSOverlay("ext1", "<div style='background:rgba(0,0,0,0.6);padding:15px 20px;border-radius:10px'><div style='color:#ffd700;font-weight:bold;font-size:1.1rem'>Extrude Geometry</div><div style='font-size:0.75rem;color:#aaa;margin-top:8px;line-height:1.6'><span style='color:#ffd700'>Star</span> &mdash; 10-point shape<br><span style='color:#e74c3c'>Heart</span> &mdash; curved outline<br><span style='color:#3498db'>Arrow</span> &mdash; angular shape<br>Bevel + metallic material</div></div>", [:position = "top-left"])

oHTML.threeJSAnimate("ext1")
oHTML.save("feat_demo3_extrude.html")
? "  Created: feat_demo3_extrude.html"
