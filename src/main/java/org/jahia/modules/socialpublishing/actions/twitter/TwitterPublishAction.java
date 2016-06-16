package org.jahia.modules.socialpublishing.actions.twitter;/**
 * Created by fabriceaissah on 5/13/16.
 */


import org.jahia.bin.Action;
import org.jahia.bin.ActionResult;
import org.jahia.services.content.JCRNodeWrapper;
import org.jahia.services.content.JCRSessionWrapper;
import org.jahia.services.content.decorator.JCRSiteNode;
import org.jahia.services.render.RenderContext;
import org.jahia.services.render.Resource;
import org.jahia.services.render.URLGenerator;
import org.jahia.services.render.URLResolver;
import org.jahia.services.seo.urlrewrite.UrlRewriteService;
import org.jahia.utils.Url;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import twitter4j.Status;
import twitter4j.StatusUpdate;
import twitter4j.Twitter;
import twitter4j.TwitterFactory;
import twitter4j.conf.ConfigurationBuilder;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import java.io.BufferedInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.lang.reflect.InvocationTargetException;
import java.net.URL;
import java.net.URLConnection;
import java.util.List;
import java.util.Map;

public class TwitterPublishAction extends Action {

    private static final Logger logger = LoggerFactory.getLogger(TwitterPublishAction.class);
    private String accessToken = null;
    private String update = "false";
    private String socialCampaignParam = "scid";
    private UrlRewriteService urlRewriteService;
    private URLGenerator u = null;

    @Override
    public ActionResult doExecute(HttpServletRequest httpServletRequest, RenderContext renderContext, Resource resource, JCRSessionWrapper jcrSessionWrapper, Map<String, List<String>> map, URLResolver urlResolver) throws Exception {
        String message = null;
        String contentURL = null;
        JCRNodeWrapper currentNode = renderContext.getMainResource().getNode();
        JCRSiteNode currentSite = currentNode.getResolveSite();
        JCRSessionWrapper session = currentNode.getSession();
        u = new URLGenerator(renderContext,resource);

        if(currentSite.isNodeType("jmix:twittersocialPublishConfiguration")){
            String twitterAPIKey = currentSite.getProperty("twitterAPIKey").getString();
            String twitterAPISecret = currentSite.getProperty("twitterAPISecret").getString();
            String twitterAccessToken  = currentSite.getProperty("twitterAccessToken").getString();
            String twitterAccessTokenSecret  = currentSite.getProperty("twitterAccessTokenSecret").getString();
            ConfigurationBuilder cb = new ConfigurationBuilder();
            cb.setDebugEnabled(true)
                    .setOAuthConsumerKey(twitterAPIKey)
                    .setOAuthConsumerSecret(twitterAPISecret)
                    .setOAuthAccessToken(twitterAccessToken)
                    .setOAuthAccessTokenSecret(twitterAccessTokenSecret);
            TwitterFactory tf = new TwitterFactory(cb.build());
            Twitter twitter = tf.getInstance();

            message = currentNode.getProperty("socialTwitterMessage").getString();
            if(message == null)
                message = currentNode.getDisplayableName();

            if(currentNode.hasProperty("contentReferenced")){
                JCRNodeWrapper contentLink = (JCRNodeWrapper) currentNode.getProperty("contentReferenced").getNode();
                contentURL = getLiveURL(contentLink,httpServletRequest,renderContext,true);
                if(currentNode.isNodeType("jmix:socialMarketingCampaign") && currentNode.hasProperty("campaingID")){
                    contentURL+="?"+socialCampaignParam+"="+currentNode.getProperty("campaingID").getString();
                }
                message+=" "+contentURL;
            }

            StatusUpdate statusUpdate = new StatusUpdate(message);

            if(currentNode.hasProperty("image")){

                URL url = new URL(getLiveURL(((JCRNodeWrapper) currentNode.getProperty("image").getNode()),httpServletRequest,renderContext,false));
                URLConnection urlConnection = url.openConnection();
                InputStream in = new BufferedInputStream(urlConnection.getInputStream());
                statusUpdate.setMedia(currentNode.getProperty("image").getName(), in);
            }

            Status status = twitter.updateStatus(statusUpdate);
            currentNode.setProperty("postId",status.getId());
            currentNode.setProperty("published",true);
            currentNode.saveSession();
        }else{
            logger.error("Twitter API not configured");
            return ActionResult.INTERNAL_ERROR;
        }

        return ActionResult.OK;
    }

    public String getLiveURL(JCRNodeWrapper node, HttpServletRequest httpServletRequest, RenderContext renderContext, boolean isPage) throws ServletException, IOException, InvocationTargetException {
        String stageUrl = (isPage) ? u.getBaseLive() + node.getPath()+".html" : "/files/live" + node.getPath();
        String contentURL = urlRewriteService.rewriteOutbound(stageUrl,httpServletRequest,renderContext.getResponse());
        contentURL = Url.getServer(httpServletRequest)+contentURL;
        logger.debug("fileURL= "+contentURL);
        return contentURL;
    }

    public void setUrlRewriteService(UrlRewriteService urlRewriteService) {
        this.urlRewriteService = urlRewriteService;
    }

}