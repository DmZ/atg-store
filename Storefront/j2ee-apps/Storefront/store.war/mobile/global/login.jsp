<%--
  This page renders a form with three different possible options:
    - Login
    - Signup
    - Skip Registration

  Each different form is contained in its own row, and clicking on that row causes a child row to expand containing the form.

  Page includes:
    /mobile/global/gadgets/loginPage.jsp - Login form
    /mobile/global/gadgets/registration.jsp - Registration form for new customers

  Required parameters:
    checkoutLogin
      If true, sets the FormHandler, error/success URLs, and proper form
      inputs to the "CheckoutProfileFormHandler". Otherwise, "ProfileFormHandler" is used
    registrationFormHandler
      FormHandler, used for user registration, one from below:
        /atg/store/profile/RegistrationFormHandler
        /atg/store/mobile/order/purchase/BillingFormHandler
    registrationSuccessUrl
      Redirection path, used when registration succeeds

  Optional parameters:
    passwordSent
      Tells us whether the customer has had a temporary password sent to their email
    loginErrors
      If true, we know there are errors on the login form, and will show it by default
    registrationErrors
      If true, we know there are errors on the registration form, and will show it by default
--%>
<dsp:page>
  <dsp:importbean bean="/atg/store/droplet/ProfileSecurityStatus"/>
  <dsp:importbean bean="/atg/userprofiling/Profile"/>

  <%-- Request parameters - to variables --%>
  <dsp:getvalueof var="passwordSent" param="passwordSent"/>
  <dsp:getvalueof var="checkoutLogin" param="checkoutLogin"/>
  <dsp:getvalueof var="loginErrors" param="loginErrors"/>
  <dsp:getvalueof var="registrationErrors" param="registrationErrors"/>

  <dsp:getvalueof var="currentLocale" vartype="java.lang.String" bean="/atg/dynamo/servlet/RequestLocale.localeString"/>

  <fmt:message var="pageTitle" key="mobile.common.login"/>
  <crs:mobilePageContainer titleString="${pageTitle}">
    <div class="roundedBox loginContainer">
      <%-- Get the first name if the user is auto logged in and set a flag to show a logout option --%>
      <dsp:droplet name="ProfileSecurityStatus">
        <dsp:oparam name="autoLoggedIn">
          <dsp:getvalueof var="firstName" bean="Profile.firstName"/>
          <c:set var="showLogout" value="true"/>
        </dsp:oparam>
      </dsp:droplet>
      
      <%-- Login row --%>
      <c:if test="${loginErrors}">
        <c:set var="loginOpenState" value="open"/>
      </c:if>
      <details ${loginOpenState}>
        <summary class="content">
          <span>
            <fmt:message key="mobile.common.login"/>&nbsp;
            <span class="firstName"><dsp:valueof value="${firstName}"/></span>
          </span>
        </summary>
        <div class="expandedLoginContainer">
          <br/>
          <dsp:include page="gadgets/loginPage.jsp">
            <c:if test="${checkoutLogin == 'true'}">
              <dsp:param name="checkoutLogin" value="true"/>
              <dsp:param name="passwordSent" value="${passwordSent}"/>
            </c:if>
          </dsp:include>
          <br/>
        </div>
      </details>
      <hr/>
      
      <%-- If logged in, display a logout row, otherwise display a registration row --%>
      <c:choose>
        <c:when test="${showLogout == 'true'}">
          <dsp:importbean bean="/atg/userprofiling/ProfileFormHandler"/>
          <dsp:a page="/">
            <span class="content"><fmt:message key="mobile.common.logout"/></span>
            <span>
              <c:url value="${pageContext.request.requestURI}" var="successURL" context="/">
                <c:if test="${checkoutLogin == 'true'}">
                  <c:param name="checkoutLogin" value="true"/>
                </c:if>
                <c:param name="userLocale" value="${currentLocale}"/>
              </c:url>
              <dsp:property bean="ProfileFormHandler.logoutSuccessURL" value="${successURL}"/>
              <dsp:property bean="ProfileFormHandler.logout" value="true"/>
            </span>
          </dsp:a>
        </c:when>
        <c:otherwise>
          <%-- Registration row --%>
          <c:if test="${registrationErrors}">
            <c:set var="RegOpenState" value="open"/>
          </c:if>
          <details ${RegOpenState}>
            <summary class="content">
              <fmt:message key="mobile.login.button.signUp"/>
            </summary>
            <div class="expandedLoginContainer">
              <dsp:include page="gadgets/registration.jsp">
                <dsp:param name="formHandler" param="registrationFormHandler"/>
                <dsp:param name="successUrl" param="registrationSuccessUrl"/>
              </dsp:include>
            </div>
          </details>
        </c:otherwise>
      </c:choose>
      
      <%-- Display the "Skip Login" row if in "Checkout" mode --%>
      <c:if test="${checkoutLogin == 'true'}">
        <hr/>
        <div onclick="document.anonymousForm.submit();" >
          <span class="content">
            <fmt:message key="mobile.login.button.skipLogin"/>
          </span>
          <div>
            <a href="javascript:void(0);">
              <dsp:importbean bean="/atg/store/profile/CheckoutProfileFormHandler"/>
              <%-- ========== Form ========== --%>
              <dsp:form action="${pageContext.request.requestURI}" method="post" name="anonymousForm" formid="anonymousForm">
                <c:url value="../checkout/shipping.jsp" var="successURL">
                  <c:param name="locale" value="${currentLocale}"/>
                </c:url>
                <dsp:input bean="CheckoutProfileFormHandler.loginSuccessURL" type="hidden" value="${successURL}"/>
                <fmt:message key="mobile.login.button.skipLogin" var="anonymousCaption"/>
                <dsp:input bean="CheckoutProfileFormHandler.anonymousCustomer" type="hidden" value="${anonymousCaption}"/>
              </dsp:form>
            </a>
          </div>
        </div>
      </c:if>
    </div>
  </crs:mobilePageContainer>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/Storefront/j2ee/store.war/mobile/global/login.jsp#10 $$Change: 813916 $--%>
