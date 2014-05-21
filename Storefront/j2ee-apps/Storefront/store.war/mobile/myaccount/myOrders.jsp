<%--
  This page renders "My Orders" page.

  Page includes:
    /mobile/myaccount/gadgets/myAccountTabBar.jsp - Display tab bar for the page
    /mobile/global/gadgets/obtainHardgoodShippingGroup.jsp - Returns the following request-scoped variables:
      - hardgoodShippingGroups counter
      - hardgoodShippingGroup object
      - giftWrapCommerceItem
    /global/util/orderState.jsp - Display order state
    /mobile/includes/crsRedirect.jspf - Renderer of the redirect prompt to the full CRS site

  Required parameters:
    None

  Optional parameters:
    redirectOrderId
      When not empty, "Redirect to the full CRS site" dialog appears
    hideOrderList
      When true, order list is hidden during the redirect dialog appeared. Used from confirm page
    redirectUrl
      Used in the modal dialog as redirection to the "full CRS" site link.
      If not defined, the redirection link points to the "full CRS" order detail page.
      Should not to contain the "orderId" parameter, use the "redirectOrderId" instead

  NOTES:
    1) The "mobileStorePrefix" request-scoped variable (request attribute), which is used here,
       is defined in the "mobilePageContainer" tag ("mobilePageContainer.tag" file).
       This variable becomes available within the <crs:mobilePageContainer> ... </crs:mobilePageContainer> block
       and in all the included pages (gadgets and Endeca cartridges).
