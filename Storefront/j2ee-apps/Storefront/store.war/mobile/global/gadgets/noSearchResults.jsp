<%--
  This gadget renders "No Search Results" pseudo-modal popup with the following options available:
    - Adjust filters
    - Clear all filters

  Optional parameters:
    Ntt
      Endeca parameter (search term).

  NOTES:
    1) The "mobileStorePrefix", "siteContextPath", "navigationActionPath" request-scoped variables (request attributes),
       which are used here, are defined in the "mobilePageContainer" tag ("mobilePageContainer.tag" file).
       These variables become available within the <crs:mobilePageContainer> ... </crs:mobilePageContainer> block
       and in all the included pages (gadgets and Endeca cartridges).
--%>
<dsp:page>
  <%-- Request parameters - to variables --%>
  <dsp:getvalueof var="valueNtt" param="Ntt"/>
  <c:set var="paramNtt">
    <c:choose>
      <c:when test="${empty valueNtt}"></c:when>
      <c:otherwise>&Ntt=${valueNtt}</c:otherwise>
    </c:choose>
  </c:set>

  <div id="noSearchResultsPopup">
    <ul class="dataList">
      <li><div class="content"><fmt:message key="mobile.resultsList.refinement.noResults"/></div></li>
      <li class="icon-ArrowRight" role="link">
        <div class="content"><fmt:message key="mobile.resultsList.button.adjustFilter"/></div>
      </li>
      <li class="icon-ArrowRight" onclick="document.location='${siteContextPath}${navigationActionPath}?Dy=1&Nty=1${paramNtt}&nav=true'" role="link">
        <div class="content"><fmt:message key="mobile.resultsList.button.clearFilter"/></div>
      </li>
    </ul>
  </div>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/Storefront/j2ee/store.war/mobile/global/gadgets/noSearchResults.jsp#4 $$Change: 800951 $--%>
