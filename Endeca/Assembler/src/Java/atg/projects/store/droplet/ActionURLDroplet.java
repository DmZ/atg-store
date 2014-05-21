/*<ORACLECOPYRIGHT>
 * Copyright (C) 1994-2012 Oracle and/or its affiliates. All rights reserved.
 * Oracle and Java are registered trademarks of Oracle and/or its affiliates. 
 * Other names may be trademarks of their respective owners.
 * UNIX is a registered trademark of The Open Group.
 *
 * This software and related documentation are provided under a license agreement 
 * containing restrictions on use and disclosure and are protected by intellectual property laws. 
 * Except as expressly permitted in your license agreement or allowed by law, you may not use, copy, 
 * reproduce, translate, broadcast, modify, license, transmit, distribute, exhibit, perform, publish, 
 * or display any part, in any form, or by any means. Reverse engineering, disassembly, 
 * or decompilation of this software, unless required by law for interoperability, is prohibited.
 *
 * The information contained herein is subject to change without notice and is not warranted to be error-free. 
 * If you find any errors, please report them to us in writing.
 *
 * U.S. GOVERNMENT RIGHTS Programs, software, databases, and related documentation and technical data delivered to U.S. 
 * Government customers are "commercial computer software" or "commercial technical data" pursuant to the applicable 
 * Federal Acquisition Regulation and agency-specific supplemental regulations. 
 * As such, the use, duplication, disclosure, modification, and adaptation shall be subject to the restrictions and 
 * license terms set forth in the applicable Government contract, and, to the extent applicable by the terms of the 
 * Government contract, the additional rights set forth in FAR 52.227-19, Commercial Computer Software License 
 * (December 2007). Oracle America, Inc., 500 Oracle Parkway, Redwood City, CA 94065.
 *
 * This software or hardware is developed for general use in a variety of information management applications. 
 * It is not developed or intended for use in any inherently dangerous applications, including applications that 
 * may create a risk of personal injury. If you use this software or hardware in dangerous applications, 
 * then you shall be responsible to take all appropriate fail-safe, backup, redundancy, 
 * and other measures to ensure its safe use. Oracle Corporation and its affiliates disclaim any liability for any 
 * damages caused by use of this software or hardware in dangerous applications.
 *
 * This software or hardware and documentation may provide access to or information on content, 
 * products, and services from third parties. Oracle Corporation and its affiliates are not responsible for and 
 * expressly disclaim all warranties of any kind with respect to third-party content, products, and services. 
 * Oracle Corporation and its affiliates will not be responsible for any loss, costs, 
 * or damages incurred due to your access to or use of third-party content, products, or services.
 </ORACLECOPYRIGHT>*/
package atg.projects.store.droplet;

import java.io.IOException;

import javax.servlet.ServletException;

import com.endeca.infront.cartridge.model.Action;
import com.endeca.infront.cartridge.model.NavigationAction;
import com.endeca.infront.cartridge.model.RecordAction;
import com.endeca.infront.cartridge.model.UrlAction;

import atg.nucleus.naming.ParameterName;
import atg.servlet.DynamoHttpServletRequest;
import atg.servlet.DynamoHttpServletResponse;
import atg.servlet.DynamoServlet;

