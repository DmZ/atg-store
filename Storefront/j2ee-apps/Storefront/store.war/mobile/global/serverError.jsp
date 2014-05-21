<%--
  This page is called upon 500 HTTP error - internal server error.

  A 500 HTTP error message will be displayed along with a link to contact
  the system administrator.  
--%>
<dsp:page>
  <fmt:message var="pageTitle" key="mobile.serverError.title"/>
  <crs:mobilePageContainer titleString="${pageTitle}">
    <jsp:body>
      <fmt:message var="email" key="mobile.contactUs.emailAddress"/>
      <div class="infoHeader">${pageTitle}</div>
      <div class="infoContent">
        <p>
          <fmt:message key="mobile.serverError.message">
            <fmt:param><a href="mailto:${email}"><dsp:valueof value="${email}"/></a></fmt:param>
          </fmt:message>
        </p>
      </div>
    </jsp:body>
  </crs:mobilePageContainer>
</dsp:page>
