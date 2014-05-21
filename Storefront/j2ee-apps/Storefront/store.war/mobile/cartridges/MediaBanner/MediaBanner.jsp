<%--
  Draws MediaBanner on page.
  "Media image" and "Click Action URL" are taken from values defined in XMgr for MediaBanner cartridge.

  Required parameters:
    none

  NOTES:
    1) The "mobileStorePrefix" request-scoped variable (request attribute), which is used here,
       is defined in the "mobilePageContainer" tag ("mobilePageContainer.tag" file).
       This variable becomes available within the <crs:mobilePageContainer> ... </crs:mobilePageContainer> block
       and in all the included pages (gadgets and Endeca cartridges).
--%>
<dsp:page>
  <dsp:importbean bean="/OriginatingRequest" var="originatingRequest"/>
  <dsp:getvalueof var="contentItem" vartype="com.endeca.infront.assembler.ContentItem" value="${originatingRequest.contentItem}"/>

  <c:if test="${not empty contentItem.link}">
    <dsp:include page="${mobileStorePrefix}/global/util/getNavLink.jsp">
      <dsp:param name="navAction" value="${contentItem.link}"/>
    </dsp:include>
  </c:if>

  <div class="mediaBannerContainer">
    <c:choose>
      <c:when test="${not empty navLink}">
        <a href="${navLink}"><img src="${contentItem.imageURL}" alt="${contentItem.name}"/></a>
      </c:when>
      <c:otherwise>
        <img src="${contentItem.imageURL}" alt="${contentItem.name}"/>
      </c:otherwise>
    </c:choose>
  </div>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/Storefront/j2ee/store.war/mobile/cartridges/MediaBanner/MediaBanner.jsp#7 $$Change: 800951 $--%>
