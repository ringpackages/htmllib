/*
	HTMLLib Demo 74 - 3D Text + Tween - Animated Text
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 74: 3D Text + Tween - Animated Text
# ------------------------------------------------------------------
? "Demo 74: 3D Text + Tween..."

oHTML = new HTMLWriter
oHTML.setTitle("Animated 3D Text")
oHTML.enableThreeJS()
oHTML.enableOrbitControls()
oHTML.enableTextGeometry()
oHTML.enableGSAP()
oHTML.addCSSRule("body", [["margin", "0"], ["overflow", "hidden"]])

oHTML.threeJSScene("txt3", [:fullscreen = true, :bg = "0x0a0a1a", :camZ = "10", :camY = "2"])

# Title text that animates in
oHTML.threeJSText3D("txt3", "animTitle", "HTMLLib", [:size = "1", :height = "0.3", :color = "0xff6b6b", :metalness = "0.7", :roughness = "0.15", :emissive = "0xff2222", :emissiveIntensity = "0.1", :font = "helvetiker", :fontStyle = "bold", :y = "2", :center = true])

oHTML.threeJSText3D("txt3", "animSub", "3D Engine", [:size = "0.5", :height = "0.12", :color = "0x6c5ce7", :metalness = "0.5", :roughness = "0.3", :font = "helvetiker", :y = "0", :center = true])

# Animate: scale from 0 to 1 with elastic bounce
oHTML.threeJSRaw("
gsap.delayedCall(0.5, function() {
  if(animTitle) {
    animTitle.scale.set(0,0,0);
    gsap.to(animTitle.scale, {x:1, y:1, z:1, duration:1.5, ease:'elastic.out(1, 0.4)'});
    gsap.to(animTitle.rotation, {y: Math.PI*2, duration:8, repeat:-1, ease:'none'});
  }
});
gsap.delayedCall(1.5, function() {
  if(animSub) {
    animSub.scale.set(0,0,0);
    gsap.to(animSub.scale, {x:1, y:1, z:1, duration:1.2, ease:'elastic.out(1, 0.4)'});
    gsap.to(animSub.position, {y:0.5, duration:2, repeat:-1, yoyo:true, ease:'power1.inOut'});
  }
});
")

oHTML.threeJSPlane("txt3", "txt3Floor", [:w = "20", :h = "20", :color = "0x1a1a2e", :rx = "-1.5708"])
oHTML.threeJSGridHelper("txt3", [:size = "20", :divisions = "20", :color1 = "0x333344", :color2 = "0x444455"])

oHTML.threeJSAmbientLight("txt3", [:intensity = "0.3"])
oHTML.threeJSDirectionalLight("txt3", "txt3Lt", [:x = "3", :y = "8", :z = "5", :intensity = "0.9"])
oHTML.threeJSPointLight("txt3", "txt3Pt", [:x = "0", :y = "5", :z = "3", :intensity = "0.5", :color = "0xff6b6b"])

oHTML.threeJSOrbitControls("txt3", [:damping = true])

oHTML.threeJSOverlay("txt3", "<div style='background:rgba(0,0,0,0.7);padding:15px 20px;border-radius:10px'><div style='color:#ff6b6b;font-weight:bold;font-size:1.1rem'>Animated 3D Text</div><div style='font-size:0.75rem;color:#aaa;margin-top:8px;line-height:1.6'>TextGeometry + GSAP<br>Elastic scale entrance<br>Continuous rotation + float</div></div>", [:position = "top-left"])

oHTML.threeJSAnimate("txt3")
oHTML.save("text_demo3_animated.html")
? "  Created: text_demo3_animated.html"
