<%--
  This page serves the following "Checkout" address detail contexts:
    - Checkout / New Credit Card / Edit Billing Address
    - Checkout / Edit Credit Card / Edit Billing Address
    - Checkout / New Shipping Address
    - Checkout / Edit Shipping Address

  Page includes:
    /mobile/address/gadgets/addressAddEdit.jsp - Renders address form (except "Nickname" field)

  Required parameters:
    addrOper
      'edit' = edit address
      'add' = add address
    addrType
      'shipping' = add/edit Shipping address
      'billing' = edit Billing address

  Optional parameters:
    cardOper
      'edit' = edit credit card
      'add' = add card
      NOTE: this parameter is only valid for "Edit Billing Address" contexts
    editAddrNickname
      "Nickname" of the address that is being edited.
      NOTE: this parameter is only valid for "Edit Address" contexts
    shipToAddressName
      "Nickname" of Default Shipping address.
      NOTE: This parameter is only valid for "Edit Shipping Address" context

  NOTES:
    1) The "siteContextPath" request-scoped variable (request attribute), which is used here,
       is defined in the "mobilePageContainer" tag ("mobilePageContainer.tag" file).
       This variable becomes available within the <crs:mobilePageContainer> ... </crs:mobilePageContainer> block
       and in all the included pages (gadgets and Endeca cartridges).
