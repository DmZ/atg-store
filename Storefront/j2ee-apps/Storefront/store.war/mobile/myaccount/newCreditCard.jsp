<%--
  Renders "Create new credit card" page.

  Page includes:
    /mobile/myaccount/gadgets/myAccountTabBar.jsp - Display tab bar for the page
    /mobile/creditcard/gadgets/creditCardAddForm.jsp - Renderer of credit card add form

  Required parameters:
    None

  Optional parameters:
    None

  NOTES:
    1) The "mobileStorePrefix" request-scoped variable (request attribute), which is used here,
       is defined in the "mobilePageContainer" tag ("mobilePageContainer.tag" file).
       This variable becomes available within the <crs:mobilePageContainer> ... </crs:mobilePageContainer> block
       and in all the included pages (gadgets and Endeca cartridges).
--%>
<dsp:page>
  <dsp:importbean bean="/atg/userprofiling/ProfileFormHandler"/>

  <fmt:message key="mobile.creditcard.header.addCard" var="pageTitle"/>
  <crs:mobilePageContainer titleString="${pageTitle}">
    <jsp:body>
      <%-- ========== Navigation Tabs ========== --%>
      <fmt:message var="paymentInfoTitle" key="mobile.creditcard.paymentInfo"/>
      <dsp:include page="gadgets/myAccountTabBar.jsp">
        <dsp:param name="secondTabLabel" value="${paymentInfoTitle}"/>
        <dsp:param name="secondTabURL" value="${mobileStorePrefix}/myaccount/selectCreditCard.jsp"/>
        <dsp:param name="thirdTabLabel" value="${pageTitle}"/>
        <dsp:param name="highlight" value="third"/>
      </dsp:include>

      <div>
        <%-- ========== Form ========== --%>
        <dsp:form formid="newCreditCard" action="${pageContext.request.requestURI}" method="post">
          <%-- ========== Redirection URLs ========== --%>
          <dsp:input type="hidden" bean="ProfileFormHandler.createCardSuccessURL" value="creditCardAddressSelect.jsp"/>
          <dsp:input type="hidden" bean="ProfileFormHandler.createCardErrorURL" value="newCreditCard.jsp"/>

          <%-- Include "creditCardAddForm.jsp" to render credit card properties --%>
          <dsp:include page="../creditcard/gadgets/creditCardAddForm.jsp">
            <dsp:param name="formHandler" value="/atg/userprofiling/ProfileFormHandler"/>
            <dsp:param name="cardParamsMap" value="/atg/userprofiling/ProfileFormHandler.editValue"/>
            <dsp:param name="nicknameProperty" value="map"/>
            <dsp:param name="showDefaultCardOption" value="true"/>
          </dsp:include>
        </dsp:form>
      </div>
    </jsp:body>
  </crs:mobilePageContainer>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/Storefront/j2ee/store.war/mobile/myaccount/newCreditCard.jsp#5 $$Change: 800951 $--%>
