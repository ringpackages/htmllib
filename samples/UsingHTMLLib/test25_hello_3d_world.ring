/*
	HTMLLib Demo 25 - Hello 3D World
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 25: Hello 3D World
# ------------------------------------------------------------------
? "Demo 25: Hello 3D World..."

oHTML = new HTMLWriter
oHTML.setTitle("Hello 3D World")
oHTML.enableThreeJS()

oHTML.addCSSRule("body", [["margin", "0"], ["background", "#1a1a2e"], ["display", "flex"], ["flex-direction", "column"], ["align-items", "center"], ["justify-content", "center"], ["min-height", "100vh"], ["font-family", "Arial, sans-serif"], ["color", "#fff"]])

oHTML.addRawHTML('<h1 style="text-align:center;margin:20px 0 10px;color:#e94560">Hello 3D World</h1>')
oHTML.addRawHTML('<p style="text-align:center;color:#888;margin-bottom:20px">A rotating cube built with Ring + Three.js</p>')

# Create scene
oHTML.threeJSScene("scene1", [:width = "800", :height = "500", :bg = "0x16213e", :camZ = "5", :camY = "2"])

# Add lights
oHTML.threeJSAmbientLight("scene1", [:intensity = "0.3"])
oHTML.threeJSDirectionalLight("scene1", "sun", [:x = "5", :y = "8", :z = "3", :intensity = "1"])

# Add a colorful cube
oHTML.threeJSBox("scene1", "cube", [:w = "2", :h = "2", :d = "2", :color = "0xe94560", :metalness = "0.3", :roughness = "0.4"])

# Auto-rotate it
oHTML.threeJSAutoRotate("scene1", "cube", [:speedX = "0.5", :speedY = "1", :speedZ = "0.3"])

# Start render loop
oHTML.threeJSAnimate("scene1")

oHTML.save("three_demo1_hello.html")
? "  Created: three_demo1_hello.html"
