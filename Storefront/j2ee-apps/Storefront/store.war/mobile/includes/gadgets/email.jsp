<%--
  Shows an "Email" link.

  Required parameters:
    None

  Optional parameters:
    None

  NOTES:
    1) The "mobileImagesPrefix" request-scoped variable (request attribute), which is used here,
       is defined in the "mobilePageContainer" tag ("mobilePageContainer.tag" file).
       This variable becomes available within the <crs:mobilePageContainer> ... </crs:mobilePageContainer> block
       and in all the included pages (gadgets and Endeca cartridges).
--%>
<dsp:page>
  <fmt:message var="emailLabel" key="mobile.common.email"/>
  <a class="contact" href="mailto:<fmt:message key='mobile.contactUs.emailAddress'/>" title="${emailLabel}">
    <img src="${mobileImagesPrefix}icon-email.png"/>
    <span>${emailLabel}</span>
  </a>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/Storefront/j2ee/store.war/mobile/includes/gadgets/email.jsp#3 $$Change: 801227 $ --%>
