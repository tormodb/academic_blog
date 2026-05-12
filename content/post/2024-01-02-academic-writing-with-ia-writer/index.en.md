---
title: Academic writing with iA Writer
author: Tormod
date: '2024-01-02'
slug: []
categories:
  - writing
tags: []
subtitle: ''
summary: ''
authors: []
lastmod: '2024-01-02T11:32:53+01:00'
featured: no
image:
  caption: ''
  focal_point: ''
  preview_only: no
projects: []
---

I have been trying to set up for academic writing in iA Writer. Although it is possible to export to nicely formatted Word documents from iA, it has not been possible to work with references from Zotero in the way one usually uses these tools when writing directly in for example Word. I have now found a way to do this using a selection of tools:

-   [Zotero](https://www.zotero.org) using the [Better Bibtex plugin](https://retorque.re/zotero-better-bibtex/) and a bibtex expoerted copy of my Zotero library
-   [The Alfred citation picker](https://github.com/chrisgrieser/alfred-bibtex-citation-picker)
-   [the DocDown utility](https://raphaelkabo.com/blog/introducing-docdown/)
-   [iA Writer](https://ia.net/writer)

After configuring all the tools according to instructions on the pages linked to above, I am now able to hit a shortcut to trigger Alfred to search the libraray for the citation of choice, enter that into my iA Writer document and drag the file over the DocDown uility and get a Word file ready, either with references inserted or with "[live citations](https://retorque.re/zotero-better-bibtex/exporting/pandoc/#from-markdown-to-zotero-live-citations)" that I can manipulate in the resulting Word file.

There are multiple ways of using these tools, and both reference documents and CSL are supported, so you have all the options from pandoc and Zotero intact, but wrapped into a nice tool that lives in your taskbar.

Note! The new version of iA Writer has some [new fancy methods for working with AI-generated content](https://ia.net/topics/ia-writer-7). To keep track of the annotations and authors, an annotation block is added to the file, looking like this:

```         
Markdown Annotations embed authorship in text while preserving its readability and portability.

---
Annotations: 0,95 SHA-256 1132bf5e376a605f5beed4b204456114  
@Human: 0,20 33,4 45,6 62,4  
&AI: 20,13 37,8 51,11 66,29  
...
```

Although this new Markdown is [well-documented](https://github.com/iainc/Markdown-Annotations), but currently breaks rendering with pandoc using the tools described above. I therefore have to manually comment out this extra content before dropping in into DocDown if I want to render.
