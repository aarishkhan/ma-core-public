<%--
    Copyright (C) 2014 Infinite Automation Systems Inc. All rights reserved.
    @author Matthew Lohbihler
--%><%@include file="/WEB-INF/tags/decl.tagf"%><%--
--%><%@tag body-content="empty"%>
<div class="col-lg-4 no-padding-left-right">
<table >

  <tr></tr>
    <tr>
    <td><input style="margin-left:10px" type="checkbox" name="fromNone" id="fromNone" onclick="updateDateRange()"/><label
    for="fromNone"><fmt:message key="common.inception"/></label></td>
    <td class="no-padding"><fmt:message key="common.dateRangeFrom"/></td>
    <td><input class="datetimepicker" onchange="setDateTimeToInputTags('from')"  id="dateTimePicker-from" style="background-image: url(http://jongsma.org/js/controls/datepicker/calendar.png); background-color: rgb(255, 255, 255); padding-right: 20px; position: relative; background-position: 100% 50%; background-repeat: no-repeat no-repeat;"></td>
    </tr>
    <tr style="display:none">
    <td class="no-padding"><input type="text" id="fromYear" class="formVeryShort" value="${fromYear}"/></td>
    <td class="no-padding"><tag:monthOptions id="fromMonth" value="${fromMonth}"/></td>
    <td class="no-padding"><tag:dayOptions id="fromDay" value="${fromDay}"/></td>
    <td class="no-padding" style="padding:0px ">,</td>
    <td class="no-padding"><tag:hourOptions id="fromHour" value="${fromHour}"/></td>
    <td class="no-padding" style="padding:0px ">:</td>
    <td class="no-padding"><tag:minuteOptions id="fromMinute" value="${fromMinute}"/></td>
    <td class="no-padding-left-right" style="padding:0px ">:</td>
    <td class="no-padding"><tag:secondOptions id="fromSecond" value="${fromSecond}"/></td>

  </tr>


    </table>

    </div>
    <div class="col-lg-3 no-padding-left-right">
    <table>

  <tr>
    <td><input style="margin-left:10px" type="checkbox" name="toNone" id="toNone" checked="checked" onclick="updateDateRange()"/><label
    for="toNone"><fmt:message key="common.latest"/></label></td>
    <td class="no-padding"><fmt:message key="common.dateRangeTo"/></td>
    <td><input class="datetimepicker" onchange="setDateTimeToInputTags('to')"  id="dateTimePicker-to" style="background-image: url(http://jongsma.org/js/controls/datepicker/calendar.png); background-color: rgb(255, 255, 255); padding-right: 20px; position: relative; background-position: 100% 50%; background-repeat: no-repeat no-repeat;"></td>
    </tr>
    <tr style="display:none">
    <td class="no-padding"><input type="text" id="toYear" class="formVeryShort" value="${toYear}"/></td>
    <td class="no-padding"><tag:monthOptions id="toMonth" value="${toMonth}"/></td>
    <td class="no-padding"><tag:dayOptions id="toDay" value="${toDay}"/></td>
    <td class="no-padding" style="padding:0px ">,</td>
    <td class="no-padding"><tag:hourOptions id="toHour" value="${toHour}"/></td>
    <td class="no-padding" style="padding:0px ">:</td>
    <td class="no-padding"><tag:minuteOptions id="toMinute" value="${toMinute}"/></td>
    <td class="no-padding" style="padding:0px ">:</td>
    <td class="no-padding"><tag:secondOptions id="toSecond" value="${toSecond}"/></td>

  </tr>


    </table>

    </div>
