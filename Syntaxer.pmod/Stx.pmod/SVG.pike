//| Generated by stxparser
//|
//| Inherit main class. If you'r creating a tag based syntax file inherit
//| HTML in Markup.pmod instead.
inherit .Markup.HTMLParser;

//! The name of the language
public string title = "SVG";

//! Is the language case sensitive or not?
//!
//! @appears case_sensitive
protected int(0..1) _case_sensitive = 1;

//! Is the language HTML embedded or not?
//!
//! @appears html_embedded
public int(0..1) _html_embedded = 0;

//! Escape char of the language. Like backslash for most C-like languages.
//!
//! @appears escape
protected string _escape = "";

//! Delimiters like (, ), ; and so on
//!
//! @appears delimiters
protected multiset(string) _delimiters = (< "<",">","/","=","\"","'","%","(",")","{","}","[","]","-","+","*" >);

//! Array of chars defining strings
//!
//! @appears quotes
protected array(string) _quotes = ({ "\"","'" });

//! What's a line comment. Like for PHP: ({ "//", "#" })
//!
//! @appears linecomment
protected array(string) _linecomments = ({ "//" });

//! The colors mapping defines how things should be colorized. Each index should
//! correspond to either the name of a base class variable containing some syntax
//! information - like "blockcomments" for instance - or an index in the
//! "keywords" mapping. The value should be a hexadecimal color definition.
//!
//! An example:
//!
//!   colors = ([
//!     "blockcomment"       : "#aaa",
//!     "linecomment"        : "#aaa",
//!     "delimiter"          : "#00c"
//!     "built-in-functions" : "#900"
//!   ]);
//!
//! There are a few generic indexes that are being used:
//!
//!   1. default:      For text that's not matching any rules
//!   2. delimiter:    For language delimiters.
//!   3. quote:        For strings
//!   4. numeric:      For numbers
//!   5. linecomment:  For line comments
//!   6. blockcomment: For block comments
//!   7. preprocessor: For preprocessor instructions (like <?php ?>)
//!   8. macro:        For macro directives like C's #define MACRO
//!
//! @appears colors
protected mapping(string:string) _colors = ([
  "default"      : "#000",
  "delimiter"    : "#00C",
  "quote"        : "#070",
  "numeric"      : "purple",
  "linecomment"  : "#818A9E",
  "blockcomment" : "#818A9E",
  "preprocessor" : "lime",
  "macro"        : "#99510a",

  //| NOTE!!! The ones below is auto generated. Check that they correspond to
  //| the indices in "_keywords". And you might want to change the colors!
  "xml-keyword"               : "#8a0e0e",
  "xml-attribute-types"       : "#049a04",
  "xml-pi-attribute"          : "#044",
  "xml-attribute-defaults"    : "#0d0dba",
  "svg-attributes"            : "#ca0f0f",
  "xml-declearation"          : "#da0a0a",
  "svg-elements"              : "#006"
]);

//! Definitions for stuff that you want to add extra HTML around.
//! An example:
//!
//!   styles = ([
//!      "keywords"     : ({ "<b>", "</b>" }),
//!      "preprocessor" : ({ "<b style='background: black;'>", "</b>" }),
//!      "macro"        : ({ "<b>", "</b>" })
//!   ]);
//!
//! The indices works in the same way as for colors.
//!
//! @appears styles
protected mapping(string:array(string)) _styles = ([]);

//! Some languages like PHP, Perl, Ruby has some variable prefixes
//! like $, @, % so we can use them to highlight these variables
//! differently. The key should be an identifier to lookup in the
//! colors mapping and the value should be the actual prefix.
//! It could look like this for Perl:
//!
//!   prefixes = ([
//!     "prefix1" : "$",
//!     "prefix2" : "%",
//!     "prefix3" : "@"
//!   ])
//!
//! or if you want all prefixes to be colorized the same way
//!
//!   prefixes = ([
//!     "prefix" : ({ "$", "%", "@" })
//!   ]);
//!
//! @appears prefixes
protected mapping(string:string|array) _prefixes = ([ "prefix" : ({ "<![CDATA[" }) ]);

//! Definition of blockcomments. This should be an array if arrays where the
//! second array should contain two values: The first the pattern that starts
//! a block comment and the second the pattern that ends it.
//! Example: ({ ({ "/*", "*/" }) })
//!
//! @appears blockcomments
protected array(array(string)) _blockcomments = ({ ({ "<!--","-->" }), ({ "/*","*/" }) });

//! HTML embedded languages use preprocessor instructions to tell when
//! the actual program code starts and ends. Add them here...
//! PHP would look like this:
//! ({
//!   ({ "<?php", "?>" }),
//!   ({ "<?", "?>" })
//! })
//!
//! @appears preprocs
protected array(array(string)) _preprocs = ({  });

