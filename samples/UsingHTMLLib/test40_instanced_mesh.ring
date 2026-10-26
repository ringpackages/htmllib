/*
	HTMLLib Demo 40 - Instanced Mesh
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 40: Instanced Mesh
# ------------------------------------------------------------------
? "Demo 40: Instanced Mesh..."

oHTML = new HTMLWriter
oHTML.setTitle("Instanced Mesh - 2000 Objects")
oHTML.enableThreeJS()
oHTML.enableOrbitControls()
oHTML.addCSSRule("body", [["margin", "0"], ["overflow", "hidden"]])

oHTML.threeJSScene("inst", [:fullscreen = true, :bg = "0x0a0a1a", :camZ = "15", :camY = "8"])

# 2000 boxes positioned randomly in a hemisphere
oHTML.threeJSInstancedMesh("inst", "cubes", "box", "0.3, 0.3, 0.3", "2000", [
	:color = "0x6c5ce7",
	:metalness = "0.6", :roughness = "0.3",
	:setup = "_dummy.position.set((Math.random()-0.5)*20, Math.random()*8, (Math.random()-0.5)*20); _dummy.rotation.set(Math.random()*Math.PI, Math.random()*Math.PI, Math.random()*Math.PI); var s = 0.5 + Math.random(); _dummy.scale.set(s, s, s);"
])

# Colorize each instance
oHTML.threeJSInstancedColors("cubes", "2000",
	"_color.setHSL(i/2000, 0.8, 0.5);")

# Animate rotation
oHTML.threeJSOnAnimate("inst", "cubes.rotation.y += 0.05 * delta;")

oHTML.threeJSGridHelper("inst", [:size = "30", :divisions = "30", :color1 = "0x222233", :color2 = "0x333344"])

oHTML.threeJSAmbientLight("inst", [:intensity = "0.3"])
oHTML.threeJSDirectionalLight("inst", "iLight", [:x = "5", :y = "10", :z = "5", :intensity = "0.8"])
oHTML.threeJSPointLight("inst", "iLight2", [:x = "-5", :y = "5", :z = "-5", :intensity = "0.4", :color = "0xff6b6b"])

oHTML.threeJSOrbitControls("inst", [:damping = true, :autoRotate = true, :autoRotateSpeed = "0.5"])

oHTML.threeJSOverlay("inst", "<div style='background:rgba(0,0,0,0.7);padding:12px 18px;border-radius:10px'><div style='color:#6c5ce7;font-weight:bold'>Instanced Mesh</div><div style='font-size:0.7rem;color:#aaa;margin-top:5px'>2000 boxes, 1 draw call<br>Individual HSL colors</div></div>", [:position = "top-left"])

oHTML.threeJSAnimate("inst")
oHTML.save("adv_demo8_instanced.html")
? "  Created: adv_demo8_instanced.html"
