<%--
  This gadget renders a product-details row for a return item specified along with return quantity.
  It displays product image, SKU info, total refund for the item.
  
  Page includes:
    /mobile/myaccount/gadgets/returnItemDetails.jspf - Displays all the details of a return item
    /global/gadgets/crossSiteLinkGenerator.jsp - Generator of cross-site links

  Required parameters:
    returnItem
      Return item to be rendered.
    mode
      'confirm' = The page is used in "Return Confirmation" context
      'detail' = The page is used in "Return Detail" context

  Optional parameters:
    activeReturn
      Indicates whether return request is currently active.
    priceListLocale
      Specifies a locale in which to format the price (as string).
      If not specified, locale will be taken from profile price list (Profile.priceList.locale).
--%>
<dsp:page>
  <%-- Request parameters - to variables --%>
  <dsp:getvalueof var="returnItem" param="returnItem"/>
  <dsp:getvalueof var="activeReturn" param="activeReturn"/>
  <dsp:getvalueof var="mode" param="mode"/>

  <%-- Retrieve commerce item, product and SKU for the specified return item --%>
  <dsp:param name="commerceItem" param="returnItem.commerceItem"/>
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
            <%@include file="returnItemDetails.jspf"%>
          </div>
        </dsp:a>
      </c:when>
      <c:otherwise>
        <div class="item">
          <%@include file="returnItemDetails.jspf"%>
        </div>
      </c:otherwise>
    </c:choose>
  </li>
</dsp:page>