--%>
<dsp:page>
  <dsp:importbean bean="/atg/commerce/order/purchase/ShippingGroupFormHandler"/>
  <dsp:importbean bean="/atg/store/droplet/ProfileSecurityStatus"/>
  <dsp:importbean bean="/atg/store/mobile/order/purchase/BillingFormHandler"/>
  <dsp:importbean bean="/atg/store/order/purchase/CouponFormHandler"/>
  <dsp:importbean bean="/atg/userprofiling/ProfileFormHandler"/>
  <dsp:importbean bean="/atg/userprofiling/Profile"/>

  <%-- Request parameters - to variables --%>
  <dsp:getvalueof var="addrType" param="addrType"/>
  <dsp:getvalueof var="addrOper" param="addrOper"/>
  <dsp:getvalueof var="cardOper" param="cardOper"/>
  <dsp:getvalueof var="editAddrNickname" param="editAddrNickname"/>
  <dsp:getvalueof var="shipToAddressName" param="shipToAddressName"/>

  <%-- FormHandler "address" property name --%>
  <c:set var="addrPropertyName">
    <c:choose>
      <c:when test="${addrType == 'shipping' && addrOper == 'add'}">/atg/commerce/order/purchase/ShippingGroupFormHandler.address</c:when>
      <c:otherwise>/atg/commerce/order/purchase/ShippingGroupFormHandler.editAddress</c:otherwise>
    </c:choose>
  </c:set>

  <%-- ========== Handle form exceptions ========== --%>
  <dsp:getvalueof var="formExceptions" bean="ShippingGroupFormHandler.formExceptions"/>
  <jsp:useBean id="errorMap" class="java.util.HashMap"/>
  <c:if test="${not empty formExceptions}">
    <c:forEach var="formException" items="${formExceptions}">
      <c:set var="errorCode" value="${formException.errorCode}"/>
      <c:choose>
        <c:when test="${errorCode == 'duplicateNickname'}">
          <c:set target="${errorMap}" property="nickname" value="inUse"/>
        </c:when>
        <c:when test="${errorCode == 'stateIsIncorrect'}">
          <c:set target="${errorMap}" property="state" value="invalidValue"/>
          <c:set target="${errorMap}" property="country" value="invalidValue"/>
        </c:when>
        <c:when test="${errorCode == 'missingRequiredValue'}">
          <c:set var="propertyName" value="${formException.propertyName}"/>
          <%--
            "Nickname" may have different names: "shippingAddressNewNickName", "newShipToAddressName"
          --%>
          <c:if test="${propertyName == 'shippingAddressNewNickName' || propertyName == 'newShipToAddressName'}">
            <c:set var="propertyName" value="nickname"/>
          </c:if>
          <c:set target="${errorMap}" property="${propertyName}" value="mandatoryField"/>
        </c:when>
      </c:choose>
    </c:forEach>
  </c:if>

  <fmt:message key="mobile.common.shipping" var="pageTitle"/>
  <crs:mobilePageContainer titleString="${pageTitle}">
    <jsp:attribute name="modalContent">
      <%-- "Remove address" modal dialog --%>
      <c:if test="${addrType == 'shipping' && addrOper == 'edit'}">
        <div class="moveDialog">
          <div class="moveItems">
            <ul class="dataList">
              <li class="remove">
                <fmt:message var="removeAddressTitle" key="mobile.address.link.delete"/>
                <dsp:a title="${removeAddressTitle}" bean="ProfileFormHandler.removeAddress" value="${editAddrNickname}"
                       href="${siteContextPath}/checkout/shipping.jsp" id="removeLink" iclass="icon-Remove">
                  <fmt:message key="mobile.common.button.delete"/>
                </dsp:a>
              </li>
            </ul>
          </div>
        </div>
      </c:if>
    </jsp:attribute>

    <jsp:body>
      <c:if test="${addrOper == 'edit'}">
        <c:if test="${not empty editAddrNickname}">
          <dsp:setvalue bean="ShippingGroupFormHandler.editShippingAddressNickName" paramvalue="editAddrNickname"/>
          <dsp:setvalue bean="ShippingGroupFormHandler.shippingAddressNewNickName" paramvalue="editAddrNickname"/>
        </c:if>
        <%-- Init address property (editAddress) from the "editShippingAddressNickName" --%>
        <dsp:setvalue bean="ShippingGroupFormHandler.initEditAddressForm" value=""/>
      </c:if>

      <div class="dataContainer">
        <%-- ========== Form header ========== --%>
        <fmt:message var="formHeader">
          <c:if test="${addrType == 'shipping' && addrOper == 'edit'}">mobile.address.header.editAddress</c:if>
          <c:if test="${addrType == 'shipping' && addrOper == 'add'}">mobile.address.header.newAddress</c:if>
          <c:if test="${addrType == 'billing'}">mobile.address.header.editBillingAddress</c:if>
        </fmt:message>
        <h2>${formHeader}</h2>

        <%-- ========== Form ========== --%>
        <dsp:form action="${pageContext.request.requestURI}" method="post">
          <%-- ========== Redirection URLs ========== --%>
          <c:url value="${pageContext.request.requestURI}" var="errorURL" context="/">
            <c:param name="addrOper" value="${addrOper}"/>
            <c:param name="addrType" value="${addrType}"/>
            <c:param name="cardOper" value="${cardOper}"/>
            <c:if test="${addrOper == 'edit'}">
              <c:param name="editAddrNickname" value="${editAddrNickname}"/>
              <c:param name="shipToAddressName" value="${shipToAddressName}"/>
            </c:if>
          </c:url>
          <c:if test="${addrType == 'shipping' && addrOper == 'add'}">
            <dsp:input type="hidden" bean="ShippingGroupFormHandler.shipToNewAddressSuccessURL"
                       value="${siteContextPath}/checkout/shippingMethod.jsp"/>
            <dsp:input type="hidden" bean="ShippingGroupFormHandler.shipToNewAddressErrorURL" value="${errorURL}"/>

            <dsp:input type="hidden" bean="ShippingGroupFormHandler.address.email" beanvalue="Profile.email"/>
            <dsp:input type="hidden" bean="ShippingGroupFormHandler.address.ownerId" beanvalue="Profile.id"/>
          </c:if>
          <c:if test="${addrType == 'shipping' && addrOper == 'edit'}">
            <dsp:input type="hidden" bean="ShippingGroupFormHandler.editShippingAddressSuccessURL"
                       value="${siteContextPath}/checkout/shipping.jsp"/>
            <dsp:input type="hidden" bean="ShippingGroupFormHandler.editShippingAddressErrorURL" value="${errorURL}"/>

            <dsp:input type="hidden" bean="ShippingGroupFormHandler.shipToAddressName" paramvalue="shipToAddressName"/>
          </c:if>
          <c:if test="${addrType == 'billing' && cardOper == 'add'}">
            <dsp:input type="hidden" bean="ShippingGroupFormHandler.editShippingAddressSuccessURL"
                       value="${siteContextPath}/checkout/creditCardAddressSelect.jsp"/>
            <dsp:input type="hidden" bean="ShippingGroupFormHandler.editShippingAddressErrorURL" value="${errorURL}"/>

            <%-- "Coupon code" --%>
            <dsp:getvalueof var="couponCode" bean="CouponFormHandler.currentCouponCode"/>
            <dsp:input bean="CouponFormHandler.couponCode" priority="10" type="hidden" value="${couponCode}"/>
          </c:if>

          <%-- Session expiration URL --%>
          <dsp:droplet name="ProfileSecurityStatus">
            <dsp:oparam name="anonymous">
              <dsp:input type="hidden" name="sessionExpirationURL" bean="BillingFormHandler.sessionExpirationURL"
                         value="${siteContextPath}"/>
            </dsp:oparam>
            <dsp:oparam name="default">
              <dsp:input type="hidden" name="sessionExpirationURL" bean="BillingFormHandler.sessionExpirationURL"
                         value="${siteContextPath}/checkout/login.jsp"/>
            </dsp:oparam>
          </dsp:droplet>

          <ul class="dataList">
            <%-- "Nickname" --%>
            <li ${not empty errorMap['nickname'] ? 'class="errorState"' : ''}>
              <div class="content">
                <fmt:message var="nickPlace" key="mobile.address.input.placeholder.addressNickname"/>
                <c:if test="${addrOper == 'edit'}">
                  <dsp:input type="hidden" bean="ShippingGroupFormHandler.editShippingAddressNickName"/>
                  <dsp:input type="text" bean="ShippingGroupFormHandler.shippingAddressNewNickName"
                             maxlength="42" required="true" placeholder="${nickPlace}" aria-label="${nickPlace}"/>
                </c:if>
                <c:if test="${addrOper == 'add'}">
                  <dsp:input type="text" bean="ShippingGroupFormHandler.newShipToAddressName"
                             maxlength="42" required="true" placeholder="${nickPlace}" aria-label="${nickPlace}"/>
                </c:if>
              </div>
              <c:if test="${not empty errorMap['nickname']}">
                <span class="errorMessage">
                  <fmt:message key="mobile.common.error.${errorMap['nickname']}"/>
                </span>
              </c:if>
            </li>

            <%-- Include "addressAddEdit.jsp" to render address properties --%>
            <dsp:include page="gadgets/addressAddEdit.jsp">
              <dsp:param name="formHandlerComponent" value="${addrPropertyName}"/>
              <dsp:param name="restrictionDroplet" value="/atg/store/droplet/ShippingRestrictionsDroplet"/>
              <dsp:param name="errorMap" value="${errorMap}"/>
            </dsp:include>

            <c:if test="${addrType == 'shipping' && addrOper == 'edit'}">
              <%-- "Delete" button --%>
              <li>
                <div class="deleteContainer">
                  <fmt:message key="mobile.address.link.delete" var="deleteText"/>
                  <div onclick="CRSMA.common.removeItemDialog($(this).parent());" title="${deleteText}" class="icon-Remove">
                    ${deleteText}
                  </div>
                </div>
              </li>
            </c:if>
          </ul>

          <%-- "Submit" button --%>
          <div class="centralButton">
            <c:set var="submitBtnHandleMethod">
              <c:if test="${addrType == 'billing' || addrOper == 'edit'}">ShippingGroupFormHandler.editShippingAddress</c:if>
              <c:if test="${addrType == 'shipping' && addrOper == 'add'}">ShippingGroupFormHandler.shipToNewAddress</c:if>
            </c:set>
            <fmt:message var="submitBtnValue" key="mobile.common.button.done"/>
            <dsp:input bean="${submitBtnHandleMethod}" class="mainActionButton" type="submit" value="${submitBtnValue}"/>
          </div>
        </dsp:form>
      </div>
    </jsp:body>
  </crs:mobilePageContainer>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/Storefront/j2ee/store.war/mobile/address/checkoutAddressDetail.jsp#8 $$Change: 813916 $--%>
