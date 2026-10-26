/*
	HTMLLib Demo 56 - Energy Shield
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 56: Energy Shield
# ------------------------------------------------------------------
? "Demo 56: Energy Shield..."

oHTML = new HTMLWriter
oHTML.setTitle("Energy Shield")
oHTML.enableThreeJS()
oHTML.addCSSRule("body", [["margin", "0"], ["background", "#000"], ["overflow", "hidden"]])

oHTML.threeJSScene("d7", [:fullscreen = true, :bg = "0x000508", :camZ = "5", :camY = "1"])

# Shield sphere
oHTML.threeJSShaderShield("d7", "shield1", "sphere", "1.5, 64, 64", [
	:color = "0x00cec9", :pulseSpeed = "3.0", :hexScale = "15.0", :y = "1.5"
])
oHTML.threeJSAutoRotate("d7", "shield1", [:speedY = "0.15"])

# Second shield (red)
oHTML.threeJSShaderShield("d7", "shield2", "sphere", "1.2, 64, 64", [
	:color = "0xff6b6b", :pulseSpeed = "4.0", :hexScale = "12.0", :x = "3.5", :y = "1.5"
])
oHTML.threeJSAutoRotate("d7", "shield2", [:speedY = "0.2"])

# Third (gold)
oHTML.threeJSShaderShield("d7", "shield3", "sphere", "1.2, 64, 64", [
	:color = "0xffd900", :pulseSpeed = "2.0", :hexScale = "18.0", :x = "-3.5", :y = "1.5"
])
oHTML.threeJSAutoRotate("d7", "shield3", [:speedY = "0.25"])

# Dark platform
oHTML.threeJSPlane("d7", "floor7", [:w = "20", :h = "20", :color = "0x050810", :rx = "-1.5708"])

oHTML.threeJSParticles("d7", "sparks", [:count = "600", :spread = "15", :size = "0.03", :color = "0x00cec9", :opacity = "0.4"])

oHTML.threeJSMouseLook("d7", [])
oHTML.threeJSOverlay("d7", "<div style='background:rgba(0,0,0,0.7);padding:12px 18px;border-radius:8px'><div style='color:#00cec9;font-weight:bold'>Energy Shield</div><div style='font-size:0.7rem;color:#666;margin-top:5px'>Hexagonal grid + fresnel + pulse wave</div></div>", [:position = "top-left"])

oHTML.threeJSAnimate("d7")
oHTML.save("shader_demo7_shield.html")
? "  Created: shader_demo7_shield.html"
