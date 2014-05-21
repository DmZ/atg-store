<%-- 
  Render order items with order summary box.

  Page includes:
    /mobile/global/gadgets/errorMessage.jsp - Displays all errors collected from FormHandler
    /mobile/global/gadgets/orderItemRenderer.jsp - Order items renderer
    /mobile/global/gadgets/pricingSummary.jsp - Checkout summary

  Required parameters:
    order
      Order which items should be displayed
    isCheckout
      Indicator if this order is about to checkout or has already been placed.
      Possible values:
        'true' = is about to checkout
        'false' = placed order

  Optional parameters:
    priceListLocale
      Specifies a locale in which to format the price (as string).
      If not specified, locale will be taken from profile price list (Profile.priceList.locale). 
--%>
<dsp:page>
  <dsp:importbean bean="/atg/store/order/purchase/CouponFormHandler"/>

  <%-- Request parameters - to variables --%>
  <dsp:getvalueof var="isCheckout" param="isCheckout"/>
  <dsp:getvalueof var="commerceItems" param="order.commerceItems"/>

  <div class="roundedBox">
    <c:if test="${not empty commerceItems}">
      <div class="cartItems">
        <c:if test="${isCheckout}">
          <%-- Display "CouponFormHandler" error messages, which were specified in "formException.message" --%>
          <dsp:include page="errorMessage.jsp">
            <dsp:param name="formHandler" bean="CouponFormHandler"/>
          </dsp:include>
        </c:if>
        <c:forEach var="currentItem" items="${commerceItems}">
          <dsp:include page="orderItemRenderer.jsp">
            <dsp:param name="currentItem" value="${currentItem}"/>
            <dsp:param name="isCheckout" param="isCheckout"/>
            <dsp:param name="order" param="order"/>
            <dsp:param name="priceListLocale" param="priceListLocale"/>
          </dsp:include>
        </c:forEach>
      </div>
    </c:if>

    <dsp:include page="pricingSummary.jsp">
      <dsp:param name="order" param="order"/>
      <dsp:param name="isCheckout" param="isCheckout"/>
      <dsp:param name="isOrderReview" value="true"/>
    </dsp:include>
  </div>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/Storefront/j2ee/store.war/mobile/global/gadgets/reviewOrderItems.jsp#5 $$Change: 804252 $--%>
