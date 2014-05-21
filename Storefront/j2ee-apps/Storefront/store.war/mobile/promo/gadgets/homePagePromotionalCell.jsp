<%--
  Renders promotional item cell html ("HomeTheme", top slot).

  Required Parameters:
    promotionalContent
      Promotional item
    childTargeter
      Used Targeter

  Optional Parameters:
    None
--%>
<dsp:page>
  <%-- Request parameters - to variables --%>
  <dsp:getvalueof var="promotionalContent" param="promotionalContent"/>
  <dsp:getvalueof var="childTargeter" param="childTargeter"/>

  <div class="cell">
    <div class="homePromotionalWrap">
      <img src="${promotionalContent.derivedImage}" alt="${promotionalContent.displayName}"
           class="homePromotionalImage" style="background-image:url(${promotionalContent.description})"/>
    </div>
  </div>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/Storefront/j2ee/store.war/mobile/promo/gadgets/homePagePromotionalCell.jsp#2 $$Change: 807101 $--%>
