<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="query" uri="http://www.jahia.org/tags/queryLib" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="ui" uri="http://www.jahia.org/tags/uiComponentsLib" %>
<c:set var="facetParamVarName" value="N-${currentNode.name}"/>
<c:set target="${moduleMap}" property="editable" value="true" />
<c:set var="boundComponent" value="${ui:getBindedComponent(currentNode, renderContext, 'j:bindedComponent')}"/>

<%-- list mode --%>
<c:choose>
    <c:when test="${not empty param[facetParamVarName] or currentResource.moduleParams.queryLoadAllUnsorted == 'true'}">
        <query:definition var="listQuery" >
            <query:selector nodeTypeName="nt:base"/>
            <c:set var="descendantNode" value="${fn:substringAfter(boundComponent.realNode.path,'/sites/')}"/>
            <c:set var="descendantNode" value="${fn:substringAfter(descendantNode,'/')}"/>
            <query:descendantNode path="/sites/${renderContext.site.name}/${descendantNode}"/>
        </query:definition>
        <c:set target="${moduleMap}" property="listQuery" value="${listQuery}"/>
    </c:when>
    <c:otherwise>
        <c:set target="${moduleMap}" property="currentList" value="${jcr:getChildrenOfType(boundComponent, jcr:getConstraints(currentNode))}" />
        <c:set target="${moduleMap}" property="end" value="${fn:length(moduleMap.currentList)}" />
        <c:set target="${moduleMap}" property="listTotalSize" value="${moduleMap.end}" />
    </c:otherwise>
</c:choose>
