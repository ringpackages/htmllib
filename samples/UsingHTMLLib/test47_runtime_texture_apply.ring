/*
	HTMLLib Demo 47 - Runtime Texture Apply
*/

load "htmllib.ring"

# Free texture URLs (public domain images)
cTexBrick = "https://images.unsplash.com/photo-1528460033278-a6ba57a8e179?w=512&h=512&fit=crop"
cTexWood  = "https://images.unsplash.com/photo-1558618666-fcd25c85f82e?w=512&h=512&fit=crop"
cTexMetal = "https://images.unsplash.com/photo-1543525238-54e3d131f7ca?w=512&h=512&fit=crop"

# ------------------------------------------------------------------
# Demo 47: Runtime Texture Apply
# ------------------------------------------------------------------
? "Demo 47: Runtime Texture Apply..."

oHTML = new HTMLWriter
oHTML.setTitle("Runtime Texture Apply")
oHTML.enableThreeJS()
oHTML.enableOrbitControls()
oHTML.addCSSRule("body", [["margin", "0"], ["overflow", "hidden"]])

oHTML.threeJSScene("rta", [:fullscreen = true, :bg = "0x111122", :camZ = "8", :camY = "3"])

# Plain white objects first
oHTML.threeJSBox("rta", "rtBox", [:x = "-3", :y = "1.2", :w = "2", :h = "2", :d = "2", :color = "0xffffff"])
oHTML.threeJSSphere("rta", "rtSph", [:x = "0", :y = "1.2", :radius = "1.2", :segments = "32", :color = "0xffffff"])
oHTML.threeJSTorus("rta", "rtTor", [:x = "3", :y = "1.2", :radius = "1", :tube = "0.35", :color = "0xffffff"])

# Apply textures at runtime
oHTML.threeJSTextureApply("rtBox", "map", cTexBrick, [:tileX = "1", :tileY = "1"])
oHTML.threeJSTextureApply("rtSph", "map", cTexMetal, [])
oHTML.threeJSTextureApply("rtTor", "map", cTexWood, [:tileX = "3", :tileY = "1"])

oHTML.threeJSPlane("rta", "rtFloor", [:w = "16", :h = "16", :rx = "-1.5708", :color = "0x1a1a2e"])
oHTML.threeJSGridHelper("rta", [:size = "16", :divisions = "16", :color1 = "0x333344", :color2 = "0x444455"])

oHTML.threeJSOnAnimate("rta", "
  rtBox.rotation.y += 0.3 * delta;
  rtSph.rotation.y += 0.4 * delta;
  rtTor.rotation.x += 0.3 * delta;
  rtTor.rotation.y += 0.2 * delta;
")

oHTML.threeJSAmbientLight("rta", [:intensity = "0.5"])
oHTML.threeJSDirectionalLight("rta", "rtaLt", [:x = "5", :y = "8", :z = "5", :intensity = "0.7"])

oHTML.threeJSOrbitControls("rta", [:damping = true])

oHTML.threeJSOverlay("rta", "<div style='background:rgba(0,0,0,0.6);padding:15px 20px;border-radius:10px'><div style='color:#9b59b6;font-weight:bold;font-size:1.1rem'>Runtime Texture Apply</div><div style='font-size:0.75rem;color:#aaa;margin-top:8px;line-height:1.6'>threeJSTextureApply()<br>applies to existing meshes<br>with repeat + wrap options<br><br>No rebuild needed!</div></div>", [:position = "top-left"])

oHTML.threeJSAnimate("rta")
oHTML.save("tex_demo3_runtime.html")
? "  Created: tex_demo3_runtime.html"
