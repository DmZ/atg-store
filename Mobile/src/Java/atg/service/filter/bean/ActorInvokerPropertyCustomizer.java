/*<ORACLECOPYRIGHT>
 * Copyright (C) 1994-2013 Oracle and/or its affiliates. All rights reserved.
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

package atg.service.filter.bean;

import java.util.Map;

import atg.beans.DynamicBeans;
import atg.beans.PropertyNotFoundException;
import atg.service.actor.Actor;
import atg.service.actor.ActorContext;
import atg.service.actor.ActorContextFactory;
import atg.service.actor.ActorException;
import atg.service.actor.ActorUtils;
import atg.service.actor.ModelMap;
import atg.service.actor.ModelMapFactory;
import atg.servlet.DynamoHttpServletResponse;
import atg.servlet.ServletUtil;

public class ActorInvokerPropertyCustomizer implements PropertyCustomizer {
  
  public static String CLASS_VERSION = "$Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/Mobile/src/atg/service/filter/bean/ActorInvokerPropertyCustomizer.java#1 $$Change: 842324 $";
  
  private ModelMapFactory mModelMapFactory;

  /** @see atg.service.actor.ModelMapFactory */
  public ModelMapFactory getModelMapFactory() {
    return mModelMapFactory;
  }

  /** @see atg.service.actor.ModelMapFactory */
  public void setModelMapFactory(ModelMapFactory pModelMapFactory) {
    mModelMapFactory = pModelMapFactory;
  }

  private ActorContextFactory mActorContextFactory;

  /** @see atg.service.actor.ActorContextFactory */
  public ActorContextFactory getActorContextFactory() {
    return mActorContextFactory;
  }

  /** @see atg.service.actor.ActorContextFactory */
  public void setActorContextFactory(ActorContextFactory pActorContextFactory) {
    mActorContextFactory = pActorContextFactory;
  }
  
  public Object getPropertyValue(Object pTargetObject, String pPropertyName, Map<String,String> pAttributes) throws BeanFilterException {
    ActorContext actorContext = getActorContextFactory().createActorContext();
    
    String objectParameterName = pAttributes.get("objectParameterName");
    if (objectParameterName != null) {
      actorContext.putAttribute(objectParameterName, pTargetObject);
    }
    
    String propertyParameterName = pAttributes.get("propertyParameterName");
    if (propertyParameterName != null) {
      Object object;
      try {
        object = DynamicBeans.getPropertyValue(pTargetObject, pPropertyName);
      } catch (PropertyNotFoundException e1) {
        throw new BeanFilterException(e1);
      }
      actorContext.putAttribute(propertyParameterName, object);
    }
    
    ActorUtils.putActorChainId(actorContext, pAttributes.get("chain-id"));
   
    ModelMap modelMap = getModelMapFactory().createModelMap();
    Object actorPathObj = ServletUtil.getCurrentRequest().resolveName(pAttributes.get("actor-path"));
    if (actorPathObj == null || !(actorPathObj instanceof Actor)) {
      throw new BeanFilterException("Invalid actor-path specified");
    }
    
    Actor actor = (Actor) actorPathObj;
    
    try {
      actor.act(actorContext, modelMap);
    } catch (ActorException e) {
      throw new BeanFilterException(e);
    }

    // we probably don't want forwards/redirects happening when we're filtering properties,
    // but they might.
    DynamoHttpServletResponse response = ServletUtil.getCurrentResponse();
    if (response != null && response.isCommitted()) {
      return null;
    }
    
    if (modelMap instanceof Map) {
      Map<?,?> output = (Map<?,?>) modelMap;
      if (output.size() == 1) {
        return output.values().toArray()[0];
      } else if (output.size() == 0) {
        return null;
      }
    }
    return modelMap;
    
//    Map<FilterOptionKey,Object> filterOptions = new HashMap<FilterOptionKey,Object>();
//    
//    BeanFilterRegistry beanFilterRegistry = (BeanFilterRegistry) Nucleus.getGlobalNucleus().resolveName("/atg/dynamo/service/filter/bean/BeanFilterService");
//    
//    Object filteredModelMap = beanFilterRegistry.applyFilter(modelMap,filterOptions);
//    

//    
//    return filteredModelMap;

  }
}
