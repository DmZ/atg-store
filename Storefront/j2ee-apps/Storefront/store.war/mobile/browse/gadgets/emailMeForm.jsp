<%--
  This page renders form for email notification: "When the product is in stock, please let me know".

  Required parameters:
    selectedSkuId
      ID of the SKU that has been selected
    productId
      ID of the product that has been selected

  Optional parameters:
    None

  NOTES:
    1) The "siteContextPath" request-scoped variable (request attribute), which is used here,
       is defined in the "mobilePageContainer" tag ("mobilePageContainer.tag" file).
       This variable becomes available within the <crs:mobilePageContainer> ... </crs:mobilePageContainer> block
       and in all the included pages (gadgets and Endeca cartridges).
--%>
<dsp:page>
  <dsp:importbean bean="/atg/store/inventory/BackInStockFormHandler"/>
  <dsp:importbean bean="/atg/store/profile/SessionBean"/>

  <div id="emailMePopup">
    <%-- ========== Form ========== --%>
    <dsp:form formid="emailMeForm" method="post" name="emailMeForm"
              action="${siteContextPath}/browse/gadgets/emailMeFormErrors.jsp" onsubmit="CRSMA.product.emailMeSubmit(event);">
      <%-- ========== Redirection URLs ========== --%>
      <dsp:input bean="BackInStockFormHandler.successURL" type="hidden" value=""/>
      <dsp:input bean="BackInStockFormHandler.errorURL" type="hidden" value=""/>

      <%-- Form properties, SKU and products that are unavailable --%>
      <dsp:input id="emailMeSkuId" bean="BackInStockFormHandler.catalogRefId" type="hidden" paramvalue="selectedSkuId"/>
      <dsp:input bean="BackInStockFormHandler.productId" type="hidden" paramvalue="productId"/>

      <ul class="dataList" role="presentation" onclick="event.stopPropagation();">
        <li><div class="content"><fmt:message key="mobile.productDetails.emailMe.whenInStock"/></div></li>
        <li id="emailAddressRow">
          <div class="content">
            <fmt:message key="mobile.common.email" var="hintText"/>
            <dsp:input id="rememberMeEmailAddress" bean="BackInStockFormHandler.emailAddress" type="email"
                       beanvalue="/atg/userprofiling/Profile.email" onclick="event.stopPropagation();"
                       placeholder="${hintText}" aria-label="${hintText}" autocapitalize="off" autocorrect="off"/>
          </div>
          <span class="errorMessage">
            <fmt:message key="mobile.common.error.invalidValue"/>
          </span>
        </li>
        <li>
          <div class="content">
            <fmt:message var="privacyTitle" key="mobile.common.privacyAndTerms"/>
            <dsp:a page="/company/terms.jsp" title="${privacyTitle}" class="icon-help email-me"/>
            <dsp:input name="rememberEmail" type="hidden" bean="SessionBean.values.rememberedEmail" value=""/>
            <input id="rememberCheckbox" type="checkbox" name="rememberCheckbox" checked="checked"/>
            <label for="rememberCheckbox" onclick=""><fmt:message key="mobile.productDetails.emailMe.checkbox.remember"/></label>
          </div>
        </li>
      </ul>
      <fmt:message key="mobile.common.button.submit" var="submitLabel"/>
      <dsp:input type="hidden" bean="BackInStockFormHandler.notifyMe" value="${submitLabel}"/>
    </dsp:form>
  </div>

  <div id="emailMeConfirm">
    <ul class="dataList" summary="" role="presentation" datatable="0">
      <li>
        <div class="content"><fmt:message key="mobile.productDetails.emailMe.title"/></div>
      </li>
      <li>
        <div class="content">
          <p><fmt:message key="mobile.productDetails.emailMe.message"/></p>
        </div>
      </li>
    </ul>
  </div>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/Storefront/j2ee/store.war/mobile/browse/gadgets/emailMeForm.jsp#4 $$Change: 800951 $ --%>
