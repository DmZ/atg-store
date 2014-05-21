<%--
  Renderer of credit card info.

  Page includes:
    None

  Required parameters:
    creditCard
      Credit card to be displayed.
    showFullInfo
      "true" to show full info, as "Country", "Billing Address, Phone".

  Optional parameters:
    None
--%>
<dsp:page>
  <%-- Request parameters - to variables --%>
  <dsp:getvalueof var="showFullInfo" param="showFullInfo"/>

  <div class="vcard">
    <div class="cardType">
      <%-- Display only last 4 digits --%>
      <dsp:getvalueof var="creditCardNumber" param="creditCard.creditCardNumber"/>
      <c:set var="creditCardNumberLength" value="${fn:length(creditCardNumber)}"/>
      <dsp:getvalueof var="expirationYear" param="creditCard.expirationYear"/>
      <c:set var="expirationYearLength" value="${fn:length(expirationYear)}"/>

      <span>
        <dsp:getvalueof var="creditCardType" param="creditCard.creditCardType"/>
        <fmt:message key="mobile.creditcard.dropdown.${creditCardType}"/>
      </span>
      <span class="cardNumber"><fmt:message key="mobile.common.ellipsis"/><c:out value="${fn:substring(creditCardNumber,creditCardNumberLength-4,creditCardNumberLength)}"/></span>
      <span class="cardExpiration"><fmt:message key="mobile.creditcard.label.expirationDate" />: <dsp:valueof param="creditCard.expirationMonth"/>/<c:out value="${fn:substring(expirationYear,expirationYearLength-2,expirationYearLength)}"/></span>
    </div>

    <dsp:getvalueof var="billingAddress" param="creditCard.billingAddress"/>
    <c:choose>
      <c:when test="${billingAddress != null}">
        <div class="firstName">
          <dsp:valueof param="creditCard.billingAddress.firstName"/>&nbsp;<dsp:valueof param="creditCard.billingAddress.lastName"/>
        </div>
        <div>
          <div><dsp:valueof param="creditCard.billingAddress.address1"/><fmt:message key="mobile.common.comma"/></div>
          <%-- Display state --%>
          <span><dsp:valueof param="creditCard.billingAddress.city"/><fmt:message key="mobile.common.comma"/></span>
          <dsp:getvalueof var="state" param="creditCard.billingAddress.state"/>
          <c:if test="${not empty state}">
            <span><dsp:valueof param="creditCard.billingAddress.state"/></span>
          </c:if>

          <%-- ZIP-code, Country name and Phone --%>
          <span><dsp:valueof param="creditCard.billingAddress.postalCode"/></span>

          <c:if test="${showFullInfo == 'true'}">
            <br/>
            <dsp:droplet name="/atg/store/droplet/CountryListDroplet">
              <dsp:param name="userLocale" bean="/atg/dynamo/servlet/RequestLocale.locale"/>
              <dsp:param name="countryCode" param="creditCard.billingAddress.country"/>
              <dsp:oparam name="false">
                <dsp:valueof param="countryDetail.displayName"/>
              </dsp:oparam>
            </dsp:droplet>
            <br/>
            <dsp:valueof param="creditCard.billingAddress.phoneNumber"/>
          </c:if>
        </div>
      </c:when>
      <c:otherwise>
        <div class="firstName">
          <fmt:message key="mobile.creditcard.error.missingBillingAddress"/>
        </div>
      </c:otherwise>
    </c:choose>
  </div>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/Storefront/j2ee/store.war/mobile/creditcard/gadgets/creditCardRenderer.jsp#7 $$Change: 804135 $--%>
