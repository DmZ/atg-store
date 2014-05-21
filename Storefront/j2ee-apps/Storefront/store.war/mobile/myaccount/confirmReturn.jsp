<%--
  A "Return Confirmation" page for the return request.
  This page lists all items selected for the return and includes action buttons Cancel/Modify/Submit.

  Page includes:
    /mobile/global/gadgets/errorMessage.jsp - Displays all errors collected from FormHandler
    /mobile/myaccount/gadgets/returnItems.jsp - Renders the list of the items to return
    /mobile/myaccount/gadgets/refundSummary.jsp - Displays refund information Summary
    /mobile/myaccount/gadgets/refundMethods.jsp - Displays refund payment methods

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
  <dsp:importbean bean="/atg/commerce/custsvc/returns/BaseReturnFormHandler"/>
  <dsp:importbean bean="/atg/commerce/custsvc/returns/IsReturnActive"/>

  <fmt:message var="pageTitle" key="mobile.return.confirmReturn.pageTitle"/>
  <crs:mobilePageContainer titleString="${pageTitle}">
    <jsp:body>
      <div class="detailsContainer">
        <%-- Display "BaseReturnFormHandler" error messages, which were specified in "formException.message" --%>
        <dsp:include page="${mobileStorePrefix}/global/gadgets/errorMessage.jsp">
          <dsp:param name="formHandler" bean="BaseReturnFormHandler"/>
        </dsp:include>

        <%-- Get currently active return request --%>
        <dsp:droplet name="IsReturnActive">
          <dsp:oparam name="true">
            <dsp:getvalueof var="returnOrderId" param="returnRequest.order.id"/>

            <dsp:getvalueof var="commerceItems" vartype="java.lang.Object" param="returnRequest.order.commerceItems"/>
            <c:if test="${not empty commerceItems}">
              <dsp:getvalueof var="priceListLocale" vartype="java.lang.String" param="returnRequest.order.commerceItems[0].priceInfo.priceList.locale"/>
            </c:if>

            <%-- Header --%>
            <div class="returnHeader"><c:out value="${pageTitle}"/></div>

            <%-- Return items --%>
            <dsp:include page="gadgets/returnItems.jsp">
              <dsp:param name="activeReturn" value="true"/>
              <dsp:param name="return" param="returnRequest"/>
              <dsp:param name="priceListLocale" value="${priceListLocale}"/>
              <dsp:param name="mode" value="confirm"/>
            </dsp:include>

            <c:url var="orderDetailUrl" value="${mobileStorePrefix}/myaccount/orderDetail.jsp">
              <c:param name="orderId" value="${returnOrderId}"/>
            </c:url>
            <c:url var="returnsSelectionUrl" value="${mobileStorePrefix}/myaccount/returnItemsSelection.jsp">
              <c:param name="orderId" value="${returnOrderId}"/>
            </c:url>
            <c:url var="confirmReturnResponseUrl" value="${mobileStorePrefix}/myaccount/confirmReturnResponse.jsp"/>

            <%-- Cancel/Modify/Submit buttons --%>
            <div class="returnButtonsBlock">
              <%-- "Cancel" --%>
              <div>
                <dsp:form action="${orderDetailUrl}" id="cancelOrder" formid="cancelOrder" method="post">
                  <%-- Specify form handler's success and error URLs --%>
                  <dsp:input bean="BaseReturnFormHandler.cancelReturnRequestSuccessURL" type="hidden"
                             value="${orderDetailUrl}"/>
                  <dsp:input bean="BaseReturnFormHandler.cancelReturnRequestErrorURL" type="hidden"
                             value="${returnsSelectionUrl}"/>
                  <fmt:message var="txtCancel" key="mobile.return.confirmReturn.button.cancel"/>
                  <dsp:input bean="BaseReturnFormHandler.cancelReturnRequest" class="cancelButton" type="submit" value="${txtCancel}"/>
                </dsp:form>
              </div>
              <%-- "Modify" --%>
              <div>
                <fmt:message var="txtModify" key="mobile.return.confirmReturn.button.modify"/>
                <input type="submit" value="${txtModify}" class="greyButton" onclick="document.location = '${returnsSelectionUrl}';"/>
              </div>
              <%-- "Submit" --%>
              <div>
                <dsp:form action="${confirmReturnResponseUrl}" id="submitReturn" formid="submitReturn" method="post">
                  <%-- Specify form handler success and error URLs --%>
                  <dsp:input bean="BaseReturnFormHandler.confirmReturnSuccessURL" type="hidden"
                             value="${confirmReturnResponseUrl}"/>
                  <dsp:input bean="BaseReturnFormHandler.confirmReturnErrorURL" type="hidden"
                             value="${pageContext.request.requestURI}"/>
                  <fmt:message var="txtSubmit" key="mobile.common.button.submit"/>
                  <dsp:input bean="BaseReturnFormHandler.confirmReturn" class="mainActionButton" type="submit" value="${txtSubmit}"/>
                </dsp:form>
              </div>
            </div>

            <div class="transactionDetails">
              <%-- "Refund Summary" --%>
              <dsp:include page="gadgets/refundSummary.jsp">
                <dsp:param name="return" param="returnRequest"/>
                <dsp:param name="hidePromotionalAmendments" value="true"/>
                <dsp:param name="priceListLocale" value="${priceListLocale}"/>
              </dsp:include>

              <%-- "*Adjustments" --%>
              <dsp:include page="gadgets/refundPriceAdjustments.jsp">
                <dsp:param name="return" param="returnRequest"/>
              </dsp:include>

              <%-- "Apply Refund To" / "Store Credits" --%>
              <dsp:include page="gadgets/refundMethods.jsp">
                <dsp:param name="return" param="returnRequest"/>
                <dsp:param name="priceListLocale" value="${priceListLocale}"/>
              </dsp:include>
            </div>
          </dsp:oparam>

          <dsp:oparam name="false">
            <%-- No active return request is found. Display error message --%>
            <div class="infoHeader">${pageTitle}</div>
            <div class="infoContent">
              <p>
                <fmt:message key="mobile.return.confirmReturn.noActiveReturn.error"/>
              </p>
            </div>
          </dsp:oparam>
        </dsp:droplet>
      </div>
    </jsp:body>
  </crs:mobilePageContainer>
</dsp:page>
