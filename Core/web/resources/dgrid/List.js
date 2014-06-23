//>>built
define("dgrid/List","dojo/_base/kernel dojo/_base/declare dojo/on dojo/has ./util/misc dojo/has!touch?./TouchScroll xstyle/has-class put-selector/put dojo/_base/sniff xstyle/css!./css/dgrid.css".split(" "),function(v,w,p,d,q,C,D,h){function x(a,b){var c=document.body,g;h(c,a,".dgrid-scrollbar-measure");g=a["offset"+b]-a["client"+b];h(a,"!dgrid-scrollbar-measure");c.removeChild(a);return g}function s(a){var b=a?"."+a.replace(y,"."):"";this._class&&(b="!"+this._class.replace(y,"!")+b);h(this.domNode,
b);this._class=a}function z(){return this._class}function A(){return{x:this.bodyNode.scrollLeft,y:this.bodyNode.scrollTop}}function B(a){"undefined"!==typeof a.x&&(this.bodyNode.scrollLeft=a.x);"undefined"!==typeof a.y&&(this.bodyNode.scrollTop=a.y)}D("mozilla","opera","webkit","ie","ie-6","ie-6-7","quirks","no-quirks","touch");var l,u;d.add("dom-scrollbar-width",function(a,b,c){return x(c,"Width")});d.add("dom-scrollbar-height",function(a,b,c){return x(c,"Height")});var E=0,y=/ +/g,F=7>d("ie")&&
!d("quirks")?function(){var a,b,c;if(this._started&&(a=document.documentElement,b=a.clientWidth,a=a.clientHeight,c=this._prevWinDims||[],c[0]!==b||c[1]!==a))this.resize(),this._prevWinDims=[b,a]}:function(){this._started&&this.resize()};return w(d("touch")?C:null,{tabableHeader:!1,showHeader:!1,showFooter:!1,maintainOddEven:!0,cleanAddedRules:!0,useTouchScroll:!0,postscript:function(a,b){var c=this;(this._Row=function(a,b,c){this.id=a;this.data=b;this.element=c}).prototype.remove=function(){c.removeRow(this.element)};
b&&(this.srcNodeRef=b=b.nodeType?b:document.getElementById(b));this.create(a,b)},listType:"list",create:function(a,b){var c=this.domNode=b||h("div"),g;a?(this.params=a,w.safeMixin(this,a),g=a["class"]||a.className||c.className,this._sort=a.sort||[],delete this.sort):this._sort=[];this.observers=[];this._numObservers=0;this._listeners=[];this._rowIdToObject={};this.postMixInProperties&&this.postMixInProperties();this.id=c.id=c.id||this.id||"dgrid_"+E++;this.buildRendering();g&&s.call(this,g);this.postCreate();
delete this.srcNodeRef;this.domNode.offsetHeight&&this.startup()},buildRendering:function(){var a=this.domNode,b=this,c,g,e,f;f=this.isRTL="rtl"==(document.body.dir||document.documentElement.dir||document.body.style.direction).toLowerCase();a.className="";h(a,"[role\x3dgrid].ui-widget.dgrid.dgrid-"+this.listType);c=this.headerNode=h(a,"div.dgrid-header.dgrid-header-row.ui-widget-header"+(this.showHeader?"":".dgrid-header-hidden"));(d("quirks")||8>d("ie"))&&h(a,"div.dgrid-spacer");g=this.bodyNode=
h(a,"div.dgrid-scroller");g.tabIndex=-1;this.headerScrollNode=h(a,"div.dgrid-header-scroll.dgrid-scrollbar-width.ui-widget-header");e=this.footerNode=h("div.dgrid-footer"+(this.showFooter?"":".dgrid-footer-hidden"));h(a,e);f&&(a.className+=" dgrid-rtl"+(d("webkit")?"":" dgrid-rtl-nonwebkit"));p(g,"scroll",function(e){b.showHeader&&(c.scrollLeft=e.scrollLeft||g.scrollLeft);e.stopPropagation();p.emit(a,"scroll",{scrollTarget:g})});this.configStructure();this.renderHeader();this.contentNode=this.touchNode=
h(this.bodyNode,"div.dgrid-content.ui-widget-content");this._listeners.push(this._resizeHandle=p(window,"resize",q.throttleDelayed(F,this)))},postCreate:d("touch")?function(){this.useTouchScroll&&this.inherited(arguments)}:function(){},startup:function(){this._started||(this.inherited(arguments),this._started=!0,this.resize(),this.set("sort",this._sort))},configStructure:function(){},resize:function(){var a=this.bodyNode,b=this.headerNode,c=this.footerNode,g=b.offsetHeight,e=this.showFooter?c.offsetHeight:
0,f=d("quirks")||7>d("ie");this.headerScrollNode.style.height=a.style.marginTop=g+"px";a.style.marginBottom=e+"px";f&&(a.style.height="",a.style.height=Math.max(this.domNode.offsetHeight-g-e,0)+"px",e&&(c.style.bottom="1px",setTimeout(function(){c.style.bottom=""},0)));l||(l=d("dom-scrollbar-width"),u=d("dom-scrollbar-height"),d("ie")&&(l++,u++),q.addCssRule(".dgrid-scrollbar-width","width: "+l+"px"),q.addCssRule(".dgrid-scrollbar-height","height: "+u+"px"),17!=l&&!f&&(q.addCssRule(".dgrid-header",
"right: "+l+"px"),q.addCssRule(".dgrid-rtl-nonwebkit .dgrid-header","left: "+l+"px")));f&&(b.style.width=a.clientWidth+"px",setTimeout(function(){b.scrollLeft=a.scrollLeft},0))},addCssRule:function(a,b){var c=q.addCssRule(a,b);this.cleanAddedRules&&this._listeners.push(c);return c},on:function(a,b){var c=p(this.domNode,a,b);d("dom-addeventlistener")||this._listeners.push(c);return c},cleanup:function(){var a=this.observers,b;for(b in this._rowIdToObject)if(this._rowIdToObject[b]!=this.columns){var c=
document.getElementById(b);c&&this.removeRow(c,!0)}for(b=0;b<a.length;b++)(c=a[b])&&c.cancel();this.observers=[];this._numObservers=0;this.preload=null},destroy:function(){if(this._listeners){for(var a=this._listeners.length;a--;)this._listeners[a].remove();delete this._listeners}this.cleanup();h(this.domNode,"!");this.inherited(arguments)},refresh:function(){this.cleanup();this._rowIdToObject={};this._autoId=0;this.contentNode.innerHTML="";this.scrollTo({x:0,y:0})},newRow:function(a,b,c,g,e){if(b){var f=
this.insertRow(a,b,c,g,e);h(f,".ui-state-highlight");setTimeout(function(){h(f,"!ui-state-highlight")},250);return f}},adjustRowIndices:function(a){var b=a.rowIndex;if(-1<b){do-1<a.rowIndex&&(this.maintainOddEven&&-1<(a.className+" ").indexOf("dgrid-row ")&&h(a,"."+(1==b%2?"dgrid-row-odd":"dgrid-row-even")+"!"+(0==b%2?"dgrid-row-odd":"dgrid-row-even")),a.rowIndex=b++);while((a=a.nextSibling)&&a.rowIndex!=b)}},renderArray:function(a,b,c){function g(a){t=k.insertRow(a,q,null,h++,c);t.observerIndex=
r;return t}function e(a){"undefined"!==typeof r&&(d[r].cancel(),d[r]=0,k._numObservers--);if(a)throw a;}function f(a){(l=b?b.parentNode:k.contentNode)&&l.parentNode&&(l!==k.contentNode||a.length)?(l.insertBefore(q,b||null),(t=a[a.length-1])&&k.adjustRowIndices(t)):d[r]&&e();return m=a}c=c||{};var k=this,h=c.start||0,d=this.observers,n,m,l,r;b||(this._lastCollection=a);a.observe&&(k._numObservers++,r=d.push(a.observe(function(a,e,g){var f,d,h;-1<e&&m[e]&&(n=m.splice(e,1)[0],n.parentNode==l&&((f=n.nextSibling)&&
e!=g&&f.rowIndex--,k.removeRow(n)),k._processScroll&&k._processScroll());if(-1<g){if(m.length){if(d=m[g],!d&&(d=m[g-1]))d=(d.connected||d).nextSibling}else d=k._getFirstRowSibling&&k._getFirstRowSibling(l);h=b&&b.parentNode||d&&d.parentNode||k.contentNode;if(n=k.newRow(a,h,d,c.start+g,c))if(n.observerIndex=r,m.splice(g,0,n),!f||g<e)f=n.previousSibling,f=!f||f.rowIndex+1==n.rowIndex||0==n.rowIndex?n:f;c.count++}e!=g&&f&&k.adjustRowIndices(f);k._onNotification(m,a,e,g)},!0))-1);var q=document.createDocumentFragment(),
t;if(a.map){if(m=a.map(g,console.error),m.then)return m.then(f,e)}else{m=[];for(var p=0,s=a.length;p<s;p++)m[p]=g(a[p])}return f(m)},_onNotification:function(a,b,c,g){},renderHeader:function(){},_autoId:0,insertRow:function(a,b,c,g,e){var f=e.parentId,f=this.id+"-row-"+(f?f+"-":"")+(this.store&&this.store.getIdentity?this.store.getIdentity(a):this._autoId++),d=document.getElementById(f),h=d&&d.previousSibling;d&&this.removeRow(d);d=this.renderRow(a,e);d.className=(d.className||"")+" ui-state-default dgrid-row "+
(1==g%2?"dgrid-row-odd":"dgrid-row-even");this._rowIdToObject[d.id=f]=a;b.insertBefore(d,c||null);h&&this.adjustRowIndices(h);d.rowIndex=g;return d},renderRow:function(a,b){return h("div",""+a)},removeRow:function(a,b){a=a.element||a;delete this._rowIdToObject[a.id];b||h(a,"!")},row:function(a){var b;if(a instanceof this._Row)return a;a.target&&a.target.nodeType&&(a=a.target);if(a.nodeType){do{var c=a.id;if(b=this._rowIdToObject[c])return new this._Row(c.substring(this.id.length+5),b,a);a=a.parentNode}while(a&&
a!=this.domNode)}else return"object"==typeof a?b=this.store.getIdentity(a):(b=a,a=this._rowIdToObject[this.id+"-row-"+b]),new this._Row(b,a,document.getElementById(this.id+"-row-"+b))},cell:function(a){return{row:this.row(a)}},_move:function(a,b,c,d){var e,f;f=e=a.element;b=b||1;do if(a=e[0>b?"previousSibling":"nextSibling"]){do if((e=a)&&-1<(e.className+" ").indexOf(c+" ")){f=e;b+=0>b?1:-1;break}while(a=(!d||!e.hidden)&&e[0>b?"lastChild":"firstChild"])}else if(e=e.parentNode,e===this.bodyNode||e===
this.headerNode)break;while(b);return f},up:function(a,b,c){a.element||(a=this.row(a));return this.row(this._move(a,-(b||1),"dgrid-row",c))},down:function(a,b,c){a.element||(a=this.row(a));return this.row(this._move(a,b||1,"dgrid-row",c))},scrollTo:d("touch")?function(a){return this.useTouchScroll?this.inherited(arguments):B.call(this,a)}:B,getScrollPosition:d("touch")?function(){return this.useTouchScroll?this.inherited(arguments):A.call(this)}:A,get:function(a){var b="_get"+a.charAt(0).toUpperCase()+
a.slice(1);return"function"===typeof this[b]?this[b].apply(this,[].slice.call(arguments,1)):this[a]},set:function(a,b){if("object"===typeof a)for(var c in a)this.set(c,a[c]);else c="_set"+a.charAt(0).toUpperCase()+a.slice(1),"function"===typeof this[c]?this[c].apply(this,[].slice.call(arguments,1)):this[a]=b;return this},_getClass:z,_setClass:s,_getClassName:z,_setClassName:s,_setSort:function(a,b){this._sort="string"!=typeof a?a:[{attribute:a,descending:b}];this.refresh();this._lastCollection&&(a.length&&
("string"!=typeof a&&(b=a[0].descending,a=a[0].attribute),this._lastCollection.sort(function(c,d){var e=c[a],f=d[a];void 0===e&&(e="");void 0===f&&(f="");return e==f?0:e>f==!b?1:-1})),this.renderArray(this._lastCollection))},sort:function(a,b){v.deprecated("sort(...)",'use set("sort", ...) instead',"dgrid 0.4");this.set("sort",a,b)},_getSort:function(){return this._sort},_setShowHeader:function(a){var b=this.headerNode;this.showHeader=a;h(b,(a?"!":".")+"dgrid-header-hidden");this.renderHeader();this.resize();
a&&(b.scrollLeft=this.getScrollPosition().x)},setShowHeader:function(a){v.deprecated("setShowHeader(...)",'use set("showHeader", ...) instead',"dgrid 0.4");this.set("showHeader",a)},_setShowFooter:function(a){this.showFooter=a;h(this.footerNode,(a?"!":".")+"dgrid-footer-hidden");this.resize()}})});
//@ sourceMappingURL=List.js.map