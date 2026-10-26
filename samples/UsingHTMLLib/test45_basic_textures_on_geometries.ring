/*
	HTMLLib Demo 45 - Basic Textures on Geometries
*/

load "htmllib.ring"

# Free texture URLs (public domain images)
cTexBrick = "https://images.unsplash.com/photo-1528460033278-a6ba57a8e179?w=512&h=512&fit=crop"
cTexWood  = "https://images.unsplash.com/photo-1558618666-fcd25c85f82e?w=512&h=512&fit=crop"
cTexStone = "https://images.unsplash.com/photo-1520178606-adba40f700db?w=512&h=512&fit=crop"
cTexEarth = "https://upload.wikimedia.org/wikipedia/commons/thumb/2/23/Blue_Marble_2002.png/512px-Blue_Marble_2002.png"

# ------------------------------------------------------------------
# Demo 45: Basic Textures on Geometries
# ------------------------------------------------------------------
? "Demo 45: Basic Textures..."

oHTML = new HTMLWriter
oHTML.setTitle("Texture Mapping - Basic")
oHTML.enableThreeJS()
oHTML.enableOrbitControls()
oHTML.addCSSRule("body", [["margin", "0"], ["overflow", "hidden"]])

oHTML.threeJSScene("tex1", [:fullscreen = true, :bg = "0x111122", :camZ = "10", :camY = "4"])

# Box with brick texture
oHTML.threeJSBox("tex1", "brickBox", [
	:x = "-3", :y = "1.2", :w = "2", :h = "2", :d = "2",
	:texture = cTexBrick,
	:color = "0xffffff",
	:roughness = "0.8",
	:metalness = "0.1"
])

# Sphere with earth texture
oHTML.threeJSSphere("tex1", "earth", [
	:x = "0", :y = "1.5",
	:radius = "1.3", :segments = "48",
	:texture = cTexEarth,
	:color = "0xffffff"
])

# Cylinder with wood texture
oHTML.threeJSCylinder("tex1", "woodCyl", [
	:x = "3.5", :y = "1.2",
	:radiusTop = "0.8", :radiusBottom = "0.8", :height = "2.5",
	:segments = "32",
	:texture = cTexWood,
	:color = "0xffffff",
	:roughness = "0.7"
])

# Floor with stone texture
oHTML.threeJSPlane("tex1", "floor1", [
	:w = "20", :h = "20", :rx = "-1.5708",
	:color = "0xffffff",
	:roughness = "0.9"
])
oHTML.threeJSTextureApply("floor1", "map", cTexStone, [:tileX = "4", :tileY = "4"])

oHTML.threeJSOnAnimate("tex1", "
  if(brickBox) brickBox.rotation.y += 0.3 * delta;
  if(earth) earth.rotation.y += 0.2 * delta;
  if(woodCyl) woodCyl.rotation.y += 0.25 * delta;
")

oHTML.threeJSAmbientLight("tex1", [:intensity = "0.5"])
oHTML.threeJSDirectionalLight("tex1", "txLt1", [:x = "5", :y = "8", :z = "5", :intensity = "0.7"])

oHTML.threeJSOrbitControls("tex1", [:damping = true])

oHTML.threeJSOverlay("tex1", "<div style='background:rgba(0,0,0,0.6);padding:15px 20px;border-radius:10px'><div style='color:#4da6ff;font-weight:bold;font-size:1.1rem'>Texture Mapping</div><div style='font-size:0.75rem;color:#aaa;margin-top:8px;line-height:1.6'><span style='color:#c87533'>Brick Box</span> &mdash; diffuse map<br><span style='color:#4da6ff'>Earth Sphere</span> &mdash; planet texture<br><span style='color:#a0522d'>Wood Cylinder</span> &mdash; natural grain<br><span style='color:#888'>Stone Floor</span> &mdash; 4&times;4 repeat</div></div>", [:position = "top-left"])

oHTML.threeJSAnimate("tex1")
oHTML.save("tex_demo1_basic.html")
? "  Created: tex_demo1_basic.html"
