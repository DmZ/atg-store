<%--
  Renders the details of a returned order.

  Page includes:
    /global/util/returnState.jsp - Display return status
    /mobile/myaccount/gadgets/myAccountTabBar.jsp - Display tab bar for the page
    /mobile/myaccount/gadgets/returnItems.jsp - Renders the list of returned items
    /mobile/myaccount/gadgets/refundPriceAdjustments.jsp - Displays price and promotions adjustments information
    /mobile/myaccount/gadgets/refundMethods.jsp - Displays refund payment methods
    /mobile/myaccount/gadgets/refundSummary.jsp - Displays refund information summary
    /mobile//myaccount/gadgets/returnOrderSummary.jsp - Displays summary of the original order

  Required parameters:
    returnRequestId
      Return id
      
  NOTES:
    1) The "mobileStorePrefix" request-scoped variable (request attribute), which is used here,
       is defined in the "mobilePageContainer" tag ("mobilePageContainer.tag" file).
       This variable becomes available within the <crs:mobilePageContainer> ... </crs:mobilePageContainer> block
       and in all the included pages (gadgets and Endeca cartridges).
--%>
<dsp:page>
  <dsp:importbean bean="/atg/commerce/custsvc/returns/ReturnRequestLookup"/>
  <dsp:importbean bean="/atg/core/i18n/LocaleTools"/>

  <%-- Request parameters - to variables --%>
  <dsp:getvalueof var="returnRequestId" param="returnRequestId"/>

  <fmt:message var="pageTitle" key="mobile.myAccount.tab.myReturns"/>
  <crs:mobilePageContainer titleString="${pageTitle}">
    <jsp:body>
      <dsp:droplet name="ReturnRequestLookup">
        <dsp:param name="returnRequestId" param="returnRequestId"/>

        <dsp:oparam name="error">
          <%-- An error occurred during return request retrieving --%>
          <div class="infoHeader">${pageTitle}</div>
          <div class="infoContent">
            <p>
              <dsp:valueof param="errorMsg"/>
            </p>
          </div>
        </dsp:oparam>

        <dsp:oparam name="empty">
          <%-- No return request with given ID is found. Display message --%>
          <div class="infoHeader">${pageTitle}</div>
          <div class="infoContent">
            <p>
              <fmt:message key="myaccount_myReturns_noSuchReturn">
                <fmt:param><dsp:valueof param="requestId"/></fmt:param>
              </fmt:message>
            </p>
          </div>
        </dsp:oparam>

        <dsp:oparam name="output">
          <dsp:setvalue param="return" paramvalue="result"/>

          <%-- Navigation Tabs --%>
          <c:set var="returnDetailsTitle">
            <fmt:message key="myaccount_returnDetail.title"/><fmt:message key="mobile.common.colon"/><dsp:valueof param="returnRequestId"/>
          </c:set>
          <dsp:include page="${mobileStorePrefix}/myaccount/gadgets/myAccountTabBar.jsp">
            <dsp:param name="secondTabLabel" value="${pageTitle}"/>
            <dsp:param name="secondTabURL" value="${mobileStorePrefix}/myaccount/myReturns.jsp"/>
            <dsp:param name="thirdTabLabel" value="${returnDetailsTitle}"/>
            <dsp:param name="highlight" value="third"/>
          </dsp:include>

          <div class="detailsContainer">
            <div class="returnStatus">
              <%-- Display return status --%>
              <div class="label"><fmt:message key="mobile.common.label.status"/><fmt:message key="mobile.common.colon"/>&nbsp;</div>
              <div class="value">
                <dsp:include page="/global/util/returnState.jsp">
                  <dsp:param name="returnRequest" param="return"/>
                </dsp:include>
              </div>

              <%-- Display submission date --%>
              <div class="label"><fmt:message key="mobile.common.label.submitted"/><fmt:message key="mobile.common.colon"/>&nbsp;</div>
              <dsp:getvalueof var="submittedDate" vartype="java.util.Date" param="return.authorizationDate"/>
              <dsp:getvalueof var="dateFormat" bean="LocaleTools.userFormattingLocaleHelper.datePatterns.shortWith4DigitYear"/>
              <div class="value"><fmt:formatDate value="${submittedDate}" pattern="${dateFormat}"/></div>

              <%-- Display related order --%>
              <fmt:message var="viewOrderDetailsTitle" key="myaccount_returnDetail.fromOrder"/>
              <div class="label"><dsp:valueof value="${viewOrderDetailsTitle}"/>&nbsp;</div>
              <dsp:getvalueof var="returnOrderId" param="return.order.id"/>
              <div class="value link">
                <dsp:a page="orderDetail.jsp" title="${viewOrderDetailsTitle}">
                  <dsp:param name="orderId" value="${returnOrderId}"/>
                  <dsp:param name="previousPageTitle" value="${returnDetailsTitle}"/>
                  <dsp:param name="previousPageURL" value="${mobileStorePrefix}/myaccount/returnDetail.jsp?returnRequestId=${returnRequestId}"/>
                  <dsp:valueof value="${returnOrderId}"/>
                </dsp:a>
              </div>

              <%-- Display 'Replacement Order' link, if there is a replacement link --%>
              <dsp:getvalueof var="replacementOrderId" param="return.replacementOrder.id"/>
              <c:if test="${not empty replacementOrderId}">
                <div class="label"><fmt:message key="myaccount_returnDetail.replacementOrder"/>&nbsp;</div>
                <fmt:message var="viewOrderDetailsTitle" key="myaccount_returnDetail.replacementOrder"/>
                <div class="value link">
                  <dsp:a page="orderDetail.jsp" title="${viewOrderDetailsTitle}">
                    <dsp:param name="orderId" value="${replacementOrderId}"/>
                    <dsp:valueof value="${replacementOrderId}"/>
                  </dsp:a>
                </div>
              </c:if>
            </div>

            <%-- 
              Retrieve the price lists locale used for return request. It will be the same as
              the original order pricelist locale. Price list is not saved within order's price info
              so retrieve it from any commerce item's price info.

              We can't use Profile's price list here as already submitted return request can be priced
              with price list different from current profile's price list.
            --%>
            <dsp:getvalueof var="commerceItems" vartype="java.lang.Object" param="returnRequest.order.commerceItems"/>

            <c:if test="${not empty commerceItems}">
              <dsp:getvalueof var="priceListLocale" vartype="java.lang.String" param="returnRequest.order.commerceItems[0].priceInfo.priceList.locale"/>
            </c:if>
            
            <%-- Display all items in the return --%>
            <dsp:include page="gadgets/returnItems.jsp">
              <dsp:param name="return" param="return"/>
              <dsp:param name="priceListLocale" value="${priceListLocale}"/>
              <dsp:param name="mode" value="detail"/>
            </dsp:include>

            <div class="transactionDetails">
              <%-- Display refund payment methods --%>
              <dsp:include page="gadgets/refundMethods.jsp">
                <dsp:param name="return" param="return"/>
                <dsp:param name="priceListLocale" value="${priceListLocale}"/>
              </dsp:include>

              <%-- Refund summary --%>
              <dsp:include page="gadgets/refundSummary.jsp">
                <dsp:param name="return" param="return"/>
                <dsp:param name="hidePromotionalAmendments" value="true"/>
                <dsp:param name="priceListLocale" value="${priceListLocale}"/>
              </dsp:include>

              <%-- "*Adjustments" --%>
              <dsp:include page="gadgets/refundPriceAdjustments.jsp">
                <dsp:param name="return" param="return"/>
              </dsp:include>

              <%-- Original order pricing summary --%>
              <dsp:include page="gadgets/orderPricingSummary.jsp">
                <dsp:param name="order" param="return.order"/>
                <dsp:param name="priceListLocale" value="${priceListLocale}"/>
              </dsp:include>
            </div>
          </div>
        </dsp:oparam>
      </dsp:droplet>
    </jsp:body>
  </crs:mobilePageContainer>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/Storefront/j2ee/store.war/mobile/myaccount/returnDetail.jsp#17 $$Change: 806772 $--%>
