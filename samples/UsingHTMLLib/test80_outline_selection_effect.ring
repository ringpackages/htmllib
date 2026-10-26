/*
	HTMLLib Demo 80 - Outline Selection Effect
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 80: Outline Selection Effect
# ------------------------------------------------------------------
? "Demo 80: Outline Selection..."

oHTML = new HTMLWriter
oHTML.setTitle("Outline Selection")
oHTML.enableThreeJS()
oHTML.enableOrbitControls()
oHTML.enableOutlinePass()
oHTML.addCSSRule("body", [["margin", "0"], ["overflow", "hidden"]])

oHTML.threeJSScene("out1", [:fullscreen = true, :bg = "0x0a0a1a", :camZ = "10", :camY = "4"])

# Objects
oHTML.threeJSBox("out1", "oBox", [:x = "-3", :y = "1", :color = "0xe74c3c", :w = "1.5", :h = "1.5", :d = "1.5"])
oHTML.threeJSSphere("out1", "oSph", [:x = "0", :y = "1.2", :color = "0x2ecc71", :radius = "1", :segments = "32"])
oHTML.threeJSTorus("out1", "oTor", [:x = "3", :y = "1.5", :color = "0x3498db", :radius = "1", :tube = "0.3"])

oHTML.threeJSPlane("out1", "outFloor", [:w = "20", :h = "20", :color = "0x1a1a2e", :rx = "-1.5708"])
oHTML.threeJSGridHelper("out1", [:size = "20", :divisions = "20", :color1 = "0x333344", :color2 = "0x444455"])

# Initialize outline
oHTML.threeJSOutlineInit("out1", [
	:edgeStrength = "4",
	:edgeGlow = "0.7",
	:edgeThickness = "2",
	:visibleColor = "0xffffff",
	:pulsePeriod = "2"
])

# Hover outline
oHTML.threeJSOutlineOnHover("out1", ["oBox", "oSph", "oTor"], [])

# Rotate objects slowly
oHTML.threeJSOnAnimate("out1", "
  oBox.rotation.y += 0.3 * delta;
  oTor.rotation.x += 0.5 * delta;
  oTor.rotation.y += 0.3 * delta;
")

oHTML.threeJSAmbientLight("out1", [:intensity = "0.4"])
oHTML.threeJSDirectionalLight("out1", "outLt", [:x = "5", :y = "8", :z = "5", :intensity = "0.7"])

oHTML.threeJSOrbitControls("out1", [:damping = true])

oHTML.threeJSOverlay("out1", "<div style='background:rgba(0,0,0,0.6);padding:15px 20px;border-radius:10px'><div style='color:#fff;font-weight:bold;font-size:1.1rem'>Outline Selection</div><div style='font-size:0.75rem;color:#aaa;margin-top:8px;line-height:1.6'><span style='color:#fff'>Hover</span> objects to highlight<br>OutlinePass post-processing<br>Pulsing glow effect<br>Raycaster + EffectComposer</div></div>", [:position = "top-left"])

oHTML.threeJSAnimate("out1")
oHTML.save("feat_demo5_outline.html")
? "  Created: feat_demo5_outline.html"
