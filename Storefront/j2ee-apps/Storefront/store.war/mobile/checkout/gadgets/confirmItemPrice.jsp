<%--
  Displays price details including quantity, discounted price, promotion applied and old price.

  Page includes:
    /global/gadgets/formattedPrice.jsp - Price formatter

  Required parameters:
    quantity
      Item quantity
    price
      Item price
    oldPrice
      List price for item (before applying discounts)

  Optional parameters:
    priceListLocale
      Specifies a locale in which to format the price (as string).
      If not specified, locale will be taken from profile price list (Profile.priceList.locale).
--%>
<dsp:page>
  <%-- Request parameters - to variables --%>
  <dsp:getvalueof var="quantity" param="quantity"/>
  <dsp:getvalueof var="price" param="price"/>
  <dsp:getvalueof var="oldPrice" param="oldPrice"/>

  <dsp:include page="/global/gadgets/formattedPrice.jsp">
    <dsp:param name="price" value="${price}"/>
    <dsp:param name="saveFormattedPrice" value="true"/>
    <dsp:param name="priceListLocale" param="priceListLocale"/>
  </dsp:include>

  <span class="${fn:length(formattedPrice) > 7 ? 'longPrice' : ''}">
    <c:if test="${not empty quantity}">
      <span class="quantity">
        <fmt:formatNumber value="${quantity}" type="number"/>
      </span>
    </c:if>
    <span class="rateOf"><fmt:message key="mobile.common.price.atRateOf"/></span>
    <c:if test="${not empty price}">
      <span class="newPrice">${formattedPrice}</span>
    </c:if>
    <c:if test="${not empty oldPrice}">
      <br/>
      <span class="oldPrice">
        <fmt:message key="mobile.common.priceWas"/><span> </span>
        <del>
          <dsp:include page="/global/gadgets/formattedPrice.jsp">
            <dsp:param name="price" value="${oldPrice}"/>
            <dsp:param name="priceListLocale" param="priceListLocale"/>
          </dsp:include>
        </del>
      </span>
    </c:if>
  </span>
  <br/>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/Storefront/j2ee/store.war/mobile/checkout/gadgets/confirmItemPrice.jsp#4 $$Change: 804252 $--%>
