<%--
    Copyright (C) 2014 Infinite Automation Systems Inc. All rights reserved.
    @author Matthew Lohbihler
--%>
<%@ include file="/WEB-INF/jsp/include/tech.jsp" %>

<c:if test='${m2m2:envBoolean("ssl.on", false)}'>
  <c:if test='${pageContext.request.scheme == "http"}'>
    <c:redirect url='https://${pageContext.request.serverName}:${m2m2:envString("ssl.port", "8443")}${requestScope["javax.servlet.forward.request_uri"]}'/>
  </c:if>
</c:if>

<tag:page>
  <script type="text/javascript">
    dojo.ready(function () {
        $("username").focus();
        BrowserDetect.init();
        
        $set("browser", BrowserDetect.browser +" "+ BrowserDetect.version +" <fmt:message key="login.browserOnPlatform"/> "+ BrowserDetect.OS);
        
        if (checkCombo(BrowserDetect.browser, BrowserDetect.version, BrowserDetect.OS)) {
            $("browserImg").src = "images/accept.png";
            show("okMsg");
        }
        else {
            $("browserImg").src = "images/thumb_down.png";
            show("warnMsg");
        }
    });
  </script>
    <div class="rowBoot col-xs-12 no-padding-left-right no-margin-left-right">
    <div class="col-md-3 no-padding-left-right no-margin-left-right">
        <form id="loginForm" action="login.htm" method="post">
          <table>
            <spring:bind path="login.username">
              <tr>
                <td class="formLabelRequired"><fmt:message key="login.userId"/></td>
                <td class="formField">
                  <input id="username" type="text" name="username" value="${status.value}" maxlength="40"/>
                </td>
                <td class="formError">${status.errorMessage}</td>
              </tr>
            </spring:bind>
            
            <spring:bind path="login.password">
              <tr>
                <td class="formLabelRequired"><fmt:message key="login.password"/></td>
                <td class="formField">
                  <input id="password" type="password" name="password" value="${status.value}" maxlength="20"/>
                </td>
                <td class="formError">${status.errorMessage}</td>
              </tr>
            </spring:bind>
                
            <spring:bind path="login">
              <c:if test="${status.error}">
                <td colspan="3" class="formError">
                  <c:forEach items="${status.errorMessages}" var="error">
                    <c:out value="${error}"/><br/>
                  </c:forEach>
                </td>
              </c:if>
            </spring:bind>
            
            <tr>
              <td colspan="2" align="center">
                <input type="submit" value="<fmt:message key="login.loginButton"/>"/>
                <tag:help id="welcomeToMango"/>
              </td>
              <td></td>
            </tr>
          </table>
        </form>
    </div>

       <div class="col-lg-5">
        <table>
          <tr>
            <td valign="top"><img id="browserImg" src="images/magnifier.png"/></td>

            <td valign="top" colspan="2">
            <b><span id="browser"><fmt:message key="login.unknownBrowser"/></span></b>
            <br>
            <span id="okMsg" style="display:none"><fmt:message key="login.supportedBrowser"/></span>
            <span id="warnMsg" style="display:none"><fmt:message key="login.unsupportedBrowser"/></span>
            </td>
          </tr>
          <tr>

          </tr>
        </table>
        <br/><br/>
    </div>

    </div>

    </tag:page>
