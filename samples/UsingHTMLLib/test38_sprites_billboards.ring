/*
	HTMLLib Demo 38 - Sprites & Billboards
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 38: Sprites & Billboards
# ------------------------------------------------------------------
? "Demo 38: Sprites & Billboards..."

oHTML = new HTMLWriter
oHTML.setTitle("Sprites & Billboards")
oHTML.enableThreeJS()
oHTML.enableOrbitControls()
oHTML.addCSSRule("body", [["margin", "0"], ["overflow", "hidden"]])

oHTML.threeJSScene("spr", [:fullscreen = true, :bg = "0x0a0a2e", :camZ = "8", :camY = "3"])

# 3D objects with text labels above
oHTML.threeJSBox("spr", "obj1", [:x = "-3", :y = "0.75", :color = "0xe74c3c", :w = "1.5", :h = "1.5", :d = "1.5"])
oHTML.threeJSTextSprite("spr", "lbl1", "Cube", [:x = "-3", :y = "2.2", :fontSize = "40", :color = "#e74c3c", :bgColor = "rgba(0,0,0,0.7)", :scale = "1.2"])

oHTML.threeJSSphere("spr", "obj2", [:x = "0", :y = "1", :color = "0x2ecc71", :radius = "0.8", :segments = "32"])
oHTML.threeJSTextSprite("spr", "lbl2", "Sphere", [:x = "0", :y = "2.5", :fontSize = "40", :color = "#2ecc71", :bgColor = "rgba(0,0,0,0.7)", :scale = "1.2"])

oHTML.threeJSCylinder("spr", "obj3", [:x = "3", :y = "0.75", :color = "0x3498db", :radiusTop = "0.7", :radiusBottom = "0.7", :height = "1.5"])
oHTML.threeJSTextSprite("spr", "lbl3", "Cylinder", [:x = "3", :y = "2.2", :fontSize = "40", :color = "#3498db", :bgColor = "rgba(0,0,0,0.7)", :scale = "1.2"])

# Floor
oHTML.threeJSPlane("spr", "floor6", [:w = "20", :h = "20", :color = "0x16213e", :rx = "-1.5708"])
oHTML.threeJSGridHelper("spr", [:size = "20", :divisions = "20", :color1 = "0x1a1a3e", :color2 = "0x2a2a4e"])

oHTML.threeJSAmbientLight("spr", [:intensity = "0.4"])
oHTML.threeJSPointLight("spr", "pl6", [:x = "5", :y = "8", :z = "5", :intensity = "0.7"])

oHTML.threeJSOrbitControls("spr", [:damping = true, :minDistance = "3", :maxDistance = "20"])

oHTML.threeJSOverlay("spr", "<div style='background:rgba(0,0,0,0.7);padding:12px 18px;border-radius:10px'><div style='color:#2ecc71;font-weight:bold'>Sprites & Billboards</div><div style='font-size:0.7rem;color:#aaa;margin-top:5px'>Canvas-rendered text labels<br>Always face camera</div></div>", [:position = "top-left"])

oHTML.threeJSAnimate("spr")
oHTML.save("adv_demo6_sprites.html")
? "  Created: adv_demo6_sprites.html"
