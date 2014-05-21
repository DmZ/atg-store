<%--
  Renders MediaBanner cartridge content.
  "Media image" and "Click Action URL" are taken from values defined in XMgr for MediaBanner cartridge.

  Required parameters:
    None.
    
  Optional parameters:
    None.
--%>
<dsp:page>
  <dsp:importbean bean="/OriginatingRequest" var="originatingRequest"/>
  <dsp:importbean bean="/atg/endeca/store/droplet/ActionURLDroplet"/>
  
  <dsp:getvalueof var="contentItem" vartype="com.endeca.infront.assembler.ContentItem" 
                  value="${originatingRequest.contentItem}"/>
  
  <c:if test="${not empty contentItem.link}">
  
    <%-- Get the URL for the action passed within content item --%>
    <dsp:droplet name="ActionURLDroplet">
      <dsp:param name="action" value="${contentItem.link}"/>
      <dsp:oparam name="output">
        <dsp:getvalueof var="actionURL" param="actionURL"/>
      </dsp:oparam>
    </dsp:droplet>
  </c:if>

  <div id="atg_store_mediaBannerContainer">
    <c:if test="${not empty actionURL}">
      <a href="${actionURL}">
    </c:if>
      <img src="${contentItem.imageURL}" alt="${contentItem.name}"/>
    <c:if test="${not empty actionURL}">
      </a>
    </c:if>
  </div>

</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/Storefront/j2ee/store.war/cartridges/MediaBanner/MediaBanner.jsp#4 $$Change: 797916 $--%>
