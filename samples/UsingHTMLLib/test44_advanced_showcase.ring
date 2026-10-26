/*
	HTMLLib Demo 44 - Combined Showcase
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 44: Combined Showcase
# ------------------------------------------------------------------
? "Demo 44: Showcase..."

oHTML = new HTMLWriter
oHTML.setTitle("Advanced Features Showcase")
oHTML.enableThreeJS()
oHTML.enableOrbitControls()
oHTML.enablePostProcessing()
oHTML.addCSSRule("body", [["margin", "0"], ["overflow", "hidden"]])

oHTML.threeJSScene("shw", [:fullscreen = true, :bg = "0x050510", :camZ = "10", :camY = "4", :camFov = "55"])

# Enable shadows
oHTML.threeJSEnableShadows("shw", [:type = "pcfsoft"])

# Main light with shadows
oHTML.threeJSDirectionalLight("shw", "mainLight", [:x = "5", :y = "10", :z = "5", :intensity = "0.9"])
oHTML.threeJSShadowConfig("mainLight", [:mapSize = "2048", :far = "30"])
oHTML.threeJSAmbientLight("shw", [:intensity = "0.2"])
oHTML.threeJSPointLight("shw", "accent", [:x = "-3", :y = "4", :z = "-3", :color = "0x6c5ce7", :intensity = "0.4"])

# Ground plane
oHTML.threeJSPlane("shw", "groundS", [:w = "30", :h = "30", :color = "0x1a1a2e", :rx = "-1.5708"])
oHTML.threeJSMeshShadow("groundS", false, true)

# Central emissive torus knot
oHTML.threeJSTorusKnot("shw", "hero", [:y = "2.5", :color = "0x6c5ce7", :radius = "1", :tube = "0.35", :metalness = "0.0", :roughness = "0.0"])
oHTML.threeJSRaw("hero.material.emissive = new THREE.Color(0x6c5ce7); hero.material.emissiveIntensity = 1.5;")
oHTML.threeJSAutoRotate("shw", "hero", [:speedY = "0.4"])
oHTML.threeJSMeshShadow("hero", true, false)

# Clickable orbs
oHTML.threeJSSphere("shw", "orb1", [:x = "-3", :y = "1", :color = "0xff6b6b", :radius = "0.5", :segments = "32"])
oHTML.threeJSMeshShadow("orb1", true, true)
oHTML.threeJSSphere("shw", "orb2", [:x = "3", :y = "1", :color = "0x00cec9", :radius = "0.5", :segments = "32"])
oHTML.threeJSMeshShadow("orb2", true, true)
oHTML.threeJSSphere("shw", "orb3", [:x = "0", :y = "1", :z = "-3", :color = "0xffd900", :radius = "0.5", :segments = "32"])
oHTML.threeJSMeshShadow("orb3", true, true)

oHTML.threeJSBob("shw", "orb1", [:speed = "1.2", :height = "0.3", :baseY = "1"])
oHTML.threeJSBob("shw", "orb2", [:speed = "1.5", :height = "0.3", :baseY = "1"])
oHTML.threeJSBob("shw", "orb3", [:speed = "1.8", :height = "0.3", :baseY = "1"])

# Labels
oHTML.threeJSTextSprite("shw", "heroLbl", "Bloom Glow", [:x = "0", :y = "4.5", :fontSize = "36", :color = "#6c5ce7", :bgColor = "rgba(0,0,0,0.6)", :scale = "1"])
oHTML.threeJSTextSprite("shw", "orbLbl1", "Click Me", [:x = "-3", :y = "2.2", :fontSize = "28", :color = "#ff6b6b", :bgColor = "rgba(0,0,0,0.6)", :scale = "0.8"])
oHTML.threeJSTextSprite("shw", "orbLbl2", "Click Me", [:x = "3", :y = "2.2", :fontSize = "28", :color = "#00cec9", :bgColor = "rgba(0,0,0,0.6)", :scale = "0.8"])

# 3D curve decoration
oHTML.threeJSCurve("shw", "arc", [
	["-5", "0.1", "5"], ["-2", "3", "3"], ["2", "3", "3"], ["5", "0.1", "5"]
], [:color = "0x6c5ce7", :tube = true, :tubeRadius = "0.03", :segments = "64"])

# Raycasting on orbs
oHTML.threeJSRaycast("shw", ["orb1", "orb2", "orb3"],
	"hit.object.material.color.set(Math.random() * 0xffffff); hit.object.material.emissive = new THREE.Color(hit.object.material.color.getHex()); hit.object.material.emissiveIntensity = 1.0;",
	[:event = "click"])

# Hover
oHTML.threeJSHover("shw", ["orb1", "orb2", "orb3"],
	"hit.object.scale.set(1.3, 1.3, 1.3); document.body.style.cursor='pointer';",
	"hit.object.scale.set(1, 1, 1); document.body.style.cursor='default';",
	[])

# Orbit controls
oHTML.threeJSOrbitControls("shw", [:damping = true, :maxPolarAngle = "1.4"])

# Particles
oHTML.threeJSParticles("shw", "dust", [:count = "800", :spread = "30", :size = "0.04", :color = "0x6c5ce7", :opacity = "0.3"])

# Post-processing: Bloom + FXAA
oHTML.threeJSPostProcessing("shw")
oHTML.threeJSBloom("shw", [:strength = "1.0", :radius = "0.4", :threshold = "0.3"])
oHTML.threeJSFXAA("shw")

oHTML.threeJSOverlay("shw", "<div style='background:rgba(0,0,0,0.7);padding:15px 20px;border-radius:10px'><div style='color:#6c5ce7;font-weight:bold;font-size:1.1rem'>Advanced Showcase</div><div style='font-size:0.7rem;color:#aaa;margin-top:8px;line-height:1.8'>Shadows + Bloom + FXAA<br>Raycasting + Hover effects<br>Text sprites + 3D curves<br>OrbitControls + Particles</div></div>", [:position = "top-left"])

oHTML.threeJSPostProcessAnimate("shw")
oHTML.save("adv_demo12_showcase.html")
? "  Created: adv_demo12_showcase.html"
