<%--
  Renders order "Payment Method" in summary form.

  Page includes:
    /mobile/creditcard/gadgets/creditCardRenderer.jsp - Renderer of credit card info

  Required parameters:
    order
      Order which payment data need to be displayed

  NOTES:
    1) The "mobileStorePrefix" request-scoped variable (request attribute), which is used here,
       is defined in the "mobilePageContainer" tag ("mobilePageContainer.tag" file).
       This variable becomes available within the <crs:mobilePageContainer> ... </crs:mobilePageContainer> block
       and in all the included pages (gadgets and Endeca cartridges).
--%>
<dsp:page>

  <div class="sectionHeader"><fmt:message key="mobile.order.label.payment"/></div>

  <%-- Request parameters - to variables --%>
  <%-- Get the payment group for billing address and payment method --%>
  <dsp:getvalueof var="paymentGroupRelationships" param="order.paymentGroupRelationships"/>
  <dsp:getvalueof var="order" param="order"/>
  <dsp:param name="paymentGroupClassType" value=""/>
  <c:forEach var="paymentGroupRelationship" items="${paymentGroupRelationships}">
    <dsp:getvalueof var="paymentGroup" value="${paymentGroupRelationship.paymentGroup}"/>
    <dsp:getvalueof var="paymentGroupClassType" value="${paymentGroup.paymentGroupClassType}"/>
    <c:if test="${paymentGroup.amount > 0}">
      <div class="roundedBox">
        <c:choose>
          <%--
            For credit card refund method display credit card's type and 4 last digits of
            credit card number.
          --%>
          <c:when test="${paymentGroupClassType == 'creditCard'}">
            <dsp:include page="${mobileStorePrefix}/myaccount/gadgets/creditCard.jsp">
              <dsp:param name="creditCard" value="${paymentGroup}"/>
              <dsp:param name="amount" value="${paymentGroup.amount}"/>
              <dsp:param name="priceListLocale" param="priceListLocale"/>
            </dsp:include>
          </c:when>
          <%-- Store credit refund method --%>
          <c:when test="${paymentGroupClassType == 'storeCredit'}">
            <div class="label"><fmt:message key="mobile.order.label.storeCredit"/></div>
            <%-- Amount applied to store credit --%>
            <div class="value">
              <dsp:include page="/global/gadgets/formattedPrice.jsp">
                <dsp:param name="price" value="${paymentGroup.amount}"/>
                <dsp:param name="priceListLocale" param="priceListLocale"/>
              </dsp:include>
            </div>
          </c:when>
        </c:choose>
      </div>
    </c:if>
  </c:forEach>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/Storefront/j2ee/store.war/mobile/myaccount/gadgets/orderPayment.jsp#5 $$Change: 812492 $--%>
