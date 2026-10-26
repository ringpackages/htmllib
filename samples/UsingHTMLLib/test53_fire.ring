/*
	HTMLLib Demo 53 - Fire
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 53: Fire
# ------------------------------------------------------------------
? "Demo 53: Fire..."

oHTML = new HTMLWriter
oHTML.setTitle("Fire Shader")
oHTML.enableThreeJS()
oHTML.addCSSRule("body", [["margin", "0"], ["background", "#0a0000"], ["overflow", "hidden"]])

oHTML.threeJSScene("d4", [:fullscreen = true, :bg = "0x0a0000", :camZ = "4", :camY = "1"])

# Fire plane
oHTML.threeJSShaderFire("d4", "fire", "plane", "2, 3, 32, 32", [
	:color1 = "0xff6b35", :color2 = "0xffd900", :color3 = "0x500000",
	:speed = "2.0", :turbulence = "5.0", :y = "1.5"
])

# Second fire (blue)
oHTML.threeJSShaderFire("d4", "fire2", "plane", "1.5, 2.5, 32, 32", [
	:color1 = "0x0984e3", :color2 = "0x00cec9", :color3 = "0x000033",
	:speed = "2.5", :turbulence = "6.0", :x = "3", :y = "1.2"
])

# Green fire
oHTML.threeJSShaderFire("d4", "fire3", "plane", "1.5, 2.5, 32, 32", [
	:color1 = "0x00b894", :color2 = "0x55efc4", :color3 = "0x003300",
	:speed = "1.8", :turbulence = "4.5", :x = "-3", :y = "1.2"
])

# Dark floor
oHTML.threeJSPlane("d4", "floor4", [:w = "20", :h = "20", :color = "0x111111", :rx = "-1.5708"])

# Ambient glow
oHTML.threeJSPointLight("d4", "glow", [:x = "0", :y = "2", :z = "2", :color = "0xff6b35", :intensity = "0.5"])
oHTML.threeJSAmbientLight("d4", [:intensity = "0.1"])

oHTML.threeJSMouseLook("d4", [])
oHTML.threeJSOverlay("d4", "<div style='background:rgba(0,0,0,0.7);padding:12px 18px;border-radius:8px'><div style='color:#ff6b35;font-weight:bold'>Fire Shader</div><div style='font-size:0.7rem;color:#666;margin-top:5px'>FBM noise + shape masking (3 color variants)</div></div>", [:position = "top-left"])

oHTML.threeJSAnimate("d4")
oHTML.save("shader_demo4_fire.html")
? "  Created: shader_demo4_fire.html"
