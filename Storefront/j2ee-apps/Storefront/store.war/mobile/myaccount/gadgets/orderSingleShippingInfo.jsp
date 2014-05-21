<%--
  This gadget displays shipping address and shipping method for a given shipping group.

  Page includes:
    /mobile/address/gadgets/displayAddress.jsp - Renderer of address info

  Required parameters:
    shippingGroup
      Shipping group to be displayed.

  NOTES:
    1) The "mobileStorePrefix" request-scoped variable (request attribute), which is used here,
       is defined in the "mobilePageContainer" tag ("mobilePageContainer.tag" file).
       This variable becomes available within the <crs:mobilePageContainer> ... </crs:mobilePageContainer> block
       and in all the included pages (gadgets and Endeca cartridges).
--%>
<dsp:page>
  <%-- Request parameters - to variables --%>
  <dsp:getvalueof var="shippingGroup" param="shippingGroup"/>
  <dsp:param name="shippingAddress" param="shippingGroup.shippingAddress"/>

  <div class="shippingInfoSection">
    <div class="shipToSection">
      <div><fmt:message key="mobile.common.shipTo"/><fmt:message key="mobile.common.colon"/></div>
      <div>
        <%-- Display shipping group shipping address --%>
        <dsp:include page="${mobileStorePrefix}/address/gadgets/displayAddress.jsp">
          <dsp:param name="address" param="shippingAddress"/>
          <dsp:param name="isPrivate" value="false"/>
        </dsp:include>
      </div>
    </div>
    <div class="viaSection">
      <div><fmt:message key="mobile.return.header.shippingMethod"/><fmt:message key="mobile.common.colon"/></div>
      <%-- Display shipping method --%>
      <dsp:getvalueof var="shippingMethod" param="shippingGroup.shippingMethod"/>
      <span><fmt:message key="common.delivery${fn:replace(shippingMethod, ' ', '')}"/></span>
    </div>
  </div>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/Storefront/j2ee/store.war/mobile/myaccount/gadgets/orderSingleShippingInfo.jsp#4 $$Change: 805775 $--%>
