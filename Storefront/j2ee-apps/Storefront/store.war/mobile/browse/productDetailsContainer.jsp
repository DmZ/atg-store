<%--
  Renders product details to the page.

  Page includes:
    /mobile/browse/gadgets/productPrice.jsp - Display product price
    /mobile/browse/gadgets/quantityPickerList.jsp - Renders a list of quantity selections
    /mobile/global/gadgets/productsHorizontalList.jsp - Renders the "Related Items" slider
    /mobile/global/gadgets/recentlyViewed.jsp - Renders the "Recently Viewed Items" slider

  Required parameters:
    picker
      Path to the JSP that will render buttons for this product
    product
      Product repository item whose details are being displayed

  Optional parameters:
    selectedSku
      Currently selected SKU. If present, signifies that this is a single-SKU product
    selectedQty
      Currently selected quantity
    selectedSize
      Currently selected size
    selectedColor
      Currently selected color
    availableSizes
      Available sizes for this product
    availableColors
      Available colors for this product
    oneSize
      If true, this product only has one size
    oneColor
      If true, this product only has one color
    isUpdateCart
      If true, changes default button text

  NOTES:
    1) The "mobileStorePrefix" request-scoped variable (request attribute), which is used here,
       is defined in the "mobilePageContainer" tag ("mobilePageContainer.tag" file).
       This variable becomes available within the <crs:mobilePageContainer> ... </crs:mobilePageContainer> block
       and in all the included pages (gadgets and Endeca cartridges).
