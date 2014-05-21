<%--
  This gadget renders price and promotion adjustments that were a result of a return.

  Required parameters:
    return
      The ReturnReqeust object to display the promotion amendments for

  Optional parameters:
    None
--%>
<dsp:page>
  <dsp:importbean bean="/atg/commerce/promotion/PromotionLookup"/>

  <dsp:getvalueof var="return" param="return"/>
  <dsp:getvalueof var="promotionAdjustments" value="${return.promotionValueAdjustments}"/>

  <c:if test="${not empty promotionAdjustments || return.nonReturnItemSubtotalAdjustment != 0}">
    <details class="roundedBox">
      <summary class="label">
        <fmt:message key="mobile.common.asterisk"/><fmt:message key="mobile.return.label.adjustment"/>
      </summary>

      <div>
        <br/>
        <hr/>

        <%-- If there are non-return item pricing adjustments, display the corresponding message --%>
        <c:if test="${return.nonReturnItemSubtotalAdjustment != 0}">
          <div class="adjustmentsTitle"><fmt:message key="mobile.return.header.pricingAdjustments"/></div>
          <div class="adjustmentsMessage"><fmt:message key="mobile.return.message.pricingAdjustments"/></div>
        </c:if>

        <%-- Display any promotion adjustments caused by the return --%>
        <c:if test="${not empty promotionAdjustments}">
          <div class="adjustmentsTitle"><fmt:message key="mobile.return.header.promotionAdjustments"/></div>
          <div class="adjustmentsMessage"><fmt:message key="mobile.return.message.promotionAdjustments"/></div>
          <c:forEach var="promotionAdjustment" items="${promotionAdjustments}">
            <%-- Lookup promotion item by its ID --%>
            <dsp:droplet name="PromotionLookup">
              <dsp:param name="id" value="${promotionAdjustment.key}"/>
              <dsp:param name="elementName" value="promotion"/>
              <dsp:oparam name="output">
                <p><fmt:message key="mobile.common.hyphen"/>&nbsp;<dsp:valueof param="promotion.description" valueishtml="true"/></p>
              </dsp:oparam>
            </dsp:droplet>
          </c:forEach>
        </c:if>
      </div>
    </details>
  </c:if>
</dsp:page>
