/*
	HTMLLib Demo 28 - Materials Lab
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 28: Materials Lab
# ------------------------------------------------------------------
? "Demo 28: Materials Lab..."

oHTML = new HTMLWriter
oHTML.setTitle("Materials Lab")
oHTML.enableThreeJS()

oHTML.addCSSRule("body", [["margin", "0"], ["background", "#1a1a2e"], ["display", "flex"], ["flex-direction", "column"], ["align-items", "center"], ["min-height", "100vh"], ["font-family", "monospace"], ["color", "#fff"]])

oHTML.addRawHTML('<h1 style="text-align:center;margin:20px 0 5px;color:#6c5ce7">Materials Lab</h1>')
oHTML.addRawHTML('<p style="text-align:center;color:#666;margin-bottom:15px">Exploring different Three.js material types</p>')

oHTML.threeJSScene("matlab", [:width = "900", :height = "500", :bg = "0x16213e", :camY = "3", :camZ = "10", :camFov = "50"])

# Rich lighting for material showcase
oHTML.threeJSAmbientLight("matlab", [:intensity = "0.3"])
oHTML.threeJSDirectionalLight("matlab", "keyLight", [:x = "5", :y = "8", :z = "5", :intensity = "1"])
oHTML.threeJSPointLight("matlab", "rimLight", [:x = "-5", :y = "3", :z = "-3", :color = "0xff6b6b", :intensity = "0.6"])

# Floor
oHTML.threeJSPlane("matlab", "floor", [:w = "20", :h = "20", :color = "0x222233", :y = "-1", :rx = "-1.5708", :receiveShadow = true])

# Row of spheres with different materials
# Standard (PBR) - high metalness
oHTML.threeJSSphere("matlab", "mStandard", [:radius = "0.8", :color = "0xe74c3c", :x = "-6", :y = "0.5", :material = "standard", :metalness = "0.9", :roughness = "0.1"])

# Standard (PBR) - rough matte
oHTML.threeJSSphere("matlab", "mRough", [:radius = "0.8", :color = "0x3498db", :x = "-3", :y = "0.5", :material = "standard", :metalness = "0.1", :roughness = "0.9"])

# Phong (shiny reflections)
oHTML.threeJSSphere("matlab", "mPhong", [:radius = "0.8", :color = "0x2ecc71", :x = "0", :y = "0.5", :material = "phong"])

# Lambert (soft diffuse)
oHTML.threeJSSphere("matlab", "mLambert", [:radius = "0.8", :color = "0xf39c12", :x = "3", :y = "0.5", :material = "lambert"])

# Normal (debug visualization)
oHTML.threeJSSphere("matlab", "mNormal", [:radius = "0.8", :x = "6", :y = "0.5", :material = "normal"])

# Wireframe objects
oHTML.threeJSTorusKnot("matlab", "wfKnot", [:radius = "0.7", :tube = "0.2", :color = "0xe94560", :x = "-4", :y = "3.5", :wireframe = true, :material = "basic"])
oHTML.threeJSIcosahedron("matlab", "wfIcosa", [:radius = "0.8", :color = "0x00e5ff", :x = "0", :y = "3.5", :wireframe = true, :material = "basic"])
oHTML.threeJSDodecahedron("matlab", "wfDodeca", [:radius = "0.8", :color = "0x76ff03", :x = "4", :y = "3.5", :wireframe = true, :material = "basic"])

# Transparent + emissive
oHTML.threeJSSphere("matlab", "mTransp", [:radius = "1.2", :color = "0x6c5ce7", :x = "-2", :y = "1", :z = "-4", :transparent = true, :opacity = "0.4", :emissive = "0x6c5ce7", :emissiveIntensity = "0.3"])
oHTML.threeJSSphere("matlab", "mGlow", [:radius = "0.6", :color = "0xff0066", :x = "2", :y = "1", :z = "-4", :emissive = "0xff0066", :emissiveIntensity = "0.8"])

# Rotate wireframes
oHTML.threeJSAutoRotate("matlab", "wfKnot", [:speedX = "0.5", :speedY = "1"])
oHTML.threeJSAutoRotate("matlab", "wfIcosa", [:speedY = "0.8", :speedZ = "0.4"])
oHTML.threeJSAutoRotate("matlab", "wfDodeca", [:speedX = "0.3", :speedY = "0.7"])
oHTML.threeJSAutoRotate("matlab", "mGlow", [:speedY = "1.5"])
oHTML.threeJSPulse("matlab", "mTransp", [:speed = "1.5", :min = "0.9", :max = "1.3"])

oHTML.threeJSMouseLook("matlab", [])
oHTML.threeJSAnimate("matlab")

oHTML.save("three_demo4_materials.html")
? "  Created: three_demo4_materials.html"
