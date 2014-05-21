<%--
  This page renders empty "Shopping Cart".

  Page includes:
    /global/gadgets/formattedPrice.jsp - Price formatter
    /mobile/cart/gadgets/getTargeterProduct.jsp - Return product from the targeter
    /mobile/global/gadgets/productsHorizontalList.jsp - Renders the "Related Items" slider
    /mobile/global/gadgets/recentlyViewed.jsp - Renders the "Recently Viewed Items" slider

  Required parameters:
    None

  Optional parameters:
    None

  NOTES:
    1) The "mobileStorePrefix" request-scoped variable (request attribute), which is used here,
       is defined in the "mobilePageContainer" tag ("mobilePageContainer.tag" file).
       This variable becomes available within the <crs:mobilePageContainer> ... </crs:mobilePageContainer> block
       and in all the included pages (gadgets and Endeca cartridges).
--%>
<dsp:page>
  <div class="cartContainer">
    <div class="roundedBox">
      <div class="cartSummary">
        <div class="orderInfo">
          <dl class="orderTotal">
            <dt class="totalText"><fmt:message key="mobile.common.label.total"/><fmt:message key="mobile.common.colon"/></dt>
            <dd class="totalPrice">
              <dsp:include page="/global/gadgets/formattedPrice.jsp">
                <dsp:param name="price" value="0"/>
              </dsp:include>
            </dd>
          </dl>
         </div>
      </div>
    </div>
  </div>

  <jsp:useBean id="featuredProducts" class="java.util.HashMap"/>
  <dsp:include page="${mobileStorePrefix}/cart/gadgets/getTargeterProduct.jsp">
    <dsp:param name="targeter" bean="/atg/registry/Slots/FeaturedProduct1"/>
  </dsp:include>
  <c:set target="${featuredProducts}" property="FeaturedProduct1" value="${requestScope.product}"/>
  <dsp:include page="${mobileStorePrefix}/cart/gadgets/getTargeterProduct.jsp">
    <dsp:param name="targeter" bean="/atg/registry/Slots/FeaturedProduct2"/>
  </dsp:include>
  <c:set target="${featuredProducts}" property="FeaturedProduct2" value="${requestScope.product}"/>
  <dsp:include page="${mobileStorePrefix}/cart/gadgets/getTargeterProduct.jsp">
    <dsp:param name="targeter" bean="/atg/registry/Slots/FeaturedProduct3"/>
  </dsp:include>
  <c:set target="${featuredProducts}" property="FeaturedProduct3" value="${requestScope.product}"/>
  <dsp:include page="${mobileStorePrefix}/cart/gadgets/getTargeterProduct.jsp">
    <dsp:param name="targeter" bean="/atg/registry/Slots/FeaturedProduct4"/>
  </dsp:include>
  <c:set target="${featuredProducts}" property="FeaturedProduct4" value="${requestScope.product}"/>
  <dsp:include page="${mobileStorePrefix}/cart/gadgets/getTargeterProduct.jsp">
    <dsp:param name="targeter" bean="/atg/registry/Slots/FeaturedProduct5"/>
  </dsp:include>
  <c:set target="${featuredProducts}" property="FeaturedProduct5" value="${requestScope.product}"/>

  <%-- Display "Featured Items" slider panel, if any --%>
  <c:if test="${not empty featuredProducts}">
    <div class="sliderTitle">
      <fmt:message key="mobile.emptyCart.header.featuredItem"/>
    </div>
    <dsp:include page="${mobileStorePrefix}/global/gadgets/productsHorizontalList.jsp">
      <dsp:param name="products" value="${featuredProducts}"/>
      <dsp:param name="index" value="1"/>
    </dsp:include>
  </c:if>

  <%-- Display "Recently Viewed Items" slider panel, if any --%>
  <dsp:include page="${mobileStorePrefix}/global/gadgets/recentlyViewed.jsp">
    <dsp:param name="index" value="2"/>
  </dsp:include>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/Storefront/j2ee/store.war/mobile/cart/emptyCart.jsp#9 $$Change: 807655 $ --%>
