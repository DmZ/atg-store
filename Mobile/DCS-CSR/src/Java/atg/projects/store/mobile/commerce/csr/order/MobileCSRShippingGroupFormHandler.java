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
import java.util.Arrays;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;

import atg.commerce.CommerceException;
import atg.commerce.csr.order.CSRShippingGroupFormHandler;
import atg.commerce.inventory.InventoryException;
import atg.commerce.inventory.LocationInventoryManager;
import atg.commerce.order.*;
import atg.commerce.order.purchase.CommerceItemShippingInfo;
import atg.commerce.util.RepeatingRequestMonitor;
import atg.core.util.StringUtils;
import atg.servlet.DynamoHttpServletRequest;
import atg.servlet.DynamoHttpServletResponse;
import javax.transaction.*;

/**
 * Mobile extensions to CSRShippingGroupFormHandler to support:
 *
 * - Applying shipping methods by shipping group ID
 *   Set parameters on the request: shippingGroupId = shipping method, e.g. sg10001=Ground
 *
 * - Moving commerce items to a different shipping group in the shipping group map container
 *   Set toShippingGroupName to the key of the shipping group from the SGMC, commerceItemIds to the commerce item IDs to move, 
 *   and set on the request the shipping group IDs that the commerce items are moving from (commerceItemId = fromShippingGroupId), 
 *
 * - Moving commerce items to an in-store shipping group
 *   Set toLocationId, commerceItemIds
 *
 * - Checking inventory before moving items to different shipping group
 *   outOfStockItems will contain a list of CommerceItems that were not moved due to destination stock levels.
 *   
 * - handleResetShippingGroups to move all items to a new default (hardgood) shipping group, allowing compatibility
 *   with CRS which doesn't currently support in-store pickup or multiple sgs on iOS apps
 *
 * @author ATG
 * @version $Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/Mobile/DCS-CSR/src/atg/projects/store/mobile/commerce/csr/order/MobileCSRShippingGroupFormHandler.java#7 $$Change: 851342 $
 * @updated $DateTime: 2013/11/13 15:15:27 $$Author: mjanulaw $
 */
