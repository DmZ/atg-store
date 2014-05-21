<%--
  This page renders order returns, exchanges and original order id information.

  Required parameters:
    order
      The the current order

  NOTES:
    1) The "mobileStorePrefix" request-scoped variable (request attribute), which is used here,
       is defined in the "mobilePageContainer" tag ("mobilePageContainer.tag" file).
       This variable becomes available within the <crs:mobilePageContainer> ... </crs:mobilePageContainer> block
       and in all the included pages (gadgets and Endeca cartridges).
--%>
<dsp:page>
  <dsp:importbean bean="/atg/commerce/custsvc/returns/BaseReturnFormHandler"/>
  <dsp:importbean bean="/atg/commerce/custsvc/returns/IsReturnActive"/>
  <dsp:importbean bean="/atg/commerce/custsvc/returns/IsReturnable"/>
  <dsp:importbean bean="/atg/commerce/custsvc/returns/ReturnDroplet"/>
  <dsp:importbean bean="/atg/dynamo/droplet/multisite/SitesShareShareableDroplet"/>
  <dsp:importbean bean="/atg/dynamo/droplet/ForEach"/>
  <dsp:importbean bean="/atg/store/droplet/ProfileSecurityStatus"/>
  <dsp:importbean bean="/atg/core/i18n/LocaleTools"/>
  <dsp:importbean bean="/atg/commerce/order/OrderLookup"/>

  <%-- Do not display return button and returns links for anonymous user --%>
  <c:set var="anonymousUser" value="${false}"/>
  <dsp:droplet name="ProfileSecurityStatus">
    <dsp:oparam name="anonymous">
      <c:set var="anonymousUser" value="${true}"/>
    </dsp:oparam>
  </dsp:droplet>

  <%-- formatting for dates --%>
  <dsp:getvalueof var="dateFormatPattern"
                  bean="LocaleTools.userFormattingLocaleHelper.datePatterns.shortWith4DigitYear"/>

  <c:if test="${not anonymousUser}">
  <div class="orderDetailReturnsContainer">
    <%--
     This droplet returns the returns & exchanges associated with a given order.

     Input params:
       orderId
         The order id.
       searchByReplacementId
         Indicates if search should be done for replacement id as well.

     Open Parameters:
       output
         Rendered once if there are Returns & Exchanges associated with a given order found.

     Output parameters:
       result
         An array of returns & exchanges.
    --%>
    <dsp:droplet name="ReturnDroplet">
      <dsp:param name="orderId" param="order.id"/>
      <dsp:param name="resultName" value="relatedReturnRequests"/>
      <dsp:param name="searchByReplacementId" value="true"/>
      <dsp:oparam name="output">
        <dsp:getvalueof var="relatedReturnRequests" param="relatedReturnRequests"/>
        <dsp:getvalueof var="currentOrderId" param="orderId"/>

        <%-- Render links to the Returns originating from the current order --%>
        <c:set var="titleShown" value="${false}"/>
        <dsp:droplet name="ForEach" array="${relatedReturnRequests}" elementName="return">
          <dsp:oparam name="output">
            <dsp:getvalueof var="return" param="return"/>

            <%-- Display only returns that originate from the current order --%>
            <c:if test="${return.order.id == currentOrderId}">
              <c:if test="${!titleShown}">
                <div class="label">
                  <fmt:message key="mobile.order.label.returnsFromThisOrder"/><fmt:message key="mobile.common.colon"/>&nbsp;
                </div>
              </c:if>

              <div class="value">
                <c:if test="${titleShown}">,</c:if>
                <dsp:a page="${mobileStorePrefix}/myaccount/returnDetail.jsp">
                  <dsp:param name="returnRequestId" value="${return.repositoryId}"/>
                    <c:out value="${return.repositoryId}"/> (<fmt:formatDate value="${return.createdDate}"
                                                                             pattern="${dateFormatPattern}"/>)
                </dsp:a>
              </div>
              <c:set var="titleShown" value="${true}"/>
            </c:if>
          </dsp:oparam>
        </dsp:droplet>

        <%-- Render links to the Exchange orders originating from the current order --%>
        <c:set var="titleShown" value="${false}"/>
        <%-- Iterate over the relatedReturnRequests and display "Exchanges from this order:" links --%>
        <dsp:droplet name="ForEach" array="${relatedReturnRequests}" elementName="return">
          <dsp:oparam name="output">
            <dsp:getvalueof var="replacementOrderId" param="return.replacementOrderId"/>
            <%-- If replacement order id exist and if it dosn't equal current order id generate link --%>
            <c:if test="${not empty replacementOrderId}">
              <%--
               It's a return request that is a part of an exchange. Check whether the associated exchange
               is made from the current order or current order itself is exchange. If replacementOrderId
               of the return reqeust is not the same as the current order ID then we are dealing with the
               exchange from the current order.
              --%>
              <c:choose>
                <c:when test="${currentOrderId != replacementOrderId}">
                  <%--
                   It's a return request that is a result of the exchange from the current order. Display a link
                   to the corresponding exchange order.
                  --%>
                  <c:if test="${!titleShown}">
                    <div class="label">
                      <fmt:message key="mobile.order.label.exchangesFromThisOrder"/><fmt:message key="mobile.common.colon"/>&nbsp;
                    </div>
                  </c:if>

                  <%-- lookup the exchange order to get the submitted date --%>
                  <dsp:droplet name="OrderLookup">
                    <dsp:param name="orderId" param="orderId"/>
                    <dsp:oparam name="output">
                      <dsp:getvalueof var="exchangeOrderDate" param="result.submittedDate"/>
                    </dsp:oparam>
                  </dsp:droplet>

                  <div class="value">
                    <c:if test="${titleShown}">,</c:if>
                    <dsp:a page="${mobileStorePrefix}/myaccount/orderDetail.jsp">
                      <dsp:param name="orderId" value="${replacementOrderId}"/>
                        <c:out value="${replacementOrderId}"/> (<fmt:formatDate value="${exchangeOrderDate}"
                                                                 pattern="${dateFormatPattern}"/>)
                    </dsp:a>
                  </div>

                  <c:set var="titleShown" value="${true}"/>
                </c:when>
                <c:otherwise>
                  <%--
                    The current order is an exchange order itself. Store the id of the original order
                    to display the link to the original order later on the page.
                  --%>
                  <dsp:getvalueof var="originalOrderId" param="return.order.id"/>
                </c:otherwise>
              </c:choose>
            </c:if>
          </dsp:oparam>
        </dsp:droplet>
        <%-- End of ForEach droplet --%>

        <%--
         If this is an exchange order, there will be an original order Id (aka parent order) so display that too.
        --%>
        <c:if test="${not empty originalOrderId}">
          <div class="label">
            <fmt:message key="mobile.order.label.parentOrder"/><fmt:message key="mobile.common.colon"/>&nbsp;
          </div>

          <%-- lookup the original order to get the submitted date --%>
          <dsp:droplet name="OrderLookup">
            <dsp:param name="orderId" value="${originalOrderId}"/>
            <dsp:oparam name="output">
              <dsp:getvalueof var="originalOrderDate" param="result.submittedDate"/>
            </dsp:oparam>
          </dsp:droplet>

          <div class="value">
            <dsp:a page="${mobileStorePrefix}/myaccount/orderDetail.jsp">
              <dsp:param name="orderId" value="${originalOrderId}"/>
                <c:out value="${originalOrderId}"/> (<fmt:formatDate value="${originalOrderDate}"
                                                         pattern="${dateFormatPattern}"/>)
            </dsp:a>
          </div>
        </c:if>
      </dsp:oparam>
    </dsp:droplet>
    <%-- End of ReturnDroplet --%>

    <%--
      RETURN BUTTON DISPLAY/ACTION
    --
    <%--
     Droplet tests if 2 sites share a ShareableType. The site ids are set
     with the siteId and otherSiteId parameters. If the siteId isn't provided,
     the current site will be used. The ShareableType can be specified by the
     shareableTypeId parameter.

     Input parameters:
       otherSiteId
         The side id to test
       shareableTypeId
         The shareable type

     Open Parameters:
       true
         This parameter is rendered once if the sites share the shareable.
       false
         This parameter is rendered once if the sites do not share the shareable
    --%>
    <dsp:droplet name="SitesShareShareableDroplet">
      <dsp:param name="shareableTypeId" value="atg.ShoppingCart"/>
      <dsp:param name="otherSiteId" param="order.siteId"/>
      <dsp:oparam name="true">
        <%--
          This droplet determines if a given order or commerce item is returnable.

          Input params:
            order
              Order object or order repository item.

          Open Parameters:
            true
              This parameter is rendered once if item is returnable.
            false
              This parameter is rendered once if item is not returnable.
        --%>
        <dsp:droplet name="IsReturnable">
          <dsp:param name="order" param="order"/>
          <dsp:oparam name="true">
            <dsp:getvalueof var="returnExist" value="false"/>
            <%-- Get currently active return request --%>
            <dsp:droplet name="IsReturnActive">
              <dsp:oparam name="true">
                <dsp:getvalueof var="returnOrderId" param="returnRequest.order.id"/>
                <dsp:getvalueof var="currentOrderId" param="order.id"/>
                <%-- If active return exist and belong to current order set returnExist to true --%>
                <c:if test="${currentOrderId eq returnOrderId}">
                  <dsp:getvalueof var="returnExist" value="true"/>
                </c:if>
              </dsp:oparam>
            </dsp:droplet>

            <fmt:message var="returnItemsButtonTitle" key="mobile.return.button.startReturn"/>
            <div class="returnItemsButtonContainer">
              <c:choose>
                <%-- If active return to this order exist just redirect to returnItemsSelection page --%>
                <c:when test="${returnExist}">
                  <dsp:getvalueof var="orderId" param="order.id"/>
                  <c:url var="startReturnUrl" value="${mobileStorePrefix}/myaccount/returnItemsSelection.jsp">
                    <c:param name="orderId" value="${orderId}"/>
                  </c:url>
                  <input type="button" value="${returnItemsButtonTitle}" class="mainActionButton"
                         onclick="document.location='${startReturnUrl}'; return false;"/>
                </c:when>
                <%-- If no active return to this order exist create it and redirect to returnItemsSelection page --%>
                <c:otherwise>
                  <%-- "Return Items" --%>
                  <dsp:form action="${pageContext.request.requestURI}" method="post">
                    <dsp:input type="hidden" bean="BaseReturnFormHandler.createReturnRequestSuccessURL"
                               value="${pageContext.request.contextPath}/myaccount/returnItemsSelection.jsp?orderId=${param.orderId}"/>
                    <dsp:input type="hidden" bean="BaseReturnFormHandler.createReturnRequestErrorURL"
                               value="${pageContext.request.requestURI}?orderId=${param.orderId}"/>
                    <dsp:input type="hidden" bean="BaseReturnFormHandler.returnOrderId"
                               paramvalue="orderId"/>
                    <dsp:input type="submit" bean="BaseReturnFormHandler.createReturnRequest"
                               value="${returnItemsButtonTitle}" class="mainActionButton"/>
                  </dsp:form>
                </c:otherwise>
              </c:choose>
            </div>
          </dsp:oparam>

          <dsp:oparam name="false">
            <%-- Display the message with returnable state description --%>
            <div class="returnItemsButtonContainer">
              <dsp:valueof param="returnableDescription"/>
            </div>
          </dsp:oparam>
        </dsp:droplet>
      </dsp:oparam>

      <dsp:oparam name="false">
        <%-- The order cant be returned on this site. Display the corresponding message --%>
        <div class="value"><fmt:message key="mobile.return.notReturnableReason.invalidSite"/></div>
      </dsp:oparam>
    </dsp:droplet>
  </div>
  </c:if>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/Storefront/j2ee/store.war/mobile/myaccount/gadgets/orderDetailReturns.jsp#14 $$Change: 814465 $--%>
