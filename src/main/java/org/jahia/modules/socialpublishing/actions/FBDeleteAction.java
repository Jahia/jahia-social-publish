package org.jahia.modules.socialpublishing.actions;/**
 * Created by fabriceaissah on 5/13/16.
 */

import com.restfb.DefaultFacebookClient;
import com.restfb.FacebookClient;
import com.restfb.Version;
import org.jahia.bin.Action;
import org.jahia.bin.ActionResult;
import org.jahia.services.content.JCRNodeWrapper;
import org.jahia.services.content.JCRSessionWrapper;
import org.jahia.services.content.decorator.JCRSiteNode;
import org.jahia.services.render.RenderContext;
import org.jahia.services.render.Resource;
import org.jahia.services.render.URLResolver;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;

public class FBDeleteAction extends Action {

    private static final Logger logger = LoggerFactory.getLogger(FBDeleteAction.class);
    private FacebookClient facebookClient = null;
    private String accessToken = null;

    @Override
    public ActionResult doExecute(HttpServletRequest httpServletRequest, RenderContext renderContext, Resource resource, JCRSessionWrapper jcrSessionWrapper, Map<String, List<String>> map, URLResolver urlResolver) throws Exception {
        JCRNodeWrapper currentNode = renderContext.getMainResource().getNode();
        JCRSiteNode currentSite = currentNode.getResolveSite();

        if(currentSite.isNodeType("jmix:socialPublishConfiguration")){
            accessToken = currentSite.getProperty("facebookToken").getString();
            facebookClient = new DefaultFacebookClient(accessToken, Version.VERSION_2_5);
            facebookClient.deleteObject(currentNode.getProperty("postId").getString());
        }
        currentNode.setProperty("published",false);
        currentNode.saveSession();
        return ActionResult.OK;
    }
}