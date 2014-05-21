<%--
  This gadget renders refund summary for the specified return request.
  
  Page includes:
    /global/gadgets/formattedPrice.jsp - Price formatter
  
  Required parameters:
    return
      The ReturnReqeust object to display refund summary for.
      
  Optional parameters:
    isActiveReturn
      Boolean indicating whether the return request is currently active.
    priceListLocale
      Specifies a locale in which to format the price (as string).
      If not specified, locale will be taken from profile price list (Profile.priceList.locale). 
--%>
<dsp:page>
  <%-- Request parameters - to variables --%>
  <dsp:getvalueof var="return" param="return"/>
  <dsp:getvalueof var="isActiveReturn" param="isActiveReturn"/>

  <%-- Display Refund Summary header --%>
  <div class="sectionHeader"><fmt:message key="mobile.return.header.refundSummary"/></div>

  <div class="roundedBox">
    <%-- Display refund of return items --%>
    <div class="label"><fmt:message key="mobile.return.label.refundItems"/></div>
    <div class="value">
      <dsp:include page="/global/gadgets/formattedPrice.jsp">
        <dsp:param name="price" value="${return.totalReturnItemRefund}"/>
        <dsp:param name="priceListLocale" param="priceListLocale"/>
      </dsp:include>
    </div>

    <hr/>

    <%-- Display total of non-return items adjustments, only if there is indeed adjustemnts --%>
    <dsp:getvalueof var="promotionAdjustments" value="${return.promotionValueAdjustments}"/>
    <c:if test="${not empty promotionAdjustments || return.nonReturnItemSubtotalAdjustment != 0}">
      <div class="label"><fmt:message key="mobile.return.label.adjustment"/><fmt:message key="mobile.common.asterisk"/></div>
      <div class="value">
        <dsp:getvalueof var="nonReturnItemsAdjustments" value="${return.nonReturnItemSubtotalAdjustment}"/>
        <dsp:include page="/global/gadgets/formattedPrice.jsp">
          <dsp:param name="price" value="${nonReturnItemsAdjustments}"/>
          <dsp:param name="priceListLocale" param="priceListLocale"/>
        </dsp:include>
      </div>
      <hr/>
    </c:if>

    <%-- Display shipping refund --%>
    <div class="label"><fmt:message key="mobile.return.label.shipping"/></div>
    <div class="value">
      <dsp:include page="/global/gadgets/formattedPrice.jsp">
        <dsp:param name="price" value="${return.actualShippingRefund}"/>
        <dsp:param name="priceListLocale" param="priceListLocale"/>
      </dsp:include>
    </div>

    <hr/>

    <%-- Display taxes refund --%>
    <div class="label"><fmt:message key="mobile.return.label.tax"/></div>
    <div class="value">
      <dsp:include page="/global/gadgets/formattedPrice.jsp">
        <dsp:param name="price" value="${return.actualTaxRefund}"/>
        <dsp:param name="priceListLocale" param="priceListLocale"/>
      </dsp:include>
    </div>

    <hr/>

    <%-- Total refund amount --%>
    <div class="label"><fmt:message key="mobile.return.label.totalRefund"/></div>
    <div class="value">
      <dsp:include page="/global/gadgets/formattedPrice.jsp">
        <dsp:param name="price" value="${return.totalRefundAmount}"/>
        <dsp:param name="priceListLocale" param="priceListLocale"/>
      </dsp:include>
    </div>
  </div>
</dsp:page>
