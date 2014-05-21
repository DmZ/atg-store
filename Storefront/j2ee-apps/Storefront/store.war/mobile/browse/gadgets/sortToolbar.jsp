<%--
  Renders the sort toolbar for an Endeca-driven results list page.

  Required parameters:
    contentItem
      The "ResultsList" content item.

  NOTES:
    1) The "siteContextPath", "navigationActionPath" request-scoped variables (request attributes), which are used here,
       are defined in the "mobilePageContainer" tag ("mobilePageContainer.tag" file).
       These variables become available within the <crs:mobilePageContainer> ... </crs:mobilePageContainer> block
       and in all the included pages (gadgets and Endeca cartridges).
--%>
<dsp:page>
  <dsp:getvalueof var="contentItem" vartype="com.endeca.infront.assembler.ContentItem" param="contentItem"/>

  <c:if test="${contentItem.totalNumRecs > 1}">
    <%--
      Determine the right labels based on the sort status and determine the selected button.
      Also, save the sort actions associated with each sort option for later use.
    --%>
    <fmt:message var="topPicksLabel" key="mobile.resultsList.sort.topPicks"/>
    <fmt:message var="nameSortLabel" key="mobile.resultsList.sort.name"/>
    <fmt:message var="priceSortLabel" key="mobile.resultsList.sort.price"/>

    <c:set var="topPicksSelected" value=""/>
    <c:set var="nameSelected" value=""/>
    <c:set var="priceSelected" value=""/>

    <c:forEach var="sortOption" items="${contentItem.sortOptions}">
      <c:choose>
        <c:when test="${sortOption.label == 'sort.nameAZ'}">
          <c:set var="nameAZAction" value="${sortOption.navigationState}"/>
          <c:if test="${sortOption.selected}">
            <fmt:message var="nameSortLabel" key="mobile.resultsList.sort.name.asc"/>
            <c:set var="selected" value="nameAZ"/>
            <c:set var="nameSelected" value="selected"/>
          </c:if>
        </c:when>
        <c:when test="${sortOption.label == 'sort.nameZA'}">
          <c:set var="nameZAAction" value="${sortOption.navigationState}"/>
          <c:if test="${sortOption.selected}">
            <c:set var="selected" value="nameZA"/>
            <fmt:message var="nameSortLabel" key="mobile.resultsList.sort.name.desc"/>
            <c:set var="nameSelected" value="selected"/>
          </c:if>
        </c:when>
        <c:when test="${sortOption.label == 'sort.priceLH'}">
          <c:set var="priceLHAction" value="${sortOption.navigationState}"/>
          <c:if test="${sortOption.selected}">
            <c:set var="selected" value="priceLH"/>
            <fmt:message var="priceSortLabel" key="mobile.resultsList.sort.price.asc"/>
            <c:set var="priceSelected" value="selected"/>
          </c:if>
        </c:when>
        <c:when test="${sortOption.label == 'sort.priceHL'}">
          <c:set var="priceHLAction" value="${sortOption.navigationState}"/>
          <c:if test="${sortOption.selected}">
            <c:set var="selected" value="priceHL"/>
            <fmt:message var="priceSortLabel" key="mobile.resultsList.sort.price.desc"/>
            <c:set var="priceSelected" value="selected"/>
          </c:if>
        </c:when>
        <c:when test="${sortOption.label == 'common.topPicks'}">
          <c:set var="selected" value="topPicks"/>
          <c:set var="topPicksAction" value="${sortOption.navigationState}"/>
          <c:if test="${sortOption.selected}">
            <c:set var="topPicksSelected" value="selected"/>
          </c:if>
        </c:when>
      </c:choose>
    </c:forEach>

    <c:if test="${(empty priceSelected) && (empty nameSelected) && (empty topPicksSelected)}">
      <c:set var="topPicksSelected" value="selected"/>
    </c:if>

    <%--
      Modify the URL to remove the nav=true part. Removing this parameter will take the user
      directly to the list view as opposed to landing them on the filter view.
    --%>
    <c:set var="nameZAAction" value="${fn:replace(nameZAAction, '&nav=true', '')}"/>
    <c:set var="nameAZAction" value="${fn:replace(nameAZAction, '&nav=true', '')}"/>
    <c:set var="priceHLAction" value="${fn:replace(priceHLAction, '&nav=true', '')}"/>
    <c:set var="priceLHAction" value="${fn:replace(priceLHAction, '&nav=true', '')}"/>
    <c:set var="topPicksAction" value="${fn:replace(topPicksAction, '&nav=true', '')}"/>

    <%-- Determine the right action for the sorting buttons --%>
    <c:choose>
      <c:when test="${selected == 'nameAZ'}">
        <c:set var="nameAction" value="${nameZAAction}"/>
        <c:set var="priceAction" value="${priceLHAction}"/>
      </c:when>
      <c:when test="${selected == 'nameZA'}">
        <c:set var="nameAction" value="${nameAZAction}"/>
        <c:set var="priceAction" value="${priceLHAction}"/>
      </c:when>
      <c:when test="${selected == 'priceHL'}">
        <c:set var="nameAction" value="${nameAZAction}"/>
        <c:set var="priceAction" value="${priceLHAction}"/>
      </c:when>
      <c:when test="${selected == 'priceLH'}">
        <c:set var="nameAction" value="${nameAZAction}"/>
        <c:set var="priceAction" value="${priceHLAction}"/>
      </c:when>
      <c:otherwise>
        <c:set var="nameAction" value="${nameAZAction}"/>
        <c:set var="priceAction" value="${priceLHAction}"/>
     </c:otherwise>
    </c:choose>

    <%-- Remember the current sort key --%>
    <input type="hidden" id="currentSort" value="${selected}"/>

    <%-- Draw the sorting "buttons" --%>
    <li class="sortToolbar">
      <div id="topPicksSort" class="${topPicksSelected}">
        <a id="topPicksURL" href="${siteContextPath}${navigationActionPath}${topPicksAction}">${topPicksLabel}</a>
      </div>
      <div id="nameSort" class="${nameSelected}">
        <a href="${siteContextPath}${navigationActionPath}${nameAction}">${nameSortLabel}</a>
      </div>
      <div id="priceSort" class="${priceSelected}">
        <a href="${siteContextPath}${navigationActionPath}${priceAction}">${priceSortLabel}</a>
      </div>
    </li>
  </c:if>

  <script>
    $(document).ready(function() {
      CRSMA.search.initSortByTopPicks();
    });
  </script>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/Storefront/j2ee/store.war/mobile/browse/gadgets/sortToolbar.jsp#9 $$Change: 811882 $--%>
