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
<c:set var="siteNode" value="${renderContext.mainResource.node.resolveSite}"/>
<c:set var="id" value="fbActions${currentNode.identifier}"/>

<c:choose>
    <c:when test="${not currentNode.properties['published'].boolean}">
        <c:set var="hidePublishedButton" value="style='display: none;'"/>
    </c:when>
    <c:otherwise>
        <c:set var="hideUnpublishedButton" value="style='display: none;'"/>
    </c:otherwise>
</c:choose>
<div class="facebookSocialActions" id="${id}">
<c:choose>
    <c:when test="${jcr:isNodeType(siteNode, 'jmix:facebookSocialPublishConfiguration')  and
        siteNode.properties['facebookToken'] != null and
        siteNode.properties['appID'] != null and
        siteNode.properties['appSecret'] != null}">
        <button ${hideUnpublishedButton} action="<c:url value='${url.base}${currentNode.path}.facebookPublish.do'/>" class="socialAction fbPublish btn btn-default btn-u" >
            <fmt:message key="publish.facebook.button"/>
        </button>

        <button ${hidePublishedButton} action="<c:url value='${url.base}${currentNode.path}.facebookUpdate.do'/>" class="socialAction fbUpdate btn btn-default btn-u">
            <fmt:message key="update.facebook.button"/>
        </button>

        <button ${hidePublishedButton} action="<c:url value='${url.base}${currentNode.path}.facebookDelete.do'/>" class="socialAction fbDelete btn btn-default btn-u" t>
            <fmt:message key="delete.facebook.button"/>
        </button>

        <a ${hidePublishedButton}  class="btn btn-default btn-u fbView" href="http://www.facebook.com/${currentNode.properties.postId.string}"  target="_blank">
            <fmt:message key="view.facebook.button"/>
        </a>

    </c:when>
    <c:otherwise>
        <fmt:message key="socialpublication.APIconfiguration"/>
    </c:otherwise>
</c:choose>
</div>

