<%--
  This page renders order state, submitted date, and site information.

  Required parameters:
    order
      The order to be rendered

  NOTES:
    1) The "mobileStorePrefix" request-scoped variable (request attribute), which is used here,
       is defined in the "mobilePageContainer" tag ("mobilePageContainer.tag" file).
       This variable becomes available within the <crs:mobilePageContainer> ... </crs:mobilePageContainer> block
       and in all the included pages (gadgets and Endeca cartridges).
--%>
<dsp:page>
  <dsp:importbean bean="/atg/core/i18n/LocaleTools"/>
  <dsp:importbean bean="/atg/dynamo/droplet/multisite/GetSiteDroplet"/>

  <%-- Order status --%>
  <div class="label">
    <fmt:message key="mobile.common.label.status"/><fmt:message key="mobile.common.colon"/>&nbsp;
  </div>
  <div class="value">
    <dsp:include page="${mobileStorePrefix}/global/util/orderState.jsp">
      <dsp:param name="order" param="order"/>
    </dsp:include>
  </div>

  <%-- Submitted date --%>
  <div class="label">
    <fmt:message key="mobile.order.label.placedOn"/><fmt:message key="mobile.common.colon"/>&nbsp;
  </div>
  <dsp:getvalueof var="submittedDate" vartype="java.util.Date" param="order.submittedDate"/>

  <div class="value">
    <c:if test="${not empty submittedDate}">
      <dsp:getvalueof var="dateFormat"
                      bean="LocaleTools.userFormattingLocaleHelper.datePatterns.shortWith4DigitYear"/>
      <fmt:formatDate value="${submittedDate}" pattern="${dateFormat}"/>
    </c:if>
  </div>

  <%-- Submitted site --%>
  <div class="label">
    <fmt:message key="mobile.order.label.orderedOn"/><fmt:message key="mobile.common.colon"/>&nbsp;
  </div>

  <dsp:droplet name="GetSiteDroplet">
    <dsp:param name="siteId" param="order.siteId"/>
    <dsp:oparam name="output">
      <dsp:getvalueof var="siteName" param="site.name"/>
    </dsp:oparam>
  </dsp:droplet>

  <div class="value">
    <c:choose>
      <c:when test="${not empty siteName}">
        <c:out value="${siteName}"/>
      </c:when>
      <c:otherwise>
        <fmt:message key="common.noValue"/>
      </c:otherwise>
    </c:choose>
  </div>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/Storefront/j2ee/store.war/mobile/myaccount/gadgets/orderDetailIntro.jsp#5 $$Change: 807607 $--%>
