<%--
  This page displays an overview of the logged in user "Profile information".
  It includes links to edit "Personal Information", "Change Password", "View Orders", "View Addresses",
  "View Credit Cards".

  Page includes:
    /mobile/myaccount/gadgets/myAccountTabBar.jsp - Displays tab bar for the page

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
  <dsp:importbean bean="/atg/dynamo/servlet/RequestLocale"/>
  <dsp:importbean bean="/atg/userprofiling/ProfileFormHandler"/>
  <dsp:importbean bean="/atg/userprofiling/Profile"/>

  <fmt:message var="pageTitle" key="mobile.myAccount.pageTitle"/>
  <crs:mobilePageContainer titleString="${pageTitle}">
    <%-- ========== Navigation Tabs ========== --%>
    <dsp:include page="gadgets/myAccountTabBar.jsp"/>

    <div class="dataContainer">
      <ul class="dataList" role="presentation">
        <%-- "Logout" and "Change Password" row --%>
        <li>
          <div class="left30">
            <%-- "Logout" --%>
            <fmt:message var="logout" key="mobile.common.logout"/>
            <dsp:getvalueof id="userLocale" vartype="java.lang.String" bean="RequestLocale.locale"/>
            <dsp:a page="/" title="${logout}">
              <span class="content">
                <dsp:property bean="ProfileFormHandler.logoutSuccessURL" value="mobile/myaccount/login.jsp?locale=${userLocale}"/>
                <dsp:property bean="ProfileFormHandler.logout" value="true"/>
                <c:out value="${logout}"/>
              </span>
            </dsp:a>
          </div>
          <div class="right70">
            <%-- "Change Password" --%>
            <dsp:a page="${mobileStorePrefix}/myaccount/profilePasswordEdit.jsp" class="icon-ArrowRight">
              <span class="content"><fmt:message key="mobile.myAccount.header.changePassword"/></span>
            </dsp:a>
          </div>
        </li>

        <%-- "Personal Information" --%>
        <li>
          <dsp:a page="${mobileStorePrefix}/myaccount/accountProfileEdit.jsp" class="icon-ArrowRight">
            <span class="content">
              <fmt:message key="mobile.myAccount.header.personalInformation"/>
              <span class="formFieldText">
                <dsp:valueof bean="Profile.firstName"/>&nbsp;<dsp:valueof bean="Profile.lastName"/><br/>
                <dsp:valueof bean="Profile.email"/><br/>
                <dsp:getvalueof var="postalCode" bean="Profile.homeAddress.postalCode"/>
                <c:if test="${not empty postalCode}">${postalCode}</c:if>
              </span>
            </span>
          </dsp:a>
        </li>

        <%-- "Orders" --%>
        <li>
          <dsp:a page="${mobileStorePrefix}/myaccount/myOrders.jsp" class="icon-ArrowRight">
            <span class="content">
              <fmt:message key="mobile.myAccount.header.orders"/>
            </span>
          </dsp:a>
        </li>

        <%-- "Returns" --%>
        <li>
          <dsp:a page="${mobileStorePrefix}/myaccount/myReturns.jsp" class="icon-ArrowRight">
            <span class="content">
              <fmt:message key="mobile.myAccount.header.returns"/>
            </span>
          </dsp:a>
        </li>

        <%-- "Addresses" --%>
        <li>
          <dsp:a page="${mobileStorePrefix}/address/addressBook.jsp" class="icon-ArrowRight">
            <span class="content">
              <fmt:message key="mobile.myAccount.header.addresses"/>
            </span>
          </dsp:a>
        </li>

        <%-- "Credit Cards" --%>
        <li>
          <dsp:a page="${mobileStorePrefix}/myaccount/selectCreditCard.jsp" class="icon-ArrowRight">
            <span class="content">
              <fmt:message key="mobile.myAccount.header.creditCards"/>
            </span>
          </dsp:a>
        </li>
      </ul>
    </div>
  </crs:mobilePageContainer>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/Storefront/j2ee/store.war/mobile/myaccount/profile.jsp#13 $$Change: 804135 $--%>
