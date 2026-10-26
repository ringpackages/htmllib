/*
	HTMLLib Demo 42 - Mirror / Reflective Floor
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 42: Mirror / Reflective Floor
# ------------------------------------------------------------------
? "Demo 42: Mirror Floor..."

oHTML = new HTMLWriter
oHTML.setTitle("Mirror Reflections")
oHTML.enableThreeJS()
oHTML.enableOrbitControls()
oHTML.enableReflector()
oHTML.addCSSRule("body", [["margin", "0"], ["overflow", "hidden"]])

oHTML.threeJSScene("mir", [:fullscreen = true, :bg = "0x0a0a2e", :camZ = "7", :camY = "3"])

# Objects above mirror
oHTML.threeJSTorusKnot("mir", "mKnot", [:y = "2", :color = "0x6c5ce7", :radius = "0.8", :tube = "0.3", :metalness = "0.9", :roughness = "0.1"])
oHTML.threeJSAutoRotate("mir", "mKnot", [:speedY = "0.4"])

oHTML.threeJSSphere("mir", "mSph", [:x = "-2.5", :y = "1.2", :color = "0xff6b6b", :radius = "0.6", :segments = "32", :metalness = "0.8", :roughness = "0.15"])
oHTML.threeJSSphere("mir", "mSph2", [:x = "2.5", :y = "1.2", :color = "0x00cec9", :radius = "0.6", :segments = "32", :metalness = "0.8", :roughness = "0.15"])

oHTML.threeJSBob("mir", "mSph", [:speed = "1.2", :height = "0.3", :baseY = "1.2"])
oHTML.threeJSBob("mir", "mSph2", [:speed = "1.5", :height = "0.3", :baseY = "1.2"])

# Mirror floor
oHTML.threeJSMirror("mir", "mirror", [:w = "20", :h = "20", :color = "0x555577", :textureWidth = "1024", :textureHeight = "1024"])

oHTML.threeJSAmbientLight("mir", [:intensity = "0.3"])
oHTML.threeJSPointLight("mir", "mLight1", [:x = "3", :y = "6", :z = "3", :intensity = "0.8"])
oHTML.threeJSPointLight("mir", "mLight2", [:x = "-3", :y = "4", :z = "-3", :intensity = "0.4", :color = "0x6c5ce7"])

oHTML.threeJSOrbitControls("mir", [:damping = true, :maxPolarAngle = "1.4"])

oHTML.threeJSOverlay("mir", "<div style='background:rgba(0,0,0,0.7);padding:12px 18px;border-radius:10px'><div style='color:#6c5ce7;font-weight:bold'>Mirror Floor</div><div style='font-size:0.7rem;color:#aaa;margin-top:5px'>Real-time planar reflections<br>THREE.Reflector</div></div>", [:position = "top-left"])

oHTML.threeJSAnimate("mir")
oHTML.save("adv_demo10_mirror.html")
? "  Created: adv_demo10_mirror.html"
