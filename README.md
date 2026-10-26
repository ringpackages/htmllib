# HTMLLib Package

## Overview

HTMLLib is a pure Ring library for generating HTML5/CSS3 web pages.

It requires no external dependencies and works on Windows, Linux, and macOS. 

The generated pages can optionally use JavaScript components, Bootstrap 5, Chart.js and Three.js (loaded from CDNs by the generated page).

## Features

- Build complete HTML5 documents with the `HTMLWriter` class
- Document settings: title, language, direction, charset, meta tags, Open Graph, favicon
- Text elements: headings, paragraphs, spans, links, images, figures, code blocks
- Lists, definition lists, and tables (simple, styled, raw)
- Forms with all input types, selects, checkboxes, radio buttons, fieldsets
- Audio, video and iframes
- Semantic containers (header, nav, main, section, article, aside, footer)
- CSS rules, CSS variables, media queries, keyframe animations
- Flexbox and Grid layout helpers
- UI components: navbar, cards, alerts, badges, progress bars, breadcrumbs, pagination, accordion, tabs, modals, tooltips
- RTL/Arabic text support
- JavaScript components: counters, toggles, tabs, slideshows, countdowns, typing effect, dark mode, notifications, sortable tables, form validation, Chart.js charts
- Bootstrap 5, Bootstrap Icons, Font Awesome and Highlight.js integration
- Built-in themes: professional, elegant, modern, dark, nature, arabic
- Landing page components: hero, feature grid, stats bar, timeline, pricing table, testimonials, gallery
- Three.js 3D scenes: meshes, lights, textures, animations, particles, shaders, post-processing, model loading (GLTF, OBJ, FBX, Collada), physics (Cannon.js), tweening (GSAP), 3D text, terrain, audio
- Save to `.html` file

## Installation

	ringpm install htmllib from ringpackages

## Screen Shot

