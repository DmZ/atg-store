<%--
  Renders content of address form, except "Nickname" field.

  Form Condition:
    This gadget must be contained inside of a form.
    Following FormHandlers must be invoked from a submit button for address fields to be processed:
      - BillingFormHandler
      - ShippingGroupFormHandler
      - ProfileFormHandler

  Page includes:
    /mobile/global/gadgets/countryStatePicker.jspf - Renders content of states select picker
    /mobile/global/gadgets/countryListPicker.jspf - Renders content of countries select picker

  Required parameters:
    formHandlerComponent
      This needs to be a full component path including object which stores the address. E.g.:
        /atg/commerce/order/purchase/ShippingGroupFormHandler.address
    restrictionDroplet
      This checks for the various droplets used while choosing the "Country" and "State"
    errorMap
      Map of errors previously found in the form

  Optional parameters:
    None
--%>
<dsp:page>
  <%-- Request parameters - to variables --%>
  <dsp:getvalueof var="formHandlerComponent" param="formHandlerComponent"/>
  <dsp:getvalueof var="restrictionDroplet" param="restrictionDroplet"/>
  <dsp:getvalueof var="errorMap" param="errorMap"/>

  <%-- "First Name" --%>
  <li ${not empty errorMap['firstName'] ? 'class="errorState"' : ''}>
    <div class="content">
      <fmt:message var="firstPlace" key="mobile.myAccount.input.placeholder.firstName"/>
      <dsp:input type="text" bean="${formHandlerComponent}.firstName" maxlength="40" required="true" placeholder="${firstPlace}" aria-label="${firstPlace}"/>
    </div>
    <c:if test="${not empty errorMap['firstName']}">
      <span class="errorMessage"><fmt:message key="mobile.common.error.${errorMap['firstName']}"/></span>
    </c:if>
  </li>

  <%-- "Last Name" --%>
  <li ${not empty errorMap['lastName'] ? 'class="errorState"' : ''}>
    <div class="content">
      <fmt:message var="lastPlace" key="mobile.myAccount.input.placeholder.lastName"/>
      <dsp:input type="text" bean="${formHandlerComponent}.lastName" maxlength="40" required="true" placeholder="${lastPlace}" aria-label="${lastPlace}"/>
    </div>
    <c:if test="${not empty errorMap['lastName']}">
      <span class="errorMessage"><fmt:message key="mobile.common.error.${errorMap['lastName']}"/></span>
    </c:if>
  </li>

  <%-- "Street" (1) --%>
  <li ${not empty errorMap['address1'] ? 'class="errorState"' : ''}>
    <div class="content">
      <fmt:message var="street1" key="mobile.address.input.placeholder.street1"/>
      <dsp:input type="text" bean="${formHandlerComponent}.address1" maxlength="40" required="true" placeholder="${street1}" aria-label="${street1}"/>
    </div>
    <c:if test="${not empty errorMap['address1']}">
      <span class="errorMessage"><fmt:message key="mobile.common.error.${errorMap['address1']}"/></span>
    </c:if>
  </li>

  <%-- "Street" (2) --%>
  <li>
    <div class="content">
      <fmt:message var="street2" key="mobile.address.input.placeholder.street2"/>
      <dsp:input type="text" bean="${formHandlerComponent}.address2" maxlength="40" required="false" placeholder="${street2}" aria-label="${street2}"/>
    </div>
  </li>

  <li ${not empty errorMap['city'] || not empty errorMap['state'] ? 'class="errorState"' : ''}>
    <%-- "City" --%>
    <div class="left ${not empty errorMap['city'] ? 'errorState' : ''}">
      <div class="content">
        <fmt:message var="cityPlace" key="mobile.address.input.placeholder.city"/>
        <dsp:input type="text" bean="${formHandlerComponent}.city" maxlength="30" required="true" placeholder="${cityPlace}" aria-label="${cityPlace}"/>
      </div>
      <c:if test="${not empty errorMap['city']}">
        <span class="errorMessage"><fmt:message key="mobile.common.error.${errorMap['city']}"/></span>
      </c:if>
    </div>

    <%-- "State" --%>
    <div class="right ${not empty errorMap['state'] ? 'errorState' : ''}">
      <div class="content icon-ArrowLeft">
        <dsp:getvalueof var="selectedState" vartype="java.lang.String" bean="${formHandlerComponent}.state"/>
        <dsp:getvalueof var="statePicker" vartype="java.lang.String" value="stateSelect"/>
        <dsp:getvalueof var="countryPicker" vartype="java.lang.String" value="countrySelect"/>
        <dsp:getvalueof var="countryRestrictionDroplet" vartype="java.lang.String" param="restrictionDroplet"/>
        <dsp:getvalueof var="countryCode" vartype="java.lang.String" bean="${formHandlerComponent}.country"/>
        <dsp:getvalueof var="labelStyle" value="${empty selectedState ? ' default' : ''}"/>
        <%@include file="/mobile/global/gadgets/countryStatePicker.jspf"%>
      </div>
      <c:if test="${not empty errorMap['state']}">
        <span class="errorMessage"><fmt:message key="mobile.common.error.${errorMap['state']}"/></span>
      </c:if>
    </div>
  </li>

  <li ${not empty errorMap['postalCode'] || not empty errorMap['country'] ? 'class="errorState"' : ''}>
    <%-- "Postal Code" --%>
    <div class="left ${not empty errorMap['postalCode'] ? 'errorState' : ''}">
      <div class="content">
        <fmt:message var="zipPlace" key="mobile.address.input.placeholder.postalZipCode"/>
        <dsp:input type="text" bean="${formHandlerComponent}.postalCode" maxlength="10" required="true" placeholder="${zipPlace}" aria-label="${zipPlace}"/>
      </div>
      <c:if test="${not empty errorMap['postalCode']}">
        <span class="errorMessage"><fmt:message key="mobile.common.error.${errorMap['postalCode']}"/></span>
      </c:if>
    </div>

    <%-- "Country" --%>
    <div class="right ${not empty errorMap['country'] ? 'errorState' : ''}">
      <div class="content icon-ArrowLeft">
        <dsp:getvalueof var="selectedCountry" vartype="java.lang.String" bean="${formHandlerComponent}.country"/>
        <dsp:getvalueof var="selectStyle" value="${empty selectedCountry ? ' default' : ''}"/>
        <dsp:select required="true" id="countrySelect" bean="${formHandlerComponent}.country" iclass="${selectStyle}"
                    onchange="CRSMA.myaccount.selectCountry(event);" role="listbox" aria-describedby="selectMessageId">
          <%@include file="/mobile/global/gadgets/countryListPicker.jspf"%>
        </dsp:select>
      </div>
      <c:if test="${not empty errorMap['country']}">
        <span class="errorMessage"><fmt:message key="mobile.common.error.${errorMap['country']}"/></span>
      </c:if>
    </div>
  </li>

  <%-- "Phone" --%>
  <li ${not empty errorMap['phoneNumber'] ? 'class="errorState"' : ''}>
    <div class="content">
      <fmt:message var="phonePlace" key="mobile.common.phone"/>
      <dsp:input type="tel" bean="${formHandlerComponent}.phoneNumber" maxlength="15" required="true" placeholder="${phonePlace}" aria-label="${phonePlace}"/>
    </div>
    <c:if test="${not empty errorMap['phoneNumber']}">
      <span class="errorMessage"><fmt:message key="mobile.common.error.${errorMap['phoneNumber']}"/></span>
    </c:if>
  </li>

  <%-- Make sure we are in "Checkout" ("Add Shipping Address" context) --%>
  <c:if test="${formHandlerComponent == '/atg/commerce/order/purchase/ShippingGroupFormHandler.address'}">
    <%-- Check if current user is registered user --%>
    <dsp:importbean bean="/atg/store/droplet/ProfileSecurityStatus"/>
    <dsp:importbean bean="/atg/commerce/order/purchase/ShippingGroupFormHandler"/>
    <dsp:droplet name="ProfileSecurityStatus">
      <dsp:oparam name="anonymous">
        <%-- User is anonymous. Don't prompt to update his profile --%>
      </dsp:oparam>
      <dsp:oparam name="default">
        <li>
          <div class="content">
            <%-- "Update my profile" --%>
            <dsp:input type="checkbox" name="saveShippingAddress" id="addressAddSaveAddressInput" checked="true"
                       bean="ShippingGroupFormHandler.saveShippingAddress"/>
            <label for="addressAddSaveAddressInput" onclick=""><fmt:message key="mobile.address.label.updateProfile"/></label>
          </div>
        </li>
      </dsp:oparam>
    </dsp:droplet>
  </c:if>
  
  <div id="selectMessageId" style="display:none">
     <fmt:message>mobile.address.a11y.submit</fmt:message>
   </div>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/Storefront/j2ee/store.war/mobile/address/gadgets/addressAddEdit.jsp#11 $$Change: 803979 $--%>
