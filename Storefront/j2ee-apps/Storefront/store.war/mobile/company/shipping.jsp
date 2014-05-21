<%--
  This page displays Shipping Rates of the Merchant.

  Page includes:
    None

  Required Parameters:
    None

  Optional Parameters:
    None
--%>
<dsp:page>
  <fmt:message var="pageTitle" key="mobile.moreInfo.shippingAndReturns"/>
  <crs:mobilePageContainer titleString="${pageTitle}">
    <jsp:body>
      <div class="infoHeader">
        <fmt:message key="mobile.company.shipping.header"/>
      </div>
      <div class="infoContent">
        <crs:outMessage key="company_shipping.text"/>
      </div>
    </jsp:body>
  </crs:mobilePageContainer>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/Storefront/j2ee/store.war/mobile/company/shipping.jsp#2 $$Change: 789440 $ --%>