--%>
<dsp:page>
  <dsp:importbean bean="/atg/store/droplet/ItemSiteGroupFilterDroplet"/>
  <dsp:importbean bean="/atg/store/droplet/SkuAvailabilityLookup"/>

  <%-- Request parameters - to variables --%>
  <dsp:getvalueof var="selectedQty" param="selectedQty"/>
  <dsp:getvalueof var="selectedSku" param="selectedSku"/>
  <dsp:getvalueof var="displayName" param="product.displayName"/>

  <ul class="productDetails">
    <li class="productTitle"><c:out value="${displayName}"/></li>
    <li class="itemPickers ${empty selectedSku ? '' : 'expanded'}">
      <div class="imageContainer">
        <dsp:getvalueof var="url" param="product.largeImage.url" idtype="java.lang.String"/>
        <c:if test="${empty url}">
          <c:set var="url" value="/crsdocroot/content/images/products/large/MissingProduct_large.jpg"/>
        </c:if>
        <a href="#">
          <img id="productImage" src="${url}" alt="${displayName}"/>
        </a>
      </div>
      <div onclick="CRSMA.product.expandPickers();" class="pickersContent">
        <dsp:include page="gadgets/productPrice.jsp">
          <dsp:param name="product" param="product"/>
          <dsp:param name="selectedSku" param="selectedSku"/>
        </dsp:include>
        <ul>
          <dsp:getvalueof var="picker" param="picker"/>
          <c:if test="${not empty picker}">
            <dsp:include page="${picker}">
              <dsp:param name="product" param="product"/>
              <dsp:param name="selectedSku" param="selectedSku"/>
              <dsp:param name="selectedSize" param="selectedSize"/>
              <dsp:param name="selectedColor" param="selectedColor"/>
              <dsp:param name="availableSizes" param="availableSizes"/>
              <dsp:param name="availableColors" param="availableColors"/>
              <dsp:param name="oneSize" param="oneSize"/>
              <dsp:param name="oneColor" param="oneColor"/>
            </dsp:include>
          </c:if>
          <li id="qtyContainer">
            <dsp:include page="gadgets/quantityPickerList.jsp">
              <dsp:param name="selectedValue" param="selectedQty"/>
              <dsp:param name="id" value="qtySelect"/>
            </dsp:include>
          </li>
        </ul>
        <div id="addToCartButton" class="centralButton">
          <%-- Determine default button text --%>
          <dsp:getvalueof var="isUpdateCart" param="isUpdateCart"/>

          <%-- Default values --%>
          <fmt:message var="buttonLabel">
            <c:choose>
              <c:when test="${empty isUpdateCart || !isUpdateCart}">mobile.productDetails.button.addToCart</c:when>
              <c:otherwise>mobile.productDetails.button.backToCart</c:otherwise>
            </c:choose>
          </fmt:message>

          <c:set var="buttonText" value=""/>

          <%-- Customization --%>
          <c:if test="${not empty selectedSku}">
            <dsp:droplet name="SkuAvailabilityLookup">
              <dsp:param name="product" param="product"/>
              <dsp:param name="skuId" value="${selectedSku.repositoryId}"/>
              <dsp:oparam name="preorderable">
                <fmt:message key="mobile.productDetails.availableSoon" var="buttonText"/>

                <c:if test="${empty isUpdateCart || !isUpdateCart}">
                  <fmt:message key="mobile.productDetails.buton.preorder" var="buttonLabel"/>
                </c:if>
              </dsp:oparam>
              <dsp:oparam name="backorderable">
                <fmt:message key="mobile.productDetails.backorder" var="buttonText"/>
              </dsp:oparam>
              <dsp:oparam name="unavailable">
                <fmt:message key="mobile.productDetails.button.emailMe" var="buttonLabel"/>
                <fmt:message key="mobile.productDetails.outOfStock" var="buttonText"/>
              </dsp:oparam>
            </dsp:droplet>
          </c:if>

          <span id="buttonText">
            <c:out value="${buttonText}"/>
          </span>
          <button class="mainActionButton" onclick="CRSMA.product.actionHandler(event);" ${empty selectedSku ? 'disabled' : ''}>
            <c:out value="${buttonLabel}"/>
          </button>
        </div>
      </div>
    </li>

    <li class="itemDetails">
      <p class="detailsTitle"><fmt:message key="mobile.productDetails.header.details"/></p>

      <p class="detailsContent">
        <dsp:getvalueof var="LongDescription" param="product.longDescription"/>
        <c:choose>
          <c:when test="${not empty LongDescription}">
            <c:out value="${LongDescription}"></c:out>
          </c:when>
          <c:otherwise>
            <dsp:valueof param="product.description"/>
          </c:otherwise>
        </c:choose>
      </p>

      <%--
        "ItemSiteGroupFilterDroplet" droplet filters out items that don't belong to the same cart sharing site group
        as the current site.

        Input parameters:
          collection
            Collection of products to filter based on the site group

        Output parameters:
          filteredCollection
            Filtered collection
      --%>
      <dsp:droplet name="ItemSiteGroupFilterDroplet">
        <dsp:param name="collection" param="product.relatedProducts"/>
        <dsp:oparam name="output">
          <dsp:getvalueof var="relatedProducts" param="filteredCollection"/>
        </dsp:oparam>
      </dsp:droplet>
    </li>

    <%-- Display "Related Items" slider panel, if any --%>
    <c:if test="${not empty relatedProducts}">
      <li class="sliderTitle">
        <fmt:message key="mobile.productDetails.header.relatedItems" />
      </li>
      <li>
        <dsp:include page="${mobileStorePrefix}/global/gadgets/productsHorizontalList.jsp">
          <dsp:param name="products" value="${relatedProducts}" />
          <dsp:param name="index" value="1" />
        </dsp:include>
      </li>
    </c:if>

    <%-- Display "Recently Viewed Items" slider panel, if any --%>
    <dsp:include page="${mobileStorePrefix}/global/gadgets/recentlyViewed.jsp">
      <dsp:param name="exclude" param="product.id"/>
      <dsp:param name="index" value="2" />
    </dsp:include>
  </ul>
  
  <script>
    $(document).ready(function() {
      CRSMA.product.toggleProductView();
    });
  </script>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/Storefront/j2ee/store.war/mobile/browse/productDetailsContainer.jsp#10 $$Change: 811829 $--%>
