<%--
  Renders a search box which allows the user to query for search results.
  Provides checkboxes to allow user to search across sites (where applicable)
  and also supports auto auggest (provides a list of possible matches as
  the user types)

  Required parameters:
    contentItem
      The "Search Box" content item
    
  Optional parameters:
    None.
--%>
<dsp:page>
  <dsp:importbean bean="/OriginatingRequest" var="originatingRequest"/>
  <dsp:importbean bean="/atg/dynamo/droplet/multisite/CartSharingSitesDroplet" />
  <dsp:importbean bean="/atg/dynamo/droplet/ForEach" />
  <dsp:importbean bean="/atg/multisite/Site" var="currentSite"/>
  <dsp:importbean bean="/atg/endeca/assembler/SearchFormHandler"/>
  <dsp:importbean bean="/atg/endeca/assembler/cartridge/manager/DefaultActionPathProvider"/>

  <dsp:getvalueof var="contentItem" vartype="com.endeca.infront.assembler.ContentItem" value="${originatingRequest.contentItem}"/> 
  <dsp:getvalueof var="contextPath" vartype="java.lang.String" value="${originatingRequest.contextPath}"/>
  <dsp:getvalueof var="actionPath" bean="DefaultActionPathProvider.defaultExperienceManagerNavigationActionPath"/>

  <fmt:message var="hintText" key="common.search.input"/>
  <fmt:message var="submitText" key="search_simpleSearch.submit"/>
  
  <div id="atg_store_search">
    
    <%-- The search form --%>
    <dsp:form action="${contextPath}${actionPath}" id="searchForm" requiresSessionConfirmation="false">
      <input type="hidden" name="Dy" value="1"/>
      <input type="hidden" name="Nty" value="1"/>
      <dsp:input bean="SearchFormHandler.siteScope" type="hidden" value="ok" name="siteScope"/>

      <%--
        The autocomplete attribute specifies whether or not an input field 
        should have autocomplete enabled. Autocomplete allows the browser to 
        display a list of options to fill in the field, based on earlier typed values.
        Turn off browser autocomplete when auto suggest is enabled so that only one
        list of options is displayed to the user.
      --%>
      <c:set var="nativeAutoCompleteState" value="on" />

      <c:if test="${contentItem.autoSuggestEnabled}">
        <dsp:getvalueof var="minAutoSuggestInputLength" value="${contentItem.minAutoSuggestInputLength}" />
        <%--
          Instantiate the Dojo AutoSuggest widget, passing in values for any
          properties that are required or that require a value other than
          the default value. See AutoSuggest.js
        --%>
        <span dojotype="atg.store.widget.AutoSuggest"
              id="autoSuggest"
              ajaxUrl="${contextPath}/assembler"
              contentCollection="/content/Shared/Auto-Suggest Panels"
              siteContextPath="${contextPath}"
              searchBoxId="atg_store_searchInput"
              submitButtonId="atg_store_searchSubmit"
              minInputLength="${minAutoSuggestInputLength}"
              animationDuration="500">
        </span>
        <c:set var="nativeAutoCompleteState" value="off" />
      </c:if>
      
      <input class="text atg_store_searchInput" name="Ntt" value="${hintText}" type="text" 
        id="atg_store_searchInput" title="${hintText}" autocomplete="${nativeAutoCompleteState}"/>
      
      <div id="atg_store_searchStoreSelect">
        
        <%--
          Check if the current site has a shared cart, other sites will be 
          editable check boxes. If site doesn't have a shareable, then search
          within the current site context.

          CartSharingSitesDroplet returns a collection of sites that share the 
          shopping cart shareable (atg.ShoppingCart) with the current site.
          You may optionally exclude the current site from the result.

          Input Parameters:
            excludeInputSite - Should the returned sites include the current
       
          Open Parameters:
            output - This parameter is rendered once, if a collection of sites
                     is found.
       
          Output Parameters:
            sites - The list of sharing sites.
        --%>
        <dsp:droplet name="CartSharingSitesDroplet" excludeInputSite="true"
                     var="sharingSites">
          <dsp:oparam name="output">
               
            <%-- Loop through the sites --%>
            <dsp:droplet name="ForEach" array="${sharingSites.sites}" var="current">
              
              <%-- Set to search the current site --%>      
              <dsp:oparam name="outputStart">            
                <dsp:input type="hidden" value="${currentSite.id}" bean="SearchFormHandler.siteIds" name="siteIds"/>
              </dsp:oparam>
              
              <%-- other sites --%>
              <dsp:oparam name="output">
                <dsp:setvalue param="site" value="${current.element}"/>
                <dsp:getvalueof var="siteId" param="site.id"/>
                <div>
                  <dsp:input type="checkbox" value="${siteId}" id="otherStore"
                    bean="SearchFormHandler.siteIds" checked="false" name="siteIds"/>
                  <label for="otherStore">
                    <fmt:message key="search.otherStoresLabel">
                      <fmt:param>
                        <dsp:valueof param="site.name"/>
                      </fmt:param>
                    </fmt:message>           
                  </label>
                </div>    
              </dsp:oparam>
            </dsp:droplet>
          </dsp:oparam>
          
          <dsp:oparam name="empty"> 
            <input type="hidden" value="${currentSite.id}" priority="10" />
          </dsp:oparam>
        </dsp:droplet>
      </div>

      <fmt:message var="submitText" key="search_simpleSearch.submit"/>
      <span class="atg_store_smallButton">
        <dsp:input type="submit" bean="SearchFormHandler.search" name="search" 
          value="${submitText}" id="atg_store_searchSubmit" title="${submitText}"/>
      </span>
      
    </dsp:form> 
  </div>
  

</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/Storefront/j2ee/store.war/cartridges/SearchBox/SearchBox.jsp#9 $$Change: 806644 $--%>