--%>
<dsp:page>
  <dsp:importbean bean="/atg/commerce/order/OrderLookup"/>
  <dsp:importbean bean="/atg/dynamo/droplet/multisite/GetSiteDroplet"/>
  <dsp:importbean bean="/atg/userprofiling/Profile"/>
  <dsp:importbean bean="/atg/core/i18n/LocaleTools"/>

  <%-- Request parameters - to variables --%>
  <dsp:getvalueof var="redirectOrderId" param="redirectOrderId"/>
  <dsp:getvalueof var="hideOrderList" param="hideOrderList"/>

  <fmt:message var="pageTitle" key="mobile.myAccount.tab.myOrders"/>
  <crs:mobilePageContainer titleString="${pageTitle}" displayModal="${empty redirectOrderId ? false : true}">
    <jsp:attribute name="modalContent">
      <%--
        If "redirectOrderId" is not empty then this page accessed from the "orderDetail.jsp" or
        from the "confirm.jsp" pages with order that does not supported in the mobile CRS.
        Order with multishipping group or with gift items handling and dialog template.
        Redirect dialog for full CRS.
      --%>
      <div id="modalMessageBox" ${empty redirectOrderId ? '' : 'style="display:block"'}>
        <div>
          <dsp:getvalueof param="redirectUrl" var="successURL"/>
          <c:if test="${empty successURL}">
            <c:set var="successURL" value="/myaccount/orderDetail.jsp"/>
          </c:if>
          <fmt:message var="topString" key="mobile.myAccount.message.multishipping"/>
          <fmt:message var="bottomString" key="mobile.myAccount.button.redirect"/>
          <dsp:getvalueof var="orderId" param="orderId"/>
          <%@include file="/mobile/includes/crsRedirect.jspf"%>
        </div>
      </div>
    </jsp:attribute>

    <jsp:body>
      <%-- ========== Navigation Tabs ========== --%>
      <dsp:include page="./gadgets/myAccountTabBar.jsp">
        <dsp:param name="secondTabLabel" value="${pageTitle}"/>
        <dsp:param name="highlight" value="second"/>
      </dsp:include>

      <dsp:droplet name="OrderLookup">
        <dsp:param name="userId" bean="Profile.id"/>
        <dsp:param name="sortBy" value="submittedDate"/>
        <dsp:param name="state" value="closed"/>
        <dsp:param name="numOrders" value="-1"/>
        <dsp:oparam name="output">
          <dsp:getvalueof var="orders" param="result"/>
          <div class="dataContainer">
            <div class="my_orders">
              <%-- ========== Form ========== --%>
              <form id="loadOrderDetailForm" action="orderDetail.jsp">
                <%-- This request parameter is used by "Redirect to the full CRS site" dialog (see above) --%>
                <input type="hidden" name="orderId" id="orderId"/>
                <ul class="dataList">
                  <c:forEach items="${orders}" var="order">
                    <dsp:include page="${mobileStorePrefix}/global/gadgets/obtainHardgoodShippingGroup.jsp">
                      <dsp:param name="order" value="${order}"/>
                    </dsp:include>

                    <c:set var="orderId">
                      <c:choose>
                        <c:when test="${not empty order.omsOrderId}">
                          <c:out value="${order.omsOrderId}"/>
                        </c:when>
                        <c:otherwise>
                          <c:out value="${order.id}"/>
                        </c:otherwise>
                      </c:choose>
                    </c:set>
                    <li>
                      <a href="javascript:void(0)" onclick="CRSMA.myaccount.loadOrderDetails('${order.id}');" class="icon-ArrowRight">
                        <div class="content">
                          <%-- "Order ID" column --%>
                          <div class="orderId">
                            <%-- Add invisible text to enhance VoiceOver experience --%>
                            <span class="invisible"><fmt:message key="mobile.order.a11y.orderNumber"/></span>
                            <c:out value="${orderId}"/>
                          </div>
                          <div class="myHistoryList_Row">
                            <%-- "Items" --%>
                            <div class="myHistoryList_Subrow">
                              <div class="myHistoryList_Legend"><fmt:message key="mobile.common.items"/></div>
                              <div class="myHistoryList_Data">
                                <dsp:getvalueof var="totalItems" vartype="java.lang.Long" value="${order.originalTotalItemsCount}"/>
                                <dsp:getvalueof var="containsWrap" vartype="java.lang.Boolean" value="${order.containsGiftWrap}"/>
                                <c:if test="${containsWrap}">
                                  <c:set var="totalItems" value="${totalItems - 1}"/>
                                </c:if>
                                <c:out value="${totalItems}"/>
                              </div>
                            </div>
                            <%-- "Submitted Date" --%>
                            <div class="myHistoryList_Subrow">
                              <div class="myHistoryList_Legend"><fmt:message key="mobile.common.label.submitted"/></div>
                              <div class="myHistoryList_Data">
                                <dsp:getvalueof var="submittedDate" vartype="java.util.Date" value="${order.submittedDate}"/>
                                <dsp:getvalueof var="dateFormat" bean="LocaleTools.userFormattingLocaleHelper.datePatterns.shortWith4DigitYear"/>
                                <fmt:formatDate value="${order.submittedDate}" pattern="${dateFormat}"/>
                              </div>
                            </div>
                            <%-- "Site" --%>
                            <div class="myHistoryList_Subrow">
                              <div class="myHistoryList_Legend"><fmt:message key="mobile.common.label.site"/></div>
                              <div class="myHistoryList_Data">
                                <dsp:droplet name="GetSiteDroplet">
                                  <dsp:param name="siteId" value="${order.siteId}"/>
                                  <dsp:oparam name="output">
                                    <dsp:valueof param="site.name"/>
                                  </dsp:oparam>
                                </dsp:droplet>
                              </div>
                            </div>
                            <%-- "Status" --%>
                            <div class="myHistoryList_Subrow">
                              <div class="myHistoryList_Legend"><fmt:message key="mobile.common.label.status"/></div>
                              <div class="myHistoryList_Data">
                                <dsp:include page="/global/util/orderState.jsp">
                                  <dsp:param name="order" value="${order}"/>
                                </dsp:include>
                              </div>
                            </div>
                          </div>
                        </div>
                      </a>
                    </li>
                  </c:forEach>
                </ul>
              </form>
            </div>
          </div>

          <%-- Hide order list when the "hideOrderList" is set. See also "confirm.jsp" page --%>
          <c:if test="${hideOrderList}">
            <script>
              $(document).ready(function() {
                $("div.my_orders").hide();
                $("#modalOverlay").bind("click", function() {
                  $("div.my_orders").show();
                });
              });
            </script>
          </c:if>
        </dsp:oparam>

        <dsp:oparam name="empty">
          <%-- Display message if user does not have any orders --%>
          <div class="infoHeader"><fmt:message key="mobile.order.message.noOrders"/></div>
        </dsp:oparam>
      </dsp:droplet>
    </jsp:body>
  </crs:mobilePageContainer>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/Storefront/j2ee/store.war/mobile/myaccount/myOrders.jsp#15 $$Change: 805471 $--%>
