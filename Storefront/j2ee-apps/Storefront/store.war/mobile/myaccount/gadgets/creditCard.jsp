<%--
  This page displays a credit card details and the amount applied to the payment.

  Page includes:
    /global/gadgets/formattedPrice.jsp - Price formatter
    /mobile/address/gadgets/displayAddress.jsp - Renderer of address info

  Required parameters:
    creditCard
      The credit-card to display.

    amount
      The amount applied to the credit-card.
      
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
  <dsp:getvalueof var="creditCard" param="creditCard"/>
  <dsp:getvalueof var="amount" param="amount"/>

  <div class="label">
    <dsp:getvalueof var="creditCardType" value="${creditCard.creditCardType}"/>
    <fmt:message key="mobile.creditcard.dropdown.${creditCardType}"/>
    <crs:trim message='${creditCard.creditCardNumber}' length='4' fromEnd='true'/>

    <%-- Display expiration date --%>
    <fmt:formatNumber var="expirationMonth" minIntegerDigits="2" value="${creditCard.expirationMonth}"/>
    <c:set var="expirationYear" value="${creditCard.expirationYear}"/>
    <span class="expirationDate">
      <fmt:message key="mobile.return.creditcard.label.expirationDate"/> ${expirationMonth}/${expirationYear}
    </span>
  </div>
    
  <div class="value">
    <%-- Amount applied to the credit card refund method --%>
    <dsp:include page="/global/gadgets/formattedPrice.jsp">
      <dsp:param name="price" value="${amount}"/>
      <dsp:param name="priceListLocale" param="priceListLocale"/>
    </dsp:include>
  </div>

  <%-- Display billing address for the credit card --%>
  <div class="billingAddress">
    <dsp:include page="${mobileStorePrefix}/address/gadgets/displayAddress.jsp">
      <dsp:param name="address" value="${creditCard.billingAddress}"/>
      <dsp:param name="isPrivate" value="false"/>
    </dsp:include>
  </div>

</dsp:page>
