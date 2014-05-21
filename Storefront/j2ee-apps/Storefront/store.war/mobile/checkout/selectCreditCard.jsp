<%--
  This page fragment renders list of credit cards to select ("Pay With" step of "Checkout").

  Page includes:
    /mobile/global/gadgets/errorMessage.jsp - Displays all errors collected from FormHandler
    /mobile/creditcard/gadgets/savedCreditCards.jsp - List of saved credit cards

  Required parameters:
    None

  Optional parameters:
    None

  NOTES:
    1) The "mobileStorePrefix", "siteContextPath" request-scoped variables (request attributes), which are used here,
       are defined in the "mobilePageContainer" tag ("mobilePageContainer.tag" file).
       These variables become available within the <crs:mobilePageContainer> ... </crs:mobilePageContainer> block
       and in all the included pages (gadgets and Endeca cartridges).
--%>
<dsp:page>
  <dsp:importbean bean="/atg/store/droplet/ProfileSecurityStatus"/>
  <dsp:importbean bean="/atg/store/mobile/order/purchase/BillingFormHandler"/>
  <dsp:importbean bean="/atg/store/order/purchase/CouponFormHandler"/>

  <fmt:message var="pageTitle" key="mobile.checkout.billingInformation.pageTitle"/>
  <crs:mobilePageContainer titleString="${pageTitle}">
    <jsp:body>
      <div class="dataContainer">
        <h2><span><fmt:message key="mobile.checkout.label.payWith"/><fmt:message key="mobile.common.colon"/></span></h2>

        <%-- Display "BillingFormHandler" error messages, which were specified in "formException.message" --%>
        <dsp:include page="${mobileStorePrefix}/global/gadgets/errorMessage.jsp">
          <dsp:param name="formHandler" bean="BillingFormHandler"/>
        </dsp:include>

        <%-- ========== Form ========== --%>
        <dsp:form formid="selectCreditCard" action="${siteContextPath}/checkout/billingCVV.jsp?dispatchCSV=selectCard" method="post">
          <%-- ========== Redirection URLs ========== --%>
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

          <dsp:include page="${mobileStorePrefix}/creditcard/gadgets/savedCreditCards.jsp">
            <dsp:param name="page" value="checkout"/>
            <dsp:param name="selectable" value="true"/>
            <dsp:param name="displayDefaultLabeled" value="false"/>
            <dsp:param name="selectProperty" value="BillingFormHandler.storedCreditCardName"/>
          </dsp:include>

          <%-- "Coupon code" --%>
          <dsp:getvalueof var="couponCode" bean="CouponFormHandler.currentCouponCode"/>
          <dsp:input bean="CouponFormHandler.couponCode" priority="10" type="hidden" value="${couponCode}"/>
        </dsp:form>
      </div>

      <script>
        $(document).ready(function() {
          CRSMA.common.delayedSubmitSetup("#creditCardList");
        });
      </script>
    </jsp:body>
  </crs:mobilePageContainer>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/Storefront/j2ee/store.war/mobile/checkout/selectCreditCard.jsp#6 $$Change: 813916 $--%>
