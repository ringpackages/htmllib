class CSSRule

	cSelector = ""
	aProperties = []

	func init
		return self

	func selector cSel
		cSelector = cSel
		return self

	func prop cName, cValue
		aProperties + [cName, cValue]
		return self

	func render
		cResult = cSelector + " {" + HTML_LF
		nPropertyLen = len(aProperties)
		for nProperty = 1 to nPropertyLen
			cResult += "    " + aProperties[nProperty][1] + ": " + aProperties[nProperty][2] + ";" + HTML_LF
		next
		cResult += "}" + HTML_LF
		return cResult

