<%--
  This page displays refund payment methods (credit card or store credit). For each payment method
  the details are displayed and the amount applied to the refund method.

  Page includes:
    /global/gadgets/formattedPrice.jsp - Price formatter
    /mobile/address/gadgets/displayAddress.jsp - Renderer of address info

  Required parameters:
    return
      The ReturnReqeust object to display refund summary for.

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
  <%-- Request parameters - to variables --%>
  <dsp:getvalueof var="return" param="return"/>

  <%-- Refund Methods title --%>
  <div class="sectionHeader"><fmt:message key="mobile.return.header.refundMethods"/></div>

  <c:forEach var="refundMethod" items="${return.refundMethodList}">
    <c:if test="${refundMethod.amount > 0}">
      <div class="roundedBox">
        <c:choose>
          <%--
            For credit card refund method display credit card's type and 4 last digits of
            credit card number.
          --%>
          <c:when test="${refundMethod.refundType == 'creditCard'}">
            <dsp:include page="${mobileStorePrefix}/myaccount/gadgets/creditCard.jsp">
              <dsp:param name="creditCard" value="${refundMethod.creditCard}"/>
              <dsp:param name="amount" value="${refundMethod.amount}"/>
              <dsp:param name="priceListLocale" value="${priceListLocale}"/>
            </dsp:include>
          </c:when>
          <%-- Store credit refund method --%>
          <c:when test="${refundMethod.refundType == 'storeCredit'}">
            <div class="label"><fmt:message key="mobile.order.label.storeCredit"/></div>
            <%-- Amount applied to store credit --%>
            <div class="value">
              <dsp:include page="/global/gadgets/formattedPrice.jsp">
                <dsp:param name="price" value="${refundMethod.amount}"/>
                <dsp:param name="priceListLocale" param="priceListLocale"/>
              </dsp:include>
            </div>
            <hr/>
            <div><fmt:message key="mobile.return.label.storeCreditNote"/></div>
          </c:when>
        </c:choose>
      </div>
    </c:if>
  </c:forEach>
</dsp:page>
