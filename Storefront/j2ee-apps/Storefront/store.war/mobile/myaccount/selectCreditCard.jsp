<%--
  This page renders user's credit cards list ("My Account / Credit Cards").

  Page includes:
    /mobile/myaccount/gadgets/myAccountTabBar.jsp - Display tab bar for the page
    /mobile/global/gadgets/savedCreditCards.jsp - List of saved credit cards

  Required parameters:
    None

  Optional parameters:
    None

  NOTES:
    1) The "mobileStorePrefix" request-scoped variable (request attribute), which is used here,
       is defined in the "mobilePageContainer" tag ("mobilePageContainer.tag" file).
       This variable becomes available within the <crs:mobilePageContainer> ... </crs:mobilePageContainer> block
       and in all the included pages (gadgets and Endeca cartridges).
--%>
<dsp:page>
  <fmt:message var="pageTitle" key="mobile.creditcard.paymentInfo"/>
  <crs:mobilePageContainer titleString="${pageTitle}">
    <jsp:body>
      <%-- ========== Navigation Tabs ========== --%>
      <dsp:include page="gadgets/myAccountTabBar.jsp">
        <dsp:param name="secondTabLabel" value="${pageTitle}"/>
        <dsp:param name="highlight" value="second"/>
      </dsp:include>

      <div class="dataContainer">
        <dsp:include page="${mobileStorePrefix}/creditcard/gadgets/savedCreditCards.jsp">
          <dsp:param name="page" value="myaccount"/>
          <dsp:param name="selectable" value="false"/>
          <dsp:param name="displayDefaultLabeled" value="true"/>
        </dsp:include>
      </div>
    </jsp:body>
  </crs:mobilePageContainer>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/Storefront/j2ee/store.war/mobile/myaccount/selectCreditCard.jsp#4 $$Change: 800951 $--%>
