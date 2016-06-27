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
<template:addResources type="css" resources="twitterPublication.css" />
<c:set var="message" value="${currentNode.properties['socialTwitterMessage'].string}"/>
<c:set var="contentReference" value="${currentNode.properties['contentReferenced'].node}"/>
<c:if test="${currentNode.properties['image'] != null}">
    <c:set var="imageClass" value="Img"/>
</c:if>

<div class="twitterSocial twitterSocialContent${imageClass}">
    <div class="left-img"><img class="img-responsive" src="${url.currentModule}/icons/twitter-official.png"></div>
    <p>${message} <a href="${contentReference.url}">${contentReference.path}</a> </p>
    <c:if test="${currentNode.properties['image'] != null}">
        <img class="twitterPic" src="${currentNode.properties['image'].node.url}">
    </c:if>
</div>