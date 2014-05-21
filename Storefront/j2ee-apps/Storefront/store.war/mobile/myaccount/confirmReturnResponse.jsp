<%--
  This is the final page for the return submission process.
  It displays success message and a link to the return details page.

  NOTES:
    1) The "mobileStorePrefix" request-scoped variable (request attribute), which is used here,
       is defined in the "mobilePageContainer" tag ("mobilePageContainer.tag" file).
       This variable becomes available within the <crs:mobilePageContainer> ... </crs:mobilePageContainer> block
       and in all the included pages (gadgets and Endeca cartridges).
--%>
<dsp:page>
  <dsp:importbean bean="/atg/store/profile/SessionBean"/>
  <dsp:importbean bean="/atg/userprofiling/Profile"/>

  <fmt:message var="pageTitle" key="mobile.return.confirmReturnResponse.successful"/>
  <crs:mobilePageContainer titleString="${pageTitle}">
    <jsp:body>
      <div class="detailsContainer returnSuccessTruck">
        <%-- Header --%>
        <div class="returnHeader"><fmt:message key="mobile.return.confirmReturnResponse.successful"/></div>
        <hr/>

        <div class="dataContainer">
          <div class="returnSuccessHeader">
            <fmt:message key="mobile.return.success.successMessage"/>
          </div>
          <div class="returnSuccessData">
            <div>
              <fmt:message key="mobile.return.success.successDetailedMessage"/>
            </div>
            <div class="roundedBox">
              <div>
                <fmt:message key="mobile.return.success.returnNumber">
                  <fmt:param>
                    <%-- Display link to currently placed order --%>
                    <dsp:a page="${mobileStorePrefix}/myaccount/returnDetail.jsp" style="float:right">
                      <dsp:param name="returnRequestId" bean="SessionBean.values.lastReturnRequest.authorizationNumber"/>
                      <dsp:valueof bean="SessionBean.values.lastReturnRequest.authorizationNumber"/>
                    </dsp:a>
                  </fmt:param>
                </fmt:message>
              </div>

              <hr/>

              <div>
                <fmt:message key="mobile.return.success.emailText">
                  <fmt:param><span><dsp:valueof bean="Profile.email"/></span></fmt:param>
                </fmt:message>
              </div>

              <hr/>

              <div>
                <fmt:message var="returnHistoryLinkTitle" key="mobile.return.success.historySection"/>
                <fmt:message key="mobile.return.success.reviewReturn">
                  <fmt:param>
                    <dsp:a page="${mobileStorePrefix}/myaccount/myReturns.jsp">${returnHistoryLinkTitle}</dsp:a>
                  </fmt:param>
                </fmt:message>
              </div>
            </div>
          </div>
        </div>
      </div>
    </jsp:body>
  </crs:mobilePageContainer>
</dsp:page>
