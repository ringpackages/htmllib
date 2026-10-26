# Safe hash key access: returns xDefault if the key doesn't exist
# Ring stores hash keys (:camZ) in lower case, so we search using lower(cKey)
func htmlGetOpt aOptions, cKey, xDefault
	nPos = find(aOptions, lower(cKey), 1)
	if nPos = 0 return xDefault ok
	return aOptions[nPos][2]

# HTML-escape special characters
func htmlEscape cText
	cResult = cText
	cResult = substr(cResult, "&", "&amp;")
	cResult = substr(cResult, "<", "&lt;")
	cResult = substr(cResult, ">", "&gt;")
	cResult = substr(cResult, '"', "&quot;")
	cResult = substr(cResult, "'", "&#39;")
	return cResult

# Build an attribute string from a hash list
# aAttrs = [:class = "box", :id = "main", :style = "color:red"]
func htmlBuildAttrs aAttrs
	if len(aAttrs) = 0 return "" ok
	cResult = ""
	nAttrLen = len(aAttrs)
	for nAttr = 1 to nAttrLen
		cKey = substr(aAttrs[nAttr][1], ":", "")  # Remove the : prefix Ring adds
		cVal = aAttrs[nAttr][2]
		if cVal != "" and isstring(cVal)
			cResult += " " + cKey + '="' + cVal + '"'
		ok
	next
	return cResult

# Build inline style string from a list of [property, value] pairs
# aStyles = [["color", "red"], ["font-size", "14px"], ["background-color", "#eee"]]
func htmlBuildStyle aStyles
	if len(aStyles) = 0 return "" ok
	cResult = ""
	nStyleLen = len(aStyles)
	for nStyle = 1 to nStyleLen
		cProp = aStyles[nStyle][1]
		cProp = substr(cProp, ":", "")
		# Note: Ring lowercases hash keys so camelCase is lost
		# Use ["background-color", "red"] not [:backgroundColor = "red"]
		cVal = aStyles[nStyle][2]
		if nStyle > 1 cResult += "; " ok
		cResult += cProp + ": " + cVal
	next
	return cResult

# Convert camelCase to kebab-case (e.g. backgroundColor -> background-color)
func htmlCamelToKebab cText
	cResult = ""
	nTextLen = len(cText)
	for nText = 1 to nTextLen
		nChar = ascii(cText[nText])
		if nChar >= 65 and nChar <= 90   # uppercase A-Z
			if nText > 1 cResult += "-" ok
			cResult += char(nChar + 32)   # to lowercase
		else
			cResult += cText[nText]
		ok
	next
	return cResult

# Quick HTML generator: quickHTML("page.html", "Title", aItems)
# aItems: list of hash items, each describing content
# Each item: [:type = "heading/paragraph/table/list/image", :data = ...]
func quickHTML cFileName, cTitleText, aItems
	oDoc = new HTMLWriter
	oDoc.setTitle(cTitleText)

	nItemLen = len(aItems)
	for nItem = 1 to nItemLen
		aItem = aItems[nItem]
		cType = aItem[:type]

		if cType = "heading" or cType = "h"
			oDoc.addHeading(aItem[:level], aItem[:text])
		but cType = "paragraph" or cType = "p"
			oDoc.addParagraph(aItem[:text])
		but cType = "table"
			oDoc.addTable(aItem[:data])
		but cType = "list" or cType = "ul"
			oDoc.addList(aItem[:items])
		but cType = "orderedlist" or cType = "ol"
			oDoc.addOrderedList(aItem[:items])
		but cType = "image" or cType = "img"
			oDoc.addImage(aItem[:src], aItem[:alt])
		but cType = "link" or cType = "a"
			oDoc.addLink(aItem[:text], aItem[:href])
		but cType = "hr"
			oDoc.addHR()
		but cType = "html" or cType = "raw"
			oDoc.addRawHTML(aItem[:html])
		but cType = "code"
			oDoc.addCodeBlock(aItem[:code], aItem[:language])
		ok
	next

	oDoc.save(cFileName)
	return oDoc
