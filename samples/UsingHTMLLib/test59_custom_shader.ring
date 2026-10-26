/*
	HTMLLib Demo 59 - Custom Shader
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 59: Custom Shader
# ------------------------------------------------------------------
? "Demo 59: Custom Shader..."

oHTML = new HTMLWriter
oHTML.setTitle("Custom Shader")
oHTML.enableThreeJS()
oHTML.addCSSRule("body", [["margin", "0"], ["background", "#0a0a1a"], ["overflow", "hidden"]])

oHTML.threeJSScene("d10", [:fullscreen = true, :bg = "0x0a0a1a", :camZ = "3.5"])

# Custom vertex + fragment shader: plasma effect
cVS = "varying vec2 vUv;" + char(10)
cVS += "void main() {" + char(10)
cVS += "  vUv = uv;" + char(10)
cVS += "  gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);" + char(10)
cVS += "}"

cFS = "uniform float uTime;" + char(10)
cFS += "uniform vec2 uMouse;" + char(10)
cFS += "uniform float uScale;" + char(10)
cFS += "varying vec2 vUv;" + char(10)
cFS += "void main() {" + char(10)
cFS += "  vec2 p = vUv * uScale;" + char(10)
cFS += "  float t = uTime;" + char(10)
cFS += "  float v1 = sin(p.x + t);" + char(10)
cFS += "  float v2 = sin(p.y + t);" + char(10)
cFS += "  float v3 = sin(p.x + p.y + t);" + char(10)
cFS += "  float v4 = sin(sqrt(p.x*p.x + p.y*p.y) + t);" + char(10)
cFS += "  float v = (v1 + v2 + v3 + v4) * 0.25;" + char(10)
cFS += "  vec3 col;" + char(10)
cFS += "  col.r = sin(v * 3.14159 + uMouse.x * 6.28) * 0.5 + 0.5;" + char(10)
cFS += "  col.g = sin(v * 3.14159 + 2.094 + uMouse.y * 6.28) * 0.5 + 0.5;" + char(10)
cFS += "  col.b = sin(v * 3.14159 + 4.189) * 0.5 + 0.5;" + char(10)
cFS += "  gl_FragColor = vec4(col, 1.0);" + char(10)
cFS += "}"

oHTML.threeJSShaderMaterial("d10", "plasma", "sphere", "1.5, 64, 64",
	cVS, cFS, [["uScale", "float", "8.0"]], [])

oHTML.threeJSShaderMouse("d10", "plasma")
oHTML.threeJSAutoRotate("d10", "plasma", [:speedY = "0.2"])

oHTML.threeJSParticles("d10", "bg10", [:count = "1000", :spread = "30", :size = "0.03", :color = "0xffffff", :opacity = "0.3"])

oHTML.threeJSMouseLook("d10", [])
oHTML.threeJSOverlay("d10", "<div style='background:rgba(0,0,0,0.7);padding:12px 18px;border-radius:8px'><div style='color:#ff6b6b;font-weight:bold'>Custom Plasma Shader</div><div style='font-size:0.7rem;color:#666;margin-top:5px'>Write your own GLSL from Ring<br>Mouse position affects colors</div></div>", [:position = "top-left"])

oHTML.threeJSAnimate("d10")
oHTML.save("shader_demo10_custom.html")
? "  Created: shader_demo10_custom.html"
