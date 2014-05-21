<%--
  This gadget displays the "Order Extras": gift wrap and gift notes.

  Page includes:
    /mobile/address/gadgets/displayAddress.jsp - Renderer of address info
    /mobile/global/gadgets/orderItemRenderer.jsp - Renders commerce item information

  Required parameters:
    order
      Specifies an order to be displayed

  Optional parameters:
    priceListLocale
      Specifies a locale in which to format the price (as string).
      If not specified, locale will be taken from profile price list (Profile.priceList.locale).
--%>
<dsp:page>
  <dsp:getvalueof var="shippingGroups" vartype="java.util.Collection" param="order.shippingGroups"/>

  <c:forEach var="shippingGroup" items="${shippingGroups}">
    <%-- Address and shipping information --%>
    <div class="shippingInfoSection">
      <div class="shipToSection">
        <div><fmt:message key="mobile.common.shipTo"/><fmt:message key="mobile.common.colon"/></div>
        <div>
          <dsp:include page="${mobileStorePrefix}/address/gadgets/displayAddress.jsp">
            <dsp:param name="address" value="${shippingGroup.shippingAddress}"/>
            <dsp:param name="isPrivate" value="false"/>
          </dsp:include>
        </div>
      </div>
      <div class="viaSection">
        <div><fmt:message key="mobile.return.header.shippingMethod"/><fmt:message key="mobile.common.colon"/></div>
        <dsp:getvalueof var="shippingMethod" value="${shippingGroup.shippingMethod}"/>
        <span><fmt:message key="mobile.return.label.delivery${fn:replace(shippingMethod, ' ', '')}"/></span>
      </div>
    </div>

    <%-- Commerce items within each shipping group --%>
    <dsp:getvalueof var="commerceItemRelationships" vartype="java.util.Collection" value="${shippingGroup.commerceItemRelationships}"/>
    <c:forEach var="commerceItemRelationship" items="${commerceItemRelationships}" varStatus="status">
      <dsp:param name="currentItem" value="${commerceItemRelationship.commerceItem}"/>
      <dsp:getvalueof var="commerceItemClassType" param="currentItem.commerceItemClassType"/>

      <%-- Do not display a Gift Wrap here: it will be shown later --%>
      <c:if test="${commerceItemClassType != 'giftWrapCommerceItem'}">
        <dsp:droplet name="/atg/store/droplet/StorePriceBeansDroplet">

          <dsp:param name="order" param="order"/>
          <dsp:param name="relationship" value="${commerceItemRelationship}" />

          <%-- pricing beans for commerce item relationsjop--%>
          <dsp:oparam name="output">
            <dsp:getvalueof var="itemQuantity" param="priceBeansQuantity" />
            <dsp:getvalueof var="itemAmount" param="priceBeansAmount" />
          </dsp:oparam>
        </dsp:droplet>
        <ul>
          <dsp:include page="${mobileStorePrefix}/myaccount/gadgets/orderItemRenderer.jsp">
            <dsp:param name="commerceItem" param="currentItem"/>
            <dsp:param name="itemQuantity" value="${itemQuantity}"/>
            <dsp:param name="itemAmount" value="${itemAmount}"/>
            <dsp:param name="priceListLocale" param="priceListLocale"/>
          </dsp:include>
        </ul>
      </c:if>
    </c:forEach>
  </c:forEach>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/Storefront/j2ee/store.war/mobile/myaccount/gadgets/orderMultiShippingInfo.jsp#8 $$Change: 813260 $--%>
