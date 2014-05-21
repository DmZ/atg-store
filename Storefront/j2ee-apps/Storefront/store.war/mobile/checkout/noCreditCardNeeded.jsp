<%--
  Displays a message telling the user that their order was entirely paid for by
  store credit and therefore no credit card is needed.

  Page includes:
    None

  Required parameters:
    None

  Optional parameters:
    None

  NOTES:
    1) The "siteContextPath" request-scoped variable (request attribute), which is used here,
       is defined in the "mobilePageContainer" tag ("mobilePageContainer.tag" file).
       This variable becomes available within the <crs:mobilePageContainer> ... </crs:mobilePageContainer> block
       and in all the included pages (gadgets and Endeca cartridges).
--%>
<dsp:page>
  <dsp:importbean bean="/atg/store/mobile/order/purchase/BillingFormHandler"/>

  <fmt:message var="pageTitle" key="mobile.checkout.billingInformation.pageTitle"/>
  <crs:mobilePageContainer titleString="${pageTitle}">
    <jsp:body>
      <div class="storeCheckout">
        <dsp:form formid="billingCVV" action="${siteContextPath}/checkout/billingCVV.jsp" method="post">
          <dsp:getvalueof var="dispatchCSV" param="dispatchCSV"/>
          <br/>
          <h4 align="center">
            <%-- Display 'Order's total is 0' message --%>
            <fmt:message key="checkout_billing.yourOrderTotal"/>
            <dsp:include page="/global/gadgets/formattedPrice.jsp">
              <dsp:param name="price" value="0"/>
            </dsp:include>
          </h4>
          <br/>
          <p align="center">
            <fmt:message key="checkout_billing.yourOrderTotalMessage"/>
          </p>
          <br/>
          <div class="centralButton">
            <dsp:input type="hidden" value="${siteContextPath}/checkout/confirm.jsp" bean="BillingFormHandler.moveToConfirmSuccessURL"/>
            <fmt:message var="submitBtnValue" key="mobile.common.button.continue"/>
            <dsp:input bean="BillingFormHandler.moveToConfirm" type="submit" class="mainActionButton" value="${submitBtnValue}"/>
          </div>
        </dsp:form>
      </div>
    </jsp:body>
  </crs:mobilePageContainer>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/Storefront/j2ee/store.war/mobile/checkout/noCreditCardNeeded.jsp#6 $$Change: 813916 $--%>
