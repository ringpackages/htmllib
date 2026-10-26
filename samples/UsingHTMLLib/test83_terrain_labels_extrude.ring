/*
	HTMLLib Demo 83 - Combined - Terrain + Labels + Extrude
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 83: Combined - Terrain + Labels + Extrude
# ------------------------------------------------------------------
? "Demo 83: Combined Showcase..."

oHTML = new HTMLWriter
oHTML.setTitle("Combined Showcase")
oHTML.enableThreeJS()
oHTML.enableOrbitControls()
oHTML.enableCSS2DRenderer()
oHTML.addCSSRule("body", [["margin", "0"], ["overflow", "hidden"]])

oHTML.threeJSScene("cmb", [:fullscreen = true, :bg = "0x1a1a3e", :camZ = "14", :camY = "8", :camX = "5"])

# Terrain
oHTML.threeJSTerrain("cmb", "cmbTerrain", [
	:width = "24", :depth = "24",
	:wSegments = "60", :dSegments = "60",
	:maxHeight = "2.5",
	:heightFunc = "Math.sin(x*0.5)*Math.cos(z*0.4)*1.5 + Math.sin(x*0.9+z*0.7)*0.6",
	:color = "0x3a6b2f",
	:flatShading = true,
	:vertexColors = true,
	:colorLow = "0x2a5a1e",
	:colorHigh = "0x6aaa4f"
])

# Landmarks on terrain with labels
oHTML.threeJSExtrude("cmb", "flag1", [["0","-0.3"],["0.5","0.3"],["0","-0.1"],["-0.5","0.3"]], [
	:depth = "0.1", :bevelEnabled = false,
	:color = "0xff4444",
	:x = "-4", :y = "3", :z = "2"
])

oHTML.threeJSCylinder("cmb", "tower1", [
	:x = "3", :y = "2.5", :z = "-3",
	:color = "0xdddddd",
	:radiusTop = "0.3", :radiusBottom = "0.5", :height = "3"
])

oHTML.threeJSSphere("cmb", "beacon1", [
	:x = "0", :y = "4", :z = "0",
	:color = "0xffd700", :radius = "0.5", :segments = "16"
])

# CSS2D labels for landmarks
oHTML.threeJSCSS2DInit("cmb")

oHTML.threeJSCSS2DLabel("cmb", "flagLbl", "flag1", "Base Camp", [
	:offsetY = "1.2",
	:background = "rgba(255,68,68,0.8)",
	:fontSize = "11px",
	:padding = "3px 8px",
	:borderRadius = "8px"
])

oHTML.threeJSCSS2DLabel("cmb", "towerLbl", "tower1", "Watch Tower", [
	:offsetY = "2.2",
	:background = "rgba(200,200,200,0.8)",
	:color = "#111",
	:fontSize = "11px",
	:padding = "3px 8px",
	:borderRadius = "8px"
])

oHTML.threeJSCSS2DLabel("cmb", "beaconLbl", "beacon1", "Signal Beacon", [
	:offsetY = "1.2",
	:background = "rgba(255,215,0,0.8)",
	:color = "#111",
	:fontSize = "11px",
	:padding = "3px 8px",
	:borderRadius = "8px"
])

# Animate beacon
oHTML.threeJSOnAnimate("cmb", "
  beacon1.position.y = 4 + Math.sin(elapsed * 2) * 0.3;
")

oHTML.threeJSAmbientLight("cmb", [:intensity = "0.3"])
oHTML.threeJSDirectionalLight("cmb", "cmbLt", [:x = "8", :y = "12", :z = "5", :intensity = "0.8"])
oHTML.threeJSHemisphereLight("cmb", [:skyColor = "0x6688cc", :groundColor = "0x3a6b2f", :intensity = "0.3"])

oHTML.threeJSFog("cmb", [:color = "0x1a1a3e", :near = "12", :far = "35"])
oHTML.threeJSOrbitControls("cmb", [:damping = true])

oHTML.threeJSOverlay("cmb", "<div style='background:rgba(0,0,0,0.6);padding:15px 20px;border-radius:10px'><div style='color:#6aaa4f;font-weight:bold;font-size:1.1rem'>Combined Showcase</div><div style='font-size:0.75rem;color:#aaa;margin-top:8px;line-height:1.6'>Procedural terrain<br>CSS2D tracking labels<br>Extruded flag shape<br>Hemisphere light + fog</div></div>", [:position = "top-left"])

oHTML.threeJSAnimate("cmb")
oHTML.save("feat_demo8_combined.html")
? "  Created: feat_demo8_combined.html"
