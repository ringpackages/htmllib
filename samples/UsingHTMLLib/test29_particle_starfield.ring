/*
	HTMLLib Demo 29 - Particle Starfield
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 29: Particle Starfield
# ------------------------------------------------------------------
? "Demo 29: Particle Starfield..."

oHTML = new HTMLWriter
oHTML.setTitle("Starfield")
oHTML.enableThreeJS()

oHTML.addCSSRule("body", [["margin", "0"], ["overflow", "hidden"], ["background", "#000"]])

oHTML.threeJSScene("stars", [:fullscreen = true, :bg = "0x000000", :camZ = "5", :camY = "0"])

# Multiple particle layers for depth
oHTML.threeJSParticles("stars", "starsNear", [:count = "500", :spread = "30", :size = "0.08", :color = "0xffffff"])
oHTML.threeJSParticles("stars", "starsMid", [:count = "1500", :spread = "60", :size = "0.05", :color = "0xaabbff"])
oHTML.threeJSParticles("stars", "starsFar", [:count = "3000", :spread = "120", :size = "0.03", :color = "0x8899cc"])

# Colored nebula particles
oHTML.threeJSParticles("stars", "nebula1", [:count = "300", :spread = "40", :size = "0.3", :color = "0x6c5ce7", :opacity = "0.3"])
oHTML.threeJSParticles("stars", "nebula2", [:count = "200", :spread = "35", :size = "0.25", :color = "0xe94560", :opacity = "0.2"])

# Central glowing object
oHTML.threeJSSphere("stars", "core", [:radius = "0.5", :color = "0xffffff", :material = "basic"])
oHTML.threeJSSphere("stars", "glow", [:radius = "0.8", :color = "0x6c5ce7", :material = "basic", :transparent = true, :opacity = "0.3"])

# Animate
oHTML.threeJSAutoRotate("stars", "starsNear", [:speedY = "0.05", :speedX = "0.02"])
oHTML.threeJSAutoRotate("stars", "starsMid", [:speedY = "0.03", :speedZ = "0.01"])
oHTML.threeJSAutoRotate("stars", "starsFar", [:speedY = "0.01"])
oHTML.threeJSAutoRotate("stars", "nebula1", [:speedY = "0.08", :speedX = "0.03"])
oHTML.threeJSAutoRotate("stars", "nebula2", [:speedY = "-0.06", :speedZ = "0.04"])
oHTML.threeJSPulse("stars", "glow", [:speed = "1", :min = "0.8", :max = "1.5"])
oHTML.threeJSAutoRotate("stars", "core", [:speedY = "1"])

oHTML.threeJSMouseLook("stars", [:sensitivity = "0.003"])

# HUD
oHTML.threeJSOverlay("stars", "<div style='font-size:1.5rem;font-weight:bold'>Starfield</div><div style='font-size:0.8rem;opacity:0.6;margin-top:5px'>5,500 particles &bull; Drag to explore</div>", [:position = "top-left"])

oHTML.threeJSAnimate("stars")

oHTML.save("three_demo5_particles.html")
? "  Created: three_demo5_particles.html"
