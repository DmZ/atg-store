<%--
  This page is called upon 404 HTTP error - page not found.
  
   Display 404 content on non-publishing instances only! Publishing servers have wrong Profile defined, that's why 
   there will be a lot of errors in the console when displaying 404 page on such servers. 
--%>
<dsp:page>
  <%--
    ComponentExists droplet conditionally renders one of its output parameters
    depending on whether or not a specified Nucleus path currently refers to a
    non-null object.  It is used to query whether a particular component has been
    instantiated, in this case StoreVersioned. If the StoreVersioned component has 
    not been instantiated we can display the 404.
      
    Input Parameters:
      path - The path to a component
       
    Open Parameters:
      true
        Rendered if the component 'path' has been instantiated.
      false
        Rendered if the component 'path' has not been instantiated. 
  --%>      
  <dsp:droplet name="/atg/dynamo/droplet/ComponentExists">
    <%-- 
      /atg/modules/StoreVersioned module is defined in EStore.Versioned, so non-publishing 
      instances will not have this component. 
    --%>
    <dsp:param name="path" value="/atg/modules/StoreVersioned"/>
    <dsp:oparam name="false">
      <fmt:message var="pageTitle" key="mobile.pageNotFound.title"/>
      <crs:mobilePageContainer titleString="${pageTitle}">
        <jsp:body>
          <div class="infoHeader">${pageTitle}</div>
          <div class="infoContent">
            <p>
              <fmt:message key="mobile.pageNotFound.message"/>
            </p>
          </div>
        </jsp:body>
      </crs:mobilePageContainer>
    </dsp:oparam>
  </dsp:droplet>
</dsp:page>
