<%--
  This page fragment renders page to create new card.

  Page includes:
    /mobile/creditcard/gadgets/creditCardAddForm.jsp - Credit card add form renderer

  Required parameters:
    None

  Optional parameters:
    None
--%>
<dsp:page>
  <dsp:importbean bean="/atg/commerce/order/purchase/RepriceOrderDroplet"/>
  <dsp:importbean bean="/atg/store/order/purchase/CouponFormHandler"/>
  <dsp:importbean bean="/atg/userprofiling/ProfileFormHandler"/>

  <fmt:message var="pageTitle" key="mobile.creditcard.newCreditCard"/>
  <crs:mobilePageContainer titleString="${pageTitle}">
    <jsp:body>
      <div>
        <h2><span><fmt:message key="mobile.checkout.header.newCreditCard"/></span></h2>

        <div>
          <%-- ========== Form ========== --%>
          <dsp:form formid="newCreditCard" action="${pageContext.request.requestURI}" method="post">
            <%-- ========== Redirection URLs ========== --%>
            <dsp:input type="hidden" bean="ProfileFormHandler.createCardSuccessURL" value="creditCardAddressSelect.jsp"/>
            <dsp:input type="hidden" bean="ProfileFormHandler.createCardErrorURL" value="newCreditCard.jsp"/>

            <%-- "Coupon code" --%>
            <dsp:getvalueof var="couponCode" bean="CouponFormHandler.currentCouponCode"/>
            <dsp:input bean="CouponFormHandler.couponCode" priority="10" type="hidden" value="${couponCode}"/>

            <%--
              If there are errors during form submition the current order is invalidated and doesn't contain priceInfo.
              Will reprice whole order in this case
            --%>
            <dsp:getvalueof var="formExceptions" bean="ProfileFormHandler.formExceptions"/>
            <c:if test="${not empty formExceptions}">
              <dsp:droplet name="RepriceOrderDroplet">
                <dsp:param name="pricingOp" value="ORDER_TOTAL"/>
              </dsp:droplet>
            </c:if>

            <%-- Include "creditCardAddForm.jsp" to render credit card properties --%>
            <dsp:include page="../creditcard/gadgets/creditCardAddForm.jsp">
              <dsp:param name="formHandler" value="/atg/userprofiling/ProfileFormHandler"/>
              <dsp:param name="cardParamsMap" value="atg/userprofiling/ProfileFormHandler.editValue"/>
              <dsp:param name="showSaveCardOption" value="true"/>
            </dsp:include>
          </dsp:form>
        </div>
      </div>
    </jsp:body>
  </crs:mobilePageContainer>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/Storefront/j2ee/store.war/mobile/checkout/newCreditCard.jsp#3 $$Change: 794175 $--%>