![Screen Shot 1](https://raw.githubusercontent.com/ringpackages/htmllib/main/images/htmllib_shot1.png)

## Quick Start

### Simple Page

```ring
load "htmllib.ring"

oHTML = new HTMLWriter
oHTML.setTitle("My Page")
oHTML.addHeading(1, "Hello World")
oHTML.addParagraph("This is a paragraph.")
oHTML.save("page.html")
```

### Bootstrap Page

```ring
load "htmllib.ring"

oHTML = new HTMLWriter
oHTML.setTitle("My Site")
oHTML.enableBootstrap()
oHTML.bsNavbar("Brand", "/", [["Home", "/", true], ["About", "#about", false]], "dark")
oHTML.bsOpenContainer("")
oHTML.bsAlert("Welcome to HTMLLib!", "success", true)
oHTML.bsCloseContainer()
oHTML.save("site.html")
```

### Themed Page

```ring
load "htmllib.ring"

oHTML = new HTMLWriter
oHTML.setTitle("Themed Page")
oHTML.setTheme("dark")
oHTML.addHeading(1, "Dark Theme")
oHTML.addTable([
	["Language", "Year"],
	["Ring", "2016"]
])
oHTML.save("themed.html")
```

### 3D Scene

```ring
load "htmllib.ring"

oHTML = new HTMLWriter
oHTML.setTitle("Hello 3D")
oHTML.enableThreeJS()
oHTML.addCSSRule("body", [["margin", "0"], ["overflow", "hidden"]])
oHTML.threeJSScene("scene", [:fullscreen = true, :bg = "0x1a1a2e", :camZ = "5"])
oHTML.threeJSAmbientLight("scene", [:intensity = "0.5"])
oHTML.threeJSDirectionalLight("scene", "sun", [:x = "5", :y = "5", :z = "5"])
oHTML.threeJSBox("scene", "cube", [:color = "0x3498db"])
oHTML.threeJSAutoRotate("scene", "cube", [:speedY = "1"])
oHTML.threeJSAnimate("scene")
oHTML.save("hello3d.html")
```

### Quick Function

```ring
load "htmllib.ring"

quickHTML("quick.html", "Quick Document", [
	[:type = "h", :level = 1, :text = "Quick HTML"],
	[:type = "p", :text = "Created using quickHTML()"],
	[:type = "ul", :items = ["One", "Two", "Three"]]
])
```

---

## Conventions

- Attribute lists are lists of `[name, value]` pairs, so both `[:class = "box", :id = "main"]` and `[["class", "box"], ["id", "main"]]` work. Attributes with empty or non-string values are skipped.
- Option lists use hash keys, for example `[:color = "0xff0000", :x = "2"]`. Ring stores hash keys in lower case, so `:camZ` and `:camz` are the same option (if you build the list as `[key, value]` pairs, write the keys in lower case).
- CSS properties are lists of `[property, value]` pairs written in kebab-case: `addCSSRule("body", [["background-color", "#fff"]])`. Do not use `[:backgroundColor = "#fff"]`, because Ring lowercases hash keys.
- Methods that take plain text escape it (`htmlEscape()`); methods ending with `Raw` insert HTML as is.
- Building methods return `self`, so they can be chained. Most `threeJS*` methods that return JavaScript code (for example `threeJSApplyForce()`) are meant to be used inside other JavaScript strings.

---

## API Reference

### Functions

| Function | Description |
|----------|-------------|
| `quickHTML(cFileName, cTitle, aItems)` | Create and save a page from a list of items; returns the `HTMLWriter` object |
| `htmlEscape(cText)` | Escape `&`, `<`, `>`, `"` and `'` |
| `htmlBuildAttrs(aAttrs)` | Build an attribute string from `[name, value]` pairs |
| `htmlBuildStyle(aStyles)` | Build an inline style string from `[property, value]` pairs |
| `htmlCamelToKebab(cText)` | Convert `backgroundColor` to `background-color` |
| `htmlGetOpt(aOptions, cKey, xDefault)` | Get an option value (case-insensitive key), or the default |

`quickHTML()` item types: `h`/`heading` (`:level`, `:text`), `p`/`paragraph` (`:text`), `table` (`:data`), `ul`/`list` and `ol`/`orderedlist` (`:items`), `img`/`image` (`:src`, `:alt`), `a`/`link` (`:text`, `:href`), `hr`, `raw`/`html` (`:html`), `code` (`:code`, `:language`).

### CSSRule Class

| Method | Description |
|--------|-------------|
| `selector(cSel)` | Set the selector |
| `prop(cName, cValue)` | Add a property |
| `render()` | Return the rule as a CSS string |

### Constants

Defined in `globals.ring`: heading levels (`HTML_H1` .. `HTML_H6`), alignment (`HTML_ALIGN_*`), input types (`HTML_INPUT_*`), display modes (`HTML_DISPLAY_*`), flex direction and alignment (`HTML_FLEX_*`, `HTML_JUSTIFY_*`, `HTML_ALIGN_ITEMS_*`), position (`HTML_POS_*`), overflow (`HTML_OVERFLOW_*`), font weights (`HTML_FONT_*`), border styles (`HTML_BORDER_*`), direction (`HTML_DIR_LTR`, `HTML_DIR_RTL`), link targets (`HTML_TARGET_*`) and button types (`HTML_BTN_*`).

---

### HTMLWriter Class

#### Document Settings

| Method | Description |
|--------|-------------|
| `setTitle(cTitle)` | Page title (default: "Untitled") |
| `setLang(cLang)` | `<html lang>` (default: "en") |
| `setDirection(cDir)` | `<html dir>` ("ltr" or "rtl") |
| `setCharset(cCharset)` | Charset (default: "UTF-8") |
| `setDescription(cDesc)` / `setKeywords(cKeywords)` / `setAuthor(cAuthor)` | SEO meta tags |
| `setViewport(cViewport)` | Viewport meta tag |
| `setFavicon(cURL)` / `setCanonicalURL(cURL)` | Favicon and canonical links |
| `addMeta(cName, cContent)` | Custom meta tag |
| `addOpenGraph(cProperty, cContent)` | Open Graph meta tag |
| `setBodyAttr(cName, cValue)` | Attribute on `<body>` |
| `setMinified(lFlag)` | Store the minified flag (reserved; the output is not changed) |

#### External Resources, CSS and Scripts

| Method | Description |
|--------|-------------|
| `addStylesheet(cHref)` / `addStylesheetMedia(cHref, cMedia)` | Link a stylesheet |
| `addGoogleFont(cFontName)` | Link a Google font |
| `addScript(cSrc)` | External script (before `</body>`) |
| `addCSSRule(cSelector, aProps)` | CSS rule from `[property, value]` pairs |
| `addRawCSS(cCSS)` | Raw CSS |
| `addCSSVariable(cName, cValue)` | CSS custom property (`--name`) in `:root` |
| `addMediaQuery(cQuery, cRules)` / `addBreakpoint(cMaxWidth, cRules)` | Media queries |
| `addKeyframes(cName, cFrames)` | Keyframe animation |
| `addHeadScript(cJS)` / `addBodyScript(cJS)` | JavaScript in `<head>` or before `</body>` |

#### Text, Links and Media

| Method | Description |
|--------|-------------|
| `addRawHTML(cHTML)` | Insert HTML as is |
| `addHeading(nLevel, cText)` | `<h1>`..`<h6>` (also `addHeadingStyled`, `addHeadingRaw`, `addHeadingRawStyled`) |
| `addParagraph(cText)` | `<p>` (also `addParagraphStyled`, `addParagraphRaw`, `addParagraphRawStyled`) |
| `addSpan(cText, aAttrs)` / `addSpanRaw(cHTML, aAttrs)` | `<span>` |
| `addBold`, `addItalic`, `addUnderline`, `addStrikethrough`, `addSmall`, `addMark`, `addSubscript`, `addSuperscript` | Inline formatting (take `cText`) |
| `addAbbr(cText, cTitle)` | Abbreviation |
| `addBlockquote(cText)` / `addBlockquoteStyled(cText, aAttrs)` | Block quote |
| `addPre(cText)` / `addCode(cText)` | Preformatted text and inline code |
| `addCodeBlock(cCode, cLanguage)` / `addCodeBlockStyled(...)` | Code block with a `language-*` class |
| `addText(cText, cColor, cFontSize, cFontWeight)` | Styled text span |
| `addBreak()` / `addHR()` / `addHRStyled(aAttrs)` | Line break and horizontal rule |
| `addLink(cText, cHref)` | Link (also `addLinkStyled`, `addLinkNewTab`, `addLinkRaw`) |
| `addAnchor(cID)` | Bookmark target |
| `addImage(cSrc, cAlt)` | Image (also `addImageStyled`, `addImageSized`, `addResponsiveImage`, `addLazyImage`) |
| `addFigure(cImgSrc, cImgAlt, cCaption)` / `addFigureStyled(...)` | Figure with caption |
| `addVideo`, `addVideoControls`, `addAudio`, `addAudioControls`, `addIframe`, `addIframeStyled` | Media elements |

#### Lists and Tables

| Method | Description |
|--------|-------------|
| `addList(aItems)` / `addListStyled(aItems, aAttrs)` | Unordered list |
| `addOrderedList(aItems)` / `addOrderedListStyled(aItems, aAttrs)` | Ordered list |
| `addListRaw(aItems)` | List with HTML items |
| `addDefList(aItems)` | Definition list from `[term, definition]` pairs |
| `addTable(aData)` | Table from a 2D list (the first row is the header) |
| `addTableStyled(aData, aOptions)` | Options: `:class`, `:id`, `:border`, `:striped`, `:hover`, `:responsive`, `:caption` |
| `addTableRaw(cHTML)` | Raw table HTML |

#### Forms

| Method | Description |
|--------|-------------|
| `openForm(cAction, cMethod)` / `openFormStyled(...)` / `closeForm()` | Form element |
| `addInput(cLabel, cType, cName, aAttrs)` / `addInputField(cLabel, cType, cName)` | Labeled input |
| `addTextarea(cLabel, cName, nRows, nCols)` / `addTextareaStyled(...)` | Text area |
| `addSelect(cLabel, cName, aOptions)` / `addSelectStyled(...)` | Select from `[value, label]` pairs |
| `addCheckbox(cLabel, cName, cValue, lChecked)` / `addRadio(...)` | Checkbox and radio button |
| `openFieldset(cLegend)` / `closeFieldset()` | Fieldset |
| `addButton(cText, cType)` / `addButtonStyled(cText, cType, aAttrs)` | Button |

#### Containers and Layout

| Method | Description |
|--------|-------------|
| `openDiv` / `openSection` / `openArticle` / `openAside` / `openMain` / `openHeader` / `openFooter` / `openNav` (`aAttrs`) | Open a container (close with the matching `close*()` method) |
| `openTag(cTag, aAttrs)` / `closeTag(cTag)` / `addSelfClosingTag(cTag, aAttrs)` | Any tag |
| `openFlex(cDirection, cJustify, cAlignItems)` / `closeFlex()` | Flexbox container |
| `openGrid(cColumns, cGap)` / `closeGrid()` | Grid container (`cColumns` is the column template, e.g. "1fr 1fr") |
| `openTwoColumns(cLeftWidth, cRightWidth, cGap)` / `closeTwoColumns()` | Two-column layout |
| `addSpacer(cHeight)` / `addComment(cText)` / `addDataDiv(aAttrs, aDataAttrs)` | Utilities |
| `getAutoId()` | Return a unique id string |

#### UI Components (no framework required)

| Method | Description |
|--------|-------------|
| `addNavbar(cBrand, aItems, aOptions)` | Navigation bar from `[text, href]` pairs |
| `addCard(cTitle, cBody, aOptions)` | Card |
| `addAlert(cMessage, cType)` | Alert ("info", "success", "warning", "danger") |
| `addBadge(cText, cBGColor, cTextColor)` | Badge |
| `addProgressBar(nPercent, cColor, cHeight)` | Progress bar |
| `addBreadcrumbs(aItems)` | Breadcrumbs from `[text, href]` pairs |
| `addPagination(nCurrentPage, nTotalPages, cBaseURL)` | Pagination |
| `addAccordion(aItems)` | Accordion using `<details>` |
| `addTabs(cTabId, aTabs)` | CSS-only tabs from `[title, html]` pairs |
| `addModal(cID, cTitle, cBody)` / `addModalButton(cText, cModalId, aAttrs)` | CSS-only modal |
| `addTooltip(cText, cTipText)` | CSS-only tooltip |
| `setRTL()`, `addRTLParagraph(cText)`, `addBidiText(cText)`, `openRTLDiv(aAttrs)`, `closeRTLDiv()` | RTL / Arabic support |

#### JavaScript

| Method | Description |
|--------|-------------|
| `addInlineScript(cJS)` | Script at the current position |
| `addDeferScript(cSrc)` / `addAsyncScript(cSrc)` | External script with `defer` / `async` |
| `addModuleScript(cJS)` / `addModuleScriptSrc(cSrc)` | ES module |
| `addNoScript(cHTML)` | `<noscript>` fallback |
| `addClickButton(cText, cJSCode, aOptions)` | Button with `onclick` |
| `addEventElement(cTag, cContent, cEvent, cJSCode, aAttrs)` | Element with any event handler |
| `addElementById`, `addDivById`, `openDivById`, `openDivByIdClass`, `openDivByClass`, `addJSPlaceholder` | Elements targeted by JavaScript |
| `addJSCounter(cID, cLabel, cStartVal, aOptions)` | Counter with buttons |
| `addJSToggle(cButtonText, cContentId, cContentHTML, aOptions)` | Show/hide content |
| `addJSTabs(cTabId, aTabs)` | JavaScript tabs |
| `addJSSlideshow(cID, aImages, aOptions)` | Image slideshow |
| `addJSCountdown(cID, cTargetDate, aOptions)` | Countdown timer |
| `addJSTypingEffect(cID, cText, aOptions)` | Typing animation |
| `addJSScrollProgress(aOptions)` | Scroll progress bar |
| `addJSDarkModeToggle(aOptions)` | Dark mode toggle |
| `addJSSmoothScroll()` / `addJSBackToTop(aOptions)` | Scrolling helpers |
| `addJSFormValidation(cFormId, aRules)` / `addJSCharCounter(cInputId, nMaxChars)` | Form helpers |
| `addJSFilterList(cID, aItems, aOptions)` | Searchable list |
| `addJSSortableTable(cID, aData, aOptions)` | Sortable table |
| `addJSCopyButton(cText, cContentToCopy, aOptions)` | Copy to clipboard |
| `addJSTooltip(cText, cTipText, aOptions)` | JavaScript tooltip |
| `addJSNotification(aOptions)` | Toast notification |
| `addJSCollapsible(cTitle, cContentHTML, aOptions)` | Collapsible section |
| `addJSAnimatedNumber(cID, cTargetNumber, aOptions)` | Animated number |
| `enableChartJS()` / `addJSChart(cID, cChartType, aLabels, aDatasets, aOptions)` | Chart.js charts (bar, line, pie, doughnut, ...) |

#### Bootstrap, Icons and Code Highlighting

| Method | Description |
|--------|-------------|
| `enableBootstrap()` / `enableBootstrapVersion(cVer)` | Bootstrap 5 (CSS and JS) |
| `enableBootstrapIcons()` / `enableFontAwesome()` / `enableFontAwesomeVersion(cVer)` | Icon fonts |
| `enableHighlightJS()` / `enableHighlightTheme(cThemeName)` | Highlight.js |
| `bsOpenContainer(cType)`, `bsOpenRow(cExtraClass)`, `bsOpenCol(cColClass)` and their `bsClose*()` methods | Grid system |
| `bsNavbar(cBrand, cBrandHref, aItems, cColorScheme)` | Responsive navbar from `[text, href, lActive]` items |
| `bsCard(cTitle, cBody, aOptions)` / `bsCardRaw(...)` | Card |
| `bsAlert(cMessage, cType, lDismissible)` | Alert |
| `bsButton`, `bsLinkButton`, `bsOutlineButton` | Buttons |
| `bsBadge(cText, cType)` | Badge |
| `bsTable(aData, aOptions)` | Table |
| `bsAccordion(cID, aItems)` | Accordion |
| `bsModal(cID, cTitle, cBodyHtml, aOptions)` / `bsModalButton(...)` | Modal |
| `bsProgress(nPercent, cType, lStriped, lAnimated)` / `bsSpinner(cType, cVariant)` | Progress and spinner |
| `bsBreadcrumb(aItems)` / `bsPagination(...)` / `bsListGroup(aItems, aOptions)` | Navigation and lists |
| `bsFormGroup`, `bsFormSelect`, `bsFormTextarea` | Form controls |
| `bsCarousel(cID, aSlides)` / `bsToast(cTitle, cMessage, cTime)` | Carousel and toast |
| `bsIcon(cName)` / `faIcon(cName, cStyle)` / `bsIconText(cIconName, cText)` | Return icon HTML |

#### Themes and Landing Pages

| Method | Description |
|--------|-------------|
| `setTheme(cThemeName)` | "professional", "elegant", "modern", "dark", "nature" or "arabic" |
| `addHero(cTitle, cSubtitle, cCTAText, cCTAHref, aOptions)` | Hero section |
| `addFeatureGrid(aFeatures, nColumns)` | Feature grid |
| `addStatsBar(aStats, aOptions)` | Statistics bar |
| `addTimeline(aEvents)` | Timeline |
| `addPricingTable(aPlans)` | Pricing table |
| `addTestimonial(cQuote, cAuthorName, cAuthorTitle, cAvatarURL)` | Testimonial |
| `addGallery(aImages, nColumns)` | Image gallery |
| `addTableOfContents(cTitle, aItems)` | Table of contents |
| `addSocialLinks(aLinks, aOptions)` / `addPageFooter(cText, aLinks, aOptions)` | Footer helpers |
| `addPrintStyles()`, `enableSmoothScroll()`, `addBackToTop()` | Page helpers |

#### Three.js (3D)

Call `enableThreeJS()`, create a scene with `threeJSScene(cCanvasId, aOptions)`, add objects, then call `threeJSAnimate(cCanvasId)` once at the end. Objects are identified by the JavaScript variable name you give them (`cName`).

| Area | Methods |
|------|---------|
| Scene | `threeJSScene`, `threeJSAnimate`, `threeJSBackground`, `threeJSFog`, `threeJSGridHelper`, `threeJSAxesHelper`, `threeJSSkybox`, `threeJSCubeTexture`, `threeJSCubeEnvMap`, `threeJSEnvMapMesh` |
| Meshes | `threeJSBox`, `threeJSSphere`, `threeJSCylinder`, `threeJSPlane`, `threeJSCone`, `threeJSTorus`, `threeJSTorusKnot`, `threeJSRing`, `threeJSDodecahedron`, `threeJSIcosahedron`, `threeJSOctahedron`, `threeJSMesh`, `threeJSClone`, `threeJSGroup`, `threeJSAddToGroup` |
| Lights and shadows | `threeJSAmbientLight`, `threeJSDirectionalLight`, `threeJSPointLight`, `threeJSSpotLight`, `threeJSHemisphereLight`, `threeJSEnableShadows`, `threeJSShadowConfig`, `threeJSMeshShadow` |
| Textures | `threeJSTexture`, `threeJSTextureApply`, `threeJSTerrainTexture`, `threeJSVideoTexture` |
| Animation | `threeJSOnAnimate`, `threeJSAutoRotate`, `threeJSBob`, `threeJSOrbit`, `threeJSPulse`, `threeJSParticles` |
| Interaction | `threeJSMouseLook`, `enableOrbitControls` + `threeJSOrbitControls`, `threeJSKeyboardControls`, `threeJSCameraFollow`, `threeJSRaycast`, `threeJSHover`, `threeJSDragControls`, `threeJSCollisionCheck` |
| HUD and games | `threeJSOverlay`, `threeJSUpdateHUD`, `threeJSGameVar`, `threeJSRaw` |
| Shaders | `threeJSShaderMaterial`, `threeJSApplyShader`, `threeJSSetUniform`, `threeJSShaderMouse`, `threeJSShaderTexture`, presets: `threeJSShaderGradient`, `threeJSShaderWave`, `threeJSShaderFresnel`, `threeJSShaderNoise`, `threeJSShaderHologram`, `threeJSShaderFire`, `threeJSShaderWater`, `threeJSShaderDissolve`, `threeJSShaderShield` |
| Post-processing | `enablePostProcessing`, `threeJSPostProcessing`, `threeJSBloom`, `threeJSFXAA`, `threeJSFilmGrain`, `threeJSGlitchPass`, `threeJSDotScreen`, `threeJSVignette`, `threeJSCustomPass`, `threeJSPostProcessAnimate`, `enableOutlinePass`, `threeJSOutlineInit`, `threeJSOutlineObjects`, `threeJSOutlineOnHover`, `threeJSOutlineOnClick` |
| Models | `enableGLTFLoader`, `enableOBJLoader`, `enableMTLLoader`, `enableFBXLoader`, `enableColladaLoader`, `enableDracoDecoder`, `threeJSLoadGLTF`, `threeJSLoadOBJ`, `threeJSLoadFBX`, `threeJSLoadCollada`, `threeJSLoadingScreen`, `threeJSHideLoading`, `threeJSUpdateLoadingProgress` |
| Model animation | `threeJSPlayAnimation`, `threeJSStopAnimations`, `threeJSAnimationSpeed`, `threeJSPauseAnimation`, `threeJSResumeAnimation`, `threeJSAnimStateMachine`, `threeJSLoadAnimation`, `threeJSOnAnimationFinished`, `threeJSLogAnimations` |
| Audio | `threeJSAudioListener`, `threeJSBackgroundMusic`, `threeJSPositionalAudio`, `threeJSSoundEffect`, `threeJSSetVolume`, `threeJSTone`, `threeJSAmbientTone` |
| Sprites, lines and geometry | `threeJSSprite`, `threeJSTextSprite`, `threeJSLine`, `threeJSCurve`, `threeJSTube`, `threeJSExtrude`, `threeJSLathe`, `threeJSExtrudeAlongPath`, `threeJSInstancedMesh`, `threeJSInstancedColors`, `threeJSLOD`, `threeJSLODPreset`, `enableReflector` + `threeJSMirror` |
| Terrain | `threeJSTerrain`, `threeJSTerrainHeight` |
| Physics (Cannon.js) | `enablePhysics`, `threeJSPhysicsWorld`, `threeJSPhysicsBody`, `threeJSPhysicsGround`, `threeJSApplyForce`, `threeJSApplyImpulse`, `threeJSSetVelocity`, `threeJSSetAngularVelocity`, `threeJSOnCollide`, `threeJSPhysicsConstraint`, `threeJSPhysicsSpawn` |
| Tweening (GSAP) | `enableGSAP`, `threeJSTween`, `threeJSTweenFrom`, `threeJSTimeline`, `threeJSTimelineAdd`, `threeJSTweenRaw`, `threeJSTweenColor`, `threeJSTweenCamera`, `threeJSDelayedCall` |
| 3D text and labels | `threeJSText`, `enableTextGeometry`, `threeJSText3D`, `threeJSText3DMulti`, `enableCSS2DRenderer`, `threeJSCSS2DInit`, `threeJSCSS2DLabel`, `threeJSCSS2DUpdate`, `threeJSCSS2DToggle`, `threeJSCSS2DBar`, `threeJSCSS2DBarUpdate` |

The options supported by each method are documented in the comments above the method in `htmlwriter.ring`, and the samples show them in use.

#### Output

| Method | Description |
|--------|-------------|
| `render()` | Return the complete HTML document as a string |
| `save(cFileName)` | Write the document to a file; returns true |
| `getContentSize()` | Return the length of the rendered document |

---

## Samples

The package comes with 89 samples in `ring/samples/UsingHTMLLib`. Each sample writes one or more `.html` files to the current folder.

| Samples | Topic |
|---------|-------|
| test01 - test11 | HTML basics: text, lists, tables, forms, layouts, components, RTL, CSS, dashboard, `quickHTML()` |
| test12 - test19 | JavaScript components and Chart.js |
| test20 - test24 | Bootstrap, themes and landing pages |
| test25 - test32 | Three.js basics: shapes, solar system, materials, particles, a 3D game |
| test33 - test44 | Raycasting, shadows, orbit controls, post-processing, sprites, lines, instancing, dragging, mirrors, audio |
| test45 - test49 | Textures |
| test50 - test59 | Shaders |
| test60 - test65 | Loading 3D models and animations |
| test66 - test75 | Physics, tweening and 3D text |
| test76 - test83 | Terrain, CSS2D labels, extrude/lathe, outlines, LOD |
| test84 - test88 | Complete 3D games |
| test89 | 3D tree visualization |

## License

MIT License
