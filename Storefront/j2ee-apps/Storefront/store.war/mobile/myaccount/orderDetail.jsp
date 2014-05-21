<%--
  Renders "Order details".

  Page includes:
    /mobile/myaccount/myOrders.jsp - List of all orders (used to display message if order is multi-shipped)
    /mobile/myaccount/gadgets/myAccountTabBar.jsp - Display tab bar for the page
    /mobile/myaccount/gadgets/orderDetailIntro.jsp - Renders order state, submitted date, and site information
    /mobile/myaccount/gadgets/orderDetailReturns.jsp -  Renders order returns, exchanges and original order id
      information and return items action button
    /mobile/myaccount/gadgets/orderMultiShippingInfo.jsp - Renders shipping groups and items in each group
    /mobile/myaccount/gadgets/orderExtras.jsp - Renders gift wrap and gift note
    /mobile/myaccount/gadgets/orderPricingSummary.jsp - Renders order pricing summary
    /mobile/myaccount/gadgets/orderPayment.jsp - Renders payment method (credit card or store credit only supported)

  Required parameters:
    orderId
      Order id

  Optional parameters:
    None.

--%>
<dsp:page>
  <dsp:importbean bean="/atg/commerce/order/OrderLookup"/>

  <dsp:getvalueof var="mobileStorePrefix" bean="/atg/store/StoreConfiguration.mobileStorePrefix"/>

  <c:set var="orderDetailsTitle">
    <fmt:message key="common.order"/><fmt:message key="mobile.common.colon"/><span><dsp:valueof param="orderId"/></span>
  </c:set>
  <c:set var="pageTitle">
    <fmt:message key="common.order"/><fmt:message key="mobile.common.colon"/><dsp:valueof param="orderId"/>
  </c:set>

  <dsp:droplet name="OrderLookup">
    <dsp:param name="orderId" param="orderId"/>

    <dsp:oparam name="output">

      <%--
        Retrieve the price list locale used for order. It will be used to format prices correctly.
         We can't use Profile's price list here as already submitted order can be priced with price
         list different from current profile price list.
      --%>
      <dsp:getvalueof var="commerceItems" param="result.commerceItems"/>
      <c:if test="${not empty commerceItems}">
        <dsp:getvalueof var="priceListLocale" vartype="java.lang.String" param="result.commerceItems[0].priceInfo.priceList.locale"/>
      </c:if>

      <crs:mobilePageContainer titleString="${pageTitle}">
        <jsp:body>
          <%-- ========== Tab header ========== --%>
          <fmt:message var="previousPageTitle" key="mobile.myAccount.tab.myOrders"/>
          <c:set var="previousPageURL" value="${mobileStorePrefix}/myaccount/myOrders.jsp"/>
          <dsp:include page="${mobileStorePrefix}/myaccount/gadgets/myAccountTabBar.jsp">
            <dsp:param name="secondTabLabel" value="${previousPageTitle}"/>
            <dsp:param name="secondTabURL" value="${previousPageURL}"/>
            <dsp:param name="thirdTabLabel" value="${orderDetailsTitle}"/>
            <dsp:param name="highlight" value="third"/>
          </dsp:include>

          <div class="detailsContainer">
            <form action="#">
              <%-- ========== Order intro (state, site, etc.) ========== --%>
              <dsp:include page="${mobileStorePrefix}/myaccount/gadgets/orderDetailIntro.jsp">
                <dsp:param name="order" param="result"/>
              </dsp:include>

              <%-- ========== Returns/exchanges and start return button ========== --%>
              <dsp:include page="${mobileStorePrefix}/myaccount/gadgets/orderDetailReturns.jsp">
                <dsp:param name="order" param="result"/>
              </dsp:include>

              <%-- ========== Order items by shipping group, order extras and pricing summary ========== --%>
              <dsp:include page="${mobileStorePrefix}/myaccount/gadgets/orderMultiShippingInfo.jsp">
                <dsp:param name="order" param="result"/>
                <dsp:param name="priceListLocale" value="${priceListLocale}"/>
              </dsp:include>

              <%-- ========== Order Extras ========== --%>
              <dsp:include page="${mobileStorePrefix}/myaccount/gadgets/orderExtras.jsp">
                <dsp:param name="order" param="result"/>
                <dsp:param name="priceListLocale" value="${priceListLocale}"/>
              </dsp:include>

              <%-- ========== Order pricing summary ========== --%>
              <dsp:include page="${mobileStorePrefix}/myaccount/gadgets/orderPricingSummary.jsp">
                <dsp:param name="order" param="result"/>
                <dsp:param name="priceListLocale" value="${priceListLocale}"/>
              </dsp:include>

              <%-- ========== Payment Information (Method and Billing Address) ========== --%>
              <dsp:include page="${mobileStorePrefix}/myaccount/gadgets/orderPayment.jsp">
                <dsp:param name="order" param="result"/>
                <dsp:param name="isCheckout" param="false"/>
                <dsp:param name="priceListLocale" value="${priceListLocale}"/>
              </dsp:include>
            </form>
          </div>
        </jsp:body>
      </crs:mobilePageContainer>
    </dsp:oparam>

    <dsp:oparam name="error">
      <crs:mobilePageContainer titleString="${pageTitle}">
        <jsp:body>
          <div class="infoHeader">
            <fmt:message key="mobile.myAccount.noOrderId.error">
               <fmt:param><dsp:valueof param="orderId"/></fmt:param>
            </fmt:message>
          </div>
        </jsp:body>
      </crs:mobilePageContainer>
    </dsp:oparam>
  </dsp:droplet>
</dsp:page>
