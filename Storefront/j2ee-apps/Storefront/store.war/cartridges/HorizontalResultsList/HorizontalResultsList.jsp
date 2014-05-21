<%--
  Renders a list of products within a Dojo horizontal scroller widget.
  The widget provides paging by means of previous and next buttons
  to move back/forward through sub pages of products. The widget makes
  an ajax call back to this JSP to load a new page of products. When
  the JSP detects an ajax request it returns HTML markup as a response
  to the ajax request. For the inital load (non ajax) the JSP initialises
  and renders the HorizontalResultsList Dojo widget.

  Required parameters:
    contentItem
      The "ResultsList" content item to render.
    contentCollection
      Only required for ajax requests, specifies the path to the Endeca content slot.
      (will be on the ajax request query string)

  Optional Parameters:
    none
--%>

<dsp:page>
  <dsp:importbean bean="/OriginatingRequest" var="originatingRequest" />
  <dsp:importbean bean="/atg/commerce/catalog/ProductLookup"/>
  <dsp:importbean bean="/atg/multisite/Site"/>
  <dsp:importbean bean="/atg/endeca/assembler/droplet/InvokeAssembler"/>
  
  <dsp:getvalueof var="contentItem" vartype="com.endeca.infront.assembler.ContentItem" 
                  value="${originatingRequest.contentItem}" />

  <%--
    On pageload if contentItem is empty then assume an ajax call is
    required to get the contentItem using the contentCollection
    string that is passed on the querystring.
  --%>
  <c:if test="${empty contentItem}">  

    <c:set var="isAjaxRequest" value="true" />

    <dsp:getvalueof var="contentCollection" vartype="java.lang.String"
                    param="contentCollection" />

    <%--
      InvokeAssembler droplet is used to retrieve content from Experience 
      Manager. In this instance we request the contentItem representing the
      Results List.

      Input Parameters:
        contentCollection is the full path to the content in Experience Manager.
      
      Output Parameters:
        contentItem is the content requested from Experience Manager.
    --%>
    <dsp:droplet name="InvokeAssembler">
      <dsp:param name="contentCollection" value="${contentCollection}"/>
      <dsp:oparam name="output">
        <dsp:getvalueof var="contentItem" vartype="com.endeca.infront.assembler.ContentItem"
                        param="contentItem.contents[0]" />
      </dsp:oparam>
    </dsp:droplet>

  </c:if>

  <%--
    It is only necessary to output the Dojo widget span and UL markup
    on first page load (i.e. it does not need to be part of the ajax response)
  --%>
  <c:if test="${empty isAjaxRequest}">

    <dsp:getvalueof var="totalNumRecs" value="${contentItem.totalNumRecs}" />
    <dsp:getvalueof var="recsPerPage" value="${contentItem.recsPerPage}"  />
    <dsp:getvalueof var="contextPath" vartype="java.lang.String" value="${originatingRequest.contextPath}"/>
    <c:set var="pagingAction" value="${contentItem.pagingActionTemplate.navigationState}" />
    <fmt:message var="previous" key="common.previous"/>
    <fmt:message var="next" key="common.next"/>

    <%--
      Instantiate the Dojo Horizontal widget, passing in values for any
      properties that are required or that require a value other than
      the default value. See HorizontalResultsList.js
    --%>
    <span dojotype="atg.store.widget.HorizontalResultsList"
          id="horizontalResultsList" 
          ajaxUrl="${pagingAction}"
          contentCollection="/content/Shared/Results List"
          siteContextPath="${contextPath}"
          pageSize="${recsPerPage}"
          totalNumberOfRecords="${totalNumRecs}"
          previousLinkTitle="${previous}"
          nextLinkTitle="${next}">
        
      <ul class="atg_store_product">

  </c:if>
            
  <c:forEach var="record" items="${contentItem.records}">

    <%--
      Get the product according to the ID returned from the ATG Search results
 
      Input Parameters:
        id - The ID of the product we want to look up
        filterBySite - whether or not filter by site should be applied
        filterByCatalog - whether or not filter by catalog should be applied
    
      Open Parameters:
        output - Serviced when no errors occur
        error - Serviced when an error was encountered when looking up the product
        empty - Serviced when no product is found
    
      Output Parameters:
        element - The product whose ID matches the 'id' input parameter  
    --%>

    <dsp:droplet name="ProductLookup">
      <dsp:param name="id" value="${record.attributes['product.repositoryId']}"/>
      <dsp:param name="filterBySite" value="false"/>
      <dsp:param name="filterByCatalog" value="false"/>
      <dsp:param bean="/OriginatingRequest.requestLocale.locale" name="repositoryKey"/>
          
      <dsp:oparam name="output">
        <dsp:setvalue param="product" paramvalue="element"/>
        <li> 
          <dsp:getvalueof var="productSites" param="product.siteIds" />
          <dsp:getvalueof var="siteId" bean="Site.id" />
          <dsp:contains var="productFromCurrentSite" values="${productSites}" object="${siteId}"/> 
          <dsp:include page="/global/gadgets/productListRangeRow.jsp">                     
            <dsp:param name="product" param="element" />
            <dsp:param name="categoryNav" value="false" />
            <dsp:param name="displaySiteIndicator" value="${!productFromCurrentSite}" />
            <dsp:param name="mode" value="name" />
            <dsp:param name="asLink" value="false" />
          </dsp:include>
        </li>
      </dsp:oparam>
    </dsp:droplet>
        
  </c:forEach>
      
  <c:if test="${empty isAjaxRequest}">
      </ul>
    </span>
  </c:if>

</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/Storefront/j2ee/store.war/cartridges/HorizontalResultsList/HorizontalResultsList.jsp#11 $$Change: 807092 $--%>
