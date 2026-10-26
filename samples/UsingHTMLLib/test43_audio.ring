/*
	HTMLLib Demo 43 - Audio
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 43: Audio
# ------------------------------------------------------------------
? "Demo 43: Audio..."

oHTML = new HTMLWriter
oHTML.setTitle("3D Audio")
oHTML.enableThreeJS()
oHTML.enableOrbitControls()
oHTML.addCSSRule("body", [["margin", "0"], ["overflow", "hidden"]])

oHTML.threeJSScene("aud", [:fullscreen = true, :bg = "0x1a1a2e", :camZ = "8", :camY = "3"])

# Procedural tones (no audio files needed)
oHTML.threeJSTone("aud", "beep", [:waveform = "sine", :volume = "0.3", :frequency = "440", :duration = "0.3"])
oHTML.threeJSTone("aud", "boop", [:waveform = "triangle", :volume = "0.25", :frequency = "330", :duration = "0.4"])
oHTML.threeJSTone("aud", "zap", [:waveform = "sawtooth", :volume = "0.15", :frequency = "880", :duration = "0.15"])
oHTML.threeJSAmbientTone("aud", "drone", [:frequency = "150", :volume = "0.12", :detune = "3"])

# Clickable spheres — each plays a different tone
oHTML.threeJSSphere("aud", "speaker1", [:x = "-3", :y = "1.5", :color = "0xff6b6b", :radius = "0.8", :segments = "32"])
oHTML.threeJSPulse("aud", "speaker1", [:speed = "2.0", :amount = "0.1", :baseScale = "1.0"])

oHTML.threeJSSphere("aud", "speaker2", [:x = "0", :y = "1.5", :color = "0x2ecc71", :radius = "0.8", :segments = "32"])
oHTML.threeJSPulse("aud", "speaker2", [:speed = "2.5", :amount = "0.1", :baseScale = "1.0"])

oHTML.threeJSSphere("aud", "speaker3", [:x = "3", :y = "1.5", :color = "0x6c5ce7", :radius = "0.8", :segments = "32"])
oHTML.threeJSPulse("aud", "speaker3", [:speed = "1.8", :amount = "0.1", :baseScale = "1.0"])

# Click raycasting — play tones on click
oHTML.threeJSRaycast("aud", ["speaker1", "speaker2", "speaker3"],
	"if(hit.object === speaker1) { beep_play(440, 0.3); hit.object.scale.set(1.3,1.3,1.3); setTimeout(function(){speaker1.scale.set(1,1,1);},150); } else if(hit.object === speaker2) { boop_play(330, 0.4); hit.object.scale.set(1.3,1.3,1.3); setTimeout(function(){speaker2.scale.set(1,1,1);},150); } else if(hit.object === speaker3) { zap_play(880, 0.15); hit.object.scale.set(1.3,1.3,1.3); setTimeout(function(){speaker3.scale.set(1,1,1);},150); }",
	[:event = "click"])

# Hover cursor
oHTML.threeJSHover("aud", ["speaker1", "speaker2", "speaker3"],
	"document.body.style.cursor='pointer';",
	"document.body.style.cursor='default';",
	[])

oHTML.threeJSPlane("aud", "floorAud", [:w = "20", :h = "20", :color = "0x2c3e50", :rx = "-1.5708"])
oHTML.threeJSGridHelper("aud", [:size = "20", :divisions = "20", :color1 = "0x333344", :color2 = "0x444455"])

oHTML.threeJSAmbientLight("aud", [:intensity = "0.4"])
oHTML.threeJSPointLight("aud", "audLight", [:x = "0", :y = "8", :z = "5", :intensity = "0.7"])

oHTML.threeJSOrbitControls("aud", [:damping = true])

# Overlay with interactive buttons for drone control
oHTML.threeJSOverlay("aud", "<div style='background:rgba(0,0,0,0.7);padding:15px 20px;border-radius:10px'><div style='color:#ff6b6b;font-weight:bold;font-size:1.1rem'>3D Audio Demo</div><div style='font-size:0.75rem;color:#aaa;margin-top:8px;line-height:1.8'>Click spheres to play tones:<br><span style='color:#ff6b6b'>Red</span> = Sine 440Hz<br><span style='color:#2ecc71'>Green</span> = Triangle 330Hz<br><span style='color:#6c5ce7'>Purple</span> = Sawtooth 880Hz</div><div style='margin-top:10px'><button onclick='drone_start()' style='padding:6px 14px;background:#2ecc71;color:#fff;border:none;border-radius:4px;cursor:pointer;margin-right:6px'>Start Drone</button><button onclick='drone_stop()' style='padding:6px 14px;background:#e74c3c;color:#fff;border:none;border-radius:4px;cursor:pointer'>Stop Drone</button></div></div>", [:position = "top-left", :interactive = true])

oHTML.threeJSAnimate("aud")
oHTML.save("adv_demo11_audio.html")
? "  Created: adv_demo11_audio.html"
