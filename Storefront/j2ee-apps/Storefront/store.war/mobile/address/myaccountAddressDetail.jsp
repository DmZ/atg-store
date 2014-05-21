<%--
  This page serves adding/editing of Shipping/Billing addresses for "My Account".

  Page includes:
    /mobile/myaccount/gadgets/myAccountTabBar.jsp - Display tab bar for the page
    /mobile/address/gadgets/addressAddEdit.jsp - Renders address form (except "Nickname" field)
    /mobile/includes/crsRedirect.jspf - Renderer of the redirect prompt to the full CRS site

  Required parameters:
    addrOper
      'edit' = edit address
      'add' = add address
    addrType
      'shipping' = add/edit Shipping address
      'billing' = add/edit Billing address

  Optional parameters:
    cardOper
      'edit' = edit credit card
      'add' = add credit card
      NOTE: this parameter is only valid for "Edit Billing Address"
    editAddrNickname
      "Nickname" of the address that is being edited
    deletable
      Flag to mark address item as deletable.
      NOTE: this parameter is only valid for "Edit Shipping Address"

  NOTES:
    1) The "mobileStorePrefix", "siteContextPath" request-scoped variables (request attributes), which are used here,
       are defined in the "mobilePageContainer" tag ("mobilePageContainer.tag" file).
       These variables become available within the <crs:mobilePageContainer> ... </crs:mobilePageContainer> block
       and in all the included pages (gadgets and Endeca cartridges).
