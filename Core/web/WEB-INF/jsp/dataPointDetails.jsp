<%--
    Copyright (C) 2014 Infinite Automation Systems Inc. All rights reserved.
    @author Matthew Lohbihler
--%>
<%@ include file="/WEB-INF/jsp/include/tech.jsp" %>
<%@page import="com.serotonin.m2m2.vo.UserComment"%>

<tag:page showHeader="${param.showHeader}" showToolbar="${param.showToolbar}" dwr="DataPointDetailsDwr" js="/resources/view.js">
  <c:if test="${!empty point}">
    <script type="text/javascript">
    require(["dojo","dojo/store/Memory","dijit/form/FilteringSelect","dijit/form/Select"], 
    		function(dojo,Memory,FilteringSelect,Select){
	      
	      mango.view.initPointDetails();
	
	      dojo.ready(function() {
	          getHistoryTableData();
	          <c:if test="${!empty periodType}">
	            DataPointDetailsDwr.getDateRangeDefaults(${periodType}, ${periodCount}, function(data) {
	                setDateRange(data);
	                getImageChart();
	            });
	          </c:if>
	          <c:if test="${!empty flipbookLimit}">getFlipbookChart();</c:if>
	          getStatsChart();
	          
	          // Point lookup
	          new dijit.form.FilteringSelect({
	              store: new dojo.store.Memory({ data: pointList }),
	              autoComplete: false,
	              style: "width: 250px;",
	              queryExpr: "*\${0}*",
	              highlightMatch: "all",
	              required: false,
	              onChange: function(point) {
	                  if (this.item)
	                      window.location='data_point_details.shtm?dpid='+ this.item.id;
	              }
	          }, "picker");        
	      
	          
	          //Setup the File Download Selector
	          var uploadTypeChoice = new Select({
	              name: "downloadTypeSelect",
	              options: [
	                  { label: "Excel", value: ".xlsx", selected: true},
	                  { label: "Comma Separated Value (CSV)", value: ".csv", },
	              ]
	          },"downloadTypeSelect");
	       
	      
	      
	      });
	      
	      
	      
	      
	      
    });
      //
      // History
      //
      function getHistoryTableData() {
          var limit = parseInt($get("historyLimit"));
          if (isNaN(limit))
              alert("<fmt:message key="pointDetails.recordCountError"/>");
          else {
              startImageFader($("historyLimitImg"));
              DataPointDetailsDwr.getHistoryTableData(limit, function(response) {
                  var data = response.data.history;
                  dwr.util.removeAllRows("historyTableData");
                  if (!data || data.length == 0)
                      dwr.util.addRows("historyTableData", ["<fmt:message key="common.noData"/>"], [function(data) { return data; }]);
                  else {
                      dwr.util.addRows("historyTableData", data,
                          [
                              function(data) { return data.value; },
                              function(data) { return data.time; },
                              function(data) { return data.annotation; }
                          ],
                          {
                              rowCreator:function(options) {
                                  var tr = document.createElement("tr");
                                  tr.className = "row"+ (options.rowIndex % 2 == 0 ? "" : "Alt");
                                  return tr;
                              }
                          });
                  }
                  $("historyTableAsof").innerHTML = response.data.asof;
                  stopImageFader($("historyLimitImg"));
              });
          }
      }
    //
    //date Time Picker
    //


    function getDateTimeFromInputTags(origin){

    var DateElement=document.getElementById('dateTimePicker-'+origin+'');
    var Year=$get(""+origin+"Year");
    var Month=$get(""+origin+"Month");
    var Day= $get(""+origin+"Day");
    var Hour= $get(""+origin+"Hour");
    var Minute=$get(""+origin+"Minute");
    var Second=$get(""+origin+"Second");
    //var fromNone= $get("fromNone"),
    var dateString=""+Month+"-"+Day+"-"+Year+" "+Hour+":"+Minute+":"+Second+"";
    console.log(dateString);

    DateElement.value=dateString;
    }
    function setDateTimeToInputTags(origin){
    var DateElement=document.getElementById('dateTimePicker-'+origin+'');
    var value= DateElement.value;
    var dateTimeArray=value.split(" ");
    var date=dateTimeArray[0].split("-");
    var time=dateTimeArray[1].split(":");
    var day=date[1];
    var month=date[0];
    var year=date[2];
    var hour=time[0];
    var minute=time[1];
    var second=time[2];
    $set(""+origin+"Year",year);
    $set(""+origin+"Month",parseInt(month));
    console.log(""+origin+"Month"+"value"+month);
    $set(""+origin+"Day",day);
    $set(""+origin+"Hour",hour);
    $set(""+origin+"Minute",minute);
    $set(""+origin+"Second",second);
    console.log("i am called sire")


    }





      
      //
      // Image chart
      //
      function getImageChart() {
          var width =document.getElementById('chart-container').clientWidth-10;// dojo.contentBox($("imageChartDiv")).w - 20;
    console.log('selector value'+ $("imageChartDiv")
    +"and"+dojo.contentBox($("imageChartDiv")).w)
    console.log(width)
             DataPointDetailsDwr.getImageChartData($get("fromYear"), $get("fromMonth"), $get("fromDay"), $get("fromHour"),
                $get("fromMinute"), $get("fromSecond"), $get("fromNone"), $get("toYear"), $get("toMonth"), 
                $get("toDay"), $get("toHour"), $get("toMinute"), $get("toSecond"), $get("toNone"), width, 350, function(response) {
            //  $("imageChartDiv").innerHTML = response.data.chart;
             // $("imageChartAsof").innerHTML = response.data.asof;

    //rickshaw graph

    var glycolgraphcont=$j('#imageChartDiv').width();
    console.log(glycolgraphcont)
    var widthAxis=glycolgraphcont*0.07;
    var widthGraph=glycolgraphcont*0.78;
    $j('#axis0').width(widthAxis);
    $j('#axis1').width(widthAxis);
    $j('#chart').width(widthGraph);
    //  $( "#slider-range" ).slider({
    //      range: true
    // });

    var data, graph, i, max, min, point, random, scales, series, _i, _j, _k, _l, _len, _len1, _len2, _ref;
    var parsedData=[];
    data = [[], []];
    $j.ajax({
    url: "http://localhost:8080/basicapi?oldapi=ft_1399932094816_1399845660000_-1_1.png",

    success: function(pointList){
    var resultObj=JSON.parse(pointList);
    makeGraphData(resultObj);
    }
    });
    function makeGraphData(data){
    for(var x=0;x<10;x++){
        parsedData.push({x:data.Temp.times[x],y:data.Temp.values[x]})

    }
    }



   random = new Rickshaw.Fixtures.RandomData(12 * 60 * 60);

    for (i = _i = 0; _i < 100; i = ++_i) {
    random.addData(data);
    }
    //window.jsonData=data;
    console.log("this is the data:"+ data);
    scales = [];

    _ref = data[1];
    for (_j = 0, _len = _ref.length; _j < _len; _j++) {
    point = _ref[_j];
    point.y *= point.y;
    }

    for (_k = 0, _len1 = data.length; _k < _len1; _k++) {
    series = data[_k];
    min = Number.MAX_VALUE;
    max = Number.MIN_VALUE;
    for (_l = 0, _len2 = series.length; _l < _len2; _l++) {
    point = series[_l];
    min = Math.min(min, point.y);
    max = Math.max(max, point.y);
    }
    if (_k === 0) {
    scales.push(d3.scale.linear().domain([min, max]).nice());
    } else {
    scales.push(d3.scale.pow().domain([min, max]).nice());
    }
    }

    graph = new Rickshaw.Graph({
    element: document.getElementById("chart"),
    renderer: 'line',height:250,width:widthGraph,
    series: [
    {
    color: 'red',
    data: data[0],
    name: 'GlycolTemperature',
    scale: scales[0]
    }
    ]
    });

    new Rickshaw.Graph.Axis.Y.Scaled({
    element: document.getElementById('axis0'),
    graph: graph,
    orientation: 'left',
    scale: scales[0],
    tickFormat: Rickshaw.Fixtures.Number.formatKMBT
    });



    new Rickshaw.Graph.Axis.Time({
    graph: graph
    });

    new Rickshaw.Graph.HoverDetail({
    graph: graph
    });
    new Rickshaw.Graph.RangeSlider({
    graph: graph,
    element: document.getElementById("slider-range")
    });

    graph.render();









              stopImageFader($("imageChartImg"));
              getDateTimeFromInputTags('from');
                getDateTimeFromInputTags('to');




          });

          startImageFader($("imageChartImg"));
      }








      function getChartData() {
          startImageFader($("chartDataImg"));
          DataPointDetailsDwr.getChartData($get("fromYear"), $get("fromMonth"), $get("fromDay"), $get("fromHour"),
                $get("fromMinute"), $get("fromSecond"), $get("fromNone"), $get("toYear"), $get("toMonth"),
                $get("toDay"), $get("toHour"), $get("toMinute"), $get("toSecond"), $get("toNone"), function(data) {
              stopImageFader($("chartDataImg"));
              var downloadTypeSelect = dijit.byId("downloadTypeSelect");
              var downloadUrl = "chartExport/pointData" + downloadTypeSelect.get('value');
              window.location = downloadUrl;

          });          
      }
    //download chart

    function saveImage(){

    if (!document.getElementsByTagName('svg')[1].children){
    SVGinitiatorIE(document.getElementsByTagName('svg')[0],document.getElementsByTagName('svg')[1],"diagram.png", 1);
    }
    else{
    SVGinitiator(document.getElementsByTagName('svg')[0],document.getElementsByTagName('svg')[1],"diagram.png", 1);}
    }











      
      //
      // Stats chart
      //
      function getStatsChart() {
          var period = parseInt($get("statsChartDuration"));
          var periodType = parseInt($get("statsChartDurationType"));
          
          if (isNaN(period))
              alert("<fmt:message key="pointDetails.timePeriodError"/>");
          else {
              startImageFader($("statsChartImg"));
              DataPointDetailsDwr.getStatsChartData(periodType, period, true, function(response) {
                  $("statsChartData").innerHTML = response.data.stats;
                  $("statsAsof").innerHTML = response.data.asof;
                  stopImageFader($("statsChartImg"));
              });
          }

      }
      
      function togglePanel(img, panelId) {
          if (!img.minimized) {
              img.src = "images/arrow_out.png";
              img.title = "<fmt:message key="common.maximize"/>";
              hide(panelId);
              img.minimized = true;
          }
          else {
              img.src = "images/arrow_in.png";
              img.title = "<fmt:message key="common.minimize"/>";
              show(panelId);
              img.minimized = false;
          }
      }
      
      // Flipbook
      function getFlipbookChart() {
          var limit = parseInt($get("flipbookLimit"));
          if (isNaN(limit))
              alert("<fmt:message key="pointDetails.imageCountError"/>");
          else {
              startImageFader($("flipbookChartImg"));
              DataPointDetailsDwr.getFlipbookData(limit, function(response) {
                  var data = response.data.images;
                  var thumbContent = "";
                  for (var i=0; i<data.length; i++)
                      thumbContent += '<img src="'+ data[i].uri +'?w=40&h=40" onmouseover="swapFlipbookImage(\''+ data[i].uri +'\')"/>';
                  $set("flipbookThumbsDiv", thumbContent);
                  if (data.length > 0)
                      swapFlipbookImage(data[0].uri);
                  
                  $("flipbookAsof").innerHTML = response.data.asof;
                  stopImageFader($("flipbookChartImg"));
              });
          }
      }
      
      function swapFlipbookImage(uri) {
          $("flipbookImage").src = uri;
      }
      
      // Force read
      function forceRead() {
          <c:if test="${!empty point}">
            startImageFader($("forceReadImg"));
            DataPointDetailsDwr.forcePointRead(${point.id}, function() {
                stopImageFader($("forceReadImg"));
            });
          </c:if>
      }

    </script>
  </c:if>
      
  <table width="100%">
    <tr>
      <td valign="top" align="right">
        <fmt:message key="pointDetails.goto"/>:&nbsp;
        <div style="display:inline;"><div id="picker"></div></div>
        
        <c:if test="${!empty prevId}">
          <tag:img png="bullet_go_left" title="pagination.previous"
                  onclick="window.location='data_point_details.shtm?dpid=${prevId}'"/>
        </c:if>
        
        <c:if test="${!empty nextId}">
          <tag:img png="bullet_go" title="pagination.next"
                  onclick="window.location='data_point_details.shtm?dpid=${nextId}'"/>
        </c:if>
        |
        <fmt:message key="pointDetails.findXid"/>:&nbsp;
        <input type="text" value="${currentXid}" onkeypress="if (event.keyCode==13) window.location='data_point_details.shtm?dpxid='+ this.value"/>
      </td>
    </tr>
  </table>
  
  <c:choose>
    <c:when test="${empty point && !empty currentXid}"><m2m2:translate key="pointDetails.pointNotFound"/></c:when>
    <c:when test="${empty point}"><m2m2:translate key="pointDetails.noPoints"/></c:when>
    <c:otherwise>
     <div class=" no-margin-left-right page-container">
    <div class="rowBoot no-margin-left-right ">
    <div class="col-lg-5 no-padding-left-right ">
            <div class="borderDiv marB marR">
              <table>
                <tr>
                  <td class="smallTitle" colspan="2">
                    <tag:img png="icon_comp" title="common.point"/>
                   <span id='point-name'> ${point.extendedName}</span>
                    <c:if test="${pointEditor}">
                      <a href="data_point_edit.shtm?dpid=${point.id}"><tag:img png="icon_comp_edit" title="pointDetails.editPoint"/></a>
                      <a href="data_source_edit.shtm?dsid=${point.dataSourceId}&pid=${point.id}"><tag:img png="icon_ds_edit"
                              title="pointDetails.editDataSource"/></a>
                    </c:if>
                  </td>
                </tr>
                <tr>
                  <td class="formLabelRequired">
                    <tag:img id="forceReadImg" png="arrow_refresh" title="common.refresh" onclick="forceRead()"/>
                    <fmt:message key="common.value"/>
                  </td>
                  <td id="pointValue" class="formField"></td>
                </tr>
                <tr>
                  <td class="formLabelRequired"><fmt:message key="common.time"/></td>
                  <td id="pointValueTime" class="formField"></td>
                </tr>
                <tr id="pointChangeNode" style="display:none">
                  <td class="formLabelRequired">
                    <tag:img id="pointChanging" png="icon_edit" title="common.set"/>
                    <fmt:message key="common.set"/>
                  </td>
                  <td id="pointChange" class="formField"></td>
                </tr>
                <tr>
                  <td class="formLabelRequired"><fmt:message key="common.xid"/></td>
                  <td class="formField">${point.xid}</td>
                </tr>
                <c:if test="${!empty hierPath}">
                  <tr>
                    <td class="formLabelRequired"><fmt:message key="common.path"/></td>
                    <td class="formField">${hierPath}</td>
                  </tr>
                </c:if>
                <tr><td colspan="2">
                        <div style='max-height:100px; overflow-y: scroll'>
                            <table><tr><td id="pointMessages"></td></tr>
                            </table>
                        </div>
                   </td>
                </tr>
              </table>
            </div>
            
            <div class="borderDiv marB marR">
              <table width="100%">
                <tr>
                  <td class="smallTitle"><fmt:message key="pointDetails.statistics"/></td>
                  <td id="statsAsof"></td>
                  <td align="right">
                    <fmt:message key="pointDetails.timePeriod"/>:
                    <input id="statsChartDuration" style="text-align:right;" type="text" class="formVeryShort"
                            value='${empty periodCount ? "1" : periodCount}'/>
                    <tag:timePeriods id="statsChartDurationType" value="${periodType}" min="true" h="true" d="true" w="true" mon="true"/>
                    <tag:img id="statsChartImg" png="control_play_blue" title="pointDetails.getStatistics" onclick="getStatsChart()"/>
                  </td>
                </tr>
              </table>
              <div id="statsChartData" style="padding:0px 0px 5px 5px;"></div>
            </div>
    </div>
          
       <div class="col-lg-5 no-padding-left-right">
            <div class="borderDiv marB marR">
              <table width="100%">
                <tr>
                  <td class="smallTitle"><fmt:message key="pointDetails.history"/></td>
                  <td id="historyTableAsof"></td>
                  <td align="right">
                    <fmt:message key="pointDetails.show"/>
                    <input id="historyLimit" type="text" style="text-align:right;" value="${historyLimit}"
                            class="formVeryShort"/>
                    <fmt:message key="pointDetails.mostRecentRecords"/>
                    <tag:img id="historyLimitImg" png="control_play_blue" title="pointDetails.getData" onclick="getHistoryTableData()"/>
                  </td>
                </tr>
              </table>
              <table cellspacing="1">
                <tr class="rowHeader">
                  <td><fmt:message key="common.value"/></td>
                  <td><fmt:message key="common.time"/></td>
                  <td><fmt:message key="common.annotation"/></td>
                </tr>
                <tbody id="historyTableData"></tbody>
              </table>
            </div>
        </div>

    <div class="col-lg-2 no-padding-left-right">
            <div class="borderDiv marB">
              <table width="100%">
                <tr>
                  <td class="smallTitle"><fmt:message key="notes.userNotes"/></td>
                  <td align="right">
                    <tag:img png="comment_add" title="notes.addNote"
                            onclick="openCommentDialog(${applicationScope['constants.UserComment.TYPE_POINT']}, ${point.id})"/>
                  </td>
                </tr>
              </table>
              <table id="pointComments${point.id}"><tag:comments comments="${point.comments}"/></table>
            </div>
     </div>

    </div>
        <c:if test="${!empty periodType}">

           <div class="rowBoot  no-margin-left-right">
              <!-- chart with editable properties and annotations -->
              <div id="chart-container" class="col-lg-12 no-margin-left-right no-padding-left-right borderDiv marB">

                  <div class="rowBoot col-lg-12 no-margin-left-right">
                    <div>
                    <div class="smallTitle"><fmt:message key="pointDetails.chart"/> &nbsp <tag:help id="chartServlet"/></div>
                    <div id="imageChartAsof"></div>
                     </div>

                     <div class="rowBoot col-lg-12 no-padding-left-right no-margin-left-right"><tag:dateRange/></div>
                    <div class="col-lg-2">
                      <tag:img id="imageChartImg" png="control_play_blue" title="pointDetails.imageChartButton"
                              onclick="getImageChart()"/>
                      <!-- TODO Add selectable type here xslx or csv, Maybe Create Tag... -->
                      <input id="downloadTypeSelect"></input>
                      <tag:img id="chartDataImg" png="bullet_down" title="pointDetails.chartDataButton"
                              onclick="getChartData()"/>


                    </div>
    <button class="btn btn-warning pull-right" id="save" onclick='saveImage()'>save As Image</button>
                  </div>
                  <div class="rowBoot col-lg-12 no-padding-left-right no-margin-left-right ">
                    <div class="col-lg-12 no-padding-left-right" colspan="4" id="imageChartDiv">
                    <div id="axis0"></div>
                    <div id="chart"></div>

                    <div id="slider-range"></div>

                    </div>


                 </div>

              </div>
            </div>

    </c:if>
        
        <c:if test="${!empty flipbookLimit}">
    <div class="rowBoot no-padding-left-right no-margin-left-right">
              <div class=" col-lg-12 no-margin-left-right borderDiv marB">
                <table width="100%">
                  <tr>
                    <td class="smallTitle"><fmt:message key="pointDetails.flipbook"/></td>
                    <td id="flipbookAsof"></td>
                    <td align="right">
                      <fmt:message key="pointDetails.images"/>:
                      <input id="flipbookLimit" style="text-align:right;" type="text" value="${flipbookLimit}"
                              class="formVeryShort"/>
                      <tag:img id="flipbookChartImg" png="control_play_blue" title="pointDetails.getImages" 
                              onclick="getFlipbookChart()"/>
                    </td>
                  </tr>
                  <tr><td colspan="2" id="flipbookThumbsDiv"></td></tr>
                  <tr><td colspan="2"><img id="flipbookImage" src=""/></td></tr>
                </table>
              </div>
          </div>
        </c:if>

        <div class="rowBoot no-padding-left-right no-margin-left-right">
            <div class="col-lg-12 no-margin-left-right borderDiv marB padding-toggle ">
              <table width="100%">
                <tr>
                  <td class="smallTitle"><fmt:message key="pointDetails.events"/></td>
                  <td align="right">
                    <tag:img png="arrow_in" title="common.maximize" onclick="togglePanel(this, 'eventsTable');"/>
                    <a href=""><tag:img png="control_repeat_blue" title="common.refresh"/></a>
                  </td>
                </tr>
              </table>
              <table class="col-lg-12 padding-toggle" id="eventsTable" cellspacing="1" cellpadding="0" >
                <tr class="col-lg-12  no-padding-left-right">
                  <td class="col-xs-1 no-padding-left-right events-Table-Data-Point-header-Text"><fmt:message key="pointDetails.id"/></td>
                  <td class="col-xs-3 no-padding-left-right events-Table-Data-Point-header-Text"><fmt:message key="common.alarmLevel"/></td>
                  <td class="col-xs-3 no-padding-left-right events-Table-Data-Point-header-Text"><fmt:message key="common.activeTime"/></td>
                  <td class="col-xs-2 no-padding-left-right events-Table-Data-Point-header-Text"><fmt:message key="pointDetails.message"/></td>
                  <td class="col-xs-2 no-padding-left-right events-Table-Data-Point-header-Text"><fmt:message key="common.status"/></td>
                  <td class="col-xs-3 no-padding-left-right events-Table-Data-Point-header-Text"><fmt:message key="events.acknowledged"/></td>
                </tr>
                
                <c:forEach items="${events}" var="event" varStatus="status" end="19">
                  <tr class="row<c:if test="${status.index % 2 == 1}">Alt</c:if>">
                    <td align="center">${event.id}</td>
                    <td align="center"><tag:eventIcon event="${event}"/></td>
                    <td>${m2m2:time(event.activeTimestamp)}</td>
                    <td>
                      <table cellspacing="0" cellpadding="0" width="100%">
                        <tr>
                          <td><b><m2m2:translate message="${event.message}"/></b></td>
                          <td align="right"><tag:img png="comment_add" title="notes.addNote"
                                  onclick="openCommentDialog(${applicationScope['constants.UserComment.TYPE_EVENT']}, ${event.id})"/></td>
                        </tr>
                      </table>
                      <table cellspacing="0" cellpadding="0" id="eventComments${event.id}">
                        <c:forEach items="${event.eventComments}" var="comment">
                          <tr>
                            <td valign="top" width="16"><tag:img png="comment" title="notes.note"/></td>
                            <td valign="top">
                              <span class="copyTitle">
                                ${comment.prettyTime} <fmt:message key="notes.by"/>
                                <c:choose>
                                  <c:when test="${empty comment.username}"><fmt:message key="common.deleted"/></c:when>
                                  <c:otherwise>${comment.username}</c:otherwise>
                                </c:choose>
                              </span><br/>
                              ${comment.comment}
                            </td>
                          </tr>
                        </c:forEach>
                      </table>
                    </td>
                    <td>
                      <c:choose>
                        <c:when test="${event.active}">
                          <fmt:message key="common.active"/>
                          <a href="events.shtm"><tag:img png="flag_white" title="common.active"/></a>
                        </c:when>
                        <c:when test="${!event.rtnApplicable}"><fmt:message key="common.nortn"/></c:when>
                        <c:otherwise>
                          ${m2m2:time(event.rtnTimestamp)} - <m2m2:translate message="${event.rtnMessage}"/>
                        </c:otherwise>
                      </c:choose>
                    </td>
                    <td>
                      <c:if test="${event.acknowledged}">
                        ${m2m2:time(event.acknowledgedTimestamp)}
                        <m2m2:translate message="${event.ackMessage}" />
                      </c:if>
                    </td>
                  </tr>
                </c:forEach>
                <c:if test="${sst:size(events) > 20}">
                  <tr class="rowBoot"><td align="center" colspan="6"><fmt:message key="pointDetails.maxEvents"/> ${sst:size(events)}</td></tr>
                </c:if>
                <c:if test="${empty events}">
                  <tr class="rowBoot"><td colspan="6"><fmt:message key="events.emptyList"/></td></tr>
                </c:if>
              </table>
            </div>
      </div>






        <div  class="rowBoot no-padding-left-right no-margin-left-right">
                <div class=" col-lg-12 no-margin-left-right borderDiv">
                  <span class="col-lg-12 no-margin-left-right smallTitle" style="margin:3px;"><fmt:message key="pointDetails.userAccess"/></span>
                  <table width="100%" cellspacing="1">
                    <tr class="rowHeader">
                      <td width="16"></td>
                      <td><fmt:message key="pointDetails.username"/></td>
                      <td><fmt:message key="pointDetails.accessType"/></td>
                    </tr>
                    <c:forEach items="${users}" var="userData" varStatus="status">
                      <tr class="row<c:if test="${status.index % 2 == 1}">Alt</c:if>">
                        <c:set var="user" value="${userData.user}"/>
                        <td><%@ include file="/WEB-INF/snippet/userIcon.jsp" %></td>
                        <td>${user.username}</td>
                        <td>
                          <c:choose>
                            <c:when test="${userData.accessType == applicationScope['constants.Permissions.DataPointAccessTypes.READ']}"><fmt:message key="common.access.read"/></c:when>
                            <c:when test="${userData.accessType == applicationScope['constants.Permissions.DataPointAccessTypes.SET']}"><fmt:message key="common.access.set"/></c:when>
                            <c:when test="${userData.accessType == applicationScope['constants.Permissions.DataPointAccessTypes.DATA_SOURCE']}"><fmt:message key="common.access.dataSource"/></c:when>
                            <c:when test="${userData.accessType == applicationScope['constants.Permissions.DataPointAccessTypes.ADMIN']}"><fmt:message key="common.access.admin"/></c:when>
                            <c:otherwise><fmt:message key="common.unknown"/> (${userData.accessType})</c:otherwise>
                          </c:choose>
                        </td>
                      </tr>
                    </c:forEach>
                  </table>
                </div>
        </div>
    </div>
      <%@ include file="/WEB-INF/jsp/include/userComment.jsp" %>
    </c:otherwise>
  </c:choose>
</tag:page>

<script type="text/javascript">
  var pointList = [
    <c:forEach items="${userPoints}" var="point">{id:${point.id},name:"${sst:dquotEncode(point.extendedName)}"},
    </c:forEach>
  ];

</script>