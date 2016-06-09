package org.jahia.modules.socialpublishing.actions;/**
 * Created by fabriceaissah on 5/13/16.
 */

import com.restfb.DefaultFacebookClient;
import com.restfb.FacebookClient;
import com.restfb.Parameter;
import com.restfb.Version;
import com.restfb.types.FacebookType;
import org.jahia.bin.Action;
import org.jahia.bin.ActionResult;
import org.jahia.services.content.JCRNodeWrapper;
import org.jahia.services.content.JCRSessionWrapper;
import org.jahia.services.content.decorator.JCRSiteNode;
import org.jahia.services.render.RenderContext;
import org.jahia.services.render.Resource;
import org.jahia.services.render.URLGenerator;
import org.jahia.services.render.URLResolver;
import org.jahia.utils.Url;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;

public class FBPublishAction extends Action {

    private static final Logger logger = LoggerFactory.getLogger(FBPublishAction.class);
    private FacebookClient facebookClient = null;
    private String accessToken = null;
    private String update = "false";

    @Override
    public ActionResult doExecute(HttpServletRequest httpServletRequest, RenderContext renderContext, Resource resource, JCRSessionWrapper jcrSessionWrapper, Map<String, List<String>> map, URLResolver urlResolver) throws Exception {
        String apiPath = "me/feed";
        String message = null;
        JCRNodeWrapper liveContentLink = null;
        FacebookType publishMessageResponse = null;
        JCRNodeWrapper currentNode = renderContext.getMainResource().getNode();
        JCRSiteNode currentSite = currentNode.getResolveSite();
        JCRSessionWrapper session = currentNode.getSession();

        if(currentSite.isNodeType("jmix:socialPublishConfiguration")){
            accessToken = currentSite.getProperty("facebookToken").getString();
            facebookClient = new DefaultFacebookClient(accessToken, Version.VERSION_2_5);

            message = currentNode.getProperty("socialFacebookMessage").getString();
            if(message == null)
                message = currentNode.getDisplayableName();

            if(update == "true" && currentNode.hasProperty("postId"))
                apiPath = "/"+currentNode.getProperty("postId").getString();;

            if(currentNode.hasProperty("contentReferenced")){
                JCRNodeWrapper contentLink = (JCRNodeWrapper) currentNode.getProperty("contentReferenced").getNode();
                URLGenerator u = new URLGenerator(renderContext,resource);
                String contentURL = Url.getServer(httpServletRequest)+ u.getBaseLive() + contentLink.getPath() + ".html";

                publishMessageResponse =  facebookClient.publish(
                        apiPath,
                        FacebookType.class,
                        Parameter.with("message", message),
                        Parameter.with("link", contentURL)
                );
            }else{
                publishMessageResponse =  facebookClient.publish(apiPath,FacebookType.class,
                        Parameter.with("message", message));
            }
            currentNode.setProperty("postId",publishMessageResponse.getId());
            currentNode.setProperty("published",true);

            currentNode.saveSession();
        }

        return ActionResult.OK;
    }

    public void setUpdate(String update) {
        this.update = update;
    }

    public String getUpdate() {
        return update;
    }
}