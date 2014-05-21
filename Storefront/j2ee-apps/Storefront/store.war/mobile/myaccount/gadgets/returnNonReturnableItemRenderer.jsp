<%--
  This gadget renders a product-details row for a Non-returnable return item.

  Required parameters:
    returnItem
      Return item to be rendered
    returnableDescription
      Description of non-returnable state

  Optional parameters:
    priceListLocale
      Specifies a locale in which to format the price (as string).
      If not specified, locale will be taken from profile price list (Profile.priceList.locale)
--%>
<dsp:page>
  <dsp:importbean bean="/atg/dynamo/droplet/multisite/GetSiteDroplet"/>

  <dsp:param name="commerceItem" param="returnItem.commerceItem"/>
  <dsp:param name="product" param="commerceItem.auxiliaryData.productRef"/>

  <dsp:param name="sku" param="commerceItem.auxiliaryData.catalogRef"/>
  <dsp:getvalueof var="skuType" vartype="java.lang.String" param="sku.type"/>
  <dsp:getvalueof var="skuId" vartype="java.lang.String" param="sku.id"/>

  <dsp:getvalueof var="imageUrl" param="product.smallImage.url"/>
  <dsp:getvalueof var="productDisplayName" param="sku.displayName"/>

  <%-- Get "Site" property value --%>
  <dsp:droplet name="GetSiteDroplet">
    <dsp:param name="siteId" param="commerceItem.auxiliaryData.siteId"/>
    <dsp:oparam name="output">
      <dsp:getvalueof var="siteName" param="site.name"/>
    </dsp:oparam>
  </dsp:droplet>

  <div class="item">
    <div class="thumbnail">
      <img src="${imageUrl}" alt="${productDisplayName}"/>
    </div>

    <div class="itemData">
      <div class="productName">
        <span>${productDisplayName}</span>
      </div>
      <div class="skuNmbr">
        <span><fmt:message key="mobile.return.label.sku"/><fmt:message key="mobile.common.colon"/> </span>
        <span>${skuId}</span>
      </div>

      <c:choose>
        <c:when test="${skuType == 'clothing-sku'}">
          <dsp:getvalueof var="color" vartype="java.lang.String" param="sku.color"/>
          <dsp:getvalueof var="size" vartype="java.lang.String" param="sku.size"/>
          <c:if test="${not empty size}">
            <div class="dimension">
              <span><fmt:message key="mobile.common.label.size"/><fmt:message key="mobile.common.colon"/> </span>
              <span>${size}</span>
            </div>
          </c:if>
          <c:if test="${not empty color}">
            <div class="dimension">
              <span><fmt:message key="mobile.common.label.color"/><fmt:message key="mobile.common.colon"/> </span>
              <span>${color}</span>
            </div>
          </c:if>
        </c:when>
        <c:when test="${skuType == 'furniture-sku'}">
          <dsp:getvalueof var="woodFinish" vartype="java.lang.String" param="sku.woodFinish"/>
          <c:if test="${not empty woodFinish}">
            <div class="dimension">
              <span><fmt:message key="mobile.common.label.woodFinish"/><fmt:message key="mobile.common.colon"/> </span>
              <span>${woodFinish}</span>
            </div>
          </c:if>
        </c:when>
      </c:choose>

      <div class="dimension">
        <span><fmt:message key="mobile.common.label.site"/><fmt:message key="mobile.common.colon"/> </span>
        <span>${siteName}</span>
      </div>
      <div class="dimension">
        <span><fmt:message key="mobile.common.label.status"/><fmt:message key="mobile.common.colon"/> </span>
        <span><dsp:valueof param="returnableDescription"/></span>
      </div>
    </div>
  </div>
</dsp:page>
