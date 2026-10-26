/*
	HTMLLib Demo 76 - Procedural Terrain
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 76: Procedural Terrain
# ------------------------------------------------------------------
? "Demo 76: Procedural Terrain..."

oHTML = new HTMLWriter
oHTML.setTitle("Procedural Terrain")
oHTML.enableThreeJS()
oHTML.enableOrbitControls()
oHTML.addCSSRule("body", [["margin", "0"], ["overflow", "hidden"]])

oHTML.threeJSScene("ter1", [:fullscreen = true, :bg = "0x87ceeb", :camZ = "18", :camY = "12", :camX = "10"])

# Procedural terrain with vertex colors
oHTML.threeJSTerrain("ter1", "terrain1", [
	:width = "30", :depth = "30",
	:wSegments = "80", :dSegments = "80",
	:maxHeight = "4",
	:heightFunc = "Math.sin(x*0.4)*Math.cos(z*0.3)*2 + Math.sin(x*0.8+z*0.6)*0.8 + Math.cos(z*0.2)*1.5",
	:color = "0x4a7c3f",
	:flatShading = true,
	:vertexColors = true,
	:colorLow = "0x2d6a1e",
	:colorHigh = "0x8fbc8f"
])

# Water plane
oHTML.threeJSPlane("ter1", "water1", [
	:w = "30", :h = "30",
	:color = "0x1e90ff",
	:rx = "-1.5708",
	:y = "-0.3",
	:material = "standard",
	:opacity = "0.6",
	:transparent = true,
	:metalness = "0.3",
	:roughness = "0.1"
])

oHTML.threeJSAmbientLight("ter1", [:intensity = "0.4"])
oHTML.threeJSDirectionalLight("ter1", "tLt1", [:x = "10", :y = "15", :z = "5", :intensity = "0.8"])
oHTML.threeJSHemisphereLight("ter1", [:skyColor = "0x87ceeb", :groundColor = "0x4a7c3f", :intensity = "0.3"])

oHTML.threeJSFog("ter1", [:color = "0x87ceeb", :near = "15", :far = "45"])
oHTML.threeJSOrbitControls("ter1", [:damping = true])

oHTML.threeJSOverlay("ter1", "<div style='background:rgba(0,0,0,0.6);padding:15px 20px;border-radius:10px'><div style='color:#4a7c3f;font-weight:bold;font-size:1.1rem'>Procedural Terrain</div><div style='font-size:0.75rem;color:#aaa;margin-top:8px;line-height:1.6'>80&times;80 segments<br>Vertex colors (low&rarr;high)<br>Custom height function<br>Fog + hemisphere light</div></div>", [:position = "top-left"])

oHTML.threeJSAnimate("ter1")
oHTML.save("feat_demo1_terrain.html")
? "  Created: feat_demo1_terrain.html"
