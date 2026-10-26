/*
	HTMLLib Demo 48 - Textured Terrain
*/

load "htmllib.ring"

# Free texture URLs (public domain images)
cTexWood  = "https://images.unsplash.com/photo-1558618666-fcd25c85f82e?w=512&h=512&fit=crop"
cTexGrass = "https://images.unsplash.com/photo-1516912481808-3406841bd33c?w=512&h=512&fit=crop"
cTexStone = "https://images.unsplash.com/photo-1520178606-adba40f700db?w=512&h=512&fit=crop"

# ------------------------------------------------------------------
# Demo 48: Textured Terrain
# ------------------------------------------------------------------
? "Demo 48: Textured Terrain..."

oHTML = new HTMLWriter
oHTML.setTitle("Textured Terrain")
oHTML.enableThreeJS()
oHTML.enableOrbitControls()
oHTML.addCSSRule("body", [["margin", "0"], ["overflow", "hidden"]])

oHTML.threeJSScene("tter", [:fullscreen = true, :bg = "0x87ceeb", :camZ = "18", :camY = "12", :camX = "10"])

# Terrain with grass texture
oHTML.threeJSTerrain("tter", "grassLand", [
	:width = "30", :depth = "30",
	:wSegments = "64", :dSegments = "64",
	:maxHeight = "3",
	:heightFunc = "Math.sin(x*0.3)*Math.cos(z*0.4)*2 + Math.sin(x*0.7+z*0.5)*0.8",
	:color = "0x66aa44",
	:flatShading = true
])

# Apply grass texture to terrain after creation
oHTML.threeJSTerrainTexture("grassLand", cTexGrass, [:tileX = "8", :tileY = "8"])

# Water plane
oHTML.threeJSPlane("tter", "water", [
	:w = "30", :h = "30", :rx = "-1.5708", :y = "-0.5",
	:color = "0x2288cc",
	:opacity = "0.5", :transparent = true,
	:metalness = "0.3", :roughness = "0.1"
])

# Some textured objects on terrain
oHTML.threeJSBox("tter", "cabin", [
	:x = "3", :y = "2.5", :z = "2",
	:w = "2", :h = "2", :d = "2",
	:texture = cTexWood,
	:color = "0xffffff",
	:roughness = "0.8"
])

oHTML.threeJSCylinder("tter", "pillar", [
	:x = "-4", :y = "2", :z = "-3",
	:radiusTop = "0.4", :radiusBottom = "0.5", :height = "3",
	:segments = "16",
	:texture = cTexStone,
	:color = "0xffffff"
])

oHTML.threeJSAmbientLight("tter", [:intensity = "0.4"])
oHTML.threeJSDirectionalLight("tter", "tterLt", [:x = "10", :y = "15", :z = "5", :intensity = "0.8"])
oHTML.threeJSHemisphereLight("tter", [:skyColor = "0x87ceeb", :groundColor = "0x4a7c3f", :intensity = "0.3"])

oHTML.threeJSFog("tter", [:color = "0x87ceeb", :near = "15", :far = "40"])
oHTML.threeJSOrbitControls("tter", [:damping = true])

oHTML.threeJSOverlay("tter", "<div style='background:rgba(0,0,0,0.6);padding:15px 20px;border-radius:10px'><div style='color:#66aa44;font-weight:bold;font-size:1.1rem'>Textured Terrain</div><div style='font-size:0.75rem;color:#aaa;margin-top:8px;line-height:1.6'>Grass texture (8&times;8 repeat)<br>Wood cabin + stone pillar<br>threeJSTerrainTexture()<br>Fog + hemisphere light</div></div>", [:position = "top-left"])

oHTML.threeJSAnimate("tter")
oHTML.save("tex_demo4_terrain.html")
? "  Created: tex_demo4_terrain.html"
