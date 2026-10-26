/*
	HTMLLib Demo 23 - Landing Page with Pricing
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 23: Landing Page with Pricing
# ------------------------------------------------------------------
? "Demo 23: Landing page..."

oHTML = new HTMLWriter
oHTML.setTitle("CloudSync Pro - Cloud Storage")
oHTML.setTheme("modern")
oHTML.enableSmoothScroll()

# Hero
oHTML.addHero(
	"Cloud Storage, Reimagined",
	"Secure, fast, and intelligent cloud storage for teams of all sizes. Start free, scale infinitely.",
	"Start Free Trial", "#pricing",
	[:bgColor = "#6c5ce7", :height = "85vh"]
)

# Features
oHTML.addRawHTML('<div style="max-width:1100px;margin:0 auto;padding:0 20px">')
oHTML.addSpacer("50px")
oHTML.addRawHTML('<h2 style="text-align:center;margin-bottom:10px">Powerful Features</h2>')
oHTML.addRawHTML('<p style="text-align:center;color:var(--text-muted);margin-bottom:30px">Everything you need to manage your files</p>')
oHTML.addFeatureGrid([
	["&#x2601;", "Cloud Storage", "Store unlimited files with 99.99% uptime guarantee."],
	["&#x1F512;", "Security", "End-to-end encryption and zero-knowledge architecture."],
	["&#x1F465;", "Collaboration", "Real-time editing and sharing with your team."],
	["&#x1F4F1;", "Mobile", "Access your files from any device, anywhere."],
	["&#x26A1;", "Fast Sync", "Lightning-fast sync across all your devices."],
	["&#x1F504;", "Versioning", "Full file history with unlimited version rollback."]
], 3)

# Pricing
oHTML.addSpacer("50px")
oHTML.addRawHTML('<h2 id="pricing" style="text-align:center;margin-bottom:30px">Simple Pricing</h2>')
oHTML.addPricingTable([
	[:name = "Starter", :price = "$0", :period = "Free forever", :features = ["5 GB Storage", "2 Users", "Basic Support", "Web Access"], :cta = "Get Started", :ctaHref = "#"],
	[:name = "Professional", :price = "$12", :period = "/user/month", :features = ["100 GB Storage", "10 Users", "Priority Support", "API Access", "Advanced Security"], :cta = "Start Trial", :ctaHref = "#", :highlight = true],
	[:name = "Enterprise", :price = "$39", :period = "/user/month", :features = ["Unlimited Storage", "Unlimited Users", "24/7 Support", "Custom Integration", "SSO & SAML", "SLA 99.99%"], :cta = "Contact Sales", :ctaHref = "#"]
])

# Timeline
oHTML.addSpacer("50px")
oHTML.addRawHTML('<h2 style="text-align:center;margin-bottom:30px">Our Journey</h2>')
oHTML.addTimeline([
	["2020", "Founded", "CloudSync was founded with a mission to simplify cloud storage."],
	["2021", "Public Launch", "Launched to the public with 10,000 users in the first month."],
	["2022", "Enterprise Tier", "Added enterprise features including SSO and compliance tools."],
	["2023", "Global Expansion", "Expanded to 30+ countries with localized data centers."],
	["2024", "AI Integration", "Launched AI-powered file organization and search."],
	["2025", "Industry Leader", "Reached 1 million users and SOC 2 Type II certification."]
])

oHTML.addRawHTML('</div>')

# Footer
oHTML.addPageFooter(
	"Copyright 2025 CloudSync Pro. All rights reserved.",
	[["Privacy", "/privacy"], ["Terms", "/terms"], ["Status", "/status"], ["Blog", "/blog"]],
	[:bgColor = "#2d3436"]
)
oHTML.addBackToTop()

oHTML.save("ext_demo4_landing.html")
? "  Created: ext_demo4_landing.html"
