<%--
  This gadget renders a product-details row for a order item specified along with order quantity.
  It displays product image, SKU info, total pricefund for the item.

  Page includes:
    /mobile/myaccount/gadgets/orderItemDetails.jspf - Displays all the details of a order item
    /global/gadgets/crossSiteLinkGenerator.jsp - Generator of cross-site links

  Required parameters:
    commerceItem
      Order item to be rendered.

  Optional parameters:
    priceListLocale
      Specifies a locale in which to format the price (as string).
      If not specified, locale will be taken from profile price list (Profile.priceList.locale).
--%>
<dsp:page>
  <%-- Request parameters - to variables --%>
  <dsp:getvalueof var="commerceItem" param="commerceItem"/>

  <dsp:param name="product" param="commerceItem.auxiliaryData.productRef"/>
  <dsp:param name="sku" param="commerceItem.auxiliaryData.catalogRef"/>

  <%-- Get IDs for missing product and SKU substitution product / SKU --%>
  <dsp:getvalueof var="missingProductId" vartype="java.lang.String" bean="/atg/commerce/order/processor/SetProductRefs.substituteDeletedProductId"/>

  <%--
    Check whether the given return item is navigable so that to determine whether we can display
    navigable link for it.
  --%>
  <dsp:getvalueof var="navigable" param="product.NavigableProducts" vartype="java.lang.Boolean"/>
  <dsp:getvalueof var="pageurl" idtype="java.lang.String" param="product.template.url"/>
  <dsp:getvalueof var="siteLinkUrl" value="" scope="request"/> <%-- intialize to empty --%>

  <c:if test="${!activeReturn && not empty pageurl && navigable && missingProductId != param.product.repositoryId}">
    <%-- Generates URL for the product, the URL is stored in the "siteLinkUrl" request-scoped variable --%>
    <dsp:include page="/global/gadgets/crossSiteLinkGenerator.jsp">
      <dsp:param name="product" param="commerceItem.auxiliaryData.productRef"/>
      <dsp:param name="siteId" param="commerceItem.auxiliaryData.siteId"/>
    </dsp:include>
  </c:if>

  <li class="item">
    <c:choose>
      <c:when test="${not empty siteLinkUrl}">
        <dsp:a href="${fn:escapeXml(siteLinkUrl)}" class="icon-ArrowRight">
          <dsp:param name="productId" param="commerceItem.auxiliaryData.productId"/>
          <div class="item">
            <%@include file="orderItemDetails.jspf"%>
          </div>
        </dsp:a>
      </c:when>
      <c:otherwise>
        <div class="item">
          <%@include file="orderItemDetails.jspf"%>
        </div>
      </c:otherwise>
    </c:choose>
  </li>
</dsp:page>
