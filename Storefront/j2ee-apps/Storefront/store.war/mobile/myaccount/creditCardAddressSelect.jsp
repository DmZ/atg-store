<%--
  Renders all stored addresses to select as Billing one for created credit card.
  This page is the next step after "newCreditCard.jsp".

  Page includes:
    /mobile/myaccount/gadgets/myAccountTabBar.jsp - Display tab bar for the page
    /mobile/myaccount/gadgets/billingAddressesList.jsp - List of available Billing addresses to select

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

  <fmt:message var="pageTitle" key="mobile.creditcard.header.addCard"/>
  <crs:mobilePageContainer titleString="${pageTitle}">
    <jsp:body>
      <%-- ========== Navigation tabs ========== --%>
      <fmt:message var="secondTabLabel" key="mobile.creditcard.paymentInfo"/>
      <dsp:include page="gadgets/myAccountTabBar.jsp">
        <dsp:param name="secondTabLabel" value="${secondTabLabel}"/>
        <dsp:param name="secondTabURL" value="${mobileStorePrefix}/myaccount/selectCreditCard.jsp"/>
        <dsp:param name="thirdTabLabel" value="${pageTitle}"/>
        <dsp:param name="highlight" value="third"/>
      </dsp:include>

      <div class="dataContainer">
        <%-- ========== Form ========== --%>
        <dsp:form action="${pageContext.request.requestURI}" method="post">
          <%-- ========== Redirection URLs ========== --%>
          <dsp:input type="hidden" bean="ProfileFormHandler.createCardSuccessURL" value="selectCreditCard.jsp"/>
          <dsp:input type="hidden" bean="ProfileFormHandler.createCardErrorURL" value="newCreditCard.jsp"/>

          <dsp:include page="gadgets/billingAddressesList.jsp"/>

          <dsp:input type="hidden" bean="ProfileFormHandler.createNewCreditCard" value="createNewCreditCard" priority="-10"/>
        </dsp:form>

        <script>
          $(document).ready(function() {
            CRSMA.common.delayedSubmitSetup("#savedBillingAddresses");
          });
        </script>
      </div>
    </jsp:body>
  </crs:mobilePageContainer>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/Storefront/j2ee/store.war/mobile/myaccount/creditCardAddressSelect.jsp#6 $$Change: 800951 $--%>
