/*
	HTMLLib Demo 39 - Lines & Curves
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 39: Lines & Curves
# ------------------------------------------------------------------
? "Demo 39: Lines & Curves..."

oHTML = new HTMLWriter
oHTML.setTitle("Lines & Curves")
oHTML.enableThreeJS()
oHTML.enableOrbitControls()
oHTML.addCSSRule("body", [["margin", "0"], ["overflow", "hidden"]])

oHTML.threeJSScene("lnc", [:fullscreen = true, :bg = "0x0a0a1a", :camZ = "10", :camY = "4"])

# Straight line
oHTML.threeJSLine("lnc", "straightLine", [
	["-6", "0", "0"], ["-6", "3", "0"], ["-3", "3", "0"]
], [:color = "0xff6b6b"])

# Dashed line
oHTML.threeJSLine("lnc", "dashedLine", [
	["-3", "0", "0"], ["-3", "3", "0"], ["0", "3", "0"]
], [:color = "0xffd900", :dashed = true, :dashSize = "0.3", :gapSize = "0.15"])

# Smooth curve (CatmullRom spline)
oHTML.threeJSCurve("lnc", "curve1", [
	["0", "0", "0"], ["1", "3", "-1"], ["3", "1", "1"], ["5", "3", "0"], ["6", "0", "0"]
], [:color = "0x6c5ce7", :segments = "64"])

# 3D Tube
oHTML.threeJSTube("lnc", "tube1", [
	["-5", "0", "3"], ["-3", "2", "4"], ["0", "3", "3"], ["3", "2", "4"], ["5", "0", "3"]
], [:color = "0x00cec9", :tubeRadius = "0.1", :segments = "64"])

# Closed curve (loop)
oHTML.threeJSCurve("lnc", "closedLoop", [
	["-4", "0", "-3"], ["-2", "2", "-4"], ["0", "0", "-5"],
	["2", "2", "-4"], ["4", "0", "-3"], ["2", "-1", "-2"],
	["0", "0", "-1"], ["-2", "-1", "-2"]
], [:color = "0xff006e", :closed = true, :tube = true, :tubeRadius = "0.06", :segments = "100"])

oHTML.threeJSGridHelper("lnc", [:size = "20", :divisions = "20", :color1 = "0x222233", :color2 = "0x333344"])

oHTML.threeJSAmbientLight("lnc", [:intensity = "0.5"])
oHTML.threeJSPointLight("lnc", "pl7", [:x = "5", :y = "8", :z = "5", :intensity = "0.7"])

oHTML.threeJSOrbitControls("lnc", [:damping = true])

oHTML.threeJSOverlay("lnc", "<div style='background:rgba(0,0,0,0.7);padding:15px 20px;border-radius:10px'><div style='color:#6c5ce7;font-weight:bold;font-size:1.1rem'>Lines & Curves</div><div style='font-size:0.7rem;color:#aaa;margin-top:8px;line-height:1.8'><span style='color:#ff6b6b'>Red</span> &mdash; Straight line<br><span style='color:#ffd900'>Yellow</span> &mdash; Dashed line<br><span style='color:#6c5ce7'>Purple</span> &mdash; CatmullRom spline<br><span style='color:#00cec9'>Teal</span> &mdash; 3D Tube<br><span style='color:#ff006e'>Pink</span> &mdash; Closed tube loop</div></div>", [:position = "top-left"])

oHTML.threeJSAnimate("lnc")
oHTML.save("adv_demo7_lines.html")
? "  Created: adv_demo7_lines.html"
