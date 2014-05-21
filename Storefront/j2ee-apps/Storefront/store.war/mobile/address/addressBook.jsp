<%--
  Renders a list of addresses saved to the user's profile (secondary addresses).
  Also provides an "Add Shipping Address" link.

  Page includes:
    /mobile/myaccount/gadgets/myAccountTabBar.jsp - Display tab bar for the page
    /mobile/address/gadgets/displayAddress.jsp - Renderer of address info
    /mobile/global/gadgets/errorMessage.jsp - Displays all errors collected from FormHandler

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
  <dsp:importbean bean="/atg/commerce/collections/filter/droplet/GiftlistSiteFilterDroplet"/>
  <dsp:importbean bean="/atg/commerce/gifts/GiftlistFormHandler"/>
  <dsp:importbean bean="/atg/commerce/gifts/GiftlistLookupDroplet"/>
  <dsp:importbean bean="/atg/commerce/util/MapToArrayDefaultFirst"/>
  <dsp:importbean bean="/atg/userprofiling/ProfileFormHandler"/>
  <dsp:importbean bean="/atg/userprofiling/Profile"/>

  <%-- Get Profile "Default Shipping address" --%>
  <dsp:getvalueof var="defaultAddr" bean="Profile.shippingAddress"/>

  <fmt:message var="pageTitle" key="mobile.address.addressBook"/>
  <crs:mobilePageContainer titleString="${pageTitle}">
    <%--
      Here, we retrieve a list of all of the addresses used in gift lists. We do this
      because we must display a modal popup which links to the full CRS site when a user
      attempts to delete an address used in a gift list (desired functionality).
      First, we create a list of gift-list addresses. Later in the jsp, we compare each of the
      user's addresses against the list to determine if it is used. If it is, we set
      "deletable" to "false" and pass it to "myaccountAddressDetail.jsp". Otherwise, we set deletable to "true".
    --%>
    <%-- START: Get all gift-list addresses --%>
    <jsp:useBean id="giftlistsMap" class="java.util.HashMap"/>
    <dsp:droplet name="GiftlistSiteFilterDroplet">
      <dsp:param name="collection" bean="Profile.giftlists"/>
      <dsp:oparam name="output">
        <dsp:getvalueof var="giftlistCollection" param="filteredCollection"/>
        <c:forEach var="giftlist" items="${giftlistCollection}">

          <%-- Use GiftlistLookupDroplet (ItemLookupDroplet) to retrieve each gift-list --%>
          <dsp:droplet name="GiftlistLookupDroplet">
            <dsp:param name="id" value="${giftlist.repositoryId}"/>
            <dsp:oparam name="output">
              <%-- Set current "giftlist" in the "GiftlistFormHandler" --%>
              <dsp:setvalue bean="GiftlistFormHandler.giftlist" paramvalue="element"/>
            </dsp:oparam>
          </dsp:droplet>

          <%-- Use GiftlistFormHandler to provide "shippingAddressId" used in gift-list --%>
          <dsp:getvalueof var="currentGiftlistShippingId" bean="GiftlistFormHandler.shippingAddressId"/>
          <c:set target="${giftlistsMap}" property="${currentGiftlistShippingId}" value="address"/>
        </c:forEach>
      </dsp:oparam>
    </dsp:droplet>
    <%-- END: Get all gift-list addresses --%>

    <%-- ========== Navigation Tabs ========== --%>
    <dsp:include page="${mobileStorePrefix}/myaccount/gadgets/myAccountTabBar.jsp">
      <dsp:param name="secondTabLabel" value="${pageTitle}"/>
      <dsp:param name="highlight" value="second"/>
    </dsp:include>

    <div class="dataContainer">
      <%-- Display "ProfileFormHandler" error messages, which were specified in "formException.message" --%>
      <dsp:include page="${mobileStorePrefix}/global/gadgets/errorMessage.jsp">
        <dsp:param name="formHandler" bean="ProfileFormHandler"/>
      </dsp:include>

      <ul class="dataList" role="presentation">
        <%--
          Iterate through all this user's Shipping addresses, sorting the array so that the
          Default Shipping address comes first.

          Input parameters:
            defaultId
              Repository Id of item that will be the first in the array
            map
              Map of repository items that will be converted into array
            sortByKeys
              Returning array will be sorted by keys (address "Nickname")

          Output parameters:
            sortedArray
              Array of sorted profile Shipping addresses
        --%>
        <dsp:droplet name="MapToArrayDefaultFirst">
          <c:if test="${not empty defaultAddr}"> <%-- "Default Shipping address" might NOT be set --%>
            <dsp:param name="defaultId" value="${defaultAddr.repositoryId}"/>
          </c:if>
          <dsp:param name="map" bean="Profile.secondaryAddresses"/>
          <dsp:param name="sortByKeys" value="true"/>

          <dsp:oparam name="empty"><%-- Do nothing when empty --%></dsp:oparam>
          <dsp:oparam name="output">
            <dsp:getvalueof var="sortedArray" param="sortedArray"/>

            <%-- Iterate through each address --%>
            <c:forEach var="shippingAddress" items="${sortedArray}" varStatus="status">
              <%-- Get the shipping address Id of each address --%>
              <c:set var="addressId" value="${shippingAddress.value.repositoryId}"/>

              <%-- Set deletable by checking if "addressId" is in our map of gift-list addresses --%>
              <c:set var="deletable" value="${empty giftlistsMap[addressId] ? 'true' : 'false'}"/>

              <%-- Link to "Edit Shipping Address". Address information --%>
              <dsp:setvalue param="shippingAddress" value="${shippingAddress}"/>
              <c:url value="${mobileStorePrefix}/address/myaccountAddressDetail.jsp" var="editURL">
                <c:param name="editAddrNickname" value="${shippingAddress.key}"/>
                <c:param name="addrOper" value="edit"/>
                <c:param name="addrType" value="shipping"/>
                <c:param name="deletable" value="${deletable}"/>
              </c:url>
              <li>
                <div class="content">
                  <dsp:valueof param="shippingAddress.key"/> <%-- Address "Nickname" --%>
                  <dsp:include page="gadgets/displayAddress.jsp">
                    <dsp:param name="address" value="${shippingAddress.value}"/>
                    <dsp:param name="isPrivate" value="false"/>
                  </dsp:include>
                  <%-- "Is Default" (default address goes FIRST) --%>
                  <c:if test="${status.count == 1 && not empty defaultAddr}">
                    <span class="defaultLabel"><fmt:message key="mobile.common.label.default"/></span>
                  </c:if>
                </div>
                <fmt:message var="addrEditTitle" key="mobile.address.header.editAddress"/>
                <dsp:a href="${editURL}" bean="ProfileFormHandler.editAddress" paramvalue="shippingAddress.key"
                       title="${addrEditTitle}" class="icon-BlueArrow"/>
              </li>
            </c:forEach>
          </dsp:oparam>
        </dsp:droplet>

        <%-- Link to "Add Shipping Address" --%>
        <li>
          <dsp:a page="${mobileStorePrefix}/address/myaccountAddressDetail.jsp?addrType=shipping&addrOper=add" class="icon-ArrowRight">
            <span class="content"><fmt:message key="mobile.address.link.createShippingAddress"/></span>
          </dsp:a>
        </li>
      </ul>
    </div>
  </crs:mobilePageContainer>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/Storefront/j2ee/store.war/mobile/address/addressBook.jsp#9 $$Change: 800951 $--%>
