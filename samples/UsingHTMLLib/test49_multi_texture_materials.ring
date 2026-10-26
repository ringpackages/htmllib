/*
	HTMLLib Demo 49 - Multi-Texture Materials (Tiled Floor)
*/

load "htmllib.ring"

# Free texture URLs (public domain images)
cTexBrick = "https://images.unsplash.com/photo-1528460033278-a6ba57a8e179?w=512&h=512&fit=crop"

# ------------------------------------------------------------------
# Demo 49: Multi-Texture Materials (Tiled Floor)
# ------------------------------------------------------------------
? "Demo 49: Multi-Texture Tiled..."

oHTML = new HTMLWriter
oHTML.setTitle("Texture Tiling & Repeat")
oHTML.enableThreeJS()
oHTML.enableOrbitControls()
oHTML.addCSSRule("body", [["margin", "0"], ["overflow", "hidden"]])

oHTML.threeJSScene("tile", [:fullscreen = true, :bg = "0x111122", :camZ = "8", :camY = "5"])

# Show different repeat values - create plain planes first, then apply textures
oHTML.threeJSPlane("tile", "tile1x1", [
	:w = "3", :h = "3", :rx = "-1.5708",
	:x = "-4", :z = "0",
	:color = "0xffffff"
])
oHTML.threeJSTextureApply("tile1x1", "map", cTexBrick, [:tileX = "1", :tileY = "1"])

oHTML.threeJSPlane("tile", "tile2x2", [
	:w = "3", :h = "3", :rx = "-1.5708",
	:x = "0", :z = "0",
	:color = "0xffffff"
])
oHTML.threeJSTextureApply("tile2x2", "map", cTexBrick, [:tileX = "2", :tileY = "2"])

oHTML.threeJSPlane("tile", "tile4x4", [
	:w = "3", :h = "3", :rx = "-1.5708",
	:x = "4", :z = "0",
	:color = "0xffffff"
])
oHTML.threeJSTextureApply("tile4x4", "map", cTexBrick, [:tileX = "4", :tileY = "4"])

# Floor
oHTML.threeJSPlane("tile", "darkFloor", [
	:w = "20", :h = "20", :rx = "-1.5708", :y = "-0.01",
	:color = "0x0a0a15"
])
oHTML.threeJSGridHelper("tile", [:size = "20", :divisions = "20", :color1 = "0x222233", :color2 = "0x333344"])

oHTML.threeJSAmbientLight("tile", [:intensity = "0.6"])
oHTML.threeJSDirectionalLight("tile", "tileLt", [:x = "3", :y = "8", :z = "5", :intensity = "0.6"])

oHTML.threeJSOrbitControls("tile", [:damping = true])

oHTML.threeJSOverlay("tile", "<div style='background:rgba(0,0,0,0.6);padding:15px 20px;border-radius:10px'><div style='color:#c87533;font-weight:bold;font-size:1.1rem'>Texture Repeat / Tiling</div><div style='font-size:0.75rem;color:#aaa;margin-top:8px;line-height:1.6'>Left: 1&times;1 (stretched)<br>Center: 2&times;2 repeat<br>Right: 4&times;4 repeat<br><br>repeatX / repeatY options<br>RepeatWrapping mode</div></div>", [:position = "top-left"])

oHTML.threeJSAnimate("tile")
oHTML.save("tex_demo5_tiling.html")
? "  Created: tex_demo5_tiling.html"
