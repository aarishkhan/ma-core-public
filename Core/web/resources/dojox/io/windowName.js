//>>built
define("dojox/io/windowName","dojo/_base/kernel dojo/_base/window dojo/_base/xhr dojo/_base/sniff dojo/_base/url dojo/domReady!".split(" "),function(d){d.getObject("io.windowName",!0,dojox);dojox.io.windowName={send:function(p,a){a.url+=(a.url.match(/\?/)?"\x26":"?")+"windowname\x3d"+(a.authElement?"auth":!0);var k=a.authElement,m=function(a){try{var h=g.ioArgs.frame.contentWindow.document;h.write(" ");h.close()}catch(m){}(k||d.body()).removeChild(g.ioArgs.outerFrame);return a},g=d._ioSetArgs(a,m,
m,m);a.timeout&&setTimeout(function(){-1==g.fired&&g.callback(Error("Timeout"))},a.timeout);dojox.io.windowName._send(g,p,k,a.onAuthLoad);return g},_send:function(p,a,k,m){function g(a){a.style.width="100%";a.style.height="100%";a.style.border="0px"}var l=p.ioArgs,h=dojox.io.windowName._frameNum++,t=(d.config.dojoBlankHtmlUrl||d.config.dojoCallbackUrl||d.moduleUrl("dojo","resources/blank.html"))+"#"+h,q=new d._Url(window.location,t),e=d.doc,f=k||d.body();if(d.isMoz&&![].reduce){var b=e.createElement("iframe");
g(b);k||(b.style.display="none");f.appendChild(b);f=b.contentWindow;e=f.document;e.write("\x3chtml\x3e\x3cbody margin\x3d'0px'\x3e\x3ciframe style\x3d'width:100%;height:100%;border:0px' name\x3d'protectedFrame'\x3e\x3c/iframe\x3e\x3c/body\x3e\x3c/html\x3e");e.close();e=f[0];f.__defineGetter__(0,function(){});f.__defineGetter__("protectedFrame",function(){});e=e.document;e.write("\x3chtml\x3e\x3cbody margin\x3d'0px'\x3e\x3c/body\x3e\x3c/html\x3e");e.close();f=e.body}var c;if(d.isIE){var n=e.createElement("div");
n.innerHTML='\x3ciframe name\x3d"'+q+'" onload\x3d"dojox.io.windowName['+h+']()"\x3e';c=n.firstChild}else c=e.createElement("iframe");l.frame=c;g(c);l.outerFrame=b=b||c;k||(b.style.display="none");var r=0;dojox.io.windowName[h]=c.onload=function(){try{if(!d.isMoz&&"about:blank"==c.contentWindow.location)return}catch(a){}r||(r=1,k?m&&m():c.contentWindow.location=t);try{if(2>r){var b=c.contentWindow.name;"string"==typeof b&&b!=q&&(r=2,p.ioArgs.hash=c.contentWindow.location.hash,p.callback(b))}}catch(e){}};
c.name=q;if(a.match(/GET/i))d._ioAddQueryToUrl(l),c.src=l.url,f.appendChild(c),c.contentWindow&&c.contentWindow.location.replace(l.url);else if(a.match(/POST/i)){f.appendChild(c);a=d.doc.createElement("form");d.body().appendChild(a);var h=d.queryToObject(l.query),s;for(s in h){b=h[s];b=b instanceof Array?b:[b];for(f=0;f<b.length;f++)n=e.createElement("input"),n.type="hidden",n.name=s,n.value=b[f],a.appendChild(n)}a.method="POST";a.action=l.url;a.target=q;a.submit();a.parentNode.removeChild(a)}else throw Error("Method "+
a+" not supported with the windowName transport");c.contentWindow&&(c.contentWindow.name=q)},_frameNum:0};return dojox.io.windowName});
//@ sourceMappingURL=windowName.js.map