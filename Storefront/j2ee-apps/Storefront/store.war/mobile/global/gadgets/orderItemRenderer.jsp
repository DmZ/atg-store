<%--
  Renders commerce item information.

  Page includes:
    /mobile/global/gadgets/productLinkGenerator.jsp - Product link generator
    /mobile/cart/gadgets/cartItemImg.jsp - Item image renderer
    /mobile/global/util/displaySkuProperties.jsp - Display list of SKU properties
    /mobile/checkout/gadgets/confirmDetailedItemPrice.jsp - Display price details of the item

  Required parameters:
    order
      Order to be proceed
    currentItem
      Item to be displayed
    isCheckout
      Indicator if this order is about to checkout or has already been placed.
      Possible values:
        'true' = is about to checkout
        'false' = placed order

  Optional parameters:
    priceListLocale
      Specifies a locale in which to format the price (as string).
      If not specified, locale will be taken from profile price list (Profile.priceList.locale). 

  NOTES:
    1) The "mobileStorePrefix" request-scoped variable (request attribute), which is used here,
       is defined in the "mobilePageContainer" tag ("mobilePageContainer.tag" file).
       This variable becomes available within the <crs:mobilePageContainer> ... </crs:mobilePageContainer> block
       and in all the included pages (gadgets and Endeca cartridges).
--%>
<dsp:page>
  <dsp:importbean bean="/atg/store/droplet/StorePriceBeansDroplet"/>

  <%-- Request parameters - to variables --%>
  <dsp:getvalueof var="currentItem" vartype="atg.commerce.order.CommerceItem" param="currentItem"/>
  <dsp:getvalueof var="navigable" vartype="java.lang.Boolean" param="currentItem.auxiliaryData.productRef.NavigableProducts"/>
  <dsp:getvalueof var="isCheckout" param="isCheckout"/>
  <dsp:getvalueof var="commerceItemClassType" param="currentItem.commerceItemClassType"/>

  <%--
    Generate price beans for each product row on page. We will use them to display all applied
    discounts per cart item.

    Input Parameters:
      order
        The order to generate the price beans for.

    Open Parameters:
      output
        Always rendered.

    Output Parameters:
      priceBeansMap
        A map whose key is the commerce item id and whose value is a price bean.
  --%>
  <dsp:droplet name="StorePriceBeansDroplet">
    <dsp:param name="order" param="order"/>
    <dsp:param name="item" param="currentItem"/>

    <dsp:oparam name="output">
      <dsp:getvalueof var="priceBeans" param="priceBeans"/>
      <dsp:getvalueof var="priceBeansQuantity" param="priceBeansQuantity"/>
      <dsp:getvalueof var="priceBeansAmount" param="priceBeansAmount"/>
      <dsp:getvalueof var="gwpPriceBeansQuantity" param="gwpPriceBeansQuantity"/>
    </dsp:oparam>
  </dsp:droplet>

  <c:if test="${commerceItemClassType == 'giftWrapCommerceItem'}">
    <c:set var="cursorType" value="defaultCursor"/>
  </c:if>

  <div class="cartItem ${cursorType}">
    <div class="itemImage">
      <dsp:include page="${mobileStorePrefix}/cart/gadgets/cartItemImg.jsp">
        <dsp:param name="commerceItem" param="currentItem"/>
      </dsp:include>
    </div>
    <div class="itemDescription">
      <p class="name">
        <%-- Link to the product detail page --%>
        <c:choose>
          <c:when test="${commerceItemClassType != 'giftWrapCommerceItem'}"> <%-- do not link to gift wrap --%>
            <dsp:include page="${mobileStorePrefix}/global/gadgets/productLinkGenerator.jsp">
              <dsp:param name="product" param="currentItem.auxiliaryData.productRef"/>
              <dsp:param name="siteId" param="currentItem.auxiliaryData.siteId"/>
            </dsp:include>
          </c:when>
          <c:otherwise>
            <%-- be sure there is no URL otherwise it's the last one --%>
            <c:set var="productUrl" scope="request" value=""/>
          </c:otherwise>
        </c:choose>
        <c:choose>
          <c:when test="${not empty productUrl && not isCheckout}">
            <%-- We do not need to read any parameters as order is already been placed --%>
            <dsp:a href="${fn:escapeXml(productUrl)}">
              <dsp:valueof param="currentItem.auxiliaryData.productRef.displayName">
                <fmt:message key="mobile.productDetails.message.noDisplayName"/>
              </dsp:valueof>
            </dsp:a>
          </c:when>
          <c:otherwise>
            <dsp:valueof param="currentItem.auxiliaryData.productRef.displayName">
              <fmt:message key="mobile.productDetails.message.noDisplayName"/>
            </dsp:valueof>
          </c:otherwise>
        </c:choose>
      </p>

      <p class="properties">
        <dsp:include page="${mobileStorePrefix}/global/util/displaySkuProperties.jsp">
          <dsp:param name="product" param="currentItem.auxiliaryData.productRef"/>
          <dsp:param name="sku" param="currentItem.auxiliaryData.catalogRef"/>
        </dsp:include>
      </p>
    </div>
    <div class="price">
      <div class="priceContent">
        <dsp:include page="${mobileStorePrefix}/checkout/gadgets/confirmDetailedItemPrice.jsp">
          <dsp:param name="commerceItem" value="${currentItem}"/>
          <dsp:param name="priceBeans" value="${priceBeans}"/>
          <dsp:param name="priceBeansQuantity" value="${priceBeansQuantity}"/>
          <dsp:param name="priceListLocale" param="priceListLocale"/>
        </dsp:include>
      </div>
    </div>
  </div>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/Storefront/j2ee/store.war/mobile/global/gadgets/orderItemRenderer.jsp#2 $$Change: 804252 $--%>
