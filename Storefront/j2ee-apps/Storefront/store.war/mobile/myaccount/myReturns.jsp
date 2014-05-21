<%--
  This page displays list of returns available for the current profile.

  Page includes:
    /mobile/myaccount/gadgets/myAccountTabBar.jsp - Display tab bar for the page
    /global/util/returnState.jsp - Display return state
--%>
<dsp:page>
  <dsp:importbean bean="/atg/commerce/custsvc/returns/ReturnRequestLookup"/>
  <dsp:importbean bean="/atg/core/i18n/LocaleTools"/>
  <dsp:importbean bean="/atg/dynamo/droplet/multisite/GetSiteDroplet"/>
  <dsp:importbean bean="/atg/userprofiling/Profile"/>

  <fmt:message var="pageTitle" key="mobile.myAccount.tab.myReturns"/>
  <crs:mobilePageContainer titleString="${pageTitle}">
    <jsp:body>
      <%-- ========== Navigation Tabs ========== --%>
      <dsp:include page="./gadgets/myAccountTabBar.jsp">
        <dsp:param name="secondTabLabel" value="${pageTitle}"/>
        <dsp:param name="highlight" value="second"/>
      </dsp:include>

      <%--
        Retrieve return requests for the Profile.

        Input parameters:
          userId
            Profile ID
          sortBy
            Property to sort by, we pass in 'createdDate' to sort returns by date
          numReturnRequests
            Number of return requests to return. Value of -1 correspond to showing all returns

        Output parameters:
          result
            Array of return request objects
      --%>
      <dsp:droplet name="ReturnRequestLookup">
        <dsp:param name="userId" bean="Profile.id"/>
        <dsp:param name="sortBy" value="createdDate"/>
        <dsp:param name="numReturnRequests" value="-1"/>
        <dsp:param name="startIndex" value="0"/>

        <dsp:oparam name="output">
          <dsp:getvalueof var="returns" param="result"/>
          <div class="dataContainer">
            <ul class="dataList">
              <c:forEach items="${returns}" var="return">
                <dsp:param name="returnRequest" value="${return}"/>
                <li>
                  <dsp:a page="returnDetail.jsp" class="icon-ArrowRight">
                    <dsp:param name="returnRequestId" param="returnRequest.requestId"/>
                    <div class="content">
                      <%-- "Return ID" column --%>
                      <div class="orderId">
                        <%-- Add invisible text to enhance VoiceOver experience --%>
                        <span class="invisible"><fmt:message key="mobile.return.a11y.returnNumber"/></span>
                        <%-- Display the return ID --%>
                        <dsp:valueof param="returnRequest.requestId"/>
                      </div>
                      <div class="myHistoryList_Row">
                        <%-- "Items" --%>
                        <div class="myHistoryList_Subrow">
                          <div class="myHistoryList_Legend"><fmt:message key="mobile.common.items"/></div>
                          <div class="myHistoryList_Data">
                            <%-- Returned count --%>
                            <dsp:getvalueof var="returnItemsCount" vartype="java.lang.Long" scope="page" param="returnRequest.returnItemCount"/>
                            <c:if test="${returnItemsCount > 0}">
                              <c:out value="${returnItemsCount}"/>&nbsp;<fmt:message key="common.returned"/>
                            </c:if>
                            <br/>

                            <%-- Exchanged count --%>
                            <dsp:getvalueof var="replacementOrderId" param="returnRequest.replacementOrder.id"/>
                            <c:if test="${not empty replacementOrderId}">
                              <dsp:getvalueof var="totalItems" vartype="java.lang.Long" scope="page"
                                            param="returnRequest.replacementOrder.originalTotalItemsCount"/>
                               <dsp:getvalueof var="containsWrap" vartype="java.lang.Boolean" scope="page"
                                            param="returnRequest.replacementOrder.containsGiftWrap"/>
                              <c:if test="${containsWrap}">
                                <c:set var="totalItems" value="${totalItems - 1}"/>
                              </c:if>
                              <c:out value="${totalItems}"/>&nbsp;<fmt:message key="common.exchanged"/>
                            </c:if>
                          </div>
                        </div>
                        <%-- "Submitted Date" --%>
                        <div class="myHistoryList_Subrow">
                          <div class="myHistoryList_Legend"><fmt:message key="mobile.common.label.submitted"/></div>
                          <div class="myHistoryList_Data">
                            <dsp:getvalueof var="submittedDate" vartype="java.util.Date" param="returnRequest.authorizationDate"/>
                            <dsp:getvalueof var="dateFormat" bean="LocaleTools.userFormattingLocaleHelper.datePatterns.shortWith4DigitYear"/>
                            <fmt:formatDate value="${submittedDate}" pattern="${dateFormat}"/>
                          </div>
                        </div>
                        <%-- "Site" --%>
                        <div class="myHistoryList_Subrow">
                          <div class="myHistoryList_Legend"><fmt:message key="mobile.common.label.site"/></div>
                          <div class="myHistoryList_Data">
                            <dsp:droplet name="GetSiteDroplet">
                              <dsp:param name="siteId" param="returnRequest.order.siteId"/>
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
                            <dsp:include page="/global/util/returnState.jsp">
                              <dsp:param name="returnRequest" param="returnRequest"/>
                            </dsp:include>
                          </div>
                        </div>
                      </div>
                    </div>
                  </dsp:a>
                </li>
              </c:forEach>
            </ul>
          </div>
        </dsp:oparam>

        <dsp:oparam name="empty">
          <%-- Display message if user does not have any returns --%>
          <div class="infoHeader"><fmt:message key="mobile.return.message.noReturns"/></div>
        </dsp:oparam>
      </dsp:droplet>
    </jsp:body>
  </crs:mobilePageContainer>
</dsp:page>
