<%--
  This page is called upon session expiry to display a message to the user.
--%>
<dsp:page>
  <fmt:message var="pageTitle" key="mobile.sessionExpired.title"/>
  <crs:mobilePageContainer titleString="${pageTitle}">
    <jsp:body>
      <div class="infoHeader">${pageTitle}</div>
      <div class="infoContent">
        <p>
          <fmt:message key="mobile.sessionExpired.message"/>
        </p>
      </div>
    </jsp:body>
  </crs:mobilePageContainer>
</dsp:page>
