<%--
  This gadget renders "Loading..." box.
  It's used in long-waiting operations for animation.

  Page includes:
    None

  Required parameters:
    None

  NOTES:
    1) The "mobileImagesPrefix" request-scoped variable (request attribute), which is used here,
       is defined in the "mobilePageContainer" tag ("mobilePageContainer.tag" file).
       This variable becomes available within the <crs:mobilePageContainer> ... </crs:mobilePageContainer> block
       and in all the included pages (gadgets and Endeca cartridges).
--%>
<dsp:page>
  <div id="modalMessageBox" style="display:block" class="refineOverlay">
    <img class="spinner" src="${mobileImagesPrefix}spinner.png" alt="<fmt:message key='mobile.common.a11y.loading'/>"/>
  </div>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/Storefront/j2ee/store.war/mobile/global/gadgets/loadingWindow.jsp#5 $$Change: 807181 $--%>
