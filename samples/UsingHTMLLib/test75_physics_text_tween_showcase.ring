/*
	HTMLLib Demo 75 - Combined - Physics + Text + Tween Showcase
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 75: Combined - Physics + Text + Tween Showcase
# ------------------------------------------------------------------
? "Demo 75: Combined Showcase..."

oHTML = new HTMLWriter
oHTML.setTitle("Physics + Text + Tween Showcase")
oHTML.enableThreeJS()
oHTML.enableOrbitControls()
oHTML.enablePhysics()
oHTML.enableGSAP()
oHTML.enableTextGeometry()
oHTML.addCSSRule("body", [["margin", "0"], ["overflow", "hidden"]])

oHTML.threeJSScene("show", [:fullscreen = true, :bg = "0x0a0a1a", :camZ = "16", :camY = "8"])

# Physics world
oHTML.threeJSPhysicsWorld("show", [:gravityY = "-9.82"])
oHTML.threeJSPhysicsGround("show", [:visible = true, :color = "0x1a1a2e", :size = "40", :restitution = "0.5"])
oHTML.threeJSGridHelper("show", [:size = "40", :divisions = "40", :color1 = "0x333344", :color2 = "0x444455"])

# 3D title text floating above
oHTML.threeJSText3D("show", "showTitle", "RING", [:size = "2", :height = "0.5", :color = "0xff6b6b", :metalness = "0.8", :roughness = "0.1", :emissive = "0xff2222", :emissiveIntensity = "0.15", :font = "helvetiker", :fontStyle = "bold", :y = "8", :center = true])

# Animate title
oHTML.threeJSRaw("
gsap.delayedCall(0.3, function() {
  if(showTitle) {
    gsap.to(showTitle.rotation, {y: Math.PI*2, duration:10, repeat:-1, ease:'none'});
    gsap.to(showTitle.position, {y:9, duration:2, repeat:-1, yoyo:true, ease:'power1.inOut'});
  }
});
")

# Physics objects — colorful boxes that fall
oHTML.threeJSBox("show", "shBox1", [:x = "-3", :y = "5", :color = "0xe74c3c", :w = "1.5", :h = "1.5", :d = "1.5"])
oHTML.threeJSPhysicsBody("show", "shBox1", "box", [:mass = "1", :restitution = "0.4", :sx = "1.5", :sy = "1.5", :sz = "1.5"])

oHTML.threeJSBox("show", "shBox2", [:x = "0", :y = "7", :color = "0x2ecc71", :w = "1.5", :h = "1.5", :d = "1.5"])
oHTML.threeJSPhysicsBody("show", "shBox2", "box", [:mass = "1", :restitution = "0.4", :sx = "1.5", :sy = "1.5", :sz = "1.5"])

oHTML.threeJSBox("show", "shBox3", [:x = "3", :y = "9", :color = "0x3498db", :w = "1.5", :h = "1.5", :d = "1.5"])
oHTML.threeJSPhysicsBody("show", "shBox3", "box", [:mass = "1", :restitution = "0.4", :sx = "1.5", :sy = "1.5", :sz = "1.5"])

# Physics balls
oHTML.threeJSSphere("show", "shBall1", [:x = "-1", :y = "12", :color = "0xf39c12", :radius = "0.7", :segments = "32"])
oHTML.threeJSPhysicsBody("show", "shBall1", "sphere", [:mass = "2", :restitution = "0.7", :radius = "0.7"])

oHTML.threeJSSphere("show", "shBall2", [:x = "1", :y = "14", :color = "0x9b59b6", :radius = "0.7", :segments = "32"])
oHTML.threeJSPhysicsBody("show", "shBall2", "sphere", [:mass = "2", :restitution = "0.7", :radius = "0.7"])

# Ball spawner
oHTML.threeJSPhysicsSpawn("show", "fball", "sphere", "sphere", [], [:mass = "2", :color = "0xffd700", :restitution = "0.6", :radius = "0.5"])

oHTML.threeJSRaw("
document.addEventListener('keydown', function(e) {
  if(e.code === 'Space') {
    spawn_fball((Math.random()-0.5)*6, 12, (Math.random()-0.5)*6, 0, 0, 0);
  }
});
")

# Tweened decorative torus
oHTML.threeJSTorus("show", "shDecor", [:x = "6", :y = "3", :z = "0", :color = "0x6c5ce7", :radius = "1", :tube = "0.25"])
oHTML.threeJSTween("shDecor", "rotation", [["x", "" + string(3.14159*2)], ["y", "" + string(3.14159*2)]], [:duration = "4", :ease = "none", :repeat = "-1"])
oHTML.threeJSTween("shDecor", "position", [["y", "5"]], [:duration = "2", :ease = "power1.inOut", :repeat = "-1", :yoyo = true])

# Lights
oHTML.threeJSAmbientLight("show", [:intensity = "0.3"])
oHTML.threeJSDirectionalLight("show", "shLt", [:x = "5", :y = "12", :z = "8", :intensity = "0.8"])
oHTML.threeJSPointLight("show", "shPtLt", [:x = "0", :y = "10", :z = "0", :intensity = "0.5", :color = "0xff6b6b"])

oHTML.threeJSOrbitControls("show", [:damping = true])

oHTML.threeJSOverlay("show", "<div style='background:rgba(0,0,0,0.7);padding:15px 20px;border-radius:10px'><div style='color:#ff6b6b;font-weight:bold;font-size:1.1rem'>Combined Showcase</div><div style='font-size:0.75rem;color:#aaa;margin-top:8px;line-height:1.8'>Cannon.js Physics<br>GSAP Tweening<br>3D TextGeometry<br><br><span style='color:#fff'>Space</span> &mdash; Spawn balls</div></div>", [:position = "top-left"])

oHTML.threeJSAnimate("show")
oHTML.save("combined_showcase.html")
? "  Created: combined_showcase.html"
