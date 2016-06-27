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

<c:set var="resourceReadOnly" value="${currentResource.moduleParams.readOnly}"/>
<template:include view="hidden.header"/>
<c:set var="isEmpty" value="true"/>
<c:choose>
    <c:when test="${moduleMap.liveOnly eq 'true' && !renderContext.liveMode}">
        <c:if test="${renderContext.editModeConfigName eq 'studiomode'}">
            <div class="area-liveOnly">
                <fmt:message key="label.content.creation.only.live"/>
            </div>
        </c:if>
        <c:if test="${!(renderContext.editModeConfigName eq 'studiomode')}">
            <template:addResources type="javascript" resources="jquery.min.js"/>
            <div id="liveList${currentNode.identifier}"></div>
            <script type="text/javascript">
                $('#liveList${currentNode.identifier}').load('<c:url value="${url.baseLive}${currentNode.path}.html.ajax"/>');
            </script>
        </c:if>
    </c:when>
    <c:otherwise>
        <div class="actionsList">
        <c:forEach items="${moduleMap.currentList}" var="subchild" begin="${moduleMap.begin}" end="${moduleMap.end}">
            <template:module node="${subchild}" view="action" editable="${moduleMap.editable && !resourceReadOnly}"/>
            <c:set var="isEmpty" value="false"/>
        </c:forEach>
        </div>
        <c:if test="${not omitFormatting}"><div class="clear"></div></c:if>
        <c:if test="${not empty moduleMap.emptyListMessage and (renderContext.editMode or moduleMap.forceEmptyListMessageDisplay) and isEmpty}">
            <fmt:message key="socialpublication.enableArea"/>
        </c:if>

        <template:include view="hidden.footer"/>
    </c:otherwise>
</c:choose>


<script>
    $(".socialAction").unbind().click(function() {
        currentNode = $(this);
        id = currentNode.parent().attr('id');
        $.ajax({
            type: 'POST',
            url: $(this).attr('action'),
            data: "",
            dataType: 'json',
            success: function (data) {
                alert("<fmt:message key='socialpublication.success'/>");
                if(currentNode.hasClass('fbPublish')){
                    currentNode.parent().find('.fbUpdate').show();
                    currentNode.parent().find('.fbDelete').show();
                    if(data.postId['0'] != null){
                        var fbview = currentNode.parent().find('.fbView');
                        fbview.attr("href", "http://www.facebook.com/" + data.postId['0']);
                        fbview.show();
                    }
                    currentNode.hide();
                }
                if(currentNode.hasClass('fbDelete')){
                    currentNode.parent().find('.fbPublish').show();
                    currentNode.parent().find('.fbUpdate').hide();
                    currentNode.parent().find('.fbView').hide();
                    currentNode.hide();
                }
                if(currentNode.hasClass('twitterPublish')){
                    currentNode.parent().find('.twitterDelete').show();
                    if(data.tweetId['0'] != null){
                        var twitterView = currentNode.parent().find('.twitterView');
                        twitterView.attr("href", "http://twitter.com/statuses/" + data.tweetId['0']);
                        twitterView.show();
                    }
                    currentNode.hide();
                }
                if(currentNode.hasClass('twitterDelete')){
                    currentNode.parent().find('.twitterPublish').show();
                     currentNode.parent().find('.twitterView').hide();
                    currentNode.hide();
                }


            },
            error: function (jqXHR, textStatus, errorThrown) {
                alert("<fmt:message key='socialpublication.error'/>");
            }
        });
    });
</script>