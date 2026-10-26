/*
	HTMLLib Demo 8 - Arabic / RTL Support
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 8: Arabic / RTL Support
# ------------------------------------------------------------------
? "Demo 8: Arabic / RTL..."

oHTML = new HTMLWriter
oHTML.setTitle("Arabic RTL Demo")
oHTML.addGoogleFont("Noto Naskh Arabic")

oHTML.addCSSRule("body", [
	["font-family", "'Noto Naskh Arabic', 'Segoe UI', Tahoma, sans-serif"],
	["max-width", "800px"],
	["margin", "0 auto"],
	["padding", "20px"],
	["line-height", "1.8"]
])
oHTML.addCSSRule(".arabic-section", [
	["background-color", "#f8f9fa"],
	["padding", "20px"],
	["border-radius", "8px"],
	["margin-bottom", "20px"],
	["border", "1px solid #e9ecef"]
])

oHTML.addHeading(1, "Arabic / RTL Demo")

# English section
oHTML.addHeading(2, "English (LTR)")
oHTML.addParagraph("This is a left-to-right English section. HTMLLib supports both LTR and RTL text directions.")

# Arabic section
oHTML.addHeading(2, "Arabic (RTL)")
oHTML.openRTLDiv([:class = "arabic-section"])
oHTML.addRTLParagraph("بسم الله الرحمن الرحيم")
oHTML.addRTLParagraph("مرحبا بالعالم - لغة البرمجة رنج")
oHTML.addRTLParagraph("جامعة الملك سعود - قسم علوم الحاسب")
oHTML.addRTLParagraph("هذه المكتبة تدعم النصوص العربية والاتجاه من اليمين إلى اليسار")
oHTML.closeRTLDiv()

# Bilingual section
oHTML.addHeading(2, "Bilingual Content")
oHTML.openTwoColumns("1fr", "1fr", "20px")
oHTML.openDiv([:style = "padding: 15px; background: #e8f4fd; border-radius: 8px"])
oHTML.addHeading(3, "Abstract")
oHTML.addParagraph("This paper presents a novel approach to developing Terminal User Interface frameworks using prompt-driven development with large language models.")
oHTML.closeDiv()
oHTML.openDiv([:style = "padding: 15px; background: #fef5e8; border-radius: 8px", :dir = "rtl"])
oHTML.addRTLParagraph("الملخص")
oHTML.addRTLParagraph("يقدم هذا البحث منهجية جديدة لتطوير واجهات المستخدم النصية باستخدام التطوير الموجه بالأوامر مع نماذج اللغة الكبيرة")
oHTML.closeDiv()
oHTML.closeTwoColumns()

# Arabic table
oHTML.addHeading(2, "Arabic Table")
oHTML.addTableStyled([
	["Field / الحقل", "Value / القيمة"],
	["Language / اللغة", "Ring / رنج"],
	["University / الجامعة", "King Saud / جامعة الملك سعود"],
	["Status / الحالة", "Active / نشط"],
	["Framework / الإطار", "TUI / واجهة نصية"]
], [:class = "bilingual-table", :striped = true, :hover = true])

oHTML.save("demo8_arabic.html")
? "  Created: demo8_arabic.html"
