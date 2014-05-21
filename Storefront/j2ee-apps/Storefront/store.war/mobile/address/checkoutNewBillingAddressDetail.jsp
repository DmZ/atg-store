<%--
  This page serves the following "Checkout" address detail contexts:
    - Checkout / New Credit Card / New Billing Address
    - Checkout / Edit Credit Card / New Billing Address

  Page includes:
    /mobile/address/gadgets/addressAddEdit.jsp - Renders address form (except "Nickname" field)

  Required parameters:
    cardOper
      'edit' = edit credit card
      'add' = add card

  NOTES:
    1) The "siteContextPath", "isLoggedIn" request-scoped variables (request attributes), which are used here,
       are defined in the "mobilePageContainer" tag ("mobilePageContainer.tag" file).
       These variables become available within the <crs:mobilePageContainer> ... </crs:mobilePageContainer> block
       and in all the included pages (gadgets and Endeca cartridges).
--%>
<dsp:page>
  <dsp:importbean bean="/atg/store/order/purchase/CouponFormHandler"/>
  <dsp:importbean bean="/atg/userprofiling/ProfileFormHandler"/>

  <%-- Request parameters - to variables --%>
  <dsp:getvalueof var="cardOper" param="cardOper"/>

  <%-- FormHandler "address" property name --%>
  <c:set var="addrPropertyName">
    <c:if test="${cardOper == 'add'}">/atg/userprofiling/ProfileFormHandler.billAddrValue</c:if>
    <c:if test="${cardOper == 'edit'}">/atg/userprofiling/ProfileFormHandler.editValue</c:if>
  </c:set>

  <%-- ========== Handle form exceptions ========== --%>
  <dsp:getvalueof var="formExceptions" bean="ProfileFormHandler.formExceptions"/>
  <jsp:useBean id="errorMap" class="java.util.HashMap"/>
  <c:if test="${not empty formExceptions}">
    <c:forEach var="formException" items="${formExceptions}">
      <c:set var="errorCode" value="${formException.errorCode}"/>
      <c:choose>
        <c:when test="${errorCode == 'stateIsIncorrect'}">
          <c:if test="${empty errorMap['state']}">
            <%-- This is because "missingRequiredValue" error code is also set in this case --%>
            <c:set target="${errorMap}" property="state" value="invalidValue"/>
          </c:if>
          <c:if test="${empty errorMap['country']}">
            <%-- This is because "missingRequiredValue" error code is also set in this case --%>
            <c:set target="${errorMap}" property="country" value="invalidValue"/>
          </c:if>
        </c:when>
        <c:when test="${errorCode == 'missingRequiredValue'}">
          <c:set var="propertyName" value="${formException.propertyName}"/>
          <c:set target="${errorMap}" property="${propertyName}" value="mandatoryField"/>
        </c:when>
      </c:choose>
    </c:forEach>
  </c:if>

  <fmt:message key="mobile.common.newBillingAddress" var="pageTitle"/>
  <crs:mobilePageContainer titleString="${pageTitle}">
    <jsp:body>
      <div class="dataContainer">
        <%-- ========== Form header ========== --%>
        <h2><fmt:message key="mobile.common.newBillingAddress"/></h2>

        <%-- ========== Form ========== --%>
        <dsp:form action="${pageContext.request.requestURI}" method="post">
          <%-- ========== Redirection URLs ========== --%>
          <c:url value="${pageContext.request.requestURI}" var="errorURL" context="/">
            <c:param name="cardOper" value="${cardOper}"/>
          </c:url>
          <c:if test="${cardOper == 'add'}">
            <dsp:input type="hidden" bean="ProfileFormHandler.createBillingAddressSuccessURL"
                       value="${siteContextPath}/checkout/billingCVV.jsp?dispatchCSV=newCardNewAddress"/>
            <dsp:input type="hidden" bean="ProfileFormHandler.createBillingAddressErrorURL" value="${errorURL}"/>

            <%-- "Coupon code" --%>
            <dsp:getvalueof var="couponCode" bean="CouponFormHandler.currentCouponCode"/>
            <dsp:input bean="CouponFormHandler.couponCode" priority="10" type="hidden" value="${couponCode}"/>
          </c:if>

          <ul class="dataList">
            <%-- Include "addressAddEdit.jsp" to render address properties --%>
            <dsp:include page="gadgets/addressAddEdit.jsp">
              <dsp:param name="formHandlerComponent" value="${addrPropertyName}"/>
              <dsp:param name="restrictionDroplet" value="/atg/store/droplet/ShippingRestrictionsDroplet"/>
              <dsp:param name="errorMap" value="${errorMap}"/>
            </dsp:include>

            <c:if test="${cardOper == 'add'}">
              <%--
                If the shopper is a guest shopper, we don't offer to save the address.
                Otherwise set "saveBillingAddress" to false to override default value of true.
              --%>
              <c:choose>
                <c:when test="${isLoggedIn}">
                  <li>
                    <div class="content">
                      <dsp:input type="checkbox" bean="ProfileFormHandler.billAddrValue.saveBillingAddress"
                                 checked="true" id="saveBillingAddress"/>
                      <label for="saveBillingAddress" onclick=""><fmt:message key="mobile.address.label.saveAddress"/></label>
                    </div>
                  </li>
                </c:when>
                <c:otherwise>
                  <dsp:input type="hidden" bean="ProfileFormHandler.billAddrValue.saveBillingAddress" value="false"/>
                </c:otherwise>
              </c:choose>
            </c:if>
          </ul>

          <%-- "Submit" button --%>
          <div class="centralButton">
            <c:set var="submitBtnHandleMethod">
              <c:if test="${cardOper == 'add'}">ProfileFormHandler.createBillingAddress</c:if>
              <c:if test="${cardOper == 'edit'}">ProfileFormHandler.newAddress</c:if>
            </c:set>
            <fmt:message var="submitBtnValue" key="mobile.common.button.done"/>
            <dsp:input bean="${submitBtnHandleMethod}" class="mainActionButton" type="submit" priority="-10" value="${submitBtnValue}"/>
          </div>
        </dsp:form>
      </div>
    </jsp:body>
  </crs:mobilePageContainer>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/Storefront/j2ee/store.war/mobile/address/checkoutNewBillingAddressDetail.jsp#6 $$Change: 803979 $--%>
