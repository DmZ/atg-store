<%-- 
  This page lays out the elements that make up the PriceSlider.
    
  Required Parameters:
    contentItem
      The content parameter represents an unselected dimension refinement.
   
  Optional Parameters:

--%>
<dsp:page>
  
  <dsp:getvalueof var="contextPath" vartype="java.lang.String"  bean="/OriginatingRequest.contextPath"/>
  <dsp:importbean bean="/OriginatingRequest" var="originatingRequest"/>
  
  <dsp:getvalueof var="contentItem" vartype="com.endeca.infront.assembler.ContentItem" value="${originatingRequest.contentItem}"/> 
  
  <%-- 
    The slider is a range filter not an Endeca dimension refinement so we need
    to use a custom method to determine if we should render the control.
  --%>
  <dsp:getvalueof var="enabled" value="${contentItem.enabled}"/>
  <c:if test="${enabled}">

    <dsp:include page="/global/gadgets/formattedPrice.jsp">
      <dsp:param name="price" value="${contentItem.sliderMin}"/>
      <dsp:param name="saveFormattedPrice" value="true"/>
    </dsp:include>
    <dsp:getvalueof var="minPrice" value="${formattedPrice}"/>

    <dsp:include page="/global/gadgets/formattedPrice.jsp">
      <dsp:param name="price" value="${contentItem.sliderMax}"/>
      <dsp:param name="saveFormattedPrice" value="true"/>
    </dsp:include>
    <dsp:getvalueof var="maxPrice" value="${formattedPrice}"/>

    <div class="atg_store_facetsGroup_options_catsub">
      <h5><fmt:message key="common.price"/></h5>

      <span dojotype="atg.store.widget.PriceSlider"
        id="atg_store_priceRefinement"
        formattedMinimum="${minPrice}"
        formattedMaximum="${maxPrice}"
        selectedMinimum="${contentItem.filterCrumb.lowerBound}"
        selectedMaximum="${contentItem.filterCrumb.upperBound}"
        sliderMinimum="${contentItem.sliderMin}"
        sliderMaximum="${contentItem.sliderMax}"
        contentItemPricePropertyName="${contentItem.priceProperty}">
      </span>
    </div>
  </c:if>

</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/Storefront/j2ee/store.war/cartridges/PriceSlider/PriceSlider.jsp#4 $$Change: 810688 $--%>
