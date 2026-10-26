/*
	HTMLLib Demo 24 - Arabic Bootstrap Page
*/

load "htmllib.ring"

# ------------------------------------------------------------------
# Demo 24: Arabic Bootstrap Page
# ------------------------------------------------------------------
? "Demo 24: Arabic Bootstrap..."

oHTML = new HTMLWriter
oHTML.setTitle("جامعة الملك سعود - قسم علوم الحاسب")
oHTML.enableBootstrap()
oHTML.enableBootstrapIcons()
oHTML.setDirection("rtl")
oHTML.setLang("ar")
oHTML.addGoogleFont("Noto Naskh Arabic")
oHTML.addCSSRule("body", [["font-family", "'Noto Naskh Arabic', Tahoma, sans-serif"]])

oHTML.bsNavbar("جامعة الملك سعود", "/", [
	["الرئيسية", "/", true],
	["الأقسام", "#", false],
	["البحث العلمي", "#", false],
	["التواصل", "#", false]
], "dark")

oHTML.bsOpenContainer("")
oHTML.addSpacer("30px")

oHTML.addRawHTML('<h1 class="mb-3">قسم علوم الحاسب</h1>')
oHTML.addRawHTML('<p class="lead mb-4">مرحبا بكم في قسم علوم الحاسب بجامعة الملك سعود - الرياض</p>')

oHTML.bsOpenRow("g-4")
oHTML.bsOpenCol("col-md-4")
oHTML.bsCard("البحث العلمي", "نشر أبحاث متقدمة في مجالات الذكاء الاصطناعي وعلوم البيانات ولغات البرمجة.", [])
oHTML.bsCloseCol()
oHTML.bsOpenCol("col-md-4")
oHTML.bsCard("التدريس", "برامج بكالوريوس وماجستير ودكتوراه في تخصصات علوم الحاسب.", [])
oHTML.bsCloseCol()
oHTML.bsOpenCol("col-md-4")
oHTML.bsCard("خدمة المجتمع", "ورش عمل ودورات تدريبية مفتوحة لخدمة المجتمع.", [])
oHTML.bsCloseCol()
oHTML.bsCloseRow()

oHTML.addSpacer("30px")
oHTML.addRawHTML('<h2 class="mb-3">أعضاء هيئة التدريس</h2>')
oHTML.bsTable([
	["الاسم", "التخصص", "الرتبة", "البريد"],
	["د. أحمد محمد", "ذكاء اصطناعي", "أستاذ مشارك", "ahmed@ksu.edu.sa"],
	["د. فاطمة علي", "هندسة برمجيات", "أستاذ مساعد", "fatima@ksu.edu.sa"],
	["د. خالد إبراهيم", "شبكات حاسب", "أستاذ", "khalid@ksu.edu.sa"],
	["د. نورة سعد", "أمن معلومات", "أستاذ مساعد", "noura@ksu.edu.sa"]
], [:striped = true, :hover = true, :bordered = true])

oHTML.bsAccordion("arFaq", [
	["ما هي لغة رنج؟", "لغة رنج هي لغة برمجة عملية متعددة النماذج صممت للبساطة والبرمجة الطبيعية."],
	["كيف أتقدم للقسم؟", "يمكنك التقديم عبر بوابة القبول الإلكترونية في الجامعة خلال فترة التقديم المعلنة."],
	["هل يوجد برنامج ماجستير؟", "نعم، يقدم القسم برنامج ماجستير في علوم الحاسب ببحث أو مقررات."]
])

oHTML.bsCloseContainer()
oHTML.addSpacer("30px")
oHTML.save("ext_demo5_arabic_bs.html")
? "  Created: ext_demo5_arabic_bs.html"
