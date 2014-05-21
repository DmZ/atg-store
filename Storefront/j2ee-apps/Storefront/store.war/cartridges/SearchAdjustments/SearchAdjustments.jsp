<%--
  "Search Adjustments" cartridge renderer.
 
  Required parameters:
    contentItem
      The "ResultsList" content item to render.
--%>
<dsp:page>
  <dsp:importbean bean="/OriginatingRequest" var="originatingRequest"/>
  <dsp:getvalueof var="contextPath" vartype="java.lang.String" value="${originatingRequest.contextPath}"/>
  <dsp:getvalueof var="contentItem" vartype="com.endeca.infront.assembler.ContentItem" value="${originatingRequest.contentItem}"/>
  
  <c:if test="${not empty contentItem.adjustedSearches || not empty contentItem.suggestedSearches}">
    <div class="atg_store_searchAdjustments">
      <%-- Search adjustments --%>
      <c:forEach var="originalTerm" items="${contentItem.originalTerms}" varStatus="status">
        <c:if test="${not empty contentItem.adjustedSearches[originalTerm]}"> 
          <fmt:message key="search.adjustment.description"><fmt:param><span>&quot;${originalTerm}&quot;</span></fmt:param></fmt:message>
          <c:forEach var="adjustment" items="${contentItem.adjustedSearches[originalTerm]}" varStatus="status">
            <span class="autoCorrect">&quot;${adjustment.adjustedTerms}&quot;</span>
            <c:if test="${!status.last}">, </c:if>
            <dsp:param name="correctedTerm" value="${adjustment.adjustedTerms}"/>
          </c:forEach>
        </c:if>

        <%-- "Did You Mean?" --%>
        <c:if test="${not empty contentItem.suggestedSearches[originalTerm]}">
          <div class="atg_store_didYouMean">      
            <fmt:message key="search.adjustment.didYouMean">
              <fmt:param>
                <c:forEach var="suggestion" items="${contentItem.suggestedSearches[originalTerm]}" varStatus="status"> 
                  <c:choose> 
                    <c:when test="${!status.last}">             
                      <a href="${contextPath}${suggestion.contentPath}${suggestion.navigationState}">${suggestion.label}</a>,
                    </c:when>
                    <c:otherwise>
                      <a href="${contextPath}${suggestion.contentPath}${suggestion.navigationState}">${suggestion.label}</a>
                    </c:otherwise>
                  </c:choose>
                </c:forEach>
              </fmt:param>
            </fmt:message>
          </div>
        </c:if>
      </c:forEach>
    </div>
  </c:if>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/Storefront/j2ee/store.war/cartridges/SearchAdjustments/SearchAdjustments.jsp#6 $$Change: 806044 $--%>
