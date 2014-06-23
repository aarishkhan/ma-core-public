<%--
    Copyright (C) 2014 Infinite Automation Systems Inc. All rights reserved.
    @author Matthew Lohbihler
--%><%@include file="/WEB-INF/tags/decl.tagf"%>
<%@tag import="com.serotonin.m2m2.Common"%>
<%@attribute name="showHeader"%>

<div class="rowBoot no-margin-left-right "  id="mainHeader" data-dojo-type="dijit/layout/BorderContainer"
	<c:choose>
  <c:when test="${!empty showHeader}">
	  <c:choose>
	    <c:when test="${showHeader == false}">style="display:none;"</c:when>
	    <c:otherwise>style="width:100%"</c:otherwise>
	  </c:choose>
	</c:when>
	<c:otherwise>style="width:100%"</c:otherwise>
	</c:choose>
	>
	<div class="col-lg-2 " id="mainHeader_leadingRegion"
		style="width: 180px; border: 0px; padding: 0px"
		data-dojo-type="dijit/layout/ContentPane">
    <!--data-dojo-props="region:'leading'">-->
		<img id="application_logo" src="<%=Common.applicationLogo%>"
			alt="Logo" />
	</div>

	<c:if test="${!simple}">
		<div class="col-xs-10 " id="alarmToaster"
			style=" border: 0px; "
			data-dojo-type="dijit/layout/ContentPane">


    </div>
    <!--data-dojo-props="region:'center'>-->

	</c:if>
    <div class="col-lg-2   smallTitle marR " style=" float:right; border: 0px; ">

    <!--data-dojo-props="region:'trailing'">-->

   My Mango Automation
    </div>

	<!-- Could put toolbar here later     <div data-dojo-type="dijit/layout/ContentPane" data-dojo-props="region:'bottom'">Bottom pane</div> -->
</div>


<script type="text/javascript">
	require([ "dojo/parser", "dijit/registry", "dojo/on", "dojo/topic",
			"dojo/dom-construct", "dojo/dom", "dijit/layout/BorderContainer",
			"dijit/layout/ContentPane", "dojox/image", "dojo/domReady!" ],
			function(parser, registry, on, topic, domConstruct,
					BorderContainer, ContentPane) {

				//Get the logo image size, then resize the leading region to have that width
				var logo = dojo.byId("application_logo");
				var leadingRegion = dojo.byId("mainHeader_leadingRegion");


				// Register the alerting routine with the "alertUser" topic.
				topic.subscribe("alarmTopic", function(message) {
					//Message has members:
					// duration - int
					// message - string
					// type - string
					var alarmMessageDiv = dijit.byId("alarmToaster");
					if (message.type == 'clear')
						alarmMessageDiv.set('content', "");
					else {
						alarmMessageDiv.set('content', alarmMessageDiv
								.get('content')
								+ message.message + "</br>");
					}
				});
			});
</script>
