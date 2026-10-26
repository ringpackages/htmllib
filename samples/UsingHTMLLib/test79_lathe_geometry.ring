/*
	HTMLLib Demo 79 - Lathe Geometry
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 79: Lathe Geometry
# ------------------------------------------------------------------
? "Demo 79: Lathe Geometry..."

oHTML = new HTMLWriter
oHTML.setTitle("Lathe Geometry")
oHTML.enableThreeJS()
oHTML.enableOrbitControls()
oHTML.addCSSRule("body", [["margin", "0"], ["overflow", "hidden"]])

oHTML.threeJSScene("lat1", [:fullscreen = true, :bg = "0x0a0a1a", :camZ = "10", :camY = "4"])

# Wine glass profile
aGlassProfile = []
add(aGlassProfile, ["0.8", "0"])
add(aGlassProfile, ["0.7", "0.1"])
add(aGlassProfile, ["0.15", "0.4"])
add(aGlassProfile, ["0.1", "0.8"])
add(aGlassProfile, ["0.1", "1.8"])
add(aGlassProfile, ["0.15", "1.9"])
add(aGlassProfile, ["0.5", "2.2"])
add(aGlassProfile, ["0.7", "2.8"])
add(aGlassProfile, ["0.65", "3.2"])
add(aGlassProfile, ["0.5", "3.3"])

oHTML.threeJSLathe("lat1", "glass1", aGlassProfile, [
	:segments = "32",
	:color = "0xaaddff",
	:x = "-3", :y = "0",
	:metalness = "0.1",
	:roughness = "0.05",
	:opacity = "0.35",
	:transparent = true
])

# Vase profile
aVaseProfile = []
add(aVaseProfile, ["0.6", "0"])
add(aVaseProfile, ["0.8", "0.5"])
add(aVaseProfile, ["1", "1"])
add(aVaseProfile, ["0.9", "1.8"])
add(aVaseProfile, ["0.5", "2.5"])
add(aVaseProfile, ["0.4", "3"])
add(aVaseProfile, ["0.6", "3.5"])
add(aVaseProfile, ["0.7", "4"])
add(aVaseProfile, ["0.55", "4.2"])

oHTML.threeJSLathe("lat1", "vase1", aVaseProfile, [
	:segments = "32",
	:color = "0xc0392b",
	:x = "0", :y = "0",
	:metalness = "0.4",
	:roughness = "0.5"
])

# Chess pawn profile
aPawnProfile = []
add(aPawnProfile, ["0.5", "0"])
add(aPawnProfile, ["0.55", "0.15"])
add(aPawnProfile, ["0.3", "0.3"])
add(aPawnProfile, ["0.15", "0.5"])
add(aPawnProfile, ["0.12", "1.5"])
add(aPawnProfile, ["0.2", "1.7"])
add(aPawnProfile, ["0.25", "1.8"])
add(aPawnProfile, ["0.2", "1.9"])
add(aPawnProfile, ["0.15", "2"])
add(aPawnProfile, ["0.3", "2.2"])
add(aPawnProfile, ["0.35", "2.5"])
add(aPawnProfile, ["0.25", "2.8"])
add(aPawnProfile, ["0", "2.9"])

oHTML.threeJSLathe("lat1", "pawn1", aPawnProfile, [
	:segments = "24",
	:color = "0xf5f5dc",
	:x = "3", :y = "0",
	:metalness = "0.2",
	:roughness = "0.6"
])

oHTML.threeJSPlane("lat1", "latFloor", [:w = "20", :h = "20", :color = "0x1a1a2e", :rx = "-1.5708"])
oHTML.threeJSGridHelper("lat1", [:size = "20", :divisions = "20", :color1 = "0x333344", :color2 = "0x444455"])

oHTML.threeJSOnAnimate("lat1", "
  glass1.rotation.y += 0.3 * delta;
  vase1.rotation.y += 0.2 * delta;
  pawn1.rotation.y += 0.4 * delta;
")

oHTML.threeJSAmbientLight("lat1", [:intensity = "0.4"])
oHTML.threeJSDirectionalLight("lat1", "latLt", [:x = "5", :y = "8", :z = "5", :intensity = "0.8"])

oHTML.threeJSOrbitControls("lat1", [:damping = true])

oHTML.threeJSOverlay("lat1", "<div style='background:rgba(0,0,0,0.6);padding:15px 20px;border-radius:10px'><div style='color:#c0392b;font-weight:bold;font-size:1.1rem'>Lathe Geometry</div><div style='font-size:0.75rem;color:#aaa;margin-top:8px;line-height:1.6'><span style='color:#aaddff'>Wine Glass</span> &mdash; transparent<br><span style='color:#c0392b'>Vase</span> &mdash; curved profile<br><span style='color:#f5f5dc'>Chess Pawn</span> &mdash; detailed<br>Revolution from 2D profiles</div></div>", [:position = "top-left"])

oHTML.threeJSAnimate("lat1")
oHTML.save("feat_demo4_lathe.html")
? "  Created: feat_demo4_lathe.html"
