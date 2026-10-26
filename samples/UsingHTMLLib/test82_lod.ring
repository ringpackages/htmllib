/*
	HTMLLib Demo 82 - LOD (Level of Detail)
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 82: LOD (Level of Detail)
# ------------------------------------------------------------------
? "Demo 82: LOD..."

oHTML = new HTMLWriter
oHTML.setTitle("LOD - Level of Detail")
oHTML.enableThreeJS()
oHTML.enableOrbitControls()
oHTML.addCSSRule("body", [["margin", "0"], ["overflow", "hidden"]])

oHTML.threeJSScene("lod1", [:fullscreen = true, :bg = "0x0a0a1a", :camZ = "6", :camY = "3"])

# LOD spheres at varying distances
oHTML.threeJSLODPreset("lod1", "lodSph1", "sphere", [
	:radius = "1", :color = "0xe74c3c",
	:x = "0", :y = "1.5", :z = "0",
	:near = "8", :mid = "20", :far = "50"
])

oHTML.threeJSLODPreset("lod1", "lodSph2", "sphere", [
	:radius = "1", :color = "0x2ecc71",
	:x = "4", :y = "1.5", :z = "-5",
	:near = "8", :mid = "20", :far = "50"
])

oHTML.threeJSLODPreset("lod1", "lodSph3", "sphere", [
	:radius = "1", :color = "0x3498db",
	:x = "-4", :y = "1.5", :z = "-10",
	:near = "8", :mid = "20", :far = "50"
])

oHTML.threeJSLODPreset("lod1", "lodTor1", "torus", [
	:radius = "1.2", :tube = "0.35", :color = "0xf39c12",
	:x = "6", :y = "1.5", :z = "-15",
	:near = "8", :mid = "20", :far = "50"
])

oHTML.threeJSLODPreset("lod1", "lodTor2", "torus", [
	:radius = "1.2", :tube = "0.35", :color = "0x9b59b6",
	:x = "-6", :y = "1.5", :z = "-20",
	:near = "8", :mid = "20", :far = "50"
])

oHTML.threeJSPlane("lod1", "lodFloor", [:w = "40", :h = "60", :color = "0x1a1a2e", :rx = "-1.5708"])
oHTML.threeJSGridHelper("lod1", [:size = "40", :divisions = "40", :color1 = "0x333344", :color2 = "0x444455"])

oHTML.threeJSAmbientLight("lod1", [:intensity = "0.4"])
oHTML.threeJSDirectionalLight("lod1", "lodLt", [:x = "5", :y = "10", :z = "5", :intensity = "0.7"])

oHTML.threeJSOrbitControls("lod1", [:damping = true])

oHTML.threeJSOverlay("lod1", "<div style='background:rgba(0,0,0,0.6);padding:15px 20px;border-radius:10px'><div style='color:#f39c12;font-weight:bold;font-size:1.1rem'>Level of Detail</div><div style='font-size:0.75rem;color:#aaa;margin-top:8px;line-height:1.6'>Zoom in/out to see LOD swap<br>Near: 32 segments (high)<br>Mid: 16 segments<br>Far: 4-8 segments (low)<br><br>Reduces GPU load for<br>distant objects</div></div>", [:position = "top-left"])

oHTML.threeJSAnimate("lod1")
oHTML.save("feat_demo7_lod.html")
? "  Created: feat_demo7_lod.html"
