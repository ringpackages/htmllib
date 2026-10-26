/*
	HTMLLib Demo 70 - Tween - Timeline Sequence
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 70: Tween - Timeline Sequence
# ------------------------------------------------------------------
? "Demo 70: Tween - Timeline..."

oHTML = new HTMLWriter
oHTML.setTitle("GSAP Timeline")
oHTML.enableThreeJS()
oHTML.enableOrbitControls()
oHTML.enableGSAP()
oHTML.addCSSRule("body", [["margin", "0"], ["overflow", "hidden"]])

oHTML.threeJSScene("tw2", [:fullscreen = true, :bg = "0x0a0a1a", :camZ = "10", :camY = "4"])

oHTML.threeJSBox("tw2", "tlBox", [:x = "-5", :y = "1", :color = "0xe74c3c", :w = "1.5", :h = "1.5", :d = "1.5"])

oHTML.threeJSPlane("tw2", "tw2Floor", [:w = "20", :h = "20", :color = "0x2c3e50", :rx = "-1.5708"])
oHTML.threeJSGridHelper("tw2", [:size = "20", :divisions = "20", :color1 = "0x333344", :color2 = "0x444455"])

# Timeline: box moves in a square path
oHTML.threeJSTimeline("boxPath", [:repeat = "-1", :yoyo = false])
oHTML.threeJSTimelineAdd("boxPath", "tlBox", "position", [["x", "5"]], [:duration = "1.5", :ease = "power2.inOut"])
oHTML.threeJSTimelineAdd("boxPath", "tlBox", "position", [["y", "5"]], [:duration = "1", :ease = "power2.inOut"])
oHTML.threeJSTimelineAdd("boxPath", "tlBox", "position", [["x", "-5"]], [:duration = "1.5", :ease = "power2.inOut"])
oHTML.threeJSTimelineAdd("boxPath", "tlBox", "position", [["y", "1"]], [:duration = "1", :ease = "power2.inOut"])

# Rotate while moving
oHTML.threeJSTween("tlBox", "rotation", [["y", "" + string(3.14159*8)]], [:duration = "5", :ease = "none", :repeat = "-1"])

oHTML.threeJSAmbientLight("tw2", [:intensity = "0.4"])
oHTML.threeJSDirectionalLight("tw2", "tw2Lt", [:x = "5", :y = "8", :z = "5", :intensity = "0.7"])

oHTML.threeJSOrbitControls("tw2", [:damping = true])

oHTML.threeJSOverlay("tw2", "<div style='background:rgba(0,0,0,0.7);padding:15px 20px;border-radius:10px'><div style='color:#e74c3c;font-weight:bold;font-size:1.1rem'>GSAP Timeline</div><div style='font-size:0.75rem;color:#aaa;margin-top:8px;line-height:1.6'>Sequenced animation steps<br>Box follows a square path<br>power2.inOut easing</div></div>", [:position = "top-left"])

oHTML.threeJSAnimate("tw2")
oHTML.save("tween_demo2_timeline.html")
? "  Created: tween_demo2_timeline.html"
