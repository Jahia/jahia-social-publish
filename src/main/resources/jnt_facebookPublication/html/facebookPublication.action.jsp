<%@ page language="java" contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="ui" uri="http://www.jahia.org/tags/uiComponentsLib" %>
<%@ taglib prefix="functions" uri="http://www.jahia.org/tags/functions" %>
<%@ taglib prefix="query" uri="http://www.jahia.org/tags/queryLib" %>
<%@ taglib prefix="utility" uri="http://www.jahia.org/tags/utilityLib" %>
<%@ taglib prefix="s" uri="http://www.jahia.org/tags/search" %>
<%--@elvariable id="currentNode" type="org.jahia.services.content.JCRNodeWrapper"--%>
<%--@elvariable id="out" type="java.io.PrintWriter"--%>
<%--@elvariable id="script" type="org.jahia.services.render.scripting.Script"--%>
<%--@elvariable id="scriptInfo" type="java.lang.String"--%>
<%--@elvariable id="workspace" type="java.lang.String"--%>
<%--@elvariable id="renderContext" type="org.jahia.services.render.RenderContext"--%>
<%--@elvariable id="currentResource" type="org.jahia.services.render.Resource"--%>
<%--@elvariable id="url" type="org.jahia.services.render.URLGenerator"--%>
<template:addResources type="css" resources="facebookPublication.css" />
<template:addResources type="javascript" resources="jquery.js"/>
<template:addResources type="javascript" resources="facebookPublication.js"/>

<c:set var="id" value="fbActions${currentNode.identifier}"/>

<c:choose>
    <c:when test="${not currentNode.properties['published'].boolean}">
        <c:set var="hidePublishedButton" value="style='display: none;'"/>
    </c:when>
    <c:otherwise>
        <c:set var="hideUnpublishedButton" value="style='display: none;'"/>
    </c:otherwise>
</c:choose>
<div class="itemSocialActions" id="${id}">
    <button ${hideUnpublishedButton} action="<c:url value='${url.base}${currentNode.path}.facebookPublish.do'/>" class="facebookAction fbPublish btn btn-default btn-u" >
        <fmt:message key="publish.facebook.button"/>
    </button>

    <button ${hidePublishedButton} action="<c:url value='${url.base}${currentNode.path}.facebookUpdate.do'/>" class="facebookAction fbUpdate btn btn-default btn-u">
        <fmt:message key="update.facebook.button"/>
    </button>

    <button ${hidePublishedButton} action="<c:url value='${url.base}${currentNode.path}.facebookDelete.do'/>" class="facebookAction fbDelete btn btn-default btn-u" t>
        <fmt:message key="delete.facebook.button"/>
    </button>
</div>
