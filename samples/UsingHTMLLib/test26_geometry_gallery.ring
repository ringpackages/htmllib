/*
	HTMLLib Demo 26 - Geometry Gallery
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 26: Geometry Gallery
# ------------------------------------------------------------------
? "Demo 26: Geometry Gallery..."

oHTML = new HTMLWriter
oHTML.setTitle("3D Geometry Gallery")
oHTML.enableThreeJS()

oHTML.addCSSRule("body", [["margin", "0"], ["background", "#0a0a0a"], ["display", "flex"], ["flex-direction", "column"], ["align-items", "center"], ["min-height", "100vh"], ["font-family", "Arial, sans-serif"], ["color", "#fff"]])

oHTML.addRawHTML('<h1 style="text-align:center;margin:20px 0 5px;color:#00b894">3D Geometry Gallery</h1>')
oHTML.addRawHTML('<p style="text-align:center;color:#666;margin-bottom:15px">All 10 built-in Three.js shapes &mdash; drag to rotate</p>')

oHTML.threeJSScene("gallery", [:width = "900", :height = "550", :bg = "0x111111", :camY = "4", :camZ = "14", :camFov = "60"])

# Lights
oHTML.threeJSAmbientLight("gallery", [:intensity = "0.4"])
oHTML.threeJSDirectionalLight("gallery", "mainLight", [:x = "8", :y = "12", :z = "8", :intensity = "0.8"])
oHTML.threeJSPointLight("gallery", "fillLight", [:x = "-5", :y = "5", :z = "5", :color = "0x6c5ce7", :intensity = "0.5"])

# Grid
oHTML.threeJSGridHelper("gallery", [:size = "30", :divisions = "30", :color1 = "0x222222", :color2 = "0x333333"])

# Row 1: Box, Sphere, Cylinder, Cone, Torus (z = 3)
oHTML.threeJSBox("gallery", "gBox", [:w = "1.4", :h = "1.4", :d = "1.4", :color = "0xe74c3c", :x = "-8", :y = "1", :z = "3", :metalness = "0.5", :roughness = "0.3"])
oHTML.threeJSSphere("gallery", "gSphere", [:radius = "0.9", :color = "0x3498db", :x = "-4", :y = "1", :z = "3", :metalness = "0.6", :roughness = "0.2"])
oHTML.threeJSCylinder("gallery", "gCylinder", [:radiusTop = "0.7", :radiusBottom = "0.7", :height = "1.6", :color = "0x2ecc71", :x = "0", :y = "1", :z = "3", :metalness = "0.4", :roughness = "0.4"])
oHTML.threeJSCone("gallery", "gCone", [:radius = "0.9", :height = "1.8", :color = "0xf39c12", :x = "4", :y = "1", :z = "3", :metalness = "0.3", :roughness = "0.5"])
oHTML.threeJSTorus("gallery", "gTorus", [:radius = "0.8", :tube = "0.3", :color = "0x9b59b6", :x = "8", :y = "1", :z = "3", :metalness = "0.7", :roughness = "0.1"])

# Row 2: TorusKnot, Ring, Dodecahedron, Icosahedron, Octahedron (z = -3)
oHTML.threeJSTorusKnot("gallery", "gKnot", [:radius = "0.7", :tube = "0.2", :color = "0xe91e63", :x = "-8", :y = "1", :z = "-3", :metalness = "0.6", :roughness = "0.2"])
oHTML.threeJSRing("gallery", "gRingShape", [:innerRadius = "0.4", :outerRadius = "0.9", :color = "0x00bcd4", :x = "-4", :y = "1", :z = "-3", :side = "double"])
oHTML.threeJSDodecahedron("gallery", "gDodeca", [:radius = "0.9", :color = "0xff6f00", :x = "0", :y = "1", :z = "-3", :metalness = "0.5", :roughness = "0.3"])
oHTML.threeJSIcosahedron("gallery", "gIcosa", [:radius = "0.9", :color = "0x7c4dff", :x = "4", :y = "1", :z = "-3", :metalness = "0.4", :roughness = "0.3"])
oHTML.threeJSOctahedron("gallery", "gOcta", [:radius = "0.9", :color = "0x00e676", :x = "8", :y = "1", :z = "-3", :metalness = "0.5", :roughness = "0.2"])

# Rotate all shapes
aShapes = ["gBox", "gSphere", "gCylinder", "gCone", "gTorus", "gKnot", "gRingShape", "gDodeca", "gIcosa", "gOcta"]
for nIndex = 1 to len(aShapes)
	oHTML.threeJSAutoRotate("gallery", aShapes[nIndex], [:speedY = "0.8", :speedX = "0.3"])
next

# Mouse orbit
oHTML.threeJSMouseLook("gallery", [])

oHTML.threeJSAnimate("gallery")

oHTML.save("three_demo2_gallery.html")
? "  Created: three_demo2_gallery.html"
