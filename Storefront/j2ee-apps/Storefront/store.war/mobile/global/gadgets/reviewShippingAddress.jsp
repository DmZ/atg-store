<%--
  Renders order "Shipping Address".

  Page includes:
    /mobile/address/gadgets/displayAddress.jsp - Renderer of address info

  Required parameters:
    address
      Address item to be displayed
    isCheckout
      Indicator if this order is about to checkout or has already been placed.
      Possible values:
        'true' = is about to checkout
        'false' = placed order

  NOTES:
    1) The "mobileStorePrefix" request-scoped variable (request attribute), which is used here,
       is defined in the "mobilePageContainer" tag ("mobilePageContainer.tag" file).
       This variable becomes available within the <crs:mobilePageContainer> ... </crs:mobilePageContainer> block
       and in all the included pages (gadgets and Endeca cartridges).
--%>
<dsp:page>
  <%-- Request parameters - to variables --%>
  <dsp:getvalueof var="isCheckout" param="isCheckout"/>

  <c:set var="linkToEditPage" value="../../checkout/shipping.jsp"/>
  <fmt:message var="title" key="mobile.common.shipTo"/>

  <div id="shipTo">
    <c:choose>
      <c:when test="${isCheckout}">
        <h2><dsp:a page="${linkToEditPage}">${title}</dsp:a></h2>
        <div class="roundedBox">
          <dsp:a page="${linkToEditPage}" title="${title}">
            <span class="content icon-ArrowRight">
              <dsp:include page="${mobileStorePrefix}/address/gadgets/displayAddress.jsp">
                <dsp:param name="address" param="address"/>
                <dsp:param name="isPrivate" value="true"/>
              </dsp:include>
            </span>
          </dsp:a>
        </div>
      </c:when>
      <c:otherwise>
        <h2>${title}</h2>
        <div class="roundedBox">
          <span class="content">
            <dsp:include page="${mobileStorePrefix}/address/gadgets/displayAddress.jsp">
              <dsp:param name="address" param="address"/>
              <dsp:param name="isPrivate" value="true"/>
            </dsp:include>
          </span>
        </div>
      </c:otherwise>
    </c:choose>
  </div>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/Storefront/j2ee/store.war/mobile/global/gadgets/reviewShippingAddress.jsp#6 $$Change: 800951 $--%>
