/*
	HTMLLib Demo 72 - 3D Text - Hello World
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 72: 3D Text - Hello World
# ------------------------------------------------------------------
? "Demo 72: 3D Text - Hello World..."

oHTML = new HTMLWriter
oHTML.setTitle("3D Text")
oHTML.enableThreeJS()
oHTML.enableOrbitControls()
oHTML.enableTextGeometry()
oHTML.addCSSRule("body", [["margin", "0"], ["overflow", "hidden"]])

oHTML.threeJSScene("txt1", [:fullscreen = true, :bg = "0x0a0a1a", :camZ = "8", :camY = "2"])

# 3D text
oHTML.threeJSText3D("txt1", "hello3d", "Hello World", [:size = "1.2", :height = "0.4", :color = "0xff6b6b", :metalness = "0.6", :roughness = "0.2", :emissive = "0xff2222", :emissiveIntensity = "0.15", :font = "helvetiker", :fontStyle = "bold", :y = "2"])

oHTML.threeJSText3D("txt1", "sub3d", "Ring Language", [:size = "0.6", :height = "0.15", :color = "0x6c5ce7", :metalness = "0.4", :roughness = "0.3", :font = "helvetiker", :y = "0"])

oHTML.threeJSPlane("txt1", "txtFloor", [:w = "20", :h = "20", :color = "0x1a1a2e", :rx = "-1.5708"])
oHTML.threeJSGridHelper("txt1", [:size = "20", :divisions = "20", :color1 = "0x333344", :color2 = "0x444455"])

oHTML.threeJSAmbientLight("txt1", [:intensity = "0.3"])
oHTML.threeJSDirectionalLight("txt1", "txtLt", [:x = "3", :y = "8", :z = "5", :intensity = "0.9"])
oHTML.threeJSPointLight("txt1", "txtPt", [:x = "0", :y = "5", :z = "3", :intensity = "0.5", :color = "0xff6b6b"])

oHTML.threeJSOrbitControls("txt1", [:damping = true, :autoRotate = true, :autoRotateSpeed = "1"])

oHTML.threeJSOverlay("txt1", "<div style='background:rgba(0,0,0,0.7);padding:15px 20px;border-radius:10px'><div style='color:#ff6b6b;font-weight:bold;font-size:1.1rem'>3D Text Geometry</div><div style='font-size:0.75rem;color:#aaa;margin-top:8px;line-height:1.6'>TextGeometry + FontLoader<br>Bevel, extrusion, metallic<br>Helvetiker Bold font</div></div>", [:position = "top-left"])

oHTML.threeJSAnimate("txt1")
oHTML.save("text_demo1_hello.html")
? "  Created: text_demo1_hello.html"