/*******************************************************************************
 *                                                                             *
 *    NOTE! Uncomment the following variables if the language supports         *
 *    preprocessing macros. Otherwise the default values will apply.           *
 *                                                                             *
 ******************************************************************************/

//! For languages that has preprocessing macros
// protected int(0..1) macro = 1;

//! Can the macro start off of the first char. C# allows for this
// protected int(0..1) macro_indent = 0;

//! Default macro character
// protected string macro_char = "#";

//! Language keywords
//!
//! @appears keywords
protected mapping(string:multiset(string)) _keywords = ([
  "xml-keyword" : (<
    "INCLUDE","IGNORE","SYSTEM","PUBLIC","NDATA","^#PCDATA","EMPTY",
    "ANY","UTF-8","utf-8","utf-16","UTF-16","ISO-10646-UCS-2",
    "ISO-10646-UCS-4","ISO-8859-1","ISO-8859-2","ISO-8859-9","ISO-2022-JP",
    "Shift_JIS","EUC-JP","euc-kr","EUC-KR" >),

  "xml-attribute-types" : (<
    "CDATA","ID","IDREF","IDREFS","ENTITY","ENTITIES","NMTOKEN",
    "NMTOKENS" >),

  "xml-pi-attribute" : (<
    "version","encoding","standalone","type","href","title","media",
    "charset","alternate","xml:space","preserve","default","xml:lang",
    "xmlns","xmlns:xlink","xmlns:svg" >),

  "xml-attribute-defaults" : (<
    "^#REQUIRED","^#IMPLIED","^#FIXED" >),

  "svg-attributes" : (<
    "accumulate","additive","amplitude","attributeName","attributeType",
    "azimuth","baseFrequency","begin","by","calcMode","class",
    "clipPathUnits","cx","cy","d","diffuseConstant","dur","dx","dy",
    "elevation","enableZoomAndPanControls","end","exponent","fill",
    "filterUnits","from","fx","fy","gradientTransform","gradientUnits",
    "height","id","transform","in","in2","intercept","k1","k2","k3","k4",
    "keyPoints","keySplines","keyTimes","lightColor","maskUnits","mode",
    "numOctaves","offset","onabort","onblur","onchange","onclick",
    "ondblclick","onerror","onfocus","onkeydown","onkeypress","onkeyup",
    "onload","onmousedown","onmousemove","onmouseout","onmouseover",
    "onmouseup","onreset","onselect","onsubmit","onunload","operator",
    "origin","path","points","pointsAtX","pointsAtY","pointsAtZ",
    "preserveAspectRatio","r","radius","repeatCount","repeatDur","restart",
    "result","resultScale","rotate","rx","ry","scale","slope",
    "specularConstant","specularExponent","stdDeviation","style",
    "surfaceScale","tableValues","to","type","values","viewBox","width","x",
    "x1","x2","xChannelSelector","xlink:href","xml:space","y","y1","y2",
    "yChannelSelector","z","stop-color","spreadmethod","font-family",
    "font-size", "font-weight","stop-opacity" >),

  "xml-declearation" : (<
    "?xml","?xml-stylesheet","!DOCTYPE","!ENTITY","!ELEMENT","!ATTLIST",
    "!NOTATION" >),

  "svg-elements" : (<
    "a","animate","animateColor","animateMotion","animateTransform",
    "circle","clipPath","defs","ellipse","feBlend","feComponentTransfer",
    "feComposite","feDiffuseLighting","feDisplacementMap","feDistantLight",
    "feFlood","feFuncA","feFuncB","feFuncG","feFuncR","feGaussianBlur",
    "feMerge","feMergeNode","feMorphology","feOffset","fePointLight",
    "feSpecularLighting","feSpotLight","feTurbulence","filter","g","image",
    "line","linearGradient","mask","path","polygon","polyline",
    "radialGradient","rect","script","set","stop","svg","text","textPath",
    "textRef","tspan","use","?xml","?","<","/",">" >)
]);

//! Constructor
//!
//! If you don't want to override one or more variables just comment them out
//! or remove them. If you wan't to add to the default variables just add a +
//! in front of =.
void create()
{
  linecomments   = _linecomments;
  delimiters     = _delimiters;
  blockcomments  = _blockcomments;
  prefixes       = _prefixes;
  colors         = _colors;
  styles         = _styles;
  preprocs       = _preprocs;
  html_embedded  = _html_embedded;
  case_sensitive = _case_sensitive;
  escape         = _escape;
  quotes         = _quotes;
  keywords       = _keywords;

  ::create();
  
  kw_order = indices(keywords) - ({ "svg-elements" }) - ({ "svg-attributes " });
  kw_order = ({ "svg-elements", "svg-attributes" }) + kw_order;
}