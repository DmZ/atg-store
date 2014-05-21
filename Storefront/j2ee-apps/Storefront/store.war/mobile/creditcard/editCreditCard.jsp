<%--
  Credit card detail page: Edit mode.

  Page includes:
    /mobile/myaccount/gadgets/myAccountTabBar.jsp - Display tab bar for the page
    /mobile/creditcard/gadgets/creditCardEditForm.jsp credit - Card edit form

  Required parameters:
    page
      'myaccount' - This page is called in "My Account" context
      'checkout' - This page is called in "Checkout" context

  Optional parameters:
    None

  NOTES:
    1) The "mobileStorePrefix", "siteContextPath" request-scoped variables (request attributes), which are used here,
       are defined in the "mobilePageContainer" tag ("mobilePageContainer.tag" file).
       These variables become available within the <crs:mobilePageContainer> ... </crs:mobilePageContainer> block
       and in all the included pages (gadgets and Endeca cartridges).
--%>
<dsp:page>
  <dsp:importbean bean="/atg/userprofiling/ProfileFormHandler"/>

  <%-- Request parameters - to variables --%>
  <dsp:getvalueof var="page" param="page"/>

  <fmt:message var="pageTitle" key="mobile.creditcard.link.editCard"/>
  <crs:mobilePageContainer titleString="${pageTitle}">
    <jsp:attribute name="modalContent">
      <dsp:getvalueof var="cardNickname" bean="ProfileFormHandler.editValue.nickname"/>
      <div class="moveDialog">
        <div class="moveItems">
          <ul class="dataList">
            <li class="remove">
              <fmt:message key="mobile.common.button.delete" var="removeText"/>
              <fmt:message key="mobile.creditcard.link.deleteCard" var="removeCard"/>
              <c:set var="removeCardSuccessUrl" value="${siteContextPath}/${page}/selectCreditCard.jsp"/>
              <dsp:a title="${removeCard}" bean="ProfileFormHandler.removeCard" value="${cardNickname}"
                     id="removeLink" iclass="icon-Remove" href="${removeCardSuccessUrl}">${removeText}</dsp:a>
            </li>
          </ul>
        </div>
      </div>
    </jsp:attribute>

    <jsp:body>
      <%-- ========== Navigation tabs ========== --%>
      <c:if test="${page == 'myaccount'}">
        <fmt:message var="paymentInfoTitle" key="mobile.creditcard.paymentInfo"/>
        <dsp:include page="${mobileStorePrefix}/myaccount/gadgets/myAccountTabBar.jsp">
          <dsp:param name="secondTabLabel" value="${paymentInfoTitle}"/>
          <dsp:param name="secondTabURL" value="${mobileStorePrefix}/myaccount/selectCreditCard.jsp"/>
          <dsp:param name="thirdTabLabel" value="${pageTitle}"/>
          <dsp:param name="highlight" value="third"/>
        </dsp:include>
      </c:if>

      <div class="dataContainer">
        <%-- ========== Form ========== --%>
        <dsp:form formid="editCreditCard" action="${pageContext.request.requestURI}" method="post">
          <%-- ========== Redirection URLs ========== --%>
          <c:set var="successURL">
            <c:if test="${page == 'myaccount'}">${siteContextPath}/myaccount/selectCreditCard.jsp</c:if>
            <c:if test="${page == 'checkout'}">${siteContextPath}/checkout/billing.jsp</c:if>
          </c:set>
          <c:url value="${pageContext.request.requestURI}" var="errorURL" context="/">
            <c:param name="page" value="${page}"/>
          </c:url>
          <dsp:input type="hidden" bean="ProfileFormHandler.updateCardSuccessURL" value="${successURL}"/>
          <dsp:input type="hidden" bean="ProfileFormHandler.updateCardErrorURL" value="${errorURL}"/>

          <%-- Include "creditCardEditForm.jsp" to render credit card properties --%>
          <dsp:include page="gadgets/creditCardEditForm.jsp">
            <dsp:param name="page" value="${page}"/>
          </dsp:include>
        </dsp:form>
      </div>
    </jsp:body>
  </crs:mobilePageContainer>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/Storefront/j2ee/store.war/mobile/creditcard/editCreditCard.jsp#6 $$Change: 800951 $--%>
