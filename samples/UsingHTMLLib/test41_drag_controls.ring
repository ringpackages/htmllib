/*
	HTMLLib Demo 41 - Drag Controls
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 41: Drag Controls
# ------------------------------------------------------------------
? "Demo 41: Drag Controls..."

oHTML = new HTMLWriter
oHTML.setTitle("Drag Controls")
oHTML.enableThreeJS()
oHTML.enableOrbitControls()
oHTML.addCSSRule("body", [["margin", "0"], ["overflow", "hidden"]])

oHTML.threeJSScene("drg", [:fullscreen = true, :bg = "0x1a1a2e", :camZ = "8", :camY = "5"])

# Draggable objects
oHTML.threeJSBox("drg", "dBox1", [:x = "-2", :y = "0.75", :color = "0xe74c3c", :w = "1.5", :h = "1.5", :d = "1.5"])
oHTML.threeJSSphere("drg", "dSph1", [:x = "0", :y = "0.8", :color = "0x2ecc71", :radius = "0.8", :segments = "32"])
oHTML.threeJSBox("drg", "dBox2", [:x = "2", :y = "0.75", :color = "0x3498db", :w = "1.5", :h = "1.5", :d = "1.5"])

oHTML.threeJSPlane("drg", "floorDrg", [:w = "20", :h = "20", :color = "0x2c3e50", :rx = "-1.5708"])
oHTML.threeJSGridHelper("drg", [:size = "20", :divisions = "20", :color1 = "0x333344", :color2 = "0x444455"])

oHTML.threeJSAmbientLight("drg", [:intensity = "0.4"])
oHTML.threeJSDirectionalLight("drg", "drgLt", [:x = "5", :y = "8", :z = "5", :intensity = "0.7"])

# Drag controls
oHTML.threeJSDragControls("drg", ["dBox1", "dSph1", "dBox2"], [
	:onDragStart = "document.body.style.cursor='grabbing';",
	:onDragEnd = "document.body.style.cursor='default';"
])

oHTML.threeJSOrbitControls("drg", [:damping = true])

oHTML.threeJSOverlay("drg", "<div style='background:rgba(0,0,0,0.7);padding:15px 20px;border-radius:10px'><div style='color:#e74c3c;font-weight:bold;font-size:1.1rem'>Drag Controls</div><div style='font-size:0.75rem;color:#aaa;margin-top:8px;line-height:1.6'>Click & drag objects to move them<br>Right-drag to orbit camera</div></div>", [:position = "top-left"])

oHTML.threeJSAnimate("drg")
oHTML.save("adv_demo9_drag.html")
? "  Created: adv_demo9_drag.html"
