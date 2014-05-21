<%--
  This page displays the tab bar for the "My Account" pages. The bar consists of three tabs. The first 
  tab is always set to "My Account" page.

  Page includes:
    /mobile/includes/tabBar.jsp - Tab bar core

  Required parameters:
    None

  Optional parameters:
    secondTabLabel
      Label for the second tab
    secondTabURL
      Url for the second tab. If no url is specified, a link is not provided
    thirdTabLabel
      Label for the third tab.
    highlight
      Specifies which tab should be highlighted. 
      Expected values are: "first", "second", or "third"

  NOTE: There is no option for a "rightURL" because it would not make sense to have one
        in the "My Account" section.

  NOTES:
    1) The "mobileStorePrefix" request-scoped variable (request attribute), which is used here,
       is defined in the "mobilePageContainer" tag ("mobilePageContainer.tag" file).
       This variable becomes available within the <crs:mobilePageContainer> ... </crs:mobilePageContainer> block
       and in all the included pages (gadgets and Endeca cartridges).
--%>
<dsp:page>
  <dsp:getvalueof var="highlight" param="highlight"/>
  <fmt:message var="myaccountTitle" key="mobile.myAccount.label.myAccount"/>

  <dsp:include page="${mobileStorePrefix}/includes/tabBar.jsp">
    <dsp:param name="firstTabLabel" value="${myaccountTitle}"/>
    <dsp:param name="firstTabURL" value="${mobileStorePrefix}/myaccount/profile.jsp"/>

    <dsp:param name="secondTabLabel" param="secondTabLabel"/>
    <dsp:param name="secondTabURL" param="secondTabURL"/>

    <dsp:param name="thirdTabLabel" param="thirdTabLabel"/>

    <c:if test="${empty highlight}">
      <dsp:setvalue param="highlight" value="first"/>
    </c:if>
    <dsp:param name="highlight" param="highlight"/>
  </dsp:include>
</dsp:page>
