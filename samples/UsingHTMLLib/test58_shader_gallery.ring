/*
	HTMLLib Demo 58 - Shader Gallery
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 58: Shader Gallery
# ------------------------------------------------------------------
? "Demo 58: Shader Gallery..."

oHTML = new HTMLWriter
oHTML.setTitle("Shader Gallery")
oHTML.enableThreeJS()
oHTML.addCSSRule("body", [["margin", "0"], ["background", "#0a0a1a"], ["overflow", "hidden"]])

oHTML.threeJSScene("d9", [:fullscreen = true, :bg = "0x0a0a1a", :camZ = "8", :camY = "2", :camFov = "55"])

# Row of different shader effects
oHTML.threeJSShaderGradient("d9", "g_grad", "sphere", "0.8, 32, 32", [
	:color1 = "0xff6b6b", :color2 = "0xffd900", :x = "-6", :y = "1.5"
])
oHTML.threeJSAutoRotate("d9", "g_grad", [:speedY = "0.5"])

oHTML.threeJSShaderFresnel("d9", "g_fres", "sphere", "0.8, 32, 32", [
	:color = "0x111111", :glowColor = "0x6c5ce7", :x = "-3", :y = "1.5"
])
oHTML.threeJSAutoRotate("d9", "g_fres", [:speedY = "0.5"])

oHTML.threeJSShaderHologram("d9", "g_holo", "torusknot", "0.6, 0.2, 64, 8", [
	:color = "0x00cec9", :x = "0", :y = "1.5"
])
oHTML.threeJSAutoRotate("d9", "g_holo", [:speedY = "0.5"])

oHTML.threeJSShaderDissolve("d9", "g_diss", "box", "1.2, 1.2, 1.2", [
	:color = "0x0984e3", :edgeColor = "0xff6b35", :speed = "0.25", :x = "3", :y = "1.5"
])
oHTML.threeJSAutoRotate("d9", "g_diss", [:speedY = "0.3", :speedX = "0.2"])

oHTML.threeJSShaderShield("d9", "g_shield", "sphere", "0.8, 32, 32", [
	:color = "0xff6b6b", :hexScale = "12.0", :x = "6", :y = "1.5"
])
oHTML.threeJSAutoRotate("d9", "g_shield", [:speedY = "0.3"])

# Water floor
oHTML.threeJSShaderWave("d9", "g_wave", "plane", "20, 20, 64, 64", [
	:color1 = "0x0a0a2e", :color2 = "0x1a1a4e", :amplitude = "0.1", :frequency = "2.0",
	:rx = "-1.5708", :y = "-0.5"
])

# Labels
oHTML.threeJSOverlay("d9", "<div style='background:rgba(0,0,0,0.7);padding:12px 18px;border-radius:8px'><div style='color:#6c5ce7;font-weight:bold;font-size:1.1rem'>Shader Gallery</div><div style='font-size:0.7rem;color:#888;margin-top:8px;line-height:1.8'>Gradient &bull; Fresnel &bull; Hologram &bull; Dissolve &bull; Shield</div><div style='font-size:0.65rem;color:#555;margin-top:5px'>Drag to orbit</div></div>", [:position = "top-left"])

oHTML.threeJSAmbientLight("d9", [:intensity = "0.2"])
oHTML.threeJSMouseLook("d9", [])
oHTML.threeJSAnimate("d9")
oHTML.save("shader_demo9_gallery.html")
? "  Created: shader_demo9_gallery.html"