public class MobileCSRShippingGroupFormHandler extends
  CSRShippingGroupFormHandler {

  //-------------------------------------
  /** Class version string */
  //-------------------------------------
  public static final String CLASS_VERSION = "$Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/Mobile/DCS-CSR/src/atg/projects/store/mobile/commerce/csr/order/MobileCSRShippingGroupFormHandler.java#7 $$Change: 851342 $";

  protected String mToShippingGroupName;
  protected String mToLocationId;
  protected String[] mCommerceItemIds;
  protected LocationInventoryManager mInventoryManager;
  protected List<CommerceItem> mOutOfStockItems = new ArrayList<CommerceItem>();
  protected String mResetShippingGroupsErrorURL;
  protected String mResetShippingGroupsSuccessURL;

  public void setResetShippingGroupsSuccessURL(String pResetShippingGroupsSuccessURL){
    mResetShippingGroupsSuccessURL = pResetShippingGroupsSuccessURL;
  }

  public String getResetShippingGroupsSuccessURL(){
    return mResetShippingGroupsSuccessURL;
  }

  public void setResetShippingGroupsErrorURL(String pResetShippingGroupsErrorURL){
    mResetShippingGroupsErrorURL = pResetShippingGroupsErrorURL;
  }

  public String getResetShippingGroupsErrorURL(){
    return mResetShippingGroupsErrorURL;
  }

  /**
   * Returns the name of the destination shipping group (from the shipping group map container)
   * @return mToShippingGroupName
   */
  public String getToShippingGroupName() {
    return mToShippingGroupName;
  }

  public void setToShippingGroupName(String pToShippingGroupName) {
    mToShippingGroupName = pToShippingGroupName;
  }

  /**
   * Returns the locationId used when moving items to an InStorePickupShippingGroup
   * @return mLocationId
   */
  public String getToLocationId() {
    return mToLocationId;
  }

  public void setToLocationId(String pToLocationId) {
    mToLocationId = pToLocationId;
  }

  /**
   * The IDs of the commerce items to move
   * @return mCommerceItemIds
   */
  public String[] getCommerceItemIds() {
    return mCommerceItemIds;
  }

  public void setCommerceItemIds(String[] pCommerceItemIds) {
    mCommerceItemIds = pCommerceItemIds;
  }

  /**
   * The inventory manager used for querying stock levels
   * @return mInventoryManager
   */
  public LocationInventoryManager getInventoryManager() {
    return mInventoryManager;
  }

  public void setInventoryManager(LocationInventoryManager pInventoryManager) {
    mInventoryManager = pInventoryManager;
  }

  /**
   * The list of commerce items that were not moved to a different shipping group,
   * due to insufficient stock levels
   * @return mOutOfStockItems
   */
  public List<CommerceItem> getOutOfStockItems() {
    return mOutOfStockItems;
  }

  public void setOutOfStockItems(List<CommerceItem> pOutOfStockItems) {
    mOutOfStockItems = pOutOfStockItems;
  }

  @Override
  public void preApplyShippingGroups(DynamoHttpServletRequest pRequest,
                                     DynamoHttpServletResponse pResponse)
    throws ServletException, IOException {
    super.preApplyShippingGroups(pRequest, pResponse);

    Map<?,?> shippingGroupMap = getShippingGroupMapContainer().getShippingGroupMap();

    // if we're trying to move commerce items to an in-store pickup shipping group,
    // create it if it doesn't exist in the sg map container
    if (!StringUtils.isEmpty(getToLocationId())) {
      Object obj = shippingGroupMap.get(getToLocationId());
      if (obj == null) {
        Object matchingSG = null;
        try {
          matchingSG = getShippingGroupManager().createShippingGroup("inStorePickupShippingGroup");
        } catch (CommerceException e) {
          addUncheckedFormException(e);
          return;
        }
        if(matchingSG instanceof InStorePickupShippingGroup) {
          InStorePickupShippingGroup ispsg = (InStorePickupShippingGroup) matchingSG;
          ispsg.setLocationId(getToLocationId());
          if(getProfile() != null) {
            ispsg.setFirstName((String)getProfile().getPropertyValue(getConfiguration().getCommercePropertyManager().getFirstNamePropertyName()));
            ispsg.setLastName((String)getProfile().getPropertyValue(getConfiguration().getCommercePropertyManager().getLastNamePropertyName()));
          }
          getShippingGroupMapContainer().addShippingGroup(getToLocationId(), ispsg);
        }
      }
      setToShippingGroupName(getToLocationId());
    }

    if (StringUtils.isEmpty(getToShippingGroupName()) ||
      getCommerceItemIds() == null) {
      return;
    }
    for (int i = 0; i < getCommerceItemIds().length; i++) {
      String cId = getCommerceItemIds()[i];
      String fromShippingGroupId = pRequest.getParameter(cId);
      if (StringUtils.isEmpty(fromShippingGroupId)) {
        continue;
      }

      String fromShippingGroupName = null;
      // check if the shipping group is in the map with the given id (for in-store shipping groups)
      if (shippingGroupMap.get(fromShippingGroupId) != null) {
        fromShippingGroupName = fromShippingGroupId;
      } else {
        // get the name from the SGMap for the shipping group commerce ID 
        for (Object obj : shippingGroupMap.entrySet()) {
          Map.Entry entry = (Map.Entry) obj;
          if (((ShippingGroup)entry.getValue()).getId().equals(fromShippingGroupId)) {
            fromShippingGroupName = (String) entry.getKey();
            break;
          }
        }
      }
      // if we haven't found it, it's possible that the shippingGroupName on the CISI is null
      List<?> cisis = getCommerceItemShippingInfoContainer().getCommerceItemShippingInfos(cId);
      // find the CISI that matches the fromShippingGroupName, then set new shipping group/method
      for (Object obj : cisis) {
        CommerceItemShippingInfo cisi = (CommerceItemShippingInfo)obj;
        if ((fromShippingGroupName != null && fromShippingGroupName.equals(cisi.getShippingGroupName())) || (fromShippingGroupName == null && cisi.getShippingGroupName() == null)) {
          // only change the shipping group if this item is in stock at that location
          if (isInStock(cisi.getCommerceItem().getCatalogRefId(), cisi.getQuantity(), getToLocationId())) {
            cisi.setShippingGroupName(getToShippingGroupName());
            if (!StringUtils.isEmpty(getShippingMethod())) {
              cisi.setShippingMethod(getShippingMethod());
            }
          } else {
            // item is not in stock, add it to list of commerce items that weren't moved out of their shipping group
            getOutOfStockItems().add(cisi.getCommerceItem());
          }
        }
      }
    }
  }

  protected boolean isInStock(String pSkuId, long pQuantity, String pLocationId) {
    try {
      return getInventoryManager().queryStockLevel(pSkuId, pLocationId) >= pQuantity;
    } catch (InventoryException e) {
      vlogDebug(e, "Exception while checking if item {} at location {} is in stock", pSkuId, pLocationId);
      return false;
    }
  }

  /**
   * Apply shipping methods to shipping groups contained in the shopping cart, 
   * from request parameters: shippingGroupId -> shipping method
   */
  @Override
  public void preApplyShippingMethods(DynamoHttpServletRequest pRequest,
                                      DynamoHttpServletResponse pResponse)
    throws ServletException, IOException {
    super.preApplyShippingMethods(pRequest, pResponse);

    List<?> shippingGroups = getOrder().getShippingGroups();
    for (Object obj : shippingGroups) {
      ShippingGroup shippingGroup = (ShippingGroup) obj;
      String shippingGroupId = shippingGroup.getId();
      String requestParamValue = pRequest.getParameter(shippingGroupId);
      if (!StringUtils.isEmpty(requestParamValue)) {
        shippingGroup.setShippingMethod(requestParamValue);
      }
    }
  }

  public boolean handleResetShippingGroups(DynamoHttpServletRequest pRequest, DynamoHttpServletResponse pResponse)
    throws ServletException, IOException{

    RepeatingRequestMonitor rrm = getRepeatingRequestMonitor();
    Transaction tr = null;
    String myHandleMethod = "MobileCSRShippingGroupFormHandler.handleResetShippingGroups";
    if ((rrm == null) || (rrm.isUniqueRequestEntry(myHandleMethod))) {
      try {
        tr = ensureTransaction();

        if (getUserLocale() == null) setUserLocale(getUserLocale(pRequest, pResponse));

        if (!checkFormRedirect(null, getResetShippingGroupsErrorURL(), pRequest, pResponse)) {
          return false;
        }
        
        synchronized(getOrder()) {
          preResetShippingGroups(pRequest, pResponse);
  
          resetShippingGroups(pRequest, pResponse);
  
          if (!checkFormRedirect(null, getResetShippingGroupsErrorURL(), pRequest, pResponse))
            return false;
  
          postResetShippingGroups(pRequest, pResponse);
          
          try {
            getOrderManager().updateOrder(getShoppingCart().getCurrent());
          } catch(CommerceException exc) {
            if (isLoggingError()) {
              logError(exc);
            }
          }
        }
        return checkFormRedirect(getResetShippingGroupsSuccessURL(), getResetShippingGroupsErrorURL(), pRequest, pResponse);
      } finally {
        if (tr != null) commitTransaction(tr);
        if (rrm != null)
          rrm.removeRequestEntry(myHandleMethod);
      }
    }
    else {
      return false;
    }
  }

  public void preResetShippingGroups(DynamoHttpServletRequest pRequest,
                                             DynamoHttpServletResponse pResponse) {
  }

  public void resetShippingGroups(DynamoHttpServletRequest pRequest, DynamoHttpServletResponse pResponse)
    throws ServletException, IOException{

    //Map<?,?> shippingGroupMap = getShippingGroupMapContainer().getShippingGroupMap();

    OrderImpl shoppingCart = (OrderImpl)getShoppingCart().getCurrent();

    ShippingGroup shippingGroup;
    try {
      shippingGroup = getShippingGroupManager().createShippingGroup("hardgoodShippingGroup");
    }
    catch (CommerceException e) {
      addUncheckedFormException(e);
      return;
    }

    getShippingGroupMapContainer().addShippingGroup(shippingGroup.getId(), shippingGroup);
    HardgoodShippingGroup hardgoodShippingGroup = (HardgoodShippingGroup)shippingGroup;

    //cycle through the commerce items
    for(int i=0; i < shoppingCart.getCommerceItems().size();i++){
      CommerceItemImpl commerceItem = (CommerceItemImpl)shoppingCart.getCommerceItems().get(i);

      //get the commerce items shipping infos
      List<?> cisis = getCommerceItemShippingInfoContainer().getCommerceItemShippingInfos(commerceItem.getId());

      for (Object obj : cisis) {
        CommerceItemShippingInfo commerceItemShippingInfo = (CommerceItemShippingInfo)obj;
        commerceItemShippingInfo.setShippingGroupName(hardgoodShippingGroup.getId());
        commerceItemShippingInfo.setShippingMethod("hardgoodShippingGroup");
      }
    }

    try {
      getCommerceItemShippingInfoTools().applyCommerceItemShippingInfos(getCommerceItemShippingInfoContainer(),getShippingGroupMapContainer(),getShoppingCart().getCurrent(), true, false);
    } catch (CommerceException e) {
      if (isLoggingError()) {
        logError(e);
      }
      processException(e, MSG_ERROR_UPDATE_SHIPPINGGROUP, pRequest, pResponse);
    }
  }


  public void postResetShippingGroups(DynamoHttpServletRequest pRequest,
                                              DynamoHttpServletResponse pResponse){
    // make sure order has at least a default payment group, so it can be used in CRS
    if (getOrder().getPaymentGroupCount() == 0) {
      OrderTools orderTools = getOrderManager().getOrderTools();
      PaymentGroup paymentGroup;
      try {
        paymentGroup = orderTools.createPaymentGroup(orderTools.getDefaultPaymentGroupType());
        getOrder().addPaymentGroup(paymentGroup);
      } catch (CommerceException e) {
        vlogError(e, "Error adding default payment group to order {}", getOrder().getId());
      }
    }
  }

}
