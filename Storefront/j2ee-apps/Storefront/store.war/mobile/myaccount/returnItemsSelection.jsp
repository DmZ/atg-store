<%--
  Return items selection page. This page lists all items in the order and allows to select any returnable items
  to include into a return request. Provides both individual items return and the whole order return. The reason
  of the return can be specified for each type of return.
  
  The page doesn't creates return request for the specified order. It is assumed that it has been already
  created before redirecting to this page. If no active return request exists for the given order ID
  an error message is displayed.
  
  Required parameters:
    orderId
      The order ID for which the active return request should be displayed

  NOTES:
    1) The "mobileStorePrefix" request-scoped variable (request attribute), which is used here,
       is defined in the "mobilePageContainer" tag ("mobilePageContainer.tag" file).
       This variable becomes available within the <crs:mobilePageContainer> ... </crs:mobilePageContainer> block
       and in all the included pages (gadgets and Endeca cartridges).
--%>
<dsp:page>
  <dsp:importbean bean="/atg/commerce/custsvc/returns/BaseReturnFormHandler"/>
  <dsp:importbean bean="/atg/commerce/custsvc/returns/IsReturnActive"/>
  <dsp:importbean bean="/atg/dynamo/droplet/ForEach"/>
  <dsp:importbean bean="/atg/commerce/custsvc/returns/IsReturnable"/>
  <dsp:importbean bean="/atg/commerce/order/OrderLookup"/>

  <fmt:message var="pageTitle" key="mobile.return.returnItemsSelection.pageTitle"/>
  <crs:mobilePageContainer titleString="${pageTitle}">
    <jsp:body>
      <dsp:getvalueof var="orderId" param="orderId"/>
      <c:choose>
        <c:when test="${not empty orderId}">
          <dsp:droplet name="OrderLookup">
            <dsp:param name="orderId" param="orderId"/>

            <dsp:oparam name="output">
              <%-- Get currently active return request --%>
              <dsp:droplet name="IsReturnActive">
                <dsp:oparam name="true">
                  <dsp:getvalueof var="returnOrderId" param="returnRequest.order.id"/>
                  <c:choose>
                    <c:when test="${returnOrderId == orderId}">
                      <div class="detailsContainer">
                        <%-- Display "BaseReturnFormHandler" error messages, which were specified in "formException.message" --%>
                        <dsp:include page="${mobileStorePrefix}/global/gadgets/errorMessage.jsp">
                          <dsp:param name="formHandler" bean="BaseReturnFormHandler"/>
                        </dsp:include>

                        <%-- Page header --%>
                        <div class="returnHeader"><fmt:message key="mobile.return.returnItemsSelection.pageHeader"/></div>

                        <c:url var="returnsSelectionPage" value="${mobileStorePrefix}/myaccount/returnItemsSelection.jsp">
                          <c:param name="orderId" value="${orderId}"/>
                        </c:url>
                        <c:url var="orderDetailUrl" value="${mobileStorePrefix}/myaccount/orderDetail.jsp">
                          <c:param name="orderId" value="${orderId}"/>
                        </c:url>

                        <%-- Include form for individual items selection --%>
                        <dsp:form action="${returnsSelectionPage}" formid="orderActions" method="post">
                          <div class="returnItemsContainer">
                            <div class="dataContainer">
                              <ul class="dataList" role="presentation">
                                <li>
                                  <div class="content">
                                    <dsp:input bean="BaseReturnFormHandler.selectAllItems" type="checkbox" id="selectAll"/>
                                    <label for="selectAll" id="selectAllLabel"><fmt:message key="mobile.return.returnAll"/></label>
                                  </div>
                                </li>
                              </ul>

                              <%-- Select control for selecting return reason --%>
                              <fmt:message var="returnReasonLabel" key="mobile.return.selectReturnReason"/>
                              <dsp:select bean="BaseReturnFormHandler.selectAllItemsReturnReason" class="universalReasonSlct hidden">
                                <dsp:option value="">
                                  <fmt:message key="mobile.return.selectReturnReason"/>
                                </dsp:option>

                                <%-- Iterate through all available return reasons --%>
                                <dsp:droplet name="ForEach">
                                  <dsp:param bean="BaseReturnFormHandler.reasonCodes" name="array"/>
                                  <dsp:param name="elementName" value="reasonCode"/>
                                  <dsp:param name="sortProperties" value="+readableDescription"/>
                                  <dsp:oparam name="output">
                                    <dsp:option paramvalue="reasonCode.repositoryId">
                                      <dsp:valueof param="reasonCode.readableDescription"/>
                                    </dsp:option>
                                  </dsp:oparam>
                                </dsp:droplet>
                              </dsp:select>
                          </div>

                          <%-- Iterate through shipping groups of the return request --%>
                          <dsp:getvalueof var="returnShippingGroupList" bean="BaseReturnFormHandler.returnRequest.shippingGroupList"/>
                          <c:forEach var="returnShippingGroup" items="${returnShippingGroupList}" varStatus="shippingGroupListStatus">
                            <c:set var="returnItems" value="${returnShippingGroup.itemList}"/>
                            <c:if test="${not empty returnItems}">
                              <%-- Display shipping group address and shipping method --%>

                              <dsp:include page="gadgets/orderSingleShippingInfo.jsp">
                                <dsp:param name="shippingGroup" value="${returnShippingGroup.shippingGroup}"/>
                              </dsp:include>

                              <div>
                                <%-- Display all return items of the current shipping group --%>

                                <c:set var="returnableItemsCounter" value="0"/>
                                <c:set var="nonReturnableItemsCounter" value="0"/>

                                <%--
                                  Iterate through all return items in the shipping group and display only those that are returnable.
                                  Non-returnable items will be displayed separately.
                                --%>
                                <c:forEach var="returnItem" items="${returnItems}" varStatus="itemsStatus">
                                  <%-- Do not render gift wrap items. They are not returnable --%>
                                  <c:if test="${returnItem.commerceItem.commerceItemClassType != 'giftWrapCommerceItem'}">
                                    <dsp:droplet name="IsReturnable">
                                      <dsp:param name="item" value="${returnItem.commerceItem}"/>
                                      <dsp:oparam name="true">
                                        <c:set var="returnable" value="${true}"/>
                                        <c:set var="returnableItemsCounter" value="${returnableItemsCounter + 1}"/>
                                      </dsp:oparam>
                                      <dsp:oparam name="false">
                                        <c:set var="returnable" value="${false}"/>
                                        <c:set var="nonReturnableItemsCounter" value="${nonReturnableItemsCounter + 1}"/>
                                      </dsp:oparam>
                                    </dsp:droplet>

                                    <c:if test="${returnable}">
                                      <dsp:include page="gadgets/returnReturnableItemRenderer.jsp">
                                        <dsp:param name="returnItem" value="${returnItem}"/>
                                        <dsp:param name="shippingGroupIndex" value="${shippingGroupListStatus.index}"/>
                                        <dsp:param name="itemIndex" value="${itemsStatus.index}"/>
                                      </dsp:include>
                                    </c:if>
                                  </c:if>
                                </c:forEach>
                              </div>
                              <c:if test="${nonReturnableItemsCounter > 0}">
                                <div class="nonReturnableItems">
                                  <%-- 'Non-Returnable' items header --%>
                                  <div class="returnHeader"><fmt:message key="mobile.return.nonReturnableItemsTitle"/></div>
                                  <c:forEach var="returnItem" items="${returnItems}">
                                    <%-- Do not render gift wrap items. They are non-returnable --%>
                                    <c:if test="${returnItem.commerceItem.commerceItemClassType != 'giftWrapCommerceItem'}">
                                      <dsp:droplet name="IsReturnable">
                                        <dsp:param name="item" value="${returnItem.commerceItem}"/>
                                        <dsp:oparam name="true">
                                          <c:set var="returnable" value="${true}"/>
                                        </dsp:oparam>
                                        <dsp:oparam name="false">
                                          <c:set var="returnable" value="${false}"/>
                                          <dsp:getvalueof var="returnableDescription" param="returnableDescription"/>
                                        </dsp:oparam>
                                      </dsp:droplet>

                                      <c:if test="${not returnable}">
                                        <dsp:include page="gadgets/returnNonReturnableItemRenderer.jsp">
                                          <dsp:param name="returnItem" value="${returnItem}"/>
                                          <dsp:param name="returnableDescription" value="${returnableDescription}"/>
                                        </dsp:include>
                                      </c:if>
                                    </c:if>
                                  </c:forEach>
                                </div>
                              </c:if>
                            </c:if>
                          </c:forEach>

                          <%-- Buttons --%>
                          <div class="returnButtonsBlock">
                            <%-- 'Cancel Return' handler success/error URLs --%>
                            <dsp:input bean="BaseReturnFormHandler.cancelReturnRequestSuccessURL" type="hidden" value="${orderDetailUrl}"/>
                            <dsp:input bean="BaseReturnFormHandler.cancelReturnRequestErrorURL" type="hidden" value="${returnsSelectionPage}"/>

                            <%-- 'Cancel Return' submit button --%>
                            <fmt:message var="cancelReturnText" key="mobile.return.confirmReturn.button.cancel"/>
                            <dsp:input bean="BaseReturnFormHandler.cancelReturnRequest" type="submit" id="cancelBtn" class="cancelButton" value="${cancelReturnText}"/>

                            <%-- 'Continue' handler success/error URLs --%>
                            <dsp:input bean="BaseReturnFormHandler.selectItemsSuccessURL" type="hidden" value="${pageContext.request.contextPath}/myaccount/confirmReturn.jsp"/>
                            <dsp:input bean="BaseReturnFormHandler.selectItemsErrorURL" type="hidden" value="${returnsSelectionPage}"/>

                            <%-- 'Continue' submit button --%>
                            <fmt:message var="continueReturnText" key="mobile.common.button.continue"/>
                            <dsp:input type="submit" bean="BaseReturnFormHandler.selectItems" id="continueBtn" class="mainActionButton" value="${continueReturnText}"/>
                          </div>
                        </dsp:form>
                      </div>

                      <script>
                        $(function() {
                          CRSMA.returns.init();
                        });
                      </script>
                    </c:when>
                    <c:otherwise>
                      <%--
                        The currently active return is not for the same order ID as specified in the page's
                        parameter. This can happen if user goes to this page bypassing normal navigation from
                        order detail page or for some other error. Display error message.
                      --%>
                      <div class="infoHeader">
                        <fmt:message key="myaccount_returnItemsSelect_noActiveReturnError"/>
                      </div>
                    </c:otherwise>
                  </c:choose>
                </dsp:oparam>

                <dsp:oparam name="false">
                  <%-- No active return request is found. Display an error message --%>
                  <div class="infoHeader">
                    <fmt:message key="myaccount_returnItemsSelect_noActiveReturnError"/>
                  </div>
                </dsp:oparam>
              </dsp:droplet>
            </dsp:oparam>

            <dsp:oparam name="error">
              <%-- No order found for the specified ID --%>
              <div class="infoHeader">
                <fmt:message key="mobile.return.noOrderId.error">
                  <fmt:param><dsp:valueof param="orderId"/></fmt:param>
                </fmt:message>
              </div>
            </dsp:oparam>
          </dsp:droplet>
        </c:when>
        <c:otherwise>
          <%-- No order ID is specified for the page --%>
          <div class="infoHeader">
            <fmt:message key="myaccount_returnItemsSelect_noOrderIdError">
              <fmt:param><dsp:valueof param="orderId"/></fmt:param>
            </fmt:message>
          </div>
        </c:otherwise>
      </c:choose>
    </jsp:body>
  </crs:mobilePageContainer>
</dsp:page>
