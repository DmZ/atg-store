<%--
  "PageSlot" cartridge renderer.
  Mobile version.

  Passes the contents of the "PageSlot" to a renderer JSP that knows how to
  handle the contents of particular type.

  NOTES:
    1) The "endecaUserAgent" request-scoped variable (request attribute), which is used here,
       is defined in the "MobileDetectionInterceptor" Nucleus component: it's set, when the "Endeca Preview" is enabled
       (AssemblerSettings.previewEnabled = true) and the "Endeca Preview User-Agent" request parameter
       is present in the request (even if it's an empty string).
--%>
<dsp:page>
  <dsp:importbean bean="/OriginatingRequest" var="originatingRequest"/>
  <dsp:getvalueof var="contentItem" vartype="com.endeca.infront.assembler.ContentItem" value="${originatingRequest.contentItem}"/>

  <c:choose>
    <c:when test="${endecaUserAgent != null}">
      <endeca:includeSlot contentItem="${contentItem}">
        <c:forEach var="element" items="${contentItem.contents}">
          <dsp:renderContentItem contentItem="${element}"/>
        </c:forEach>
      </endeca:includeSlot>
    </c:when>
    <c:otherwise>
      <c:forEach var="element" items="${contentItem.contents}">
        <dsp:renderContentItem contentItem="${element}"/>
      </c:forEach>
    </c:otherwise>
  </c:choose>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/Storefront/j2ee/store.war/mobile/cartridges/PageSlot/PageSlot.jsp#4 $$Change: 800951 $--%>
