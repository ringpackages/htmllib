class HTMLWriter

	# Document settings
	cTitle = "Untitled"
	cLang = "en"
	cDir = ""
	cCharset = "UTF-8"
	cDescription = ""
	cKeywords = ""
	cAuthor = ""
	cViewport = "width=device-width, initial-scale=1.0"
	cFavicon = ""
	cCanonicalURL = ""
	lMinified = false

	# Open Graph / Social
	aOpenGraph = []			# List of [property, content]
	aMetaTags = []			# Custom meta tags [name, content]

	# External resources
	aStylesheets = []		# External CSS links
	aScriptsSrc = []		# External JS scripts

	# Internal CSS
	aCSSRules = []			# List of rendered CSS rules
	aCSSVariables = []		# CSS custom properties [name, value]
	aMediaQueries = []		# List of [:query = "...", :rules = "..."]
	aKeyframes = []			# List of [:name = "...", :frames = "..."]
	cRawCSS = ""			# Raw CSS string to append

	# Internal JS
	cScriptsHead = ""		# JS in <head>
	cScriptsBody = ""		# JS before </body>

	# Body content
	aBodyContent = []		# List of HTML strings (in order)
	aBodyAttrs = []			# Body element attributes

	# Framework support
	lBootstrap = false		# Enable Bootstrap CSS/JS
	cBootstrapVersion = "5.3.3"
	lBootstrapIcons = false
	lFontAwesome = false
	cFontAwesomeVersion = "6.5.1"
	lHighlightJS = false
	cHighlightTheme = "github"
	lThreeJS = false		# Enable Three.js 3D engine
	lGLTFLoader = false		# Enable GLTF/GLB loader
	lOBJLoader = false
	lMTLLoader = false
	lFBXLoader = false
	lColladaLoader = false
	lDracoDecoder = false
	lOrbitControls = false
	lPostProcessing = false
	lReflector = false
	lCannonJS = false		# Enable Cannon.js physics
	lGSAP = false			# Enable GSAP tweening
	lTextGeometry = false		# Enable TextGeometry + FontLoader
	lCSS2DRenderer = false		# Enable CSS2DRenderer for HTML labels
	lOutlinePass = false		# Enable OutlinePass for selection highlight

	# Theme support
	cTheme = ""			# Current theme name
	aThemeColors = []		# Theme color palette

	# State tracking
	nIndentLevel = 0		# Depth of open container elements
	nAutoId = 0			# Auto-ID counter for generated elements

	func init
		return self

	# ====================================================================
	# Document Settings
	# ====================================================================

	func setTitle cNewTitle
		cTitle = cNewTitle
		return self

	func setLang cNewLang
		cLang = cNewLang
		return self

	func setDirection cNewDir
		cDir = cNewDir
		return self

	func setCharset cNewCharset
		cCharset = cNewCharset
		return self

	func setDescription cDesc
		cDescription = cDesc
		return self

	func setKeywords cKw
		cKeywords = cKw
		return self

	func setAuthor cNewAuthor
		cAuthor = cNewAuthor
		return self

	func setViewport cVp
		cViewport = cVp
		return self

	func setFavicon cURL
		cFavicon = cURL
		return self

	func setCanonicalURL cURL
		cCanonicalURL = cURL
		return self

	func setMinified lFlag
		lMinified = lFlag
		return self

	func addMeta cName, cContent
		aMetaTags + [cName, cContent]
		return self

	func addOpenGraph cProperty, cContent
		aOpenGraph + [cProperty, cContent]
		return self

	func setBodyAttr cName, cValue
		aBodyAttrs + [cName, cValue]
		return self

	# ====================================================================
	# External Resources
	# ====================================================================

	func addStylesheet cHref
		aStylesheets + cHref
		return self

	# Add with media query
	func addStylesheetMedia cHref, cMedia
		aStylesheets + (cHref + '" media="' + cMedia)
		return self

	func addScript cSrc
		aScriptsSrc + cSrc
		return self

	func addGoogleFont cFontName
		cEncoded = substr(cFontName, " ", "+")
		addStylesheet("https://fonts.googleapis.com/css2?family=" + cEncoded + ":wght@300;400;500;600;700&display=swap")
		return self

	# ====================================================================
	# CSS Styling
	# ====================================================================

	# Add a CSS rule: addCSSRule("body", [["background-color", "#fff"], ["font-family", "Arial"]])
	# Use list-of-lists with CSS kebab-case property names
	# Correct:   [["background-color", "red"], ["font-size", "16px"]]
	# Wrong:     [:backgroundColor = "red"]  (Ring lowercases => "backgroundcolor")
	# Wrong:     ["background-color" = "red"] (Ring hash, not iterable as pairs)
	func addCSSRule cSelectorStr, aProps
		cRule = cSelectorStr + " {" + HTML_LF
		nPropertyLen = len(aProps)
		for nProperty = 1 to nPropertyLen
			cPropName = aProps[nProperty][1]
			cPropName = substr(cPropName, ":", "")
			# Ring lowercases hash keys, so camelCase is lost
			# Properties must be written in kebab-case directly
			cRule += "    " + cPropName + ": " + aProps[nProperty][2] + ";" + HTML_LF
		next
		cRule += "}" + HTML_LF
		aCSSRules + cRule
		return self

	# Add raw CSS string
	func addRawCSS cCSS
		cRawCSS += cCSS + char(10)
		return self

	# Add CSS variable
	func addCSSVariable cName, cValue
		aCSSVariables + [cName, cValue]
		return self

	# Add media query with rules
	func addMediaQuery cQuery, cRulesText
		aMediaQueries + [:query = cQuery, :rules = cRulesText]
		return self

	# Add responsive breakpoint helper
	func addBreakpoint cMaxWidth, cRulesText
		addMediaQuery("max-width: " + cMaxWidth, cRulesText)
		return self

	# Add keyframe animation
	func addKeyframes cName, cFramesText
		aKeyframes + [:name = cName, :frames = cFramesText]
		return self

	# Add JavaScript to <head>
	func addHeadScript cJS
		cScriptsHead += cJS + char(10)
		return self

	# Add JavaScript before </body>
	func addBodyScript cJS
		cScriptsBody += cJS + char(10)
		return self

	# ====================================================================
	# Content Helpers (private)
	# ====================================================================

	func appendContent cHTML
		aBodyContent + cHTML

	# ====================================================================
	# Raw HTML
	# ====================================================================

	func addRawHTML cHTML
		appendContent(cHTML)
		return self

	# ====================================================================
	# Text Elements
	# ====================================================================

	# Heading: addHeading(1, "Title")
	func addHeading nLevel, cText
		appendContent("<h" + nLevel + ">" + htmlEscape(cText) + "</h" + nLevel + ">")
		return self

	# Heading with attributes: addHeadingStyled(2, "Subtitle", [:class = "blue"])
	func addHeadingStyled nLevel, cText, aAttrs
		appendContent("<h" + nLevel + htmlBuildAttrs(aAttrs) + ">" + htmlEscape(cText) + "</h" + nLevel + ">")
		return self

	# Heading with raw HTML content (for mixing tags inside headings)
	func addHeadingRaw nLevel, cHTML
		appendContent("<h" + nLevel + ">" + cHTML + "</h" + nLevel + ">")
		return self

	func addHeadingRawStyled nLevel, cHTML, aAttrs
		appendContent("<h" + nLevel + htmlBuildAttrs(aAttrs) + ">" + cHTML + "</h" + nLevel + ">")
		return self

	# Paragraph
	func addParagraph cText
		appendContent("<p>" + htmlEscape(cText) + "</p>")
		return self

	func addParagraphStyled cText, aAttrs
		appendContent("<p" + htmlBuildAttrs(aAttrs) + ">" + htmlEscape(cText) + "</p>")
		return self

	# Paragraph with raw HTML content
	func addParagraphRaw cHTML
		appendContent("<p>" + cHTML + "</p>")
		return self

	func addParagraphRawStyled cHTML, aAttrs
		appendContent("<p" + htmlBuildAttrs(aAttrs) + ">" + cHTML + "</p>")
		return self

	# Line break
	func addBreak
		appendContent("<br>")
		return self

	# Horizontal rule
	func addHR
		appendContent("<hr>")
		return self

	func addHRStyled aAttrs
		appendContent("<hr" + htmlBuildAttrs(aAttrs) + ">")
		return self

	# Span
	func addSpan cText, aAttrs
		appendContent("<span" + htmlBuildAttrs(aAttrs) + ">" + htmlEscape(cText) + "</span>")
		return self

	func addSpanRaw cHTML, aAttrs
		appendContent("<span" + htmlBuildAttrs(aAttrs) + ">" + cHTML + "</span>")
		return self

	# Bold, italic, underline, etc.
	func addBold cText
		appendContent("<strong>" + htmlEscape(cText) + "</strong>")
		return self

	func addItalic cText
		appendContent("<em>" + htmlEscape(cText) + "</em>")
		return self

	func addUnderline cText
		appendContent('<span style="text-decoration: underline">' + htmlEscape(cText) + "</span>")
		return self

	func addStrikethrough cText
		appendContent("<del>" + htmlEscape(cText) + "</del>")
		return self

	func addSmall cText
		appendContent("<small>" + htmlEscape(cText) + "</small>")
		return self

	func addMark cText
		appendContent("<mark>" + htmlEscape(cText) + "</mark>")
		return self

	func addSubscript cText
		appendContent("<sub>" + htmlEscape(cText) + "</sub>")
		return self

	func addSuperscript cText
		appendContent("<sup>" + htmlEscape(cText) + "</sup>")
		return self

	func addAbbr cText, cTitleText
		appendContent('<abbr title="' + htmlEscape(cTitleText) + '">' + htmlEscape(cText) + "</abbr>")
		return self

	func addBlockquote cText
		appendContent("<blockquote>" + htmlEscape(cText) + "</blockquote>")
		return self

	func addBlockquoteStyled cText, aAttrs
		appendContent("<blockquote" + htmlBuildAttrs(aAttrs) + ">" + htmlEscape(cText) + "</blockquote>")
		return self

	# Preformatted text
	func addPre cText
		appendContent("<pre>" + htmlEscape(cText) + "</pre>")
		return self

	func addCode cText
		appendContent("<code>" + htmlEscape(cText) + "</code>")
		return self

	# Code block with language class
	func addCodeBlock cCode, cLanguage
		appendContent('<pre><code class="language-' + htmlEscape(cLanguage) + '">' + htmlEscape(cCode) + "</code></pre>")
		return self

	func addCodeBlockStyled cCode, cLanguage, aAttrs
		appendContent('<pre' + htmlBuildAttrs(aAttrs) + '><code class="language-' + htmlEscape(cLanguage) + '">' + htmlEscape(cCode) + "</code></pre>")
		return self

	# Text with inline style shorthand
	func addText cText, cColor, cFontSize, cFontWeight
		cStyle = "color: " + cColor + "; font-size: " + cFontSize + "; font-weight: " + cFontWeight
		appendContent('<span style="' + cStyle + '">' + htmlEscape(cText) + "</span>")
		return self

	# ====================================================================
	# Links
	# ====================================================================

	func addLink cText, cHref
		appendContent('<a href="' + cHref + '">' + htmlEscape(cText) + "</a>")
		return self

	func addLinkStyled cText, cHref, aAttrs
		appendContent('<a href="' + cHref + '"' + htmlBuildAttrs(aAttrs) + ">" + htmlEscape(cText) + "</a>")
		return self

	func addLinkNewTab cText, cHref
		appendContent('<a href="' + cHref + '" target="_blank" rel="noopener noreferrer">' + htmlEscape(cText) + "</a>")
		return self

	func addLinkRaw cHTML, cHref, aAttrs
		appendContent('<a href="' + cHref + '"' + htmlBuildAttrs(aAttrs) + ">" + cHTML + "</a>")
		return self

	# Anchor (bookmark target)
	func addAnchor cID
		appendContent('<a id="' + cID + '"></a>')
		return self

	# ====================================================================
	# Images
	# ====================================================================

	func addImage cSrc, cAlt
		appendContent('<img src="' + cSrc + '" alt="' + htmlEscape(cAlt) + '">')
		return self

	func addImageStyled cSrc, cAlt, aAttrs
		appendContent('<img src="' + cSrc + '" alt="' + htmlEscape(cAlt) + '"' + htmlBuildAttrs(aAttrs) + ">")
		return self

	func addImageSized cSrc, cAlt, cWidth, cHeight
		appendContent('<img src="' + cSrc + '" alt="' + htmlEscape(cAlt) + '" width="' + cWidth + '" height="' + cHeight + '">')
		return self

	# Responsive image with srcset
	func addResponsiveImage cSrc, cAlt, cSrcset, cSizes
		appendContent('<img src="' + cSrc + '" alt="' + htmlEscape(cAlt) + '" srcset="' + cSrcset + '" sizes="' + cSizes + '">')
		return self

	# Figure with caption
	func addFigure cImgSrc, cImgAlt, cCaption
		cHTML = "<figure>" + char(10)
		cHTML += '    <img src="' + cImgSrc + '" alt="' + htmlEscape(cImgAlt) + '">' + char(10)
		cHTML += "    <figcaption>" + htmlEscape(cCaption) + "</figcaption>" + char(10)
		cHTML += "</figure>"
		appendContent(cHTML)
		return self

	func addFigureStyled cImgSrc, cImgAlt, cCaption, aAttrs
		cHTML = "<figure" + htmlBuildAttrs(aAttrs) + ">" + char(10)
		cHTML += '    <img src="' + cImgSrc + '" alt="' + htmlEscape(cImgAlt) + '">' + char(10)
		cHTML += "    <figcaption>" + htmlEscape(cCaption) + "</figcaption>" + char(10)
		cHTML += "</figure>"
		appendContent(cHTML)
		return self

	# ====================================================================
	# Media (Audio, Video, Iframe)
	# ====================================================================

	func addVideo cSrc, aAttrs
		appendContent('<video src="' + cSrc + '"' + htmlBuildAttrs(aAttrs) + ">Your browser does not support the video tag.</video>")
		return self

	func addVideoControls cSrc, cWidth, cHeight
		appendContent('<video src="' + cSrc + '" controls width="' + cWidth + '" height="' + cHeight + '">Your browser does not support the video tag.</video>')
		return self

	func addAudio cSrc, aAttrs
		appendContent('<audio src="' + cSrc + '"' + htmlBuildAttrs(aAttrs) + ">Your browser does not support the audio tag.</audio>")
		return self

	func addAudioControls cSrc
		appendContent('<audio src="' + cSrc + '" controls>Your browser does not support the audio tag.</audio>')
		return self

	func addIframe cSrc, cWidth, cHeight
		appendContent('<iframe src="' + cSrc + '" width="' + cWidth + '" height="' + cHeight + '" frameborder="0"></iframe>')
		return self

	func addIframeStyled cSrc, aAttrs
		appendContent('<iframe src="' + cSrc + '"' + htmlBuildAttrs(aAttrs) + "></iframe>")
		return self

	# ====================================================================
	# Lists
	# ====================================================================

	# Simple unordered list: addList(["Item 1", "Item 2", "Item 3"])
	func addList aItems
		cHTML = "<ul>" + char(10)
		nItemLen = len(aItems)
		for nItem = 1 to nItemLen
			cHTML += "    <li>" + htmlEscape(aItems[nItem]) + "</li>" + char(10)
		next
		cHTML += "</ul>"
		appendContent(cHTML)
		return self

	func addListStyled aItems, aAttrs
		cHTML = "<ul" + htmlBuildAttrs(aAttrs) + ">" + char(10)
		nItemLen = len(aItems)
		for nItem = 1 to nItemLen
			cHTML += "    <li>" + htmlEscape(aItems[nItem]) + "</li>" + char(10)
		next
		cHTML += "</ul>"
		appendContent(cHTML)
		return self

	# Ordered list
	func addOrderedList aItems
		cHTML = "<ol>" + char(10)
		nItemLen = len(aItems)
		for nItem = 1 to nItemLen
			cHTML += "    <li>" + htmlEscape(aItems[nItem]) + "</li>" + char(10)
		next
		cHTML += "</ol>"
		appendContent(cHTML)
		return self

	func addOrderedListStyled aItems, aAttrs
		cHTML = "<ol" + htmlBuildAttrs(aAttrs) + ">" + char(10)
		nItemLen = len(aItems)
		for nItem = 1 to nItemLen
			cHTML += "    <li>" + htmlEscape(aItems[nItem]) + "</li>" + char(10)
		next
		cHTML += "</ol>"
		appendContent(cHTML)
		return self

	# List with raw HTML items (allows nested lists, links, etc.)
	func addListRaw aItems
		cHTML = "<ul>" + char(10)
		nItemLen = len(aItems)
		for nItem = 1 to nItemLen
			cHTML += "    <li>" + aItems[nItem] + "</li>" + char(10)
		next
		cHTML += "</ul>"
		appendContent(cHTML)
		return self

	# Definition list: addDefList([["Term1", "Def1"], ["Term2", "Def2"]])
	func addDefList aItems
		cHTML = "<dl>" + char(10)
		nItemLen = len(aItems)
		for nItem = 1 to nItemLen
			cHTML += "    <dt>" + htmlEscape(aItems[nItem][1]) + "</dt>" + char(10)
			cHTML += "    <dd>" + htmlEscape(aItems[nItem][2]) + "</dd>" + char(10)
		next
		cHTML += "</dl>"
		appendContent(cHTML)
		return self

	# ====================================================================
	# Tables
	# ====================================================================

	# Simple table from 2D list (first row = header)
	# data = [["Name","Age"], ["Alice","30"], ["Bob","25"]]
	func addTable aData
		cHTML = "<table>" + char(10)
		nDataLen = len(aData)
		for nRow = 1 to nDataLen
			aRow = aData[nRow]
			nColLen = len(aRow)
			if nRow = 1
				cHTML += "    <thead>" + char(10) + "        <tr>" + char(10)
				for nCol = 1 to nColLen
					cHTML += "            <th>" + htmlEscape("" + aRow[nCol]) + "</th>" + char(10)
				next
				cHTML += "        </tr>" + char(10) + "    </thead>" + char(10)
				cHTML += "    <tbody>" + char(10)
			else
				cHTML += "        <tr>" + char(10)
				for nCol = 1 to nColLen
					cHTML += "            <td>" + htmlEscape("" + aRow[nCol]) + "</td>" + char(10)
				next
				cHTML += "        </tr>" + char(10)
			ok
		next
		if nDataLen > 1
			cHTML += "    </tbody>" + char(10)
		ok
		cHTML += "</table>"
		appendContent(cHTML)
		return self

	# Styled table with options
	# options: [:class, :id, :border, :striped, :hover, :responsive, :caption]
	func addTableStyled aData, aOptions
		# Build table class
		cTableClass = htmlGetOpt(aOptions, "class", "")
		cTableId = htmlGetOpt(aOptions, "id", "")
		cTableBorder = htmlGetOpt(aOptions, "border", "")
		lIsResponsive = htmlGetOpt(aOptions, "responsive", false)
		lIsStriped = htmlGetOpt(aOptions, "striped", false)
		lIsHover = htmlGetOpt(aOptions, "hover", false)
		cCaptionText = htmlGetOpt(aOptions, "caption", "")

		cTableAttrs = ""
		if cTableClass != "" cTableAttrs += ' class="' + cTableClass + '"' ok
		if cTableId != "" cTableAttrs += ' id="' + cTableId + '"' ok
		if cTableBorder != "" cTableAttrs += ' border="' + cTableBorder + '"' ok

		cHTML = ""
		if lIsResponsive = true
			cHTML += '<div style="overflow-x: auto">' + char(10)
		ok

		cHTML += "<table" + cTableAttrs + ">" + char(10)

		if cCaptionText != ""
			cHTML += "    <caption>" + htmlEscape(cCaptionText) + "</caption>" + char(10)
		ok

		nDataLen = len(aData)
		for nRow = 1 to nDataLen
			aRow = aData[nRow]
			nColLen = len(aRow)
			if nRow = 1
				cHTML += "    <thead>" + char(10) + "        <tr>" + char(10)
				for nCol = 1 to nColLen
					cHTML += "            <th>" + htmlEscape("" + aRow[nCol]) + "</th>" + char(10)
				next
				cHTML += "        </tr>" + char(10) + "    </thead>" + char(10)
				cHTML += "    <tbody>" + char(10)
			else
				cHTML += "        <tr>" + char(10)
				for nCol = 1 to nColLen
					cHTML += "            <td>" + htmlEscape("" + aRow[nCol]) + "</td>" + char(10)
				next
				cHTML += "        </tr>" + char(10)
			ok
		next
		if nDataLen > 1
			cHTML += "    </tbody>" + char(10)
		ok
		cHTML += "</table>"

		if lIsResponsive = true
			cHTML += char(10) + "</div>"
		ok

		appendContent(cHTML)

		# Auto-generate striped/hover CSS if requested
		if lIsStriped = true
			cSel = "table"
			if cTableClass != "" cSel = "." + cTableClass ok
			addCSSRule(cSel + " tbody tr:nth-child(even)", [["background-color", "#f8f9fa"]])
		ok
		if lIsHover = true
			cSel = "table"
			if cTableClass != "" cSel = "." + cTableClass ok
			addCSSRule(cSel + " tbody tr:hover", [["background-color", "#e9ecef"]])
		ok

		return self

	# Table with raw HTML cells (allows spanning, mixed content)
	func addTableRaw cHTML
		appendContent(cHTML)
		return self

	# ====================================================================
	# Forms
	# ====================================================================

	func openForm cAction, cMethod
		cHTML = '<form action="' + cAction + '" method="' + cMethod + '">'
		appendContent(cHTML)
		return self

	func openFormStyled cAction, cMethod, aAttrs
		cHTML = '<form action="' + cAction + '" method="' + cMethod + '"' + htmlBuildAttrs(aAttrs) + ">"
		appendContent(cHTML)
		return self

	func closeForm
		appendContent("</form>")
		return self

	# Input field with label
	func addInput cLabel, cType, cName, aAttrs
		cHTML = ""
		cID = cName
		if cLabel != ""
			cHTML += '<label for="' + cID + '">' + htmlEscape(cLabel) + "</label> "
		ok
		cHTML += '<input type="' + cType + '" name="' + cName + '" id="' + cID + '"'
		cHTML += htmlBuildAttrs(aAttrs) + ">"
		appendContent(cHTML)
		return self

	# Simple labeled input
	func addInputField cLabel, cType, cName
		addInput(cLabel, cType, cName, [])
		return self

	# Textarea
	func addTextarea cLabel, cName, nRows, nCols
		cHTML = ""
		if cLabel != ""
			cHTML += '<label for="' + cName + '">' + htmlEscape(cLabel) + "</label> "
		ok
		cHTML += '<textarea name="' + cName + '" id="' + cName + '" rows="' + nRows + '" cols="' + nCols + '"></textarea>'
		appendContent(cHTML)
		return self

	func addTextareaStyled cLabel, cName, nRows, nCols, aAttrs
		cHTML = ""
		if cLabel != ""
			cHTML += '<label for="' + cName + '">' + htmlEscape(cLabel) + "</label> "
		ok
		cHTML += '<textarea name="' + cName + '" id="' + cName + '" rows="' + nRows + '" cols="' + nCols + '"' + htmlBuildAttrs(aAttrs) + "></textarea>"
		appendContent(cHTML)
		return self

	# Select dropdown
	# options: [["value1", "Label 1"], ["value2", "Label 2"]]
	func addSelect cLabel, cName, aOptions
		cHTML = ""
		if cLabel != ""
			cHTML += '<label for="' + cName + '">' + htmlEscape(cLabel) + "</label> "
		ok
		cHTML += '<select name="' + cName + '" id="' + cName + '">' + char(10)
		nOptionLen = len(aOptions)
		for nOption = 1 to nOptionLen
			cHTML += '    <option value="' + htmlEscape(aOptions[nOption][1]) + '">' + htmlEscape(aOptions[nOption][2]) + "</option>" + char(10)
		next
		cHTML += "</select>"
		appendContent(cHTML)
		return self

	func addSelectStyled cLabel, cName, aOptions, aAttrs
		cHTML = ""
		if cLabel != ""
			cHTML += '<label for="' + cName + '">' + htmlEscape(cLabel) + "</label> "
		ok
		cHTML += '<select name="' + cName + '" id="' + cName + '"' + htmlBuildAttrs(aAttrs) + ">" + char(10)
		nOptionLen = len(aOptions)
		for nOption = 1 to nOptionLen
			cHTML += '    <option value="' + htmlEscape(aOptions[nOption][1]) + '">' + htmlEscape(aOptions[nOption][2]) + "</option>" + char(10)
		next
		cHTML += "</select>"
		appendContent(cHTML)
		return self

	# Checkbox
	func addCheckbox cLabel, cName, cValue, lChecked
		cCheckedAttr = ""
		if lChecked cCheckedAttr = " checked" ok
		cHTML = '<label><input type="checkbox" name="' + cName + '" value="' + cValue + '"' + cCheckedAttr + "> " + htmlEscape(cLabel) + "</label>"
		appendContent(cHTML)
		return self

	# Radio button
	func addRadio cLabel, cName, cValue, lChecked
		cCheckedAttr = ""
		if lChecked cCheckedAttr = " checked" ok
		cHTML = '<label><input type="radio" name="' + cName + '" value="' + cValue + '"' + cCheckedAttr + "> " + htmlEscape(cLabel) + "</label>"
		appendContent(cHTML)
		return self

	# Fieldset with legend
	func openFieldset cLegend
		cHTML = "<fieldset>" + char(10)
		if cLegend != ""
			cHTML += "    <legend>" + htmlEscape(cLegend) + "</legend>"
		ok
		appendContent(cHTML)
		return self

	func closeFieldset
		appendContent("</fieldset>")
		return self

	# Button
	func addButton cText, cType
		appendContent('<button type="' + cType + '">' + htmlEscape(cText) + "</button>")
		return self

	func addButtonStyled cText, cType, aAttrs
		appendContent('<button type="' + cType + '"' + htmlBuildAttrs(aAttrs) + ">" + htmlEscape(cText) + "</button>")
		return self

	# ====================================================================
	# Container / Structure Elements
	# ====================================================================

	func openDiv aAttrs
		appendContent("<div" + htmlBuildAttrs(aAttrs) + ">")
		nIndentLevel++
		return self

	func closeDiv
		nIndentLevel--
		appendContent("</div>")
		return self

	func openSection aAttrs
		appendContent("<section" + htmlBuildAttrs(aAttrs) + ">")
		nIndentLevel++
		return self

	func closeSection
		nIndentLevel--
		appendContent("</section>")
		return self

	func openArticle aAttrs
		appendContent("<article" + htmlBuildAttrs(aAttrs) + ">")
		nIndentLevel++
		return self

	func closeArticle
		nIndentLevel--
		appendContent("</article>")
		return self

	func openAside aAttrs
		appendContent("<aside" + htmlBuildAttrs(aAttrs) + ">")
		nIndentLevel++
		return self

	func closeAside
		nIndentLevel--
		appendContent("</aside>")
		return self

	func openMain aAttrs
		appendContent("<main" + htmlBuildAttrs(aAttrs) + ">")
		nIndentLevel++
		return self

	func closeMain
		nIndentLevel--
		appendContent("</main>")
		return self

	func openHeader aAttrs
		appendContent("<header" + htmlBuildAttrs(aAttrs) + ">")
		nIndentLevel++
		return self

	func closeHeader
		nIndentLevel--
		appendContent("</header>")
		return self

	func openFooter aAttrs
		appendContent("<footer" + htmlBuildAttrs(aAttrs) + ">")
		nIndentLevel++
		return self

	func closeFooter
		nIndentLevel--
		appendContent("</footer>")
		return self

	func openNav aAttrs
		appendContent("<nav" + htmlBuildAttrs(aAttrs) + ">")
		nIndentLevel++
		return self

	func closeNav
		nIndentLevel--
		appendContent("</nav>")
		return self

	# Generic open/close for any tag
	func openTag cTag, aAttrs
		appendContent("<" + cTag + htmlBuildAttrs(aAttrs) + ">")
		nIndentLevel++
		return self

	func closeTag cTag
		nIndentLevel--
		appendContent("</" + cTag + ">")
		return self

	# Self-closing tag
	func addSelfClosingTag cTag, aAttrs
		appendContent("<" + cTag + htmlBuildAttrs(aAttrs) + ">")
		return self

	# ====================================================================
	# Layout Helpers
	# ====================================================================

	# Flex container
	func openFlex cDirection, cJustify, cAlignItems
		cStyle = "display: flex"
		if cDirection != "" cStyle += "; flex-direction: " + cDirection ok
		if cJustify != "" cStyle += "; justify-content: " + cJustify ok
		if cAlignItems != "" cStyle += "; align-items: " + cAlignItems ok
		appendContent('<div style="' + cStyle + '">')
		nIndentLevel++
		return self

	func closeFlex
		nIndentLevel--
		appendContent("</div>")
		return self

	# Grid container
	func openGrid cColumns, cGap
		cStyle = "display: grid; grid-template-columns: " + cColumns
		if cGap != "" cStyle += "; gap: " + cGap ok
		appendContent('<div style="' + cStyle + '">')
		nIndentLevel++
		return self

	func closeGrid
		nIndentLevel--
		appendContent("</div>")
		return self

	# Two-column layout
	func openTwoColumns cLeftWidth, cRightWidth, cGap
		cStyle = "display: grid; grid-template-columns: " + cLeftWidth + " " + cRightWidth
		if cGap != "" cStyle += "; gap: " + cGap ok
		appendContent('<div style="' + cStyle + '">')
		nIndentLevel++
		return self

	func closeTwoColumns
		nIndentLevel--
		appendContent("</div>")
		return self

	# ====================================================================
	# UI Components
	# ====================================================================

	# Navigation bar
	# items: [["Home", "/"], ["About", "/about"], ["Contact", "/contact"]]
	func addNavbar cBrand, aItems, aOptions
		cNavClass = htmlGetOpt(aOptions, "class", "navbar")
		cBGColor = htmlGetOpt(aOptions, "bgColor", "#333")
		cTextColor = htmlGetOpt(aOptions, "textColor", "#fff")

		cHTML = '<nav class="' + cNavClass + '">' + char(10)
		if cBrand != ""
			cHTML += '    <div class="navbar-brand">' + htmlEscape(cBrand) + "</div>" + char(10)
		ok
		cHTML += '    <ul class="navbar-links">' + char(10)
		nItemLen = len(aItems)
		for nItem = 1 to nItemLen
			cHTML += '        <li><a href="' + aItems[nItem][2] + '">' + htmlEscape(aItems[nItem][1]) + "</a></li>" + char(10)
		next
		cHTML += "    </ul>" + char(10)
		cHTML += "</nav>"
		appendContent(cHTML)

		# Auto-generate navbar CSS
		addCSSRule("." + cNavClass, [
			["display", "flex"],
			["justify-content", "space-between"],
			["align-items", "center"],
			["padding", "0 20px"],
			["background-color", cBGColor],
			["color", cTextColor]
		])
		addCSSRule("." + cNavClass + " .navbar-brand", [
			["font-size", "1.5rem"],
			["font-weight", "bold"],
			["padding", "15px 0"]
		])
		addCSSRule("." + cNavClass + " .navbar-links", [
			["display", "flex"],
			["list-style", "none"],
			["margin", "0"],
			["padding", "0"],
			["gap", "5px"]
		])
		addCSSRule("." + cNavClass + " .navbar-links a", [
			["color", cTextColor],
			["text-decoration", "none"],
			["padding", "15px 12px"],
			["display", "block"],
			["transition", "background-color 0.3s"]
		])
		addCSSRule("." + cNavClass + " .navbar-links a:hover", [
			["background-color", "rgba(255,255,255,0.1)"]
		])
		return self

	# Card component
	func addCard cTitleText, cBody, aOptions
		cCardClass = htmlGetOpt(aOptions, "class", "card")
		cCardImage = htmlGetOpt(aOptions, "image", "")
		cCardFooter = htmlGetOpt(aOptions, "footer", "")

		cHTML = '<div class="' + cCardClass + '">' + char(10)
		if cCardImage != ""
			cHTML += '    <img src="' + cCardImage + '" alt="" class="card-img">' + char(10)
		ok
		cHTML += '    <div class="card-body">' + char(10)
		if cTitleText != ""
			cHTML += '        <h3 class="card-title">' + htmlEscape(cTitleText) + "</h3>" + char(10)
		ok
		cHTML += "        <p>" + htmlEscape(cBody) + "</p>" + char(10)
		if cCardFooter != ""
			cHTML += '        <div class="card-footer">' + cCardFooter + "</div>" + char(10)
		ok
		cHTML += "    </div>" + char(10)
		cHTML += "</div>"
		appendContent(cHTML)

		# Auto-generate card CSS if first time
		addCSSRule("." + cCardClass, [
			["border", "1px solid #dee2e6"],
			["border-radius", "8px"],
			["overflow", "hidden"],
			["background-color", "#fff"],
			["box-shadow", "0 2px 4px rgba(0,0,0,0.1)"],
			["transition", "box-shadow 0.3s"]
		])
		addCSSRule("." + cCardClass + ":hover", [
			["box-shadow", "0 4px 12px rgba(0,0,0,0.15)"]
		])
		addCSSRule("." + cCardClass + " .card-img", [
			["width", "100%"],
			["display", "block"]
		])
		addCSSRule("." + cCardClass + " .card-body", [
			["padding", "16px"]
		])
		addCSSRule("." + cCardClass + " .card-title", [
			["margin", "0 0 8px 0"],
			["font-size", "1.25rem"]
		])
		addCSSRule("." + cCardClass + " .card-footer", [
			["margin-top", "12px"],
			["padding-top", "12px"],
			["border-top", "1px solid #eee"]
		])
		return self

	# Alert / notification
	func addAlert cMessage, cType
		aColors = [
			:success = ["#d4edda", "#155724", "#c3e6cb"],
			:danger  = ["#f8d7da", "#721c24", "#f5c6cb"],
			:warning = ["#fff3cd", "#856404", "#ffeeba"],
			:info    = ["#d1ecf1", "#0c5460", "#bee5eb"],
			:primary = ["#cce5ff", "#004085", "#b8daff"]
		]
		aColorSet = aColors[cType]
		if aColorSet = NULL aColorSet = aColors[:info] ok

		cStyle = "padding: 12px 20px; border-radius: 4px; margin: 10px 0"
		cStyle += "; background-color: " + aColorSet[1]
		cStyle += "; color: " + aColorSet[2]
		cStyle += "; border: 1px solid " + aColorSet[3]

		appendContent('<div style="' + cStyle + '" role="alert">' + htmlEscape(cMessage) + "</div>")
		return self

	# Badge
	func addBadge cText, cBGColor, cTextColor
		cStyle = "display: inline-block; padding: 3px 8px; border-radius: 12px; font-size: 0.75rem; font-weight: 600"
		cStyle += "; background-color: " + cBGColor
		cStyle += "; color: " + cTextColor
		appendContent('<span style="' + cStyle + '">' + htmlEscape(cText) + "</span>")
		return self

	# Progress bar
	func addProgressBar nPercent, cColor, cHeight
		cOuterStyle = "background-color: #e9ecef; border-radius: 4px; overflow: hidden"
		if cHeight != "" cOuterStyle += "; height: " + cHeight ok
		cInnerStyle = "height: 100%; min-height: 20px; width: " + nPercent + "%"
		cInnerStyle += "; background-color: " + cColor
		cInnerStyle += "; transition: width 0.3s"

		cHTML = '<div style="' + cOuterStyle + '">'
		cHTML += '<div style="' + cInnerStyle + '"></div>'
		cHTML += "</div>"
		appendContent(cHTML)
		return self

	# Breadcrumbs
	# items: [["Home", "/"], ["Products", "/products"], ["Item", ""]]
	func addBreadcrumbs aItems
		cHTML = '<nav aria-label="breadcrumb"><ol style="list-style: none; display: flex; gap: 8px; padding: 0; margin: 10px 0">'
		nItemLen = len(aItems)
		for nItem = 1 to nItemLen
			if nItem = nItemLen
				cHTML += '<li style="color: #6c757d">' + htmlEscape(aItems[nItem][1]) + "</li>"
			else
				cHTML += '<li><a href="' + aItems[nItem][2] + '">' + htmlEscape(aItems[nItem][1]) + '</a> <span style="color: #ccc">/</span></li>'
			ok
		next
		cHTML += "</ol></nav>"
		appendContent(cHTML)
		return self

	# Pagination
	func addPagination nCurrentPage, nTotalPages, cBaseURL
		cHTML = '<nav aria-label="pagination"><ul style="list-style: none; display: flex; gap: 4px; padding: 0">'
		for nPage = 1 to nTotalPages
			if nPage = nCurrentPage
				cHTML += '<li><span style="padding: 6px 12px; background: #007bff; color: #fff; border-radius: 4px">' + nPage + "</span></li>"
			else
				cURL = cBaseURL + "?page=" + nPage
				cHTML += '<li><a href="' + cURL + '" style="padding: 6px 12px; border: 1px solid #dee2e6; border-radius: 4px; text-decoration: none; color: #007bff">' + nPage + "</a></li>"
			ok
		next
		cHTML += "</ul></nav>"
		appendContent(cHTML)
		return self

	# Accordion (uses <details>/<summary> — no JS required)
	func addAccordion aItems
		cHTML = ""
		nItemLen = len(aItems)
		for nItem = 1 to nItemLen
			cHTML += '<details style="border: 1px solid #dee2e6; border-radius: 4px; margin-bottom: 4px">' + char(10)
			cHTML += '    <summary style="padding: 12px 16px; cursor: pointer; font-weight: 600; background: #f8f9fa">' + htmlEscape(aItems[nItem][1]) + "</summary>" + char(10)
			cHTML += '    <div style="padding: 12px 16px">' + htmlEscape(aItems[nItem][2]) + "</div>" + char(10)
			cHTML += "</details>" + char(10)
		next
		appendContent(cHTML)
		return self

	# Tabs (CSS-only using radio buttons)
	func addTabs cTabId, aTabs
		cHTML = '<div class="tabs-' + cTabId + '">' + char(10)
		nTabLen = len(aTabs)
		# Radio buttons (hidden) + labels
		for nTab = 1 to nTabLen
			cChecked = ""
			if nTab = 1 cChecked = " checked" ok
			cRid = cTabId + "-tab-" + nTab
			cHTML += '<input type="radio" name="' + cTabId + '" id="' + cRid + '"' + cChecked + ' class="tab-radio">' + char(10)
		next
		cHTML += '<div class="tab-labels">' + char(10)
		for nTab = 1 to nTabLen
			cRid = cTabId + "-tab-" + nTab
			cHTML += '    <label for="' + cRid + '">' + htmlEscape(aTabs[nTab][1]) + "</label>" + char(10)
		next
		cHTML += "</div>" + char(10)
		for nTab = 1 to nTabLen
			cHTML += '<div class="tab-content">' + htmlEscape(aTabs[nTab][2]) + "</div>" + char(10)
		next
		cHTML += "</div>"
		appendContent(cHTML)

		# CSS for tabs
		addRawCSS(".tabs-" + cTabId + " .tab-radio { display: none; }")
		addRawCSS(".tabs-" + cTabId + " .tab-labels { display: flex; border-bottom: 2px solid #dee2e6; }")
		addRawCSS(".tabs-" + cTabId + " .tab-labels label { padding: 10px 20px; cursor: pointer; border-bottom: 2px solid transparent; margin-bottom: -2px; transition: all 0.3s; }")
		addRawCSS(".tabs-" + cTabId + " .tab-labels label:hover { background: #f8f9fa; }")
		addRawCSS(".tabs-" + cTabId + " .tab-content { display: none; padding: 16px; }")
		# Show correct tab content based on checked radio
		for nTab = 1 to nTabLen
			cRid = cTabId + "-tab-" + nTab
			addRawCSS("#" + cRid + ":checked ~ .tab-labels label[for='" + cRid + "'] { border-bottom-color: #007bff; color: #007bff; font-weight: 600; }")
			addRawCSS("#" + cRid + ":checked ~ .tab-content:nth-of-type(" + nTab + ") { display: block; }")
		next
		return self

	# Modal dialog (CSS-only using :target)
	func addModal cID, cTitleText, cBody
		cHTML = '<div id="' + cID + '" class="modal-overlay">' + char(10)
		cHTML += '    <div class="modal-content">' + char(10)
		cHTML += '        <a href="#" class="modal-close">&times;</a>' + char(10)
		if cTitleText != ""
			cHTML += '        <h3 class="modal-title">' + htmlEscape(cTitleText) + "</h3>" + char(10)
		ok
		cHTML += '        <div class="modal-body">' + htmlEscape(cBody) + "</div>" + char(10)
		cHTML += "    </div>" + char(10)
		cHTML += "</div>"
		appendContent(cHTML)

		# Modal CSS
		addCSSRule(".modal-overlay", [
			["display", "none"],
			["position", "fixed"],
			["top", "0"],
			["left", "0"],
			["width", "100%"],
			["height", "100%"],
			["background-color", "rgba(0,0,0,0.5)"],
			["z-index", "1000"],
			["justify-content", "center"],
			["align-items", "center"]
		])
		addCSSRule(".modal-overlay:target", [
			["display", "flex"]
		])
		addCSSRule(".modal-content", [
			["background", "#fff"],
			["border-radius", "8px"],
			["padding", "24px"],
			["max-width", "500px"],
			["width", "90%"],
			["position", "relative"],
			["box-shadow", "0 10px 40px rgba(0,0,0,0.2)"]
		])
		addCSSRule(".modal-close", [
			["position", "absolute"],
			["top", "12px"],
			["right", "16px"],
			["font-size", "1.5rem"],
			["text-decoration", "none"],
			["color", "#666"]
		])
		addCSSRule(".modal-title", [
			["margin", "0 0 16px 0"]
		])

		return self

	# Button to open modal
	func addModalButton cText, cModalId, aAttrs
		appendContent('<a href="#' + cModalId + '"' + htmlBuildAttrs(aAttrs) + ">" + htmlEscape(cText) + "</a>")
		return self

	# Tooltip (CSS-only)
	func addTooltip cText, cTipText
		cHTML = '<span class="tooltip-wrap">' + htmlEscape(cText)
		cHTML += '<span class="tooltip-text">' + htmlEscape(cTipText) + "</span>"
		cHTML += "</span>"
		appendContent(cHTML)

		addCSSRule(".tooltip-wrap", [
			["position", "relative"],
			["cursor", "help"],
			["border-bottom", "1px dotted #999"]
		])
		addCSSRule(".tooltip-text", [
			["display", "none"],
			["position", "absolute"],
			["bottom", "125%"],
			["left", "50%"],
			["transform", "translateX(-50%)"],
			["background-color", "#333"],
			["color", "#fff"],
			["padding", "6px 10px"],
			["border-radius", "4px"],
			["font-size", "0.8rem"],
			["white-space", "nowrap"],
			["z-index", "100"]
		])
		addCSSRule(".tooltip-wrap:hover .tooltip-text", [
			["display", "block"]
		])
		return self

	# ====================================================================
	# RTL / Arabic Support
	# ====================================================================

	# Set entire document to RTL
	func setRTL
		cDir = "rtl"
		cLang = "ar"
		return self

	# Add RTL paragraph
	func addRTLParagraph cText
		appendContent('<p dir="rtl" style="text-align: right">' + htmlEscape(cText) + "</p>")
		return self

	# Add Bidi text (auto-detected direction)
	func addBidiText cText
		appendContent('<p dir="auto">' + htmlEscape(cText) + "</p>")
		return self

	# Open RTL section
	func openRTLDiv aAttrs
		aAllAttrs = [:dir = "rtl"]
		nAttrLen = len(aAttrs)
		for nAttr = 1 to nAttrLen
			aAllAttrs + aAttrs[nAttr]
		next
		appendContent("<div" + htmlBuildAttrs(aAllAttrs) + ">")
		nIndentLevel++
		return self

	func closeRTLDiv
		nIndentLevel--
		appendContent("</div>")
		return self

	# ====================================================================
	# Utility / Common Patterns
	# ====================================================================

	# Auto-generate unique ID string
	func getAutoId
		nAutoId += 1
		return "" + nAutoId

	# Add spacer
	func addSpacer cHeight
		appendContent('<div style="height: ' + cHeight + '"></div>')
		return self

	# Add a comment
	func addComment cText
		appendContent("<!-- " + cText + " -->")
		return self

	# Add a data attribute wrapper (for JS frameworks)
	func addDataDiv aAttrs, aDataAttrs
		cAttrsStr = htmlBuildAttrs(aAttrs)
		nDataAttrLen = len(aDataAttrs)
		for nDataAttr = 1 to nDataAttrLen
			cKey = aDataAttrs[nDataAttr][1]
			cKey = substr(cKey, ":", "")
			cAttrsStr += ' data-' + cKey + '="' + aDataAttrs[nDataAttr][2] + '"'
		next
		appendContent("<div" + cAttrsStr + ">")
		nIndentLevel++
		return self

	# ====================================================================
	# JavaScript Integration
	# ====================================================================

	# Add inline script at current position in body
	func addInlineScript cJS
		appendContent("<script>" + char(10) + cJS + char(10) + "</script>")
		return self

	# Add script with defer attribute
	func addDeferScript cSrc
		aScriptsSrc + cSrc
		return self

	# Add script with async attribute (loaded at body end)
	func addAsyncScript cSrc
		appendContent('<script src="' + cSrc + '" async></script>')
		return self

	# Add script module (ES6)
	func addModuleScript cJS
		appendContent('<script type="module">' + char(10) + cJS + char(10) + '</script>')
		return self

	# Add external module script
	func addModuleScriptSrc cSrc
		appendContent('<script type="module" src="' + cSrc + '"></script>')
		return self

	# Add a noscript fallback
	func addNoScript cHTML
		appendContent("<noscript>" + cHTML + "</noscript>")
		return self

	# ---- Event Handlers ----

	# Add element with onclick handler
	func addClickButton cText, cJSCode, aOptions
		cCls = htmlGetOpt(aOptions, "class", "")
		cID = htmlGetOpt(aOptions, "id", "")
		cStyle = htmlGetOpt(aOptions, "style", "")
		cAttrs = ""
		if cCls != "" cAttrs += ' class="' + cCls + '"' ok
		if cID != "" cAttrs += ' id="' + cID + '"' ok
		if cStyle != "" cAttrs += ' style="' + cStyle + '"' ok
		appendContent('<button onclick="' + htmlEscape(cJSCode) + '"' + cAttrs + '>' + htmlEscape(cText) + '</button>')
		return self

	# Add element with any event handler
	func addEventElement cTag, cContent, cEvent, cJSCode, aAttrs
		cAttrsStr = htmlBuildAttrs(aAttrs)
		appendContent('<' + cTag + ' on' + cEvent + '="' + htmlEscape(cJSCode) + '"' + cAttrsStr + '>' + cContent + '</' + cTag + '>')
		return self

	# ---- DOM Targeting ----

	# Add element with ID (for JS targeting)
	func addElementById cTag, cID, cContent, aAttrs
		cAttrsStr = htmlBuildAttrs(aAttrs)
		appendContent('<' + cTag + ' id="' + cID + '"' + cAttrsStr + '>' + cContent + '</' + cTag + '>')
		return self

	# Add div with ID
	func addDivById cID, cContent
		appendContent('<div id="' + cID + '">' + cContent + '</div>')
		return self

	# Open div with ID
	func openDivById cID
		appendContent('<div id="' + cID + '">')
		nIndentLevel++
		return self

	func openDivByIdClass cID, cCls
		appendContent('<div id="' + cID + '" class="' + cCls + '">')
		nIndentLevel++
		return self

	# Open div with class
	func openDivByClass cCls
		appendContent('<div class="' + cCls + '">')
		nIndentLevel++
		return self

	# Add empty container for JS to populate
	func addJSPlaceholder cID, cTag
		appendContent('<' + cTag + ' id="' + cID + '"></' + cTag + '>')
		return self

	# ---- JavaScript Component Builders ----

	# Counter component
	func addJSCounter cID, cLabel, cStartVal, aOptions
		cBtnStyle = htmlGetOpt(aOptions, "btnStyle", "padding:8px 16px;font-size:1.1rem;cursor:pointer;border:1px solid #ccc;border-radius:4px;background:#fff")
		cValStyle = htmlGetOpt(aOptions, "valStyle", "display:inline-block;min-width:60px;text-align:center;font-size:1.5rem;font-weight:bold;padding:0 15px")

		cHTML = '<div style="display:flex;align-items:center;gap:5px;margin:10px 0">'
		if cLabel != "" cHTML += '<span style="margin-right:10px">' + htmlEscape(cLabel) + '</span>' ok
		cHTML += '<button style="' + cBtnStyle + '" onclick="document.getElementById(' + HTML_SQ + cID + HTML_SQ + ').textContent=parseInt(document.getElementById(' + HTML_SQ + cID + HTML_SQ + ').textContent)-1">&#8722;</button>'
		cHTML += '<span id="' + cID + '" style="' + cValStyle + '">' + cStartVal + '</span>'
		cHTML += '<button style="' + cBtnStyle + '" onclick="document.getElementById(' + HTML_SQ + cID + HTML_SQ + ').textContent=parseInt(document.getElementById(' + HTML_SQ + cID + HTML_SQ + ').textContent)+1">+</button>'
		cHTML += '</div>'
		appendContent(cHTML)
		return self

	# Toggle visibility
	func addJSToggle cButtonText, cContentId, cContentHTML, aOptions
		cBtnClass = htmlGetOpt(aOptions, "btnClass", "")
		cBtnStyle = htmlGetOpt(aOptions, "btnStyle", "padding:8px 20px;cursor:pointer;border:1px solid #ccc;border-radius:4px;background:#fff;margin:5px 0")

		cBtnAttrs = ""
		if cBtnClass != "" cBtnAttrs = ' class="' + cBtnClass + '"' ok

		cJSCode = "var e=document.getElementById(" + HTML_SQ + cContentId + HTML_SQ + ");e.style.display=e.style.display===" + HTML_SQ + "none" + HTML_SQ + "?" + HTML_SQ + "block" + HTML_SQ + ":" + HTML_SQ + "none" + HTML_SQ
		appendContent('<button style="' + cBtnStyle + '"' + cBtnAttrs + ' onclick="' + cJSCode + '">' + htmlEscape(cButtonText) + '</button>')
		appendContent('<div id="' + cContentId + '" style="display:none">' + cContentHTML + '</div>')
		return self

	# Tabs (JS-powered, more flexible than CSS-only)
	func addJSTabs cTabId, aTabs
		# Tab buttons
		cHTML = '<div class="js-tabs" id="' + cTabId + '">' + HTML_LF
		cHTML += '<div class="js-tab-buttons" style="display:flex;border-bottom:2px solid #ddd;margin-bottom:15px">' + HTML_LF
		nTabLen = len(aTabs)
		for nTab = 1 to nTabLen
			cActive = ""
			if nTab = 1 cActive = " js-tab-active" ok
			cHTML += '  <button class="js-tab-btn' + cActive + '" data-tab="' + cTabId + '-panel-' + nTab + '" style="padding:10px 20px;border:none;background:none;cursor:pointer;border-bottom:2px solid transparent;margin-bottom:-2px;font-size:1rem" onclick="'
			cHTML += "var btns=this.parentElement.querySelectorAll(''.js-tab-btn'');btns.forEach(function(b){b.classList.remove(''js-tab-active'');b.style.borderBottomColor=''transparent''});this.classList.add(''js-tab-active'');this.style.borderBottomColor=''var(--primary,#007bff)'';"
			cHTML += "var panels=this.parentElement.parentElement.querySelectorAll(''.js-tab-panel'');panels.forEach(function(p){p.style.display=''none''});document.getElementById(this.getAttribute(''data-tab'')).style.display=''block''"
			cHTML += '">' + htmlEscape(aTabs[nTab][1]) + '</button>' + HTML_LF
		next
		cHTML += '</div>' + HTML_LF

		# Tab panels
		for nTab = 1 to nTabLen
			cDisp = "none"
			if nTab = 1 cDisp = "block" ok
			cHTML += '<div class="js-tab-panel" id="' + cTabId + '-panel-' + nTab + '" style="display:' + cDisp + '">' + aTabs[nTab][2] + '</div>' + HTML_LF
		next
		cHTML += '</div>'
		appendContent(cHTML)

		# Style active tab
		addRawCSS(".js-tab-active { border-bottom-color: var(--primary, #007bff) !important; font-weight: 600; }")
		return self

	# Image slideshow / carousel (JS)
	func addJSSlideshow cID, aImages, aOptions
		cInterval = htmlGetOpt(aOptions, "interval", "3000")
		cHeight = htmlGetOpt(aOptions, "height", "400px")
		lShowDots = htmlGetOpt(aOptions, "dots", true)
		lShowArrows = htmlGetOpt(aOptions, "arrows", true)

		nImageLen = len(aImages)

		cHTML = '<div id="' + cID + '" style="position:relative;width:100%;max-width:100%;overflow:hidden;border-radius:var(--radius,8px)">' + HTML_LF
		# Slides
		for nImage = 1 to nImageLen
			cDisp = "none"
			if nImage = 1 cDisp = "block" ok
			cHTML += '  <div class="' + cID + '-slide" style="display:' + cDisp + '">'
			cHTML += '<img src="' + aImages[nImage][1] + '" alt="' + htmlEscape(aImages[nImage][2]) + '" style="width:100%;height:' + cHeight + ';object-fit:cover;display:block">'
			cHTML += '</div>' + HTML_LF
		next

		# Arrows
		if lShowArrows
			cArrowStyle = "position:absolute;top:50%;transform:translateY(-50%);background:rgba(0,0,0,0.5);color:#fff;border:none;padding:12px 16px;cursor:pointer;font-size:1.2rem;z-index:2;border-radius:4px"
			cHTML += '  <button onclick="slideNav(' + HTML_SQ + cID + HTML_SQ + ',-1)" style="left:10px;' + cArrowStyle + '">&#10094;</button>' + HTML_LF
			cHTML += '  <button onclick="slideNav(' + HTML_SQ + cID + HTML_SQ + ',1)" style="right:10px;' + cArrowStyle + '">&#10095;</button>' + HTML_LF
		ok

		# Dots
		if lShowDots
			cHTML += '  <div style="text-align:center;padding:10px;position:absolute;bottom:10px;width:100%">' + HTML_LF
			for nImage = 1 to nImageLen
				cHTML += '    <span class="' + cID + '-dot" onclick="slideGo(' + HTML_SQ + cID + HTML_SQ + ',' + nImage + ')" style="height:12px;width:12px;margin:0 4px;background:rgba(255,255,255,0.5);border-radius:50%;display:inline-block;cursor:pointer"></span>' + HTML_LF
			next
			cHTML += '  </div>' + HTML_LF
		ok
		cHTML += '</div>'
		appendContent(cHTML)

		# Slideshow JS
		cJS = 'var slideData=slideData||{};' + HTML_LF
		cJS += 'slideData["' + cID + '"]={current:1,total:' + nImageLen + ',timer:null};' + HTML_LF
		cJS += 'function slideNav(id,dir){var d=slideData[id];d.current+=dir;if(d.current>d.total)d.current=1;if(d.current<1)d.current=d.total;slideGo(id,d.current);}' + HTML_LF
		cJS += 'function slideGo(id,n){var d=slideData[id];d.current=n;var slides=document.querySelectorAll("."+id+"-slide");slides.forEach(function(s){s.style.display="none"});slides[n-1].style.display="block";var dots=document.querySelectorAll("."+id+"-dot");dots.forEach(function(dt){dt.style.background="rgba(255,255,255,0.5)"});if(dots.length)dots[n-1].style.background="#fff";if(d.timer)clearInterval(d.timer);d.timer=setInterval(function(){slideNav(id,1)},' + cInterval + ');}' + HTML_LF
		cJS += 'slideData["' + cID + '"].timer=setInterval(function(){slideNav("' + cID + '",1)},' + cInterval + ');' + HTML_LF
		cJS += '(function(){var dots=document.querySelectorAll(".' + cID + '-dot");if(dots.length)dots[0].style.background="#fff"})();'
		addBodyScript(cJS)
		return self

	# Countdown timer
	func addJSCountdown cID, cTargetDate, aOptions
		cLblStyle = htmlGetOpt(aOptions, "labelStyle", "font-size:0.8rem;color:var(--text-muted,#666)")
		cNumStyle = htmlGetOpt(aOptions, "numStyle", "font-size:2.5rem;font-weight:700")
		cContainerStyle = htmlGetOpt(aOptions, "style", "display:flex;justify-content:center;gap:20px;padding:20px;text-align:center")

		cHTML = '<div id="' + cID + '" style="' + cContainerStyle + '">'
		cHTML += '<div><div id="' + cID + '-d" style="' + cNumStyle + '">00</div><div style="' + cLblStyle + '">Days</div></div>'
		cHTML += '<div><div id="' + cID + '-h" style="' + cNumStyle + '">00</div><div style="' + cLblStyle + '">Hours</div></div>'
		cHTML += '<div><div id="' + cID + '-m" style="' + cNumStyle + '">00</div><div style="' + cLblStyle + '">Minutes</div></div>'
		cHTML += '<div><div id="' + cID + '-s" style="' + cNumStyle + '">00</div><div style="' + cLblStyle + '">Seconds</div></div>'
		cHTML += '</div>'
		appendContent(cHTML)

		cJS = '(function(){' + HTML_LF
		cJS += '  var target=new Date("' + cTargetDate + '").getTime();' + HTML_LF
		cJS += '  setInterval(function(){' + HTML_LF
		cJS += '    var now=new Date().getTime(),diff=target-now;' + HTML_LF
		cJS += '    if(diff<0){document.getElementById("' + cID + '").innerHTML="<div style=\"font-size:1.5rem;font-weight:700;text-align:center\">Event Started!</div>";return;}' + HTML_LF
		cJS += '    document.getElementById("' + cID + '-d").textContent=Math.floor(diff/86400000);' + HTML_LF
		cJS += '    document.getElementById("' + cID + '-h").textContent=Math.floor((diff%86400000)/3600000);' + HTML_LF
		cJS += '    document.getElementById("' + cID + '-m").textContent=Math.floor((diff%3600000)/60000);' + HTML_LF
		cJS += '    document.getElementById("' + cID + '-s").textContent=Math.floor((diff%60000)/1000);' + HTML_LF
		cJS += '  },1000);' + HTML_LF
		cJS += '})();'
		addBodyScript(cJS)
		return self

	# Typing animation effect
	func addJSTypingEffect cID, cText, aOptions
		cSpeed = htmlGetOpt(aOptions, "speed", "50")
		cTag = htmlGetOpt(aOptions, "tag", "p")
		cStyle = htmlGetOpt(aOptions, "style", "")
		lCursor = htmlGetOpt(aOptions, "cursor", true)

		cStyleAttr = ""
		if cStyle != "" cStyleAttr = ' style="' + cStyle + '"' ok

		appendContent('<' + cTag + ' id="' + cID + '"' + cStyleAttr + '></' + cTag + '>')

		cCursorCSS = ""
		if lCursor
			# Build JS that creates a <style> for blinking cursor
			# Ring single-quoted string, JS uses double quotes, CSS content uses backslash-escaped quotes
			# Output: var st=document.createElement("style");st.textContent="#id::after{content:'|';...}";document.head.appendChild(st);
			cCursorCSS = 'var st=document.createElement(' + HTML_DQ + 'style' + HTML_DQ + ');st.textContent=' + HTML_DQ + '#' + cID + '::after{content:' + HTML_SQ + '|' + HTML_SQ + ';animation:blink 0.7s infinite}@keyframes blink{50%{opacity:0}}' + HTML_DQ + ';document.head.appendChild(st);'
		ok
		cJS = '(function(){' + HTML_LF
		cJS += '  var txt="' + cText + '",i=0,el=document.getElementById("' + cID + '");' + HTML_LF
		if lCursor cJS += '  ' + cCursorCSS + HTML_LF ok
		cJS += '  function type(){if(i<txt.length){el.textContent+=txt.charAt(i);i++;setTimeout(type,' + cSpeed + ')}}type();' + HTML_LF
		cJS += '})();'
		addBodyScript(cJS)
		return self

	# Scroll progress bar (top of page)
	func addJSScrollProgress aOptions
		cBGColor = htmlGetOpt(aOptions, "color", "var(--primary, #007bff)")
		cHeight = htmlGetOpt(aOptions, "height", "4px")

		appendContent('<div id="scroll-progress-bar" style="position:fixed;top:0;left:0;width:0%;height:' + cHeight + ';background:' + cBGColor + ';z-index:9999;transition:width 0.1s"></div>')

		cJS = 'window.addEventListener("scroll",function(){'
		cJS += 'var h=document.documentElement,b=document.body;'
		cJS += 'var st=h.scrollTop||b.scrollTop;'
		cJS += 'var sh=(h.scrollHeight||b.scrollHeight)-h.clientHeight;'
		cJS += 'document.getElementById("scroll-progress-bar").style.width=(st/sh*100)+"%"'
		cJS += '});'
		addBodyScript(cJS)
		return self

	# Dark mode toggle
	func addJSDarkModeToggle aOptions
		cBtnText = htmlGetOpt(aOptions, "label", "Toggle Dark Mode")
		cLightBg = htmlGetOpt(aOptions, "lightBg", "#ffffff")
		cDarkBg = htmlGetOpt(aOptions, "darkBg", "#121212")
		cLightText = htmlGetOpt(aOptions, "lightText", "#333333")
		cDarkText = htmlGetOpt(aOptions, "darkText", "#e0e0e0")
		cBtnStyle = htmlGetOpt(aOptions, "style", "position:fixed;bottom:20px;left:20px;padding:10px 18px;border:none;border-radius:20px;cursor:pointer;font-size:0.9rem;background:#333;color:#fff;z-index:999;box-shadow:0 2px 10px rgba(0,0,0,0.2)")

		appendContent('<button id="dark-mode-btn" style="' + cBtnStyle + '" onclick="toggleDarkMode()">' + htmlEscape(cBtnText) + '</button>')

		cJS = 'var isDark=false;' + HTML_LF
		cJS += 'function toggleDarkMode(){' + HTML_LF
		cJS += '  isDark=!isDark;' + HTML_LF
		cJS += '  document.body.style.backgroundColor=isDark?"' + cDarkBg + '":"' + cLightBg + '";' + HTML_LF
		cJS += '  document.body.style.color=isDark?"' + cDarkText + '":"' + cLightText + '";' + HTML_LF
		cJS += '  document.getElementById("dark-mode-btn").textContent=isDark?"Light Mode":"' + cBtnText + '";' + HTML_LF
		cJS += '  document.getElementById("dark-mode-btn").style.background=isDark?"#ddd":"#333";' + HTML_LF
		cJS += '  document.getElementById("dark-mode-btn").style.color=isDark?"#333":"#fff";' + HTML_LF
		cJS += '}'
		addBodyScript(cJS)
		return self

	# Smooth scroll to anchor links
	func addJSSmoothScroll
		cJS = "document.querySelectorAll(" + HTML_SQ + 'a[href^="#"]' + HTML_SQ + ").forEach(function(a){"
		cJS += 'a.addEventListener("click",function(e){'
		cJS += 'e.preventDefault();var t=document.querySelector(this.getAttribute("href"));'
		cJS += 'if(t)t.scrollIntoView({behavior:"smooth",block:"start"})'
		cJS += '})});'
		addBodyScript(cJS)
		return self

	# Back to top (JS-enhanced with show/hide on scroll)
	func addJSBackToTop aOptions
		cBGColor = htmlGetOpt(aOptions, "bg", "var(--primary, #333)")
		cTextColor = htmlGetOpt(aOptions, "color", "#fff")
		cThreshold = htmlGetOpt(aOptions, "threshold", "300")

		appendContent('<button id="js-back-to-top" onclick="window.scrollTo({top:0,behavior:' + HTML_SQ + 'smooth' + HTML_SQ + '})" style="display:none;position:fixed;bottom:30px;right:30px;width:45px;height:45px;background:' + cBGColor + ';color:' + cTextColor + ';border:none;border-radius:50%;font-size:1.3rem;cursor:pointer;box-shadow:0 3px 12px rgba(0,0,0,0.2);z-index:999;transition:opacity 0.3s">&uarr;</button>')

		cJS = 'window.addEventListener("scroll",function(){'
		cJS += 'var btn=document.getElementById("js-back-to-top");'
		cJS += 'btn.style.display=(window.scrollY>' + cThreshold + ')?"flex":"none"'
		cJS += '});'
		addBodyScript(cJS)
		return self

	# Lazy image loading
	func addLazyImage cSrc, cAlt, aAttrs
		cAttrsStr = htmlBuildAttrs(aAttrs)
		appendContent('<img data-src="' + cSrc + '" alt="' + htmlEscape(cAlt) + '" loading="lazy" style="opacity:0;transition:opacity 0.5s" onload="this.style.opacity=1"' + cAttrsStr + ' src="' + cSrc + '">')
		return self

	# ---- Form Validation ----

	# Add client-side form validation
	func addJSFormValidation cFormId, aRules
		cJS = 'document.getElementById("' + cFormId + '").addEventListener("submit",function(e){' + HTML_LF
		cJS += '  var valid=true,msg="";' + HTML_LF
		nRuleLen = len(aRules)
		for nRule = 1 to nRuleLen
			cField = aRules[nRule][1]
			cRuleType = aRules[nRule][2]
			cErrMsg = aRules[nRule][3]
			cJS += '  var f' + nRule + '=this.elements["' + cField + '"];' + HTML_LF
			if cRuleType = "required"
				cJS += '  if(!f' + nRule + '||!f' + nRule + '.value.trim()){valid=false;msg+="' + cErrMsg + '\\n";if(f' + nRule + ')f' + nRule + '.style.borderColor="red"}else{if(f' + nRule + ')f' + nRule + '.style.borderColor=""}' + HTML_LF
			but cRuleType = "email"
				cJS += '  if(f' + nRule + '&&f' + nRule + '.value&&!/^[^@]+@[^@]+\\.[^@]+$/.test(f' + nRule + '.value)){valid=false;msg+="' + cErrMsg + '\\n";f' + nRule + '.style.borderColor="red"}else{if(f' + nRule + ')f' + nRule + '.style.borderColor=""}' + HTML_LF
			but cRuleType = "minlength"
				cMinLen = aRules[nRule][4]
				cJS += '  if(f' + nRule + '&&f' + nRule + '.value.length<' + cMinLen + '){valid=false;msg+="' + cErrMsg + '\\n";f' + nRule + '.style.borderColor="red"}else{if(f' + nRule + ')f' + nRule + '.style.borderColor=""}' + HTML_LF
			but cRuleType = "pattern"
				cPattern = aRules[nRule][4]
				cJS += '  if(f' + nRule + '&&!/' + cPattern + '/.test(f' + nRule + '.value)){valid=false;msg+="' + cErrMsg + '\\n";f' + nRule + '.style.borderColor="red"}else{if(f' + nRule + ')f' + nRule + '.style.borderColor=""}' + HTML_LF
			ok
		next
		cJS += '  if(!valid){e.preventDefault();' + HTML_LF
		cJS += '    var errDiv=document.getElementById("' + cFormId + '-errors");' + HTML_LF
		cJS += '    if(!errDiv){errDiv=document.createElement("div");errDiv.id="' + cFormId + '-errors";errDiv.style.cssText="background:#fee;border:1px solid #fcc;color:#c33;padding:12px;border-radius:6px;margin-bottom:15px";this.insertBefore(errDiv,this.firstChild)}' + HTML_LF
		cJS += '    errDiv.innerHTML=msg.replace(/\\n/g,"<br>")}' + HTML_LF
		cJS += '  else{var errDiv=document.getElementById("' + cFormId + '-errors");if(errDiv)errDiv.remove()}' + HTML_LF
		cJS += '});'
		addBodyScript(cJS)
		return self

	# Live character counter for textarea/input
	func addJSCharCounter cInputId, nMaxChars
		cCounterId = cInputId + "-counter"
		appendContent('<div id="' + cCounterId + '" style="font-size:0.85rem;color:var(--text-muted,#666);margin-top:4px">0 / ' + nMaxChars + '</div>')

		cJS = 'document.getElementById("' + cInputId + '").addEventListener("input",function(){'
		cJS += 'var c=this.value.length;'
		cJS += 'var el=document.getElementById("' + cCounterId + '");'
		cJS += 'el.textContent=c+" / ' + nMaxChars + '";'
		cJS += 'el.style.color=c>' + nMaxChars + '?"red":"var(--text-muted,#666)"'
		cJS += '});'
		addBodyScript(cJS)
		return self

	# ---- Data Display Components ----

	# Dynamic search/filter for a list
	func addJSFilterList cID, aItems, aOptions
		cPlaceholder = htmlGetOpt(aOptions, "placeholder", "Search...")

		cHTML = '<div id="' + cID + '-wrap">' + HTML_LF
		cHTML += '<input type="text" id="' + cID + '-search" placeholder="' + htmlEscape(cPlaceholder) + '" style="width:100%;padding:10px;border:1px solid var(--border,#ddd);border-radius:var(--radius,6px);margin-bottom:10px;font-size:1rem;box-sizing:border-box">' + HTML_LF
		cHTML += '<ul id="' + cID + '-list" style="list-style:none;padding:0;margin:0">' + HTML_LF
		nItemLen = len(aItems)
		for nItem = 1 to nItemLen
			cHTML += '  <li style="padding:10px;border-bottom:1px solid var(--border,#eee)">' + htmlEscape(aItems[nItem]) + '</li>' + HTML_LF
		next
		cHTML += '</ul>' + HTML_LF
		cHTML += '<div id="' + cID + '-empty" style="display:none;padding:20px;text-align:center;color:var(--text-muted,#666)">No results found</div>' + HTML_LF
		cHTML += '</div>'
		appendContent(cHTML)

		cJS = 'document.getElementById("' + cID + '-search").addEventListener("input",function(){' + HTML_LF
		cJS += '  var q=this.value.toLowerCase(),items=document.querySelectorAll("#' + cID + '-list li"),shown=0;' + HTML_LF
		cJS += '  items.forEach(function(li){if(li.textContent.toLowerCase().indexOf(q)>-1){li.style.display="";shown++}else{li.style.display="none"}});' + HTML_LF
		cJS += '  document.getElementById("' + cID + '-empty").style.display=shown===0?"block":"none"' + HTML_LF
		cJS += '});'
		addBodyScript(cJS)
		return self

	# Sortable table (click header to sort)
	func addJSSortableTable cID, aData, aOptions
		cCls = htmlGetOpt(aOptions, "class", "")
		lStriped = htmlGetOpt(aOptions, "striped", true)
		lHover = htmlGetOpt(aOptions, "hover", true)

		nDataLen = len(aData)
		if nDataLen < 2 return self ok

		# Build table
		cHTML = '<table id="' + cID + '"'
		if cCls != "" cHTML += ' class="' + cCls + '"' ok
		cHTML += '>' + HTML_LF

		# Header
		nColLen = len(aData[1])
		cHTML += '<thead><tr>' + HTML_LF
		for nCol = 1 to nColLen
			cHTML += '  <th style="cursor:pointer;user-select:none" onclick="sortTable(' + HTML_SQ + cID + HTML_SQ + ',' + (nCol-1) + ')">' + htmlEscape("" + aData[1][nCol]) + ' <span style="opacity:0.4">&#8597;</span></th>' + HTML_LF
		next
		cHTML += '</tr></thead><tbody>' + HTML_LF

		# Body
		for nRow = 2 to nDataLen
			aRow = aData[nRow]
			cHTML += '<tr>' + HTML_LF
			for nCol = 1 to len(aRow)
				cHTML += '  <td>' + htmlEscape("" + aRow[nCol]) + '</td>' + HTML_LF
			next
			cHTML += '</tr>' + HTML_LF
		next
		cHTML += '</tbody></table>'
		appendContent(cHTML)

		# Striped/hover CSS
		if lStriped addRawCSS('#' + cID + ' tbody tr:nth-child(even){background-color:var(--bg-alt,#f8f9fa)}') ok
		if lHover addRawCSS('#' + cID + ' tbody tr:hover{background-color:#e9ecef}') ok

		# Sort JS (only add once)
		cJS = 'if(typeof sortTable==="undefined"){' + HTML_LF
		cJS += 'var sortDirs={};' + HTML_LF
		cJS += 'function sortTable(tid,col){' + HTML_LF
		cJS += '  var t=document.getElementById(tid),tbody=t.querySelector("tbody"),rows=Array.from(tbody.querySelectorAll("tr"));' + HTML_LF
		cJS += '  var key=tid+"-"+col;sortDirs[key]=!sortDirs[key];var asc=sortDirs[key];' + HTML_LF
		cJS += '  rows.sort(function(a,b){' + HTML_LF
		cJS += '    var va=a.cells[col].textContent.trim(),vb=b.cells[col].textContent.trim();' + HTML_LF
		cJS += '    var na=parseFloat(va),nb=parseFloat(vb);' + HTML_LF
		cJS += '    if(!isNaN(na)&&!isNaN(nb))return asc?na-nb:nb-na;' + HTML_LF
		cJS += '    return asc?va.localeCompare(vb):vb.localeCompare(va)' + HTML_LF
		cJS += '  });' + HTML_LF
		cJS += '  rows.forEach(function(r){tbody.appendChild(r)})' + HTML_LF
		cJS += '}}'
		addBodyScript(cJS)
		return self

	# Copy to clipboard button
	func addJSCopyButton cText, cContentToCopy, aOptions
		cBtnStyle = htmlGetOpt(aOptions, "style", "padding:8px 16px;cursor:pointer;border:1px solid #ccc;border-radius:4px;background:#fff")
		cSuccessText = htmlGetOpt(aOptions, "successText", "Copied!")

		cBtnId = "copy-btn-" + getAutoId()
		appendContent('<button id="' + cBtnId + '" style="' + cBtnStyle + '" onclick="copyClip(' + HTML_SQ + cBtnId + HTML_SQ + ',' + HTML_SQ + htmlEscape(cContentToCopy) + HTML_SQ + ')">' + htmlEscape(cText) + '</button>')

		cJS = 'if(typeof copyClip==="undefined"){function copyClip(bid,txt){navigator.clipboard.writeText(txt).then(function(){var b=document.getElementById(bid);var orig=b.textContent;b.textContent="Copied!";setTimeout(function(){b.textContent=orig},1500)})}}'
		addBodyScript(cJS)
		return self

	# Tooltip (JS-powered, works better than CSS-only)
	func addJSTooltip cText, cTipText, aOptions
		cPos = htmlGetOpt(aOptions, "position", "top")
		cBG = htmlGetOpt(aOptions, "bg", "#333")
		cColor = htmlGetOpt(aOptions, "color", "#fff")

		cTipId = "tip-" + getAutoId()
		appendContent('<span style="position:relative;cursor:help;border-bottom:1px dotted #999" onmouseenter="showTip(' + HTML_SQ + cTipId + HTML_SQ + ')" onmouseleave="hideTip(' + HTML_SQ + cTipId + HTML_SQ + ')"><span id="' + cTipId + '" style="display:none;position:absolute;' + cPos + ':-35px;left:50%;transform:translateX(-50%);background:' + cBG + ';color:' + cColor + ';padding:5px 10px;border-radius:4px;font-size:0.8rem;white-space:nowrap;z-index:100;pointer-events:none">' + htmlEscape(cTipText) + '</span>' + htmlEscape(cText) + '</span>')

		cJS = 'if(typeof showTip==="undefined"){function showTip(id){document.getElementById(id).style.display="block"}function hideTip(id){document.getElementById(id).style.display="none"}}'
		addBodyScript(cJS)
		return self

	# Notification / toast (JS)
	func addJSNotification aOptions
		cPosition = htmlGetOpt(aOptions, "position", "top-right")
		cPosStyle = "top:20px;right:20px"
		if cPosition = "top-left" cPosStyle = "top:20px;left:20px" ok
		if cPosition = "bottom-right" cPosStyle = "bottom:20px;right:20px" ok
		if cPosition = "bottom-left" cPosStyle = "bottom:20px;left:20px" ok

		appendContent('<div id="js-notify-area" style="position:fixed;' + cPosStyle + ';z-index:9999;display:flex;flex-direction:column;gap:10px;max-width:350px"></div>')

		cJS = 'function notify(msg,type,duration){' + HTML_LF
		cJS += '  type=type||"info";duration=duration||3000;' + HTML_LF
		cJS += '  var colors={success:"#d4edda",danger:"#f8d7da",warning:"#fff3cd",info:"#d1ecf1"};' + HTML_LF
		cJS += '  var textC={success:"#155724",danger:"#721c24",warning:"#856404",info:"#0c5460"};' + HTML_LF
		cJS += '  var d=document.createElement("div");' + HTML_LF
		cJS += '  d.style.cssText="padding:14px 20px;border-radius:6px;background:"+colors[type]+";color:"+textC[type]+";box-shadow:0 3px 12px rgba(0,0,0,0.15);transition:opacity 0.4s;font-size:0.95rem";' + HTML_LF
		cJS += '  d.textContent=msg;' + HTML_LF
		cJS += '  document.getElementById("js-notify-area").appendChild(d);' + HTML_LF
		cJS += '  setTimeout(function(){d.style.opacity="0";setTimeout(function(){d.remove()},400)},duration)' + HTML_LF
		cJS += '}'
		addBodyScript(cJS)
		return self

	# Collapsible sections (JS accordion-style)
	func addJSCollapsible cTitleText, cContentHTML, aOptions
		lIsOpen = htmlGetOpt(aOptions, "open", false)
		lIcon = htmlGetOpt(aOptions, "icon", true)

		cColId = "col-" + getAutoId()
		cDisp = "none"
		cArrow = "&#9654;"
		if lIsOpen cDisp = "block" cArrow = "&#9660;" ok


		# Build onclick JS: toggle panel and arrow
		cJSClick = "var c=document.getElementById(" + HTML_SQ + cColId + HTML_SQ + ");"
		cJSClick += "var a=this.querySelector(" + HTML_SQ + ".col-arrow" + HTML_SQ + ");"
		cJSClick += "if(c.style.display===" + HTML_SQ + "none" + HTML_SQ + "){c.style.display=" + HTML_SQ + "block" + HTML_SQ + ";a.innerHTML=" + HTML_SQ + "&#9660;" + HTML_SQ + "}"
		cJSClick += "else{c.style.display=" + HTML_SQ + "none" + HTML_SQ + ";a.innerHTML=" + HTML_SQ + "&#9654;" + HTML_SQ + "}"

		cHTML = '<div style="border:1px solid var(--border,#ddd);border-radius:var(--radius,6px);margin:8px 0;overflow:hidden">' + HTML_LF
		cHTML += '  <div style="padding:12px 16px;background:var(--bg-alt,#f5f5f5);cursor:pointer;display:flex;justify-content:space-between;align-items:center;user-select:none" onclick="' + cJSClick + '">'
		cHTML += '<span>' + htmlEscape(cTitleText) + '</span>'
		if lIcon cHTML += '<span class="col-arrow" style="font-size:0.8rem">' + cArrow + '</span>' ok
		cHTML += '</div>' + HTML_LF
		cHTML += '  <div id="' + cColId + '" style="display:' + cDisp + ';padding:16px;border-top:1px solid var(--border,#ddd)">' + cContentHTML + '</div>' + HTML_LF
		cHTML += '</div>'
		appendContent(cHTML)
		return self

	# Animated number counter (counts up from 0)
	func addJSAnimatedNumber cID, cTargetNumber, aOptions
		cDuration = htmlGetOpt(aOptions, "duration", "2000")
		cPrefix = htmlGetOpt(aOptions, "prefix", "")
		cSuffix = htmlGetOpt(aOptions, "suffix", "")
		cStyle = htmlGetOpt(aOptions, "style", "font-size:3rem;font-weight:700;color:var(--primary,#333)")

		appendContent('<span id="' + cID + '" style="' + cStyle + '">' + cPrefix + '0' + cSuffix + '</span>')

		cJS = '(function(){' + HTML_LF
		cJS += '  var el=document.getElementById("' + cID + '"),target=' + cTargetNumber + ',dur=' + cDuration + ';' + HTML_LF
		cJS += '  var start=null;' + HTML_LF
		cJS += '  function step(ts){' + HTML_LF
		cJS += '    if(!start)start=ts;var p=Math.min((ts-start)/dur,1);' + HTML_LF
		cJS += '    el.textContent="' + cPrefix + '"+Math.floor(p*target)+"' + cSuffix + '";' + HTML_LF
		cJS += '    if(p<1)requestAnimationFrame(step)' + HTML_LF
		cJS += '  }' + HTML_LF
		cJS += '  var obs=new IntersectionObserver(function(entries){if(entries[0].isIntersecting){requestAnimationFrame(step);obs.disconnect()}});' + HTML_LF
		cJS += '  obs.observe(el);' + HTML_LF
		cJS += '})();'
		addBodyScript(cJS)
		return self

	# Chart.js simple bar/line chart (requires addScript for Chart.js CDN)
	func addJSChart cID, cChartType, aLabels, aDatasets, aOptions
		cWidth = htmlGetOpt(aOptions, "width", "100%")
		cHeight = htmlGetOpt(aOptions, "height", "400px")
		cTitleText = htmlGetOpt(aOptions, "title", "")

		appendContent('<div style="width:' + cWidth + ';max-width:100%;margin:0 auto"><canvas id="' + cID + '" height="' + cHeight + '"></canvas></div>')

		cJS = '(function(){' + HTML_LF
		cJS += '  var ctx=document.getElementById("' + cID + '").getContext("2d");' + HTML_LF

		# Build labels
		cJS += '  var labels=['
		nLabelLen = len(aLabels)
		for nLabel = 1 to nLabelLen
			if nLabel > 1 cJS += ',' ok
			cJS += '"' + aLabels[nLabel] + '"'
		next
		cJS += '];' + HTML_LF

		# Build datasets
		cJS += '  var datasets=['
		nDatasetLen = len(aDatasets)
		for nDataset = 1 to nDatasetLen
			aDataset = aDatasets[nDataset]
			cDsLabel = aDataset[1]
			aDsData = aDataset[2]
			xDsColor = aDataset[3]
			if nDataset > 1 cJS += ',' ok
			cJS += '{label:"' + cDsLabel + '",data:['
			nDsDataLen = len(aDsData)
			for nValue = 1 to nDsDataLen
				if nValue > 1 cJS += ',' ok
				cJS += "" + aDsData[nValue]
			next
			cJS += '],'
			# Handle color: can be a string "#abc" or a list ["#a","#b","#c"]
			if islist(xDsColor)
				cJS += 'backgroundColor:['
				nDsColorLen = len(xDsColor)
				for nColor = 1 to nDsColorLen
					if nColor > 1 cJS += ',' ok
					cJS += '"' + xDsColor[nColor] + '"'
				next
				cJS += '],borderColor:['
				for nColor = 1 to nDsColorLen
					if nColor > 1 cJS += ',' ok
					cJS += '"' + xDsColor[nColor] + '"'
				next
				cJS += ']'
			else
				cJS += 'backgroundColor:"' + xDsColor + '",borderColor:"' + xDsColor + '"'
			ok
			cJS += ',borderWidth:2,fill:false}'
		next
		cJS += '];' + HTML_LF

		# Chart config
		cJS += '  new Chart(ctx,{type:"' + cChartType + '",data:{labels:labels,datasets:datasets},options:{responsive:true'
		if cTitleText != ""
			cJS += ',plugins:{title:{display:true,text:"' + cTitleText + '"}}'
		ok
		cJS += '}});' + HTML_LF
		cJS += '})();'
		addBodyScript(cJS)
		return self

	# Enable Chart.js CDN
	func enableChartJS
		addScript("https://cdn.jsdelivr.net/npm/chart.js")
		return self


	# ====================================================================
	# Three.js 3D Engine Integration
	# ====================================================================
	# Enables creating 3D scenes, games, and applications from Ring.
	# Usage: doc.enableThreeJS() then use threeJS*() methods.
	# Three.js r128 loaded from cdnjs.cloudflare.com
	# ====================================================================

	# Enable Three.js CDN (r128)
	func enableThreeJS
		lThreeJS = true
		return self

	# ---- Scene Setup ----

	# Create a complete 3D scene with renderer, camera, and render loop
	# canvasId: ID for the canvas element
	# options: [:width, :height, :bg, :antialias, :alpha, :shadows,
	#           :camFov, :camNear, :camFar, :camX, :camY, :camZ,
	#           :lookX, :lookY, :lookZ, :fullscreen, :responsive]
	func threeJSScene cCanvasId, aOptions
		cWidth = htmlGetOpt(aOptions, "width", "800")
		cHeight = htmlGetOpt(aOptions, "height", "600")
		cBG = htmlGetOpt(aOptions, "bg", "0x000000")
		lAntialias = htmlGetOpt(aOptions, "antialias", true)
		lAlpha = htmlGetOpt(aOptions, "alpha", false)
		lShadows = htmlGetOpt(aOptions, "shadows", false)
		cCamFov = htmlGetOpt(aOptions, "camFov", "75")
		cCamNear = htmlGetOpt(aOptions, "camNear", "0.1")
		cCamFar = htmlGetOpt(aOptions, "camFar", "1000")
		cCamX = htmlGetOpt(aOptions, "camX", "0")
		cCamY = htmlGetOpt(aOptions, "camY", "5")
		cCamZ = htmlGetOpt(aOptions, "camZ", "10")
		cLookX = htmlGetOpt(aOptions, "lookX", "0")
		cLookY = htmlGetOpt(aOptions, "lookY", "0")
		cLookZ = htmlGetOpt(aOptions, "lookZ", "0")
		lFullscreen = htmlGetOpt(aOptions, "fullscreen", false)
		lResponsive = htmlGetOpt(aOptions, "responsive", true)


		# Canvas element
		if lFullscreen
			appendContent('<canvas id="' + cCanvasId + '" style="display:block;width:100vw;height:100vh;position:fixed;top:0;left:0"></canvas>')
		else
			appendContent('<canvas id="' + cCanvasId + '" width="' + cWidth + '" height="' + cHeight + '" style="display:block;max-width:100%;border-radius:var(--radius,8px)"></canvas>')
		ok

		# Scene setup JS
		cJS = "// Three.js Scene: " + cCanvasId + HTML_LF
		cJS += "var canvas_" + cCanvasId + " = document.getElementById('" + cCanvasId + "');" + HTML_LF
		cJS += "var renderer_" + cCanvasId + " = new THREE.WebGLRenderer({canvas:canvas_" + cCanvasId + ",antialias:" + threeJSBool(lAntialias) + ",alpha:" + threeJSBool(lAlpha) + "});" + HTML_LF

		if lFullscreen
			cJS += "renderer_" + cCanvasId + ".setSize(window.innerWidth, window.innerHeight);" + HTML_LF
		else
			cJS += "renderer_" + cCanvasId + ".setSize(" + cWidth + ", " + cHeight + ");" + HTML_LF
		ok

		cJS += "renderer_" + cCanvasId + ".setPixelRatio(window.devicePixelRatio);" + HTML_LF
		cJS += "renderer_" + cCanvasId + ".setClearColor(" + cBG + ");" + HTML_LF

		if lShadows
			cJS += "renderer_" + cCanvasId + ".shadowMap.enabled = true;" + HTML_LF
			cJS += "renderer_" + cCanvasId + ".shadowMap.type = THREE.PCFSoftShadowMap;" + HTML_LF
		ok

		cJS += "var scene_" + cCanvasId + " = new THREE.Scene();" + HTML_LF
		cJS += "var camera_" + cCanvasId + " = new THREE.PerspectiveCamera(" + cCamFov + ", "
		if lFullscreen
			cJS += "window.innerWidth / window.innerHeight"
		else
			cJS += cWidth + " / " + cHeight
		ok
		cJS += ", " + cCamNear + ", " + cCamFar + ");" + HTML_LF
		cJS += "camera_" + cCanvasId + ".position.set(" + cCamX + ", " + cCamY + ", " + cCamZ + ");" + HTML_LF
		cJS += "camera_" + cCanvasId + ".lookAt(" + cLookX + ", " + cLookY + ", " + cLookZ + ");" + HTML_LF
		cJS += HTML_LF

		# Clock for animations
		cJS += "var clock_" + cCanvasId + " = new THREE.Clock();" + HTML_LF

		# Animation callbacks array
		cJS += "var animCallbacks_" + cCanvasId + " = [];" + HTML_LF

		# Resize handler
		if lResponsive
			cJS += "window.addEventListener('resize', function() {" + HTML_LF
			if lFullscreen
				cJS += "  camera_" + cCanvasId + ".aspect = window.innerWidth / window.innerHeight;" + HTML_LF
				cJS += "  camera_" + cCanvasId + ".updateProjectionMatrix();" + HTML_LF
				cJS += "  renderer_" + cCanvasId + ".setSize(window.innerWidth, window.innerHeight);" + HTML_LF
			else
				cJS += "  var container = canvas_" + cCanvasId + ".parentElement;" + HTML_LF
				cJS += "  var w = container.clientWidth;" + HTML_LF
				cJS += "  var h = w * (" + cHeight + " / " + cWidth + ");" + HTML_LF
				cJS += "  camera_" + cCanvasId + ".aspect = w / h;" + HTML_LF
				cJS += "  camera_" + cCanvasId + ".updateProjectionMatrix();" + HTML_LF
				cJS += "  renderer_" + cCanvasId + ".setSize(w, h);" + HTML_LF
			ok
			cJS += "});" + HTML_LF
		ok

		cJS += HTML_LF
		addBodyScript(cJS)
		return self

	# Start the render loop (call AFTER adding all objects & animations)
	func threeJSAnimate cCanvasId
		cJS = "// Animation loop" + HTML_LF
		cJS += "(function animate_" + cCanvasId + "() {" + HTML_LF
		cJS += "  requestAnimationFrame(animate_" + cCanvasId + ");" + HTML_LF
		cJS += "  var delta_" + cCanvasId + " = clock_" + cCanvasId + ".getDelta();" + HTML_LF
		cJS += "  for(var i=0; i<animCallbacks_" + cCanvasId + ".length; i++) {" + HTML_LF
		cJS += "    animCallbacks_" + cCanvasId + "[i](delta_" + cCanvasId + ", clock_" + cCanvasId + ".elapsedTime);" + HTML_LF
		cJS += "  }" + HTML_LF
		# Skip standard render if outline composer handles it
		cJS += "  if(typeof _skipRender_" + cCanvasId + " === 'undefined' || !_skipRender_" + cCanvasId + ")" + HTML_LF
		cJS += "    renderer_" + cCanvasId + ".render(scene_" + cCanvasId + ", camera_" + cCanvasId + ");" + HTML_LF
		cJS += "})();" + HTML_LF
		addBodyScript(cJS)
		return self

	# ---- Geometry / Mesh Builders ----

	# Add a box (cube/cuboid) mesh
	# name: JS variable name for the mesh
	# options: [:w, :h, :d, :color, :x, :y, :z, :rx, :ry, :rz,
	#           :material (standard/basic/phong/lambert), :wireframe,
	#           :castShadow, :receiveShadow, :metalness, :roughness, :opacity, :transparent]
	func threeJSBox cCanvasId, cName, aOptions
		cW = htmlGetOpt(aOptions, "w", "1")
		cH = htmlGetOpt(aOptions, "h", "1")
		cD = htmlGetOpt(aOptions, "d", "1")
		return threeJSMesh(cCanvasId, cName, "BoxGeometry(" + cW + "," + cH + "," + cD + ")", aOptions)

	# Add a sphere mesh
	# options: [:radius, :wSeg, :hSeg + all mesh options]
	func threeJSSphere cCanvasId, cName, aOptions
		cRadius = htmlGetOpt(aOptions, "radius", "1")
		cWSeg = htmlGetOpt(aOptions, "wSeg", "32")
		cHSeg = htmlGetOpt(aOptions, "hSeg", "32")
		return threeJSMesh(cCanvasId, cName, "SphereGeometry(" + cRadius + "," + cWSeg + "," + cHSeg + ")", aOptions)

	# Add a cylinder mesh
	# options: [:radiusTop, :radiusBottom, :height, :segments + mesh options]
	func threeJSCylinder cCanvasId, cName, aOptions
		cRTop = htmlGetOpt(aOptions, "radiusTop", "1")
		cRBot = htmlGetOpt(aOptions, "radiusBottom", "1")
		cH = htmlGetOpt(aOptions, "height", "2")
		cSeg = htmlGetOpt(aOptions, "segments", "32")
		return threeJSMesh(cCanvasId, cName, "CylinderGeometry(" + cRTop + "," + cRBot + "," + cH + "," + cSeg + ")", aOptions)

	# Add a plane mesh (flat surface)
	# options: [:w, :h, :wSeg, :hSeg + mesh options]
	func threeJSPlane cCanvasId, cName, aOptions
		cW = htmlGetOpt(aOptions, "w", "10")
		cH = htmlGetOpt(aOptions, "h", "10")
		cWSeg = htmlGetOpt(aOptions, "wSeg", "1")
		cHSeg = htmlGetOpt(aOptions, "hSeg", "1")
		return threeJSMesh(cCanvasId, cName, "PlaneGeometry(" + cW + "," + cH + "," + cWSeg + "," + cHSeg + ")", aOptions)

	# Add a cone mesh
	func threeJSCone cCanvasId, cName, aOptions
		cRadius = htmlGetOpt(aOptions, "radius", "1")
		cH = htmlGetOpt(aOptions, "height", "2")
		cSeg = htmlGetOpt(aOptions, "segments", "32")
		return threeJSMesh(cCanvasId, cName, "ConeGeometry(" + cRadius + "," + cH + "," + cSeg + ")", aOptions)

	# Add a torus (donut) mesh
	func threeJSTorus cCanvasId, cName, aOptions
		cRadius = htmlGetOpt(aOptions, "radius", "1")
		cTube = htmlGetOpt(aOptions, "tube", "0.4")
		cRSeg = htmlGetOpt(aOptions, "radialSeg", "16")
		cTSeg = htmlGetOpt(aOptions, "tubeSeg", "48")
		return threeJSMesh(cCanvasId, cName, "TorusGeometry(" + cRadius + "," + cTube + "," + cRSeg + "," + cTSeg + ")", aOptions)

	# Add a torus knot mesh
	func threeJSTorusKnot cCanvasId, cName, aOptions
		cRadius = htmlGetOpt(aOptions, "radius", "1")
		cTube = htmlGetOpt(aOptions, "tube", "0.3")
		cTSeg = htmlGetOpt(aOptions, "tubeSeg", "100")
		cRSeg = htmlGetOpt(aOptions, "radialSeg", "16")
		cP = htmlGetOpt(aOptions, "p", "2")
		cQ = htmlGetOpt(aOptions, "q", "3")
		return threeJSMesh(cCanvasId, cName, "TorusKnotGeometry(" + cRadius + "," + cTube + "," + cTSeg + "," + cRSeg + "," + cP + "," + cQ + ")", aOptions)

	# Add a ring (flat donut) mesh
	func threeJSRing cCanvasId, cName, aOptions
		cInnerR = htmlGetOpt(aOptions, "innerRadius", "0.5")
		cOuterR = htmlGetOpt(aOptions, "outerRadius", "1")
		cSeg = htmlGetOpt(aOptions, "segments", "32")
		return threeJSMesh(cCanvasId, cName, "RingGeometry(" + cInnerR + "," + cOuterR + "," + cSeg + ")", aOptions)

	# Add a dodecahedron
	func threeJSDodecahedron cCanvasId, cName, aOptions
		cRadius = htmlGetOpt(aOptions, "radius", "1")
		cDetail = htmlGetOpt(aOptions, "detail", "0")
		return threeJSMesh(cCanvasId, cName, "DodecahedronGeometry(" + cRadius + "," + cDetail + ")", aOptions)

	# Add an icosahedron
	func threeJSIcosahedron cCanvasId, cName, aOptions
		cRadius = htmlGetOpt(aOptions, "radius", "1")
		cDetail = htmlGetOpt(aOptions, "detail", "0")
		return threeJSMesh(cCanvasId, cName, "IcosahedronGeometry(" + cRadius + "," + cDetail + ")", aOptions)

	# Add an octahedron
	func threeJSOctahedron cCanvasId, cName, aOptions
		cRadius = htmlGetOpt(aOptions, "radius", "1")
		cDetail = htmlGetOpt(aOptions, "detail", "0")
		return threeJSMesh(cCanvasId, cName, "OctahedronGeometry(" + cRadius + "," + cDetail + ")", aOptions)

	# ---- Core mesh builder (private helper) ----
	func threeJSMesh cCanvasId, cName, cGeometryExpr, aOptions
		cColor = htmlGetOpt(aOptions, "color", "0x00ff00")
		cX = htmlGetOpt(aOptions, "x", "0")
		cY = htmlGetOpt(aOptions, "y", "0")
		cZ = htmlGetOpt(aOptions, "z", "0")
		cRX = htmlGetOpt(aOptions, "rx", "")
		cRY = htmlGetOpt(aOptions, "ry", "")
		cRZ = htmlGetOpt(aOptions, "rz", "")
		cMaterial = htmlGetOpt(aOptions, "material", "standard")
		lWireframe = htmlGetOpt(aOptions, "wireframe", false)
		lCastShadow = htmlGetOpt(aOptions, "castShadow", false)
		lReceiveShadow = htmlGetOpt(aOptions, "receiveShadow", false)
		cMetalness = htmlGetOpt(aOptions, "metalness", "")
		cRoughness = htmlGetOpt(aOptions, "roughness", "")
		cOpacity = htmlGetOpt(aOptions, "opacity", "")
		lTransparent = htmlGetOpt(aOptions, "transparent", false)
		cEmissive = htmlGetOpt(aOptions, "emissive", "")
		cEmissiveIntensity = htmlGetOpt(aOptions, "emissiveIntensity", "")
		cSide = htmlGetOpt(aOptions, "side", "")
		lFlatShading = htmlGetOpt(aOptions, "flatShading", false)

		# Texture options
		cTextureUrl = htmlGetOpt(aOptions, "texture", "")
		cNormalMapUrl = htmlGetOpt(aOptions, "normalMap", "")
		cBumpMapUrl = htmlGetOpt(aOptions, "bumpMap", "")
		cBumpScale = htmlGetOpt(aOptions, "bumpScale", "")
		cRoughnessMapUrl = htmlGetOpt(aOptions, "roughnessMap", "")
		cMetalnessMapUrl = htmlGetOpt(aOptions, "metalnessMap", "")
		cEmissiveMapUrl = htmlGetOpt(aOptions, "emissiveMap", "")
		cAoMapUrl = htmlGetOpt(aOptions, "aoMap", "")
		cAlphaMapUrl = htmlGetOpt(aOptions, "alphaMap", "")
		cEnvMapUrl = htmlGetOpt(aOptions, "envMap", "")
		cDisplacementMapUrl = htmlGetOpt(aOptions, "displacementMap", "")
		cDisplacementScale = htmlGetOpt(aOptions, "displacementScale", "")
		cRepeatX = htmlGetOpt(aOptions, "tileX", "")
		cRepeatY = htmlGetOpt(aOptions, "tileY", "")


		# Material
		cMatType = "MeshStandardMaterial"
		if cMaterial = "basic" cMatType = "MeshBasicMaterial" ok
		if cMaterial = "phong" cMatType = "MeshPhongMaterial" ok
		if cMaterial = "lambert" cMatType = "MeshLambertMaterial" ok
		if cMaterial = "normal" cMatType = "MeshNormalMaterial" ok
		if cMaterial = "toon" cMatType = "MeshToonMaterial" ok

		# Check if any texture is used
		lHasTexture = (cTextureUrl != "" or cNormalMapUrl != "" or cBumpMapUrl != "" or
					  cRoughnessMapUrl != "" or cMetalnessMapUrl != "" or cEmissiveMapUrl != "" or
					  cAoMapUrl != "" or cAlphaMapUrl != "" or cDisplacementMapUrl != "")

		if lHasTexture
			# Use texture loader approach
			cJS = "// Textured mesh: " + cName + HTML_LF
			cJS += "(function() {" + HTML_LF
			cJS += "  var _loader = new THREE.TextureLoader();" + HTML_LF
			cJS += "  var _matOpts = {color:" + cColor
			if lWireframe cJS += ",wireframe:true" ok
			if lTransparent cJS += ",transparent:true" ok
			if cOpacity != "" cJS += ",opacity:" + cOpacity ok
			if cMetalness != "" cJS += ",metalness:" + cMetalness ok
			if cRoughness != "" cJS += ",roughness:" + cRoughness ok
			if cEmissive != "" cJS += ",emissive:" + cEmissive ok
			if cEmissiveIntensity != "" cJS += ",emissiveIntensity:" + cEmissiveIntensity ok
			if lFlatShading cJS += ",flatShading:true" ok
			if cSide = "double" cJS += ",side:THREE.DoubleSide" ok
			if cSide = "back" cJS += ",side:THREE.BackSide" ok
			cJS += "};" + HTML_LF

			# Count textures to load for callback tracking
			cJS += "  var _texCount = 0, _texLoaded = 0;" + HTML_LF

			# Helper to apply repeat/wrap to any texture
			cFuncApplyRepeat = ""
			if cRepeatX != "" or cRepeatY != ""
				cRX = cRepeatX
				cRY = cRepeatY
				if cRX = "" cRX = "1" ok
				if cRY = "" cRY = "1" ok
				cFuncApplyRepeat = "function _applyRepeat(t){t.wrapS=THREE.RepeatWrapping;t.wrapT=THREE.RepeatWrapping;t.repeat.set(" + cRX + "," + cRY + ");}"
				cJS += "  " + cFuncApplyRepeat + HTML_LF
			ok

			# Load each texture type
			if cTextureUrl != ""
				cJS += "  _texCount++;" + HTML_LF
				cJS += "  _loader.load(" + HTML_DQ + cTextureUrl + HTML_DQ + ", function(t){" + HTML_LF
				if cFuncApplyRepeat != "" cJS += "    _applyRepeat(t);" + HTML_LF ok
				cJS += "    _matOpts.map = t; _texLoaded++; if(_texLoaded>=_texCount) _buildMesh();" + HTML_LF
				cJS += "  });" + HTML_LF
			ok
			if cNormalMapUrl != ""
				cJS += "  _texCount++;" + HTML_LF
				cJS += "  _loader.load(" + HTML_DQ + cNormalMapUrl + HTML_DQ + ", function(t){" + HTML_LF
				if cFuncApplyRepeat != "" cJS += "    _applyRepeat(t);" + HTML_LF ok
				cJS += "    _matOpts.normalMap = t; _texLoaded++; if(_texLoaded>=_texCount) _buildMesh();" + HTML_LF
				cJS += "  });" + HTML_LF
			ok
			if cBumpMapUrl != ""
				cJS += "  _texCount++;" + HTML_LF
				cJS += "  _loader.load(" + HTML_DQ + cBumpMapUrl + HTML_DQ + ", function(t){" + HTML_LF
				if cFuncApplyRepeat != "" cJS += "    _applyRepeat(t);" + HTML_LF ok
				cJS += "    _matOpts.bumpMap = t;" + HTML_LF
				if cBumpScale != "" cJS += "    _matOpts.bumpScale = " + cBumpScale + ";" + HTML_LF ok
				cJS += "    _texLoaded++; if(_texLoaded>=_texCount) _buildMesh();" + HTML_LF
				cJS += "  });" + HTML_LF
			ok
			if cRoughnessMapUrl != ""
				cJS += "  _texCount++;" + HTML_LF
				cJS += "  _loader.load(" + HTML_DQ + cRoughnessMapUrl + HTML_DQ + ", function(t){" + HTML_LF
				if cFuncApplyRepeat != "" cJS += "    _applyRepeat(t);" + HTML_LF ok
				cJS += "    _matOpts.roughnessMap = t; _texLoaded++; if(_texLoaded>=_texCount) _buildMesh();" + HTML_LF
				cJS += "  });" + HTML_LF
			ok
			if cMetalnessMapUrl != ""
				cJS += "  _texCount++;" + HTML_LF
				cJS += "  _loader.load(" + HTML_DQ + cMetalnessMapUrl + HTML_DQ + ", function(t){" + HTML_LF
				if cFuncApplyRepeat != "" cJS += "    _applyRepeat(t);" + HTML_LF ok
				cJS += "    _matOpts.metalnessMap = t; _texLoaded++; if(_texLoaded>=_texCount) _buildMesh();" + HTML_LF
				cJS += "  });" + HTML_LF
			ok
			if cEmissiveMapUrl != ""
				cJS += "  _texCount++;" + HTML_LF
				cJS += "  _loader.load(" + HTML_DQ + cEmissiveMapUrl + HTML_DQ + ", function(t){" + HTML_LF
				if cFuncApplyRepeat != "" cJS += "    _applyRepeat(t);" + HTML_LF ok
				cJS += "    _matOpts.emissiveMap = t; _texLoaded++; if(_texLoaded>=_texCount) _buildMesh();" + HTML_LF
				cJS += "  });" + HTML_LF
			ok
			if cAoMapUrl != ""
				cJS += "  _texCount++;" + HTML_LF
				cJS += "  _loader.load(" + HTML_DQ + cAoMapUrl + HTML_DQ + ", function(t){" + HTML_LF
				if cFuncApplyRepeat != "" cJS += "    _applyRepeat(t);" + HTML_LF ok
				cJS += "    _matOpts.aoMap = t; _texLoaded++; if(_texLoaded>=_texCount) _buildMesh();" + HTML_LF
				cJS += "  });" + HTML_LF
			ok
			if cAlphaMapUrl != ""
				cJS += "  _texCount++;" + HTML_LF
				cJS += "  _loader.load(" + HTML_DQ + cAlphaMapUrl + HTML_DQ + ", function(t){" + HTML_LF
				if cFuncApplyRepeat != "" cJS += "    _applyRepeat(t);" + HTML_LF ok
				cJS += "    _matOpts.alphaMap = t; _matOpts.transparent = true; _texLoaded++; if(_texLoaded>=_texCount) _buildMesh();" + HTML_LF
				cJS += "  });" + HTML_LF
			ok
			if cDisplacementMapUrl != ""
				cJS += "  _texCount++;" + HTML_LF
				cJS += "  _loader.load(" + HTML_DQ + cDisplacementMapUrl + HTML_DQ + ", function(t){" + HTML_LF
				if cFuncApplyRepeat != "" cJS += "    _applyRepeat(t);" + HTML_LF ok
				cJS += "    _matOpts.displacementMap = t;" + HTML_LF
				if cDisplacementScale != "" cJS += "    _matOpts.displacementScale = " + cDisplacementScale + ";" + HTML_LF ok
				cJS += "    _texLoaded++; if(_texLoaded>=_texCount) _buildMesh();" + HTML_LF
				cJS += "  });" + HTML_LF
			ok

			# Build mesh after all textures loaded
			cJS += "  function _buildMesh() {" + HTML_LF
			cJS += "    var geo = new THREE." + cGeometryExpr + ";" + HTML_LF
			if cAoMapUrl != ""
				cJS += "    geo.setAttribute('uv2', new THREE.BufferAttribute(geo.attributes.uv.array, 2));" + HTML_LF
			ok
			cJS += "    var mat = new THREE." + cMatType + "(_matOpts);" + HTML_LF
			cJS += "    window." + cName + " = new THREE.Mesh(geo, mat);" + HTML_LF
			cJS += "    " + cName + ".position.set(" + cX + ", " + cY + ", " + cZ + ");" + HTML_LF
			if cRX != "" cJS += "    " + cName + ".rotation.x = " + cRX + ";" + HTML_LF ok
			if cRY != "" cJS += "    " + cName + ".rotation.y = " + cRY + ";" + HTML_LF ok
			if cRZ != "" cJS += "    " + cName + ".rotation.z = " + cRZ + ";" + HTML_LF ok
			if lCastShadow cJS += "    " + cName + ".castShadow = true;" + HTML_LF ok
			if lReceiveShadow cJS += "    " + cName + ".receiveShadow = true;" + HTML_LF ok
			cJS += "    scene_" + cCanvasId + ".add(" + cName + ");" + HTML_LF
			cJS += "  }" + HTML_LF

			# Declare global reference for immediate use
			cJS += "  window." + cName + " = null;" + HTML_LF
			cJS += "})();" + HTML_LF
		else
			# No texture - original fast path
			cJS = "var " + cName + "_geo = new THREE." + cGeometryExpr + ";" + HTML_LF
			cJS += "var " + cName + "_mat = new THREE." + cMatType + "({color:" + cColor
			if lWireframe cJS += ",wireframe:true" ok
			if lTransparent cJS += ",transparent:true" ok
			if cOpacity != "" cJS += ",opacity:" + cOpacity ok
			if cMetalness != "" cJS += ",metalness:" + cMetalness ok
			if cRoughness != "" cJS += ",roughness:" + cRoughness ok
			if cEmissive != "" cJS += ",emissive:" + cEmissive ok
			if cEmissiveIntensity != "" cJS += ",emissiveIntensity:" + cEmissiveIntensity ok
			if lFlatShading cJS += ",flatShading:true" ok
			if cSide = "double" cJS += ",side:THREE.DoubleSide" ok
			if cSide = "back" cJS += ",side:THREE.BackSide" ok
			cJS += "});" + HTML_LF

			cJS += "var " + cName + " = new THREE.Mesh(" + cName + "_geo, " + cName + "_mat);" + HTML_LF
			cJS += cName + ".position.set(" + cX + ", " + cY + ", " + cZ + ");" + HTML_LF

			if cRX != "" cJS += cName + ".rotation.x = " + cRX + ";" + HTML_LF ok
			if cRY != "" cJS += cName + ".rotation.y = " + cRY + ";" + HTML_LF ok
			if cRZ != "" cJS += cName + ".rotation.z = " + cRZ + ";" + HTML_LF ok
			if lCastShadow cJS += cName + ".castShadow = true;" + HTML_LF ok
			if lReceiveShadow cJS += cName + ".receiveShadow = true;" + HTML_LF ok

			cJS += "scene_" + cCanvasId + ".add(" + cName + ");" + HTML_LF
		ok

		addBodyScript(cJS)
		return self

	# ---- Text (3D extruded text) ----
	# Note: Requires a font JSON file. Built-in fonts can be loaded from three.js examples.
	func threeJSText cCanvasId, cName, cText, aOptions
		cFontUrl = htmlGetOpt(aOptions, "fontUrl", "https://cdn.jsdelivr.net/npm/three@0.128.0/examples/fonts/helvetiker_regular.typeface.json")
		cSize = htmlGetOpt(aOptions, "size", "1")
		cHeight = htmlGetOpt(aOptions, "height", "0.2")
		cColor = htmlGetOpt(aOptions, "color", "0xffffff")
		cX = htmlGetOpt(aOptions, "x", "0")
		cY = htmlGetOpt(aOptions, "y", "0")
		cZ = htmlGetOpt(aOptions, "z", "0")
		cMaterial = htmlGetOpt(aOptions, "material", "standard")
		lCenterX = htmlGetOpt(aOptions, "centerX", true)

		cMatType = "MeshStandardMaterial"
		if cMaterial = "basic" cMatType = "MeshBasicMaterial" ok
		if cMaterial = "phong" cMatType = "MeshPhongMaterial" ok

		cJS = "var " + cName + "_loader = new THREE.FontLoader();" + HTML_LF
		cJS += cName + "_loader.load(" + HTML_DQ + cFontUrl + HTML_DQ + ", function(font) {" + HTML_LF
		cJS += "  var " + cName + "_geo = new THREE.TextGeometry(" + HTML_DQ + cText + HTML_DQ + ", {" + HTML_LF
		cJS += "    font: font, size: " + cSize + ", height: " + cHeight + "," + HTML_LF
		cJS += "    curveSegments: 12, bevelEnabled: false" + HTML_LF
		cJS += "  });" + HTML_LF
		if lCenterX
			cJS += "  " + cName + "_geo.computeBoundingBox();" + HTML_LF
			cJS += "  " + cName + "_geo.translate(-(" + cName + "_geo.boundingBox.max.x - " + cName + "_geo.boundingBox.min.x) / 2, 0, 0);" + HTML_LF
		ok
		cJS += "  var " + cName + "_mat = new THREE." + cMatType + "({color:" + cColor + "});" + HTML_LF
		cJS += "  var " + cName + " = new THREE.Mesh(" + cName + "_geo, " + cName + "_mat);" + HTML_LF
		cJS += "  " + cName + ".position.set(" + cX + ", " + cY + ", " + cZ + ");" + HTML_LF
		cJS += "  scene_" + cCanvasId + ".add(" + cName + ");" + HTML_LF
		cJS += "});" + HTML_LF
		addBodyScript(cJS)
		return self

	# ---- Lights ----

	# Ambient light (illuminates all objects equally)
	func threeJSAmbientLight cCanvasId, aOptions
		cColor = htmlGetOpt(aOptions, "color", "0x404040")
		cIntensity = htmlGetOpt(aOptions, "intensity", "0.5")

		cJS = "var ambientLight_" + cCanvasId + " = new THREE.AmbientLight(" + cColor + ", " + cIntensity + ");" + HTML_LF
		cJS += "scene_" + cCanvasId + ".add(ambientLight_" + cCanvasId + ");" + HTML_LF
		addBodyScript(cJS)
		return self

	# Directional light (like sunlight)
	func threeJSDirectionalLight cCanvasId, cName, aOptions
		cColor = htmlGetOpt(aOptions, "color", "0xffffff")
		cIntensity = htmlGetOpt(aOptions, "intensity", "1")
		cX = htmlGetOpt(aOptions, "x", "5")
		cY = htmlGetOpt(aOptions, "y", "10")
		cZ = htmlGetOpt(aOptions, "z", "5")
		lCastShadow = htmlGetOpt(aOptions, "castShadow", false)
		cShadowSize = htmlGetOpt(aOptions, "shadowSize", "10")

		cJS = "var " + cName + " = new THREE.DirectionalLight(" + cColor + ", " + cIntensity + ");" + HTML_LF
		cJS += cName + ".position.set(" + cX + ", " + cY + ", " + cZ + ");" + HTML_LF
		if lCastShadow
			cJS += cName + ".castShadow = true;" + HTML_LF
			cJS += cName + ".shadow.mapSize.width = 2048;" + HTML_LF
			cJS += cName + ".shadow.mapSize.height = 2048;" + HTML_LF
			cJS += cName + ".shadow.camera.left = -" + cShadowSize + ";" + HTML_LF
			cJS += cName + ".shadow.camera.right = " + cShadowSize + ";" + HTML_LF
			cJS += cName + ".shadow.camera.top = " + cShadowSize + ";" + HTML_LF
			cJS += cName + ".shadow.camera.bottom = -" + cShadowSize + ";" + HTML_LF
		ok
		cJS += "scene_" + cCanvasId + ".add(" + cName + ");" + HTML_LF
		addBodyScript(cJS)
		return self

	# Point light (light bulb, radiates in all directions)
	func threeJSPointLight cCanvasId, cName, aOptions
		cColor = htmlGetOpt(aOptions, "color", "0xffffff")
		cIntensity = htmlGetOpt(aOptions, "intensity", "1")
		cDistance = htmlGetOpt(aOptions, "distance", "0")
		cDecay = htmlGetOpt(aOptions, "decay", "2")
		cX = htmlGetOpt(aOptions, "x", "0")
		cY = htmlGetOpt(aOptions, "y", "5")
		cZ = htmlGetOpt(aOptions, "z", "0")
		lCastShadow = htmlGetOpt(aOptions, "castShadow", false)

		cJS = "var " + cName + " = new THREE.PointLight(" + cColor + ", " + cIntensity + ", " + cDistance + ", " + cDecay + ");" + HTML_LF
		cJS += cName + ".position.set(" + cX + ", " + cY + ", " + cZ + ");" + HTML_LF
		if lCastShadow cJS += cName + ".castShadow = true;" + HTML_LF ok
		cJS += "scene_" + cCanvasId + ".add(" + cName + ");" + HTML_LF
		addBodyScript(cJS)
		return self

	# Spot light (focused cone of light)
	func threeJSSpotLight cCanvasId, cName, aOptions
		cColor = htmlGetOpt(aOptions, "color", "0xffffff")
		cIntensity = htmlGetOpt(aOptions, "intensity", "1")
		cDistance = htmlGetOpt(aOptions, "distance", "0")
		cAngle = htmlGetOpt(aOptions, "angle", "0.5")
		cPenumbra = htmlGetOpt(aOptions, "penumbra", "0.1")
		cX = htmlGetOpt(aOptions, "x", "0")
		cY = htmlGetOpt(aOptions, "y", "10")
		cZ = htmlGetOpt(aOptions, "z", "0")
		cTargetX = htmlGetOpt(aOptions, "targetX", "0")
		cTargetY = htmlGetOpt(aOptions, "targetY", "0")
		cTargetZ = htmlGetOpt(aOptions, "targetZ", "0")
		lCastShadow = htmlGetOpt(aOptions, "castShadow", false)

		cJS = "var " + cName + " = new THREE.SpotLight(" + cColor + ", " + cIntensity + ", " + cDistance + ", " + cAngle + ", " + cPenumbra + ");" + HTML_LF
		cJS += cName + ".position.set(" + cX + ", " + cY + ", " + cZ + ");" + HTML_LF
		cJS += cName + ".target.position.set(" + cTargetX + ", " + cTargetY + ", " + cTargetZ + ");" + HTML_LF
		if lCastShadow
			cJS += cName + ".castShadow = true;" + HTML_LF
			cJS += cName + ".shadow.mapSize.width = 2048;" + HTML_LF
			cJS += cName + ".shadow.mapSize.height = 2048;" + HTML_LF
		ok
		cJS += "scene_" + cCanvasId + ".add(" + cName + ");" + HTML_LF
		cJS += "scene_" + cCanvasId + ".add(" + cName + ".target);" + HTML_LF
		addBodyScript(cJS)
		return self

	# Hemisphere light (sky/ground light)
	func threeJSHemisphereLight cCanvasId, aOptions
		cSkyColor = htmlGetOpt(aOptions, "skyColor", "0x87ceeb")
		cGroundColor = htmlGetOpt(aOptions, "groundColor", "0x444444")
		cIntensity = htmlGetOpt(aOptions, "intensity", "0.6")

		cJS = "var hemiLight_" + cCanvasId + " = new THREE.HemisphereLight(" + cSkyColor + ", " + cGroundColor + ", " + cIntensity + ");" + HTML_LF
		cJS += "scene_" + cCanvasId + ".add(hemiLight_" + cCanvasId + ");" + HTML_LF
		addBodyScript(cJS)
		return self

	# ---- Scene Environment ----

	# Add fog to scene
	func threeJSFog cCanvasId, aOptions
		cColor = htmlGetOpt(aOptions, "color", "0x000000")
		cNear = htmlGetOpt(aOptions, "near", "10")
		cFar = htmlGetOpt(aOptions, "far", "100")

		cJS = "scene_" + cCanvasId + ".fog = new THREE.Fog(" + cColor + ", " + cNear + ", " + cFar + ");" + char(10)
		addBodyScript(cJS)
		return self

	# Set scene background color
	func threeJSBackground cCanvasId, cColor
		cJS = "scene_" + cCanvasId + ".background = new THREE.Color(" + cColor + ");" + char(10)
		addBodyScript(cJS)
		return self

	# Add a grid helper
	func threeJSGridHelper cCanvasId, aOptions
		cSize = htmlGetOpt(aOptions, "size", "20")
		cDivisions = htmlGetOpt(aOptions, "divisions", "20")
		cColor1 = htmlGetOpt(aOptions, "color1", "0x444444")
		cColor2 = htmlGetOpt(aOptions, "color2", "0x888888")

		cJS = "var grid_" + cCanvasId + " = new THREE.GridHelper(" + cSize + ", " + cDivisions + ", " + cColor1 + ", " + cColor2 + ");" + HTML_LF
		cJS += "scene_" + cCanvasId + ".add(grid_" + cCanvasId + ");" + HTML_LF
		addBodyScript(cJS)
		return self

	# Add axes helper
	func threeJSAxesHelper cCanvasId, cSize
		cJS = "var axes_" + cCanvasId + " = new THREE.AxesHelper(" + cSize + ");" + HTML_LF
		cJS += "scene_" + cCanvasId + ".add(axes_" + cCanvasId + ");" + HTML_LF
		addBodyScript(cJS)
		return self

	# Add skybox (using CubeTextureLoader)
	func threeJSSkybox cCanvasId, cPath, aFileNames
		cJS = "var skyLoader_" + cCanvasId + " = new THREE.CubeTextureLoader();" + HTML_LF
		cJS += "skyLoader_" + cCanvasId + ".setPath(" + HTML_DQ + cPath + HTML_DQ + ");" + HTML_LF
		cJS += "var skyTex_" + cCanvasId + " = skyLoader_" + cCanvasId + ".load(["
		nFileNameLen = len(aFileNames)
		for nFileName = 1 to nFileNameLen
			if nFileName > 1 cJS += "," ok
			cJS += HTML_DQ + aFileNames[nFileName] + HTML_DQ
		next
		cJS += "]);" + HTML_LF
		cJS += "scene_" + cCanvasId + ".background = skyTex_" + cCanvasId + ";" + HTML_LF
		addBodyScript(cJS)
		return self

	# ---- Textures ----

	# Load a texture onto a named mesh
	func threeJSTexture cMeshName, cTextureUrl, aOptions
		cRepeat = htmlGetOpt(aOptions, "repeat", "")
		cWrapS = htmlGetOpt(aOptions, "wrapS", "")
		cWrapT = htmlGetOpt(aOptions, "wrapT", "")

		cJS = "var texLoader_" + cMeshName + " = new THREE.TextureLoader();" + HTML_LF
		cJS += "var tex_" + cMeshName + " = texLoader_" + cMeshName + ".load(" + HTML_DQ + cTextureUrl + HTML_DQ + ");" + HTML_LF
		if cWrapS = "repeat"
			cJS += "tex_" + cMeshName + ".wrapS = THREE.RepeatWrapping;" + HTML_LF
		ok
		if cWrapT = "repeat"
			cJS += "tex_" + cMeshName + ".wrapT = THREE.RepeatWrapping;" + HTML_LF
		ok
		if cRepeat != ""
			cJS += "tex_" + cMeshName + ".repeat.set(" + cRepeat + ");" + HTML_LF
		ok
		cJS += cMeshName + ".material.map = tex_" + cMeshName + ";" + HTML_LF
		cJS += cMeshName + ".material.needsUpdate = true;" + HTML_LF
		addBodyScript(cJS)
		return self

	# ---- Animation Helpers ----

	# Register a custom animation callback
	# jsCode: JS code string using 'delta' (seconds since last frame) and 'elapsed' (total seconds)
	func threeJSOnAnimate cCanvasId, cJSCode
		cJS = "animCallbacks_" + cCanvasId + ".push(function(delta, elapsed) {" + HTML_LF
		cJS += "  " + cJSCode + HTML_LF
		cJS += "});" + HTML_LF
		addBodyScript(cJS)
		return self

	# Auto-rotate an object
	func threeJSAutoRotate cCanvasId, cMeshName, aOptions
		cSpeedX = htmlGetOpt(aOptions, "speedX", "0")
		cSpeedY = htmlGetOpt(aOptions, "speedY", "1")
		cSpeedZ = htmlGetOpt(aOptions, "speedZ", "0")

		cJSCode = cMeshName + ".rotation.x += " + cSpeedX + " * delta;"
		cJSCode += cMeshName + ".rotation.y += " + cSpeedY + " * delta;"
		cJSCode += cMeshName + ".rotation.z += " + cSpeedZ + " * delta;"
		return threeJSOnAnimate(cCanvasId, cJSCode)

	# Bobbing (up/down) animation
	func threeJSBob cCanvasId, cMeshName, aOptions
		cSpeed = htmlGetOpt(aOptions, "speed", "2")
		cAmplitude = htmlGetOpt(aOptions, "amplitude", "0.5")
		cBaseY = htmlGetOpt(aOptions, "baseY", "0")

		cJSCode = cMeshName + ".position.y = " + cBaseY + " + Math.sin(elapsed * " + cSpeed + ") * " + cAmplitude + ";"
		return threeJSOnAnimate(cCanvasId, cJSCode)

	# Orbit animation (circular path)
	func threeJSOrbit cCanvasId, cMeshName, aOptions
		cSpeed = htmlGetOpt(aOptions, "speed", "1")
		cRadius = htmlGetOpt(aOptions, "radius", "5")
		cCenterX = htmlGetOpt(aOptions, "centerX", "0")
		cCenterZ = htmlGetOpt(aOptions, "centerZ", "0")
		cY = htmlGetOpt(aOptions, "y", "0")

		cJSCode = cMeshName + ".position.x = " + cCenterX + " + Math.cos(elapsed * " + cSpeed + ") * " + cRadius + ";"
		cJSCode += cMeshName + ".position.z = " + cCenterZ + " + Math.sin(elapsed * " + cSpeed + ") * " + cRadius + ";"
		if cY != "0" cJSCode += cMeshName + ".position.y = " + cY + ";" ok
		return threeJSOnAnimate(cCanvasId, cJSCode)

	# Scale pulse animation
	func threeJSPulse cCanvasId, cMeshName, aOptions
		cSpeed = htmlGetOpt(aOptions, "speed", "2")
		cMinScale = htmlGetOpt(aOptions, "min", "0.8")
		cMaxScale = htmlGetOpt(aOptions, "max", "1.2")

		cMid = "" + (0 + cMinScale + (0 + cMaxScale - cMinScale) / 2)
		cAmp = "" + ((0 + cMaxScale - cMinScale) / 2)
		cJSCode = "var s=" + cMid + "+Math.sin(elapsed*" + cSpeed + ")*" + cAmp + ";" + cMeshName + ".scale.set(s,s,s);"
		return threeJSOnAnimate(cCanvasId, cJSCode)

	# ---- Groups ----

	# Create a group and add it to scene
	func threeJSGroup cCanvasId, cName, aOptions
		cX = htmlGetOpt(aOptions, "x", "0")
		cY = htmlGetOpt(aOptions, "y", "0")
		cZ = htmlGetOpt(aOptions, "z", "0")

		cJS = "var " + cName + " = new THREE.Group();" + HTML_LF
		cJS += cName + ".position.set(" + cX + ", " + cY + ", " + cZ + ");" + HTML_LF
		cJS += "scene_" + cCanvasId + ".add(" + cName + ");" + HTML_LF
		addBodyScript(cJS)
		return self

	# Add an existing mesh to a group (instead of scene)
	func threeJSAddToGroup cGroupName, cMeshName
		cJS = cGroupName + ".add(" + cMeshName + ");" + char(10)
		addBodyScript(cJS)
		return self

	# ---- Particle System ----

	# Simple particle system (point-based)
	func threeJSParticles cCanvasId, cName, aOptions
		cCount = htmlGetOpt(aOptions, "count", "1000")
		cSize = htmlGetOpt(aOptions, "size", "0.1")
		cColor = htmlGetOpt(aOptions, "color", "0xffffff")
		cSpread = htmlGetOpt(aOptions, "spread", "20")
		lTransparent = htmlGetOpt(aOptions, "transparent", true)
		cOpacity = htmlGetOpt(aOptions, "opacity", "0.8")

		cJS = "var " + cName + "_geo = new THREE.BufferGeometry();" + HTML_LF
		cJS += "var " + cName + "_positions = new Float32Array(" + cCount + " * 3);" + HTML_LF
		cJS += "for(var i=0; i<" + cCount + "*3; i++) {" + HTML_LF
		cJS += "  " + cName + "_positions[i] = (Math.random() - 0.5) * " + cSpread + ";" + HTML_LF
		cJS += "}" + HTML_LF
		cJS += cName + "_geo.setAttribute('position', new THREE.BufferAttribute(" + cName + "_positions, 3));" + HTML_LF
		cJS += "var " + cName + "_mat = new THREE.PointsMaterial({color:" + cColor + ",size:" + cSize + ",transparent:" + threeJSBool(lTransparent) + ",opacity:" + cOpacity + "});" + HTML_LF
		cJS += "var " + cName + " = new THREE.Points(" + cName + "_geo, " + cName + "_mat);" + HTML_LF
		cJS += "scene_" + cCanvasId + ".add(" + cName + ");" + HTML_LF
		addBodyScript(cJS)
		return self

	# ---- Camera Controls ----

	# Mouse-based orbit controls (simple implementation without external OrbitControls)
	func threeJSMouseLook cCanvasId, aOptions
		cSensitivity = htmlGetOpt(aOptions, "sensitivity", "0.005")

		cJS = "(function() {" + HTML_LF
		cJS += "  var isDragging = false, prevX = 0, prevY = 0;" + HTML_LF
		cJS += "  var rotX = 0, rotY = 0;" + HTML_LF
		cJS += "  var cam = camera_" + cCanvasId + ";" + HTML_LF
		cJS += "  var dist = cam.position.length();" + HTML_LF
		cJS += "  canvas_" + cCanvasId + ".addEventListener('mousedown', function(e) { isDragging = true; prevX = e.clientX; prevY = e.clientY; });" + HTML_LF
		cJS += "  window.addEventListener('mouseup', function() { isDragging = false; });" + HTML_LF
		cJS += "  canvas_" + cCanvasId + ".addEventListener('mousemove', function(e) {" + HTML_LF
		cJS += "    if(!isDragging) return;" + HTML_LF
		cJS += "    rotY += (e.clientX - prevX) * " + cSensitivity + ";" + HTML_LF
		cJS += "    rotX += (e.clientY - prevY) * " + cSensitivity + ";" + HTML_LF
		cJS += "    rotX = Math.max(-Math.PI/2.1, Math.min(Math.PI/2.1, rotX));" + HTML_LF
		cJS += "    cam.position.x = dist * Math.sin(rotY) * Math.cos(rotX);" + HTML_LF
		cJS += "    cam.position.y = dist * Math.sin(rotX);" + HTML_LF
		cJS += "    cam.position.z = dist * Math.cos(rotY) * Math.cos(rotX);" + HTML_LF
		cJS += "    cam.lookAt(0, 0, 0);" + HTML_LF
		cJS += "    prevX = e.clientX; prevY = e.clientY;" + HTML_LF
		cJS += "  });" + HTML_LF
		cJS += "  canvas_" + cCanvasId + ".addEventListener('wheel', function(e) {" + HTML_LF
		cJS += "    dist += e.deltaY * 0.01;" + HTML_LF
		cJS += "    dist = Math.max(1, Math.min(100, dist));" + HTML_LF
		cJS += "    cam.position.normalize().multiplyScalar(dist);" + HTML_LF
		cJS += "    cam.lookAt(0, 0, 0);" + HTML_LF
		cJS += "  });" + HTML_LF
		cJS += "})();" + HTML_LF
		addBodyScript(cJS)
		return self

	# ---- Keyboard Input ----

	# Keyboard state tracker + optional WASD movement for a mesh
	func threeJSKeyboardControls cCanvasId, cMeshName, aOptions
		cSpeed = htmlGetOpt(aOptions, "speed", "5")
		lUseArrows = htmlGetOpt(aOptions, "arrows", true)
		lUseWASD = htmlGetOpt(aOptions, "wasd", true)
		lJump = htmlGetOpt(aOptions, "jump", false)
		cJumpForce = htmlGetOpt(aOptions, "jumpForce", "8")
		cGravity = htmlGetOpt(aOptions, "gravity", "20")
		cGroundY = htmlGetOpt(aOptions, "groundY", "0.5")
		cRotateSpeed = htmlGetOpt(aOptions, "rotateSpeed", "10")

		cJS = "var keys_" + cCanvasId + " = {};" + HTML_LF
		cJS += "var vel_" + cCanvasId + " = {y: 0, grounded: true};" + HTML_LF
		cJS += "window.addEventListener('keydown', function(e) { keys_" + cCanvasId + "[e.key.toLowerCase()] = true; });" + HTML_LF
		cJS += "window.addEventListener('keyup', function(e) { keys_" + cCanvasId + "[e.key.toLowerCase()] = false; });" + HTML_LF

		# Movement animation callback with rotation
		cJS += "animCallbacks_" + cCanvasId + ".push(function(delta) {" + HTML_LF
		cJS += "  var spd = " + cSpeed + " * delta;" + HTML_LF
		cJS += "  var k = keys_" + cCanvasId + ";" + HTML_LF
		cJS += "  var moveX = 0, moveZ = 0;" + HTML_LF

		# Gather input direction
		# W/Up = +Z (forward), S/Down = -Z (back), A/Left = +X, D/Right = -X
		if lUseWASD and lUseArrows
			cJS += "  if(k['w'] || k['arrowup']) moveZ += 1;" + HTML_LF
			cJS += "  if(k['s'] || k['arrowdown']) moveZ -= 1;" + HTML_LF
			cJS += "  if(k['a'] || k['arrowleft']) moveX += 1;" + HTML_LF
			cJS += "  if(k['d'] || k['arrowright']) moveX -= 1;" + HTML_LF
		but lUseWASD
			cJS += "  if(k['w']) moveZ += 1;" + HTML_LF
			cJS += "  if(k['s']) moveZ -= 1;" + HTML_LF
			cJS += "  if(k['a']) moveX += 1;" + HTML_LF
			cJS += "  if(k['d']) moveX -= 1;" + HTML_LF
		but lUseArrows
			cJS += "  if(k['arrowup']) moveZ += 1;" + HTML_LF
			cJS += "  if(k['arrowdown']) moveZ -= 1;" + HTML_LF
			cJS += "  if(k['arrowleft']) moveX += 1;" + HTML_LF
			cJS += "  if(k['arrowright']) moveX -= 1;" + HTML_LF
		ok

		# Normalize diagonal movement and apply
		cJS += "  if(moveX !== 0 || moveZ !== 0) {" + HTML_LF
		cJS += "    var len = Math.sqrt(moveX*moveX + moveZ*moveZ);" + HTML_LF
		cJS += "    moveX /= len; moveZ /= len;" + HTML_LF
		cJS += "    " + cMeshName + ".position.x += moveX * spd;" + HTML_LF
		cJS += "    " + cMeshName + ".position.z += moveZ * spd;" + HTML_LF
		# Rotate to face movement direction
		cJS += "    var targetAngle = Math.atan2(moveX, moveZ);" + HTML_LF
		cJS += "    var currAngle = " + cMeshName + ".rotation.y;" + HTML_LF
		cJS += "    var diff = targetAngle - currAngle;" + HTML_LF
		# Shortest rotation path
		cJS += "    while(diff > Math.PI) diff -= Math.PI*2;" + HTML_LF
		cJS += "    while(diff < -Math.PI) diff += Math.PI*2;" + HTML_LF
		cJS += "    " + cMeshName + ".rotation.y += diff * Math.min(1, " + cRotateSpeed + " * delta);" + HTML_LF
		cJS += "  }" + HTML_LF

		if lJump
			cJS += "  if((k[' '] || k['space']) && vel_" + cCanvasId + ".grounded) {" + HTML_LF
			cJS += "    vel_" + cCanvasId + ".y = " + cJumpForce + "; vel_" + cCanvasId + ".grounded = false;" + HTML_LF
			cJS += "  }" + HTML_LF
			cJS += "  vel_" + cCanvasId + ".y -= " + cGravity + " * delta;" + HTML_LF
			cJS += "  " + cMeshName + ".position.y += vel_" + cCanvasId + ".y * delta;" + HTML_LF
			cJS += "  if(" + cMeshName + ".position.y <= " + cGroundY + ") {" + HTML_LF
			cJS += "    " + cMeshName + ".position.y = " + cGroundY + "; vel_" + cCanvasId + ".y = 0; vel_" + cCanvasId + ".grounded = true;" + HTML_LF
			cJS += "  }" + HTML_LF
		ok

		cJS += "});" + HTML_LF
		addBodyScript(cJS)
		return self

	# Camera follow (3rd person)
	func threeJSCameraFollow cCanvasId, cMeshName, aOptions
		cOffsetX = htmlGetOpt(aOptions, "offsetX", "0")
		cOffsetY = htmlGetOpt(aOptions, "offsetY", "5")
		cOffsetZ = htmlGetOpt(aOptions, "offsetZ", "10")
		cSmooth = htmlGetOpt(aOptions, "smooth", "5")

		cJSCode = "var tgt=new THREE.Vector3(" + cMeshName + ".position.x+" + cOffsetX + "," + cMeshName + ".position.y+" + cOffsetY + "," + cMeshName + ".position.z+" + cOffsetZ + ");"
		cJSCode += "camera_" + cCanvasId + ".position.lerp(tgt, " + cSmooth + "*delta);"
		cJSCode += "camera_" + cCanvasId + ".lookAt(" + cMeshName + ".position);"
		return threeJSOnAnimate(cCanvasId, cJSCode)

	# ---- Collision / Raycasting ----

	# Simple AABB collision check between two meshes (returns JS function)
	func threeJSCollisionCheck cCanvasId, cMeshA, cMeshB, cJSOnCollide
		cJSCode = "var boxA=new THREE.Box3().setFromObject(" + cMeshA + ");"
		cJSCode += "var boxB=new THREE.Box3().setFromObject(" + cMeshB + ");"
		cJSCode += "if(boxA.intersectsBox(boxB)){" + cJSOnCollide + "}"
		return threeJSOnAnimate(cCanvasId, cJSCode)

	# ---- HUD / Overlay ----

	# Add a 2D HTML overlay on top of the 3D canvas
	func threeJSOverlay cCanvasId, cHTMLContent, aOptions
		cPosition = htmlGetOpt(aOptions, "position", "top-left")
		cStyle = htmlGetOpt(aOptions, "style", "")
		cID = htmlGetOpt(aOptions, "id", "hud-" + cCanvasId)
		lInteractive = htmlGetOpt(aOptions, "interactive", false)

		cPosStyle = "top:10px;left:10px"
		if cPosition = "top-right" cPosStyle = "top:10px;right:10px" ok
		if cPosition = "bottom-left" cPosStyle = "bottom:10px;left:10px" ok
		if cPosition = "bottom-right" cPosStyle = "bottom:10px;right:10px" ok
		if cPosition = "center" cPosStyle = "top:50%;left:50%;transform:translate(-50%,-50%)" ok

		if lInteractive
			cPointerStyle = "pointer-events:auto;"
		else
			cPointerStyle = "pointer-events:none;"
		ok

		appendContent('<div id="' + cID + '" style="position:absolute;' + cPosStyle + ';z-index:10;color:#fff;font-family:monospace;padding:10px;' + cPointerStyle + cStyle + '">' + cHTMLContent + '</div>')
		return self

	# Update HUD text from animation loop
	func threeJSUpdateHUD cCanvasId, cElementId, cJSExpression
		cJSCode = 'document.getElementById("' + cElementId + '").innerHTML = ' + cJSExpression + ';'
		return threeJSOnAnimate(cCanvasId, cJSCode)

	# ---- Score / Game State ----

	# Add a game state variable (accessible in animation callbacks)
	func threeJSGameVar cName, cInitialValue
		cJS = "var " + cName + " = " + cInitialValue + ";" + char(10)
		addBodyScript(cJS)
		return self

	# ---- Cloning ----

	# Clone an existing mesh
	func threeJSClone cCanvasId, cOriginalName, cCloneName, aOptions
		cX = htmlGetOpt(aOptions, "x", "0")
		cY = htmlGetOpt(aOptions, "y", "0")
		cZ = htmlGetOpt(aOptions, "z", "0")

		cJS = "var " + cCloneName + " = " + cOriginalName + ".clone();" + HTML_LF
		cJS += cCloneName + ".position.set(" + cX + ", " + cY + ", " + cZ + ");" + HTML_LF
		cJS += "scene_" + cCanvasId + ".add(" + cCloneName + ");" + HTML_LF
		addBodyScript(cJS)
		return self

	# ---- Custom JS Injection ----

	# Add raw Three.js JavaScript (for advanced use)
	func threeJSRaw cJS
		addBodyScript(cJS + char(10))
		return self

	# ---- Utility ----

	func threeJSBool cValue
		if cValue return "true" ok
		return "false"


	# ====================================================================
	# Three.js Shaders & Post-Processing
	# ====================================================================
	# Custom vertex/fragment shaders, ShaderMaterial, uniforms,
	# built-in shader presets, and post-processing effects.
	# ====================================================================

	# ---- Custom ShaderMaterial ----

	# Create a mesh with custom vertex and fragment shaders
	# name: JS variable name for the mesh
	# geometry: "box","sphere","plane","torus","torusknot","cylinder","icosahedron","dodecahedron"
	# geoParams: list of geometry constructor args as string e.g. "2, 2, 2"
	# vertexShader: GLSL vertex shader code
	# fragmentShader: GLSL fragment shader code
	# uniforms: list of [uniformName, type, value]
	#   types: "float","int","vec2","vec3","vec4","color","sampler2D"
	# options: [:x,:y,:z,:rx,:ry,:rz,:transparent,:side,:wireframe,:depthWrite]
	func threeJSShaderMaterial cCanvasId, cName, cGeometry, cGeoParams, cVertexShader, cFragmentShader, aUniforms, aOptions
		cX = htmlGetOpt(aOptions, "x", "0")
		cY = htmlGetOpt(aOptions, "y", "0")
		cZ = htmlGetOpt(aOptions, "z", "0")
		cRX = htmlGetOpt(aOptions, "rx", "")
		cRY = htmlGetOpt(aOptions, "ry", "")
		cRZ = htmlGetOpt(aOptions, "rz", "")
		lTransparent = htmlGetOpt(aOptions, "transparent", false)
		cSide = htmlGetOpt(aOptions, "side", "")
		lWireframe = htmlGetOpt(aOptions, "wireframe", false)
		cDepthWrite = htmlGetOpt(aOptions, "depthWrite", "")


		# Build uniforms object
		cJS = "var " + cName + "_uniforms = {" + HTML_LF
		if islist(aUniforms)
			nUniformLen = len(aUniforms)
			for nUniform = 1 to nUniformLen
				cUName = aUniforms[nUniform][1]
				cUType = aUniforms[nUniform][2]
				cUVal = aUniforms[nUniform][3]
				if nUniform > 1 cJS += "," + HTML_LF ok
				if cUType = "float" or cUType = "int"
					cJS += "  " + cUName + ": { value: " + cUVal + " }"
				but cUType = "vec2"
					cJS += "  " + cUName + ": { value: new THREE.Vector2(" + cUVal + ") }"
				but cUType = "vec3"
					cJS += "  " + cUName + ": { value: new THREE.Vector3(" + cUVal + ") }"
				but cUType = "vec4"
					cJS += "  " + cUName + ": { value: new THREE.Vector4(" + cUVal + ") }"
				but cUType = "color"
					cJS += "  " + cUName + ": { value: new THREE.Color(" + cUVal + ") }"
				but cUType = "sampler2D" or cUType = "sampler2d" or cUType = "texture"
					cJS += "  " + cUName + ": { value: null }"
				else
					cJS += "  " + cUName + ": { value: " + cUVal + " }"
				ok
			next
		ok
		cJS += HTML_LF + "};" + HTML_LF

		# Always add common uniforms (time, resolution, mouse)
		cJS += cName + "_uniforms.uTime = { value: 0.0 };" + HTML_LF
		cJS += cName + "_uniforms.uResolution = { value: new THREE.Vector2(window.innerWidth, window.innerHeight) };" + HTML_LF
		cJS += cName + "_uniforms.uMouse = { value: new THREE.Vector2(0.5, 0.5) };" + HTML_LF

		# Shader material
		cJS += "var " + cName + "_material = new THREE.ShaderMaterial({" + HTML_LF
		cJS += "  uniforms: " + cName + "_uniforms," + HTML_LF
		cJS += "  vertexShader: " + HTML_BT + cVertexShader + HTML_BT + "," + HTML_LF
		cJS += "  fragmentShader: " + HTML_BT + cFragmentShader + HTML_BT + "," + HTML_LF
		if lTransparent cJS += "  transparent: true," + HTML_LF ok
		if lWireframe cJS += "  wireframe: true," + HTML_LF ok
		if cSide = "double" cJS += "  side: THREE.DoubleSide," + HTML_LF ok
		if cSide = "back" cJS += "  side: THREE.BackSide," + HTML_LF ok
		if cDepthWrite != "" cJS += "  depthWrite: " + cDepthWrite + "," + HTML_LF ok
		cJS += "});" + HTML_LF

		# Geometry
		cGeoClass = threeJSGeoClass(cGeometry)
		cJS += "var " + cName + "_geo = new THREE." + cGeoClass + "(" + cGeoParams + ");" + HTML_LF

		# Mesh
		cJS += "var " + cName + " = new THREE.Mesh(" + cName + "_geo, " + cName + "_material);" + HTML_LF
		cJS += cName + ".position.set(" + cX + ", " + cY + ", " + cZ + ");" + HTML_LF
		if cRX != "" cJS += cName + ".rotation.x = " + cRX + ";" + HTML_LF ok
		if cRY != "" cJS += cName + ".rotation.y = " + cRY + ";" + HTML_LF ok
		if cRZ != "" cJS += cName + ".rotation.z = " + cRZ + ";" + HTML_LF ok
		cJS += "scene_" + cCanvasId + ".add(" + cName + ");" + HTML_LF

		# Auto-update uTime in animation loop
		cJS += "animCallbacks_" + cCanvasId + ".push(function(delta, elapsed) {" + HTML_LF
		cJS += "  " + cName + "_uniforms.uTime.value = elapsed;" + HTML_LF
		cJS += "});" + HTML_LF

		addBodyScript(cJS)
		return self

	# Helper: geometry name to Three.js class
	func threeJSGeoClass cGeoName
		cGeoName = lower(cGeoName)
		if cGeoName = "box" return "BoxGeometry" ok
		if cGeoName = "sphere" return "SphereGeometry" ok
		if cGeoName = "plane" return "PlaneGeometry" ok
		if cGeoName = "torus" return "TorusGeometry" ok
		if cGeoName = "torusknot" return "TorusKnotGeometry" ok
		if cGeoName = "cylinder" return "CylinderGeometry" ok
		if cGeoName = "cone" return "ConeGeometry" ok
		if cGeoName = "icosahedron" return "IcosahedronGeometry" ok
		if cGeoName = "dodecahedron" return "DodecahedronGeometry" ok
		if cGeoName = "octahedron" return "OctahedronGeometry" ok
		if cGeoName = "ring" return "RingGeometry" ok
		return "SphereGeometry"

	# ---- Update Shader Uniform at Runtime ----

	# Set a uniform value from JS (use in animation callbacks or events)
	func threeJSSetUniform cName, cUniformName, cJSValue
		return cName + "_uniforms." + cUniformName + ".value = " + cJSValue + ";"

	# ---- Mouse Tracking for Shaders ----

	# Enable mouse position tracking and feed into shader uMouse uniform
	func threeJSShaderMouse cCanvasId, cName
		cJS = "window.addEventListener('mousemove', function(e) {" + HTML_LF
		cJS += "  " + cName + "_uniforms.uMouse.value.x = e.clientX / window.innerWidth;" + HTML_LF
		cJS += "  " + cName + "_uniforms.uMouse.value.y = 1.0 - (e.clientY / window.innerHeight);" + HTML_LF
		cJS += "});" + HTML_LF
		addBodyScript(cJS)
		return self

	# ---- Load Texture for Shader ----

	# Load a texture and assign to a sampler2D uniform
	func threeJSShaderTexture cName, cUniformName, cTextureUrl, aOptions
		cWrapS = htmlGetOpt(aOptions, "wrapS", "repeat")
		cWrapT = htmlGetOpt(aOptions, "wrapT", "repeat")
		cRepeatX = htmlGetOpt(aOptions, "tileX", "1")
		cRepeatY = htmlGetOpt(aOptions, "tileY", "1")

		cJS = "new THREE.TextureLoader().load(" + HTML_DQ + cTextureUrl + HTML_DQ + ", function(tex) {" + HTML_LF
		if cWrapS = "repeat"
			cJS += "  tex.wrapS = THREE.RepeatWrapping;" + HTML_LF
		ok
		if cWrapT = "repeat"
			cJS += "  tex.wrapT = THREE.RepeatWrapping;" + HTML_LF
		ok
		cJS += "  tex.repeat.set(" + cRepeatX + ", " + cRepeatY + ");" + HTML_LF
		cJS += "  " + cName + "_uniforms." + cUniformName + ".value = tex;" + HTML_LF
		cJS += "  " + cName + "_material.needsUpdate = true;" + HTML_LF
		cJS += "});" + HTML_LF
		addBodyScript(cJS)
		return self

	# ---- Apply Custom Shader to Existing Mesh ----

	# Replace an existing mesh's material with a ShaderMaterial
	func threeJSApplyShader cMeshName, cShaderName, cVertexShader, cFragmentShader, aUniforms

		# Build uniforms
		cJS = "var " + cShaderName + "_uniforms = {" + HTML_LF
		cJS += "  uTime: { value: 0.0 }," + HTML_LF
		cJS += "  uResolution: { value: new THREE.Vector2(window.innerWidth, window.innerHeight) }," + HTML_LF
		cJS += "  uMouse: { value: new THREE.Vector2(0.5, 0.5) }"
		if islist(aUniforms)
			nUniformLen = len(aUniforms)
			for nUniform = 1 to nUniformLen
				cUName = aUniforms[nUniform][1]
				cUType = aUniforms[nUniform][2]
				cUVal = aUniforms[nUniform][3]
				cJS += "," + HTML_LF
				if cUType = "float" or cUType = "int"
					cJS += "  " + cUName + ": { value: " + cUVal + " }"
				but cUType = "vec3"
					cJS += "  " + cUName + ": { value: new THREE.Vector3(" + cUVal + ") }"
				but cUType = "color"
					cJS += "  " + cUName + ": { value: new THREE.Color(" + cUVal + ") }"
				else
					cJS += "  " + cUName + ": { value: " + cUVal + " }"
				ok
			next
		ok
		cJS += HTML_LF + "};" + HTML_LF

		cJS += cShaderName + "_material = new THREE.ShaderMaterial({" + HTML_LF
		cJS += "  uniforms: " + cShaderName + "_uniforms," + HTML_LF
		cJS += "  vertexShader: " + HTML_BT + cVertexShader + HTML_BT + "," + HTML_LF
		cJS += "  fragmentShader: " + HTML_BT + cFragmentShader + HTML_BT + "" + HTML_LF
		cJS += "});" + HTML_LF
		cJS += cMeshName + ".material = " + cShaderName + "_material;" + HTML_LF

		addBodyScript(cJS)
		return self

	# ====================================================================
	# Built-in Shader Presets
	# ====================================================================
	# Ready-to-use visual effects — just specify geometry and options.
	# Each preset provides tuned vertex + fragment shaders with
	# time-based animation and configurable parameters.
	# ====================================================================

	# ---- Gradient Shader ----
	# Animated vertical/radial gradient with configurable colors
	func threeJSShaderGradient cCanvasId, cName, cGeometry, cGeoParams, aOptions
		cColor1 = htmlGetOpt(aOptions, "color1", "0x6c5ce7")
		cColor2 = htmlGetOpt(aOptions, "color2", "0x00cec9")
		cDirection = htmlGetOpt(aOptions, "direction", "vertical")
		lAnimate = htmlGetOpt(aOptions, "animate", true)
		cSpeed = htmlGetOpt(aOptions, "speed", "0.5")

		cVS = threeJSDefaultVS()

		cFS = "uniform float uTime;" + char(10)
		cFS += "uniform vec3 uColor1;" + char(10)
		cFS += "uniform vec3 uColor2;" + char(10)
		cFS += "varying vec2 vUv;" + char(10)
		cFS += "void main() {" + char(10)
		if cDirection = "radial"
			cFS += "  float d = distance(vUv, vec2(0.5));" + char(10)
			if lAnimate
				cFS += "  d = d + sin(uTime * " + cSpeed + ") * 0.15;" + char(10)
			ok
			cFS += "  gl_FragColor = vec4(mix(uColor1, uColor2, d), 1.0);" + char(10)
		else
			if lAnimate
				cFS += "  float t = vUv.y + sin(uTime * " + cSpeed + ") * 0.2;" + char(10)
			else
				cFS += "  float t = vUv.y;" + char(10)
			ok
			cFS += "  gl_FragColor = vec4(mix(uColor1, uColor2, t), 1.0);" + char(10)
		ok
		cFS += "}"

		aUniforms = [
			["uColor1", "color", cColor1],
			["uColor2", "color", cColor2]
		]

		return threeJSShaderMaterial(cCanvasId, cName, cGeometry, cGeoParams, cVS, cFS, aUniforms, aOptions)

	# ---- Wave / Displacement Shader ----
	# Vertex displacement with sine waves
	func threeJSShaderWave cCanvasId, cName, cGeometry, cGeoParams, aOptions
		cAmplitude = htmlGetOpt(aOptions, "amplitude", "0.3")
		cFrequency = htmlGetOpt(aOptions, "frequency", "3.0")
		cSpeed = htmlGetOpt(aOptions, "speed", "2.0")
		cColor1 = htmlGetOpt(aOptions, "color1", "0x0984e3")
		cColor2 = htmlGetOpt(aOptions, "color2", "0x00cec9")
		cAxis = htmlGetOpt(aOptions, "axis", "y")

		cVS = "uniform float uTime;" + char(10)
		cVS += "uniform float uAmplitude;" + char(10)
		cVS += "uniform float uFrequency;" + char(10)
		cVS += "varying vec2 vUv;" + char(10)
		cVS += "varying float vDisp;" + char(10)
		cVS += "void main() {" + char(10)
		cVS += "  vUv = uv;" + char(10)
		cVS += "  vec3 pos = position;" + char(10)
		if cAxis = "y"
			cVS += "  float wave = sin(pos.x * uFrequency + uTime * " + cSpeed + ") * uAmplitude;" + char(10)
			cVS += "  wave += sin(pos.z * uFrequency * 0.7 + uTime * " + cSpeed + " * 0.8) * uAmplitude * 0.5;" + char(10)
			cVS += "  pos.y += wave;" + char(10)
		but cAxis = "x"
			cVS += "  float wave = sin(pos.y * uFrequency + uTime * " + cSpeed + ") * uAmplitude;" + char(10)
			cVS += "  pos.x += wave;" + char(10)
		else
			cVS += "  float wave = sin(pos.x * uFrequency + uTime * " + cSpeed + ") * uAmplitude;" + char(10)
			cVS += "  pos.z += wave;" + char(10)
		ok
		cVS += "  vDisp = wave / uAmplitude;" + char(10)
		cVS += "  gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);" + char(10)
		cVS += "}"

		cFS = "uniform vec3 uColor1;" + char(10)
		cFS += "uniform vec3 uColor2;" + char(10)
		cFS += "varying vec2 vUv;" + char(10)
		cFS += "varying float vDisp;" + char(10)
		cFS += "void main() {" + char(10)
		cFS += "  float t = vDisp * 0.5 + 0.5;" + char(10)
		cFS += "  gl_FragColor = vec4(mix(uColor1, uColor2, t), 1.0);" + char(10)
		cFS += "}"

		aUniforms = [
			["uAmplitude", "float", cAmplitude],
			["uFrequency", "float", cFrequency],
			["uColor1", "color", cColor1],
			["uColor2", "color", cColor2]
		]

		return threeJSShaderMaterial(cCanvasId, cName, cGeometry, cGeoParams, cVS, cFS, aUniforms, aOptions)

	# ---- Fresnel / Glow Shader ----
	# Edge glow / rim lighting effect
	func threeJSShaderFresnel cCanvasId, cName, cGeometry, cGeoParams, aOptions
		cColor = htmlGetOpt(aOptions, "color", "0x6c5ce7")
		cGlowColor = htmlGetOpt(aOptions, "glowColor", "0x00cec9")
		cPower = htmlGetOpt(aOptions, "power", "2.0")
		cIntensity = htmlGetOpt(aOptions, "intensity", "1.5")
		lAnimate = htmlGetOpt(aOptions, "animate", true)
		cSpeed = htmlGetOpt(aOptions, "speed", "1.0")

		cVS = "varying vec3 vNormal;" + char(10)
		cVS += "varying vec3 vViewDir;" + char(10)
		cVS += "varying vec2 vUv;" + char(10)
		cVS += "void main() {" + char(10)
		cVS += "  vUv = uv;" + char(10)
		cVS += "  vNormal = normalize(normalMatrix * normal);" + char(10)
		cVS += "  vec4 mvPos = modelViewMatrix * vec4(position, 1.0);" + char(10)
		cVS += "  vViewDir = normalize(-mvPos.xyz);" + char(10)
		cVS += "  gl_Position = projectionMatrix * mvPos;" + char(10)
		cVS += "}"

		cFS = "uniform float uTime;" + char(10)
		cFS += "uniform vec3 uColor;" + char(10)
		cFS += "uniform vec3 uGlowColor;" + char(10)
		cFS += "uniform float uPower;" + char(10)
		cFS += "uniform float uIntensity;" + char(10)
		cFS += "varying vec3 vNormal;" + char(10)
		cFS += "varying vec3 vViewDir;" + char(10)
		cFS += "varying vec2 vUv;" + char(10)
		cFS += "void main() {" + char(10)
		cFS += "  float fresnel = pow(1.0 - abs(dot(vNormal, vViewDir)), uPower);" + char(10)
		if lAnimate
			cFS += "  fresnel *= uIntensity * (0.7 + 0.3 * sin(uTime * " + cSpeed + "));" + char(10)
		else
			cFS += "  fresnel *= uIntensity;" + char(10)
		ok
		cFS += "  vec3 col = mix(uColor, uGlowColor, fresnel);" + char(10)
		cFS += "  gl_FragColor = vec4(col, 0.3 + fresnel * 0.7);" + char(10)
		cFS += "}"

		aUniforms = [
			["uColor", "color", cColor],
			["uGlowColor", "color", cGlowColor],
			["uPower", "float", cPower],
			["uIntensity", "float", cIntensity]
		]

		# Force transparent for glow effect
		add(aOptions, ["transparent", true])

		return threeJSShaderMaterial(cCanvasId, cName, cGeometry, cGeoParams, cVS, cFS, aUniforms, aOptions)

	# ---- Noise / Procedural Shader ----
	# Perlin-style noise patterns
	func threeJSShaderNoise cCanvasId, cName, cGeometry, cGeoParams, aOptions
		cColor1 = htmlGetOpt(aOptions, "color1", "0x2d3436")
		cColor2 = htmlGetOpt(aOptions, "color2", "0x6c5ce7")
		cNoiseScale = htmlGetOpt(aOptions, "noiseScale", "3.0")
		cSpeed = htmlGetOpt(aOptions, "speed", "0.5")
		lDistort = htmlGetOpt(aOptions, "distort", false)
		cDistortAmt = htmlGetOpt(aOptions, "distortAmount", "0.2")

		# Simplex noise GLSL (compact 3D noise)
		cNoiseFunc = "vec3 mod289(vec3 x){return x-floor(x*(1.0/289.0))*289.0;}" + char(10)
		cNoiseFunc += "vec4 mod289(vec4 x){return x-floor(x*(1.0/289.0))*289.0;}" + char(10)
		cNoiseFunc += "vec4 permute(vec4 x){return mod289(((x*34.0)+1.0)*x);}" + char(10)
		cNoiseFunc += "vec4 taylorInvSqrt(vec4 r){return 1.79284291400159-0.85373472095314*r;}" + char(10)
		cNoiseFunc += "float snoise(vec3 v){" + char(10)
		cNoiseFunc += "  const vec2 C=vec2(1.0/6.0,1.0/3.0);const vec4 D=vec4(0.0,0.5,1.0,2.0);" + char(10)
		cNoiseFunc += "  vec3 i=floor(v+dot(v,C.yyy));vec3 x0=v-i+dot(i,C.xxx);" + char(10)
		cNoiseFunc += "  vec3 g=step(x0.yzx,x0.xyz);vec3 l=1.0-g;" + char(10)
		cNoiseFunc += "  vec3 i1=min(g.xyz,l.zxy);vec3 i2=max(g.xyz,l.zxy);" + char(10)
		cNoiseFunc += "  vec3 x1=x0-i1+C.xxx;vec3 x2=x0-i2+C.yyy;vec3 x3=x0-D.yyy;" + char(10)
		cNoiseFunc += "  i=mod289(i);" + char(10)
		cNoiseFunc += "  vec4 p=permute(permute(permute(i.z+vec4(0.0,i1.z,i2.z,1.0))+i.y+vec4(0.0,i1.y,i2.y,1.0))+i.x+vec4(0.0,i1.x,i2.x,1.0));" + char(10)
		cNoiseFunc += "  float n_=0.142857142857;vec3 ns=n_*D.wyz-D.xzx;" + char(10)
		cNoiseFunc += "  vec4 j=p-49.0*floor(p*ns.z*ns.z);" + char(10)
		cNoiseFunc += "  vec4 x_=floor(j*ns.z);vec4 y_=floor(j-7.0*x_);" + char(10)
		cNoiseFunc += "  vec4 x=x_*ns.x+ns.yyyy;vec4 y=y_*ns.x+ns.yyyy;" + char(10)
		cNoiseFunc += "  vec4 h=1.0-abs(x)-abs(y);" + char(10)
		cNoiseFunc += "  vec4 b0=vec4(x.xy,y.xy);vec4 b1=vec4(x.zw,y.zw);" + char(10)
		cNoiseFunc += "  vec4 s0=floor(b0)*2.0+1.0;vec4 s1=floor(b1)*2.0+1.0;" + char(10)
		cNoiseFunc += "  vec4 sh=-step(h,vec4(0.0));" + char(10)
		cNoiseFunc += "  vec4 a0=b0.xzyw+s0.xzyw*sh.xxyy;vec4 a1=b1.xzyw+s1.xzyw*sh.zzww;" + char(10)
		cNoiseFunc += "  vec3 p0=vec3(a0.xy,h.x);vec3 p1=vec3(a0.zw,h.y);vec3 p2=vec3(a1.xy,h.z);vec3 p3=vec3(a1.zw,h.w);" + char(10)
		cNoiseFunc += "  vec4 norm=taylorInvSqrt(vec4(dot(p0,p0),dot(p1,p1),dot(p2,p2),dot(p3,p3)));" + char(10)
		cNoiseFunc += "  p0*=norm.x;p1*=norm.y;p2*=norm.z;p3*=norm.w;" + char(10)
		cNoiseFunc += "  vec4 m=max(0.6-vec4(dot(x0,x0),dot(x1,x1),dot(x2,x2),dot(x3,x3)),0.0);" + char(10)
		cNoiseFunc += "  m=m*m;return 42.0*dot(m*m,vec4(dot(p0,x0),dot(p1,x1),dot(p2,x2),dot(p3,x3)));" + char(10)
		cNoiseFunc += "}" + char(10)

		if lDistort
			cVS = "uniform float uTime;" + char(10)
			cVS += "uniform float uNoiseScale;" + char(10)
			cVS += "uniform float uDistortAmt;" + char(10)
			cVS += "varying vec2 vUv;" + char(10)
			cVS += "varying float vNoise;" + char(10)
			cVS += cNoiseFunc
			cVS += "void main() {" + char(10)
			cVS += "  vUv = uv;" + char(10)
			cVS += "  float n = snoise(position * uNoiseScale + uTime * " + cSpeed + ");" + char(10)
			cVS += "  vNoise = n;" + char(10)
			cVS += "  vec3 pos = position + normal * n * uDistortAmt;" + char(10)
			cVS += "  gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);" + char(10)
			cVS += "}"
		else
			cVS = threeJSDefaultVS()
		ok

		cFS = "uniform float uTime;" + char(10)
		cFS += "uniform float uNoiseScale;" + char(10)
		cFS += "uniform vec3 uColor1;" + char(10)
		cFS += "uniform vec3 uColor2;" + char(10)
		cFS += "varying vec2 vUv;" + char(10)
		if lDistort
			cFS += "varying float vNoise;" + char(10)
		ok
		cFS += cNoiseFunc
		cFS += "void main() {" + char(10)
		if lDistort
			cFS += "  float n = vNoise * 0.5 + 0.5;" + char(10)
		else
			cFS += "  float n = snoise(vec3(vUv * uNoiseScale, uTime * " + cSpeed + ")) * 0.5 + 0.5;" + char(10)
		ok
		cFS += "  vec3 col = mix(uColor1, uColor2, n);" + char(10)
		cFS += "  gl_FragColor = vec4(col, 1.0);" + char(10)
		cFS += "}"

		aUniforms = [
			["uNoiseScale", "float", cNoiseScale],
			["uColor1", "color", cColor1],
			["uColor2", "color", cColor2]
		]
		if lDistort
			add(aUniforms, ["uDistortAmt", "float", cDistortAmt])
		ok

		return threeJSShaderMaterial(cCanvasId, cName, cGeometry, cGeoParams, cVS, cFS, aUniforms, aOptions)

	# ---- Hologram Shader ----
	# Scan-line holographic effect with edge glow
	func threeJSShaderHologram cCanvasId, cName, cGeometry, cGeoParams, aOptions
		cColor = htmlGetOpt(aOptions, "color", "0x00cec9")
		cScanSpeed = htmlGetOpt(aOptions, "scanSpeed", "2.0")
		cScanDensity = htmlGetOpt(aOptions, "scanDensity", "40.0")
		cGlitchIntensity = htmlGetOpt(aOptions, "glitchIntensity", "0.02")

		cVS = "uniform float uTime;" + char(10)
		cVS += "uniform float uGlitch;" + char(10)
		cVS += "varying vec3 vNormal;" + char(10)
		cVS += "varying vec3 vViewDir;" + char(10)
		cVS += "varying vec3 vWorldPos;" + char(10)
		cVS += "void main() {" + char(10)
		cVS += "  vNormal = normalize(normalMatrix * normal);" + char(10)
		cVS += "  vec3 pos = position;" + char(10)
		cVS += "  float glitch = step(0.98, fract(sin(uTime * 43.0) * 4375.5453)) * uGlitch;" + char(10)
		cVS += "  pos.x += glitch * sin(pos.y * 20.0 + uTime * 50.0);" + char(10)
		cVS += "  vec4 mvPos = modelViewMatrix * vec4(pos, 1.0);" + char(10)
		cVS += "  vViewDir = normalize(-mvPos.xyz);" + char(10)
		cVS += "  vWorldPos = (modelMatrix * vec4(pos, 1.0)).xyz;" + char(10)
		cVS += "  gl_Position = projectionMatrix * mvPos;" + char(10)
		cVS += "}"

		cFS = "uniform float uTime;" + char(10)
		cFS += "uniform vec3 uColor;" + char(10)
		cFS += "uniform float uScanSpeed;" + char(10)
		cFS += "uniform float uScanDensity;" + char(10)
		cFS += "varying vec3 vNormal;" + char(10)
		cFS += "varying vec3 vViewDir;" + char(10)
		cFS += "varying vec3 vWorldPos;" + char(10)
		cFS += "void main() {" + char(10)
		cFS += "  float fresnel = pow(1.0 - abs(dot(vNormal, vViewDir)), 2.0);" + char(10)
		cFS += "  float scanLine = sin(vWorldPos.y * uScanDensity + uTime * uScanSpeed) * 0.5 + 0.5;" + char(10)
		cFS += "  scanLine = smoothstep(0.3, 0.7, scanLine);" + char(10)
		cFS += "  float alpha = 0.15 + fresnel * 0.6 + scanLine * 0.2;" + char(10)
		cFS += "  vec3 col = uColor * (0.6 + fresnel * 0.8 + scanLine * 0.3);" + char(10)
		cFS += "  gl_FragColor = vec4(col, alpha);" + char(10)
		cFS += "}"

		aUniforms = [
			["uColor", "color", cColor],
			["uScanSpeed", "float", cScanSpeed],
			["uScanDensity", "float", cScanDensity],
			["uGlitch", "float", cGlitchIntensity]
		]

		add(aOptions, ["transparent", true])

		return threeJSShaderMaterial(cCanvasId, cName, cGeometry, cGeoParams, cVS, cFS, aUniforms, aOptions)

	# ---- Fire / Flame Shader ----
	# Procedural fire effect using noise
	func threeJSShaderFire cCanvasId, cName, cGeometry, cGeoParams, aOptions
		cColor1 = htmlGetOpt(aOptions, "color1", "0xff6b35")
		cColor2 = htmlGetOpt(aOptions, "color2", "0xffd900")
		cColor3 = htmlGetOpt(aOptions, "color3", "0x500000")
		cSpeed = htmlGetOpt(aOptions, "speed", "2.0")
		cTurbulence = htmlGetOpt(aOptions, "turbulence", "5.0")

		cVS = threeJSDefaultVS()

		# Simple hash-based noise for fire (no simplex needed, lighter)
		cFS = "uniform float uTime;" + char(10)
		cFS += "uniform vec3 uColor1;" + char(10)
		cFS += "uniform vec3 uColor2;" + char(10)
		cFS += "uniform vec3 uColor3;" + char(10)
		cFS += "uniform float uTurbulence;" + char(10)
		cFS += "varying vec2 vUv;" + char(10)
		cFS += "float hash(vec2 p) { return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453); }" + char(10)
		cFS += "float noise(vec2 p) {" + char(10)
		cFS += "  vec2 i = floor(p); vec2 f = fract(p);" + char(10)
		cFS += "  f = f*f*(3.0-2.0*f);" + char(10)
		cFS += "  return mix(mix(hash(i), hash(i+vec2(1,0)), f.x), mix(hash(i+vec2(0,1)), hash(i+vec2(1,1)), f.x), f.y);" + char(10)
		cFS += "}" + char(10)
		cFS += "float fbm(vec2 p) {" + char(10)
		cFS += "  float v=0.0; float a=0.5; mat2 rot=mat2(0.8,-0.6,0.6,0.8);" + char(10)
		cFS += "  for(int i=0;i<5;i++){v+=a*noise(p);p=rot*p*2.0;a*=0.5;}" + char(10)
		cFS += "  return v;" + char(10)
		cFS += "}" + char(10)
		cFS += "void main() {" + char(10)
		cFS += "  vec2 uv = vUv;" + char(10)
		cFS += "  float t = uTime * " + cSpeed + ";" + char(10)
		cFS += "  float n = fbm(uv * uTurbulence + vec2(0.0, -t));" + char(10)
		cFS += "  n += fbm(uv * uTurbulence * 2.0 + vec2(0.0, -t * 1.5)) * 0.5;" + char(10)
		cFS += "  float shape = 1.0 - uv.y;" + char(10)
		cFS += "  shape *= smoothstep(0.0, 0.3, uv.x) * smoothstep(1.0, 0.7, uv.x);" + char(10)
		cFS += "  float fire = shape * n;" + char(10)
		cFS += "  vec3 col = mix(uColor3, uColor1, smoothstep(0.1, 0.5, fire));" + char(10)
		cFS += "  col = mix(col, uColor2, smoothstep(0.5, 0.9, fire));" + char(10)
		cFS += "  float alpha = smoothstep(0.05, 0.3, fire);" + char(10)
		cFS += "  gl_FragColor = vec4(col, alpha);" + char(10)
		cFS += "}"

		aUniforms = [
			["uColor1", "color", cColor1],
			["uColor2", "color", cColor2],
			["uColor3", "color", cColor3],
			["uTurbulence", "float", cTurbulence]
		]

		add(aOptions, ["transparent", true])
		add(aOptions, ["side", "double"])

		return threeJSShaderMaterial(cCanvasId, cName, cGeometry, cGeoParams, cVS, cFS, aUniforms, aOptions)

	# ---- Water Shader ----
	# Animated water surface with reflections and waves
	func threeJSShaderWater cCanvasId, cName, cGeometry, cGeoParams, aOptions
		cColor1 = htmlGetOpt(aOptions, "color1", "0x006994")
		cColor2 = htmlGetOpt(aOptions, "color2", "0x00b4d8")
		cWaveHeight = htmlGetOpt(aOptions, "waveHeight", "0.15")
		cWaveFreq = htmlGetOpt(aOptions, "waveFreq", "4.0")
		cSpeed = htmlGetOpt(aOptions, "speed", "1.5")
		cFoamThreshold = htmlGetOpt(aOptions, "foamThreshold", "0.6")

		cVS = "uniform float uTime;" + char(10)
		cVS += "uniform float uWaveHeight;" + char(10)
		cVS += "uniform float uWaveFreq;" + char(10)
		cVS += "varying vec2 vUv;" + char(10)
		cVS += "varying float vWave;" + char(10)
		cVS += "varying vec3 vNormal;" + char(10)
		cVS += "varying vec3 vViewDir;" + char(10)
		cVS += "void main() {" + char(10)
		cVS += "  vUv = uv;" + char(10)
		cVS += "  vec3 pos = position;" + char(10)
		cVS += "  float t = uTime * " + cSpeed + ";" + char(10)
		cVS += "  float w1 = sin(pos.x * uWaveFreq + t) * cos(pos.z * uWaveFreq * 0.7 + t * 0.8);" + char(10)
		cVS += "  float w2 = sin(pos.x * uWaveFreq * 1.5 + t * 1.3) * 0.3;" + char(10)
		cVS += "  float w3 = cos(pos.z * uWaveFreq * 2.0 + t * 0.9) * 0.15;" + char(10)
		cVS += "  float wave = (w1 + w2 + w3) * uWaveHeight;" + char(10)
		cVS += "  pos.y += wave;" + char(10)
		cVS += "  vWave = wave / uWaveHeight;" + char(10)
		cVS += "  vNormal = normalize(normalMatrix * normal);" + char(10)
		cVS += "  vec4 mvPos = modelViewMatrix * vec4(pos, 1.0);" + char(10)
		cVS += "  vViewDir = normalize(-mvPos.xyz);" + char(10)
		cVS += "  gl_Position = projectionMatrix * mvPos;" + char(10)
		cVS += "}"

		cFS = "uniform vec3 uColor1;" + char(10)
		cFS += "uniform vec3 uColor2;" + char(10)
		cFS += "uniform float uFoam;" + char(10)
		cFS += "varying vec2 vUv;" + char(10)
		cFS += "varying float vWave;" + char(10)
		cFS += "varying vec3 vNormal;" + char(10)
		cFS += "varying vec3 vViewDir;" + char(10)
		cFS += "void main() {" + char(10)
		cFS += "  float fresnel = pow(1.0 - abs(dot(vNormal, vViewDir)), 3.0);" + char(10)
		cFS += "  vec3 col = mix(uColor1, uColor2, vWave * 0.5 + 0.5);" + char(10)
		cFS += "  col += vec3(fresnel * 0.3);" + char(10)
		cFS += "  float foam = smoothstep(uFoam, 1.0, vWave);" + char(10)
		cFS += "  col = mix(col, vec3(1.0), foam * 0.6);" + char(10)
		cFS += "  gl_FragColor = vec4(col, 0.85);" + char(10)
		cFS += "}"

		aUniforms = [
			["uColor1", "color", cColor1],
			["uColor2", "color", cColor2],
			["uWaveHeight", "float", cWaveHeight],
			["uWaveFreq", "float", cWaveFreq],
			["uFoam", "float", cFoamThreshold]
		]

		add(aOptions, ["transparent", true])
		add(aOptions, ["side", "double"])

		return threeJSShaderMaterial(cCanvasId, cName, cGeometry, cGeoParams, cVS, cFS, aUniforms, aOptions)

	# ---- Dissolve Shader ----
	# Noise-based dissolve / disintegration effect
	func threeJSShaderDissolve cCanvasId, cName, cGeometry, cGeoParams, aOptions
		cColor = htmlGetOpt(aOptions, "color", "0x6c5ce7")
		cEdgeColor = htmlGetOpt(aOptions, "edgeColor", "0xff6b35")
		cDissolveSpeed = htmlGetOpt(aOptions, "speed", "0.3")
		cEdgeWidth = htmlGetOpt(aOptions, "edgeWidth", "0.05")
		cNoiseScale = htmlGetOpt(aOptions, "noiseScale", "3.0")

		cVS = "varying vec2 vUv;" + char(10)
		cVS += "varying vec3 vPosition;" + char(10)
		cVS += "void main() {" + char(10)
		cVS += "  vUv = uv;" + char(10)
		cVS += "  vPosition = position;" + char(10)
		cVS += "  gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);" + char(10)
		cVS += "}"

		cFS = "uniform float uTime;" + char(10)
		cFS += "uniform vec3 uColor;" + char(10)
		cFS += "uniform vec3 uEdgeColor;" + char(10)
		cFS += "uniform float uEdgeWidth;" + char(10)
		cFS += "uniform float uNoiseScale;" + char(10)
		cFS += "varying vec2 vUv;" + char(10)
		cFS += "varying vec3 vPosition;" + char(10)
		cFS += "float hash(vec2 p) { return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453); }" + char(10)
		cFS += "float noise(vec2 p) {" + char(10)
		cFS += "  vec2 i = floor(p); vec2 f = fract(p);" + char(10)
		cFS += "  f = f*f*(3.0-2.0*f);" + char(10)
		cFS += "  return mix(mix(hash(i), hash(i+vec2(1,0)), f.x), mix(hash(i+vec2(0,1)), hash(i+vec2(1,1)), f.x), f.y);" + char(10)
		cFS += "}" + char(10)
		cFS += "void main() {" + char(10)
		cFS += "  float n = noise(vPosition.xz * uNoiseScale) * 0.5 + noise(vPosition.xy * uNoiseScale * 2.0) * 0.3 + noise(vPosition.yz * uNoiseScale * 3.0) * 0.2;" + char(10)
		cFS += "  float dissolve = fract(uTime * " + cDissolveSpeed + ");" + char(10)
		cFS += "  if(n < dissolve) discard;" + char(10)
		cFS += "  float edge = smoothstep(dissolve, dissolve + uEdgeWidth, n);" + char(10)
		cFS += "  vec3 col = mix(uEdgeColor * 2.0, uColor, edge);" + char(10)
		cFS += "  gl_FragColor = vec4(col, 1.0);" + char(10)
		cFS += "}"

		aUniforms = [
			["uColor", "color", cColor],
			["uEdgeColor", "color", cEdgeColor],
			["uEdgeWidth", "float", cEdgeWidth],
			["uNoiseScale", "float", cNoiseScale]
		]

		return threeJSShaderMaterial(cCanvasId, cName, cGeometry, cGeoParams, cVS, cFS, aUniforms, aOptions)

	# ---- Pulse / Energy Shield Shader ----
	# Hexagonal energy shield with pulse waves
	func threeJSShaderShield cCanvasId, cName, cGeometry, cGeoParams, aOptions
		cColor = htmlGetOpt(aOptions, "color", "0x00cec9")
		cPulseSpeed = htmlGetOpt(aOptions, "pulseSpeed", "3.0")
		cHexScale = htmlGetOpt(aOptions, "hexScale", "15.0")

		cVS = "varying vec3 vNormal;" + char(10)
		cVS += "varying vec3 vViewDir;" + char(10)
		cVS += "varying vec3 vWorldPos;" + char(10)
		cVS += "varying vec2 vUv;" + char(10)
		cVS += "void main() {" + char(10)
		cVS += "  vUv = uv;" + char(10)
		cVS += "  vNormal = normalize(normalMatrix * normal);" + char(10)
		cVS += "  vec4 mvPos = modelViewMatrix * vec4(position, 1.0);" + char(10)
		cVS += "  vViewDir = normalize(-mvPos.xyz);" + char(10)
		cVS += "  vWorldPos = (modelMatrix * vec4(position, 1.0)).xyz;" + char(10)
		cVS += "  gl_Position = projectionMatrix * mvPos;" + char(10)
		cVS += "}"

		cFS = "uniform float uTime;" + char(10)
		cFS += "uniform vec3 uColor;" + char(10)
		cFS += "uniform float uPulseSpeed;" + char(10)
		cFS += "uniform float uHexScale;" + char(10)
		cFS += "varying vec3 vNormal;" + char(10)
		cFS += "varying vec3 vViewDir;" + char(10)
		cFS += "varying vec3 vWorldPos;" + char(10)
		cFS += "varying vec2 vUv;" + char(10)
		cFS += "float hex(vec2 p) {" + char(10)
		cFS += "  p = abs(p);" + char(10)
		cFS += "  return max(dot(p, vec2(1.0, 1.732) * 0.5), p.x);" + char(10)
		cFS += "}" + char(10)
		cFS += "float hexGrid(vec2 uv) {" + char(10)
		cFS += "  vec2 r = vec2(1.0, 1.732);" + char(10)
		cFS += "  vec2 h = r * 0.5;" + char(10)
		cFS += "  vec2 a = mod(uv, r) - h;" + char(10)
		cFS += "  vec2 b = mod(uv - h, r) - h;" + char(10)
		cFS += "  float da = hex(a); float db = hex(b);" + char(10)
		cFS += "  return min(da, db);" + char(10)
		cFS += "}" + char(10)
		cFS += "void main() {" + char(10)
		cFS += "  float fresnel = pow(1.0 - abs(dot(vNormal, vViewDir)), 2.5);" + char(10)
		cFS += "  float hx = hexGrid(vUv * uHexScale);" + char(10)
		cFS += "  float hexLine = 1.0 - smoothstep(0.4, 0.5, hx);" + char(10)
		cFS += "  float pulse = sin(vWorldPos.y * 5.0 - uTime * uPulseSpeed) * 0.5 + 0.5;" + char(10)
		cFS += "  float alpha = fresnel * 0.6 + hexLine * 0.3 + pulse * 0.15;" + char(10)
		cFS += "  vec3 col = uColor * (0.5 + fresnel + hexLine * 0.5 + pulse * 0.3);" + char(10)
		cFS += "  gl_FragColor = vec4(col, alpha);" + char(10)
		cFS += "}"

		aUniforms = [
			["uColor", "color", cColor],
			["uPulseSpeed", "float", cPulseSpeed],
			["uHexScale", "float", cHexScale]
		]

		add(aOptions, ["transparent", true])
		add(aOptions, ["side", "double"])

		return threeJSShaderMaterial(cCanvasId, cName, cGeometry, cGeoParams, cVS, cFS, aUniforms, aOptions)

	# ---- Default Vertex Shader (shared by fragment-only presets) ----

	func threeJSDefaultVS
		cVS = "varying vec2 vUv;" + char(10)
		cVS += "void main() {" + char(10)
		cVS += "  vUv = uv;" + char(10)
		cVS += "  gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);" + char(10)
		cVS += "}"
		return cVS


	# ====================================================================
	# Three.js Model Loading & Animation
	# ====================================================================
	# Load 3D models (GLTF/GLB, OBJ/MTL, FBX) and control skeletal
	# animations from Ring code. Supports animation mixing, speed
	# control, model transforms, and animation state machines.
	# ====================================================================

	# ---- Loader CDN Enablers ----

	# Enable GLTF/GLB model loader (most common modern format)
	func enableGLTFLoader
		lGLTFLoader = true
		return self

	# Enable OBJ model loader
	func enableOBJLoader
		lOBJLoader = true
		return self

	# Enable MTL (material) loader for OBJ models
	func enableMTLLoader
		lMTLLoader = true
		return self

	# Enable FBX model loader
	func enableFBXLoader
		lFBXLoader = true
		return self

	# Enable Collada (DAE) model loader
	func enableColladaLoader
		lColladaLoader = true
		return self

	# Enable Draco compression decoder (for compressed GLTF)
	func enableDracoDecoder
		lDracoDecoder = true
		return self

	# ---- GLTF / GLB Loading ----

	# Load a GLTF/GLB model into the scene
	# name: JS variable name for the loaded model
	# url: path to .gltf or .glb file
	# options: [:x, :y, :z, :scale, :scaleX, :scaleY, :scaleZ,
	#           :rx, :ry, :rz, :castShadow, :receiveShadow,
	#           :autoPlay (play first animation), :onLoad (JS callback code)]
	func threeJSLoadGLTF cCanvasId, cName, cURL, aOptions
		cX = htmlGetOpt(aOptions, "x", "0")
		cY = htmlGetOpt(aOptions, "y", "0")
		cZ = htmlGetOpt(aOptions, "z", "0")
		cScale = htmlGetOpt(aOptions, "scale", "1")
		cScX = htmlGetOpt(aOptions, "scaleX", "")
		cScY = htmlGetOpt(aOptions, "scaleY", "")
		cScZ = htmlGetOpt(aOptions, "scaleZ", "")
		cRX = htmlGetOpt(aOptions, "rx", "")
		cRY = htmlGetOpt(aOptions, "ry", "")
		cRZ = htmlGetOpt(aOptions, "rz", "")
		cAutoFit = htmlGetOpt(aOptions, "autoFit", "")
		lCastShadow = htmlGetOpt(aOptions, "castShadow", true)
		lReceiveShadow = htmlGetOpt(aOptions, "receiveShadow", true)
		lAutoPlay = htmlGetOpt(aOptions, "autoPlay", false)
		cOnLoad = htmlGetOpt(aOptions, "onLoad", "")


		# Declare model and mixer variables globally
		cJS = "var " + cName + " = null;" + HTML_LF
		cJS += "var " + cName + "_mixer = null;" + HTML_LF
		cJS += "var " + cName + "_actions = {};" + HTML_LF
		cJS += "var " + cName + "_clips = [];" + HTML_LF
		cJS += "var " + cName + "_currentAction = null;" + HTML_LF
		cJS += HTML_LF

		# Setup Draco decoder if enabled
		if lDracoDecoder
			cJS += "var " + cName + "_loader = new THREE.GLTFLoader();" + HTML_LF
			cJS += "var " + cName + "_draco = new THREE.DRACOLoader();" + HTML_LF
			cJS += cName + "_draco.setDecoderPath(" + HTML_DQ + "https://cdn.jsdelivr.net/npm/three@0.128.0/examples/js/libs/draco/" + HTML_DQ + ");" + HTML_LF
			cJS += cName + "_loader.setDRACOLoader(" + cName + "_draco);" + HTML_LF
		else
			cJS += "var " + cName + "_loader = new THREE.GLTFLoader();" + HTML_LF
		ok

		cJS += cName + "_loader.load(" + HTML_DQ + cURL + HTML_DQ + "," + HTML_LF
		cJS += "  function(gltf) {" + HTML_LF
		cJS += "    " + cName + " = gltf.scene;" + HTML_LF
		cJS += "    " + cName + ".position.set(" + cX + ", " + cY + ", " + cZ + ");" + HTML_LF

		# Scale — autoFit computes bounding box and normalizes to target size
		if cAutoFit != ""
			cJS += "    var _box = new THREE.Box3().setFromObject(" + cName + ");" + HTML_LF
			cJS += "    var _size = new THREE.Vector3();" + HTML_LF
			cJS += "    _box.getSize(_size);" + HTML_LF
			cJS += "    var _maxDim = Math.max(_size.x, _size.y, _size.z);" + HTML_LF
			cJS += "    if(_maxDim > 0) {" + HTML_LF
			cJS += "      var _fitScale = " + cAutoFit + " / _maxDim;" + HTML_LF
			cJS += "      " + cName + ".scale.set(_fitScale, _fitScale, _fitScale);" + HTML_LF
			cJS += "    }" + HTML_LF
			# Re-center on base after scaling
			cJS += "    var _box2 = new THREE.Box3().setFromObject(" + cName + ");" + HTML_LF
			cJS += "    " + cName + ".position.y += (" + cY + ") - _box2.min.y;" + HTML_LF
		but cScX != ""
			cJS += "    " + cName + ".scale.set(" + cScX + ", " + cScY + ", " + cScZ + ");" + HTML_LF
		else
			cJS += "    " + cName + ".scale.set(" + cScale + ", " + cScale + ", " + cScale + ");" + HTML_LF
		ok

		# Rotation
		if cRX != "" cJS += "    " + cName + ".rotation.x = " + cRX + ";" + HTML_LF ok
		if cRY != "" cJS += "    " + cName + ".rotation.y = " + cRY + ";" + HTML_LF ok
		if cRZ != "" cJS += "    " + cName + ".rotation.z = " + cRZ + ";" + HTML_LF ok

		# Shadows
		if lCastShadow or lReceiveShadow
			cJS += "    " + cName + ".traverse(function(child) {" + HTML_LF
			cJS += "      if(child.isMesh) {" + HTML_LF
			if lCastShadow cJS += "        child.castShadow = true;" + HTML_LF ok
			if lReceiveShadow cJS += "        child.receiveShadow = true;" + HTML_LF ok
			cJS += "      }" + HTML_LF
			cJS += "    });" + HTML_LF
		ok

		# Animation setup
		cJS += "    if(gltf.animations && gltf.animations.length > 0) {" + HTML_LF
		cJS += "      " + cName + "_mixer = new THREE.AnimationMixer(" + cName + ");" + HTML_LF
		cJS += "      " + cName + "_clips = gltf.animations;" + HTML_LF
		cJS += "      for(var i = 0; i < gltf.animations.length; i++) {" + HTML_LF
		cJS += "        var clip = gltf.animations[i];" + HTML_LF
		cJS += "        " + cName + "_actions[clip.name] = " + cName + "_mixer.clipAction(clip);" + HTML_LF
		cJS += "      }" + HTML_LF

		if lAutoPlay
			cJS += "      var firstClip = gltf.animations[0];" + HTML_LF
			cJS += "      " + cName + "_currentAction = " + cName + "_actions[firstClip.name];" + HTML_LF
			cJS += "      " + cName + "_currentAction.play();" + HTML_LF
		ok

		cJS += "    }" + HTML_LF

		# Add to scene
		cJS += "    scene_" + cCanvasId + ".add(" + cName + ");" + HTML_LF

		# Custom onLoad callback
		if cOnLoad != ""
			cJS += "    " + cOnLoad + HTML_LF
		ok

		cJS += "  }," + HTML_LF
		# Progress callback
		cJS += "  function(xhr) {" + HTML_LF
		cJS += "    if(xhr.total) { var pct = Math.round(xhr.loaded / xhr.total * 100); }" + HTML_LF
		cJS += "  }," + HTML_LF
		# Error callback
		cJS += "  function(error) {" + HTML_LF
		cJS += "    console.error(" + HTML_DQ + "Error loading model " + cName + ":" + HTML_DQ + ", error);" + HTML_LF
		cJS += "  }" + HTML_LF
		cJS += ");" + HTML_LF
		cJS += HTML_LF

		# Register mixer update in animation loop
		cJS += "animCallbacks_" + cCanvasId + ".push(function(delta) {" + HTML_LF
		cJS += "  if(" + cName + "_mixer) " + cName + "_mixer.update(delta);" + HTML_LF
		cJS += "});" + HTML_LF
		cJS += HTML_LF

		# Generate _playAnim helper (usable from buttons, state machines, etc.)
		cJS += "function " + cName + "_playAnim(clipName, fadeTime, doLoop, clamp, speed) {" + HTML_LF
		cJS += "  var action = " + cName + "_actions[clipName];" + HTML_LF
		cJS += "  if(!action) { console.warn(" + HTML_DQ + "Animation not found: " + HTML_DQ + " + clipName); return; }" + HTML_LF
		cJS += "  if(" + cName + "_currentAction && " + cName + "_currentAction !== action) {" + HTML_LF
		cJS += "    " + cName + "_currentAction.fadeOut(fadeTime);" + HTML_LF
		cJS += "  }" + HTML_LF
		cJS += "  action.reset();" + HTML_LF
		cJS += "  action.setEffectiveTimeScale(speed);" + HTML_LF
		cJS += "  action.setEffectiveWeight(1);" + HTML_LF
		cJS += "  if(!doLoop) {" + HTML_LF
		cJS += "    action.setLoop(THREE.LoopOnce);" + HTML_LF
		cJS += "    action.clampWhenFinished = clamp;" + HTML_LF
		cJS += "  } else {" + HTML_LF
		cJS += "    action.setLoop(THREE.LoopRepeat);" + HTML_LF
		cJS += "  }" + HTML_LF
		cJS += "  action.fadeIn(fadeTime).play();" + HTML_LF
		cJS += "  " + cName + "_currentAction = action;" + HTML_LF
		cJS += "}" + HTML_LF

		addBodyScript(cJS)
		return self

	# ---- OBJ Loading ----

	# Load an OBJ model (with optional MTL material)
	func threeJSLoadOBJ cCanvasId, cName, cOBJUrl, aOptions
		cMTLUrl = htmlGetOpt(aOptions, "mtlUrl", "")
		cX = htmlGetOpt(aOptions, "x", "0")
		cY = htmlGetOpt(aOptions, "y", "0")
		cZ = htmlGetOpt(aOptions, "z", "0")
		cScale = htmlGetOpt(aOptions, "scale", "1")
		cRX = htmlGetOpt(aOptions, "rx", "")
		cRY = htmlGetOpt(aOptions, "ry", "")
		cRZ = htmlGetOpt(aOptions, "rz", "")
		lCastShadow = htmlGetOpt(aOptions, "castShadow", true)
		cColor = htmlGetOpt(aOptions, "color", "")
		cOnLoad = htmlGetOpt(aOptions, "onLoad", "")


		cJS = "var " + cName + " = null;" + HTML_LF

		if cMTLUrl != ""
			# Load MTL first, then OBJ
			cJS += "var " + cName + "_mtlLoader = new THREE.MTLLoader();" + HTML_LF
			cJS += cName + "_mtlLoader.load(" + HTML_DQ + cMTLUrl + HTML_DQ + ", function(materials) {" + HTML_LF
			cJS += "  materials.preload();" + HTML_LF
			cJS += "  var " + cName + "_objLoader = new THREE.OBJLoader();" + HTML_LF
			cJS += "  " + cName + "_objLoader.setMaterials(materials);" + HTML_LF
			cJS += "  " + cName + "_objLoader.load(" + HTML_DQ + cOBJUrl + HTML_DQ + ", function(obj) {" + HTML_LF
			cJS += "    " + cName + " = obj;" + HTML_LF
			cJS += "    " + cName + ".position.set(" + cX + ", " + cY + ", " + cZ + ");" + HTML_LF
			cJS += "    " + cName + ".scale.set(" + cScale + ", " + cScale + ", " + cScale + ");" + HTML_LF
			if cRX != "" cJS += "    " + cName + ".rotation.x = " + cRX + ";" + HTML_LF ok
			if cRY != "" cJS += "    " + cName + ".rotation.y = " + cRY + ";" + HTML_LF ok
			if cRZ != "" cJS += "    " + cName + ".rotation.z = " + cRZ + ";" + HTML_LF ok
			if lCastShadow
				cJS += "    " + cName + ".traverse(function(c){if(c.isMesh)c.castShadow=true;});" + HTML_LF
			ok
			cJS += "    scene_" + cCanvasId + ".add(" + cName + ");" + HTML_LF
			if cOnLoad != "" cJS += "    " + cOnLoad + HTML_LF ok
			cJS += "  });" + HTML_LF
			cJS += "});" + HTML_LF
		else
			# OBJ only
			cJS += "var " + cName + "_objLoader = new THREE.OBJLoader();" + HTML_LF
			cJS += cName + "_objLoader.load(" + HTML_DQ + cOBJUrl + HTML_DQ + ", function(obj) {" + HTML_LF
			cJS += "  " + cName + " = obj;" + HTML_LF
			cJS += "  " + cName + ".position.set(" + cX + ", " + cY + ", " + cZ + ");" + HTML_LF
			cJS += "  " + cName + ".scale.set(" + cScale + ", " + cScale + ", " + cScale + ");" + HTML_LF
			if cRX != "" cJS += "  " + cName + ".rotation.x = " + cRX + ";" + HTML_LF ok
			if cRY != "" cJS += "  " + cName + ".rotation.y = " + cRY + ";" + HTML_LF ok
			if cRZ != "" cJS += "  " + cName + ".rotation.z = " + cRZ + ";" + HTML_LF ok
			if cColor != ""
				cJS += "  " + cName + ".traverse(function(c){if(c.isMesh){c.material=new THREE.MeshStandardMaterial({color:" + cColor + "});}});" + HTML_LF
			ok
			if lCastShadow
				cJS += "  " + cName + ".traverse(function(c){if(c.isMesh)c.castShadow=true;});" + HTML_LF
			ok
			cJS += "  scene_" + cCanvasId + ".add(" + cName + ");" + HTML_LF
			if cOnLoad != "" cJS += "  " + cOnLoad + HTML_LF ok
			cJS += "});" + HTML_LF
		ok

		addBodyScript(cJS)
		return self

	# ---- FBX Loading ----

	# Load an FBX model (commonly used for animated characters)
	func threeJSLoadFBX cCanvasId, cName, cURL, aOptions
		cX = htmlGetOpt(aOptions, "x", "0")
		cY = htmlGetOpt(aOptions, "y", "0")
		cZ = htmlGetOpt(aOptions, "z", "0")
		cScale = htmlGetOpt(aOptions, "scale", "0.01")
		cRX = htmlGetOpt(aOptions, "rx", "")
		cRY = htmlGetOpt(aOptions, "ry", "")
		cRZ = htmlGetOpt(aOptions, "rz", "")
		lCastShadow = htmlGetOpt(aOptions, "castShadow", true)
		lAutoPlay = htmlGetOpt(aOptions, "autoPlay", false)
		cOnLoad = htmlGetOpt(aOptions, "onLoad", "")


		cJS = "var " + cName + " = null;" + HTML_LF
		cJS += "var " + cName + "_mixer = null;" + HTML_LF
		cJS += "var " + cName + "_actions = {};" + HTML_LF
		cJS += "var " + cName + "_currentAction = null;" + HTML_LF
		cJS += HTML_LF
		cJS += "var " + cName + "_fbxLoader = new THREE.FBXLoader();" + HTML_LF
		cJS += cName + "_fbxLoader.load(" + HTML_DQ + cURL + HTML_DQ + ", function(fbx) {" + HTML_LF
		cJS += "  " + cName + " = fbx;" + HTML_LF
		cJS += "  " + cName + ".position.set(" + cX + ", " + cY + ", " + cZ + ");" + HTML_LF
		cJS += "  " + cName + ".scale.set(" + cScale + ", " + cScale + ", " + cScale + ");" + HTML_LF
		if cRX != "" cJS += "  " + cName + ".rotation.x = " + cRX + ";" + HTML_LF ok
		if cRY != "" cJS += "  " + cName + ".rotation.y = " + cRY + ";" + HTML_LF ok
		if cRZ != "" cJS += "  " + cName + ".rotation.z = " + cRZ + ";" + HTML_LF ok
		if lCastShadow
			cJS += "  " + cName + ".traverse(function(c){if(c.isMesh){c.castShadow=true;c.receiveShadow=true;}});" + HTML_LF
		ok
		cJS += "  if(fbx.animations && fbx.animations.length > 0) {" + HTML_LF
		cJS += "    " + cName + "_mixer = new THREE.AnimationMixer(" + cName + ");" + HTML_LF
		cJS += "    for(var i = 0; i < fbx.animations.length; i++) {" + HTML_LF
		cJS += "      var clip = fbx.animations[i];" + HTML_LF
		cJS += "      " + cName + "_actions[clip.name] = " + cName + "_mixer.clipAction(clip);" + HTML_LF
		cJS += "    }" + HTML_LF
		if lAutoPlay
			cJS += "    " + cName + "_currentAction = " + cName + "_mixer.clipAction(fbx.animations[0]);" + HTML_LF
			cJS += "    " + cName + "_currentAction.play();" + HTML_LF
		ok
		cJS += "  }" + HTML_LF
		cJS += "  scene_" + cCanvasId + ".add(" + cName + ");" + HTML_LF
		if cOnLoad != "" cJS += "  " + cOnLoad + HTML_LF ok
		cJS += "});" + HTML_LF
		cJS += HTML_LF
		cJS += "animCallbacks_" + cCanvasId + ".push(function(delta) {" + HTML_LF
		cJS += "  if(" + cName + "_mixer) " + cName + "_mixer.update(delta);" + HTML_LF
		cJS += "});" + HTML_LF
		cJS += HTML_LF

		# Generate _playAnim helper
		cJS += "function " + cName + "_playAnim(clipName, fadeTime, doLoop, clamp, speed) {" + HTML_LF
		cJS += "  var action = " + cName + "_actions[clipName];" + HTML_LF
		cJS += "  if(!action) { console.warn(" + HTML_DQ + "Animation not found: " + HTML_DQ + " + clipName); return; }" + HTML_LF
		cJS += "  if(" + cName + "_currentAction && " + cName + "_currentAction !== action) {" + HTML_LF
		cJS += "    " + cName + "_currentAction.fadeOut(fadeTime);" + HTML_LF
		cJS += "  }" + HTML_LF
		cJS += "  action.reset().setEffectiveTimeScale(speed).setEffectiveWeight(1);" + HTML_LF
		cJS += "  if(!doLoop){action.setLoop(THREE.LoopOnce);action.clampWhenFinished=clamp}" + HTML_LF
		cJS += "  else{action.setLoop(THREE.LoopRepeat)}" + HTML_LF
		cJS += "  action.fadeIn(fadeTime).play();" + HTML_LF
		cJS += "  " + cName + "_currentAction = action;" + HTML_LF
		cJS += "}" + HTML_LF

		addBodyScript(cJS)
		return self

	# ---- Collada (DAE) Loading ----

	# Load a Collada (.dae) model
	func threeJSLoadCollada cCanvasId, cName, cURL, aOptions
		cX = htmlGetOpt(aOptions, "x", "0")
		cY = htmlGetOpt(aOptions, "y", "0")
		cZ = htmlGetOpt(aOptions, "z", "0")
		cScale = htmlGetOpt(aOptions, "scale", "1")
		lCastShadow = htmlGetOpt(aOptions, "castShadow", true)
		lAutoPlay = htmlGetOpt(aOptions, "autoPlay", false)
		cOnLoad = htmlGetOpt(aOptions, "onLoad", "")


		cJS = "var " + cName + " = null;" + HTML_LF
		cJS += "var " + cName + "_mixer = null;" + HTML_LF
		cJS += "var " + cName + "_actions = {};" + HTML_LF
		cJS += HTML_LF
		cJS += "var " + cName + "_colladaLoader = new THREE.ColladaLoader();" + HTML_LF
		cJS += cName + "_colladaLoader.load(" + HTML_DQ + cURL + HTML_DQ + ", function(collada) {" + HTML_LF
		cJS += "  " + cName + " = collada.scene;" + HTML_LF
		cJS += "  " + cName + ".position.set(" + cX + ", " + cY + ", " + cZ + ");" + HTML_LF
		cJS += "  " + cName + ".scale.set(" + cScale + ", " + cScale + ", " + cScale + ");" + HTML_LF
		if lCastShadow
			cJS += "  " + cName + ".traverse(function(c){if(c.isMesh){c.castShadow=true;c.receiveShadow=true;}});" + HTML_LF
		ok
		cJS += "  if(collada.animations && collada.animations.length > 0) {" + HTML_LF
		cJS += "    " + cName + "_mixer = new THREE.AnimationMixer(" + cName + ");" + HTML_LF
		cJS += "    for(var i = 0; i < collada.animations.length; i++) {" + HTML_LF
		cJS += "      " + cName + "_actions[collada.animations[i].name] = " + cName + "_mixer.clipAction(collada.animations[i]);" + HTML_LF
		cJS += "    }" + HTML_LF
		if lAutoPlay
			cJS += "    " + cName + "_mixer.clipAction(collada.animations[0]).play();" + HTML_LF
		ok
		cJS += "  }" + HTML_LF
		cJS += "  scene_" + cCanvasId + ".add(" + cName + ");" + HTML_LF
		if cOnLoad != "" cJS += "  " + cOnLoad + HTML_LF ok
		cJS += "});" + HTML_LF
		cJS += HTML_LF
		cJS += "animCallbacks_" + cCanvasId + ".push(function(delta) {" + HTML_LF
		cJS += "  if(" + cName + "_mixer) " + cName + "_mixer.update(delta);" + HTML_LF
		cJS += "});" + HTML_LF
		cJS += HTML_LF

		# Generate _playAnim helper
		cJS += "function " + cName + "_playAnim(clipName, fadeTime, doLoop, clamp, speed) {" + HTML_LF
		cJS += "  var action = " + cName + "_actions[clipName];" + HTML_LF
		cJS += "  if(!action) return;" + HTML_LF
		cJS += "  if(" + cName + "_currentAction && " + cName + "_currentAction !== action) {" + HTML_LF
		cJS += "    " + cName + "_currentAction.fadeOut(fadeTime);" + HTML_LF
		cJS += "  }" + HTML_LF
		cJS += "  action.reset().setEffectiveTimeScale(speed).setEffectiveWeight(1);" + HTML_LF
		cJS += "  if(!doLoop){action.setLoop(THREE.LoopOnce);action.clampWhenFinished=clamp}" + HTML_LF
		cJS += "  else{action.setLoop(THREE.LoopRepeat)}" + HTML_LF
		cJS += "  action.fadeIn(fadeTime).play();" + HTML_LF
		cJS += "  " + cName + "_currentAction = action;" + HTML_LF
		cJS += "}" + HTML_LF

		addBodyScript(cJS)
		return self

	# ---- Animation Control ----

	# Play a named animation clip on a model
	# Crossfades from current animation with configurable duration
	func threeJSPlayAnimation cName, cClipName, aOptions
		cFadeDuration = htmlGetOpt(aOptions, "fadeDuration", "0.5")
		lLoop = htmlGetOpt(aOptions, "loop", true)
		lClampWhenFinished = htmlGetOpt(aOptions, "clampWhenFinished", false)
		cTimeScale = htmlGetOpt(aOptions, "timeScale", "1")


		# Build a callable JS function
		cFuncName = cName + "_playAnim"
		cJS = "function " + cFuncName + "(clipName, fadeTime, doLoop, clamp, speed) {" + HTML_LF
		cJS += "  var action = " + cName + "_actions[clipName];" + HTML_LF
		cJS += "  if(!action) { console.warn(" + HTML_DQ + "Animation not found: " + HTML_DQ + " + clipName); return; }" + HTML_LF
		cJS += "  if(" + cName + "_currentAction && " + cName + "_currentAction !== action) {" + HTML_LF
		cJS += "    " + cName + "_currentAction.fadeOut(fadeTime);" + HTML_LF
		cJS += "  }" + HTML_LF
		cJS += "  action.reset();" + HTML_LF
		cJS += "  action.setEffectiveTimeScale(speed);" + HTML_LF
		cJS += "  action.setEffectiveWeight(1);" + HTML_LF
		cJS += "  if(!doLoop) {" + HTML_LF
		cJS += "    action.setLoop(THREE.LoopOnce);" + HTML_LF
		cJS += "    action.clampWhenFinished = clamp;" + HTML_LF
		cJS += "  } else {" + HTML_LF
		cJS += "    action.setLoop(THREE.LoopRepeat);" + HTML_LF
		cJS += "  }" + HTML_LF
		cJS += "  action.fadeIn(fadeTime).play();" + HTML_LF
		cJS += "  " + cName + "_currentAction = action;" + HTML_LF
		cJS += "}" + HTML_LF

		# Immediately play the requested clip
		cJS += cFuncName + "(" + HTML_DQ + cClipName + HTML_DQ + ", " + cFadeDuration + ", " + threeJSBool(lLoop) + ", " + threeJSBool(lClampWhenFinished) + ", " + cTimeScale + ");" + HTML_LF

		addBodyScript(cJS)
		return self

	# Stop all animations on a model
	func threeJSStopAnimations cName
		cJS = "if(" + cName + "_mixer) {" + HTML_LF
		cJS += "  " + cName + "_mixer.stopAllAction();" + HTML_LF
		cJS += "  " + cName + "_currentAction = null;" + HTML_LF
		cJS += "}" + HTML_LF
		addBodyScript(cJS)
		return self

	# Set animation speed (timeScale)
	func threeJSAnimationSpeed cName, cSpeed
		cJS = "if(" + cName + "_currentAction) " + cName + "_currentAction.setEffectiveTimeScale(" + cSpeed + ");" + char(10)
		addBodyScript(cJS)
		return self

	# Pause/resume animation
	func threeJSPauseAnimation cName
		cJS = "if(" + cName + "_currentAction) " + cName + "_currentAction.paused = true;" + char(10)
		addBodyScript(cJS)
		return self

	func threeJSResumeAnimation cName
		cJS = "if(" + cName + "_currentAction) " + cName + "_currentAction.paused = false;" + char(10)
		addBodyScript(cJS)
		return self

	# ---- Animation State Machine ----

	# Create an animation state machine for keyboard-driven characters
	# states: list of [stateName, clipName, options]
	# Each option: [:loop, :timeScale, :fadeDuration]
	# transitions: list of [fromState, toState, condition]
	# condition: JS expression evaluated each frame (e.g. "keys.w" or "!grounded")
	func threeJSAnimStateMachine cCanvasId, cName, aStates, aTransitions

		# State machine variable
		cJS = "var " + cName + "_state = " + HTML_DQ + aStates[1][1] + HTML_DQ + ";" + HTML_LF

		# Ensure playAnim function exists
		cJS += "if(typeof " + cName + "_playAnim === " + HTML_DQ + "undefined" + HTML_DQ + ") {" + HTML_LF
		cJS += "  function " + cName + "_playAnim(clipName, fadeTime, doLoop, clamp, speed) {" + HTML_LF
		cJS += "    var action = " + cName + "_actions[clipName];" + HTML_LF
		cJS += "    if(!action) return;" + HTML_LF
		cJS += "    if(" + cName + "_currentAction && " + cName + "_currentAction !== action) {" + HTML_LF
		cJS += "      " + cName + "_currentAction.fadeOut(fadeTime);" + HTML_LF
		cJS += "    }" + HTML_LF
		cJS += "    action.reset().setEffectiveTimeScale(speed).setEffectiveWeight(1);" + HTML_LF
		cJS += "    if(!doLoop){action.setLoop(THREE.LoopOnce);action.clampWhenFinished=clamp}" + HTML_LF
		cJS += "    else{action.setLoop(THREE.LoopRepeat)}" + HTML_LF
		cJS += "    action.fadeIn(fadeTime).play();" + HTML_LF
		cJS += "    " + cName + "_currentAction = action;" + HTML_LF
		cJS += "  }" + HTML_LF
		cJS += "}" + HTML_LF

		# Build state definitions
		cJS += "var " + cName + "_states = {" + HTML_LF
		nStateLen = len(aStates)
		for nState = 1 to nStateLen
			cStateName = aStates[nState][1]
			cClipName = aStates[nState][2]
			cLoop = "true"
			cSSpeed = "1"
			cSFade = "0.3"
			if len(aStates[nState]) >= 3
				aStateOpts = aStates[nState][3]
				if islist(aStateOpts)
					cLoop = threeJSBool(htmlGetOpt(aStateOpts, "loop", true))
					cSSpeed = htmlGetOpt(aStateOpts, "timeScale", "1")
					cSFade = htmlGetOpt(aStateOpts, "fadeDuration", "0.3")
				ok
			ok
			if nState > 1 cJS += "," + HTML_LF ok
			cJS += "  " + HTML_DQ + cStateName + HTML_DQ + ": {clip:" + HTML_DQ + cClipName + HTML_DQ + ",loop:" + cLoop + ",speed:" + cSSpeed + ",fade:" + cSFade + "}"
		next
		cJS += HTML_LF + "};" + HTML_LF

		# Play initial state
		cJS += "(function() {" + HTML_LF
		cJS += "  var initState = " + cName + "_states[" + HTML_DQ + aStates[1][1] + HTML_DQ + "];" + HTML_LF
		cJS += "  if(initState && " + cName + "_actions[initState.clip]) {" + HTML_LF
		cJS += "    " + cName + "_playAnim(initState.clip, 0, initState.loop, false, initState.speed);" + HTML_LF
		cJS += "  }" + HTML_LF
		cJS += "})();" + HTML_LF

		# Transition checker (runs each frame)
		cJS += "animCallbacks_" + cCanvasId + ".push(function(delta) {" + HTML_LF
		cJS += "  var k = keys_" + cCanvasId + " || {};" + HTML_LF
		nTransitionLen = len(aTransitions)
		for nState = 1 to nTransitionLen
			cFromSt = aTransitions[nState][1]
			cToSt = aTransitions[nState][2]
			cCondition = aTransitions[nState][3]
			cJS += "  if(" + cName + "_state === " + HTML_DQ + cFromSt + HTML_DQ + " && (" + cCondition + ")) {" + HTML_LF
			cJS += "    " + cName + "_state = " + HTML_DQ + cToSt + HTML_DQ + ";" + HTML_LF
			cJS += "    var st = " + cName + "_states[" + HTML_DQ + cToSt + HTML_DQ + "];" + HTML_LF
			cJS += "    " + cName + "_playAnim(st.clip, st.fade, st.loop, !st.loop, st.speed);" + HTML_LF
			cJS += "  }" + HTML_LF
		next
		cJS += "});" + HTML_LF

		addBodyScript(cJS)
		return self

	# ---- Load Additional Animation onto Existing Model ----

	# Load a separate animation file and apply to an already-loaded model
	# Useful for loading idle.fbx, walk.fbx, run.fbx separately
	func threeJSLoadAnimation cName, cAnimName, cURL, aOptions
		cFormat = htmlGetOpt(aOptions, "format", "fbx")
		lAutoPlay = htmlGetOpt(aOptions, "autoPlay", false)


		if cFormat = "fbx"
			cJS = "var " + cAnimName + "_animLoader = new THREE.FBXLoader();" + HTML_LF
			cJS += cAnimName + "_animLoader.load(" + HTML_DQ + cURL + HTML_DQ + ", function(anim) {" + HTML_LF
			cJS += "  if(anim.animations.length > 0) {" + HTML_LF
			cJS += "    if(!" + cName + "_mixer) " + cName + "_mixer = new THREE.AnimationMixer(" + cName + ");" + HTML_LF
			cJS += "    var clip = anim.animations[0];" + HTML_LF
			cJS += "    clip.name = " + HTML_DQ + cAnimName + HTML_DQ + ";" + HTML_LF
			cJS += "    " + cName + "_actions[" + HTML_DQ + cAnimName + HTML_DQ + "] = " + cName + "_mixer.clipAction(clip);" + HTML_LF
			cJS += "    " + cName + "_clips.push(clip);" + HTML_LF
			if lAutoPlay
				cJS += "    " + cName + "_playAnim(" + HTML_DQ + cAnimName + HTML_DQ + ", 0.3, true, false, 1);" + HTML_LF
			ok
			cJS += "  }" + HTML_LF
			cJS += "});" + HTML_LF
		but cFormat = "gltf" or cFormat = "glb"
			cJS = "var " + cAnimName + "_animLoader = new THREE.GLTFLoader();" + HTML_LF
			cJS += cAnimName + "_animLoader.load(" + HTML_DQ + cURL + HTML_DQ + ", function(gltf) {" + HTML_LF
			cJS += "  if(gltf.animations.length > 0) {" + HTML_LF
			cJS += "    if(!" + cName + "_mixer) " + cName + "_mixer = new THREE.AnimationMixer(" + cName + ");" + HTML_LF
			cJS += "    var clip = gltf.animations[0];" + HTML_LF
			cJS += "    clip.name = " + HTML_DQ + cAnimName + HTML_DQ + ";" + HTML_LF
			cJS += "    " + cName + "_actions[" + HTML_DQ + cAnimName + HTML_DQ + "] = " + cName + "_mixer.clipAction(clip);" + HTML_LF
			cJS += "    " + cName + "_clips.push(clip);" + HTML_LF
			if lAutoPlay
				cJS += "    " + cName + "_playAnim(" + HTML_DQ + cAnimName + HTML_DQ + ", 0.3, true, false, 1);" + HTML_LF
			ok
			cJS += "  }" + HTML_LF
			cJS += "});" + HTML_LF
		ok

		addBodyScript(cJS)
		return self

	# ---- Animation Events ----

	# Run JS code when an animation finishes (for LoopOnce animations)
	func threeJSOnAnimationFinished cName, cJSCode
		cJS = "if(" + cName + "_mixer) {" + HTML_LF
		cJS += "  " + cName + "_mixer.addEventListener('finished', function(e) {" + HTML_LF
		cJS += "    " + cJSCode + HTML_LF
		cJS += "  });" + HTML_LF
		cJS += "}" + HTML_LF
		addBodyScript(cJS)
		return self

	# ---- Model Info / Debug ----

	# Print model animation names to console (useful for debugging)
	func threeJSLogAnimations cName
		cJS = "setTimeout(function() {" + HTML_LF
		cJS += "  console.log(" + HTML_DQ + "Animations for " + cName + ":" + HTML_DQ + ");" + HTML_LF
		cJS += "  for(var aName in " + cName + "_actions) {" + HTML_LF
		cJS += "    console.log(" + HTML_DQ + "  - " + HTML_DQ + " + aName);" + HTML_LF
		cJS += "  }" + HTML_LF
		cJS += "}, 2000);" + HTML_LF
		addBodyScript(cJS)
		return self

	# ---- Loading Progress UI ----

	# Add a loading screen overlay that hides when model loads
	func threeJSLoadingScreen cCanvasId, aOptions
		cText = htmlGetOpt(aOptions, "text", "Loading 3D Model...")
		cBGColor = htmlGetOpt(aOptions, "bg", "#000000")
		cTextColor = htmlGetOpt(aOptions, "color", "#ffffff")
		cSpinnerColor = htmlGetOpt(aOptions, "spinnerColor", "#6c5ce7")

		cLoadId = "loading-" + cCanvasId

		cHTML = '<div id="' + cLoadId + '" style="position:fixed;top:0;left:0;width:100%;height:100%;background:' + cBGColor + ';display:flex;flex-direction:column;align-items:center;justify-content:center;z-index:1000;transition:opacity 0.5s">' + HTML_LF
		cHTML += '  <div style="width:50px;height:50px;border:4px solid rgba(255,255,255,0.1);border-top:4px solid ' + cSpinnerColor + ';border-radius:50%;animation:spin3d 1s linear infinite"></div>' + HTML_LF
		cHTML += '  <div id="' + cLoadId + '-text" style="color:' + cTextColor + ';margin-top:20px;font-family:monospace;font-size:1rem">' + cText + '</div>' + HTML_LF
		cHTML += '  <div id="' + cLoadId + '-bar" style="width:200px;height:4px;background:rgba(255,255,255,0.1);border-radius:2px;margin-top:15px;overflow:hidden"><div id="' + cLoadId + '-progress" style="width:0%;height:100%;background:' + cSpinnerColor + ';transition:width 0.3s"></div></div>' + HTML_LF
		cHTML += '</div>'
		appendContent(cHTML)

		addKeyframes("spin3d", "0% { transform: rotate(0deg) } 100% { transform: rotate(360deg) }")

		return self

	# Hide loading screen (call from onLoad callback)
	func threeJSHideLoading cCanvasId
		cLoadId = "loading-" + cCanvasId
		cJS = "var ls = document.getElementById('" + cLoadId + "');" + HTML_LF
		cJS += "if(ls) { ls.style.opacity = '0'; setTimeout(function() { ls.style.display = 'none'; }, 500); }" + HTML_LF
		return cJS

	# Update loading progress (use in progress callback)
	func threeJSUpdateLoadingProgress cCanvasId, nPercent
		cLoadId = "loading-" + cCanvasId
		return "document.getElementById('" + cLoadId + "-progress').style.width = '" + nPercent + "%';"


	# ====================================================================
	# Three.js Advanced Features
	# ====================================================================
	# Audio (3D spatial + background), Raycasting/Mouse Picking,
	# Physics (Cannon.js), Shadows, OrbitControls, Post-Processing,
	# Environment Maps, Sprites/Billboards, Lines/Curves,
	# Video Texture, Mirror/Reflections, Instanced Mesh
	# ====================================================================

	# ============================================================
	# 1. AUDIO — 3D Spatial + Background Music + Sound Effects
	# ============================================================

	# Enable the audio listener on the camera
	func threeJSAudioListener cCanvasId
		cJS = "var audioListener_" + cCanvasId + " = new THREE.AudioListener();" + HTML_LF
		cJS += "camera_" + cCanvasId + ".add(audioListener_" + cCanvasId + ");" + HTML_LF
		addBodyScript(cJS)
		return self

	# Play background music (non-positional, everywhere)
	func threeJSBackgroundMusic cCanvasId, cName, cURL, aOptions
		nVolume = htmlGetOpt(aOptions, "volume", "0.5")
		lLoop = htmlGetOpt(aOptions, "bLoop", true)
		lAutoPlay = htmlGetOpt(aOptions, "autoPlay", true)

		cJS = "var " + cName + " = new THREE.Audio(audioListener_" + cCanvasId + ");" + HTML_LF
		cJS += "var " + cName + "_loader = new THREE.AudioLoader();" + HTML_LF
		cJS += cName + "_loader.load(" + HTML_DQ + cURL + HTML_DQ + ", function(buffer) {" + HTML_LF
		cJS += "  " + cName + ".setBuffer(buffer);" + HTML_LF
		cJS += "  " + cName + ".setVolume(" + nVolume + ");" + HTML_LF
		if lLoop
			cJS += "  " + cName + ".setLoop(true);" + HTML_LF
		ok
		if lAutoPlay
			cJS += "  document.addEventListener(" + HTML_DQ + "click" + HTML_DQ + ", function _ap() {" + HTML_LF
			cJS += "    " + cName + ".play(); document.removeEventListener(" + HTML_DQ + "click" + HTML_DQ + ", _ap);" + HTML_LF
			cJS += "  }, {once: true});" + HTML_LF
		ok
		cJS += "});" + HTML_LF
		addBodyScript(cJS)
		return self

	# Positional 3D audio attached to a mesh
	func threeJSPositionalAudio cCanvasId, cName, cMeshName, cURL, aOptions
		nVolume = htmlGetOpt(aOptions, "volume", "1.0")
		cRefDist = htmlGetOpt(aOptions, "refDistance", "5")
		cMaxDist = htmlGetOpt(aOptions, "maxDistance", "50")
		lLoop = htmlGetOpt(aOptions, "bLoop", true)
		lAutoPlay = htmlGetOpt(aOptions, "autoPlay", true)

		cJS = "var " + cName + " = new THREE.PositionalAudio(audioListener_" + cCanvasId + ");" + HTML_LF
		cJS += "var " + cName + "_loader = new THREE.AudioLoader();" + HTML_LF
		cJS += cName + "_loader.load(" + HTML_DQ + cURL + HTML_DQ + ", function(buffer) {" + HTML_LF
		cJS += "  " + cName + ".setBuffer(buffer);" + HTML_LF
		cJS += "  " + cName + ".setVolume(" + nVolume + ");" + HTML_LF
		cJS += "  " + cName + ".setRefDistance(" + cRefDist + ");" + HTML_LF
		cJS += "  " + cName + ".setMaxDistance(" + cMaxDist + ");" + HTML_LF
		if lLoop
			cJS += "  " + cName + ".setLoop(true);" + HTML_LF
		ok
		if lAutoPlay
			cJS += "  document.addEventListener(" + HTML_DQ + "click" + HTML_DQ + ", function _ap() {" + HTML_LF
			cJS += "    " + cName + ".play(); document.removeEventListener(" + HTML_DQ + "click" + HTML_DQ + ", _ap);" + HTML_LF
			cJS += "  }, {once: true});" + HTML_LF
		ok
		cJS += "});" + HTML_LF
		cJS += cMeshName + ".add(" + cName + ");" + HTML_LF
		addBodyScript(cJS)
		return self

	# Play a one-shot sound effect (non-looping)
	func threeJSSoundEffect cCanvasId, cName, cURL, aOptions
		nVolume = htmlGetOpt(aOptions, "volume", "1.0")

		cJS = "var " + cName + "_buffer = null;" + HTML_LF
		cJS += "new THREE.AudioLoader().load(" + HTML_DQ + cURL + HTML_DQ + ", function(buf) { " + cName + "_buffer = buf; });" + HTML_LF
		cJS += "function " + cName + "_play() {" + HTML_LF
		cJS += "  if(!" + cName + "_buffer) return;" + HTML_LF
		cJS += "  var snd = new THREE.Audio(audioListener_" + cCanvasId + ");" + HTML_LF
		cJS += "  snd.setBuffer(" + cName + "_buffer);" + HTML_LF
		cJS += "  snd.setVolume(" + nVolume + ");" + HTML_LF
		cJS += "  snd.play();" + HTML_LF
		cJS += "}" + HTML_LF
		addBodyScript(cJS)
		return self

	# Set volume at runtime: returns JS expression
	func threeJSSetVolume cName, cJSVolume
		return cName + ".setVolume(" + cJSVolume + ");"

	# Generate a procedural tone using Web Audio API (no file needed)
	# Creates a play function: name_play(frequency, duration)
	func threeJSTone cCanvasId, cName, aOptions
		cWaveform = htmlGetOpt(aOptions, "waveform", "sine")
		nVolume = htmlGetOpt(aOptions, "volume", "0.3")
		cDefaultFreq = htmlGetOpt(aOptions, "frequency", "440")
		cDefaultDur = htmlGetOpt(aOptions, "duration", "0.3")

		cJS = "var " + cName + "_ctx = null;" + HTML_LF
		cJS += "function " + cName + "_play(freq, dur) {" + HTML_LF
		cJS += "  if(!" + cName + "_ctx) " + cName + "_ctx = new (window.AudioContext || window.webkitAudioContext)();" + HTML_LF
		# Resume suspended context (browser autoplay policy)
		cJS += "  if(" + cName + "_ctx.state === " + HTML_SQ + "suspended" + HTML_SQ + ") " + cName + "_ctx.resume();" + HTML_LF
		cJS += "  freq = freq || " + cDefaultFreq + ";" + HTML_LF
		cJS += "  dur = dur || " + cDefaultDur + ";" + HTML_LF
		cJS += "  var osc = " + cName + "_ctx.createOscillator();" + HTML_LF
		cJS += "  var gain = " + cName + "_ctx.createGain();" + HTML_LF
		cJS += "  osc.type = " + HTML_SQ + cWaveform + HTML_SQ + ";" + HTML_LF
		cJS += "  osc.frequency.value = freq;" + HTML_LF
		cJS += "  gain.gain.setValueAtTime(" + nVolume + ", " + cName + "_ctx.currentTime);" + HTML_LF
		cJS += "  gain.gain.exponentialRampToValueAtTime(0.001, " + cName + "_ctx.currentTime + dur);" + HTML_LF
		cJS += "  osc.connect(gain);" + HTML_LF
		cJS += "  gain.connect(" + cName + "_ctx.destination);" + HTML_LF
		cJS += "  osc.start();" + HTML_LF
		cJS += "  osc.stop(" + cName + "_ctx.currentTime + dur);" + HTML_LF
		cJS += "}" + HTML_LF
		addBodyScript(cJS)
		return self

	# Generate a procedural ambient drone / pad sound
	func threeJSAmbientTone cCanvasId, cName, aOptions
		cFrequency = htmlGetOpt(aOptions, "frequency", "120")
		nVolume = htmlGetOpt(aOptions, "volume", "0.1")
		cDetune = htmlGetOpt(aOptions, "detune", "5")

		cJS = "var " + cName + "_ctx = null;" + HTML_LF
		cJS += "var " + cName + "_playing = false;" + HTML_LF
		cJS += "var " + cName + "_oscs = [];" + HTML_LF
		cJS += "function " + cName + "_start() {" + HTML_LF
		cJS += "  if(" + cName + "_playing) return;" + HTML_LF
		cJS += "  " + cName + "_ctx = new (window.AudioContext || window.webkitAudioContext)();" + HTML_LF
		# Resume suspended context (browser autoplay policy)
		cJS += "  " + cName + "_ctx.resume().then(function() {" + HTML_LF
		cJS += "    var master = " + cName + "_ctx.createGain();" + HTML_LF
		cJS += "    master.gain.value = " + nVolume + ";" + HTML_LF
		cJS += "    master.connect(" + cName + "_ctx.destination);" + HTML_LF
		# Two slightly detuned oscillators for rich sound
		cJS += "    var osc1 = " + cName + "_ctx.createOscillator();" + HTML_LF
		cJS += "    osc1.type = " + HTML_SQ + "sine" + HTML_SQ + ";" + HTML_LF
		cJS += "    osc1.frequency.value = " + cFrequency + ";" + HTML_LF
		cJS += "    var osc2 = " + cName + "_ctx.createOscillator();" + HTML_LF
		cJS += "    osc2.type = " + HTML_SQ + "sine" + HTML_SQ + ";" + HTML_LF
		cJS += "    osc2.frequency.value = parseFloat(" + cFrequency + ") + " + cDetune + ";" + HTML_LF
		# Third oscillator an octave up, quieter
		cJS += "    var osc3 = " + cName + "_ctx.createOscillator();" + HTML_LF
		cJS += "    osc3.type = " + HTML_SQ + "triangle" + HTML_SQ + ";" + HTML_LF
		cJS += "    osc3.frequency.value = parseFloat(" + cFrequency + ") * 2;" + HTML_LF
		cJS += "    var g3 = " + cName + "_ctx.createGain();" + HTML_LF
		cJS += "    g3.gain.value = 0.3;" + HTML_LF
		cJS += "    osc1.connect(master); osc2.connect(master);" + HTML_LF
		cJS += "    osc3.connect(g3); g3.connect(master);" + HTML_LF
		cJS += "    osc1.start(); osc2.start(); osc3.start();" + HTML_LF
		cJS += "    " + cName + "_oscs = [osc1, osc2, osc3];" + HTML_LF
		cJS += "    " + cName + "_playing = true;" + HTML_LF
		cJS += "  });" + HTML_LF
		cJS += "}" + HTML_LF
		cJS += "function " + cName + "_stop() {" + HTML_LF
		cJS += "  if(!" + cName + "_playing) return;" + HTML_LF
		cJS += "  " + cName + "_oscs.forEach(function(o) { try{o.stop();}catch(e){} });" + HTML_LF
		cJS += "  if(" + cName + "_ctx) { " + cName + "_ctx.close(); " + cName + "_ctx = null; }" + HTML_LF
		cJS += "  " + cName + "_oscs = [];" + HTML_LF
		cJS += "  " + cName + "_playing = false;" + HTML_LF
		cJS += "}" + HTML_LF
		addBodyScript(cJS)
		return self

	# ============================================================
	# 2. RAYCASTING / MOUSE PICKING
	# ============================================================

	# Enable raycasting — click on 3D objects
	# clickables: list of mesh variable names that can be clicked
	# jsOnClick: JS code executed when a mesh is hit; 
	#   available vars: hit (intersection object), hit.object, hit.point
	func threeJSRaycast cCanvasId, aClickables, cJSOnClick, aOptions
		cEventType = htmlGetOpt(aOptions, "event", "click")
		lRecursive = htmlGetOpt(aOptions, "recursive", false)

		cJS = "var raycaster_" + cCanvasId + " = new THREE.Raycaster();" + HTML_LF
		cJS += "var rayMouse_" + cCanvasId + " = new THREE.Vector2();" + HTML_LF

		# Build clickable targets array
		cJS += "var rayTargets_" + cCanvasId + " = ["
		nClickableLen = len(aClickables)
		for nClickable = 1 to nClickableLen
			if nClickable > 1 cJS += ", " ok
			cJS += aClickables[nClickable]
		next
		cJS += "];" + HTML_LF

		cJS += "renderer_" + cCanvasId + ".domElement.addEventListener(" + HTML_DQ + cEventType + HTML_DQ + ", function(e) {" + HTML_LF
		cJS += "  var rect = renderer_" + cCanvasId + ".domElement.getBoundingClientRect();" + HTML_LF
		cJS += "  rayMouse_" + cCanvasId + ".x = ((e.clientX - rect.left) / rect.width) * 2 - 1;" + HTML_LF
		cJS += "  rayMouse_" + cCanvasId + ".y = -((e.clientY - rect.top) / rect.height) * 2 + 1;" + HTML_LF
		cJS += "  raycaster_" + cCanvasId + ".setFromCamera(rayMouse_" + cCanvasId + ", camera_" + cCanvasId + ");" + HTML_LF
		if lRecursive
			cJS += "  var _hits = raycaster_" + cCanvasId + ".intersectObjects(rayTargets_" + cCanvasId + ", true);" + HTML_LF
		else
			cJS += "  var _hits = raycaster_" + cCanvasId + ".intersectObjects(rayTargets_" + cCanvasId + ");" + HTML_LF
		ok
		cJS += "  if(_hits.length > 0) {" + HTML_LF
		cJS += "    var hit = _hits[0];" + HTML_LF
		cJS += "    " + cJSOnClick + HTML_LF
		cJS += "  }" + HTML_LF
		cJS += "});" + HTML_LF
		addBodyScript(cJS)
		return self

	# Hover detection — highlight objects on mouse over
	func threeJSHover cCanvasId, aHoverables, cJSOnEnter, cJSOnLeave, aOptions
		lRecursive = htmlGetOpt(aOptions, "recursive", false)

		cJS = "var hoverRay_" + cCanvasId + " = new THREE.Raycaster();" + HTML_LF
		cJS += "var hoverMouse_" + cCanvasId + " = new THREE.Vector2();" + HTML_LF
		cJS += "var hoverCurrent_" + cCanvasId + " = null;" + HTML_LF

		# Build targets
		cJS += "var hoverTargets_" + cCanvasId + " = ["
		nHoverableLen = len(aHoverables)
		for nHoverable = 1 to nHoverableLen
			if nHoverable > 1 cJS += ", " ok
			cJS += aHoverables[nHoverable]
		next
		cJS += "];" + HTML_LF

		cJS += "renderer_" + cCanvasId + ".domElement.addEventListener(" + HTML_DQ + "mousemove" + HTML_DQ + ", function(e) {" + HTML_LF
		cJS += "  var rect = renderer_" + cCanvasId + ".domElement.getBoundingClientRect();" + HTML_LF
		cJS += "  hoverMouse_" + cCanvasId + ".x = ((e.clientX - rect.left) / rect.width) * 2 - 1;" + HTML_LF
		cJS += "  hoverMouse_" + cCanvasId + ".y = -((e.clientY - rect.top) / rect.height) * 2 + 1;" + HTML_LF
		cJS += "  hoverRay_" + cCanvasId + ".setFromCamera(hoverMouse_" + cCanvasId + ", camera_" + cCanvasId + ");" + HTML_LF
		if lRecursive
			cJS += "  var _hits = hoverRay_" + cCanvasId + ".intersectObjects(hoverTargets_" + cCanvasId + ", true);" + HTML_LF
		else
			cJS += "  var _hits = hoverRay_" + cCanvasId + ".intersectObjects(hoverTargets_" + cCanvasId + ");" + HTML_LF
		ok
		cJS += "  if(_hits.length > 0) {" + HTML_LF
		cJS += "    var obj = _hits[0].object;" + HTML_LF
		cJS += "    if(hoverCurrent_" + cCanvasId + " !== obj) {" + HTML_LF
		cJS += "      if(hoverCurrent_" + cCanvasId + ") { var hit = {object: hoverCurrent_" + cCanvasId + "}; " + cJSOnLeave + " }" + HTML_LF
		cJS += "      hoverCurrent_" + cCanvasId + " = obj;" + HTML_LF
		cJS += "      var hit = _hits[0]; " + cJSOnEnter + HTML_LF
		cJS += "    }" + HTML_LF
		cJS += "  } else if(hoverCurrent_" + cCanvasId + ") {" + HTML_LF
		cJS += "    var hit = {object: hoverCurrent_" + cCanvasId + "}; " + cJSOnLeave + HTML_LF
		cJS += "    hoverCurrent_" + cCanvasId + " = null;" + HTML_LF
		cJS += "  }" + HTML_LF
		cJS += "});" + HTML_LF
		addBodyScript(cJS)
		return self

	# Drag objects with mouse
	# Uses pointer events in capture phase to fire BEFORE OrbitControls
	func threeJSDragControls cCanvasId, aDraggables, aOptions
		cOnDragStart = htmlGetOpt(aOptions, "onDragStart", "")
		cOnDragEnd = htmlGetOpt(aOptions, "onDragEnd", "")

		cJS = "var dragRay_" + cCanvasId + " = new THREE.Raycaster();" + HTML_LF
		cJS += "var dragMouse_" + cCanvasId + " = new THREE.Vector2();" + HTML_LF
		cJS += "var dragObj_" + cCanvasId + " = null;" + HTML_LF
		cJS += "var dragPlane_" + cCanvasId + " = new THREE.Plane();" + HTML_LF
		cJS += "var dragOffset_" + cCanvasId + " = new THREE.Vector3();" + HTML_LF

		cJS += "var dragTargets_" + cCanvasId + " = ["
		nDraggableLen = len(aDraggables)
		for nDraggable = 1 to nDraggableLen
			if nDraggable > 1 cJS += ", " ok
			cJS += aDraggables[nDraggable]
		next
		cJS += "];" + HTML_LF

		# Pointer down in CAPTURE phase — fires before OrbitControls
		cJS += "renderer_" + cCanvasId + ".domElement.addEventListener(" + HTML_DQ + "pointerdown" + HTML_DQ + ", function(e) {" + HTML_LF
		cJS += "  if(e.button !== 0) return;" + HTML_LF
		cJS += "  var rect = renderer_" + cCanvasId + ".domElement.getBoundingClientRect();" + HTML_LF
		cJS += "  dragMouse_" + cCanvasId + ".x = ((e.clientX-rect.left)/rect.width)*2-1;" + HTML_LF
		cJS += "  dragMouse_" + cCanvasId + ".y = -((e.clientY-rect.top)/rect.height)*2+1;" + HTML_LF
		cJS += "  dragRay_" + cCanvasId + ".setFromCamera(dragMouse_" + cCanvasId + ", camera_" + cCanvasId + ");" + HTML_LF
		cJS += "  var _h = dragRay_" + cCanvasId + ".intersectObjects(dragTargets_" + cCanvasId + ");" + HTML_LF
		cJS += "  if(_h.length > 0) {" + HTML_LF
		cJS += "    e.stopPropagation();" + HTML_LF
		cJS += "    dragObj_" + cCanvasId + " = _h[0].object;" + HTML_LF
		# Use horizontal plane at object Y for stable dragging
		cJS += "    dragPlane_" + cCanvasId + ".setFromNormalAndCoplanarPoint(new THREE.Vector3(0,1,0), _h[0].point);" + HTML_LF
		cJS += "    var _ip = new THREE.Vector3();" + HTML_LF
		cJS += "    if(dragRay_" + cCanvasId + ".ray.intersectPlane(dragPlane_" + cCanvasId + ", _ip)) {" + HTML_LF
		cJS += "      dragOffset_" + cCanvasId + ".copy(_ip).sub(dragObj_" + cCanvasId + ".position);" + HTML_LF
		cJS += "    }" + HTML_LF
		# Disable orbit controls while dragging
		cJS += "    if(typeof controls_" + cCanvasId + " !== " + HTML_DQ + "undefined" + HTML_DQ + ") controls_" + cCanvasId + ".enabled = false;" + HTML_LF
		if cOnDragStart != ""
			cJS += "    " + cOnDragStart + HTML_LF
		ok
		cJS += "  }" + HTML_LF
		cJS += "}, true);" + HTML_LF

		# Pointer move — update position (window level to catch outside canvas)
		cJS += "window.addEventListener(" + HTML_DQ + "pointermove" + HTML_DQ + ", function(e) {" + HTML_LF
		cJS += "  if(!dragObj_" + cCanvasId + ") return;" + HTML_LF
		cJS += "  var rect = renderer_" + cCanvasId + ".domElement.getBoundingClientRect();" + HTML_LF
		cJS += "  dragMouse_" + cCanvasId + ".x = ((e.clientX-rect.left)/rect.width)*2-1;" + HTML_LF
		cJS += "  dragMouse_" + cCanvasId + ".y = -((e.clientY-rect.top)/rect.height)*2+1;" + HTML_LF
		cJS += "  dragRay_" + cCanvasId + ".setFromCamera(dragMouse_" + cCanvasId + ", camera_" + cCanvasId + ");" + HTML_LF
		cJS += "  var _ip = new THREE.Vector3();" + HTML_LF
		cJS += "  if(dragRay_" + cCanvasId + ".ray.intersectPlane(dragPlane_" + cCanvasId + ", _ip)) {" + HTML_LF
		cJS += "    dragObj_" + cCanvasId + ".position.copy(_ip.sub(dragOffset_" + cCanvasId + "));" + HTML_LF
		cJS += "  }" + HTML_LF
		cJS += "});" + HTML_LF

		# Pointer up — end drag, re-enable orbit
		cJS += "window.addEventListener(" + HTML_DQ + "pointerup" + HTML_DQ + ", function() {" + HTML_LF
		cJS += "  if(dragObj_" + cCanvasId + ") {" + HTML_LF
		if cOnDragEnd != ""
			cJS += "    " + cOnDragEnd + HTML_LF
		ok
		cJS += "    if(typeof controls_" + cCanvasId + " !== " + HTML_DQ + "undefined" + HTML_DQ + ") controls_" + cCanvasId + ".enabled = true;" + HTML_LF
		cJS += "  }" + HTML_LF
		cJS += "  dragObj_" + cCanvasId + " = null;" + HTML_LF
		cJS += "});" + HTML_LF

		addBodyScript(cJS)
		return self

	# ============================================================
	# 3. SHADOWS
	# ============================================================

	# Enable shadow mapping on the renderer
	func threeJSEnableShadows cCanvasId, aOptions
		cShadowType = htmlGetOpt(aOptions, "type", "pcfsoft")

		cJS = "renderer_" + cCanvasId + ".shadowMap.enabled = true;" + HTML_LF
		if cShadowType = "basic"
			cJS += "renderer_" + cCanvasId + ".shadowMap.type = THREE.BasicShadowMap;" + HTML_LF
		but cShadowType = "pcf"
			cJS += "renderer_" + cCanvasId + ".shadowMap.type = THREE.PCFShadowMap;" + HTML_LF
		else
			cJS += "renderer_" + cCanvasId + ".shadowMap.type = THREE.PCFSoftShadowMap;" + HTML_LF
		ok
		addBodyScript(cJS)
		return self

	# Configure shadow camera on a directional/spot light
	func threeJSShadowConfig cLightName, aOptions
		cMapSize = htmlGetOpt(aOptions, "mapSize", "1024")
		cNear = htmlGetOpt(aOptions, "near", "0.5")
		cFar = htmlGetOpt(aOptions, "far", "50")
		cLeft = htmlGetOpt(aOptions, "left", "-10")
		cRight = htmlGetOpt(aOptions, "right", "10")
		cTop2 = htmlGetOpt(aOptions, "top", "10")
		cBottom = htmlGetOpt(aOptions, "bottom", "-10")
		cBias = htmlGetOpt(aOptions, "bias", "-0.001")

		cJS = cLightName + ".castShadow = true;" + HTML_LF
		cJS += cLightName + ".shadow.mapSize.width = " + cMapSize + ";" + HTML_LF
		cJS += cLightName + ".shadow.mapSize.height = " + cMapSize + ";" + HTML_LF
		cJS += cLightName + ".shadow.camera.near = " + cNear + ";" + HTML_LF
		cJS += cLightName + ".shadow.camera.far = " + cFar + ";" + HTML_LF
		cJS += cLightName + ".shadow.camera.left = " + cLeft + ";" + HTML_LF
		cJS += cLightName + ".shadow.camera.right = " + cRight + ";" + HTML_LF
		cJS += cLightName + ".shadow.camera.top = " + cTop2 + ";" + HTML_LF
		cJS += cLightName + ".shadow.camera.bottom = " + cBottom + ";" + HTML_LF
		cJS += cLightName + ".shadow.bias = " + cBias + ";" + HTML_LF
		addBodyScript(cJS)
		return self

	# Set cast/receive shadow on a mesh
	func threeJSMeshShadow cMeshName, lCast, lReceive
		cJS = cMeshName + ".castShadow = " + threeJSBool(lCast) + ";" + HTML_LF
		cJS += cMeshName + ".receiveShadow = " + threeJSBool(lReceive) + ";" + HTML_LF
		# Also apply to children (for loaded models)
		cJS += cMeshName + ".traverse(function(child) {" + HTML_LF
		cJS += "  if(child.isMesh) {" + HTML_LF
		cJS += "    child.castShadow = " + threeJSBool(lCast) + ";" + HTML_LF
		cJS += "    child.receiveShadow = " + threeJSBool(lReceive) + ";" + HTML_LF
		cJS += "  }" + HTML_LF
		cJS += "});" + HTML_LF
		addBodyScript(cJS)
		return self

	# ============================================================
	# 4. ORBIT CONTROLS
	# ============================================================

	# Enable OrbitControls CDN
	func enableOrbitControls
		lOrbitControls = true
		return self

	# Add OrbitControls to scene (replaces mouse look)
	func threeJSOrbitControls cCanvasId, aOptions
		lEnableDamping = htmlGetOpt(aOptions, "damping", true)
		cDampingFactor = htmlGetOpt(aOptions, "dampingFactor", "0.05")
		lEnableZoom = htmlGetOpt(aOptions, "zoom", true)
		lEnablePan = htmlGetOpt(aOptions, "pan", true)
		lEnableRotate = htmlGetOpt(aOptions, "rotate", true)
		lAutoRot = htmlGetOpt(aOptions, "autoRotate", false)
		cAutoRotSpeed = htmlGetOpt(aOptions, "autoRotateSpeed", "2.0")
		cMinDist = htmlGetOpt(aOptions, "minDistance", "")
		cMaxDist = htmlGetOpt(aOptions, "maxDistance", "")
		cMinPolar = htmlGetOpt(aOptions, "minPolarAngle", "")
		cMaxPolar = htmlGetOpt(aOptions, "maxPolarAngle", "")
		cTargetX = htmlGetOpt(aOptions, "targetX", "")
		cTargetY = htmlGetOpt(aOptions, "targetY", "")
		cTargetZ = htmlGetOpt(aOptions, "targetZ", "")

		cJS = "var controls_" + cCanvasId + " = new THREE.OrbitControls(camera_" + cCanvasId + ", renderer_" + cCanvasId + ".domElement);" + HTML_LF
		if lEnableDamping
			cJS += "controls_" + cCanvasId + ".enableDamping = true;" + HTML_LF
			cJS += "controls_" + cCanvasId + ".dampingFactor = " + cDampingFactor + ";" + HTML_LF
		ok
		if !lEnableZoom cJS += "controls_" + cCanvasId + ".enableZoom = false;" + HTML_LF ok
		if !lEnablePan cJS += "controls_" + cCanvasId + ".enablePan = false;" + HTML_LF ok
		if !lEnableRotate cJS += "controls_" + cCanvasId + ".enableRotate = false;" + HTML_LF ok
		if lAutoRot
			cJS += "controls_" + cCanvasId + ".autoRotate = true;" + HTML_LF
			cJS += "controls_" + cCanvasId + ".autoRotateSpeed = " + cAutoRotSpeed + ";" + HTML_LF
		ok
		if cMinDist != "" cJS += "controls_" + cCanvasId + ".minDistance = " + cMinDist + ";" + HTML_LF ok
		if cMaxDist != "" cJS += "controls_" + cCanvasId + ".maxDistance = " + cMaxDist + ";" + HTML_LF ok
		if cMinPolar != "" cJS += "controls_" + cCanvasId + ".minPolarAngle = " + cMinPolar + ";" + HTML_LF ok
		if cMaxPolar != "" cJS += "controls_" + cCanvasId + ".maxPolarAngle = " + cMaxPolar + ";" + HTML_LF ok
		if cTargetX != ""
			cJS += "controls_" + cCanvasId + ".target.set(" + cTargetX + ", " + cTargetY + ", " + cTargetZ + ");" + HTML_LF
		ok
		cJS += "controls_" + cCanvasId + ".update();" + HTML_LF

		# Update controls in animation loop
		cJS += "animCallbacks_" + cCanvasId + ".push(function(delta) {" + HTML_LF
		cJS += "  controls_" + cCanvasId + ".update();" + HTML_LF
		cJS += "});" + HTML_LF

		addBodyScript(cJS)
		return self

	# ============================================================
	# 5. POST-PROCESSING (EffectComposer)
	# ============================================================

	# Enable post-processing CDN scripts
	func enablePostProcessing
		lPostProcessing = true
		return self

	# Initialize the EffectComposer
	func threeJSPostProcessing cCanvasId
		cJS = "var composer_" + cCanvasId + " = new THREE.EffectComposer(renderer_" + cCanvasId + ");" + HTML_LF
		cJS += "composer_" + cCanvasId + ".addPass(new THREE.RenderPass(scene_" + cCanvasId + ", camera_" + cCanvasId + "));" + HTML_LF
		addBodyScript(cJS)
		return self

	# Bloom effect (glow)
	func threeJSBloom cCanvasId, aOptions
		cStrength = htmlGetOpt(aOptions, "strength", "1.0")
		cRadius = htmlGetOpt(aOptions, "radius", "0.4")
		cThreshold = htmlGetOpt(aOptions, "threshold", "0.8")

		cJS = "var bloom_" + cCanvasId + " = new THREE.UnrealBloomPass(" + HTML_LF
		cJS += "  new THREE.Vector2(window.innerWidth, window.innerHeight)," + HTML_LF
		cJS += "  " + cStrength + ", " + cRadius + ", " + cThreshold + HTML_LF
		cJS += ");" + HTML_LF
		cJS += "composer_" + cCanvasId + ".addPass(bloom_" + cCanvasId + ");" + HTML_LF
		addBodyScript(cJS)
		return self

	# FXAA anti-aliasing
	func threeJSFXAA cCanvasId
		cJS = "var fxaa_" + cCanvasId + " = new THREE.ShaderPass(THREE.FXAAShader);" + HTML_LF
		cJS += "fxaa_" + cCanvasId + ".material.uniforms[" + char(39) + "resolution" + char(39) + "].value.set(1/window.innerWidth, 1/window.innerHeight);" + HTML_LF
		cJS += "composer_" + cCanvasId + ".addPass(fxaa_" + cCanvasId + ");" + HTML_LF
		addBodyScript(cJS)
		return self

	# Film grain effect
	func threeJSFilmGrain cCanvasId, aOptions
		cNoiseIntensity = htmlGetOpt(aOptions, "noise", "0.35")
		cScanIntensity = htmlGetOpt(aOptions, "scanlines", "0.025")
		cScanCount = htmlGetOpt(aOptions, "scanCount", "648")
		lGrayscale = htmlGetOpt(aOptions, "grayscale", false)

		cJS = "var film_" + cCanvasId + " = new THREE.FilmPass(" + HTML_LF
		if lGrayscale
			cJS += "  " + cNoiseIntensity + ", " + cScanIntensity + ", " + cScanCount + ", true" + HTML_LF
		else
			cJS += "  " + cNoiseIntensity + ", " + cScanIntensity + ", " + cScanCount + ", false" + HTML_LF
		ok
		cJS += ");" + HTML_LF
		cJS += "composer_" + cCanvasId + ".addPass(film_" + cCanvasId + ");" + HTML_LF
		addBodyScript(cJS)
		return self

	# Glitch effect
	func threeJSGlitchPass cCanvasId, aOptions
		lGoWild = htmlGetOpt(aOptions, "wild", false)

		cJS = "var glitch_" + cCanvasId + " = new THREE.GlitchPass();" + HTML_LF
		if lGoWild
			cJS += "glitch_" + cCanvasId + ".goWild = true;" + HTML_LF
		ok
		cJS += "composer_" + cCanvasId + ".addPass(glitch_" + cCanvasId + ");" + HTML_LF
		addBodyScript(cJS)
		return self

	# Dot screen effect
	func threeJSDotScreen cCanvasId, aOptions
		cDotScale = htmlGetOpt(aOptions, "scale", "4.0")
		cAngle = htmlGetOpt(aOptions, "angle", "1.57")

		cJS = "var dot_" + cCanvasId + " = new THREE.ShaderPass(THREE.DotScreenShader);" + HTML_LF
		cJS += "dot_" + cCanvasId + ".uniforms[" + char(39) + "scale" + char(39) + "].value = " + cDotScale + ";" + HTML_LF
		cJS += "dot_" + cCanvasId + ".uniforms[" + char(39) + "angle" + char(39) + "].value = " + cAngle + ";" + HTML_LF
		cJS += "composer_" + cCanvasId + ".addPass(dot_" + cCanvasId + ");" + HTML_LF
		addBodyScript(cJS)
		return self

	# Vignette (darken edges)
	func threeJSVignette cCanvasId, aOptions
		cOffset = htmlGetOpt(aOptions, "offset", "1.0")
		cDarkness = htmlGetOpt(aOptions, "darkness", "1.3")

		cJS = "var vignette_" + cCanvasId + " = new THREE.ShaderPass(THREE.VignetteShader);" + HTML_LF
		cJS += "vignette_" + cCanvasId + ".uniforms[" + char(39) + "offset" + char(39) + "].value = " + cOffset + ";" + HTML_LF
		cJS += "vignette_" + cCanvasId + ".uniforms[" + char(39) + "darkness" + char(39) + "].value = " + cDarkness + ";" + HTML_LF
		cJS += "composer_" + cCanvasId + ".addPass(vignette_" + cCanvasId + ");" + HTML_LF
		addBodyScript(cJS)
		return self

	# Custom shader pass
	func threeJSCustomPass cCanvasId, cName, cFragmentShader, aUniforms

		# Build uniforms JS
		cJS = "var " + cName + "_shader = {" + HTML_LF
		cJS += "  uniforms: {" + HTML_LF
		cJS += "    tDiffuse: { value: null }," + HTML_LF
		cJS += "    uTime: { value: 0.0 }"
		if islist(aUniforms)
			nUniformLen = len(aUniforms)
			for nUniform = 1 to nUniformLen
				cUName = aUniforms[nUniform][1]
				cUVal = aUniforms[nUniform][2]
				cJS += "," + HTML_LF + "    " + cUName + ": { value: " + cUVal + " }"
			next
		ok
		cJS += HTML_LF + "  }," + HTML_LF
		cJS += "  vertexShader: " + HTML_BT + "varying vec2 vUv; void main() { vUv = uv; gl_Position = projectionMatrix * modelViewMatrix * vec4(position,1.0); }" + HTML_BT + "," + HTML_LF
		cJS += "  fragmentShader: " + HTML_BT + cFragmentShader + HTML_BT + HTML_LF
		cJS += "};" + HTML_LF
		cJS += "var " + cName + "_pass = new THREE.ShaderPass(" + cName + "_shader);" + HTML_LF
		cJS += "composer_" + cCanvasId + ".addPass(" + cName + "_pass);" + HTML_LF

		# Update uTime
		cJS += "animCallbacks_" + cCanvasId + ".push(function(delta, elapsed) {" + HTML_LF
		cJS += "  " + cName + "_pass.uniforms.uTime.value = elapsed;" + HTML_LF
		cJS += "});" + HTML_LF

		addBodyScript(cJS)
		return self

	# Replace render call with composer render (MUST call after adding all passes)
	func threeJSPostProcessAnimate cCanvasId
		cJS = "var clock_" + cCanvasId + " = clock_" + cCanvasId + " || new THREE.Clock();" + HTML_LF
		cJS += "var _ppElapsed_" + cCanvasId + " = 0;" + HTML_LF
		cJS += "function animate_" + cCanvasId + "() {" + HTML_LF
		cJS += "  requestAnimationFrame(animate_" + cCanvasId + ");" + HTML_LF
		cJS += "  var delta = clock_" + cCanvasId + ".getDelta();" + HTML_LF
		cJS += "  _ppElapsed_" + cCanvasId + " += delta;" + HTML_LF
		cJS += "  for(var i=0; i<animCallbacks_" + cCanvasId + ".length; i++) {" + HTML_LF
		cJS += "    animCallbacks_" + cCanvasId + "[i](delta, _ppElapsed_" + cCanvasId + ");" + HTML_LF
		cJS += "  }" + HTML_LF
		cJS += "  composer_" + cCanvasId + ".render();" + HTML_LF
		cJS += "}" + HTML_LF
		cJS += "animate_" + cCanvasId + "();" + HTML_LF
		addBodyScript(cJS)
		return self

	# ============================================================
	# 6. ENVIRONMENT MAPS / REFLECTIONS
	# ============================================================

	# Load cubemap environment (6 images: px, nx, py, ny, pz, nz)
	func threeJSCubeEnvMap cCanvasId, cPath, aOptions
		lAsBackground = htmlGetOpt(aOptions, "background", true)
		cEnvIntensity = htmlGetOpt(aOptions, "intensity", "1.0")
		cFileExt = htmlGetOpt(aOptions, "ext", ".jpg")

		cJS = "var cubeLoader_" + cCanvasId + " = new THREE.CubeTextureLoader();" + HTML_LF
		cJS += "cubeLoader_" + cCanvasId + ".setPath(" + HTML_DQ + cPath + HTML_DQ + ");" + HTML_LF
		cJS += "var envMap_" + cCanvasId + " = cubeLoader_" + cCanvasId + ".load([" + HTML_LF
		cJS += "  " + HTML_SQ + "px" + cFileExt + HTML_SQ + ", " + HTML_SQ + "nx" + cFileExt + HTML_SQ + "," + HTML_LF
		cJS += "  " + HTML_SQ + "py" + cFileExt + HTML_SQ + ", " + HTML_SQ + "ny" + cFileExt + HTML_SQ + "," + HTML_LF
		cJS += "  " + HTML_SQ + "pz" + cFileExt + HTML_SQ + ", " + HTML_SQ + "nz" + cFileExt + HTML_SQ + HTML_LF
		cJS += "]);" + HTML_LF
		if lAsBackground
			cJS += "scene_" + cCanvasId + ".background = envMap_" + cCanvasId + ";" + HTML_LF
		ok
		cJS += "scene_" + cCanvasId + ".environment = envMap_" + cCanvasId + ";" + HTML_LF
		addBodyScript(cJS)
		return self

	# Apply environment map to specific mesh for reflections
	func threeJSEnvMapMesh cMeshName, cCanvasId, aOptions
		cReflectivity = htmlGetOpt(aOptions, "reflectivity", "1.0")

		cJS = "if(envMap_" + cCanvasId + " && " + cMeshName + ".material) {" + HTML_LF
		cJS += "  " + cMeshName + ".material.envMap = envMap_" + cCanvasId + ";" + HTML_LF
		cJS += "  " + cMeshName + ".material.reflectivity = " + cReflectivity + ";" + HTML_LF
		cJS += "  " + cMeshName + ".material.needsUpdate = true;" + HTML_LF
		cJS += "}" + HTML_LF
		addBodyScript(cJS)
		return self

	# ============================================================
	# 7. SPRITES / BILLBOARDS
	# ============================================================

	# Create a sprite (always faces camera)
	func threeJSSprite cCanvasId, cName, cTextureUrl, aOptions
		cX = htmlGetOpt(aOptions, "x", "0")
		cY = htmlGetOpt(aOptions, "y", "0")
		cZ = htmlGetOpt(aOptions, "z", "0")
		cScaleX = htmlGetOpt(aOptions, "scaleX", "1")
		cScaleY = htmlGetOpt(aOptions, "scaleY", "1")
		cColor = htmlGetOpt(aOptions, "color", "")
		cOpacity = htmlGetOpt(aOptions, "opacity", "1.0")
		lDepthTest = htmlGetOpt(aOptions, "depthTest", true)

		cJS = "var " + cName + "_map = new THREE.TextureLoader().load(" + HTML_DQ + cTextureUrl + HTML_DQ + ");" + HTML_LF
		cJS += "var " + cName + "_mat = new THREE.SpriteMaterial({" + HTML_LF
		cJS += "  map: " + cName + "_map," + HTML_LF
		cJS += "  transparent: true," + HTML_LF
		cJS += "  opacity: " + cOpacity + "," + HTML_LF
		if !lDepthTest cJS += "  depthTest: false," + HTML_LF ok
		if cColor != "" cJS += "  color: " + cColor + "," + HTML_LF ok
		cJS += "});" + HTML_LF
		cJS += "var " + cName + " = new THREE.Sprite(" + cName + "_mat);" + HTML_LF
		cJS += cName + ".position.set(" + cX + ", " + cY + ", " + cZ + ");" + HTML_LF
		cJS += cName + ".scale.set(" + cScaleX + ", " + cScaleY + ", 1);" + HTML_LF
		cJS += "scene_" + cCanvasId + ".add(" + cName + ");" + HTML_LF
		addBodyScript(cJS)
		return self

	# Create text sprite (canvas-rendered text as billboard)
	func threeJSTextSprite cCanvasId, cName, cText, aOptions
		cX = htmlGetOpt(aOptions, "x", "0")
		cY = htmlGetOpt(aOptions, "y", "0")
		cZ = htmlGetOpt(aOptions, "z", "0")
		cFontSize = htmlGetOpt(aOptions, "fontSize", "48")
		cFontFamily = htmlGetOpt(aOptions, "font", "Arial")
		cTextColor = htmlGetOpt(aOptions, "color", "#ffffff")
		cBGColor = htmlGetOpt(aOptions, "bgColor", "")
		cPadding = htmlGetOpt(aOptions, "padding", "10")
		cScaleF = htmlGetOpt(aOptions, "scale", "1")


		cJS = "(function() {" + HTML_LF
		cJS += "  var canvas = document.createElement(" + HTML_SQ + "canvas" + HTML_SQ + ");" + HTML_LF
		cJS += "  var ctx = canvas.getContext(" + HTML_SQ + "2d" + HTML_SQ + ");" + HTML_LF
		cJS += "  ctx.font = " + HTML_SQ + cFontSize + "px " + cFontFamily + HTML_SQ + ";" + HTML_LF
		cJS += "  var w = ctx.measureText(" + HTML_DQ + cText + HTML_DQ + ").width + " + cPadding + "*2;" + HTML_LF
		cJS += "  var h = parseInt(" + cFontSize + ") + " + cPadding + "*2;" + HTML_LF
		cJS += "  canvas.width = w; canvas.height = h;" + HTML_LF
		if cBGColor != ""
			cJS += "  ctx.fillStyle = " + HTML_DQ + cBGColor + HTML_DQ + ";" + HTML_LF
			cJS += "  ctx.fillRect(0, 0, w, h);" + HTML_LF
		ok
		cJS += "  ctx.font = " + HTML_SQ + cFontSize + "px " + cFontFamily + HTML_SQ + ";" + HTML_LF
		cJS += "  ctx.fillStyle = " + HTML_DQ + cTextColor + HTML_DQ + ";" + HTML_LF
		cJS += "  ctx.textBaseline = " + HTML_SQ + "middle" + HTML_SQ + ";" + HTML_LF
		cJS += "  ctx.fillText(" + HTML_DQ + cText + HTML_DQ + ", " + cPadding + ", h/2);" + HTML_LF
		cJS += "  var tex = new THREE.CanvasTexture(canvas);" + HTML_LF
		cJS += "  var mat = new THREE.SpriteMaterial({map: tex, transparent: true});" + HTML_LF
		cJS += "  var spr = new THREE.Sprite(mat);" + HTML_LF
		cJS += "  spr.position.set(" + cX + ", " + cY + ", " + cZ + ");" + HTML_LF
		cJS += "  spr.scale.set(w/h * " + cScaleF + ", " + cScaleF + ", 1);" + HTML_LF
		cJS += "  scene_" + cCanvasId + ".add(spr);" + HTML_LF
		cJS += "  window." + cName + " = spr;" + HTML_LF
		cJS += "})();" + HTML_LF
		addBodyScript(cJS)
		return self

	# ============================================================
	# 8. LINES & CURVES
	# ============================================================

	# Draw a line from a list of points
	# points: list of [x, y, z] strings, e.g. [["0","0","0"], ["1","2","0"], ["3","0","1"]]
	func threeJSLine cCanvasId, cName, aPoints, aOptions
		cColor = htmlGetOpt(aOptions, "color", "0xffffff")
		cLineWidth = htmlGetOpt(aOptions, "lineWidth", "1")
		lDashed = htmlGetOpt(aOptions, "dashed", false)
		cDashSize = htmlGetOpt(aOptions, "dashSize", "0.3")
		cGapSize = htmlGetOpt(aOptions, "gapSize", "0.15")

		cJS = "var " + cName + "_points = [];" + HTML_LF
		nPointLen = len(aPoints)
		for nPoint = 1 to nPointLen
			cJS += cName + "_points.push(new THREE.Vector3(" + aPoints[nPoint][1] + ", " + aPoints[nPoint][2] + ", " + aPoints[nPoint][3] + "));" + HTML_LF
		next
		cJS += "var " + cName + "_geo = new THREE.BufferGeometry().setFromPoints(" + cName + "_points);" + HTML_LF
		if lDashed
			cJS += "var " + cName + "_mat = new THREE.LineDashedMaterial({color:" + cColor + ", dashSize:" + cDashSize + ", gapSize:" + cGapSize + "});" + HTML_LF
			cJS += "var " + cName + " = new THREE.Line(" + cName + "_geo, " + cName + "_mat);" + HTML_LF
			cJS += cName + ".computeLineDistances();" + HTML_LF
		else
			cJS += "var " + cName + "_mat = new THREE.LineBasicMaterial({color:" + cColor + "});" + HTML_LF
			cJS += "var " + cName + " = new THREE.Line(" + cName + "_geo, " + cName + "_mat);" + HTML_LF
		ok
		cJS += "scene_" + cCanvasId + ".add(" + cName + ");" + HTML_LF
		addBodyScript(cJS)
		return self

	# Draw a smooth curve (CatmullRom spline)
	func threeJSCurve cCanvasId, cName, aControlPoints, aOptions
		cColor = htmlGetOpt(aOptions, "color", "0xffffff")
		cSegments = htmlGetOpt(aOptions, "segments", "64")
		lClosed = htmlGetOpt(aOptions, "closed", false)
		cTension = htmlGetOpt(aOptions, "tension", "0.5")
		lTube = htmlGetOpt(aOptions, "tube", false)
		cTubeRadius = htmlGetOpt(aOptions, "tubeRadius", "0.05")
		cTubeSegments = htmlGetOpt(aOptions, "tubeSegments", "8")

		cJS = "var " + cName + "_cp = [];" + HTML_LF
		nControlPointLen = len(aControlPoints)
		for nControlPoint = 1 to nControlPointLen
			cJS += cName + "_cp.push(new THREE.Vector3(" + aControlPoints[nControlPoint][1] + ", " + aControlPoints[nControlPoint][2] + ", " + aControlPoints[nControlPoint][3] + "));" + HTML_LF
		next

		if lClosed
			cJS += "var " + cName + "_curve = new THREE.CatmullRomCurve3(" + cName + "_cp, true, " + char(39) + "catmullrom" + char(39) + ", " + cTension + ");" + HTML_LF
		else
			cJS += "var " + cName + "_curve = new THREE.CatmullRomCurve3(" + cName + "_cp, false, " + char(39) + "catmullrom" + char(39) + ", " + cTension + ");" + HTML_LF
		ok

		if lTube
			cJS += "var " + cName + "_geo = new THREE.TubeGeometry(" + cName + "_curve, " + cSegments + ", " + cTubeRadius + ", " + cTubeSegments + ", " + threeJSBool(lClosed) + ");" + HTML_LF
			cJS += "var " + cName + "_mat = new THREE.MeshStandardMaterial({color:" + cColor + "});" + HTML_LF
			cJS += "var " + cName + " = new THREE.Mesh(" + cName + "_geo, " + cName + "_mat);" + HTML_LF
		else
			cJS += "var " + cName + "_pts = " + cName + "_curve.getPoints(" + cSegments + ");" + HTML_LF
			cJS += "var " + cName + "_geo = new THREE.BufferGeometry().setFromPoints(" + cName + "_pts);" + HTML_LF
			cJS += "var " + cName + "_mat = new THREE.LineBasicMaterial({color:" + cColor + "});" + HTML_LF
			cJS += "var " + cName + " = new THREE.Line(" + cName + "_geo, " + cName + "_mat);" + HTML_LF
		ok
		cJS += "scene_" + cCanvasId + ".add(" + cName + ");" + HTML_LF
		addBodyScript(cJS)
		return self

	# Tube geometry along a path
	func threeJSTube cCanvasId, cName, aControlPoints, aOptions
		add(aOptions, ["tube", true])
		return threeJSCurve(cCanvasId, cName, aControlPoints, aOptions)

	# ============================================================
	# 9. VIDEO TEXTURE
	# ============================================================

	# Map a video to a mesh
	func threeJSVideoTexture cCanvasId, cMeshName, cVideoUrl, aOptions
		lLoop = htmlGetOpt(aOptions, "bLoop", true)
		lMuted = htmlGetOpt(aOptions, "muted", true)
		lAutoPlay = htmlGetOpt(aOptions, "autoPlay", true)


		cJS = "var " + cMeshName + "_video = document.createElement(" + HTML_SQ + "video" + HTML_SQ + ");" + HTML_LF
		cJS += cMeshName + "_video.src = " + HTML_DQ + cVideoUrl + HTML_DQ + ";" + HTML_LF
		cJS += cMeshName + "_video.crossOrigin = " + HTML_DQ + "anonymous" + HTML_DQ + ";" + HTML_LF
		if lLoop cJS += cMeshName + "_video.loop = true;" + HTML_LF ok
		if lMuted cJS += cMeshName + "_video.muted = true;" + HTML_LF ok
		cJS += cMeshName + "_video.playsInline = true;" + HTML_LF
		cJS += "var " + cMeshName + "_vidTex = new THREE.VideoTexture(" + cMeshName + "_video);" + HTML_LF
		cJS += cMeshName + ".material.map = " + cMeshName + "_vidTex;" + HTML_LF
		cJS += cMeshName + ".material.needsUpdate = true;" + HTML_LF
		if lAutoPlay
			cJS += "document.addEventListener(" + HTML_DQ + "click" + HTML_DQ + ", function _vp() {" + HTML_LF
			cJS += "  " + cMeshName + "_video.play(); document.removeEventListener(" + HTML_DQ + "click" + HTML_DQ + ", _vp);" + HTML_LF
			cJS += "}, {once: true});" + HTML_LF
		ok
		addBodyScript(cJS)
		return self

	# ============================================================
	# 10. MIRROR / REFLECTIVE PLANES
	# ============================================================

	# Enable Reflector CDN
	func enableReflector
		lReflector = true
		return self

	# Create a reflective plane (mirror floor)
	func threeJSMirror cCanvasId, cName, aOptions
		cW = htmlGetOpt(aOptions, "w", "10")
		cH = htmlGetOpt(aOptions, "h", "10")
		cX = htmlGetOpt(aOptions, "x", "0")
		cY = htmlGetOpt(aOptions, "y", "0")
		cZ = htmlGetOpt(aOptions, "z", "0")
		cRX = htmlGetOpt(aOptions, "rx", "-1.5708")
		cColor = htmlGetOpt(aOptions, "color", "0x888888")
		cTextureW = htmlGetOpt(aOptions, "textureWidth", "512")
		cTextureH = htmlGetOpt(aOptions, "textureHeight", "512")
		cOpacity = htmlGetOpt(aOptions, "opacity", "0.5")

		cJS = "var " + cName + "_geo = new THREE.PlaneGeometry(" + cW + ", " + cH + ");" + HTML_LF
		cJS += "var " + cName + " = new THREE.Reflector(" + cName + "_geo, {" + HTML_LF
		cJS += "  clipBias: 0.003," + HTML_LF
		cJS += "  textureWidth: " + cTextureW + "," + HTML_LF
		cJS += "  textureHeight: " + cTextureH + "," + HTML_LF
		cJS += "  color: " + cColor + HTML_LF
		cJS += "});" + HTML_LF
		cJS += cName + ".position.set(" + cX + ", " + cY + ", " + cZ + ");" + HTML_LF
		cJS += cName + ".rotation.x = " + cRX + ";" + HTML_LF
		cJS += "scene_" + cCanvasId + ".add(" + cName + ");" + HTML_LF
		addBodyScript(cJS)
		return self

	# ============================================================
	# 11. INSTANCED MESH
	# ============================================================

	# Create instanced mesh for rendering many copies efficiently
	# geometry, material: same as regular mesh, count: number of instances
	# jsSetupCode: JS code to position each instance using _matrix, _dummy, and index i
	func threeJSInstancedMesh cCanvasId, cName, cGeometry, cGeoParams, cCount, aOptions
		cColor = htmlGetOpt(aOptions, "color", "0x00cec9")
		cMetalness = htmlGetOpt(aOptions, "metalness", "0.3")
		cRoughness = htmlGetOpt(aOptions, "roughness", "0.5")
		lCastShadow = htmlGetOpt(aOptions, "castShadow", false)
		lReceiveShadow = htmlGetOpt(aOptions, "receiveShadow", false)
		cJSSetup = htmlGetOpt(aOptions, "setup", "")

		cGeoClass = threeJSGeoClass(cGeometry)

		cJS = "var " + cName + "_geo = new THREE." + cGeoClass + "(" + cGeoParams + ");" + HTML_LF
		cJS += "var " + cName + "_mat = new THREE.MeshStandardMaterial({color:" + cColor + ", metalness:" + cMetalness + ", roughness:" + cRoughness + "});" + HTML_LF
		cJS += "var " + cName + " = new THREE.InstancedMesh(" + cName + "_geo, " + cName + "_mat, " + cCount + ");" + HTML_LF
		if lCastShadow cJS += cName + ".castShadow = true;" + HTML_LF ok
		if lReceiveShadow cJS += cName + ".receiveShadow = true;" + HTML_LF ok

		# Setup instances
		cJS += "var _dummy = new THREE.Object3D();" + HTML_LF
		cJS += "var _matrix = new THREE.Matrix4();" + HTML_LF
		cJS += "var _color = new THREE.Color();" + HTML_LF
		if cJSSetup != ""
			cJS += "for(var i=0; i<" + cCount + "; i++) {" + HTML_LF
			cJS += "  " + cJSSetup + HTML_LF
			cJS += "  _dummy.updateMatrix();" + HTML_LF
			cJS += "  " + cName + ".setMatrixAt(i, _dummy.matrix);" + HTML_LF
			cJS += "}" + HTML_LF
		ok
		cJS += cName + ".instanceMatrix.needsUpdate = true;" + HTML_LF
		cJS += "scene_" + cCanvasId + ".add(" + cName + ");" + HTML_LF
		addBodyScript(cJS)
		return self

	# Set individual instance color
	# jsColorSetup: JS code run inside for loop (var i, _color available)
	func threeJSInstancedColors cName, cCount, cJSColorSetup
		cJS = "var _color = new THREE.Color();" + HTML_LF
		cJS += "for(var i=0; i<" + cCount + "; i++) {" + HTML_LF
		cJS += "  " + cJSColorSetup + HTML_LF
		cJS += "  " + cName + ".setColorAt(i, _color);" + HTML_LF
		cJS += "}" + HTML_LF
		cJS += cName + ".instanceColor.needsUpdate = true;" + HTML_LF
		addBodyScript(cJS)
		return self


	# ============================================================
	# 13. PHYSICS ENGINE (Cannon.js)
	# ============================================================

	# Enable Cannon.js physics CDN
	func enablePhysics
		lCannonJS = true
		return self

	# Create physics world with gravity
	# Options: gravityX, gravityY (-9.82 default), gravityZ, broadphase (naive/sap),
	#          iterations (solver iterations), tolerance
	func threeJSPhysicsWorld cCanvasId, aOptions
		cGx = htmlGetOpt(aOptions, "gravityX", "0")
		cGy = htmlGetOpt(aOptions, "gravityY", "-9.82")
		cGz = htmlGetOpt(aOptions, "gravityZ", "0")
		cBroadphase = htmlGetOpt(aOptions, "broadphase", "naive")
		cIterations = htmlGetOpt(aOptions, "iterations", "10")
		cTolerance = htmlGetOpt(aOptions, "tolerance", "0.001")

		cJS = "// Cannon.js Physics World" + HTML_LF
		cJS += "var world_" + cCanvasId + " = new CANNON.World();" + HTML_LF
		cJS += "world_" + cCanvasId + ".gravity.set(" + cGx + ", " + cGy + ", " + cGz + ");" + HTML_LF
		if cBroadphase = "sap"
			cJS += "world_" + cCanvasId + ".broadphase = new CANNON.SAPBroadphase(world_" + cCanvasId + ");" + HTML_LF
		else
			cJS += "world_" + cCanvasId + ".broadphase = new CANNON.NaiveBroadphase();" + HTML_LF
		ok
		cJS += "world_" + cCanvasId + ".solver.iterations = " + cIterations + ";" + HTML_LF
		cJS += "world_" + cCanvasId + ".solver.tolerance = " + cTolerance + ";" + HTML_LF

		# Physics bodies registry: maps mesh name -> body
		cJS += "var physicsBodies_" + cCanvasId + " = [];" + HTML_LF

		# Step physics in animation loop
		cJS += "var physTimeStep_" + cCanvasId + " = 1/60;" + HTML_LF
		cJS += "animCallbacks_" + cCanvasId + ".push(function(delta) {" + HTML_LF
		cJS += "  world_" + cCanvasId + ".step(physTimeStep_" + cCanvasId + ", delta, 3);" + HTML_LF
		cJS += "  for(var i = 0; i < physicsBodies_" + cCanvasId + ".length; i++) {" + HTML_LF
		cJS += "    var pb = physicsBodies_" + cCanvasId + "[i];" + HTML_LF
		cJS += "    pb.mesh.position.copy(pb.body.position);" + HTML_LF
		cJS += "    pb.mesh.quaternion.copy(pb.body.quaternion);" + HTML_LF
		cJS += "  }" + HTML_LF
		cJS += "});" + HTML_LF

		addBodyScript(cJS)
		return self

	# Add a physics rigid body to an existing mesh
	# shape: box, sphere, cylinder, plane
	# bodyType: dynamic (default), static, kinematic
	# Options: mass (0=static), friction, restitution (bounciness),
	#          linearDamping, angularDamping, fixedRotation,
	#          sx/sy/sz (shape size overrides), radius
	func threeJSPhysicsBody cCanvasId, cMeshName, cShape, aOptions
		cMass = htmlGetOpt(aOptions, "mass", "1")
		cFriction = htmlGetOpt(aOptions, "friction", "0.3")
		cRestitution = htmlGetOpt(aOptions, "restitution", "0.3")
		cLinearDamping = htmlGetOpt(aOptions, "linearDamping", "0.01")
		cAngularDamping = htmlGetOpt(aOptions, "angularDamping", "0.01")
		lFixedRotation = htmlGetOpt(aOptions, "fixedRotation", false)
		cBodyType = htmlGetOpt(aOptions, "bodyType", "dynamic")
		# Shape size overrides
		cSx = htmlGetOpt(aOptions, "sx", "")
		cSy = htmlGetOpt(aOptions, "sy", "")
		cSz = htmlGetOpt(aOptions, "sz", "")
		cRadius = htmlGetOpt(aOptions, "radius", "")

		cJS = "// Physics body for " + cMeshName + HTML_LF

		# Create shape based on type
		if cShape = "box"
			if cSx != ""
				cJS += "var " + cMeshName + "_shape = new CANNON.Box(new CANNON.Vec3(" + cSx + "/2, " + cSy + "/2, " + cSz + "/2));" + HTML_LF
			else
				# Auto-detect from mesh bounding box
				cJS += "var _bb = new THREE.Box3().setFromObject(" + cMeshName + ");" + HTML_LF
				cJS += "var _sz = new THREE.Vector3();" + HTML_LF
				cJS += "_bb.getSize(_sz);" + HTML_LF
				cJS += "var " + cMeshName + "_shape = new CANNON.Box(new CANNON.Vec3(_sz.x/2, _sz.y/2, _sz.z/2));" + HTML_LF
			ok
		but cShape = "sphere"
			if cRadius != ""
				cJS += "var " + cMeshName + "_shape = new CANNON.Sphere(" + cRadius + ");" + HTML_LF
			else
				cJS += "var _bb = new THREE.Box3().setFromObject(" + cMeshName + ");" + HTML_LF
				cJS += "var _sz = new THREE.Vector3();" + HTML_LF
				cJS += "_bb.getSize(_sz);" + HTML_LF
				cJS += "var " + cMeshName + "_shape = new CANNON.Sphere(Math.max(_sz.x,_sz.y,_sz.z)/2);" + HTML_LF
			ok
		but cShape = "cylinder"
			if cRadius != ""
				cJS += "var " + cMeshName + "_shape = new CANNON.Cylinder(" + cRadius + ", " + cRadius + ", " + cSy + ", 12);" + HTML_LF
			else
				cJS += "var _bb = new THREE.Box3().setFromObject(" + cMeshName + ");" + HTML_LF
				cJS += "var _sz = new THREE.Vector3();" + HTML_LF
				cJS += "_bb.getSize(_sz);" + HTML_LF
				cJS += "var " + cMeshName + "_shape = new CANNON.Cylinder(Math.max(_sz.x,_sz.z)/2, Math.max(_sz.x,_sz.z)/2, _sz.y, 12);" + HTML_LF
			ok
		but cShape = "plane"
			cJS += "var " + cMeshName + "_shape = new CANNON.Plane();" + HTML_LF
		ok

		# Create body
		if cBodyType = "static"
			cJS += "var " + cMeshName + "_body = new CANNON.Body({ mass: 0 });" + HTML_LF
			cJS += cMeshName + "_body.type = CANNON.Body.STATIC;" + HTML_LF
		but cBodyType = "kinematic"
			cJS += "var " + cMeshName + "_body = new CANNON.Body({ mass: 0 });" + HTML_LF
			cJS += cMeshName + "_body.type = CANNON.Body.KINEMATIC;" + HTML_LF
		else
			cJS += "var " + cMeshName + "_body = new CANNON.Body({ mass: " + cMass + " });" + HTML_LF
		ok

		cJS += cMeshName + "_body.addShape(" + cMeshName + "_shape);" + HTML_LF
		cJS += cMeshName + "_body.position.set(" + cMeshName + ".position.x, " + cMeshName + ".position.y, " + cMeshName + ".position.z);" + HTML_LF
		cJS += cMeshName + "_body.quaternion.set(" + cMeshName + ".quaternion.x, " + cMeshName + ".quaternion.y, " + cMeshName + ".quaternion.z, " + cMeshName + ".quaternion.w);" + HTML_LF

		# Material properties
		cJS += cMeshName + "_body.material = new CANNON.Material();" + HTML_LF
		cJS += cMeshName + "_body.material.friction = " + cFriction + ";" + HTML_LF
		cJS += cMeshName + "_body.material.restitution = " + cRestitution + ";" + HTML_LF

		# Damping
		cJS += cMeshName + "_body.linearDamping = " + cLinearDamping + ";" + HTML_LF
		cJS += cMeshName + "_body.angularDamping = " + cAngularDamping + ";" + HTML_LF

		if lFixedRotation
			cJS += cMeshName + "_body.fixedRotation = true;" + HTML_LF
			cJS += cMeshName + "_body.updateMassProperties();" + HTML_LF
		ok

		# Add to world and register for sync
		cJS += "world_" + cCanvasId + ".addBody(" + cMeshName + "_body);" + HTML_LF
		cJS += "physicsBodies_" + cCanvasId + ".push({ mesh: " + cMeshName + ", body: " + cMeshName + "_body });" + HTML_LF

		addBodyScript(cJS)
		return self

	# Create a static physics ground plane (infinite, at y=0 by default)
	# Options: y (height), friction, restitution, visible (show a mesh), 
	#          size (visible mesh size), color
	func threeJSPhysicsGround cCanvasId, aOptions
		cY = htmlGetOpt(aOptions, "y", "0")
		cFriction = htmlGetOpt(aOptions, "friction", "0.5")
		cRestitution = htmlGetOpt(aOptions, "restitution", "0.3")
		lVisible = htmlGetOpt(aOptions, "visible", true)
		cSize = htmlGetOpt(aOptions, "size", "40")
		cColor = htmlGetOpt(aOptions, "color", "0x333333")

		cJS = "// Physics ground plane" + HTML_LF
		cJS += "var groundBody_" + cCanvasId + " = new CANNON.Body({ mass: 0 });" + HTML_LF
		cJS += "groundBody_" + cCanvasId + ".addShape(new CANNON.Plane());" + HTML_LF
		cJS += "groundBody_" + cCanvasId + ".position.set(0, " + cY + ", 0);" + HTML_LF
		# Rotate plane to face up (Cannon planes face +Z by default)
		cJS += "groundBody_" + cCanvasId + ".quaternion.setFromAxisAngle(new CANNON.Vec3(1,0,0), -Math.PI/2);" + HTML_LF
		cJS += "groundBody_" + cCanvasId + ".material = new CANNON.Material();" + HTML_LF
		cJS += "groundBody_" + cCanvasId + ".material.friction = " + cFriction + ";" + HTML_LF
		cJS += "groundBody_" + cCanvasId + ".material.restitution = " + cRestitution + ";" + HTML_LF
		cJS += "world_" + cCanvasId + ".addBody(groundBody_" + cCanvasId + ");" + HTML_LF

		if lVisible
			cJS += "var groundMesh_" + cCanvasId + " = new THREE.Mesh(" + HTML_LF
			cJS += "  new THREE.PlaneGeometry(" + cSize + ", " + cSize + ")," + HTML_LF
			cJS += "  new THREE.MeshStandardMaterial({color: " + cColor + "})" + HTML_LF
			cJS += ");" + HTML_LF
			cJS += "groundMesh_" + cCanvasId + ".rotation.x = -Math.PI/2;" + HTML_LF
			cJS += "groundMesh_" + cCanvasId + ".position.y = " + cY + ";" + HTML_LF
			cJS += "groundMesh_" + cCanvasId + ".receiveShadow = true;" + HTML_LF
			cJS += "scene_" + cCanvasId + ".add(groundMesh_" + cCanvasId + ");" + HTML_LF
		ok

		addBodyScript(cJS)
		return self

	# Apply a force to a physics body
	# Returns JS code string to use in event handlers
	func threeJSApplyForce cMeshName, cFx, cFy, cFz
		return cMeshName + "_body.applyForce(new CANNON.Vec3(" + cFx + "," + cFy + "," + cFz + "), " + cMeshName + "_body.position);"

	# Apply an impulse (instant velocity change) to a physics body
	func threeJSApplyImpulse cMeshName, cIx, cIy, cIz
		return cMeshName + "_body.applyImpulse(new CANNON.Vec3(" + cIx + "," + cIy + "," + cIz + "), " + cMeshName + "_body.position);"

	# Set velocity directly on a physics body
	func threeJSSetVelocity cMeshName, cVx, cVy, cVz
		return cMeshName + "_body.velocity.set(" + cVx + "," + cVy + "," + cVz + ");"

	# Set angular velocity
	func threeJSSetAngularVelocity cMeshName, cAx, cAy, cAz
		return cMeshName + "_body.angularVelocity.set(" + cAx + "," + cAy + "," + cAz + ");"

	# Physics collision event: execute JS when two bodies collide
	# jsOnCollide: JS code with 'e' (contact event) available
	func threeJSOnCollide cCanvasId, cMeshName, cJSOnCollide
		cJS = cMeshName + "_body.addEventListener(" + HTML_DQ + "collide" + HTML_DQ + ", function(e) {" + HTML_LF
		cJS += "  " + cJSOnCollide + HTML_LF
		cJS += "});" + HTML_LF
		addBodyScript(cJS)
		return self

	# Physics constraint: connect two bodies with a point-to-point joint
	# Options: pivotA_x/y/z, pivotB_x/y/z, maxForce
	func threeJSPhysicsConstraint cCanvasId, cMeshA, cMeshB, aOptions
		cPax = htmlGetOpt(aOptions, "pivotA_x", "0")
		cPay = htmlGetOpt(aOptions, "pivotA_y", "0")
		cPaz = htmlGetOpt(aOptions, "pivotA_z", "0")
		cPbx = htmlGetOpt(aOptions, "pivotB_x", "0")
		cPby = htmlGetOpt(aOptions, "pivotB_y", "0")
		cPbz = htmlGetOpt(aOptions, "pivotB_z", "0")
		cMaxForce = htmlGetOpt(aOptions, "maxForce", "1e6")

		cJS = "var constraint_" + cMeshA + "_" + cMeshB + " = new CANNON.PointToPointConstraint(" + HTML_LF
		cJS += "  " + cMeshA + "_body, new CANNON.Vec3(" + cPax + "," + cPay + "," + cPaz + ")," + HTML_LF
		cJS += "  " + cMeshB + "_body, new CANNON.Vec3(" + cPbx + "," + cPby + "," + cPbz + ")," + HTML_LF
		cJS += "  " + cMaxForce + HTML_LF
		cJS += ");" + HTML_LF
		cJS += "world_" + cCanvasId + ".addConstraint(constraint_" + cMeshA + "_" + cMeshB + ");" + HTML_LF

		addBodyScript(cJS)
		return self

	# Spawn a physics object at runtime (returns JS code)
	# Useful for projectiles, spawners, etc.
	func threeJSPhysicsSpawn cCanvasId, cNamePrefix, cShape, cGeoType, cGeoParams, aOptions
		cMass = htmlGetOpt(aOptions, "mass", "1")
		cColor = htmlGetOpt(aOptions, "color", "0xff0000")
		cRestitution = htmlGetOpt(aOptions, "restitution", "0.5")
		cFriction = htmlGetOpt(aOptions, "friction", "0.3")
		cRadius = htmlGetOpt(aOptions, "radius", "0.3")
		cSx = htmlGetOpt(aOptions, "sx", "0.5")
		cSy = htmlGetOpt(aOptions, "sy", "0.5")
		cSz = htmlGetOpt(aOptions, "sz", "0.5")

		cJS = "var _spawnCount_" + cNamePrefix + " = 0;" + HTML_LF
		cJS += "function spawn_" + cNamePrefix + "(x, y, z, vx, vy, vz) {" + HTML_LF
		cJS += "  vx = vx || 0; vy = vy || 0; vz = vz || 0;" + HTML_LF

		# Create mesh
		if cGeoType = "sphere"
			cJS += "  var geo = new THREE.SphereGeometry(" + cRadius + ", 16, 16);" + HTML_LF
		but cGeoType = "box"
			cJS += "  var geo = new THREE.BoxGeometry(" + cSx + ", " + cSy + ", " + cSz + ");" + HTML_LF
		ok
		cJS += "  var mat = new THREE.MeshStandardMaterial({color: " + cColor + "});" + HTML_LF
		cJS += "  var mesh = new THREE.Mesh(geo, mat);" + HTML_LF
		cJS += "  mesh.position.set(x, y, z);" + HTML_LF
		cJS += "  mesh.castShadow = true;" + HTML_LF
		cJS += "  scene_" + cCanvasId + ".add(mesh);" + HTML_LF

		# Create physics body
		if cShape = "sphere"
			cJS += "  var pShape = new CANNON.Sphere(" + cRadius + ");" + HTML_LF
		but cShape = "box"
			cJS += "  var pShape = new CANNON.Box(new CANNON.Vec3(" + cSx + "/2, " + cSy + "/2, " + cSz + "/2));" + HTML_LF
		ok
		cJS += "  var body = new CANNON.Body({ mass: " + cMass + " });" + HTML_LF
		cJS += "  body.addShape(pShape);" + HTML_LF
		cJS += "  body.position.set(x, y, z);" + HTML_LF
		cJS += "  body.velocity.set(vx, vy, vz);" + HTML_LF
		cJS += "  body.material = new CANNON.Material();" + HTML_LF
		cJS += "  body.material.restitution = " + cRestitution + ";" + HTML_LF
		cJS += "  body.material.friction = " + cFriction + ";" + HTML_LF
		cJS += "  world_" + cCanvasId + ".addBody(body);" + HTML_LF
		cJS += "  physicsBodies_" + cCanvasId + ".push({ mesh: mesh, body: body });" + HTML_LF
		cJS += "  _spawnCount_" + cNamePrefix + "++;" + HTML_LF
		cJS += "  return { mesh: mesh, body: body };" + HTML_LF
		cJS += "}" + HTML_LF

		addBodyScript(cJS)
		return self

	# ============================================================
	# 14. ANIMATION TWEENING (GSAP)
	# ============================================================

	# Enable GSAP CDN
	func enableGSAP
		lGSAP = true
		return self

	# Tween a mesh property (position, rotation, scale, material)
	# target: "position", "rotation", "scale", "material.color", "material.opacity", "material"
	# props: list of [prop, value] e.g. [["x", "5"], ["y", "2"]]
	# Options: duration, ease, delay, repeat (-1=infinite), yoyo, 
	#          onComplete (JS code), onUpdate (JS code), stagger
	func threeJSTween cMeshName, cTarget, aProps, aOptions
		cDuration = htmlGetOpt(aOptions, "duration", "1")
		cEase = htmlGetOpt(aOptions, "ease", "power2.out")
		cDelay = htmlGetOpt(aOptions, "delay", "0")
		cRepeat = htmlGetOpt(aOptions, "repeat", "0")
		lYoyo = htmlGetOpt(aOptions, "yoyo", false)
		cOnComplete = htmlGetOpt(aOptions, "onComplete", "")
		cOnUpdate = htmlGetOpt(aOptions, "onUpdate", "")
		cStagger = htmlGetOpt(aOptions, "stagger", "")


		# Build target object reference
		cTargetRef = cMeshName + "." + cTarget

		# Build properties object
		cJS = "gsap.to(" + cTargetRef + ", {" + HTML_LF
		nPropLen = len(aProps)
		for nProp = 1 to nPropLen
			cJS += "  " + aProps[nProp][1] + ": " + aProps[nProp][2]
			if nProp < nPropLen cJS += "," ok
			cJS += HTML_LF
		next
		cJS += "  ,duration: " + cDuration + HTML_LF
		cJS += "  ,ease: " + HTML_DQ + cEase + HTML_DQ + HTML_LF
		if cDelay != "0"
			cJS += "  ,delay: " + cDelay + HTML_LF
		ok
		if cRepeat != "0"
			cJS += "  ,repeat: " + cRepeat + HTML_LF
		ok
		if lYoyo
			cJS += "  ,yoyo: true" + HTML_LF
		ok
		if cOnComplete != ""
			cJS += "  ,onComplete: function() { " + cOnComplete + " }" + HTML_LF
		ok
		if cOnUpdate != ""
			cJS += "  ,onUpdate: function() { " + cOnUpdate + " }" + HTML_LF
		ok
		cJS += "});" + HTML_LF

		addBodyScript(cJS)
		return self

	# Tween from values (reverse direction)
	func threeJSTweenFrom cMeshName, cTarget, aProps, aOptions
		cDuration = htmlGetOpt(aOptions, "duration", "1")
		cEase = htmlGetOpt(aOptions, "ease", "power2.out")
		cDelay = htmlGetOpt(aOptions, "delay", "0")


		cTargetRef = cMeshName + "." + cTarget
		cJS = "gsap.from(" + cTargetRef + ", {" + HTML_LF
		nPropLen = len(aProps)
		for nProp = 1 to nPropLen
			cJS += "  " + aProps[nProp][1] + ": " + aProps[nProp][2]
			if nProp < nPropLen cJS += "," ok
			cJS += HTML_LF
		next
		cJS += "  ,duration: " + cDuration + HTML_LF
		cJS += "  ,ease: " + HTML_DQ + cEase + HTML_DQ + HTML_LF
		if cDelay != "0"
			cJS += "  ,delay: " + cDelay + HTML_LF
		ok
		cJS += "});" + HTML_LF

		addBodyScript(cJS)
		return self

	# Create a GSAP timeline for sequenced animations
	# name: timeline variable name
	# Options: repeat (-1=infinite), yoyo, delay, paused
	func threeJSTimeline cName, aOptions
		cRepeat = htmlGetOpt(aOptions, "repeat", "0")
		lYoyo = htmlGetOpt(aOptions, "yoyo", false)
		cDelay = htmlGetOpt(aOptions, "delay", "0")
		lPaused = htmlGetOpt(aOptions, "paused", false)

		cJS = "var " + cName + " = gsap.timeline({"

		aOpts = []
		if cRepeat != "0" add(aOpts, "repeat: " + cRepeat) ok
		if lYoyo add(aOpts, "yoyo: true") ok
		if cDelay != "0" add(aOpts, "delay: " + cDelay) ok
		if lPaused add(aOpts, "paused: true") ok

		nOptLen = len(aOpts)
		for nOpt = 1 to nOptLen
			if nOpt > 1 cJS += ", " ok
			cJS += aOpts[nOpt]
		next
		cJS += "});" + HTML_LF

		addBodyScript(cJS)
		return self

	# Add a tween step to a timeline
	# timelineLabel: position in timeline ("<" = start of previous, "+=0.5" = 0.5s after previous)
	func threeJSTimelineAdd cTimelineName, cMeshName, cTarget, aProps, aOptions
		cDuration = htmlGetOpt(aOptions, "duration", "1")
		cEase = htmlGetOpt(aOptions, "ease", "power2.inOut")
		cLabel = htmlGetOpt(aOptions, "label", "")


		cTargetRef = cMeshName + "." + cTarget
		cJS = cTimelineName + ".to(" + cTargetRef + ", {" + HTML_LF
		nPropLen = len(aProps)
		for nProp = 1 to nPropLen
			cJS += "  " + aProps[nProp][1] + ": " + aProps[nProp][2]
			if nProp < nPropLen cJS += "," ok
			cJS += HTML_LF
		next
		cJS += "  ,duration: " + cDuration + HTML_LF
		cJS += "  ,ease: " + HTML_DQ + cEase + HTML_DQ + HTML_LF
		cJS += "}"
		if cLabel != ""
			cJS += ", " + HTML_DQ + cLabel + HTML_DQ
		ok
		cJS += ");" + HTML_LF

		addBodyScript(cJS)
		return self

	# Tween a raw JS expression / object (not just mesh properties)
	# target: JS expression for the object to tween
	# props: list of [prop, value]
	# Options: same as threeJSTween
	func threeJSTweenRaw cTarget, aProps, aOptions
		cDuration = htmlGetOpt(aOptions, "duration", "1")
		cEase = htmlGetOpt(aOptions, "ease", "power2.out")
		cDelay = htmlGetOpt(aOptions, "delay", "0")
		cRepeat = htmlGetOpt(aOptions, "repeat", "0")
		lYoyo = htmlGetOpt(aOptions, "yoyo", false)
		cOnComplete = htmlGetOpt(aOptions, "onComplete", "")
		cOnUpdate = htmlGetOpt(aOptions, "onUpdate", "")


		cJS = "gsap.to(" + cTarget + ", {" + HTML_LF
		nPropLen = len(aProps)
		for nProp = 1 to nPropLen
			cJS += "  " + aProps[nProp][1] + ": " + aProps[nProp][2]
			if nProp < nPropLen cJS += "," ok
			cJS += HTML_LF
		next
		cJS += "  ,duration: " + cDuration + HTML_LF
		cJS += "  ,ease: " + HTML_DQ + cEase + HTML_DQ + HTML_LF
		if cDelay != "0"
			cJS += "  ,delay: " + cDelay + HTML_LF
		ok
		if cRepeat != "0"
			cJS += "  ,repeat: " + cRepeat + HTML_LF
		ok
		if lYoyo
			cJS += "  ,yoyo: true" + HTML_LF
		ok
		if cOnComplete != ""
			cJS += "  ,onComplete: function() { " + cOnComplete + " }" + HTML_LF
		ok
		if cOnUpdate != ""
			cJS += "  ,onUpdate: function() { " + cOnUpdate + " }" + HTML_LF
		ok
		cJS += "});" + HTML_LF

		addBodyScript(cJS)
		return self

	# Tween material color with GSAP (special handling for THREE.Color)
	# colorHex: target color as "0xRRGGBB" or "#RRGGBB"
	func threeJSTweenColor cMeshName, cColorHex, aOptions
		cDuration = htmlGetOpt(aOptions, "duration", "1")
		cEase = htmlGetOpt(aOptions, "ease", "power2.inOut")
		cDelay = htmlGetOpt(aOptions, "delay", "0")


		cJS = "(function() {" + HTML_LF
		cJS += "  var _tc = new THREE.Color(" + cColorHex + ");" + HTML_LF
		cJS += "  gsap.to(" + cMeshName + ".material.color, {" + HTML_LF
		cJS += "    r: _tc.r, g: _tc.g, b: _tc.b," + HTML_LF
		cJS += "    duration: " + cDuration + "," + HTML_LF
		cJS += "    ease: " + HTML_DQ + cEase + HTML_DQ + HTML_LF
		if cDelay != "0"
			cJS += "    ,delay: " + cDelay + HTML_LF
		ok
		cJS += "  });" + HTML_LF
		cJS += "})();" + HTML_LF

		addBodyScript(cJS)
		return self

	# Tween camera to a new position/lookAt
	# Options: duration, ease, lookX/Y/Z
	func threeJSTweenCamera cCanvasId, aOptions
		cX = htmlGetOpt(aOptions, "x", "")
		cY = htmlGetOpt(aOptions, "y", "")
		cZ = htmlGetOpt(aOptions, "z", "")
		cLookX = htmlGetOpt(aOptions, "lookX", "")
		cLookY = htmlGetOpt(aOptions, "lookY", "")
		cLookZ = htmlGetOpt(aOptions, "lookZ", "")
		cDuration = htmlGetOpt(aOptions, "duration", "2")
		cEase = htmlGetOpt(aOptions, "ease", "power2.inOut")
		cDelay = htmlGetOpt(aOptions, "delay", "0")


		# Tween camera position
		if cX != "" or cY != "" or cZ != ""
			cJS = "gsap.to(camera_" + cCanvasId + ".position, {" + HTML_LF
			if cX != "" cJS += "  x: " + cX + "," + HTML_LF ok
			if cY != "" cJS += "  y: " + cY + "," + HTML_LF ok
			if cZ != "" cJS += "  z: " + cZ + "," + HTML_LF ok
			cJS += "  duration: " + cDuration + "," + HTML_LF
			cJS += "  ease: " + HTML_DQ + cEase + HTML_DQ + HTML_LF
			if cDelay != "0"
				cJS += "  ,delay: " + cDelay + HTML_LF
			ok
			cJS += "});" + HTML_LF
			addBodyScript(cJS)
		ok

		# Tween orbit controls target (lookAt point)
		if cLookX != "" or cLookY != "" or cLookZ != ""
			cJS = "if(typeof controls_" + cCanvasId + " !== " + HTML_DQ + "undefined" + HTML_DQ + ") {" + HTML_LF
			cJS += "  gsap.to(controls_" + cCanvasId + ".target, {" + HTML_LF
			if cLookX != "" cJS += "    x: " + cLookX + "," + HTML_LF ok
			if cLookY != "" cJS += "    y: " + cLookY + "," + HTML_LF ok
			if cLookZ != "" cJS += "    z: " + cLookZ + "," + HTML_LF ok
			cJS += "    duration: " + cDuration + "," + HTML_LF
			cJS += "    ease: " + HTML_DQ + cEase + HTML_DQ + HTML_LF
			if cDelay != "0"
				cJS += "    ,delay: " + cDelay + HTML_LF
			ok
			cJS += "    ,onUpdate: function() { controls_" + cCanvasId + ".update(); }" + HTML_LF
			cJS += "  });" + HTML_LF
			cJS += "}" + HTML_LF
			addBodyScript(cJS)
		ok

		return self

	# Delayed execution using GSAP (cleaner than setTimeout)
	func threeJSDelayedCall cDelay, cJSCode
		cJS = "gsap.delayedCall(" + cDelay + ", function() {" + HTML_LF
		cJS += "  " + cJSCode + HTML_LF
		cJS += "});" + HTML_LF
		addBodyScript(cJS)
		return self

	# ============================================================
	# 15. 3D TEXT GEOMETRY
	# ============================================================

	# Enable TextGeometry + FontLoader CDN
	func enableTextGeometry
		lTextGeometry = true
		return self

	# Load a font and create 3D text mesh
	# text: the string to render in 3D
	# Options: font (url or built-in name), size, height (extrusion depth),
	#          curveSegments, bevelEnabled, bevelThickness, bevelSize, bevelSegments,
	#          color, metalness, roughness, emissive, emissiveIntensity,
	#          mat (basic/standard/phong), x, y, z, rx, ry, rz,
	#          castShadow, receiveShadow, center (auto-center the text)
	func threeJSText3D cCanvasId, cName, cText, aOptions
		# Font options
		cFont = htmlGetOpt(aOptions, "font", "helvetiker")
		cFontStyle = htmlGetOpt(aOptions, "fontStyle", "regular")
		cFontUrl = htmlGetOpt(aOptions, "fontUrl", "")

		# Geometry options
		cSize = htmlGetOpt(aOptions, "size", "1")
		cHeight = htmlGetOpt(aOptions, "height", "0.3")
		cCurveSegments = htmlGetOpt(aOptions, "curveSegments", "6")
		lBevelEnabled = htmlGetOpt(aOptions, "bevelEnabled", true)
		cBevelThickness = htmlGetOpt(aOptions, "bevelThickness", "0.03")
		cBevelSize = htmlGetOpt(aOptions, "bevelSize", "0.02")
		cBevelSegments = htmlGetOpt(aOptions, "bevelSegments", "4")

		# Material options
		cColor = htmlGetOpt(aOptions, "color", "0xffffff")
		cMetalness = htmlGetOpt(aOptions, "metalness", "0.3")
		cRoughness = htmlGetOpt(aOptions, "roughness", "0.4")
		cEmissive = htmlGetOpt(aOptions, "emissive", "")
		cEmissiveIntensity = htmlGetOpt(aOptions, "emissiveIntensity", "0.5")
		cMaterial = htmlGetOpt(aOptions, "mat", "standard")
		lWireframe = htmlGetOpt(aOptions, "wireframe", false)

		# Transform
		cX = htmlGetOpt(aOptions, "x", "0")
		cY = htmlGetOpt(aOptions, "y", "0")
		cZ = htmlGetOpt(aOptions, "z", "0")
		cRX = htmlGetOpt(aOptions, "rx", "0")
		cRY = htmlGetOpt(aOptions, "ry", "0")
		cRZ = htmlGetOpt(aOptions, "rz", "0")
		cScale = htmlGetOpt(aOptions, "scale", "")

		# Extras
		lCastShadow = htmlGetOpt(aOptions, "castShadow", true)
		lReceiveShadow = htmlGetOpt(aOptions, "receiveShadow", false)
		lCenter = htmlGetOpt(aOptions, "center", true)


		# Determine font URL
		if cFontUrl != ""
			cFUrl = cFontUrl
		else
			# Built-in Three.js fonts
			cFUrl = "https://cdn.jsdelivr.net/npm/three@0.128.0/examples/fonts/"
			if cFont = "helvetiker"
				if cFontStyle = "bold"
					cFUrl += "helvetiker_bold.typeface.json"
				else
					cFUrl += "helvetiker_regular.typeface.json"
				ok
			but cFont = "optimer"
				if cFontStyle = "bold"
					cFUrl += "optimer_bold.typeface.json"
				else
					cFUrl += "optimer_regular.typeface.json"
				ok
			but cFont = "gentilis"
				if cFontStyle = "bold"
					cFUrl += "gentilis_bold.typeface.json"
				else
					cFUrl += "gentilis_regular.typeface.json"
				ok
			but cFont = "droid_sans"
				if cFontStyle = "bold"
					cFUrl += "droid/droid_sans_bold.typeface.json"
				else
					cFUrl += "droid/droid_sans_regular.typeface.json"
				ok
			but cFont = "droid_serif"
				if cFontStyle = "bold"
					cFUrl += "droid/droid_serif_bold.typeface.json"
				else
					cFUrl += "droid/droid_serif_regular.typeface.json"
				ok
			else
				cFUrl += "helvetiker_regular.typeface.json"
			ok
		ok

		cJS = "// 3D Text: " + cName + HTML_LF
		cJS += "var " + cName + " = null;" + HTML_LF
		cJS += "(function() {" + HTML_LF
		cJS += "  var loader = new THREE.FontLoader();" + HTML_LF
		cJS += "  loader.load(" + HTML_DQ + cFUrl + HTML_DQ + ", function(font) {" + HTML_LF
		cJS += "    var geo = new THREE.TextGeometry(" + HTML_DQ + cText + HTML_DQ + ", {" + HTML_LF
		cJS += "      font: font," + HTML_LF
		cJS += "      size: " + cSize + "," + HTML_LF
		cJS += "      height: " + cHeight + "," + HTML_LF
		cJS += "      curveSegments: " + cCurveSegments + "," + HTML_LF
		if lBevelEnabled
			cJS += "      bevelEnabled: true," + HTML_LF
			cJS += "      bevelThickness: " + cBevelThickness + "," + HTML_LF
			cJS += "      bevelSize: " + cBevelSize + "," + HTML_LF
			cJS += "      bevelSegments: " + cBevelSegments + HTML_LF
		else
			cJS += "      bevelEnabled: false" + HTML_LF
		ok
		cJS += "    });" + HTML_LF

		# Center the geometry
		if lCenter
			cJS += "    geo.computeBoundingBox();" + HTML_LF
			cJS += "    geo.translate(" + HTML_LF
			cJS += "      -(geo.boundingBox.max.x - geo.boundingBox.min.x) / 2," + HTML_LF
			cJS += "      -(geo.boundingBox.max.y - geo.boundingBox.min.y) / 2," + HTML_LF
			cJS += "      -(geo.boundingBox.max.z - geo.boundingBox.min.z) / 2" + HTML_LF
			cJS += "    );" + HTML_LF
		ok

		# Material
		if cMaterial = "basic"
			cMatType = "MeshBasicMaterial"
		but cMaterial = "phong"
			cMatType = "MeshPhongMaterial"
		else
			cMatType = "MeshStandardMaterial"
		ok

		cJS += "    var mat = new THREE." + cMatType + "({" + HTML_LF
		cJS += "      color: " + cColor + HTML_LF
		if cMaterial = "standard" or cMaterial = "phong"
			cJS += "      ,metalness: " + cMetalness + HTML_LF
			cJS += "      ,roughness: " + cRoughness + HTML_LF
		ok
		if cEmissive != ""
			cJS += "      ,emissive: " + cEmissive + HTML_LF
			cJS += "      ,emissiveIntensity: " + cEmissiveIntensity + HTML_LF
		ok
		if lWireframe
			cJS += "      ,wireframe: true" + HTML_LF
		ok
		cJS += "    });" + HTML_LF

		# Create mesh
		cJS += "    " + cName + " = new THREE.Mesh(geo, mat);" + HTML_LF
		cJS += "    " + cName + ".position.set(" + cX + ", " + cY + ", " + cZ + ");" + HTML_LF
		if cRX != "0" cJS += "    " + cName + ".rotation.x = " + cRX + ";" + HTML_LF ok
		if cRY != "0" cJS += "    " + cName + ".rotation.y = " + cRY + ";" + HTML_LF ok
		if cRZ != "0" cJS += "    " + cName + ".rotation.z = " + cRZ + ";" + HTML_LF ok
		if cScale != ""
			cJS += "    " + cName + ".scale.set(" + cScale + ", " + cScale + ", " + cScale + ");" + HTML_LF
		ok
		if lCastShadow
			cJS += "    " + cName + ".castShadow = true;" + HTML_LF
		ok
		if lReceiveShadow
			cJS += "    " + cName + ".receiveShadow = true;" + HTML_LF
		ok
		cJS += "    scene_" + cCanvasId + ".add(" + cName + ");" + HTML_LF
		cJS += "  });" + HTML_LF
		cJS += "})();" + HTML_LF

		addBodyScript(cJS)
		return self

	# Create multiple 3D text objects with a shared font load
	# items: list of [name, text, x, y, z, color] lists
	# Options: same font/geometry options as threeJSText3D
	func threeJSText3DMulti cCanvasId, aItems, aOptions
		cFont = htmlGetOpt(aOptions, "font", "helvetiker")
		cFontStyle = htmlGetOpt(aOptions, "fontStyle", "regular")
		cFontUrl = htmlGetOpt(aOptions, "fontUrl", "")
		cSize = htmlGetOpt(aOptions, "size", "1")
		cHeight = htmlGetOpt(aOptions, "height", "0.3")
		cCurveSegments = htmlGetOpt(aOptions, "curveSegments", "6")
		lBevelEnabled = htmlGetOpt(aOptions, "bevelEnabled", true)
		cBevelThickness = htmlGetOpt(aOptions, "bevelThickness", "0.03")
		cBevelSize = htmlGetOpt(aOptions, "bevelSize", "0.02")
		cBevelSegments = htmlGetOpt(aOptions, "bevelSegments", "4")
		cMetalness = htmlGetOpt(aOptions, "metalness", "0.3")
		cRoughness = htmlGetOpt(aOptions, "roughness", "0.4")
		lCenter = htmlGetOpt(aOptions, "center", true)


		# Determine font URL (same logic as threeJSText3D)
		if cFontUrl != ""
			cFUrl = cFontUrl
		else
			cFUrl = "https://cdn.jsdelivr.net/npm/three@0.128.0/examples/fonts/"
			if cFont = "helvetiker"
				if cFontStyle = "bold" cFUrl += "helvetiker_bold.typeface.json"
				else cFUrl += "helvetiker_regular.typeface.json" ok
			but cFont = "optimer"
				if cFontStyle = "bold" cFUrl += "optimer_bold.typeface.json"
				else cFUrl += "optimer_regular.typeface.json" ok
			but cFont = "gentilis"
				if cFontStyle = "bold" cFUrl += "gentilis_bold.typeface.json"
				else cFUrl += "gentilis_regular.typeface.json" ok
			else
				cFUrl += "helvetiker_regular.typeface.json"
			ok
		ok

		# Declare variables
		nItemLen = len(aItems)
		for nItem = 1 to nItemLen
			cJS = "var " + aItems[nItem][1] + " = null;" + HTML_LF
			addBodyScript(cJS)
		next

		cJS = "(function() {" + HTML_LF
		cJS += "  var loader = new THREE.FontLoader();" + HTML_LF
		cJS += "  loader.load(" + HTML_DQ + cFUrl + HTML_DQ + ", function(font) {" + HTML_LF

		for nItem = 1 to nItemLen
			aItem = aItems[nItem]
			cIName = aItem[1]
			cIText = aItem[2]
			cIx = aItem[3]
			cIy = aItem[4]
			cIz = aItem[5]
			cIColor = aItem[6]

			cJS += "    var geo_" + cIName + " = new THREE.TextGeometry(" + HTML_DQ + cIText + HTML_DQ + ", {" + HTML_LF
			cJS += "      font: font, size: " + cSize + ", height: " + cHeight + "," + HTML_LF
			cJS += "      curveSegments: " + cCurveSegments + "," + HTML_LF
			if lBevelEnabled
				cJS += "      bevelEnabled: true, bevelThickness: " + cBevelThickness + "," + HTML_LF
				cJS += "      bevelSize: " + cBevelSize + ", bevelSegments: " + cBevelSegments + HTML_LF
			else
				cJS += "      bevelEnabled: false" + HTML_LF
			ok
			cJS += "    });" + HTML_LF
			if lCenter
				cJS += "    geo_" + cIName + ".computeBoundingBox();" + HTML_LF
				cJS += "    geo_" + cIName + ".translate(-(geo_" + cIName + ".boundingBox.max.x-geo_" + cIName + ".boundingBox.min.x)/2, -(geo_" + cIName + ".boundingBox.max.y-geo_" + cIName + ".boundingBox.min.y)/2, -(geo_" + cIName + ".boundingBox.max.z-geo_" + cIName + ".boundingBox.min.z)/2);" + HTML_LF
			ok
			cJS += "    " + cIName + " = new THREE.Mesh(geo_" + cIName + ", new THREE.MeshStandardMaterial({color: " + cIColor + ", metalness: " + cMetalness + ", roughness: " + cRoughness + "}));" + HTML_LF
			cJS += "    " + cIName + ".position.set(" + cIx + ", " + cIy + ", " + cIz + ");" + HTML_LF
			cJS += "    " + cIName + ".castShadow = true;" + HTML_LF
			cJS += "    scene_" + cCanvasId + ".add(" + cIName + ");" + HTML_LF
		next

		cJS += "  });" + HTML_LF
		cJS += "})();" + HTML_LF

		addBodyScript(cJS)
		return self

	# ============================================================
	# 16. TERRAIN / HEIGHTMAP
	# ============================================================

	# Create a terrain mesh from a heightmap (procedural or image-based)
	# Options: width, depth, wSegments, dSegments, maxHeight, color,
	#          heightFunc (JS expression using x,z to compute y),
	#          heightMapUrl (image URL - overrides heightFunc),
	#          wireframe, flatShading, material (standard/phong/lambert)
	func threeJSTerrain cCanvasId, cName, aOptions
		cWidth = htmlGetOpt(aOptions, "width", "20")
		cDepth = htmlGetOpt(aOptions, "depth", "20")
		cWSeg = htmlGetOpt(aOptions, "wSegments", "64")
		cDSeg = htmlGetOpt(aOptions, "dSegments", "64")
		cMaxHeight = htmlGetOpt(aOptions, "maxHeight", "3")
		cColor = htmlGetOpt(aOptions, "color", "0x4a7c3f")
		cHeightFunc = htmlGetOpt(aOptions, "heightFunc", "")
		cHeightMapUrl = htmlGetOpt(aOptions, "heightMapUrl", "")
		lWireframe = htmlGetOpt(aOptions, "wireframe", false)
		lFlatShading = htmlGetOpt(aOptions, "flatShading", true)
		cMaterial = htmlGetOpt(aOptions, "material", "standard")
		cMetalness = htmlGetOpt(aOptions, "metalness", "0.1")
		cRoughness = htmlGetOpt(aOptions, "roughness", "0.9")
		cX = htmlGetOpt(aOptions, "x", "0")
		cY = htmlGetOpt(aOptions, "y", "0")
		cZ = htmlGetOpt(aOptions, "z", "0")
		lReceiveShadow = htmlGetOpt(aOptions, "receiveShadow", true)
		lVertexColors = htmlGetOpt(aOptions, "vertexColors", false)
		cColorLow = htmlGetOpt(aOptions, "colorLow", "0x2d5a1e")
		cColorHigh = htmlGetOpt(aOptions, "colorHigh", "0xffffff")


		cMatType = "MeshStandardMaterial"
		if cMaterial = "phong" cMatType = "MeshPhongMaterial" ok
		if cMaterial = "lambert" cMatType = "MeshLambertMaterial" ok

		if cHeightMapUrl != ""
			# Image-based heightmap
			cJS = "// Terrain from heightmap: " + cName + HTML_LF
			cJS += "(function() {" + HTML_LF
			cJS += "  var loader = new THREE.TextureLoader();" + HTML_LF
			cJS += "  loader.load(" + HTML_DQ + cHeightMapUrl + HTML_DQ + ", function(tex) {" + HTML_LF
			cJS += "    var canvas = document.createElement('canvas');" + HTML_LF
			cJS += "    canvas.width = tex.image.width;" + HTML_LF
			cJS += "    canvas.height = tex.image.height;" + HTML_LF
			cJS += "    var ctx = canvas.getContext('2d');" + HTML_LF
			cJS += "    ctx.drawImage(tex.image, 0, 0);" + HTML_LF
			cJS += "    var imgData = ctx.getImageData(0, 0, canvas.width, canvas.height);" + HTML_LF
			cJS += "    var geo = new THREE.PlaneGeometry(" + cWidth + ", " + cDepth + ", " + cWSeg + ", " + cDSeg + ");" + HTML_LF
			cJS += "    var pos = geo.attributes.position;" + HTML_LF
			cJS += "    for(var i = 0; i < pos.count; i++) {" + HTML_LF
			cJS += "      var u = (pos.getX(i) / " + cWidth + " + 0.5);" + HTML_LF
			cJS += "      var v = (pos.getY(i) / " + cDepth + " + 0.5);" + HTML_LF
			cJS += "      var px = Math.floor(u * (canvas.width-1));" + HTML_LF
			cJS += "      var py = Math.floor((1-v) * (canvas.height-1));" + HTML_LF
			cJS += "      var idx = (py * canvas.width + px) * 4;" + HTML_LF
			cJS += "      var h = imgData.data[idx] / 255 * " + cMaxHeight + ";" + HTML_LF
			cJS += "      pos.setZ(i, h);" + HTML_LF
			cJS += "    }" + HTML_LF
			cJS += "    geo.computeVertexNormals();" + HTML_LF
			cJS += "    var mat = new THREE." + cMatType + "({color: " + cColor
			if lWireframe cJS += ", wireframe: true" ok
			if lFlatShading cJS += ", flatShading: true" ok
			cJS += ", metalness: " + cMetalness + ", roughness: " + cRoughness + "});" + HTML_LF
			cJS += "    " + cName + " = new THREE.Mesh(geo, mat);" + HTML_LF
			cJS += "    " + cName + ".rotation.x = -Math.PI/2;" + HTML_LF
			cJS += "    " + cName + ".position.set(" + cX + ", " + cY + ", " + cZ + ");" + HTML_LF
			if lReceiveShadow cJS += "    " + cName + ".receiveShadow = true;" + HTML_LF ok
			cJS += "    scene_" + cCanvasId + ".add(" + cName + ");" + HTML_LF
			cJS += "  });" + HTML_LF
			cJS += "})();" + HTML_LF
			cJS = "var " + cName + " = null;" + HTML_LF + cJS
		else
			# Procedural heightmap
			if cHeightFunc = ""
				cHeightFunc = "Math.sin(x*0.5)*Math.cos(z*0.5)*" + cMaxHeight
			ok
			cJS = "// Procedural terrain: " + cName + HTML_LF
			cJS += "var " + cName + "_geo = new THREE.PlaneGeometry(" + cWidth + ", " + cDepth + ", " + cWSeg + ", " + cDSeg + ");" + HTML_LF
			cJS += "var " + cName + "_pos = " + cName + "_geo.attributes.position;" + HTML_LF

			if lVertexColors
				cJS += "var " + cName + "_colors = new Float32Array(" + cName + "_pos.count * 3);" + HTML_LF
				cJS += "var _cLow = new THREE.Color(" + cColorLow + ");" + HTML_LF
				cJS += "var _cHigh = new THREE.Color(" + cColorHigh + ");" + HTML_LF
			ok

			cJS += "for(var i = 0; i < " + cName + "_pos.count; i++) {" + HTML_LF
			cJS += "  var x = " + cName + "_pos.getX(i);" + HTML_LF
			cJS += "  var z = " + cName + "_pos.getY(i);" + HTML_LF
			cJS += "  var h = " + cHeightFunc + ";" + HTML_LF
			cJS += "  " + cName + "_pos.setZ(i, h);" + HTML_LF
			if lVertexColors
				cJS += "  var t = (h / " + cMaxHeight + " + 1) / 2;" + HTML_LF
				cJS += "  var _c = _cLow.clone().lerp(_cHigh, t);" + HTML_LF
				cJS += "  " + cName + "_colors[i*3] = _c.r;" + HTML_LF
				cJS += "  " + cName + "_colors[i*3+1] = _c.g;" + HTML_LF
				cJS += "  " + cName + "_colors[i*3+2] = _c.b;" + HTML_LF
			ok
			cJS += "}" + HTML_LF
			cJS += cName + "_geo.computeVertexNormals();" + HTML_LF

			if lVertexColors
				cJS += cName + "_geo.setAttribute('color', new THREE.BufferAttribute(" + cName + "_colors, 3));" + HTML_LF
			ok

			cJS += "var " + cName + "_mat = new THREE." + cMatType + "({color: " + cColor
			if lWireframe cJS += ", wireframe: true" ok
			if lFlatShading cJS += ", flatShading: true" ok
			if lVertexColors cJS += ", vertexColors: true" ok
			cJS += ", metalness: " + cMetalness + ", roughness: " + cRoughness + "});" + HTML_LF
			cJS += "var " + cName + " = new THREE.Mesh(" + cName + "_geo, " + cName + "_mat);" + HTML_LF
			cJS += cName + ".rotation.x = -Math.PI/2;" + HTML_LF
			cJS += cName + ".position.set(" + cX + ", " + cY + ", " + cZ + ");" + HTML_LF
			if lReceiveShadow cJS += cName + ".receiveShadow = true;" + HTML_LF ok
			cJS += "scene_" + cCanvasId + ".add(" + cName + ");" + HTML_LF
		ok

		addBodyScript(cJS)
		return self

	# Get height at a world position on a terrain (returns JS expression)
	# Useful for placing objects or characters on terrain
	func threeJSTerrainHeight cName, cJSX, cJSZ
		return "(function(){var _rc=new THREE.Raycaster(new THREE.Vector3(" + cJSX + ",100," + cJSZ + "),new THREE.Vector3(0,-1,0));var _h=_rc.intersectObject(" + cName + ");return _h.length>0?_h[0].point.y:0;})()"

	# ============================================================
	# 17. CSS2D LABELS (HTML tracking 3D objects)
	# ============================================================

	# Enable CSS2DRenderer
	func enableCSS2DRenderer
		lCSS2DRenderer = true
		return self

	# Initialize CSS2D rendering layer for a scene
	# Must be called AFTER threeJSScene and BEFORE threeJSAnimate
	func threeJSCSS2DInit cCanvasId
		cJS = "// CSS2D Label Renderer" + HTML_LF
		cJS += "var labelRenderer_" + cCanvasId + " = new THREE.CSS2DRenderer();" + HTML_LF
		cJS += "labelRenderer_" + cCanvasId + ".setSize(window.innerWidth, window.innerHeight);" + HTML_LF
		cJS += "labelRenderer_" + cCanvasId + ".domElement.style.position = 'fixed';" + HTML_LF
		cJS += "labelRenderer_" + cCanvasId + ".domElement.style.top = '0';" + HTML_LF
		cJS += "labelRenderer_" + cCanvasId + ".domElement.style.left = '0';" + HTML_LF
		cJS += "labelRenderer_" + cCanvasId + ".domElement.style.pointerEvents = 'none';" + HTML_LF
		cJS += "labelRenderer_" + cCanvasId + ".domElement.style.zIndex = '1';" + HTML_LF
		cJS += "document.body.appendChild(labelRenderer_" + cCanvasId + ".domElement);" + HTML_LF

		# Resize handler
		cJS += "window.addEventListener('resize', function() {" + HTML_LF
		cJS += "  labelRenderer_" + cCanvasId + ".setSize(window.innerWidth, window.innerHeight);" + HTML_LF
		cJS += "});" + HTML_LF

		# Add to animation loop
		cJS += "animCallbacks_" + cCanvasId + ".push(function() {" + HTML_LF
		cJS += "  labelRenderer_" + cCanvasId + ".render(scene_" + cCanvasId + ", camera_" + cCanvasId + ");" + HTML_LF
		cJS += "});" + HTML_LF

		addBodyScript(cJS)
		return self

	# Attach an HTML label to a 3D object
	# html: HTML content for the label
	# Options: offsetY (vertical offset), className (CSS class),
	#          background, color, fontSize, padding, borderRadius,
	#          border, opacity, pointerEvents, visible
	func threeJSCSS2DLabel cCanvasId, cName, cMeshName, cHTMLContent, aOptions
		cOffsetY = htmlGetOpt(aOptions, "offsetY", "1.5")
		cClassName = htmlGetOpt(aOptions, "className", "")
		cBackground = htmlGetOpt(aOptions, "background", "rgba(0,0,0,0.7)")
		cColor = htmlGetOpt(aOptions, "color", "#ffffff")
		cFontSize = htmlGetOpt(aOptions, "fontSize", "12px")
		cPadding = htmlGetOpt(aOptions, "padding", "4px 8px")
		cBorderRadius = htmlGetOpt(aOptions, "borderRadius", "4px")
		cBorder = htmlGetOpt(aOptions, "border", "")
		cOpacity = htmlGetOpt(aOptions, "opacity", "")
		lPointerEvents = htmlGetOpt(aOptions, "pointerEvents", false)
		lVisible = htmlGetOpt(aOptions, "visible", true)


		cJS = "// CSS2D Label: " + cName + HTML_LF
		cJS += "var " + cName + "_div = document.createElement('div');" + HTML_LF
		if cClassName != ""
			cJS += cName + "_div.className = " + HTML_DQ + cClassName + HTML_DQ + ";" + HTML_LF
		ok
		cJS += cName + "_div.innerHTML = " + HTML_DQ + cHTMLContent + HTML_DQ + ";" + HTML_LF
		cJS += cName + "_div.style.background = " + HTML_DQ + cBackground + HTML_DQ + ";" + HTML_LF
		cJS += cName + "_div.style.color = " + HTML_DQ + cColor + HTML_DQ + ";" + HTML_LF
		cJS += cName + "_div.style.fontSize = " + HTML_DQ + cFontSize + HTML_DQ + ";" + HTML_LF
		cJS += cName + "_div.style.padding = " + HTML_DQ + cPadding + HTML_DQ + ";" + HTML_LF
		cJS += cName + "_div.style.borderRadius = " + HTML_DQ + cBorderRadius + HTML_DQ + ";" + HTML_LF
		cJS += cName + "_div.style.fontFamily = " + HTML_DQ + "Arial, sans-serif" + HTML_DQ + ";" + HTML_LF
		cJS += cName + "_div.style.whiteSpace = " + HTML_DQ + "nowrap" + HTML_DQ + ";" + HTML_LF
		if cBorder != ""
			cJS += cName + "_div.style.border = " + HTML_DQ + cBorder + HTML_DQ + ";" + HTML_LF
		ok
		if cOpacity != ""
			cJS += cName + "_div.style.opacity = " + HTML_DQ + cOpacity + HTML_DQ + ";" + HTML_LF
		ok
		if lPointerEvents
			cJS += cName + "_div.style.pointerEvents = " + HTML_DQ + "auto" + HTML_DQ + ";" + HTML_LF
		ok

		cJS += "var " + cName + " = new THREE.CSS2DObject(" + cName + "_div);" + HTML_LF
		cJS += cName + ".position.set(0, " + cOffsetY + ", 0);" + HTML_LF
		if !lVisible
			cJS += cName + ".visible = false;" + HTML_LF
		ok
		cJS += cMeshName + ".add(" + cName + ");" + HTML_LF

		addBodyScript(cJS)
		return self

	# Update label content dynamically (returns JS code)
	func threeJSCSS2DUpdate cName, cJSContent
		return cName + "_div.innerHTML = " + cJSContent + ";"

	# Toggle label visibility (returns JS code)
	func threeJSCSS2DToggle cName
		return cName + ".visible = !" + cName + ".visible;"

	# Create a health/progress bar label
	# Options: width, height, barColor, bgColor, value (0-100), label text
	func threeJSCSS2DBar cCanvasId, cName, cMeshName, aOptions
		cWidth = htmlGetOpt(aOptions, "width", "60")
		cHeight = htmlGetOpt(aOptions, "height", "8")
		cBarColor = htmlGetOpt(aOptions, "barColor", "#2ecc71")
		cBGColor = htmlGetOpt(aOptions, "bgColor", "rgba(0,0,0,0.5)")
		cValue = htmlGetOpt(aOptions, "value", "100")
		cLabelText = htmlGetOpt(aOptions, "label", "")
		cOffsetY = htmlGetOpt(aOptions, "offsetY", "1.5")
		cFontSize = htmlGetOpt(aOptions, "fontSize", "9px")


		cBarHtml = ""
		if cLabelText != ""
			cBarHtml += "<div style=" + HTML_SQ + "text-align:center;font-size:" + cFontSize + ";margin-bottom:2px;color:#fff" + HTML_SQ + ">" + cLabelText + "</div>"
		ok
		cBarHtml += "<div style=" + HTML_SQ + "width:" + cWidth + "px;height:" + cHeight + "px;background:" + cBGColor + ";border-radius:3px;overflow:hidden" + HTML_SQ + ">"
		cBarHtml += "<div id=" + HTML_SQ + cName + "_fill" + HTML_SQ + " style=" + HTML_SQ + "width:" + cValue + "%;height:100%;background:" + cBarColor + ";transition:width 0.3s" + HTML_SQ + "></div>"
		cBarHtml += "</div>"

		threeJSCSS2DLabel(cCanvasId, cName, cMeshName, cBarHtml, [:offsetY = cOffsetY, :background = "transparent", :padding = "0", :borderRadius = "0"])

		return self

	# Update bar value (returns JS code)
	func threeJSCSS2DBarUpdate cName, cJSValue
		return "document.getElementById(" + HTML_DQ + cName + "_fill" + HTML_DQ + ").style.width = (" + cJSValue + ") + " + HTML_DQ + "%" + HTML_DQ + ";"

	# ============================================================
	# 18. EXTRUDE & LATHE GEOMETRY
	# ============================================================

	# Create an extruded shape from 2D points
	# points: list of [x, y] coordinate pairs defining the shape outline
	# Options: depth, bevelEnabled, bevelThickness, bevelSize, bevelSegments,
	#          steps, color, x, y, z, rx, ry, rz + standard mesh options
	func threeJSExtrude cCanvasId, cName, aPoints, aOptions
		cDepth = htmlGetOpt(aOptions, "depth", "1")
		lBevelEnabled = htmlGetOpt(aOptions, "bevelEnabled", true)
		cBevelThickness = htmlGetOpt(aOptions, "bevelThickness", "0.1")
		cBevelSize = htmlGetOpt(aOptions, "bevelSize", "0.05")
		cBevelSegments = htmlGetOpt(aOptions, "bevelSegments", "3")
		cSteps = htmlGetOpt(aOptions, "steps", "1")
		cColor = htmlGetOpt(aOptions, "color", "0x00ff00")
		cX = htmlGetOpt(aOptions, "x", "0")
		cY = htmlGetOpt(aOptions, "y", "0")
		cZ = htmlGetOpt(aOptions, "z", "0")
		cRX = htmlGetOpt(aOptions, "rx", "")
		cRY = htmlGetOpt(aOptions, "ry", "")
		cRZ = htmlGetOpt(aOptions, "rz", "")
		cMaterial = htmlGetOpt(aOptions, "material", "standard")
		cMetalness = htmlGetOpt(aOptions, "metalness", "")
		cRoughness = htmlGetOpt(aOptions, "roughness", "")
		lWireframe = htmlGetOpt(aOptions, "wireframe", false)
		lCastShadow = htmlGetOpt(aOptions, "castShadow", true)
		lFlatShading = htmlGetOpt(aOptions, "flatShading", false)
		cOpacity = htmlGetOpt(aOptions, "opacity", "")
		lTransparent = htmlGetOpt(aOptions, "transparent", false)


		cMatType = "MeshStandardMaterial"
		if cMaterial = "basic" cMatType = "MeshBasicMaterial" ok
		if cMaterial = "phong" cMatType = "MeshPhongMaterial" ok

		# Build shape from points
		cJS = "// Extruded shape: " + cName + HTML_LF
		cJS += "var " + cName + "_shape = new THREE.Shape();" + HTML_LF
		nPointLen = len(aPoints)
		if nPointLen > 0
			cJS += cName + "_shape.moveTo(" + aPoints[1][1] + ", " + aPoints[1][2] + ");" + HTML_LF
			for nPoint = 2 to nPointLen
				cJS += cName + "_shape.lineTo(" + aPoints[nPoint][1] + ", " + aPoints[nPoint][2] + ");" + HTML_LF
			next
		ok

		cJS += "var " + cName + "_settings = {" + HTML_LF
		cJS += "  depth: " + cDepth + "," + HTML_LF
		cJS += "  steps: " + cSteps + "," + HTML_LF
		if lBevelEnabled
			cJS += "  bevelEnabled: true," + HTML_LF
			cJS += "  bevelThickness: " + cBevelThickness + "," + HTML_LF
			cJS += "  bevelSize: " + cBevelSize + "," + HTML_LF
			cJS += "  bevelSegments: " + cBevelSegments + HTML_LF
		else
			cJS += "  bevelEnabled: false" + HTML_LF
		ok
		cJS += "};" + HTML_LF

		cJS += "var " + cName + "_geo = new THREE.ExtrudeGeometry(" + cName + "_shape, " + cName + "_settings);" + HTML_LF
		cJS += "var " + cName + "_mat = new THREE." + cMatType + "({color: " + cColor
		if lWireframe cJS += ", wireframe: true" ok
		if cMetalness != "" cJS += ", metalness: " + cMetalness ok
		if cRoughness != "" cJS += ", roughness: " + cRoughness ok
		if lFlatShading cJS += ", flatShading: true" ok
		if lTransparent cJS += ", transparent: true" ok
		if cOpacity != "" cJS += ", opacity: " + cOpacity ok
		cJS += "});" + HTML_LF
		cJS += "var " + cName + " = new THREE.Mesh(" + cName + "_geo, " + cName + "_mat);" + HTML_LF
		cJS += cName + ".position.set(" + cX + ", " + cY + ", " + cZ + ");" + HTML_LF
		if cRX != "" cJS += cName + ".rotation.x = " + cRX + ";" + HTML_LF ok
		if cRY != "" cJS += cName + ".rotation.y = " + cRY + ";" + HTML_LF ok
		if cRZ != "" cJS += cName + ".rotation.z = " + cRZ + ";" + HTML_LF ok
		if lCastShadow cJS += cName + ".castShadow = true;" + HTML_LF ok
		cJS += "scene_" + cCanvasId + ".add(" + cName + ");" + HTML_LF

		addBodyScript(cJS)
		return self

	# Create a lathe (revolution) geometry from a profile curve
	# profile: list of [x, y] points (x=radius, y=height) defining the profile to revolve
	# Options: segments (revolution steps), phiStart, phiLength (arc in radians),
	#          color, x, y, z + standard mesh options
	func threeJSLathe cCanvasId, cName, aProfile, aOptions
		cSegments = htmlGetOpt(aOptions, "segments", "32")
		cPhiStart = htmlGetOpt(aOptions, "phiStart", "0")
		cPhiLength = htmlGetOpt(aOptions, "phiLength", "6.2832")
		cColor = htmlGetOpt(aOptions, "color", "0x00ff00")
		cX = htmlGetOpt(aOptions, "x", "0")
		cY = htmlGetOpt(aOptions, "y", "0")
		cZ = htmlGetOpt(aOptions, "z", "0")
		cRX = htmlGetOpt(aOptions, "rx", "")
		cRY = htmlGetOpt(aOptions, "ry", "")
		cRZ = htmlGetOpt(aOptions, "rz", "")
		cMaterial = htmlGetOpt(aOptions, "material", "standard")
		cMetalness = htmlGetOpt(aOptions, "metalness", "")
		cRoughness = htmlGetOpt(aOptions, "roughness", "")
		lWireframe = htmlGetOpt(aOptions, "wireframe", false)
		lCastShadow = htmlGetOpt(aOptions, "castShadow", true)
		cOpacity = htmlGetOpt(aOptions, "opacity", "")
		lTransparent = htmlGetOpt(aOptions, "transparent", false)


		cMatType = "MeshStandardMaterial"
		if cMaterial = "basic" cMatType = "MeshBasicMaterial" ok
		if cMaterial = "phong" cMatType = "MeshPhongMaterial" ok

		# Build profile points
		cJS = "// Lathe geometry: " + cName + HTML_LF
		cJS += "var " + cName + "_pts = [" + HTML_LF
		nProfileLen = len(aProfile)
		for nProfile = 1 to nProfileLen
			cJS += "  new THREE.Vector2(" + aProfile[nProfile][1] + ", " + aProfile[nProfile][2] + ")"
			if nProfile < nProfileLen cJS += "," ok
			cJS += HTML_LF
		next
		cJS += "];" + HTML_LF

		cJS += "var " + cName + "_geo = new THREE.LatheGeometry(" + cName + "_pts, " + cSegments + ", " + cPhiStart + ", " + cPhiLength + ");" + HTML_LF
		cJS += "var " + cName + "_mat = new THREE." + cMatType + "({color: " + cColor
		if lWireframe cJS += ", wireframe: true" ok
		if cMetalness != "" cJS += ", metalness: " + cMetalness ok
		if cRoughness != "" cJS += ", roughness: " + cRoughness ok
		if lTransparent cJS += ", transparent: true" ok
		if cOpacity != "" cJS += ", opacity: " + cOpacity ok
		cJS += ", side: THREE.DoubleSide});" + HTML_LF
		cJS += "var " + cName + " = new THREE.Mesh(" + cName + "_geo, " + cName + "_mat);" + HTML_LF
		cJS += cName + ".position.set(" + cX + ", " + cY + ", " + cZ + ");" + HTML_LF
		if cRX != "" cJS += cName + ".rotation.x = " + cRX + ";" + HTML_LF ok
		if cRY != "" cJS += cName + ".rotation.y = " + cRY + ";" + HTML_LF ok
		if cRZ != "" cJS += cName + ".rotation.z = " + cRZ + ";" + HTML_LF ok
		if lCastShadow cJS += cName + ".castShadow = true;" + HTML_LF ok
		cJS += "scene_" + cCanvasId + ".add(" + cName + ");" + HTML_LF

		addBodyScript(cJS)
		return self

	# Extrude a shape along a 3D path (sweep)
	# points: 2D shape outline, path: list of [x,y,z] 3D path points
	# Options: steps, closed, color + standard mesh options
	func threeJSExtrudeAlongPath cCanvasId, cName, aPoints, aPath, aOptions
		cSteps = htmlGetOpt(aOptions, "steps", "100")
		lClosed = htmlGetOpt(aOptions, "closed", false)
		cColor = htmlGetOpt(aOptions, "color", "0x00ff00")
		cX = htmlGetOpt(aOptions, "x", "0")
		cY = htmlGetOpt(aOptions, "y", "0")
		cZ = htmlGetOpt(aOptions, "z", "0")
		cMaterial = htmlGetOpt(aOptions, "material", "standard")
		cMetalness = htmlGetOpt(aOptions, "metalness", "")
		cRoughness = htmlGetOpt(aOptions, "roughness", "")
		lCastShadow = htmlGetOpt(aOptions, "castShadow", true)


		cMatType = "MeshStandardMaterial"
		if cMaterial = "basic" cMatType = "MeshBasicMaterial" ok
		if cMaterial = "phong" cMatType = "MeshPhongMaterial" ok

		# Build shape
		cJS = "// Extrude along path: " + cName + HTML_LF
		cJS += "var " + cName + "_shape = new THREE.Shape();" + HTML_LF
		nPointLen = len(aPoints)
		if nPointLen > 0
			cJS += cName + "_shape.moveTo(" + aPoints[1][1] + ", " + aPoints[1][2] + ");" + HTML_LF
			for nPoint = 2 to nPointLen
				cJS += cName + "_shape.lineTo(" + aPoints[nPoint][1] + ", " + aPoints[nPoint][2] + ");" + HTML_LF
			next
		ok

		# Build 3D path
		cJS += "var " + cName + "_pathPts = [" + HTML_LF
		nPathLen = len(aPath)
		for nPoint = 1 to nPathLen
			cJS += "  new THREE.Vector3(" + aPath[nPoint][1] + ", " + aPath[nPoint][2] + ", " + aPath[nPoint][3] + ")"
			if nPoint < nPathLen cJS += "," ok
			cJS += HTML_LF
		next
		cJS += "];" + HTML_LF
		cJS += "var " + cName + "_curve = new THREE.CatmullRomCurve3(" + cName + "_pathPts"
		if lClosed cJS += ", true" ok
		cJS += ");" + HTML_LF

		cJS += "var " + cName + "_geo = new THREE.ExtrudeGeometry(" + cName + "_shape, {" + HTML_LF
		cJS += "  steps: " + cSteps + "," + HTML_LF
		cJS += "  bevelEnabled: false," + HTML_LF
		cJS += "  extrudePath: " + cName + "_curve" + HTML_LF
		cJS += "});" + HTML_LF

		cJS += "var " + cName + "_mat = new THREE." + cMatType + "({color: " + cColor
		if cMetalness != "" cJS += ", metalness: " + cMetalness ok
		if cRoughness != "" cJS += ", roughness: " + cRoughness ok
		cJS += "});" + HTML_LF
		cJS += "var " + cName + " = new THREE.Mesh(" + cName + "_geo, " + cName + "_mat);" + HTML_LF
		cJS += cName + ".position.set(" + cX + ", " + cY + ", " + cZ + ");" + HTML_LF
		if lCastShadow cJS += cName + ".castShadow = true;" + HTML_LF ok
		cJS += "scene_" + cCanvasId + ".add(" + cName + ");" + HTML_LF

		addBodyScript(cJS)
		return self

	# ============================================================
	# 19. OUTLINE / SELECTION EFFECT
	# ============================================================

	# Enable OutlinePass
	func enableOutlinePass
		lOutlinePass = true
		return self

	# Initialize outline post-processing for a scene
	# Options: edgeStrength, edgeGlow, edgeThickness, 
	#          visibleColor, hiddenColor, pulsePeriod
	func threeJSOutlineInit cCanvasId, aOptions
		cEdgeStrength = htmlGetOpt(aOptions, "edgeStrength", "3")
		cEdgeGlow = htmlGetOpt(aOptions, "edgeGlow", "0.5")
		cEdgeThickness = htmlGetOpt(aOptions, "edgeThickness", "1")
		cVisibleColor = htmlGetOpt(aOptions, "visibleColor", "0xffffff")
		cHiddenColor = htmlGetOpt(aOptions, "hiddenColor", "0x000000")
		cPulsePeriod = htmlGetOpt(aOptions, "pulsePeriod", "0")

		cJS = "// Outline Effect" + HTML_LF
		cJS += "var _skipRender_" + cCanvasId + " = true;" + HTML_LF
		cJS += "var outlineComposer_" + cCanvasId + " = new THREE.EffectComposer(renderer_" + cCanvasId + ");" + HTML_LF
		cJS += "var outlineRenderPass_" + cCanvasId + " = new THREE.RenderPass(scene_" + cCanvasId + ", camera_" + cCanvasId + ");" + HTML_LF
		cJS += "outlineComposer_" + cCanvasId + ".addPass(outlineRenderPass_" + cCanvasId + ");" + HTML_LF

		cJS += "var outlinePass_" + cCanvasId + " = new THREE.OutlinePass(" + HTML_LF
		cJS += "  new THREE.Vector2(renderer_" + cCanvasId + ".domElement.clientWidth, renderer_" + cCanvasId + ".domElement.clientHeight)," + HTML_LF
		cJS += "  scene_" + cCanvasId + ", camera_" + cCanvasId + HTML_LF
		cJS += ");" + HTML_LF
		cJS += "outlinePass_" + cCanvasId + ".edgeStrength = " + cEdgeStrength + ";" + HTML_LF
		cJS += "outlinePass_" + cCanvasId + ".edgeGlow = " + cEdgeGlow + ";" + HTML_LF
		cJS += "outlinePass_" + cCanvasId + ".edgeThickness = " + cEdgeThickness + ";" + HTML_LF
		cJS += "outlinePass_" + cCanvasId + ".visibleEdgeColor.set(" + cVisibleColor + ");" + HTML_LF
		cJS += "outlinePass_" + cCanvasId + ".hiddenEdgeColor.set(" + cHiddenColor + ");" + HTML_LF
		if cPulsePeriod != "0"
			cJS += "outlinePass_" + cCanvasId + ".pulsePeriod = " + cPulsePeriod + ";" + HTML_LF
		ok
		cJS += "outlineComposer_" + cCanvasId + ".addPass(outlinePass_" + cCanvasId + ");" + HTML_LF

		# Replace standard render with composer render
		cJS += "animCallbacks_" + cCanvasId + ".push(function() {" + HTML_LF
		cJS += "  outlineComposer_" + cCanvasId + ".render();" + HTML_LF
		cJS += "});" + HTML_LF

		# Resize handler
		cJS += "window.addEventListener('resize', function() {" + HTML_LF
		cJS += "  outlineComposer_" + cCanvasId + ".setSize(renderer_" + cCanvasId + ".domElement.clientWidth, renderer_" + cCanvasId + ".domElement.clientHeight);" + HTML_LF
		cJS += "});" + HTML_LF

		addBodyScript(cJS)
		return self

	# Set which objects have the outline effect
	# meshNames: list of mesh variable names
	func threeJSOutlineObjects cCanvasId, aMeshNames
		cJS = "outlinePass_" + cCanvasId + ".selectedObjects = ["
		nMeshNameLen = len(aMeshNames)
		for nMeshName = 1 to nMeshNameLen
			if nMeshName > 1 cJS += ", " ok
			cJS += aMeshNames[nMeshName]
		next
		cJS += "];" + HTML_LF
		addBodyScript(cJS)
		return self

	# Outline on hover: automatically outline whatever mesh the mouse is over
	# meshes: list of mesh variable names that can be hovered
	# Options: visibleColor, edgeStrength
	func threeJSOutlineOnHover cCanvasId, aMeshes, aOptions
		cVisibleColor = htmlGetOpt(aOptions, "visibleColor", "")
		cEdgeStrength = htmlGetOpt(aOptions, "edgeStrength", "")


		cJS = "// Outline on hover" + HTML_LF
		cJS += "var _outlineHoverMeshes_" + cCanvasId + " = ["
		nMeshLen = len(aMeshes)
		for nMesh = 1 to nMeshLen
			if nMesh > 1 cJS += ", " ok
			cJS += aMeshes[nMesh]
		next
		cJS += "];" + HTML_LF

		cJS += "var _outlineRaycaster_" + cCanvasId + " = new THREE.Raycaster();" + HTML_LF
		cJS += "var _outlineMouse_" + cCanvasId + " = new THREE.Vector2();" + HTML_LF

		cJS += "renderer_" + cCanvasId + ".domElement.addEventListener('mousemove', function(e) {" + HTML_LF
		cJS += "  var rect = renderer_" + cCanvasId + ".domElement.getBoundingClientRect();" + HTML_LF
		cJS += "  _outlineMouse_" + cCanvasId + ".x = ((e.clientX - rect.left) / rect.width) * 2 - 1;" + HTML_LF
		cJS += "  _outlineMouse_" + cCanvasId + ".y = -((e.clientY - rect.top) / rect.height) * 2 + 1;" + HTML_LF
		cJS += "  _outlineRaycaster_" + cCanvasId + ".setFromCamera(_outlineMouse_" + cCanvasId + ", camera_" + cCanvasId + ");" + HTML_LF
		cJS += "  var hits = _outlineRaycaster_" + cCanvasId + ".intersectObjects(_outlineHoverMeshes_" + cCanvasId + ");" + HTML_LF
		cJS += "  if(hits.length > 0) {" + HTML_LF
		cJS += "    outlinePass_" + cCanvasId + ".selectedObjects = [hits[0].object];" + HTML_LF
		cJS += "    renderer_" + cCanvasId + ".domElement.style.cursor = 'pointer';" + HTML_LF
		cJS += "  } else {" + HTML_LF
		cJS += "    outlinePass_" + cCanvasId + ".selectedObjects = [];" + HTML_LF
		cJS += "    renderer_" + cCanvasId + ".domElement.style.cursor = 'default';" + HTML_LF
		cJS += "  }" + HTML_LF
		cJS += "});" + HTML_LF

		addBodyScript(cJS)
		return self

	# Outline on click: outline clicked object, deselect on background click
	func threeJSOutlineOnClick cCanvasId, aMeshes, aOptions
		cJSOnSelect = htmlGetOpt(aOptions, "onSelect", "")
		cJSOnDeselect = htmlGetOpt(aOptions, "onDeselect", "")


		cJS = "// Outline on click" + HTML_LF
		cJS += "var _outlineClickMeshes_" + cCanvasId + " = ["
		nMeshLen = len(aMeshes)
		for nMesh = 1 to nMeshLen
			if nMesh > 1 cJS += ", " ok
			cJS += aMeshes[nMesh]
		next
		cJS += "];" + HTML_LF

		cJS += "var _outlineClickRC_" + cCanvasId + " = new THREE.Raycaster();" + HTML_LF
		cJS += "var _outlineClickM_" + cCanvasId + " = new THREE.Vector2();" + HTML_LF
		cJS += "var selectedMesh_" + cCanvasId + " = null;" + HTML_LF

		cJS += "renderer_" + cCanvasId + ".domElement.addEventListener('click', function(e) {" + HTML_LF
		cJS += "  var rect = renderer_" + cCanvasId + ".domElement.getBoundingClientRect();" + HTML_LF
		cJS += "  _outlineClickM_" + cCanvasId + ".x = ((e.clientX - rect.left) / rect.width) * 2 - 1;" + HTML_LF
		cJS += "  _outlineClickM_" + cCanvasId + ".y = -((e.clientY - rect.top) / rect.height) * 2 + 1;" + HTML_LF
		cJS += "  _outlineClickRC_" + cCanvasId + ".setFromCamera(_outlineClickM_" + cCanvasId + ", camera_" + cCanvasId + ");" + HTML_LF
		cJS += "  var hits = _outlineClickRC_" + cCanvasId + ".intersectObjects(_outlineClickMeshes_" + cCanvasId + ");" + HTML_LF
		cJS += "  if(hits.length > 0) {" + HTML_LF
		cJS += "    selectedMesh_" + cCanvasId + " = hits[0].object;" + HTML_LF
		cJS += "    outlinePass_" + cCanvasId + ".selectedObjects = [selectedMesh_" + cCanvasId + "];" + HTML_LF
		if cJSOnSelect != ""
			cJS += "    " + cJSOnSelect + HTML_LF
		ok
		cJS += "  } else {" + HTML_LF
		cJS += "    selectedMesh_" + cCanvasId + " = null;" + HTML_LF
		cJS += "    outlinePass_" + cCanvasId + ".selectedObjects = [];" + HTML_LF
		if cJSOnDeselect != ""
			cJS += "    " + cJSOnDeselect + HTML_LF
		ok
		cJS += "  }" + HTML_LF
		cJS += "});" + HTML_LF

		addBodyScript(cJS)
		return self

	# ============================================================
	# 20. LOD (Level of Detail)
	# ============================================================

	# Create a LOD object that swaps meshes based on camera distance
	# levels: list of lists, each: [geometryExpr, maxDistance]
	#   e.g. [["SphereGeometry(1,32,32)", "10"], ["SphereGeometry(1,8,8)", "30"], ["SphereGeometry(1,4,4)", "100"]]
	# Options: color, x, y, z, material + standard mesh options
	func threeJSLOD cCanvasId, cName, aLevels, aOptions
		cColor = htmlGetOpt(aOptions, "color", "0x00ff00")
		cX = htmlGetOpt(aOptions, "x", "0")
		cY = htmlGetOpt(aOptions, "y", "0")
		cZ = htmlGetOpt(aOptions, "z", "0")
		cMaterial = htmlGetOpt(aOptions, "material", "standard")
		cMetalness = htmlGetOpt(aOptions, "metalness", "")
		cRoughness = htmlGetOpt(aOptions, "roughness", "")
		lWireframe = htmlGetOpt(aOptions, "wireframe", false)
		lCastShadow = htmlGetOpt(aOptions, "castShadow", true)


		cMatType = "MeshStandardMaterial"
		if cMaterial = "basic" cMatType = "MeshBasicMaterial" ok
		if cMaterial = "phong" cMatType = "MeshPhongMaterial" ok

		cJS = "// LOD: " + cName + HTML_LF
		cJS += "var " + cName + " = new THREE.LOD();" + HTML_LF

		# Shared material
		cJS += "var " + cName + "_mat = new THREE." + cMatType + "({color: " + cColor
		if lWireframe cJS += ", wireframe: true" ok
		if cMetalness != "" cJS += ", metalness: " + cMetalness ok
		if cRoughness != "" cJS += ", roughness: " + cRoughness ok
		cJS += "});" + HTML_LF

		nLevelLen = len(aLevels)
		for nLevel = 1 to nLevelLen
			cGeoExpr = aLevels[nLevel][1]
			cDist = aLevels[nLevel][2]
			cJS += "var " + cName + "_m" + string(nLevel) + " = new THREE.Mesh(new THREE." + cGeoExpr + ", " + cName + "_mat);" + HTML_LF
			if lCastShadow cJS += cName + "_m" + string(nLevel) + ".castShadow = true;" + HTML_LF ok
			cJS += cName + ".addLevel(" + cName + "_m" + string(nLevel) + ", " + cDist + ");" + HTML_LF
		next

		cJS += cName + ".position.set(" + cX + ", " + cY + ", " + cZ + ");" + HTML_LF
		cJS += "scene_" + cCanvasId + ".add(" + cName + ");" + HTML_LF

		# LOD needs to update in animation loop
		cJS += "animCallbacks_" + cCanvasId + ".push(function() {" + HTML_LF
		cJS += "  " + cName + ".update(camera_" + cCanvasId + ");" + HTML_LF
		cJS += "});" + HTML_LF

		addBodyScript(cJS)
		return self

	# Create LOD from predefined quality presets for common shapes
	# shape: "sphere", "box", "torus", "cylinder"
	# Options: radius/size, distances (list of 3 distances), + standard options
	func threeJSLODPreset cCanvasId, cName, cShape, aOptions
		cD1 = htmlGetOpt(aOptions, "near", "10")
		cD2 = htmlGetOpt(aOptions, "mid", "30")
		cD3 = htmlGetOpt(aOptions, "far", "80")
		cRadius = htmlGetOpt(aOptions, "radius", "1")
		cSize = htmlGetOpt(aOptions, "size", "1")

		aLevels = []

		if cShape = "sphere"
			add(aLevels, ["SphereGeometry(" + cRadius + ",32,32)", "0"])
			add(aLevels, ["SphereGeometry(" + cRadius + ",16,16)", cD1])
			add(aLevels, ["SphereGeometry(" + cRadius + ",8,8)", cD2])
			add(aLevels, ["SphereGeometry(" + cRadius + ",4,4)", cD3])
		but cShape = "box"
			add(aLevels, ["BoxGeometry(" + cSize + "," + cSize + "," + cSize + ")", "0"])
			add(aLevels, ["BoxGeometry(" + cSize + "," + cSize + "," + cSize + ")", cD3])
		but cShape = "torus"
			cTube = htmlGetOpt(aOptions, "tube", "0.3")
			add(aLevels, ["TorusGeometry(" + cRadius + "," + cTube + ",16,48)", "0"])
			add(aLevels, ["TorusGeometry(" + cRadius + "," + cTube + ",8,24)", cD1])
			add(aLevels, ["TorusGeometry(" + cRadius + "," + cTube + ",6,12)", cD2])
			add(aLevels, ["TorusGeometry(" + cRadius + "," + cTube + ",4,6)", cD3])
		but cShape = "cylinder"
			cH = htmlGetOpt(aOptions, "height", "2")
			add(aLevels, ["CylinderGeometry(" + cRadius + "," + cRadius + "," + cH + ",24)", "0"])
			add(aLevels, ["CylinderGeometry(" + cRadius + "," + cRadius + "," + cH + ",12)", cD1])
			add(aLevels, ["CylinderGeometry(" + cRadius + "," + cRadius + "," + cH + ",6)", cD2])
		ok

		return threeJSLOD(cCanvasId, cName, aLevels, aOptions)

	# ============================================================
	# 21. TEXTURE MAPPING
	# ============================================================

	# Load a texture and apply it to an existing mesh at runtime
	# mapType: "map", "normalMap", "bumpMap", "roughnessMap", "metalnessMap",
	#          "emissiveMap", "aoMap", "alphaMap", "displacementMap", "envMap"
	# Options: tileX, tileY, wrapS (repeat/clamp/mirror), wrapT, 
	#          offsetX, offsetY, rotation, flipY
	func threeJSTextureApply cMeshName, cMapType, cURL, aOptions
		cRepeatX = htmlGetOpt(aOptions, "tileX", "")
		cRepeatY = htmlGetOpt(aOptions, "tileY", "")
		cWrapS = htmlGetOpt(aOptions, "wrapS", "")
		cWrapT = htmlGetOpt(aOptions, "wrapT", "")
		cOffsetX = htmlGetOpt(aOptions, "offsetX", "")
		cOffsetY = htmlGetOpt(aOptions, "offsetY", "")
		cRotation = htmlGetOpt(aOptions, "rotation", "")
		cFlipY = htmlGetOpt(aOptions, "flipY", "")


		cJS = "// Apply texture to " + cMeshName + "." + cMapType + HTML_LF
		cJS += "(function(){" + HTML_LF
		cJS += "  new THREE.TextureLoader().load(" + HTML_DQ + cURL + HTML_DQ + ", function(tex){" + HTML_LF

		# Wrap mode
		if cRepeatX != "" or cRepeatY != "" or cWrapS = "repeat"
			cJS += "    tex.wrapS = THREE.RepeatWrapping;" + HTML_LF
			cJS += "    tex.wrapT = THREE.RepeatWrapping;" + HTML_LF
		ok
		if cWrapS = "mirror"
			cJS += "    tex.wrapS = THREE.MirroredRepeatWrapping;" + HTML_LF
		ok
		if cWrapT = "mirror"
			cJS += "    tex.wrapT = THREE.MirroredRepeatWrapping;" + HTML_LF
		ok
		if cWrapS = "clamp"
			cJS += "    tex.wrapS = THREE.ClampToEdgeWrapping;" + HTML_LF
		ok
		if cWrapT = "clamp"
			cJS += "    tex.wrapT = THREE.ClampToEdgeWrapping;" + HTML_LF
		ok

		if cRepeatX != "" or cRepeatY != ""
			cRX = cRepeatX
			cRY = cRepeatY
			if cRX = "" cRX = "1" ok
			if cRY = "" cRY = "1" ok
			cJS += "    tex.repeat.set(" + cRX + "," + cRY + ");" + HTML_LF
		ok
		if cOffsetX != "" or cOffsetY != ""
			cOffX = cOffsetX
			cOffY = cOffsetY
			if cOffX = "" cOffX = "0" ok
			if cOffY = "" cOffY = "0" ok
			cJS += "    tex.offset.set(" + cOffX + "," + cOffY + ");" + HTML_LF
		ok
		if cRotation != ""
			cJS += "    tex.rotation = " + cRotation + ";" + HTML_LF
		ok
		if cFlipY != ""
			cJS += "    tex.flipY = " + cFlipY + ";" + HTML_LF
		ok

		cJS += "    " + cMeshName + ".material." + cMapType + " = tex;" + HTML_LF
		cJS += "    " + cMeshName + ".material.needsUpdate = true;" + HTML_LF
		cJS += "  });" + HTML_LF
		cJS += "})();" + HTML_LF

		addBodyScript(cJS)
		return self

	# Load a CubeTexture (6-face skybox) and set as scene background or mesh envMap
	# faces: list of 6 image URLs [posX, negX, posY, negY, posZ, negZ]
	func threeJSCubeTexture cCanvasId, cName, aFaces, aOptions
		lAsBackground = htmlGetOpt(aOptions, "background", true)
		cAsMeshEnvMap = htmlGetOpt(aOptions, "meshEnvMap", "")


		cJS = "// CubeTexture: " + cName + HTML_LF
		cJS += "var " + cName + " = new THREE.CubeTextureLoader().load([" + HTML_LF
		for nFace = 1 to len(aFaces)
			cJS += "  " + HTML_DQ + aFaces[nFace] + HTML_DQ
			if nFace < len(aFaces) cJS += "," ok
			cJS += HTML_LF
		next
		cJS += "]);" + HTML_LF

		if lAsBackground
			cJS += "scene_" + cCanvasId + ".background = " + cName + ";" + HTML_LF
		ok
		if cAsMeshEnvMap != ""
			cJS += cAsMeshEnvMap + ".material.envMap = " + cName + ";" + HTML_LF
			cJS += cAsMeshEnvMap + ".material.needsUpdate = true;" + HTML_LF
		ok

		addBodyScript(cJS)
		return self

	# Apply a terrain texture with proper tiling to a terrain mesh
	# Convenience method for common use case
	func threeJSTerrainTexture cTerrainName, cURL, aOptions
		cRepeatX = htmlGetOpt(aOptions, "tileX", "10")
		cRepeatY = htmlGetOpt(aOptions, "tileY", "10")
		return threeJSTextureApply(cTerrainName, "map", cURL, [:tileX = cRepeatX, :tileY = cRepeatY])

	# ====================================================================
	# Bootstrap Framework Support
	# ====================================================================

	# Enable Bootstrap 5 (CDN)
	func enableBootstrap
		lBootstrap = true
		return self

	func enableBootstrapVersion cVer
		lBootstrap = true
		cBootstrapVersion = cVer
		return self

	func enableBootstrapIcons
		lBootstrapIcons = true
		return self

	func enableFontAwesome
		lFontAwesome = true
		return self

	func enableFontAwesomeVersion cVer
		lFontAwesome = true
		cFontAwesomeVersion = cVer
		return self

	func enableHighlightJS
		lHighlightJS = true
		return self

	func enableHighlightTheme cThemeName
		lHighlightJS = true
		cHighlightTheme = cThemeName
		return self

	# Bootstrap container
	func bsOpenContainer cType
		cCls = "container"
		if cType != "" cCls = "container-" + cType ok
		appendContent('<div class="' + cCls + '">')
		nIndentLevel++
		return self

	func bsCloseContainer
		nIndentLevel--
		appendContent("</div>")
		return self

	func bsOpenRow cExtraClass
		cCls = "row"
		if cExtraClass != "" cCls += " " + cExtraClass ok
		appendContent('<div class="' + cCls + '">')
		nIndentLevel++
		return self

	func bsCloseRow
		nIndentLevel--
		appendContent("</div>")
		return self

	func bsOpenCol cColClass
		appendContent('<div class="' + cColClass + '">')
		nIndentLevel++
		return self

	func bsCloseCol
		nIndentLevel--
		appendContent("</div>")
		return self

	# Bootstrap navbar with responsive toggle
	func bsNavbar cBrand, cBrandHref, aItems, cColorScheme
		cBGClass = "bg-" + cColorScheme
		cDataTheme = "dark"
		if cColorScheme = "light" cDataTheme = "light" ok
		cHTML = '<nav class="navbar navbar-expand-lg ' + cBGClass + '" data-bs-theme="' + cDataTheme + '">' + char(10)
		cHTML += '  <div class="container-fluid">' + char(10)
		cHTML += '    <a class="navbar-brand" href="' + cBrandHref + '">' + htmlEscape(cBrand) + '</a>' + char(10)
		cHTML += '    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navContent"><span class="navbar-toggler-icon"></span></button>' + char(10)
		cHTML += '    <div class="collapse navbar-collapse" id="navContent"><ul class="navbar-nav me-auto mb-2 mb-lg-0">' + char(10)
		nItemLen = len(aItems)
		for nItem = 1 to nItemLen
			cActive = ""
			if len(aItems[nItem]) >= 3
				if aItems[nItem][3] = true cActive = " active" ok
			ok
			cHTML += '      <li class="nav-item"><a class="nav-link' + cActive + '" href="' + aItems[nItem][2] + '">' + htmlEscape(aItems[nItem][1]) + '</a></li>' + char(10)
		next
		cHTML += '    </ul></div></div></nav>'
		appendContent(cHTML)
		return self

	# Bootstrap card
	func bsCard cTitleText, cBody, aOptions
		cCardClass = "card " + htmlGetOpt(aOptions, "class", "")
		cImgSrc = htmlGetOpt(aOptions, "image", "")
		cFooterText = htmlGetOpt(aOptions, "footer", "")
		cHeaderText = htmlGetOpt(aOptions, "header", "")
		cStyle = htmlGetOpt(aOptions, "style", "")
		cStyleAttr = ""
		if cStyle != "" cStyleAttr = ' style="' + cStyle + '"' ok
		cHTML = '<div class="' + cCardClass + '"' + cStyleAttr + '>' + char(10)
		if cHeaderText != ""
			cHTML += '  <div class="card-header">' + cHeaderText + '</div>' + char(10)
		ok
		if cImgSrc != ""
			cHTML += '  <img src="' + cImgSrc + '" class="card-img-top" alt="">' + char(10)
		ok
		cHTML += '  <div class="card-body">' + char(10)
		if cTitleText != ""
			cHTML += '    <h5 class="card-title">' + htmlEscape(cTitleText) + '</h5>' + char(10)
		ok
		cHTML += '    <p class="card-text">' + htmlEscape(cBody) + '</p>' + char(10)
		cHTML += '  </div>' + char(10)
		if cFooterText != ""
			cHTML += '  <div class="card-footer text-muted">' + cFooterText + '</div>' + char(10)
		ok
		cHTML += '</div>'
		appendContent(cHTML)
		return self

	func bsCardRaw cTitleText, cBodyHtml, aOptions
		cCardClass = "card " + htmlGetOpt(aOptions, "class", "")
		cImgSrc = htmlGetOpt(aOptions, "image", "")
		cFooterText = htmlGetOpt(aOptions, "footer", "")
		cHTML = '<div class="' + cCardClass + '">' + char(10)
		if cImgSrc != "" cHTML += '  <img src="' + cImgSrc + '" class="card-img-top" alt="">' + char(10) ok
		cHTML += '  <div class="card-body">' + char(10)
		if cTitleText != "" cHTML += '    <h5 class="card-title">' + htmlEscape(cTitleText) + '</h5>' + char(10) ok
		cHTML += '    ' + cBodyHtml + char(10) + '  </div>' + char(10)
		if cFooterText != "" cHTML += '  <div class="card-footer text-muted">' + cFooterText + '</div>' + char(10) ok
		cHTML += '</div>'
		appendContent(cHTML)
		return self

	func bsAlert cMessage, cType, lDismissible
		cCls = "alert alert-" + cType
		cBtn = ""
		if lDismissible
			cCls += " alert-dismissible fade show"
			cBtn = ' <button type="button" class="btn-close" data-bs-dismiss="alert"></button>'
		ok
		appendContent('<div class="' + cCls + '" role="alert">' + htmlEscape(cMessage) + cBtn + '</div>')
		return self

	func bsButton cText, cType, cSize
		cCls = "btn btn-" + cType
		if cSize != "" cCls += " btn-" + cSize ok
		appendContent('<button type="button" class="' + cCls + '">' + htmlEscape(cText) + '</button>')
		return self

	func bsLinkButton cText, cHref, cType, cSize
		cCls = "btn btn-" + cType
		if cSize != "" cCls += " btn-" + cSize ok
		appendContent('<a href="' + cHref + '" class="' + cCls + '">' + htmlEscape(cText) + '</a>')
		return self

	func bsOutlineButton cText, cType, cSize
		cCls = "btn btn-outline-" + cType
		if cSize != "" cCls += " btn-" + cSize ok
		appendContent('<button type="button" class="' + cCls + '">' + htmlEscape(cText) + '</button>')
		return self

	func bsBadge cText, cType
		appendContent('<span class="badge bg-' + cType + '">' + htmlEscape(cText) + '</span>')
		return self

	func bsTable aData, aOptions
		cCls = "table"
		if htmlGetOpt(aOptions, "striped", false) = true cCls += " table-striped" ok
		if htmlGetOpt(aOptions, "hover", false) = true cCls += " table-hover" ok
		if htmlGetOpt(aOptions, "bordered", false) = true cCls += " table-bordered" ok
		if htmlGetOpt(aOptions, "small", false) = true cCls += " table-sm" ok
		cVariant = htmlGetOpt(aOptions, "variant", "")
		if cVariant != "" cCls += " table-" + cVariant ok
		lResponsive = htmlGetOpt(aOptions, "responsive", false)
		cCaptionText = htmlGetOpt(aOptions, "caption", "")
		cHTML = ""
		if lResponsive = true cHTML += '<div class="table-responsive">' + char(10) ok
		cHTML += '<table class="' + cCls + '">' + char(10)
		if cCaptionText != "" cHTML += '  <caption>' + htmlEscape(cCaptionText) + '</caption>' + char(10) ok
		nDataLen = len(aData)
		for nRow = 1 to nDataLen
			aRow = aData[nRow]
			nColLen = len(aRow)
			if nRow = 1
				cHTML += '  <thead><tr>' + char(10)
				for nCol = 1 to nColLen
					cHTML += '    <th>' + htmlEscape("" + aRow[nCol]) + '</th>' + char(10)
				next
				cHTML += '  </tr></thead><tbody>' + char(10)
			else
				cHTML += '  <tr>' + char(10)
				for nCol = 1 to nColLen
					cHTML += '    <td>' + htmlEscape("" + aRow[nCol]) + '</td>' + char(10)
				next
				cHTML += '  </tr>' + char(10)
			ok
		next
		if nDataLen > 1 cHTML += '  </tbody>' + char(10) ok
		cHTML += '</table>'
		if lResponsive = true cHTML += char(10) + '</div>' ok
		appendContent(cHTML)
		return self

	func bsAccordion cID, aItems
		cHTML = '<div class="accordion" id="' + cID + '">' + char(10)
		nItemLen = len(aItems)
		for nItem = 1 to nItemLen
			cCollapseId = cID + "-c-" + nItem
			cExpanded = "false"  cShow = ""  cCollapsed = " collapsed"
			if nItem = 1 cExpanded = "true" cShow = " show" cCollapsed = "" ok
			cHTML += '  <div class="accordion-item"><h2 class="accordion-header">' + char(10)
			cHTML += '    <button class="accordion-button' + cCollapsed + '" type="button" data-bs-toggle="collapse" data-bs-target="#' + cCollapseId + '" aria-expanded="' + cExpanded + '">' + htmlEscape(aItems[nItem][1]) + '</button>' + char(10)
			cHTML += '  </h2><div id="' + cCollapseId + '" class="accordion-collapse collapse' + cShow + '" data-bs-parent="#' + cID + '">' + char(10)
			cHTML += '    <div class="accordion-body">' + htmlEscape(aItems[nItem][2]) + '</div></div></div>' + char(10)
		next
		cHTML += '</div>'
		appendContent(cHTML)
		return self

	func bsModal cID, cTitleText, cBodyHtml, aOptions
		cSize = htmlGetOpt(aOptions, "size", "")
		cSizeClass = ""
		if cSize != "" cSizeClass = " modal-" + cSize ok
		lCentered = htmlGetOpt(aOptions, "centered", false)
		cDialogClass = "modal-dialog" + cSizeClass
		if lCentered = true cDialogClass += " modal-dialog-centered" ok
		cFooterHtml = htmlGetOpt(aOptions, "footer", "")
		cHTML = '<div class="modal fade" id="' + cID + '" tabindex="-1"><div class="' + cDialogClass + '"><div class="modal-content">' + char(10)
		cHTML += '  <div class="modal-header"><h5 class="modal-title">' + htmlEscape(cTitleText) + '</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>' + char(10)
		cHTML += '  <div class="modal-body">' + cBodyHtml + '</div>' + char(10)
		if cFooterHtml != "" cHTML += '  <div class="modal-footer">' + cFooterHtml + '</div>' + char(10) ok
		cHTML += '</div></div></div>'
		appendContent(cHTML)
		return self

	func bsModalButton cText, cModalId, cType, cSize
		cCls = "btn btn-" + cType
		if cSize != "" cCls += " btn-" + cSize ok
		appendContent('<button type="button" class="' + cCls + '" data-bs-toggle="modal" data-bs-target="#' + cModalId + '">' + htmlEscape(cText) + '</button>')
		return self

	func bsProgress nPercent, cType, lStriped, lAnimated
		cCls = "progress-bar"
		if cType != "" cCls += " bg-" + cType ok
		if lStriped cCls += " progress-bar-striped" ok
		if lAnimated cCls += " progress-bar-animated" ok
		appendContent('<div class="progress" style="height:20px"><div class="' + cCls + '" style="width:' + nPercent + '%">' + nPercent + '%</div></div>')
		return self

	func bsSpinner cType, cVariant
		cCls = "spinner-" + cType
		if cVariant != "" cCls += " text-" + cVariant ok
		appendContent('<div class="' + cCls + '" role="status"><span class="visually-hidden">Loading...</span></div>')
		return self

	func bsBreadcrumb aItems
		cHTML = '<nav aria-label="breadcrumb"><ol class="breadcrumb">' + char(10)
		nItemLen = len(aItems)
		for nItem = 1 to nItemLen
			if nItem = nItemLen
				cHTML += '  <li class="breadcrumb-item active">' + htmlEscape(aItems[nItem][1]) + '</li>' + char(10)
			else
				cHTML += '  <li class="breadcrumb-item"><a href="' + aItems[nItem][2] + '">' + htmlEscape(aItems[nItem][1]) + '</a></li>' + char(10)
			ok
		next
		cHTML += '</ol></nav>'
		appendContent(cHTML)
		return self

	func bsPagination nCurrentPage, nTotalPages, cBaseURL
		cHTML = '<nav><ul class="pagination">' + char(10)
		if nCurrentPage > 1
			cHTML += '  <li class="page-item"><a class="page-link" href="' + cBaseURL + '?page=' + (nCurrentPage-1) + '">&laquo;</a></li>' + char(10)
		else
			cHTML += '  <li class="page-item disabled"><span class="page-link">&laquo;</span></li>' + char(10)
		ok
		for nPage = 1 to nTotalPages
			if nPage = nCurrentPage
				cHTML += '  <li class="page-item active"><span class="page-link">' + nPage + '</span></li>' + char(10)
			else
				cHTML += '  <li class="page-item"><a class="page-link" href="' + cBaseURL + '?page=' + nPage + '">' + nPage + '</a></li>' + char(10)
			ok
		next
		if nCurrentPage < nTotalPages
			cHTML += '  <li class="page-item"><a class="page-link" href="' + cBaseURL + '?page=' + (nCurrentPage+1) + '">&raquo;</a></li>' + char(10)
		else
			cHTML += '  <li class="page-item disabled"><span class="page-link">&raquo;</span></li>' + char(10)
		ok
		cHTML += '</ul></nav>'
		appendContent(cHTML)
		return self

	func bsListGroup aItems, aOptions
		lFlush = htmlGetOpt(aOptions, "flush", false)
		cCls = "list-group"
		if lFlush = true cCls += " list-group-flush" ok
		cHTML = '<ul class="' + cCls + '">' + char(10)
		nItemLen = len(aItems)
		for nItem = 1 to nItemLen
			cHTML += '  <li class="list-group-item">' + htmlEscape(aItems[nItem]) + '</li>' + char(10)
		next
		cHTML += '</ul>'
		appendContent(cHTML)
		return self

	func bsFormGroup cLabel, cType, cName, cPlaceholder
		cID = cName
		cHTML = '<div class="form-floating mb-3">' + char(10)
		cHTML += '  <input type="' + cType + '" class="form-control" id="' + cID + '" name="' + cName + '" placeholder="' + htmlEscape(cPlaceholder) + '">' + char(10)
		cHTML += '  <label for="' + cID + '">' + htmlEscape(cLabel) + '</label></div>'
		appendContent(cHTML)
		return self

	func bsFormSelect cLabel, cName, aSelectOptions
		cID = cName
		cHTML = '<div class="form-floating mb-3"><select class="form-select" id="' + cID + '" name="' + cName + '">' + char(10)
		nSelectOptionLen = len(aSelectOptions)
		for nSelectOption = 1 to nSelectOptionLen
			cHTML += '    <option value="' + htmlEscape(aSelectOptions[nSelectOption][1]) + '">' + htmlEscape(aSelectOptions[nSelectOption][2]) + '</option>' + char(10)
		next
		cHTML += '  </select><label for="' + cID + '">' + htmlEscape(cLabel) + '</label></div>'
		appendContent(cHTML)
		return self

	func bsFormTextarea cLabel, cName, nRows
		cID = cName
		cHTML = '<div class="form-floating mb-3">' + char(10)
		cHTML += '  <textarea class="form-control" id="' + cID + '" name="' + cName + '" style="height:' + (nRows*24) + 'px" placeholder="' + htmlEscape(cLabel) + '"></textarea>' + char(10)
		cHTML += '  <label for="' + cID + '">' + htmlEscape(cLabel) + '</label></div>'
		appendContent(cHTML)
		return self

	func bsCarousel cID, aSlides
		cHTML = '<div id="' + cID + '" class="carousel slide" data-bs-ride="carousel"><div class="carousel-indicators">' + char(10)
		nSlideLen = len(aSlides)
		for nSlide = 1 to nSlideLen
			cActive = "" if nSlide = 1 cActive = " active" ok
			cHTML += '  <button type="button" data-bs-target="#' + cID + '" data-bs-slide-to="' + (nSlide-1) + '" class="' + cActive + '"></button>' + char(10)
		next
		cHTML += '</div><div class="carousel-inner">' + char(10)
		for nSlide = 1 to nSlideLen
			cActive = "" if nSlide = 1 cActive = " active" ok
			cHTML += '  <div class="carousel-item' + cActive + '"><img src="' + aSlides[nSlide][1] + '" class="d-block w-100" alt="">' + char(10)
			if len(aSlides[nSlide]) >= 2
				cHTML += '    <div class="carousel-caption d-none d-md-block"><h5>' + htmlEscape(aSlides[nSlide][2]) + '</h5>' + char(10)
				if len(aSlides[nSlide]) >= 3 cHTML += '      <p>' + htmlEscape(aSlides[nSlide][3]) + '</p>' + char(10) ok
				cHTML += '    </div>' + char(10)
			ok
			cHTML += '  </div>' + char(10)
		next
		cHTML += '</div>' + char(10)
		cHTML += '<button class="carousel-control-prev" type="button" data-bs-target="#' + cID + '" data-bs-slide="prev"><span class="carousel-control-prev-icon"></span></button>' + char(10)
		cHTML += '<button class="carousel-control-next" type="button" data-bs-target="#' + cID + '" data-bs-slide="next"><span class="carousel-control-next-icon"></span></button></div>'
		appendContent(cHTML)
		return self

	func bsToast cTitleText, cMessage, cTime
		cHTML = '<div class="toast show" role="alert"><div class="toast-header"><strong class="me-auto">' + htmlEscape(cTitleText) + '</strong><small class="text-muted">' + htmlEscape(cTime) + '</small>'
		cHTML += '<button type="button" class="btn-close" data-bs-dismiss="toast"></button></div><div class="toast-body">' + htmlEscape(cMessage) + '</div></div>'
		appendContent(cHTML)
		return self

	# ====================================================================
	# Icon Support
	# ====================================================================

	func bsIcon cName
		appendContent('<i class="bi bi-' + cName + '"></i>')
		return self

	func faIcon cName, cStyle
		appendContent('<i class="' + cStyle + ' fa-' + cName + '"></i>')
		return self

	func bsIconText cIconName, cText
		appendContent('<i class="bi bi-' + cIconName + '"></i> ' + htmlEscape(cText))
		return self

	# ====================================================================
	# Built-in Theme System
	# ====================================================================

	func setTheme cThemeName
		cTheme = cThemeName
		if cThemeName = "professional"
			addCSSVariable("primary", "#2c3e50") addCSSVariable("secondary", "#34495e")
			addCSSVariable("accent", "#3498db") addCSSVariable("success", "#27ae60")
			addCSSVariable("warning", "#f39c12") addCSSVariable("danger", "#e74c3c")
			addCSSVariable("bg", "#ffffff") addCSSVariable("bg-alt", "#f8f9fa")
			addCSSVariable("text", "#2c3e50") addCSSVariable("text-muted", "#6c757d")
			addCSSVariable("border", "#dee2e6") addCSSVariable("radius", "6px")
			addCSSVariable("shadow", "0 2px 8px rgba(0,0,0,0.08)")
			addCSSVariable("font-body", "'Segoe UI', Roboto, 'Helvetica Neue', sans-serif")
			addCSSVariable("font-heading", "'Segoe UI', Roboto, sans-serif")
			applyBaseThemeCSS()
		but cThemeName = "elegant"
			addCSSVariable("primary", "#1a1a2e") addCSSVariable("secondary", "#16213e")
			addCSSVariable("accent", "#e94560") addCSSVariable("success", "#2ecc71")
			addCSSVariable("warning", "#f1c40f") addCSSVariable("danger", "#e74c3c")
			addCSSVariable("bg", "#f5f5f5") addCSSVariable("bg-alt", "#eee")
			addCSSVariable("text", "#1a1a2e") addCSSVariable("text-muted", "#777")
			addCSSVariable("border", "#ddd") addCSSVariable("radius", "12px")
			addCSSVariable("shadow", "0 4px 15px rgba(0,0,0,0.1)")
			addCSSVariable("font-body", "Georgia, 'Times New Roman', serif")
			addCSSVariable("font-heading", "Georgia, serif")
			applyBaseThemeCSS()
		but cThemeName = "modern"
			addCSSVariable("primary", "#6c5ce7") addCSSVariable("secondary", "#a29bfe")
			addCSSVariable("accent", "#fd79a8") addCSSVariable("success", "#00b894")
			addCSSVariable("warning", "#fdcb6e") addCSSVariable("danger", "#d63031")
			addCSSVariable("bg", "#ffffff") addCSSVariable("bg-alt", "#f0f0f3")
			addCSSVariable("text", "#2d3436") addCSSVariable("text-muted", "#636e72")
			addCSSVariable("border", "#dfe6e9") addCSSVariable("radius", "16px")
			addCSSVariable("shadow", "0 8px 30px rgba(0,0,0,0.08)")
			addCSSVariable("font-body", "'Inter', -apple-system, sans-serif")
			addCSSVariable("font-heading", "'Inter', sans-serif")
			addGoogleFont("Inter")
			applyBaseThemeCSS()
		but cThemeName = "dark"
			addCSSVariable("primary", "#bb86fc") addCSSVariable("secondary", "#03dac6")
			addCSSVariable("accent", "#cf6679") addCSSVariable("success", "#00e676")
			addCSSVariable("warning", "#ffab00") addCSSVariable("danger", "#ff5252")
			addCSSVariable("bg", "#121212") addCSSVariable("bg-alt", "#1e1e1e")
			addCSSVariable("text", "#e0e0e0") addCSSVariable("text-muted", "#888")
			addCSSVariable("border", "#333") addCSSVariable("radius", "8px")
			addCSSVariable("shadow", "0 4px 15px rgba(0,0,0,0.3)")
			addCSSVariable("font-body", "'Segoe UI', Roboto, sans-serif")
			addCSSVariable("font-heading", "'Segoe UI', sans-serif")
			applyBaseThemeCSS()
			addCSSRule("a", [["color", "var(--primary)"]]) addCSSRule("a:hover", [["color", "var(--secondary)"]])
		but cThemeName = "nature"
			addCSSVariable("primary", "#2d6a4f") addCSSVariable("secondary", "#40916c")
			addCSSVariable("accent", "#d4a373") addCSSVariable("success", "#52b788")
			addCSSVariable("warning", "#e9c46a") addCSSVariable("danger", "#e76f51")
			addCSSVariable("bg", "#fefae0") addCSSVariable("bg-alt", "#f0ead2")
			addCSSVariable("text", "#2d3436") addCSSVariable("text-muted", "#606c38")
			addCSSVariable("border", "#ccd5ae") addCSSVariable("radius", "10px")
			addCSSVariable("shadow", "0 3px 12px rgba(45,106,79,0.1)")
			addCSSVariable("font-body", "'Nunito', sans-serif")
			addCSSVariable("font-heading", "'Nunito', sans-serif")
			addGoogleFont("Nunito")
			applyBaseThemeCSS()
		but cThemeName = "arabic"
			addCSSVariable("primary", "#1b4965") addCSSVariable("secondary", "#5fa8d3")
			addCSSVariable("accent", "#bee9e8") addCSSVariable("success", "#2a9d8f")
			addCSSVariable("warning", "#e9c46a") addCSSVariable("danger", "#e76f51")
			addCSSVariable("bg", "#faf9f6") addCSSVariable("bg-alt", "#f0ece2")
			addCSSVariable("text", "#1a1a2e") addCSSVariable("text-muted", "#666")
			addCSSVariable("border", "#ddd") addCSSVariable("radius", "8px")
			addCSSVariable("shadow", "0 2px 10px rgba(0,0,0,0.08)")
			addCSSVariable("font-body", "'Noto Naskh Arabic', 'Segoe UI', Tahoma, sans-serif")
			addCSSVariable("font-heading", "'Noto Naskh Arabic', serif")
			addGoogleFont("Noto Naskh Arabic")
			setDirection("rtl") setLang("ar")
			applyBaseThemeCSS()
			addCSSRule("body", [["direction", "rtl"], ["text-align", "right"]])
		ok
		return self

	func applyBaseThemeCSS
		addCSSRule("*", [["margin", "0"], ["padding", "0"], ["box-sizing", "border-box"]])
		addCSSRule("body", [["font-family", "var(--font-body)"], ["background-color", "var(--bg)"], ["color", "var(--text)"], ["line-height", "1.7"]])
		addCSSRule("h1,h2,h3,h4,h5,h6", [["font-family", "var(--font-heading)"], ["color", "var(--primary)"], ["margin-bottom", "0.5em"]])
		addCSSRule("p", [["margin-bottom", "1em"]])
		addCSSRule("a", [["color", "var(--accent)"], ["text-decoration", "none"]])
		addCSSRule("a:hover", [["text-decoration", "underline"]])
		addCSSRule("table", [["width", "100%"], ["border-collapse", "collapse"], ["margin-bottom", "1.5em"]])
		addCSSRule("th,td", [["padding", "10px 14px"], ["text-align", "left"], ["border-bottom", "1px solid var(--border)"]])
		addCSSRule("th", [["background-color", "var(--primary)"], ["color", "#fff"], ["font-weight", "600"]])
		addCSSRule("blockquote", [["border-left", "4px solid var(--accent)"], ["padding-left", "16px"], ["margin", "1em 0"], ["color", "var(--text-muted)"], ["font-style", "italic"]])
		addCSSRule("pre", [["background-color", "var(--bg-alt)"], ["padding", "16px"], ["border-radius", "var(--radius)"], ["overflow", "auto"], ["border", "1px solid var(--border)"]])
		addCSSRule("code", [["font-family", "'Fira Code','Consolas',monospace"], ["font-size", "0.9em"]])
		addCSSRule("hr", [["border", "none"], ["border-top", "1px solid var(--border)"], ["margin", "2em 0"]])
		addCSSRule("img", [["max-width", "100%"], ["height", "auto"]])
		addBreakpoint("768px", "body { font-size: 14px; }")
		return self

	# ====================================================================
	# Landing Page Components
	# ====================================================================

	func addHero cTitleText, cSubtitle, cCTAText, cCTAHref, aOptions
		cBGColor = htmlGetOpt(aOptions, "bgColor", "var(--primary)")
		cTextColor = htmlGetOpt(aOptions, "textColor", "#ffffff")
		cBGImage = htmlGetOpt(aOptions, "bgImage", "")
		cHeight = htmlGetOpt(aOptions, "height", "70vh")
		cAlign = htmlGetOpt(aOptions, "align", "center")
		cStyle = "display:flex;flex-direction:column;justify-content:center;align-items:" + cAlign
		cStyle += ";min-height:" + cHeight + ";padding:60px 40px;text-align:" + cAlign
		cStyle += ";color:" + cTextColor + ";background-color:" + cBGColor
		if cBGImage != "" cStyle += ";background-image:url('" + cBGImage + "');background-size:cover;background-position:center" ok
		cHTML = '<section style="' + cStyle + '">' + char(10)
		cHTML += '  <h1 style="font-size:3rem;margin-bottom:16px">' + htmlEscape(cTitleText) + '</h1>' + char(10)
		if cSubtitle != "" cHTML += '  <p style="font-size:1.3rem;max-width:700px;opacity:0.9;margin-bottom:30px">' + htmlEscape(cSubtitle) + '</p>' + char(10) ok
		if cCTAText != ""
			if lBootstrap
				cHTML += '  <a href="' + cCTAHref + '" class="btn btn-light btn-lg">' + htmlEscape(cCTAText) + '</a>' + char(10)
			else
				cHTML += '  <a href="' + cCTAHref + '" style="display:inline-block;padding:14px 32px;background:' + cTextColor + ';color:' + cBGColor + ';border-radius:var(--radius,6px);font-weight:600;font-size:1.1rem;text-decoration:none">' + htmlEscape(cCTAText) + '</a>' + char(10)
			ok
		ok
		cHTML += '</section>'
		appendContent(cHTML)
		return self

	func addFeatureGrid aFeatures, nColumns
		cColTemplate = ""
		for nCol = 1 to nColumns
			if nCol > 1 cColTemplate += " " ok
			cColTemplate += "1fr"
		next
		cHTML = '<div style="display:grid;grid-template-columns:' + cColTemplate + ';gap:30px;padding:40px 20px">' + char(10)
		nFeatureLen = len(aFeatures)
		for nFeature = 1 to nFeatureLen
			cHTML += '  <div style="text-align:center;padding:20px"><div style="font-size:2.5rem;margin-bottom:12px">' + aFeatures[nFeature][1] + '</div>' + char(10)
			cHTML += '    <h3 style="margin-bottom:8px">' + htmlEscape(aFeatures[nFeature][2]) + '</h3>' + char(10)
			cHTML += '    <p style="color:var(--text-muted,#666)">' + htmlEscape(aFeatures[nFeature][3]) + '</p></div>' + char(10)
		next
		cHTML += '</div>'
		appendContent(cHTML)
		return self

	func addStatsBar aStats, aOptions
		cBGColor = htmlGetOpt(aOptions, "bgColor", "var(--primary,#2c3e50)")
		cTextColor = htmlGetOpt(aOptions, "textColor", "#ffffff")
		nStatCount = len(aStats)
		cHTML = '<div style="display:flex;justify-content:space-around;padding:40px 20px;background:' + cBGColor + ';color:' + cTextColor + ';text-align:center;flex-wrap:wrap">' + char(10)
		for nStat = 1 to nStatCount
			cHTML += '  <div style="padding:10px 20px"><div style="font-size:2.5rem;font-weight:700">' + htmlEscape(aStats[nStat][1]) + '</div><div style="opacity:0.85;font-size:0.95rem">' + htmlEscape(aStats[nStat][2]) + '</div></div>' + char(10)
		next
		cHTML += '</div>'
		appendContent(cHTML)
		return self

	func addTimeline aEvents
		cHTML = '<div class="tl-wrap">' + char(10)
		nEventLen = len(aEvents)
		for nEvent = 1 to nEventLen
			cSide = "tl-left"
			if nEvent % 2 = 0 cSide = "tl-right" ok
			cHTML += '  <div class="tl-item ' + cSide + '"><div class="tl-date">' + htmlEscape(aEvents[nEvent][1]) + '</div><div class="tl-body"><h4>' + htmlEscape(aEvents[nEvent][2]) + '</h4><p>' + htmlEscape(aEvents[nEvent][3]) + '</p></div></div>' + char(10)
		next
		cHTML += '</div>'
		appendContent(cHTML)
		addCSSRule(".tl-wrap", [["position", "relative"], ["max-width", "800px"], ["margin", "30px auto"], ["padding", "20px 0"]])
		addCSSRule(".tl-wrap::before", [["content", "''"], ["position", "absolute"], ["left", "50%"], ["top", "0"], ["bottom", "0"], ["width", "2px"], ["background-color", "var(--border,#dee2e6)"]])
		addCSSRule(".tl-item", [["position", "relative"], ["margin-bottom", "30px"], ["width", "50%"]])
		addCSSRule(".tl-left", [["padding-right", "40px"], ["text-align", "right"]])
		addCSSRule(".tl-right", [["padding-left", "40px"], ["margin-left", "50%"]])
		addCSSRule(".tl-date", [["font-weight", "700"], ["color", "var(--primary,#333)"], ["margin-bottom", "4px"]])
		addCSSRule(".tl-body", [["background-color", "var(--bg-alt,#f8f9fa)"], ["padding", "16px"], ["border-radius", "var(--radius,8px)"], ["box-shadow", "var(--shadow,0 2px 8px rgba(0,0,0,0.08))"]])
		addBreakpoint("768px", ".tl-item{width:100%!important;padding-left:30px!important;padding-right:0!important;margin-left:0!important;text-align:left!important}.tl-wrap::before{left:10px}")
		return self

	func addPricingTable aPlans
		nPlanCount = len(aPlans)
		cColTemplate = ""
		for nCol = 1 to nPlanCount
			if nCol > 1 cColTemplate += " " ok
			cColTemplate += "1fr"
		next
		cHTML = '<div style="display:grid;grid-template-columns:' + cColTemplate + ';gap:20px;padding:20px;max-width:1000px;margin:0 auto">' + char(10)
		for nPlan = 1 to nPlanCount
			aPlan = aPlans[nPlan]
			cPName = htmlGetOpt(aPlan, "name", "Plan")
			cPPrice = htmlGetOpt(aPlan, "price", "$0")
			cPPeriod = htmlGetOpt(aPlan, "period", "/month")
			aPFeatures = htmlGetOpt(aPlan, "features", [])
			cPCta = htmlGetOpt(aPlan, "cta", "Choose")
			cPHref = htmlGetOpt(aPlan, "ctaHref", "#")
			lPHighlight = htmlGetOpt(aPlan, "highlight", false)
			cBorder = "1px solid var(--border,#dee2e6)"
			if lPHighlight = true cBorder = "2px solid var(--primary,#007bff)" ok
			cHTML += '  <div style="border:' + cBorder + ';border-radius:var(--radius,8px);padding:30px;text-align:center;background:var(--bg,#fff)">' + char(10)
			cHTML += '    <h3 style="margin-bottom:10px">' + htmlEscape(cPName) + '</h3><div style="font-size:2.5rem;font-weight:700;color:var(--primary,#333)">' + htmlEscape(cPPrice) + '</div><div style="color:var(--text-muted,#666);margin-bottom:20px">' + htmlEscape(cPPeriod) + '</div>' + char(10)
			if islist(aPFeatures)
				cHTML += '    <ul style="list-style:none;padding:0;margin:0 0 20px 0">' + char(10)
				nPFeatureLen = len(aPFeatures)
				for nFeature = 1 to nPFeatureLen
					cHTML += '      <li style="padding:8px 0;border-bottom:1px solid var(--border,#eee)">&#10003; ' + htmlEscape(aPFeatures[nFeature]) + '</li>' + char(10)
				next
				cHTML += '    </ul>' + char(10)
			ok
			cHTML += '    <a href="' + cPHref + '" style="display:inline-block;padding:12px 30px;background:var(--primary,#007bff);color:#fff;border-radius:var(--radius,6px);text-decoration:none;font-weight:600">' + htmlEscape(cPCta) + '</a></div>' + char(10)
		next
		cHTML += '</div>'
		appendContent(cHTML)
		return self

	func addTestimonial cQuote, cAuthorName, cAuthorTitle, cAvatarURL
		cHTML = '<div style="background:var(--bg-alt,#f8f9fa);padding:24px;border-radius:var(--radius,8px);margin:15px 0;border-left:4px solid var(--accent,#3498db)">' + char(10)
		cHTML += '  <p style="font-style:italic;font-size:1.05rem;margin-bottom:16px">"' + htmlEscape(cQuote) + '"</p><div style="display:flex;align-items:center;gap:12px">' + char(10)
		if cAvatarURL != "" cHTML += '    <img src="' + cAvatarURL + '" style="width:48px;height:48px;border-radius:50%;object-fit:cover" alt="">' + char(10) ok
		cHTML += '    <div><strong>' + htmlEscape(cAuthorName) + '</strong>'
		if cAuthorTitle != "" cHTML += '<div style="color:var(--text-muted,#666);font-size:0.9rem">' + htmlEscape(cAuthorTitle) + '</div>' ok
		cHTML += '</div></div></div>'
		appendContent(cHTML)
		return self

	func addGallery aImages, nColumns
		cColTemplate = ""
		for nCol = 1 to nColumns
			if nCol > 1 cColTemplate += " " ok
			cColTemplate += "1fr"
		next
		cHTML = '<div style="display:grid;grid-template-columns:' + cColTemplate + ';gap:10px">' + char(10)
		nImageLen = len(aImages)
		for nImage = 1 to nImageLen
			cHTML += '  <div style="overflow:hidden;border-radius:var(--radius,6px)"><img src="' + aImages[nImage][1] + '" alt="' + htmlEscape(aImages[nImage][2]) + '" style="width:100%;height:200px;object-fit:cover;transition:transform 0.3s"></div>' + char(10)
		next
		cHTML += '</div>'
		appendContent(cHTML)
		return self

	func addTableOfContents cTitleText, aItems
		cHTML = '<div style="background:var(--bg-alt,#f8f9fa);padding:20px 30px;border-radius:var(--radius,8px);border:1px solid var(--border,#dee2e6);margin:20px 0">' + char(10)
		if cTitleText != "" cHTML += '  <h3 style="margin-bottom:12px">' + htmlEscape(cTitleText) + '</h3>' + char(10) ok
		cHTML += '  <ol style="margin:0;padding-left:20px">' + char(10)
		nItemLen = len(aItems)
		for nItem = 1 to nItemLen
			cHTML += '    <li style="padding:4px 0"><a href="' + aItems[nItem][2] + '" style="text-decoration:none">' + htmlEscape(aItems[nItem][1]) + '</a></li>' + char(10)
		next
		cHTML += '  </ol></div>'
		appendContent(cHTML)
		return self

	func addSocialLinks aLinks, aOptions
		cColor = htmlGetOpt(aOptions, "color", "var(--text-muted,#666)")
		cSize = htmlGetOpt(aOptions, "size", "24px")
		cGap = htmlGetOpt(aOptions, "gap", "15px")
		cHTML = '<div style="display:flex;gap:' + cGap + ';align-items:center;flex-wrap:wrap">' + char(10)
		nLinkLen = len(aLinks)
		for nLink = 1 to nLinkLen
			cPlatform = aLinks[nLink][1]
			cURL = aLinks[nLink][2]
			if lBootstrapIcons
				cHTML += '  <a href="' + cURL + '" target="_blank" rel="noopener" style="color:' + cColor + ';font-size:' + cSize + '" title="' + htmlEscape(cPlatform) + '"><i class="bi bi-' + cPlatform + '"></i></a>' + char(10)
			but lFontAwesome
				cHTML += '  <a href="' + cURL + '" target="_blank" rel="noopener" style="color:' + cColor + ';font-size:' + cSize + '" title="' + htmlEscape(cPlatform) + '"><i class="fab fa-' + cPlatform + '"></i></a>' + char(10)
			else
				cHTML += '  <a href="' + cURL + '" target="_blank" rel="noopener" style="color:' + cColor + ';text-decoration:none;font-size:0.9rem">[' + htmlEscape(cPlatform) + ']</a>' + char(10)
			ok
		next
		cHTML += '</div>'
		appendContent(cHTML)
		return self

	func addPageFooter cText, aLinks, aOptions
		cBGColor = htmlGetOpt(aOptions, "bgColor", "var(--primary,#2c3e50)")
		cTextColor = htmlGetOpt(aOptions, "textColor", "#ccc")
		cPadding = htmlGetOpt(aOptions, "padding", "40px 20px")
		cHTML = '<footer style="background:' + cBGColor + ';color:' + cTextColor + ';padding:' + cPadding + ';text-align:center;margin-top:40px">' + char(10)
		if len(aLinks) > 0
			cHTML += '  <div style="margin-bottom:15px">' + char(10)
			nLinkLen = len(aLinks)
			for nLink = 1 to nLinkLen
				if nLink > 1 cHTML += '    <span style="margin:0 10px;opacity:0.5">|</span>' + char(10) ok
				cHTML += '    <a href="' + aLinks[nLink][2] + '" style="color:' + cTextColor + ';text-decoration:none">' + htmlEscape(aLinks[nLink][1]) + '</a>' + char(10)
			next
			cHTML += '  </div>' + char(10)
		ok
		cHTML += '  <p style="margin:0;opacity:0.7;font-size:0.9rem">' + htmlEscape(cText) + '</p></footer>'
		appendContent(cHTML)
		return self

	func addPrintStyles
		addRawCSS("@media print{body{background:#fff!important;color:#000!important}nav,.navbar,footer,button,.btn,.no-print{display:none!important}a{text-decoration:underline;color:#000}table{border-collapse:collapse}th,td{border:1px solid #333!important}}")
		return self

	func enableSmoothScroll
		addCSSRule("html", [["scroll-behavior", "smooth"]])
		return self

	func addBackToTop
		appendContent('<a href="#" style="position:fixed;bottom:30px;right:30px;width:45px;height:45px;background:var(--primary,#333);color:#fff;border-radius:50%;display:flex;align-items:center;justify-content:center;text-decoration:none;font-size:1.2rem;box-shadow:0 2px 10px rgba(0,0,0,0.2);z-index:999">&uarr;</a>')
		return self


	# ====================================================================
	# Document Generation
	# ====================================================================

	func render
		cHTML = "<!DOCTYPE html>" + HTML_LF
		cHTML += '<html lang="' + cLang + '"'
		if cDir != "" cHTML += ' dir="' + cDir + '"' ok
		cHTML += ">" + HTML_LF

		# <head>
		cHTML += "<head>" + HTML_LF
		cHTML += '    <meta charset="' + cCharset + '">' + HTML_LF
		if cViewport != ""
			cHTML += '    <meta name="viewport" content="' + cViewport + '">' + HTML_LF
		ok
		cHTML += "    <title>" + htmlEscape(cTitle) + "</title>" + HTML_LF

		if cDescription != ""
			cHTML += '    <meta name="description" content="' + htmlEscape(cDescription) + '">' + HTML_LF
		ok
		if cKeywords != ""
			cHTML += '    <meta name="keywords" content="' + htmlEscape(cKeywords) + '">' + HTML_LF
		ok
		if cAuthor != ""
			cHTML += '    <meta name="author" content="' + htmlEscape(cAuthor) + '">' + HTML_LF
		ok
		if cCanonicalURL != ""
			cHTML += '    <link rel="canonical" href="' + cCanonicalURL + '">' + HTML_LF
		ok
		if cFavicon != ""
			cHTML += '    <link rel="icon" href="' + cFavicon + '">' + HTML_LF
		ok

		# Open Graph
		nOpenGraphLen = len(aOpenGraph)
		for nOpenGraph = 1 to nOpenGraphLen
			cHTML += '    <meta property="' + aOpenGraph[nOpenGraph][1] + '" content="' + htmlEscape(aOpenGraph[nOpenGraph][2]) + '">' + HTML_LF
		next

		# Custom meta tags
		nMetaTagLen = len(aMetaTags)
		for nOpenGraph = 1 to nMetaTagLen
			cHTML += '    <meta name="' + aMetaTags[nOpenGraph][1] + '" content="' + htmlEscape(aMetaTags[nOpenGraph][2]) + '">' + HTML_LF
		next

		# Framework CSS (injected before user stylesheets)
		if lBootstrap
			cHTML += '    <link href="https://cdn.jsdelivr.net/npm/bootstrap@' + cBootstrapVersion + '/dist/css/bootstrap.min.css" rel="stylesheet">' + HTML_LF
		ok
		if lBootstrapIcons
			cHTML += '    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">' + HTML_LF
		ok
		if lFontAwesome
			cHTML += '    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/' + cFontAwesomeVersion + '/css/all.min.css" rel="stylesheet">' + HTML_LF
		ok
		if lHighlightJS
			cHTML += '    <link href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/styles/' + cHighlightTheme + '.min.css" rel="stylesheet">' + HTML_LF
		ok

		# External stylesheets
		nStylesheetLen = len(aStylesheets)
		for nOpenGraph = 1 to nStylesheetLen
			cHTML += '    <link rel="stylesheet" href="' + aStylesheets[nOpenGraph] + '">' + HTML_LF
		next

		# Internal CSS
		if len(aCSSVariables) > 0 or len(aCSSRules) > 0 or len(aMediaQueries) > 0 or len(aKeyframes) > 0 or cRawCSS != ""
			cHTML += "    <style>" + HTML_LF

			# CSS Variables
			if len(aCSSVariables) > 0
				cHTML += "        :root {" + HTML_LF
				nCSSVariableLen = len(aCSSVariables)
				for nOpenGraph = 1 to nCSSVariableLen
					cHTML += "            --" + aCSSVariables[nOpenGraph][1] + ": " + aCSSVariables[nOpenGraph][2] + ";" + HTML_LF
				next
				cHTML += "        }" + HTML_LF
			ok

			# CSS Rules
			nCSSRuleLen = len(aCSSRules)
			for nOpenGraph = 1 to nCSSRuleLen
				cHTML += "        " + substr(aCSSRules[nOpenGraph], char(10), char(10) + "        ")
			next

			# Keyframes
			nKeyframeLen = len(aKeyframes)
			for nOpenGraph = 1 to nKeyframeLen
				cHTML += "        @keyframes " + aKeyframes[nOpenGraph][:name] + " {" + HTML_LF
				cHTML += "            " + aKeyframes[nOpenGraph][:frames] + HTML_LF
				cHTML += "        }" + HTML_LF
			next

			# Media queries
			nMediaQueryLen = len(aMediaQueries)
			for nOpenGraph = 1 to nMediaQueryLen
				cHTML += "        @media (" + aMediaQueries[nOpenGraph][:query] + ") {" + HTML_LF
				cHTML += "            " + aMediaQueries[nOpenGraph][:rules] + HTML_LF
				cHTML += "        }" + HTML_LF
			next

			# Raw CSS
			if cRawCSS != ""
				cHTML += "        " + substr(cRawCSS, char(10), char(10) + "        ") + HTML_LF
			ok

			cHTML += "    </style>" + HTML_LF
		ok

		# Head scripts
		if cScriptsHead != ""
			cHTML += "    <script>" + HTML_LF
			cHTML += "        " + substr(cScriptsHead, char(10), char(10) + "        ") + HTML_LF
			cHTML += "    </script>" + HTML_LF
		ok

		cHTML += "</head>" + HTML_LF

		# <body>
		cHTML += "<body"
		if len(aBodyAttrs) > 0
			cHTML += htmlBuildAttrs(aBodyAttrs)
		ok
		cHTML += ">" + HTML_LF

		# Body content
		nBodyContentLen = len(aBodyContent)
		for nOpenGraph = 1 to nBodyContentLen
			cHTML += aBodyContent[nOpenGraph] + HTML_LF
		next

		# Framework scripts (before user scripts)
		if lBootstrap
			cHTML += '<script src="https://cdn.jsdelivr.net/npm/bootstrap@' + cBootstrapVersion + '/dist/js/bootstrap.bundle.min.js"></script>' + HTML_LF
		ok
		if lHighlightJS
			cHTML += '<script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/highlight.min.js"></script>' + HTML_LF
			cHTML += '<script>hljs.highlightAll();</script>' + HTML_LF
		ok

		# Three.js CDN (must load before user scripts)
		if lThreeJS
			cHTML += '<script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/r128/three.min.js"></script>' + HTML_LF
		ok

		# Three.js Loaders (must load after three.js core)
		if lGLTFLoader
			cHTML += '<script src="https://cdn.jsdelivr.net/npm/three@0.128.0/examples/js/loaders/GLTFLoader.js"></script>' + HTML_LF
		ok
		if lDracoDecoder
			cHTML += '<script src="https://cdn.jsdelivr.net/npm/three@0.128.0/examples/js/loaders/DRACOLoader.js"></script>' + HTML_LF
		ok
		if lOBJLoader
			cHTML += '<script src="https://cdn.jsdelivr.net/npm/three@0.128.0/examples/js/loaders/OBJLoader.js"></script>' + HTML_LF
		ok
		if lMTLLoader
			cHTML += '<script src="https://cdn.jsdelivr.net/npm/three@0.128.0/examples/js/loaders/MTLLoader.js"></script>' + HTML_LF
		ok
		if lFBXLoader
			cHTML += '<script src="https://cdn.jsdelivr.net/npm/three@0.128.0/examples/js/loaders/FBXLoader.js"></script>' + HTML_LF
			# FBX needs fflate for decompression
			cHTML += '<script src="https://cdn.jsdelivr.net/npm/fflate@0.6.9/umd/index.js"></script>' + HTML_LF
		ok
		if lColladaLoader
			cHTML += '<script src="https://cdn.jsdelivr.net/npm/three@0.128.0/examples/js/loaders/ColladaLoader.js"></script>' + HTML_LF
		ok
		if lOrbitControls
			cHTML += '<script src="https://cdn.jsdelivr.net/npm/three@0.128.0/examples/js/controls/OrbitControls.js"></script>' + HTML_LF
		ok
		if lPostProcessing
			cHTML += '<script src="https://cdn.jsdelivr.net/npm/three@0.128.0/examples/js/postprocessing/EffectComposer.js"></script>' + HTML_LF
			cHTML += '<script src="https://cdn.jsdelivr.net/npm/three@0.128.0/examples/js/postprocessing/RenderPass.js"></script>' + HTML_LF
			cHTML += '<script src="https://cdn.jsdelivr.net/npm/three@0.128.0/examples/js/postprocessing/ShaderPass.js"></script>' + HTML_LF
			cHTML += '<script src="https://cdn.jsdelivr.net/npm/three@0.128.0/examples/js/postprocessing/UnrealBloomPass.js"></script>' + HTML_LF
			cHTML += '<script src="https://cdn.jsdelivr.net/npm/three@0.128.0/examples/js/postprocessing/FilmPass.js"></script>' + HTML_LF
			cHTML += '<script src="https://cdn.jsdelivr.net/npm/three@0.128.0/examples/js/postprocessing/GlitchPass.js"></script>' + HTML_LF
			cHTML += '<script src="https://cdn.jsdelivr.net/npm/three@0.128.0/examples/js/shaders/CopyShader.js"></script>' + HTML_LF
			cHTML += '<script src="https://cdn.jsdelivr.net/npm/three@0.128.0/examples/js/shaders/LuminosityHighPassShader.js"></script>' + HTML_LF
			cHTML += '<script src="https://cdn.jsdelivr.net/npm/three@0.128.0/examples/js/shaders/FXAAShader.js"></script>' + HTML_LF
			cHTML += '<script src="https://cdn.jsdelivr.net/npm/three@0.128.0/examples/js/shaders/FilmShader.js"></script>' + HTML_LF
			cHTML += '<script src="https://cdn.jsdelivr.net/npm/three@0.128.0/examples/js/shaders/DotScreenShader.js"></script>' + HTML_LF
			cHTML += '<script src="https://cdn.jsdelivr.net/npm/three@0.128.0/examples/js/shaders/VignetteShader.js"></script>' + HTML_LF
			cHTML += '<script src="https://cdn.jsdelivr.net/npm/three@0.128.0/examples/js/shaders/DigitalGlitch.js"></script>' + HTML_LF
		ok
		if lReflector
			cHTML += '<script src="https://cdn.jsdelivr.net/npm/three@0.128.0/examples/js/objects/Reflector.js"></script>' + HTML_LF
		ok
		if lCannonJS
			cHTML += '<script src="https://cdnjs.cloudflare.com/ajax/libs/cannon.js/0.6.2/cannon.min.js"></script>' + HTML_LF
		ok
		if lGSAP
			cHTML += '<script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.2/gsap.min.js"></script>' + HTML_LF
		ok
		if lTextGeometry
			cHTML += '<script src="https://cdn.jsdelivr.net/npm/three@0.128.0/examples/js/loaders/FontLoader.js"></script>' + HTML_LF
			cHTML += '<script src="https://cdn.jsdelivr.net/npm/three@0.128.0/examples/js/geometries/TextGeometry.js"></script>' + HTML_LF
		ok
		if lCSS2DRenderer
			cHTML += '<script src="https://cdn.jsdelivr.net/npm/three@0.128.0/examples/js/renderers/CSS2DRenderer.js"></script>' + HTML_LF
		ok
		if lOutlinePass
			if !lPostProcessing
				cHTML += '<script src="https://cdn.jsdelivr.net/npm/three@0.128.0/examples/js/postprocessing/EffectComposer.js"></script>' + HTML_LF
				cHTML += '<script src="https://cdn.jsdelivr.net/npm/three@0.128.0/examples/js/postprocessing/RenderPass.js"></script>' + HTML_LF
				cHTML += '<script src="https://cdn.jsdelivr.net/npm/three@0.128.0/examples/js/postprocessing/ShaderPass.js"></script>' + HTML_LF
				cHTML += '<script src="https://cdn.jsdelivr.net/npm/three@0.128.0/examples/js/shaders/CopyShader.js"></script>' + HTML_LF
			ok
			cHTML += '<script src="https://cdn.jsdelivr.net/npm/three@0.128.0/examples/js/postprocessing/OutlinePass.js"></script>' + HTML_LF
		ok

		# External scripts
		nScriptsSrcLen = len(aScriptsSrc)
		for nOpenGraph = 1 to nScriptsSrcLen
			cHTML += '<script src="' + aScriptsSrc[nOpenGraph] + '"></script>' + HTML_LF
		next

		# Body scripts
		if cScriptsBody != ""
			cHTML += "<script>" + HTML_LF
			cHTML += cScriptsBody + HTML_LF
			cHTML += "</script>" + HTML_LF
		ok

		cHTML += "</body>" + HTML_LF
		cHTML += "</html>" + HTML_LF

		return cHTML

	# Save to file
	func save cFileName
		cContent = render()
		write(cFileName, cContent)
		return true

	# Get content length
	func getContentSize
		return len(render())
