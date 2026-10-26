/*
	HTMLLib Demo 55 - Dissolve
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 55: Dissolve
# ------------------------------------------------------------------
? "Demo 55: Dissolve..."

oHTML = new HTMLWriter
oHTML.setTitle("Dissolve Effect")
oHTML.enableThreeJS()
oHTML.addCSSRule("body", [["margin", "0"], ["background", "#0a0a1a"], ["overflow", "hidden"]])

oHTML.threeJSScene("d6", [:fullscreen = true, :bg = "0x0a0a1a", :camZ = "4"])

# Dissolving shapes
oHTML.threeJSShaderDissolve("d6", "dBox", "box", "1.5, 1.5, 1.5", [
	:color = "0x6c5ce7", :edgeColor = "0xff6b35", :speed = "0.3",
	:edgeWidth = "0.04", :noiseScale = "3.0", :x = "-2", :y = "0"
])
oHTML.threeJSAutoRotate("d6", "dBox", [:speedY = "0.3", :speedX = "0.2"])

oHTML.threeJSShaderDissolve("d6", "dSphere", "sphere", "1, 64, 64", [
	:color = "0x00cec9", :edgeColor = "0xffd900", :speed = "0.2",
	:edgeWidth = "0.06", :noiseScale = "4.0", :x = "2", :y = "0"
])
oHTML.threeJSAutoRotate("d6", "dSphere", [:speedY = "0.4"])

oHTML.threeJSGridHelper("d6", [:size = "20", :divisions = "20", :color1 = "0x222233", :color2 = "0x333344"])

oHTML.threeJSMouseLook("d6", [])
oHTML.threeJSOverlay("d6", "<div style='background:rgba(0,0,0,0.7);padding:12px 18px;border-radius:8px'><div style='color:#ff6b35;font-weight:bold'>Dissolve Shader</div><div style='font-size:0.7rem;color:#666;margin-top:5px'>Noise threshold + glowing edge</div></div>", [:position = "top-left"])

oHTML.threeJSAnimate("d6")
oHTML.save("shader_demo6_dissolve.html")
? "  Created: shader_demo6_dissolve.html"
