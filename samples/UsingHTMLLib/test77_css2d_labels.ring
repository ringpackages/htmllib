/*
	HTMLLib Demo 77 - CSS2D Labels
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 77: CSS2D Labels
# ------------------------------------------------------------------
? "Demo 77: CSS2D Labels..."

oHTML = new HTMLWriter
oHTML.setTitle("CSS2D Labels")
oHTML.enableThreeJS()
oHTML.enableOrbitControls()
oHTML.enableCSS2DRenderer()
oHTML.addCSSRule("body", [["margin", "0"], ["overflow", "hidden"]])

oHTML.threeJSScene("lbl", [:fullscreen = true, :bg = "0x0a0a1a", :camZ = "12", :camY = "6"])

# Three planets with labels
oHTML.threeJSSphere("lbl", "planet1", [:x = "-4", :y = "1.5", :color = "0xe74c3c", :radius = "1", :segments = "32"])
oHTML.threeJSSphere("lbl", "planet2", [:x = "0", :y = "1.5", :color = "0x3498db", :radius = "1.3", :segments = "32"])
oHTML.threeJSSphere("lbl", "planet3", [:x = "4.5", :y = "1.5", :color = "0x2ecc71", :radius = "0.8", :segments = "32"])

# Initialize CSS2D layer
oHTML.threeJSCSS2DInit("lbl")

# Name labels
oHTML.threeJSCSS2DLabel("lbl", "lbl1", "planet1", "Mars", [
	:offsetY = "1.6",
	:background = "rgba(231,76,60,0.8)",
	:fontSize = "14px",
	:padding = "4px 12px",
	:borderRadius = "12px"
])
oHTML.threeJSCSS2DLabel("lbl", "lbl2", "planet2", "Earth", [
	:offsetY = "2",
	:background = "rgba(52,152,219,0.8)",
	:fontSize = "14px",
	:padding = "4px 12px",
	:borderRadius = "12px"
])
oHTML.threeJSCSS2DLabel("lbl", "lbl3", "planet3", "Venus", [
	:offsetY = "1.4",
	:background = "rgba(46,204,113,0.8)",
	:fontSize = "14px",
	:padding = "4px 12px",
	:borderRadius = "12px"
])

# Health bars on planets
oHTML.threeJSCSS2DBar("lbl", "hp1", "planet1", [:value = "70", :barColor = "#e74c3c", :label = "HP", :offsetY = "2.4", :width = "50"])
oHTML.threeJSCSS2DBar("lbl", "hp2", "planet2", [:value = "100", :barColor = "#3498db", :label = "HP", :offsetY = "2.8", :width = "60"])
oHTML.threeJSCSS2DBar("lbl", "hp3", "planet3", [:value = "45", :barColor = "#2ecc71", :label = "HP", :offsetY = "2.2", :width = "45"])

oHTML.threeJSPlane("lbl", "lblFloor", [:w = "20", :h = "20", :color = "0x1a1a2e", :rx = "-1.5708"])
oHTML.threeJSGridHelper("lbl", [:size = "20", :divisions = "20", :color1 = "0x333344", :color2 = "0x444455"])

# Rotate planets
oHTML.threeJSOnAnimate("lbl", "
  planet1.rotation.y += 0.5 * delta;
  planet2.rotation.y += 0.3 * delta;
  planet3.rotation.y += 0.7 * delta;
")

oHTML.threeJSAmbientLight("lbl", [:intensity = "0.4"])
oHTML.threeJSDirectionalLight("lbl", "lblLt", [:x = "5", :y = "8", :z = "5", :intensity = "0.7"])

oHTML.threeJSOrbitControls("lbl", [:damping = true])

oHTML.threeJSOverlay("lbl", "<div style='background:rgba(0,0,0,0.6);padding:15px 20px;border-radius:10px'><div style='color:#3498db;font-weight:bold;font-size:1.1rem'>CSS2D Labels</div><div style='font-size:0.75rem;color:#aaa;margin-top:8px;line-height:1.6'>HTML labels track 3D objects<br>Name tags + health bars<br>CSS2DRenderer overlay<br>Orbit to see perspective</div></div>", [:position = "top-left"])

oHTML.threeJSAnimate("lbl")
oHTML.save("feat_demo2_labels.html")
? "  Created: feat_demo2_labels.html"
