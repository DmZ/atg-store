<%--
  "Search Adjustments" cartridge renderer.
  Mobile version.

  Required Parameters:
    contentItem
      The "SearchAdjustments" content item to render.

  NOTES:
    1) The "siteBaseURL" request-scoped variable (request attribute), which is used here,
       is defined in the "mobilePageContainer" tag ("mobilePageContainer.tag" file).
       This variable becomes available within the <crs:mobilePageContainer> ... </crs:mobilePageContainer> block
       and in all the included pages (gadgets and Endeca cartridges).
--%>
<dsp:page>
  <dsp:importbean bean="/OriginatingRequest" var="originatingRequest"/>
  <dsp:getvalueof var="contentItem" vartype="com.endeca.infront.assembler.ContentItem" value="${originatingRequest.contentItem}"/>

  <c:if test="${not empty contentItem.adjustedSearches || not empty contentItem.suggestedSearches}">
    <div class="SearchAdjustments">
      <%-- Search adjustments --%>
      <c:forEach var="originalTerm" items="${contentItem.originalTerms}" varStatus="status">
        <c:if test="${not empty contentItem.adjustedSearches[originalTerm]}">
          <fmt:message key="mobile.resultsList.searchAdjustment">
            <fmt:param><span>${originalTerm}</span></fmt:param>
          </fmt:message>
          <span> </span>
          <c:forEach var="adjustment" items="${contentItem.adjustedSearches[originalTerm]}" varStatus="status">
            <span>${adjustment.adjustedTerms}</span><%-- exclude whitespaces this way
            --%><c:if test="${!status.last}">, </c:if>
          </c:forEach>
        </c:if>

        <%-- "Did You Mean?" --%>
        <c:if test="${not empty contentItem.suggestedSearches[originalTerm]}">
          <div class="DYM">
            <fmt:message key="mobile.resultsList.searchAdjustment.didYouMean">
              <fmt:param>
                <c:forEach var="suggestion" items="${contentItem.suggestedSearches[originalTerm]}" varStatus="status">
                  <a href="${siteBaseURL}${suggestion.contentPath}${suggestion.navigationState}">${suggestion.label}</a><%-- exclude whitespaces this way
                  --%><c:if test="${!status.last}">, </c:if>
                </c:forEach>
              </fmt:param>
            </fmt:message>
          </div>
        </c:if>
      </c:forEach>
    </div>
  </c:if>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/Storefront/j2ee/store.war/mobile/cartridges/SearchAdjustments/SearchAdjustments.jsp#7 $$Change: 801222 $--%>
