<%--
  "Shopping cart" page.

  NOTE: This page renders "Loading..." message box.

  Page includes:
    /mobile/global/gadgets/loadingWindow.jsp - "Loading..." message box
    /mobile/cart/emptyCart.jsp - Renderer of empty cart
    /mobile/cart/cartContent.jsp - Renderer of cart with items

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
  <dsp:importbean bean="/atg/commerce/ShoppingCart"/>
  <dsp:importbean bean="/atg/commerce/order/purchase/RepriceOrderDroplet"/>

  <dsp:droplet name="RepriceOrderDroplet">
    <dsp:param name="pricingOp" value="ORDER_SUBTOTAL"/>
    <dsp:oparam name="success">
      <%-- Nope for success --%>
    </dsp:oparam>
    <dsp:oparam name="successWithErrors">
      <%-- Call "RepriceOrderDroplet" again, in case of errors --%>
      <dsp:droplet name="RepriceOrderDroplet">
        <dsp:param name="pricingOp" value="ORDER_SUBTOTAL"/>
      </dsp:droplet>
    </dsp:oparam>
    <dsp:oparam name="failure">
      <%-- Call "RepriceOrderDroplet" again, in case of errors --%>
      <dsp:droplet name="RepriceOrderDroplet">
        <dsp:param name="pricingOp" value="ORDER_SUBTOTAL"/>
      </dsp:droplet>
    </dsp:oparam>
  </dsp:droplet>

  <fmt:message var="pageTitle" key="mobile.cart.title"/>
  <crs:mobilePageContainer titleString="${pageTitle}" displayModal="true">
    <jsp:attribute name="modalContent">
      <%-- "Remove item from Cart" dialog template --%>
      <div class="moveDialog" onclick="$(this).hide();">
        <div class="moveItems">
          <ul class="dataList">
            <li>
              <fmt:message key="mobile.common.button.delete" var="removeText"/>
              <a id="removeLink" class="icon-Remove" role="button" href="javascript:void(0);" title="${removeText}"
                 onclick="CRSMA.cart.removeCurrentCartItem()">${removeText}</a>
            </li>
          </ul>
        </div>
      </div>
      <%-- "Share" dialog template --%>
      <div class="shareDialog" onclick="$(this).hide();">
        <div class="shareItems">
          <ul class="dataList">
            <li>
              <a id="shareLink" class="icon-Share" role="button" href="javascript:void(0);"><fmt:message key="mobile.cart.button.emailAFriend"/></a>
            </li>
          </ul>
        </div>
      </div>
      <%-- "Loading..." message box --%>
      <dsp:include page="${mobileStorePrefix}/global/gadgets/loadingWindow.jsp"/>
    </jsp:attribute>

    <jsp:body>
      <dsp:getvalueof var="commerceItemCount" bean="ShoppingCart.current.CommerceItemCount"/>
      <c:choose>
        <c:when test="${commerceItemCount == 0}">
          <dsp:include page="emptyCart.jsp"/>
        </c:when>
        <c:otherwise>
          <dsp:include page="cartContent.jsp"/>
        </c:otherwise>
      </c:choose>

      <script>
        $(document).ready(function() {
          CRSMA.common.hideLoadingWindow();
          CRSMA.mobilepage.saveCartItems();
        });
        <c:if test="${commerceItemCount > 0}">
          <%-- Disable links inside of the item boxes --%>
          $(".cartItem a").click(function(e) {
            e.preventDefault();
          });
        </c:if>
      </script>
    </jsp:body>
  </crs:mobilePageContainer>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/Storefront/j2ee/store.war/mobile/cart/cart.jsp#6 $$Change: 800951 $ --%>
