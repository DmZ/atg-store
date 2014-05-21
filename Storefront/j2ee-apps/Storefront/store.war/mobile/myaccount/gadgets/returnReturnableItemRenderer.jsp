<%--
  This gadget renders a product-details row for a return item specified along with return quantity
  and return reason selection controls.

  For return selection page the gadget should be included into the form element.

  Required parameters:
    returnItem
      Return item to be rendered.
    shippingGroupIndex
      The index of ReturnShippingGroup to which current return item belongs.
    itemIndex
      The index of return item in the ReturnShippingGroup's itemList.

  Optional parameters:
    None
--%>
<dsp:page>
  <dsp:importbean bean="/atg/commerce/custsvc/returns/BaseReturnFormHandler"/>
  <dsp:importbean bean="/atg/commerce/custsvc/returns/ReturnReasonLookupDroplet"/>
  <dsp:importbean bean="/atg/dynamo/droplet/multisite/GetSiteDroplet"/>
  <dsp:importbean bean="/atg/dynamo/droplet/ForEach"/>

  <dsp:getvalueof var="returnItem" param="returnItem"/>

  <dsp:param name="commerceItem" param="returnItem.commerceItem"/>
  <dsp:param name="product" param="commerceItem.auxiliaryData.productRef"/>
  <dsp:param name="sku" param="commerceItem.auxiliaryData.catalogRef"/>

  <dsp:getvalueof var="skuType" vartype="java.lang.String" param="sku.type"/>

  <dsp:getvalueof var="productDisplayName" param="sku.displayName"/>
  <dsp:getvalueof var="quantityAvailable" param="returnItem.quantityAvailable"/>
  <dsp:getvalueof var="siteId" vartype="java.lang.String" param="commerceItem.auxiliaryData.siteId"/>
  <dsp:getvalueof var="skuId" vartype="java.lang.String" param="sku.id"/>
  <dsp:getvalueof var="imageUrl" param="product.smallImage.url"/>

  <dsp:droplet name="GetSiteDroplet">
    <dsp:param name="siteId" value="${siteId}"/>
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
      <div class="dimension">
        <span><fmt:message key="mobile.common.quantity"/><fmt:message key="mobile.common.colon"/> </span>
        <span>${quantityAvailable}</span>
      </div>
      <c:choose>
        <c:when test="${skuType == 'clothing-sku'}">
          <dsp:getvalueof var="size" vartype="java.lang.String" param="sku.size"/>
          <dsp:getvalueof var="color" vartype="java.lang.String" param="sku.color"/>
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
    </div>

    <%-- Quantity drop-down --%>
    <fmt:message var="quantityLabel" key="mobile.common.quantity"/>
    <dsp:select bean="BaseReturnFormHandler.returnRequest.shippingGroupList[param:shippingGroupIndex].itemList[param:itemIndex].quantityToReturn"
                class="quantitySlct" aria-label="${quantityLabel}">
      <dsp:option value="0">
        <fmt:message key="mobile.return.selectReturnQuantity"/>
      </dsp:option>
      <c:forEach var="itemValue" begin="1" end="${quantityAvailable}" step="1">
        <dsp:option value="${itemValue}">
          ${itemValue}
        </dsp:option>
      </c:forEach>
    </dsp:select>

    <%-- Reason for return drop-down --%>
    <fmt:message var="reasonLabel" key="mobile.return.label.reason"/>
    <dsp:select bean="BaseReturnFormHandler.returnRequest.shippingGroupList[param:shippingGroupIndex].itemList[param:itemIndex].returnReason"
                class="reasonSlct" aria-label="${reasonLabel}">
      <dsp:option value="">
        <fmt:message key="mobile.return.selectReturnReason"/>
      </dsp:option>
      <dsp:droplet name="ForEach">
        <dsp:param bean="BaseReturnFormHandler.reasonCodes" name="array"/>
        <dsp:param name="elementName" value="reasonCode"/>
        <dsp:param name="sortProperties" value="+readableDescription"/>
        <dsp:oparam name="output">
          <dsp:option paramvalue="reasonCode.repositoryId">
            <dsp:valueof param="reasonCode.readableDescription"/>
          </dsp:option>
        </dsp:oparam>
      </dsp:droplet>
    </dsp:select>
  </div>
</dsp:page>
