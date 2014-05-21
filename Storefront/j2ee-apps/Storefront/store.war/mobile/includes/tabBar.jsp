<%--
  This page displays the tab bar which contains three tabs.
  
  Note: Currently (Android 2.3.3), the min-width attribute does not work with tables,
  so the width for any empty cell is explicitly set to 30%, to provide proper spacing within the table.

  Required parameters:
    firstTabLabel
      Label for the first tab.
    secondTabLabel
      Label for the second tab.
    thirdTabLabel
      Label for the third tab.

  Optional parameters:
    highlight
      Specifies which tab should be highlighted. Expected values are: "first", "second", or "third".
    firstTabURL
      Url for the first tab. If no url is specified, a link is not provided.
    secondTabURL
      Url for the second tab. If no url is specified, a link is not provided.
    thirdTabURL
      Url for the third tab. If no url is specified, a link is not provided
--%>
<dsp:page>
  <dsp:getvalueof var="firstTabText" param="firstTabLabel"/>
  <dsp:getvalueof var="secondTabLabel" param="secondTabLabel"/>
  <dsp:getvalueof var="thirdTabLabel" param="thirdTabLabel"/>
  <dsp:getvalueof var="highlight" param="highlight"/>
  <c:if test="${not empty highlight}">
    <dsp:getvalueof var="isFirstTabInFocus" value="${highlight == 'first'}"/>
    <dsp:getvalueof var="isSecondTabInFocus" value="${highlight == 'second'}"/>
    <dsp:getvalueof var="isThirdTabInFocus" value="${highlight == 'third'}"/>
  </c:if>
  <dsp:getvalueof var="firstTabURL" param="firstTabURL"/>
  <dsp:getvalueof var="secondTabURL" param="secondTabURL"/>
  <dsp:getvalueof var="thirdTabURL" param="thirdTabURL"/>

  <c:set var="highlightFirstTabClass" value="${isFirstTabInFocus ? 'highlight' : ''}"/>
  <c:set var="highlightSecondTabClass" value="${isSecondTabInFocus ? 'highlight' : ''}"/>
  <c:set var="highlightThirdTabClass" value="${isThirdTabInFocus ? 'highlight' : ''}"/>
  
  <div class="tabBar" role="tablist">
    <div class="${highlightFirstTabClass}" role="tab" aria-selected="${isFirstTabInFocus}">
      <c:choose>
        <c:when test="${not empty firstTabURL}">
          <dsp:a page="${firstTabURL}">${firstTabText}</dsp:a>
        </c:when>
        <c:otherwise>
          <div>${firstTabText}</div>
        </c:otherwise>
      </c:choose>
    </div>
    <c:if test="${not empty secondTabLabel}">
      <div class="${highlightSecondTabClass}" role="tab" aria-selected="${isSecondTabInFocus}">
        <c:choose>
          <c:when test="${not empty secondTabURL}">
            <dsp:a page="${secondTabURL}">${secondTabLabel}</dsp:a>
          </c:when>
          <c:otherwise>
            <div>${secondTabLabel}</div>
          </c:otherwise>
        </c:choose>
      </div>
    </c:if>
    <c:if test="${not empty thirdTabLabel}">
      <div class="${highlightThirdTabClass}" role="tab" aria-selected="${isThirdTabInFocus}">
        <c:choose>
          <c:when test="${not empty thirdTabURL}">
            <dsp:a page="${thirdTabURL}">${thirdTabLabel}</dsp:a>
          </c:when>
          <c:otherwise>
            <div>${thirdTabLabel}</div>
          </c:otherwise>
        </c:choose>
      </div>
    </c:if>
  </div>
</dsp:page>
