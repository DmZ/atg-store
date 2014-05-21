<%--
  Renders html for promotional items slot ("HomeFeaturedProducts", bottom slot).

  Page includes:
    /mobile/promo/gadgets/homePagePromotionalCell.jsp - Renders promotional item cell html

  Required Parameters:
    None

  Optional Parameters:
    None

  NOTES:
    1) The "mobileStorePrefix" request-scoped variable (request attribute), which is used here,
       is defined in the "mobilePageContainer" tag ("mobilePageContainer.tag" file).
       This variable becomes available within the <crs:mobilePageContainer> ... </crs:mobilePageContainer> block
       and in all the included pages (gadgets and Endeca cartridges).
--%>
<dsp:page>
  <dsp:importbean bean="/atg/targeting/TargetingFirst"/>

  <div id="homeTopSlotContent">
    <dsp:droplet name="TargetingFirst">
      <%-- Promotional item #1 --%>
      <dsp:param bean="atg/registry/RepositoryTargeters/ProductCatalog/MobilePromotionParent1" name="targeter"/>
      <dsp:param name="fireViewItemEvent" value="false"/>
      <dsp:oparam name="output">
        <dsp:include page="${mobileStorePrefix}/promo/gadgets/homePagePromotionalCell.jsp">
          <dsp:param name="promotionalContent" param="element"/>
          <dsp:param name="childTargeter" value="/atg/registry/RepositoryTargeters/ProductCatalog/MobilePromotionChild1"/>
        </dsp:include>
      </dsp:oparam>
    </dsp:droplet>
    <dsp:droplet name="TargetingFirst">
      <%-- Promotional item #2 --%>
      <dsp:param bean="atg/registry/RepositoryTargeters/ProductCatalog/MobilePromotionParent2" name="targeter"/>
      <dsp:param name="fireViewItemEvent" value="false"/>
      <dsp:oparam name="output">
        <dsp:include page="${mobileStorePrefix}/promo/gadgets/homePagePromotionalCell.jsp">
          <dsp:param name="promotionalContent" param="element"/>
          <dsp:param name="childTargeter" value="/atg/registry/RepositoryTargeters/ProductCatalog/MobilePromotionChild2"/>
        </dsp:include>
      </dsp:oparam>
    </dsp:droplet>
    <dsp:droplet name="TargetingFirst">
      <%-- Promotional item #3 --%>
      <dsp:param bean="atg/registry/RepositoryTargeters/ProductCatalog/MobilePromotionParent3" name="targeter"/>
      <dsp:param name="fireViewItemEvent" value="false"/>
      <dsp:oparam name="output">
        <dsp:include page="${mobileStorePrefix}/promo/gadgets/homePagePromotionalCell.jsp">
          <dsp:param name="promotionalContent" param="element"/>
          <dsp:param name="childTargeter" value="/atg/registry/RepositoryTargeters/ProductCatalog/MobilePromotionChild3"/>
        </dsp:include>
      </dsp:oparam>
    </dsp:droplet>
  </div>
  <div id="circlesContainer">
    <table>
      <tbody>
        <tr>
          <td>
            <div id="pageCircle_0" class="ON"></div>
            <div id="pageCircle_1" class="BLANK"></div>
            <div id="pageCircle_2" class="BLANK"></div>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/Storefront/j2ee/store.war/mobile/promo/gadgets/homePromotionalItemRenderer.jsp#4 $$Change: 807101 $--%>
