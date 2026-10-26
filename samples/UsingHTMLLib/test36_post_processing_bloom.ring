/*
	HTMLLib Demo 36 - Post-Processing — Bloom
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 36: Post-Processing — Bloom
# ------------------------------------------------------------------
? "Demo 36: Post-Processing Bloom..."

oHTML = new HTMLWriter
oHTML.setTitle("Bloom Effect")
oHTML.enableThreeJS()
oHTML.enableOrbitControls()
oHTML.enablePostProcessing()
oHTML.addCSSRule("body", [["margin", "0"], ["overflow", "hidden"]])

oHTML.threeJSScene("blm", [:fullscreen = true, :bg = "0x000000", :camZ = "6", :camY = "2"])

# Emissive neon objects
oHTML.threeJSTorusKnot("blm", "neon1", [:color = "0x6c5ce7", :radius = "1", :tube = "0.3", :metalness = "0.0", :roughness = "0.0", :y = "1.5"])
oHTML.threeJSRaw("neon1.material.emissive = new THREE.Color(0x6c5ce7); neon1.material.emissiveIntensity = 2.0;")
oHTML.threeJSAutoRotate("blm", "neon1", [:speedY = "0.5"])

oHTML.threeJSSphere("blm", "neon2", [:x = "-3", :y = "1", :color = "0xff006e", :radius = "0.6", :segments = "32"])
oHTML.threeJSRaw("neon2.material.emissive = new THREE.Color(0xff006e); neon2.material.emissiveIntensity = 2.0;")

oHTML.threeJSSphere("blm", "neon3", [:x = "3", :y = "1", :color = "0x00cec9", :radius = "0.6", :segments = "32"])
oHTML.threeJSRaw("neon3.material.emissive = new THREE.Color(0x00cec9); neon3.material.emissiveIntensity = 2.0;")

# Dark floor
oHTML.threeJSPlane("blm", "darkFloor", [:w = "30", :h = "30", :color = "0x080808", :rx = "-1.5708"])

oHTML.threeJSAmbientLight("blm", [:intensity = "0.1"])

oHTML.threeJSOrbitControls("blm", [:damping = true])

# Post-processing pipeline
oHTML.threeJSPostProcessing("blm")
oHTML.threeJSBloom("blm", [:strength = "1.5", :radius = "0.5", :threshold = "0.2"])
oHTML.threeJSFXAA("blm")

oHTML.threeJSOverlay("blm", "<div style='background:rgba(0,0,0,0.7);padding:12px 18px;border-radius:10px'><div style='color:#6c5ce7;font-weight:bold'>Bloom Post-Processing</div><div style='font-size:0.7rem;color:#aaa;margin-top:5px'>Unreal Bloom + FXAA</div></div>", [:position = "top-left"])

oHTML.threeJSPostProcessAnimate("blm")
oHTML.save("adv_demo4_bloom.html")
? "  Created: adv_demo4_bloom.html"
