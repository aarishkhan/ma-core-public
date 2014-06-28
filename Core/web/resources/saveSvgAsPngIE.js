(function() {
  var out$ = typeof exports != 'undefined' && exports || this;

  var doctype = '<?xml version="1.0" standalone="no"?><!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">';

  function inlineImages(callback) {
    var images = document.querySelectorAll('svg image');
    var left = images.length;
    if (left == 0) {
      callback();
    }
    for (var i = 0; i < images.length; i++) {
      (function(image) {
        var canvas = document.createElement('canvas');
        var ctx = canvas.getContext('2d');
        var img = new Image();
        img.src = image.getAttribute('xlink:href');
        img.onload = function() {
          canvas.width = img.width;
          canvas.height = img.height;
          ctx.drawImage(img, 0, 0);
          image.setAttribute('xlink:href', canvas.toDataURL('image/png'));
          left--;
          if (left == 0) {
            callback();
          }
        }
      })(images[i]);
    }
  }
    function moveChildren(src, dest) {
        if(src.children){
            while (src.children.length > 0) {
                var child = src.children[0];
                dest.appendChild(child);
            }
        }
        else{
            while (src.childNodes.length > 0) {
                var child = src.childNodes[0];
                dest.appendChild(child);
            }


        }
        return dest;
    }

    function styles(dom) {
        var used = "";
        var sheets = document.styleSheets;
        for (var i = 0; i < sheets.length; i++) {
            var rules = sheets[i].cssRules;
            for (var j = 0; j < rules.length; j++) {
                var rule = rules[j];
                var patt = new RegExp(/(^#|\.)?([a-zA-Z])/);
                var patt2 = new RegExp(/::/);
                if (typeof(rule.style) != "undefined") {

                    if(!patt2.test(rule.selectorText)){
                        if ( patt.test(rule.selectorText)){

                            var elems =    dom.querySelectorAll(rule.selectorText);
                        }
                        else{
                            var elems =    $j(rule.selectorText);
                        }
                    }
                    if (elems.length > 0) {
                        used += rule.selectorText + " { " + rule.style.cssText + " }\n";
                    }
                }
            }
        }

    var s = document.createElement('style');
    s.setAttribute('type', 'text/css');
    s.innerHTML = "<![CDATA[\n" + used + "\n]]>";

    var defs = document.createElement('defs');
    defs.appendChild(s);
    return defs;
  }

    function extractGroup(clone){
        if(clone.childNodes[2])
        {if(clone.childNodes[2].attributes.class.value=='y_grid'){
            var svg= clone;
            var gChild=svg.childNodes[2];
            clone.removeChild(gChild);


        }


        }
        return clone;}

  out$.svgAsDataUri = function(el, scaleFactor, cb) {
    scaleFactor = scaleFactor || 1;

    inlineImages(function() {
      var outer = document.createElement("div");
      var clone = el.cloneNode(true);
      var width = parseInt(clone.getAttribute("width"));
      var height = parseInt(clone.getAttribute("height"));
        clone=extractGroup(clone);
      clone.setAttribute("version", "1.1");
      clone.setAttribute("xmlns", "http://www.w3.org/2000/svg");
      clone.setAttribute("xmlns:xlink", "http://www.w3.org/1999/xlink");
      clone.setAttribute("width", width * scaleFactor);
      clone.setAttribute("height", height * scaleFactor);
      var scaling = document.createElement("g");
      scaling.setAttribute("transform", "scale(" + scaleFactor + ")");
      clone.appendChild(moveChildren(clone, scaling));
      outer.appendChild(clone);

      clone.insertBefore(styles(clone), clone.firstChild);

      var svg = ""+doctype+"" + outer.innerHTML;
        console.log(outer);
        if (!document.getElementsByTagName('svg')[1].children){
            console.log('replacement happened');
            typeof(svg);
            svg = svg.replace('xmlns:NS1=""', "");
            svg = svg.replace('NS1:', "");
            svg= svg.replace(' xmlns="http://www.w3.org/2000/svg"');
            svg= svg.replace('svgundefined',"svg");
        }
        console.log(svg);
      var uri = 'data:image/svg+xml;base64,' + window.btoa(unescape(encodeURIComponent(svg)));
      if (cb) {
        cb(uri,width,height);
      }
    });
  }

    out$.saveSvgAsPng = function(el, name, scaleFactor) {
        var imageObj;
        out$.svgAsDataUri(el, scaleFactor, function(uri,width,height) {
            var image = new Image();
            image.src = uri;
            image.width=width;
            image.height=height;
            imageObj=image;
        });
        return imageObj;
    }
    out$.SVGinitiatorIE=function(el1,el2,name, scaleFactor){

        var imageArray=[saveSvgAsPng(el1, name, scaleFactor),saveSvgAsPng(el2, name, scaleFactor)];

        ImageLoader(imageArray,name, document.getElementById('point-name').innerHTML);

    }


















    function ImageLoader(imagearray,name,pointname){
        window. canvas = document.createElement('canvas');
        //document.getElementById("chart-container").appendChild(window.canvas);
        canvas.width = imagearray[0].width+imagearray[1].width ;
        canvas.height = imagearray[0].height ;
        window. context = canvas.getContext('2d');
        var  tempx=0;
        var  tempy=0;

        var items={a:imagearray[0],b:imagearray[1]};

        for(i in items) {
            var img = new Image();
            img.onload = (function (nr) {
                return function() {
                    context.drawImage(items[nr] , tempx, tempy);
                    console.log('loaded')
                    tempx+=items[nr].width;
                    if (nr=='b'){
                        drawVerticalTicks(context,canvas.width, canvas.height,imagearray[0].width);
                        drawHorizontalTicks(context,canvas.width,imagearray[0].width);
                        console.log(pointname);
                        writePointName(context,pointname,canvas.width, canvas.height);
                        setTimeout(function(){downloadImage(canvas,name);console.log('downloaded')},1000);

                    }
                }
            }(i));
            img.src = items[i].src;
        }
    }


    function downloadImage(canvas,name){

       canvas.toBlob(function(blob) {
            saveAs(blob, "name.png");
        },"image/png");
    }

    function writePointName(context,pointname,width,height){
        context.font="20px Verdana";
        context.fillStyle='blue';
        context.fillText(pointname,15,height-8);
        context.fill();
    }

    function drawVerticalTicks(context,width,height,marginleft){
        var array=document.getElementsByClassName('x_tick');
        var values=[];
        for(var x=0;x<array.length;x++){
            var leftVal=(array[x].style.left).replace(/px/i,"");

            values.push({val:array[x].children[0].innerHTML,left:parseInt(leftVal)+marginleft});
        }
        for(var x=0;x<values.length;x++){
            drawDashedLine(context,{x:values[x].left,y:height},{x:values[x].left,y:0},values[x].val);
        }


    }

    function drawHorizontalTicks(context,width,marginleft){
        var g=document.getElementsByClassName('y_axis')[0].childNodes[0].childNodes;
       window.array=[];

        for (var x=0;x< g.length;x++){
            if(g[x].attributes.class.value=='tick') array.push(g[x]);}


        var values=[];
        for(var x=0;x<array.length;x++){

            var bottomVal=array[x].attributes.transform.value.split(' ')[1].replace(/[)]/,'');
            console.log("string :"+bottomVal+"number"+parseFloat(bottomVal));
            values.push({bottom:parseFloat(bottomVal)-5});
            //deducting 5 removes the error value
        }
        for(var x=0;x<values.length;x++){
            drawDashedLine(context,{x:marginleft+2,y:values[x].bottom},{x:width,y:values[x].bottom},"");
        }
    }

    function drawDashedLine(context,start,end,text){
        console.log("line being drawn")
        context.setLineDash([2,4]);


        context.beginPath();
        context.translate(0.5,0.5);
        context.font="15px Verdana";
        context.fillStyle='grey';
        context.strokeStyle='grey';
        context.fillText(text,start.x+3,start.y-8);
        context.fill();
        context.beginPath();
        context.moveTo(start.x,start.y);
        context.lineTo(end.x,end.y);

        context.closePath();
        context.stroke();

    }
})();
