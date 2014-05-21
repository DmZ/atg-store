<%--
  This page is displayed after the user successfully places an order.

  Page includes:
    /mobile/global/gadgets/registration.jsp - Registration form

  Required parameters:
    None

  Optional parameters:
    registrationErrors
      ???

  NOTES:
    1) The "mobileStorePrefix" request-scoped variable (request attribute), which is used here,
       is defined in the "mobilePageContainer" tag ("mobilePageContainer.tag" file).
       This variable becomes available within the <crs:mobilePageContainer> ... </crs:mobilePageContainer> block
       and in all the included pages (gadgets and Endeca cartridges).
--%>
<dsp:page>
  <dsp:importbean bean="/atg/commerce/ShoppingCart"/>
  <dsp:importbean bean="/atg/store/droplet/ProfileSecurityStatus"/>
  <dsp:importbean bean="/atg/userprofiling/Profile" var="profilebean"/>

  <dsp:getvalueof var="registrationErrors" param="registrationErrors"/>

  <fmt:message var="pageTitle" key="mobile.checkout.confirmation.pageTitle"/>
  <crs:mobilePageContainer titleString="${pageTitle}">
    <h2><fmt:message key="mobile.checkout.header.orderPlaced"/></h2>

    <dsp:droplet name="ProfileSecurityStatus">
      <dsp:oparam name="anonymous">
        <%-- Confirmation page for anonimous user --%>
        <div class="dataContainer">
          <div align="center" class="actionConfirmation">
            <c:choose>
              <c:when test="${not empty profilebean.email}">
                <fmt:message key="mobile.checkout.message..confirmationEmailed"/><fmt:message key="mobile.common.colon"/>
                <br/>
                <strong><c:out value="${profilebean.email}"/></strong>
              </c:when>
              <c:otherwise>
                <fmt:message key="mobile.checkout.message.orderNumber"/><fmt:message key="mobile.common.colon"/>
                <br/>
                <strong><dsp:valueof bean="ShoppingCart.last.id"/></strong>
              </c:otherwise>
            </c:choose>
          </div>
          <br/>

          <details class="roundedBox loginContainer">
            <summary class="content">
              <fmt:message key="mobile.checkout.link.register"/>
            </summary>

            <div class="expandedLoginContainer">
              <%--
                Propagate Locale from request (RequestLocale) to "profile.jsp".
                This is needed to set user's language after registration as he set it while being anonimous.
              --%>
              <dsp:getvalueof var="currentLocale" vartype="java.lang.String" bean="/atg/dynamo/servlet/RequestLocale.localeString"/>
              <dsp:include page="${mobileStorePrefix}/global/gadgets/registration.jsp">
                <dsp:param name="successUrl" value="../myaccount/profile.jsp?locale=${currentLocale}"/>
              </dsp:include>
            </div>
          </details>
          <br/>
        </div>
      </dsp:oparam>
      <dsp:oparam name="default">
        <%-- Confirmation page for registered user --%>
        <div align="center" class="actionConfirmation">
          <fmt:message key="mobile.checkout.message..confirmationEmailed"/><fmt:message key="mobile.common.colon"/>
          <br/>
          <strong><c:out value="${profilebean.email}"/></strong>
        </div>
        <br/>
        <div class="dataContainer">
          <ul class="dataList">
            <li>
              <dsp:a page="${mobileStorePrefix}/myaccount/orderDetail.jsp" class="icon-ArrowRight">
                <dsp:param name="orderId" bean="ShoppingCart.last.id"/>
                <span class="content"><fmt:message key="mobile.checkout.link.viewOrder"/></span>
              </dsp:a>
            </li>
            <li>
              <dsp:a page="${mobileStorePrefix}/myaccount/myOrders.jsp" class="icon-ArrowRight">
                <span class="content"><fmt:message key="mobile.checkout.link.viewAllOrders"/></span>
              </dsp:a>
            </li>
          </ul>
        </div>
        <br/>
      </dsp:oparam>
    </dsp:droplet>
  </crs:mobilePageContainer>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/Storefront/j2ee/store.war/mobile/checkout/confirmResponse.jsp#7 $$Change: 805775 $ --%>
