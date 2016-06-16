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
import org.jahia.services.render.URLResolver;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import twitter4j.Status;
import twitter4j.Twitter;
import twitter4j.TwitterFactory;
import twitter4j.conf.ConfigurationBuilder;

import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;

public class TwitterdeleteAction extends Action {

    private static final Logger logger = LoggerFactory.getLogger(TwitterdeleteAction.class);
    private String accessToken = null;
    private String update = "false";

    @Override
    public ActionResult doExecute(HttpServletRequest httpServletRequest, RenderContext renderContext, Resource resource, JCRSessionWrapper jcrSessionWrapper, Map<String, List<String>> map, URLResolver urlResolver) throws Exception {
       String apiPath = "me/feed";
        String message = null;
        JCRNodeWrapper currentNode = renderContext.getMainResource().getNode();
        JCRSiteNode currentSite = currentNode.getResolveSite();
        JCRSessionWrapper session = currentNode.getSession();

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
            Status status = twitter.destroyStatus(currentNode.getProperty("postId").getLong());
            currentNode.setProperty("postId","");
            currentNode.setProperty("published",false);
            currentNode.saveSession();
        }

        return ActionResult.OK;
    }

}