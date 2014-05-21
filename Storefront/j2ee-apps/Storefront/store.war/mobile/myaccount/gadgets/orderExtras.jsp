<%--
  This gadget displays the "Order Extras" -- gift wrap and gift notes.

  Page includes:
    /mobile/global/gadgets/orderItemRenderer.jsp - Renders commerce item information
    /mobile/global/gadgets/giftNote.jsp - Render a gift note

  Required parameters:
    order
      Specifies an order to be displayed.

  Optional parameters:
    priceListLocale
      Specifies a locale in which to format the price (as string).
      If not specified, locale will be taken from profile price list (Profile.priceList.locale).
--%>
<dsp:page>
  <%-- Request parameters - to variables --%>
  <dsp:getvalueof var="giftWrapItem" param="order.giftWrapItem"/>
  <dsp:getvalueof var="containsGiftMessage" vartype="java.lang.String" param="order.containsGiftMessage"/>

  <c:if test='${not empty giftWrapItem || containsGiftMessage == "true"}'>
    <div class="orderExtrasTitle">
      <fmt:message key="mobile.order.extras.title"/>
    </div>

    <%-- Render order extras at the very end --%>
    <ul>
      <%-- Optional: Gift Wrap --%>
      <c:if test="${not empty giftWrapItem}">
        <li class="item">
          <dsp:include page="${mobileStorePrefix}/myaccount/gadgets/orderItemRenderer.jsp">
            <dsp:param name="commerceItem" value="${giftWrapItem}"/>
            <dsp:param name="priceListLocale" param="priceListLocale"/>
          </dsp:include>
        </li>
      </c:if>

      <%-- Gift Note --%>
      <c:if test='${containsGiftMessage == "true"}'>
        <li class="item">
          <dsp:include page="${mobileStorePrefix}/global/gadgets/giftNote.jsp">
            <dsp:param name="order" param="order"/>
            <dsp:param name="isCheckout" param="false"/>
          </dsp:include>
        </li>
      </c:if>
    </ul>

  </c:if>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/Storefront/j2ee/store.war/mobile/myaccount/gadgets/orderExtras.jsp#7 $$Change: 811974 $--%>
