<%--
  This gadget renders brief order summary for the return related pages. It will display:
    1. Order sub-total
    2. Applied discounts
    3. Shipping price
    4. Applied tax
    5. Order total

  Page includes:
    /global/gadgets/formattedPrice.jsp - Price formatter

  Required parameters:
    order
      Specifies an order whose summary should be displayed.

  Optional parameters:
    priceListLocale
      Specifies a locale in which to format the price (as string).
      If not specified, locale will be taken from profile price list (Profile.priceList.locale).
--%>
<dsp:page>
  <dsp:getvalueof var="order" param="order"/>

  <%-- Display 'Order Summary' header --%>
  <div class="sectionHeader"><fmt:message key="mobile.order.header.orderSummary"/></div>

  <div class="roundedBox">
    <%-- Display order subtotal. --%>
    <div class="label"><fmt:message key="mobile.order.label.subtotal"/></div>
    <div class="value">
      <dsp:getvalueof var="rawSubtotal" vartype="java.lang.Double" param="order.priceInfo.rawSubtotal"/>
      <dsp:include page="/global/gadgets/formattedPrice.jsp">
        <dsp:param name="price" value="${rawSubtotal}"/>
        <dsp:param name="priceListLocale" param="priceListLocale"/>
      </dsp:include>
    </div>

    <hr/>

    <%--
      Display applied discounts amount.
      First, check if there are applied discounts. If this is the case, display applied discounts amount.
    --%>
    <dsp:getvalueof var="discountAmount" vartype="java.lang.Double" param="order.priceInfo.discountAmount"/>
    <c:if test="${discountAmount > 0}">
      <div class="label"><fmt:message key="mobile.order.label.discount"/><fmt:message key="mobile.common.asterisk"/></div>
      <div class="value">
        <dsp:include page="/global/gadgets/formattedPrice.jsp">
          <dsp:param name="price" value="${-discountAmount}"/>
          <dsp:param name="priceListLocale" param="priceListLocale"/>
        </dsp:include>
      </div>
     <hr/>
    </c:if>

    <%-- Display shipping price and look for any discounts. --%>
    <dsp:getvalueof var="isShippingDiscounted" param="order.shippingGroups[0].priceInfo.discounted"/>

    <div class="label">
      <c:choose>
        <c:when test="${isShippingDiscounted}">
          <fmt:message key="mobile.common.shipping"/><fmt:message key="mobile.common.doubleasterisk"/>
        </c:when>
        <c:otherwise>
          <fmt:message key="mobile.common.shipping"/>
        </c:otherwise>
      </c:choose>
    </div>
    <div class="value">
      <dsp:getvalueof var="shipping" vartype="java.lang.Double" param="order.priceInfo.shipping"/>
      <dsp:include page="/global/gadgets/formattedPrice.jsp">
        <dsp:param name="price" value="${shipping}"/>
        <dsp:param name="priceListLocale" param="priceListLocale"/>
      </dsp:include>
    </div>

    <hr/>

    <%-- Display taxes amount --%>
    <div class="label"><fmt:message key="mobile.order.label.tax"/></div>
    <div class="value">
      <dsp:getvalueof var="tax" vartype="java.lang.Double" param="order.priceInfo.tax"/>
      <dsp:include page="/global/gadgets/formattedPrice.jsp">
        <dsp:param name="price" value="${tax}"/>
        <dsp:param name="priceListLocale" param="priceListLocale"/>
      </dsp:include>
    </div>

    <hr/>

    <%--
      Calculate store credits for this order.
      On the Order Details page, store credits should be calculated from the order itself.
      On checkout pages, store credits should be calculated from the current profile.
    --%>
    <dsp:getvalueof var="storeCreditAmount" vartype="java.lang.Double" param="order.storeCreditsAppliedTotal"/>
    <dsp:getvalueof var="total" vartype="java.lang.Double" param="order.priceInfo.total"/>

    <%-- Display calculated store credits amount only if there are credits to display --%>
    <c:if test="${storeCreditAmount > .0}">
      <div class="label"><fmt:message key="mobile.order.label.storeCredit"/></div>
      <div class="value">
        <dsp:include page="/global/gadgets/formattedPrice.jsp">
          <%--
            If it's an order details page, display storeCreditAmount (got from order).
            Otherwise compare order total and storeCreditAmount (available for the current user).
            If there are enough store credits to pay for order, display order's total.
            Display store credits otherwise.
          --%>
          <dsp:param name="price" value="${-storeCreditAmount}"/>
          <dsp:param name="priceListLocale" param="priceListLocale"/>
        </dsp:include>
      </div>
      <hr/>
    </c:if>

    <%-- Display order's total --%>
    <div class="label"><fmt:message key="mobile.common.label.total"/></div>
    <div class="value">
      <dsp:include page="/global/gadgets/formattedPrice.jsp">
        <%-- If there are enough store credits to pay for order, display order's total as 0 --%>
        <dsp:param name="price" value="${total > storeCreditAmount ? total - storeCreditAmount : 0}"/>
        <dsp:param name="priceListLocale" param="priceListLocale"/>
      </dsp:include>
    </div>
  </div>

  <%--
    Display all available pricing adjustments (i.e. discounts) except the first one.
    The first adjustment is always order's raw sub-total, and hence doesn't contain a discount.
  --%>
  <c:if test="${fn:length(order.priceInfo.adjustments) > 1}">
    <div class="discount">
      <span class="invisible"><fmt:message key="mobile.order.a11y.promotions"/></span>
      <c:forEach var="priceAdjustment" varStatus="status" items="${order.priceInfo.adjustments}" begin="1">
        <preview:repositoryItem item="${priceAdjustment.pricingModel}">
          <fmt:message key="mobile.common.asterisk"/>
          <dsp:tomap var="pricingModel" value="${priceAdjustment.pricingModel}"/>
          <c:out value="${pricingModel.description}" escapeXml="false"/>
        </preview:repositoryItem>
      </c:forEach>
    </div>
  </c:if>

  <%--
    Display all available shipping price adjustments.
  --%>
  <c:if test="${fn:length(order.shippingGroups[0].priceInfo.adjustments) > 0}">
    <div class="discount">
      <c:forEach var="priceAdjustment" items="${order.shippingGroups[0].priceInfo.adjustments}"
                 varStatus="status" begin="1">
        <preview:repositoryItem item="${priceAdjustment.pricingModel}">
          <fmt:message key="mobile.common.doubleasterisk"/>
          <dsp:tomap var="pricingModel" value="${priceAdjustment.pricingModel}"/>
          <c:out value="${pricingModel.description}" escapeXml="false"/>
        </preview:repositoryItem>
      </c:forEach>
    </div>
  </c:if>


</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/Storefront/j2ee/store.war/mobile/myaccount/gadgets/orderPricingSummary.jsp#7 $$Change: 811844 $--%>
