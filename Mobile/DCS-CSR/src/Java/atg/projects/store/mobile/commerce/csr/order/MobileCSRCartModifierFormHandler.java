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

package atg.projects.store.mobile.commerce.csr.order;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import atg.commerce.CommerceException;
import atg.commerce.csr.order.CSRCartModifierFormHandler;
import atg.commerce.order.CommerceItem;
import atg.commerce.order.CommerceItemNotFoundException;
import atg.commerce.order.InvalidParameterException;
import atg.commerce.order.ShippingGroup;
import atg.commerce.order.ShippingGroupCommerceItemRelationship;
import atg.core.util.StringUtils;
import atg.servlet.DynamoHttpServletRequest;
import atg.servlet.DynamoHttpServletResponse;

import javax.servlet.ServletException;

/**
 * Mobile extensions to CSRCartModifierFormHandler
 * - adds a 'shippingGroupNickname' property, that when specified, sets this form handler's shipping group 
 * to the associated value from the shipping group container map. This allows you to associate a commerce 
 * item with a shipping group when adding it to the order, e.g. by setting shippingGroupNickname="Home", 
 * the item will be added to the "Home" shipping group contained in the SG map container. 
 * Note that the SG map container must have been initialized with the ShippingGroupDroplet for this to work.  
 * 
 * @author ATG
 * @version $Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/Mobile/DCS-CSR/src/atg/projects/store/mobile/commerce/csr/order/MobileCSRCartModifierFormHandler.java#4 $$Change: 848728 $
 * @updated $DateTime: 2013/11/04 05:31:51 $$Author: pwoodhea $
 *
 */
public class MobileCSRCartModifierFormHandler extends
    CSRCartModifierFormHandler {
  
  //-------------------------------------
  /** Class version string */
  //-------------------------------------
  public static final String CLASS_VERSION = "$Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/Mobile/DCS-CSR/src/atg/projects/store/mobile/commerce/csr/order/MobileCSRCartModifierFormHandler.java#4 $$Change: 848728 $";

  String mShippingGroupNickname;
  
  public String getShippingGroupNickname() {
    return mShippingGroupNickname;
  }

  // Property: Origin of Order
  private String mOriginOfOrder;

  /**
   * The channel to set as the origin of this order
   * @return the origin of order
   */
  public String getOriginOfOrder() {
    return mOriginOfOrder;
  }

  /**
   * Configures the channel to set as the origin of this order
   * @param pOriginOfOrder the origin of the current order.
   */
  public void setOriginOfOrder(String pOriginOfOrder) {
    mOriginOfOrder = pOriginOfOrder;
  }

  /**
   * Overrides the superclass method in order to set the origin of the order.
   *
   * @param pRequest a value of type 'DynamoHttpServletRequest'
   * @param pResponse a value of type 'DynamoHttpServletResponse'
   * @throws ServletException
   * @throws IOException
   */
  @Override
  public void postAddItemToOrder(DynamoHttpServletRequest pRequest,
                                 DynamoHttpServletResponse pResponse) throws ServletException, IOException {
    super.postAddItemToOrder(pRequest, pResponse);

    if (getOriginOfOrder() != null) {
      getOrder().setOriginOfOrder(getOriginOfOrder());
    }
  }
  
  /**
   * Sets the shipping group on this form handler (which is used during add item to order) by looking up 
   * the specified nickname in the shipping group map container
   * @param pShippingGroupNickname
   */
  public void setShippingGroupNickname(String pShippingGroupNickname) {
    // find the shipping group from the shipping group container service
    ShippingGroup shippingGroup = (ShippingGroup) getShippingGroupMapContainer().getShippingGroup(pShippingGroupNickname);
    if (shippingGroup == null) {
      vlogError("Cannot find shipping group with name {} in shipping group map container", pShippingGroupNickname);
      return;
    }
    
    setShippingGroup(shippingGroup);
    
    // check if the shipping group is already part of the order
    List<?> shippingGroups = getOrder().getShippingGroups();
 
    for (Object obj : shippingGroups) {
      ShippingGroup orderShippingGroup = (ShippingGroup) obj;
      if (shippingGroup.getId().equals(orderShippingGroup.getId())) {
        // already in order, nothing more to do
        return;
      }
    }
    // shipping group not found in order, so add it
    try {
      getShippingGroupManager().addShippingGroupToOrder(getOrder(), shippingGroup);
    } catch (CommerceException e) {
      vlogError("Exception adding shipping group {} to order: {}", shippingGroup.getId(), e);
    }
  }

   /**
    *Get commerce item identifiers for items added via the addItemToOrder Method
    */
   public Map commerceItemIdsForAddedItems(String[] catalogRefIds){
    Map<String, String> commerceItemCatalogRefMap = new HashMap<String, String>();
    List<CommerceItem> commerceItems = getAddItemsToOrderResult();
    for(int i=0; i < catalogRefIds.length; i++){
      String catalogRefId = catalogRefIds[i];
      for (CommerceItem addedItem: commerceItems){
        if(addedItem.getCatalogRefId().equalsIgnoreCase(catalogRefId)){
          commerceItemCatalogRefMap.put(catalogRefId, addedItem.getId());
          continue;
        }
      }
    }
    return commerceItemCatalogRefMap;
  }
  
  /**
   * If removalCommerceIds is set, set removalRelationshipIds by looking them up based on request parameters
   * in the format: commerceItemId=shippingGroupId
   * e.g. removalCommerceIds=[ci10001], request parameter: ci10001=sg10002
   *      will set removalRelationshipIds to the shipping group-commerce item 
   *      relationship between ci10001 and sg10002
   */
  public void preRemoveItemFromOrderByRelationshipId(DynamoHttpServletRequest pRequest,
      DynamoHttpServletResponse pResponse) throws ServletException, IOException {
    super.preRemoveItemFromOrderByRelationshipId(pRequest, pResponse);
    
    if (getRemovalCommerceIds() != null) {
      List<String> relationshipIds = new ArrayList<String>(getRemovalCommerceIds().length);
      for (String commerceItemId : getRemovalCommerceIds()) {
        String shippingGroupId = pRequest.getParameter(commerceItemId);
        if (shippingGroupId == null) {
          vlogDebug("No shipping group specified for commerceItemId: {}", commerceItemId);
          continue;
        }
        
        CommerceItem commerceItem;
        try {
          commerceItem = getOrder().getCommerceItem(commerceItemId);
        } catch (CommerceItemNotFoundException e) {
          vlogDebug(e, "commerceItemId not found: {}", commerceItemId);
          continue;
        } catch (InvalidParameterException e) {
          vlogDebug(e, "commerceItemId: {}", commerceItemId);
          continue;
        }
        List<?> sgCiRels = commerceItem.getShippingGroupRelationships();
        for (Object obj : sgCiRels) {
          ShippingGroupCommerceItemRelationship sgCiRel = (ShippingGroupCommerceItemRelationship)obj;
          if (shippingGroupId.equals(sgCiRel.getShippingGroup().getId())) {
            relationshipIds.add(sgCiRel.getId());
            break;
          }
        }   
      }
      setRemovalRelationshipIds(relationshipIds.toArray(new String[relationshipIds.size()]));
    }
  }
}
