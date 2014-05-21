<%--
  Renders a stored address. "Nickname" of the address is not displayed here.
  If required, it must be rendered just before a include to this JSP.

  Required parameters:
    address
      "ContactInfo" repository item (address data) to display.
    isPrivate
      Indicator if the details of the "address.address1", "address.address2" should be hidden
      Possible values:
        - true
        - false
--%>
<dsp:page>
  <%-- Request parameters - to variables --%>
  <dsp:getvalueof var="isPrivate" param="isPrivate"/>

  <%--
    Condition to determine the CountryCode so that Country-specific Address formats can be rendered.
    Currently only default has been included for US Address formats.
    The condition is used as a place holder for future extensibility when multiple countries will be supported.
  --%>
  <dsp:getvalueof var="addressValue" param="address.country"/>
  <c:if test='${addressValue != ""}'>
    <%-- US Address format --%>
    <div class="vcard">
      <div>
        <span><dsp:valueof param="address.firstName"/></span>
        <span><dsp:valueof param="address.middleName"/></span>
        <span><dsp:valueof param="address.lastName"/></span>
      </div>

      <div>
        <%-- Display private address details --%>
        <c:if test="${isPrivate == 'false'}">
          <div><dsp:valueof param="address.address1"/></div>
          <dsp:getvalueof var="address2" param="address.address2"/>
          <c:if test="${not empty address2}">
            <div><c:out value="${address2}"/></div>
          </c:if>
        </c:if>

        <span><dsp:valueof param="address.city"/><fmt:message key="mobile.common.comma"/></span>
        <dsp:getvalueof var="state" param="address.state"/>
        <c:if test="${not empty state}">
          <span><c:out value="${state}"/></span>
        </c:if>

        <span><dsp:valueof param="address.postalCode"/></span>
        <div>
          <dsp:droplet name="/atg/store/droplet/CountryListDroplet">
            <dsp:param name="userLocale" bean="/atg/dynamo/servlet/RequestLocale.locale"/>
            <dsp:param name="countryCode" param="address.country"/>
              <dsp:oparam name="false">
              <span><dsp:valueof param="countryDetail.displayName"/></span>
            </dsp:oparam>
          </dsp:droplet>
        </div>
      </div>
      <div>
        <%-- Add invisible text to enhance VoiceOver experience --%>
        <span class="invisible"><fmt:message key="mobile.address.a11y.phoneNumber"/></span>
        <dsp:valueof param="address.phoneNumber"/>
      </div>
    </div>
  </c:if>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/Storefront/j2ee/store.war/mobile/address/gadgets/displayAddress.jsp#6 $$Change: 804511 $--%>
