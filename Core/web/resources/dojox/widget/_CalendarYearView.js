//>>built
require({cache:{"url:dojox/widget/Calendar/CalendarYear.html":'\x3cdiv class\x3d"dojoxCalendarYearLabels" style\x3d"left: 0px;" dojoAttachPoint\x3d"yearContainer"\x3e\n    \x3ctable cellspacing\x3d"0" cellpadding\x3d"0" border\x3d"0" style\x3d"margin: auto;" dojoAttachEvent\x3d"onclick: onClick"\x3e\n        \x3ctbody\x3e\n            \x3ctr class\x3d"dojoxCalendarYearGroupTemplate"\x3e\n                \x3ctd class\x3d"dojoxCalendarNextMonth dojoxCalendarYearTemplate"\x3e\n                    \x3cdiv class\x3d"dojoxCalendarYearLabel"\x3e\n                    \x3c/div\x3e\n                \x3c/td\x3e\n            \x3c/tr\x3e\n        \x3c/tbody\x3e\n    \x3c/table\x3e\n\x3c/div\x3e\n'}});
define("dojox/widget/_CalendarYearView","dojo/_base/declare ./_CalendarView dijit/_TemplatedMixin dojo/date dojo/dom-class dojo/_base/event dojo/text!./Calendar/CalendarYear.html ./_CalendarMonthYearView".split(" "),function(c,d,e,f,g,h,k,l){return c("dojox.widget._CalendarYearView",[d,e],{templateString:k,displayedYears:6,postCreate:function(){this.cloneClass(".dojoxCalendarYearTemplate",3);this.cloneClass(".dojoxCalendarYearGroupTemplate",2);this._populateYears();this.addFx(".dojoxCalendarYearLabel",
this.domNode)},_setValueAttr:function(a){this._populateYears(a.getFullYear())},_populateYears:l.prototype._populateYears,adjustDate:function(a,b){return f.add(a,"year",12*b)},onClick:function(a){if(g.contains(a.target,"dojoxCalendarYearLabel")){a=Number(a.target.innerHTML);var b=this.get("value");b.setYear(a);this.onValueSelected(b,a)}else h.stop(a)}})});
//@ sourceMappingURL=_CalendarYearView.js.map