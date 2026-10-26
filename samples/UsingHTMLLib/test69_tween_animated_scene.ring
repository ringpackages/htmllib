/*
	HTMLLib Demo 69 - Tween - Animated Scene
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 69: Tween - Animated Scene
# ------------------------------------------------------------------
? "Demo 69: Tween - Animated Scene..."

oHTML = new HTMLWriter
oHTML.setTitle("GSAP Tween Animation")
oHTML.enableThreeJS()
oHTML.enableOrbitControls()
oHTML.enableGSAP()
oHTML.addCSSRule("body", [["margin", "0"], ["overflow", "hidden"]])

oHTML.threeJSScene("tw1", [:fullscreen = true, :bg = "0x0a0a1a", :camZ = "10", :camY = "4"])

# Objects
oHTML.threeJSBox("tw1", "twBox", [:x = "-4", :y = "1", :color = "0xe74c3c", :w = "1.5", :h = "1.5", :d = "1.5"])
oHTML.threeJSSphere("tw1", "twSph", [:x = "0", :y = "1", :color = "0x2ecc71", :radius = "0.8", :segments = "32"])
oHTML.threeJSTorus("tw1", "twTor", [:x = "4", :y = "1.5", :color = "0x3498db", :radius = "1", :tube = "0.3"])

oHTML.threeJSPlane("tw1", "twFloor", [:w = "20", :h = "20", :color = "0x2c3e50", :rx = "-1.5708"])
oHTML.threeJSGridHelper("tw1", [:size = "20", :divisions = "20", :color1 = "0x333344", :color2 = "0x444455"])

# Tween: box bounces up and down
oHTML.threeJSTween("twBox", "position", [["y", "4"]], [:duration = "1.5", :ease = "bounce.out", :repeat = "-1", :yoyo = true])

# Tween: sphere rotates and changes color
oHTML.threeJSTween("twSph", "rotation", [["y", "" + string(3.14159*4)]], [:duration = "4", :ease = "none", :repeat = "-1"])
oHTML.threeJSTweenColor("twSph", "0x9b59b6", [:duration = "2"])
oHTML.threeJSDelayedCall("2", "gsap.to(twSph.material.color, {r:0.2, g:0.8, b:0.4, duration:2});")

# Tween: torus orbit-like motion
oHTML.threeJSTween("twTor", "position", [["y", "3.5"]], [:duration = "2", :ease = "power1.inOut", :repeat = "-1", :yoyo = true])
oHTML.threeJSTween("twTor", "rotation", [["x", "" + string(3.14159*2)], ["z", "" + string(3.14159*2)]], [:duration = "3", :ease = "none", :repeat = "-1"])

# Tween: scale pulse on box
oHTML.threeJSTween("twBox", "scale", [["x", "1.3"], ["y", "1.3"], ["z", "1.3"]], [:duration = "0.8", :ease = "elastic.out(1, 0.3)", :repeat = "-1", :yoyo = true])

oHTML.threeJSAmbientLight("tw1", [:intensity = "0.4"])
oHTML.threeJSDirectionalLight("tw1", "twLt", [:x = "5", :y = "8", :z = "5", :intensity = "0.7"])

oHTML.threeJSOrbitControls("tw1", [:damping = true])

oHTML.threeJSOverlay("tw1", "<div style='background:rgba(0,0,0,0.7);padding:15px 20px;border-radius:10px'><div style='color:#e74c3c;font-weight:bold;font-size:1.1rem'>GSAP Tweening</div><div style='font-size:0.75rem;color:#aaa;margin-top:8px;line-height:1.8'><span style='color:#e74c3c'>Box</span> &mdash; bounce + elastic scale<br><span style='color:#2ecc71'>Sphere</span> &mdash; spin + color shift<br><span style='color:#3498db'>Torus</span> &mdash; float + tumble<br><br>Easing: bounce, elastic, power1</div></div>", [:position = "top-left"])

oHTML.threeJSAnimate("tw1")
oHTML.save("tween_demo1_scene.html")
? "  Created: tween_demo1_scene.html"