--%>
<dsp:page>
  <dsp:importbean bean="/atg/userprofiling/ProfileFormHandler"/>
  <dsp:importbean bean="/atg/userprofiling/Profile"/>

  <%-- Request parameters - to variables --%>
  <dsp:getvalueof var="editAddrNickname" param="editAddrNickname"/>
  <dsp:getvalueof var="addrType" param="addrType"/>
  <dsp:getvalueof var="addrOper" param="addrOper"/>
  <dsp:getvalueof var="cardOper" param="cardOper"/>
  <dsp:getvalueof var="deletable" param="deletable"/>

  <%-- FormHandler "address" property name --%>
  <c:set var="addrPropertyName">
    <c:choose>
      <c:when test="${cardOper == 'add' && addrOper == 'add'}">/atg/userprofiling/ProfileFormHandler.billAddrValue</c:when>
      <c:otherwise>/atg/userprofiling/ProfileFormHandler.editValue</c:otherwise>
    </c:choose>
  </c:set>

  <%-- ========== Handle form exceptions ========== --%>
  <dsp:getvalueof var="formExceptions" bean="ProfileFormHandler.formExceptions"/>
  <jsp:useBean id="errorMap" class="java.util.HashMap"/>
  <c:if test="${not empty formExceptions}">
    <c:forEach var="formException" items="${formExceptions}">
      <c:set var="errorCode" value="${formException.errorCode}"/>
      <c:choose>
        <c:when test="${errorCode == 'errorDuplicateNickname'}">
          <c:set target="${errorMap}" property="nickname" value="inUse"/>
        </c:when>
        <c:when test="${errorCode == 'stateIsIncorrect'}">
          <c:set target="${errorMap}" property="state" value="invalidValue"/>
          <c:set target="${errorMap}" property="country" value="invalidValue"/>
        </c:when>
        <c:when test="${errorCode == 'missingRequiredValue'}">
          <c:set var="propertyName" value="${formException.propertyName}"/>
          <%--
            "Nickname" may have different names: "nickname", "newNickname"
          --%>
          <c:if test="${propertyName == 'newNickname'}">
            <c:set var="propertyName" value="nickname"/>
          </c:if>
          <c:set target="${errorMap}" property="${propertyName}" value="mandatoryField"/>
        </c:when>
      </c:choose>
    </c:forEach>
  </c:if>

  <fmt:message var="pageTitle" key="mobile.address.header.editAddress"/>
  <crs:mobilePageContainer titleString="${pageTitle}">
    <jsp:attribute name="modalContent">
      <c:if test="${addrType == 'shipping' && addrOper == 'edit'}">
        <c:choose>
          <c:when test="${deletable == 'true'}">
            <%-- "Remove address" modal dialog template --%>
            <div class="moveDialog">
              <div class="moveItems">
                <ul class="dataList">
                  <li class="remove">
                    <fmt:message key="mobile.address.link.delete" var="deleteText"/>
                    <dsp:a title="${deleteText}" bean="ProfileFormHandler.removeAddress" value="${editAddrNickname}"
                           href="addressBook.jsp" id="removeLink" iclass="icon-Remove">
                      <fmt:message key="mobile.common.button.delete"/>
                    </dsp:a>
                  </li>
                </ul>
              </div>
            </div>
          </c:when>
          <c:otherwise>
            <%-- Modal dialog when address can't be deleted due to gift list redirect for Full CRS --%>
            <div id="modalMessageBox">
              <div id="modalInclude">
                <c:set var="successURL" value="addressBook.jsp"/>
                <fmt:message var="topString" key="mobile.addresses.message.redirectTopString"/>
                <fmt:message var="bottomString" key="mobile.address.message.redirectBottomString"/>
                <%@include file="../includes/crsRedirect.jspf"%>
              </div>
            </div>
          </c:otherwise>
        </c:choose>
      </c:if>
    </jsp:attribute>

    <jsp:body>
      <%-- ========== Navigation Tabs ========== --%>
      <fmt:message var="thirdTabLabel">
        <c:if test="${addrType == 'shipping' && addrOper == 'edit'}">mobile.address.header.editAddress</c:if>
        <c:if test="${addrType == 'shipping' && addrOper == 'add'}">mobile.address.header.addAddress</c:if>
        <c:if test="${addrType == 'billing' && cardOper == 'edit'}">mobile.creditcard.link.editCard</c:if>
        <c:if test="${addrType == 'billing' && cardOper == 'add'}">mobile.creditcard.header.addCard</c:if>
      </fmt:message>
      <fmt:message var="secondTabLabel">
        <c:if test="${addrType == 'shipping'}">mobile.address.addressBook</c:if>
        <c:if test="${addrType == 'billing'}">mobile.creditcard.paymentInfo</c:if>
      </fmt:message>
      <c:set var="secondTabURL">
        <c:if test="${addrType == 'shipping'}">${mobileStorePrefix}/address/addressBook.jsp</c:if>
        <c:if test="${addrType == 'billing'}">${mobileStorePrefix}/myaccount/selectCreditCard.jsp</c:if>
      </c:set>
      <dsp:include page="${mobileStorePrefix}/myaccount/gadgets/myAccountTabBar.jsp">
        <dsp:param name="secondTabLabel" value="${secondTabLabel}"/>
        <dsp:param name="secondTabURL" value="${secondTabURL}"/>
        <dsp:param name="thirdTabLabel" value="${thirdTabLabel}"/>
        <dsp:param name="highlight" value="third"/>
      </dsp:include>

      <div class="dataContainer">
        <%-- ========== Form ========== --%>
        <dsp:form action="${pageContext.request.requestURI}" method="post">
          <%-- ========== Redirection URLs ========== --%>
          <c:url value="${pageContext.request.requestURI}" var="errorURL" context="/">
            <c:param name="addrOper" value="${addrOper}"/>
            <c:param name="addrType" value="${addrType}"/>
            <c:param name="cardOper" value="${cardOper}"/>
            <c:if test="${addrOper == 'edit'}">
              <c:param name="editAddrNickname" value="${editAddrNickname}"/>
              <c:param name="deletable" value="${deletable}"/>
            </c:if>
          </c:url>
          <c:set var="successURL">
            <c:choose>
              <c:when test="${addrType == 'billing'}">
                <c:if test="${cardOper == 'add'}">
                  <c:if test="${addrOper == 'edit'}">${siteContextPath}/myaccount/creditCardAddressSelect.jsp</c:if>
                  <c:if test="${addrOper == 'add'}">${siteContextPath}/myaccount/selectCreditCard.jsp</c:if>
                </c:if>
              </c:when>
              <c:otherwise>addressBook.jsp</c:otherwise> <%-- Shipping address --%>
            </c:choose>
          </c:set>
          <dsp:input type="hidden" bean="ProfileFormHandler.successURL" value="${successURL}"/>
          <dsp:input type="hidden" bean="ProfileFormHandler.errorURL" value="${errorURL}"/>

          <ul class="dataList">
            <%-- Display "Nickname" for specific contexts only --%>
            <c:if test="${!(addrType == 'billing' && addrOper == 'add' && cardOper == 'edit')}">
              <%-- "Nickname" --%>
              <li ${not empty errorMap['nickname'] ? 'class="errorState"' : ''}>
                <div class="content">
                  <fmt:message var="nickPlace" key="mobile.address.input.placeholder.addressNickname"/>
                  <c:if test="${addrOper == 'edit'}">
                    <dsp:input type="hidden" bean="${addrPropertyName}.nickname"/>
                    <dsp:input type="text" bean="${addrPropertyName}.newNickname" maxlength="42" required="true"
                               placeholder="${nickPlace}" aria-label="${nickPlace}"/>
                  </c:if>
                  <c:if test="${addrOper == 'add' && addrType == 'shipping'}">
                    <dsp:input type="text" bean="${addrPropertyName}.nickname" maxlength="42" required="true"
                               placeholder="${nickPlace}" aria-label="${nickPlace}"/>
                  </c:if>
                  <c:if test="${addrOper == 'add' && addrType == 'billing'}">
                    <dsp:input type="text" bean="${addrPropertyName}.shippingAddrNickname" maxlength="42" required="true"
                               placeholder="${nickPlace}" aria-label="${nickPlace}"/>
                  </c:if>
                </div>
                <c:if test="${not empty errorMap['nickname']}">
                  <span class="errorMessage">
                    <fmt:message key="mobile.common.error.${errorMap['nickname']}"/>
                  </span>
                </c:if>
              </li>
            </c:if>

            <%-- Include "addressAddEdit.jsp" to render address properties --%>
            <dsp:include page="gadgets/addressAddEdit.jsp">
              <dsp:param name="formHandlerComponent" value="${addrPropertyName}"/>
              <dsp:param name="restrictionDroplet" value="/atg/store/droplet/ShippingRestrictionsDroplet"/>
              <dsp:param name="errorMap" value="${errorMap}"/>
            </dsp:include>

            <%-- Checkbox: "Make this my default address" --%>
            <c:if test="${addrType == 'shipping'}">
              <li>
                <dsp:getvalueof var="defaultAddressId" bean="Profile.shippingAddress.repositoryId"/>
                <dsp:getvalueof var="currentAddressId" bean="${addrPropertyName}.addressId"/>
                <div class="content">
                  <div class="checkBox">
                    <dsp:input type="checkbox" name="useShippingAddressAsDefault" id="addresses_useShippingAddressAsDefault"
                               bean="ProfileFormHandler.useShippingAddressAsDefault"
                               checked="${defaultAddressId == currentAddressId}"/>
                    <label for="addresses_useShippingAddressAsDefault" onclick="">
                      <fmt:message key="mobile.addresses.label.defaultAddress"/>
                    </label>
                  </div>
                </div>
              </li>
            </c:if>

            <%-- "Delete" button --%>
            <c:if test="${addrType == 'shipping' && addrOper == 'edit'}">
              <li>
                <div class="deleteContainer">
                  <fmt:message var="deleteText" key="mobile.address.link.delete"/>
                  <div onclick="${deletable ? 'CRSMA.common.removeItemDialog($(this).parent())' : 'CRSMA.myaccount.toggleCantDeleteAddressDialog()'}" title="${deleteText}" class="icon-Remove">
                    ${deleteText}
                  </div>
                </div>
              </li>
            </c:if>
          </ul>

          <%-- Hidden input: "Make this my default address" --%>
          <c:if test="${addrType == 'billing' && addrOper == 'edit' && cardOper == 'edit'}">
            <%-- "Edit Credit Card / Edit Billing Address" --%>
            <dsp:getvalueof var="defaultAddressId" bean="Profile.shippingAddress.repositoryId"/>
            <dsp:getvalueof var="currentAddressId" bean="${addrPropertyName}.addressId"/>
            <dsp:input type="hidden" bean="ProfileFormHandler.useShippingAddressAsDefault"
                       value="${defaultAddressId == currentAddressId}"/>
          </c:if>

          <%-- "Submit" button --%>
          <div class="centralButton">
            <c:set var="submitBtnHandleMethod">
              <c:if test="${addrType == 'shipping' && addrOper == 'edit'}">ProfileFormHandler.updateAddress</c:if>
              <c:if test="${addrType == 'shipping' && addrOper == 'add'}">ProfileFormHandler.newAddress</c:if>
              <c:if test="${addrType == 'billing'  && cardOper == 'add'  && addrOper == 'add'}">ProfileFormHandler.createNewCreditCardAndAddress</c:if>
              <c:if test="${addrType == 'billing'  && cardOper == 'add'  && addrOper == 'edit'}">ProfileFormHandler.updateAddress</c:if>
              <c:if test="${addrType == 'billing'  && cardOper == 'edit' && addrOper == 'add'}">ProfileFormHandler.newAddress</c:if>
              <c:if test="${addrType == 'billing'  && cardOper == 'edit' && addrOper == 'edit'}">ProfileFormHandler.updateAddress</c:if>
            </c:set>
            <fmt:message var="submitBtnValue" key="mobile.myAccount.button.saveAddress"/>
            <dsp:input bean="${submitBtnHandleMethod}" class="mainActionButton" type="submit" value="${submitBtnValue}"/>
          </div>
        </dsp:form>
      </div>
    </jsp:body>
  </crs:mobilePageContainer>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/Storefront/j2ee/store.war/mobile/address/myaccountAddressDetail.jsp#9 $$Change: 800951 $--%>
