<%--
  Layout page to reset the password.

  Page includes:
    None

  Required Parameters:
    checkoutLogin
      If true, this takes place in the "Checkout" workflow.
      If empty or false, this takes place on the normal login page.

  Optional parameters:
    None
--%>
<dsp:page>
  <dsp:importbean bean="/atg/userprofiling/ForgotPasswordHandler"/>

  <%-- Request parameters - to variables --%>
  <dsp:getvalueof var="checkoutLogin" param="checkoutLogin"/>
  <dsp:getvalueof var="email" param="email"/>

  <%-- ========== Handle form exceptions ========== --%>
  <dsp:getvalueof var="formExceptions" bean="ForgotPasswordHandler.formExceptions"/>
  <jsp:useBean id="errorMap" class="java.util.HashMap"/>
  <c:if test="${not empty formExceptions}">
    <c:forEach var="formException" items="${formExceptions}">
      <dsp:param name="formException" value="${formException}"/>
      <c:set var="errorCode" value="${formException.errorCode}"/>
      <c:choose>
        <c:when test="${errorCode == 'missingRequiredValue'}"><c:set target="${errorMap}" property="email" value="mandatoryField"/></c:when>
        <c:when test="${errorCode == 'noSuchProfileError'}"><c:set target="${errorMap}" property="email" value="invalidValue"/></c:when>
      </c:choose>
    </c:forEach>
  </c:if>

  <fmt:message var="pageTitle" key="mobile.common.login"/>
  <crs:mobilePageContainer titleString="${pageTitle}">
    <jsp:body>
      <div class="dataContainer">
        <h2><fmt:message key="mobile.login.link.forgotPassword"/></h2>

        <p class="passwordResetIntro">
          <fmt:message key="mobile.myAccount.message.passwordReset"/>
        </p>

        <%-- ========== Form ========== --%>
        <dsp:form formid="passwordReset" action="${pageContext.request.requestURI}" method="post"
                  onsubmit="CRSMA.myaccount.copyEmailToUrl('passwordResetEmail', 'successUrl')">
          <%-- ========== Redirection URLs ========== --%>
          <c:choose>
            <c:when test="${checkoutLogin == 'true'}">
              <dsp:input bean="ForgotPasswordHandler.forgotPasswordSuccessURL" type="hidden" id="successUrl"
                         value="../checkout/login.jsp?checkoutLogin=true&passwordSent=true&loginErrors=true"/>
              <dsp:input type="hidden" bean="ForgotPasswordHandler.forgotPasswordErrorURL"
                         value="passwordReset.jsp?checkoutLogin=true"/>
            </c:when>
            <c:otherwise>
              <dsp:input bean="ForgotPasswordHandler.forgotPasswordSuccessURL" type="hidden" id="successUrl"
                         value="login.jsp?passwordSent=true&loginErrors=true"/>
              <dsp:input type="hidden" bean="ForgotPasswordHandler.forgotPasswordErrorURL"
                         value="passwordReset.jsp"/>
            </c:otherwise>
          </c:choose>

          <ul class="dataList">
            <%-- "Email" --%>
            <li ${not empty errorMap['email'] ? 'class="errorState"' : ''}>
              <div class="content">
                <fmt:message var="nickEmail" key="mobile.myAccount.passwordReset.input.placeholder.email"/>
                <dsp:input type="email" bean="ForgotPasswordHandler.value.email" size="35" required="true"
                           id="passwordResetEmail" placeholder="${nickEmail}" aria-label="${nickEmail}" autocapitalize="off" value="${email}"/>
              </div>
              <c:if test="${not empty errorMap['email']}">
                <span class="errorMessage">
                  <fmt:message key="mobile.common.error.${errorMap['email']}"/>
                </span>
              </c:if>
            </li>
          </ul>

          <%-- "Submit" button --%>
          <div class="centralButton">
            <fmt:message var="submitLabel" key="mobile.login.button.send"/>
            <dsp:input bean="ForgotPasswordHandler.forgotPassword" type="submit" class="mainActionButton" value="${submitLabel}"/>
          </div>
        </dsp:form>
      </div>
    </jsp:body>
  </crs:mobilePageContainer>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/Storefront/j2ee/store.war/mobile/myaccount/passwordReset.jsp#3 $$Change: 789440 $--%>
