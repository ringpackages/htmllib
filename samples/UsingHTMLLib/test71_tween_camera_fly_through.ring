/*
	HTMLLib Demo 71 - Tween - Camera Fly-Through
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 71: Tween - Camera Fly-Through
# ------------------------------------------------------------------
? "Demo 71: Tween - Camera Fly-Through..."

oHTML = new HTMLWriter
oHTML.setTitle("Camera Fly-Through")
oHTML.enableThreeJS()
oHTML.enableOrbitControls()
oHTML.enableGSAP()
oHTML.addCSSRule("body", [["margin", "0"], ["overflow", "hidden"]])

oHTML.threeJSScene("tw3", [:fullscreen = true, :bg = "0x0a0a1a", :camZ = "15", :camY = "8"])

# Scattered objects to fly through
oHTML.threeJSBox("tw3", "ftBox1", [:x = "-5", :y = "1", :z = "-5", :color = "0xe74c3c", :w = "2", :h = "3", :d = "2"])
oHTML.threeJSSphere("tw3", "ftSph1", [:x = "4", :y = "2", :z = "-3", :color = "0x2ecc71", :radius = "1.2", :segments = "32"])
oHTML.threeJSCylinder("tw3", "ftCyl1", [:x = "0", :y = "2", :z = "-8", :color = "0x3498db", :radiusTop = "0.5", :radiusBottom = "1", :height = "4"])
oHTML.threeJSTorus("tw3", "ftTor1", [:x = "-3", :y = "2", :z = "4", :color = "0xf39c12", :radius = "1.5", :tube = "0.4"])
oHTML.threeJSTorusKnot("tw3", "ftKnot1", [:x = "5", :y = "2.5", :z = "5", :color = "0x9b59b6", :radius = "1", :tube = "0.3"])

oHTML.threeJSPlane("tw3", "tw3Floor", [:w = "30", :h = "30", :color = "0x2c3e50", :rx = "-1.5708"])
oHTML.threeJSGridHelper("tw3", [:size = "30", :divisions = "30", :color1 = "0x333344", :color2 = "0x444455"])

# Camera fly-through sequence
oHTML.threeJSDelayedCall("1", "
  gsap.to(camera_tw3.position, {x:-5, y:3, z:-3, duration:3, ease:'power2.inOut'});
")
oHTML.threeJSDelayedCall("4.5", "
  gsap.to(camera_tw3.position, {x:4, y:2, z:0, duration:3, ease:'power2.inOut'});
")
oHTML.threeJSDelayedCall("8", "
  gsap.to(camera_tw3.position, {x:0, y:10, z:2, duration:3, ease:'power2.inOut'});
")
oHTML.threeJSDelayedCall("11.5", "
  gsap.to(camera_tw3.position, {x:5, y:3, z:8, duration:3, ease:'power2.inOut'});
")
oHTML.threeJSDelayedCall("15", "
  gsap.to(camera_tw3.position, {x:0, y:8, z:15, duration:3, ease:'power2.inOut'});
")

# Gentle rotations on objects
oHTML.threeJSTween("ftTor1", "rotation", [["x", "" + string(3.14159*2)], ["y", "" + string(3.14159*2)]], [:duration = "6", :ease = "none", :repeat = "-1"])
oHTML.threeJSTween("ftKnot1", "rotation", [["y", "" + string(3.14159*2)]], [:duration = "4", :ease = "none", :repeat = "-1"])

oHTML.threeJSAmbientLight("tw3", [:intensity = "0.4"])
oHTML.threeJSDirectionalLight("tw3", "tw3Lt", [:x = "5", :y = "10", :z = "5", :intensity = "0.7"])

oHTML.threeJSOrbitControls("tw3", [:damping = true])

oHTML.threeJSOverlay("tw3", "<div style='background:rgba(0,0,0,0.7);padding:15px 20px;border-radius:10px'><div style='color:#f39c12;font-weight:bold;font-size:1.1rem'>Camera Fly-Through</div><div style='font-size:0.75rem;color:#aaa;margin-top:8px;line-height:1.6'>Automated camera tour<br>GSAP + delayedCall sequencing<br>power2.inOut easing</div></div>", [:position = "top-left"])

oHTML.threeJSAnimate("tw3")
oHTML.save("tween_demo3_camera.html")
? "  Created: tween_demo3_camera.html"
