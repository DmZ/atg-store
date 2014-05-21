<%--
  Render a gift note.

  Required parameters:
    order
      Order from which the gift note should be displayed.

--%>
<dsp:page>

  <%-- Request parameters - to variables --%>
  <dsp:getvalueof var="containsGiftMessage" vartype="java.lang.String" param="order.containsGiftMessage"/>

  <%-- Optional: Gift Message --%>
  <c:if test='${containsGiftMessage == "true"}'>

    <div class="item">

      <%-- Hard-coded gift note image --%>
      <div class="thumbnail">
        <img src="/crsdocroot/content/images/GN_GiftNote.jpg" alt="${giftNote}">
      </div>

      <%-- Display product details --%>
      <div class="itemData">
        <div class="productName">
          <span><fmt:message key="mobile.order.label.giftNote"/></span>
        </div>

        <div class="dimension">
          <span>
            <fmt:message key="mobile.common.quantity"/><fmt:message key="mobile.common.colon"/>
          </span>
          <span><fmt:formatNumber value="1" type="number"/></span>
        </div>

        <div class="dimension">
          <span>
            <fmt:message key="mobile.common.label.to"/><fmt:message key="common.labelSeparator"/>
          </span>
          <span>
            <dsp:valueof param="order.specialInstructions.giftMessageTo"/>
          </span>
        </div>

        <div class="dimension">
          <span>
            <fmt:message key="mobile.common.label.from"/><fmt:message key="common.labelSeparator"/>
          </span>
          <span>
            <dsp:valueof param="order.specialInstructions.giftMessageFrom"/>
          </span>
        </div>

        <div class="dimension">
          <span>
            <fmt:message key="mobile.common.label.text"/><fmt:message key="common.labelSeparator"/>
          </span>
          <span>
            <dsp:valueof param="order.specialInstructions.giftMessage"/>
          </span>
        </div>

        <div class="dimension">
          <span>
            <fmt:message key="mobile.common.label.price"/><fmt:message key="common.labelSeparator"/>
          </span>
          <span>
            <fmt:message key="mobile.common.price.FREE"/>
          </span>
        </div>

      </div>

    </div>

  </c:if> <%-- containsGiftMessage --%>

</dsp:page>
