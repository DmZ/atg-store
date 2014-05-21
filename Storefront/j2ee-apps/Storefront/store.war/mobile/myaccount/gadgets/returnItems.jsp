<%--
  This gadget renders all items in a return grouped by shipping group.

  Page includes:
    /mobile/myaccount/gadgets/returnItemRenderer.jsp - Renders a return item

  Required parameters:
    return
      The return request to display return items for.
    mode
      'confirm' = The page is used in "Return Confirmation" context
      'detail' = The page is used in "Return Detail" context

  Optional parameters:
    activeReturn
      Indicates whether return request is currently active.
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

  <%-- Iterate through shipping groups of the return request --%>
  <dsp:getvalueof var="returnShippingGroupList" param="return.shippingGroupList"/>
  <c:forEach var="returnShippingGroup" items="${returnShippingGroupList}" varStatus="shippingGroupListStatus">
    <dsp:getvalueof var="returnItemsList" param="return.returnItemList"/>
    <c:set var="shippingGroupId" value="${returnShippingGroup.shippingGroup.id}"/>
    <c:set var="returnItemsCounter" value="0"/>

    <%-- Display all return items of the current return shipping group --%>
    <ul>
      <c:forEach var="returnItem" items="${returnItemsList}">
        <%--
          Check whether the quantity to return is bigger than 0. If so we will display
          the item. If quantity is 0 than item is not included into the return.
        --%>
        <c:if test="${returnItem.quantityToReturn > 0 and returnItem.shippingGroupId == shippingGroupId}">
          <c:set var="returnItemsCounter" value="${returnItemsCounter + 1}"/>
          <%-- Display shipping group details if this is the first return item in the shipping group --%>
          <c:if test="${returnItemsCounter == 1}">
            <%-- Display shipping group's address and shipping method --%>
            <div class="shippingInfoSection">
              <div class="shipToSection">
                <div><fmt:message key="mobile.common.shipTo"/><fmt:message key="mobile.common.colon"/></div>
                <div>
                  <dsp:include page="${mobileStorePrefix}/address/gadgets/displayAddress.jsp">
                    <dsp:param name="address" value="${returnShippingGroup.shippingGroup.shippingAddress}"/>
                    <dsp:param name="isPrivate" value="false"/>
                  </dsp:include>
                </div>
              </div>
              <div class="viaSection">
                <div><fmt:message key="mobile.return.header.shippingMethod"/><fmt:message key="mobile.common.colon"/></div>
                <dsp:getvalueof var="shippingMethod" value="${returnShippingGroup.shippingGroup.shippingMethod}"/>
                <div><fmt:message key="mobile.return.label.delivery${fn:replace(shippingMethod, ' ', '')}"/></div>
              </div>
            </div>
          </c:if>

          <dsp:include page="returnItemRenderer.jsp">
            <dsp:param name="returnItem" value="${returnItem}"/>
            <dsp:param name="activeReturn" param="activeReturn"/>
            <dsp:param name="priceListLocale" param="priceListLocale"/>
            <dsp:param name="mode" param="mode"/>
          </dsp:include>
        </c:if>
      </c:forEach>
    </ul>
  </c:forEach>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/Storefront/j2ee/store.war/mobile/myaccount/gadgets/returnItems.jsp#10 $$Change: 805775 $--%>