/**
 * This droplet builds a complete URL string for the Endeca-produced action object.
 * The action can be represented either by NavigationAction, RecordAction or
 * UrlAction.
 * 
 * For the NavigationAction type of Action the URL is built of request's context path,
 * action's <code>contentPath</code> and <code>navigationState</code>.
 * 
 * For the RecordAction type of Action the URL is built of request's context path,
 * action's <code>contentPath</code> and <code>recordState</code>.
 * 
 * For the UrlAction type of Action the URL is built of request's context path (only in
 * the case of relative URL) and action's URL.
 * 
 * <p>
 * Input parameters:
 * <ul>
 *   <li>action - An <code>action</code> object to produce URL for.</li>
 * </ul>
 * 
 * <p>
 * Output parameters: 
 * <ul>
 *   <li>actionURL - An URL for the passed in action Object.</li>
 * </ul>
 * 
 * <p>
 * Open parameters rendered by the droplet: 
 * <ul>
 *   <li>output - The <code>output</code> oparam is rendered when the not empty URL is represented
 *   by the Action object.</li> *   
 *   <li>empty - The <code>empty</code> oparam is rendered in the case of empty URL.</li>   
 * </ul>
 * 
 * <p>
 * Here is the example of droplet's usage:
 * 
 * &lt;dsp:droplet name="ActionURLDroplet"&gt;
 *   &lt;dsp:param name="action" value="${contentItem.link}"/&gt;
 *   &lt;dsp:oparam name="output"&gt;
 *     &lt;dsp:getvalueof var="actionURL" param="actionURL"/&gt;
 *     &lt;c:set var="url" value="${originatingRequest.contextPath}${actionURL}"/&gt;
 *   &lt;/dsp:oparam&gt;
 *   &lt;dsp:oparam name="empty"&gt;
 *     &lt;c:set var="url" value="#"/&gt;
 *   &lt;/dsp:oparam&gt;
 * &lt;/dsp:droplet&gt;
 * 
 * @author Natallia Paulouskaya
 * @version $Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/Endeca/Assembler/src/atg/projects/store/droplet/ActionURLDroplet.java#1 $$Change: 796860 $
 * @updated $DateTime: 2013/03/14 09:30:30 $$Author: npaulous $
 */
public class ActionURLDroplet extends DynamoServlet{
  
  //----------------------------------------
  /** Class version string */
  public static final String CLASS_VERSION = 
    "$Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/Endeca/Assembler/src/atg/projects/store/droplet/ActionURLDroplet.java#1 $$Change: 796860 $";
  
  /** Action object input parameter name*/
  public static final ParameterName ACTION = ParameterName.getParameterName("action");
  
  /** The URL for the action output parameter name */
  public static final String ACTION_URL = "actionURL";
    
  /** Output parameter name. */
  public static final String OUTPUT = "output";
    
  /** Empty parameter name. */
  public static final String EMPTY = "empty";
  
  /** URL separator */
  public static final String URL_SEPARATOR = "/";
    
  /**
   * Builds the complete URL string for the Endeca-produced action object.
   * The action can be represented either by NavigationAction, RecordAction or
   * UrlAction.
  */
  @Override
  public void service(DynamoHttpServletRequest pRequest, DynamoHttpServletResponse pResponse)
    throws ServletException, IOException {
 
    // Take Action object from the request
    Action action = (Action) pRequest.getObjectParameter(ACTION);
    
    StringBuilder actionURL = new StringBuilder();
    
    if (action != null){
      
      // Check the type of the action
      if (action instanceof NavigationAction){
        
        // NavigationAction case
        actionURL.append(pRequest.getContextPath());
        actionURL.append(action.getContentPath());
        String navigationState = ((NavigationAction)action).getNavigationState();
        if (navigationState!=null){
          actionURL.append(navigationState);
        }
      } else{
        if (action instanceof RecordAction){
          
          // RecordAction case
          actionURL.append(pRequest.getContextPath());
          actionURL.append(action.getContentPath());
          String recordState = ((RecordAction)action).getRecordState();
          if (recordState!=null){
            actionURL.append(recordState);
          }
        }else{
          if (action instanceof UrlAction){
            
            // UrlAction case
            String url = ((UrlAction)action).getUrl();
            if (url.startsWith(URL_SEPARATOR)){
              actionURL.append(pRequest.getContextPath());
            }
            actionURL.append(((UrlAction)action).getUrl());
          }
        }
      }
      
      // If action's URL is not empty pass it through output parameter
      if (actionURL.length()>0){
        pRequest.setParameter(ACTION_URL , actionURL.toString());
        pRequest.serviceLocalParameter(OUTPUT, pRequest, pResponse);
        return;
      }          
    }
      
    // Action's URL is empty, render empty oparam
    pRequest.serviceLocalParameter(EMPTY, pRequest, pResponse);
  }

}
