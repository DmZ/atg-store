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
package atg.projects.store.order;

import java.io.IOException;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.ResourceBundle;
import java.util.Set;

import javax.servlet.ServletException;

import atg.commerce.CommerceException;
import atg.commerce.order.Order;
import atg.commerce.order.OrderManager;
import atg.commerce.order.ShippingGroup;
import atg.commerce.pricing.PricingAdjustment;
import atg.core.i18n.LayeredResourceBundle;
import atg.core.util.StringUtils;
import atg.nucleus.naming.ParameterName;
import atg.repository.RepositoryItem;
import atg.servlet.DynamoHttpServletRequest;
import atg.servlet.DynamoHttpServletResponse;
import atg.servlet.DynamoServlet;
import atg.servlet.RequestLocale;

/**
 * This droplet aggregates shipping promotions from all order's shipping groups
 * and returns the list of shipping promotions applied to the order.
 * <p>
 * Input parameters:
 * <dl>
 *   <dt>orderId</dt>
 *   <dd>The id of the order to return shipping promotions for. Either orderId or
 *   order parameters should be specified</dd>
 *
 *   <dt>order</dt>
 *   <dd>The Order object to return shipping promotions for. Either orderId or
 *   order parameters should be specified</dd>
 * </dl>
 *   
 * Output parameters:
 * <dl>
 *   <dt>shippingPromotions</dt>
 *   <dd>The list of shipping promotions applied to the order.</dd>
 *   <dt>errorMsg</dt>
 *   <dd>If an error occurred this will be the detailed error message
 *   for the user.</dd>
 * </dl>
 * 
 * Open parameters: 
 * <dl>
 *   <dt>output</dt>
 *   <dd>Rendered when some shipping promotions are applied to the order.</dd>
 *   <dt>empty</dt>
 *   <dd>Rendered when there no shipping promotions in the order.</dd>
 *   <dt>error</dt>
 *   <dd>Rendered when some error occurred during droplet's execution.</dd>
 * </dl>
 * 
 * Example of usage:
 * 
 *  &lt;dsp:droplet name="ShippingPromotionsDroplet"&gt;
 *    &lt;dsp:param name="order" value="${order}"/&gt;
 *    &lt;dsp:oparam name="output"&gt;
 *      &lt;dsp:getvalueof var="shippingPromotions" param="shippingPromotions"/&gt;      
 *    &lt;/dsp:oparam&gt;
 *  &lt;/dsp:droplet&gt;
 *    
 * @author ATG
 * @version $Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/EStore/src/atg/projects/store/order/ShippingPromotionsDroplet.java#2 $$Change: 809701 $
 * @updated $DateTime: 2013/05/17 03:27:37 $$Author: npaulous $
 */

public class ShippingPromotionsDroplet extends DynamoServlet{
  
  /** Class version string */
  public static final String CLASS_VERSION = "$Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/EStore/src/atg/projects/store/order/ShippingPromotionsDroplet.java#2 $$Change: 809701 $";
  
  //-------------------------------------
  // Constants
  //-------------------------------------
  
  // Resource bundle settings
  /** Resource bundle name. */
  private static final String RESOURCE_NAME = "atg.commerce.order.UserMessages";
  
  
  // input parameters
  /** The order ID parameter name */
  public final static ParameterName ORDERID = ParameterName.getParameterName("orderId");
  /** The order parameter name */
  public final static ParameterName ORDER = ParameterName.getParameterName("order");
  
  // output parameters
  /** The parameter name for list of shipping promotions.*/
  public final static String SHIPPING_PROMOTIONS = "shippingPromotions";
  /** The output parameter that includes the error message. */
  public final static String ERRORMESSAGE = "errorMsg";
  /** The open parameter that indicates that there was an error */
  public final static String ERROR = "error";
  /** The open parameter that indicates that there is a result */
  public final static String OUTPUT = "output";
  /** The open parameter that indicates that there were no results */
  public final static String EMPTY = "empty";
  
  // Constants used for error messages
  protected static final String MSG_NO_SUCH_ORDER = "NoSuchOrder";
  protected static final String MSG_NO_ORDER_PARAM_SPECIFIED = "NoOrderParamSpecified";
  
  
  //-------------------------------------
  // property: OrderManager
  OrderManager mOrderManager;
  
  /**
   * Sets property OrderManager
   **/
  public void setOrderManager(OrderManager pOrderManager) {
    mOrderManager = pOrderManager;
  }
  
  /**
   * Returns property OrderManager
   **/
  public OrderManager getOrderManager() {
    return mOrderManager;
  }
    
    
  @Override
  public void service(DynamoHttpServletRequest pRequest, DynamoHttpServletResponse pResponse)
      throws ServletException, IOException {

  // Get order object to look shipping promotions for.
    String orderId = (String)pRequest.getLocalParameter(ORDERID);
    Order orderObject = (Order) pRequest.getLocalParameter(ORDER);
    String errorMsg = null;
    
    if (orderObject == null && StringUtils.isEmpty(orderId)){
      errorMsg = formatUserMessage(MSG_NO_ORDER_PARAM_SPECIFIED, pRequest, pResponse);
    }
    
    if (orderObject == null){
      try {
        orderObject =  getOrderManager().loadOrder(orderId);
      } catch (CommerceException e) {
        if (isLoggingError()){
          logError(e);
        }
      }
    }
    if (orderObject == null){
      errorMsg = formatUserMessage(MSG_NO_SUCH_ORDER, pRequest, pResponse);
    }
    
    // If some error occurred service error oparam
    if (errorMsg != null){
      pRequest.setParameter(ERRORMESSAGE, errorMsg);
      pRequest.serviceLocalParameter(ERROR, pRequest, pResponse);
      return;
    }
    
    Set<RepositoryItem> shippingPromotions = getOrderShippingPromotions(orderObject);
    
    //If no shipping promotions service empty open param.
    if (shippingPromotions.isEmpty()){
      pRequest.serviceLocalParameter(EMPTY, pRequest, pResponse);
      return;
    }
    
    pRequest.setParameter(SHIPPING_PROMOTIONS, shippingPromotions);
    pRequest.serviceLocalParameter(OUTPUT, pRequest, pResponse);  
    
    
  }
  
  /**
   * Returns set of shipping promotions applied to the given order.
   * 
   * @param pOrder - Order to retrieve shipping promotions from.
   * @return Set of shipping promotions applied to the given order.
   */  
  protected Set<RepositoryItem> getOrderShippingPromotions(Order pOrder){
    Set<RepositoryItem> shippingPromotions = new HashSet<RepositoryItem>();
    
    @SuppressWarnings("unchecked")
    List<ShippingGroup> shippingGroups = (List<ShippingGroup>)pOrder.getShippingGroups();
    
    for (ShippingGroup sg : shippingGroups){
      if (sg.getPriceInfo() != null){
        
        @SuppressWarnings("unchecked")
        List<PricingAdjustment> adjustments = (List<PricingAdjustment>)sg.getPriceInfo().getAdjustments();
        if (adjustments != null){
          for (PricingAdjustment adjustment : adjustments){
            RepositoryItem promotion = adjustment.getPricingModel();
            if (promotion != null){
              shippingPromotions.add (promotion);
            }
          }
        }
      }
    }
    
    return shippingPromotions;
  }
  
  /**
   * Retrieves a message from default resource bundle. Resource bundle is defined 
   * with {@link #RESOURCE_NAME} field.
   * 
   * @param pResourceKey - key to be searched within a resource bundle.
   * @param pRequest - the HTTP request.
   * @param pResponse - the HTTP response
   * 
   * @return string obtained from the resource bundle.
   */
  protected String formatUserMessage(String pResourceKey, 
                                     DynamoHttpServletRequest pRequest, 
                                     DynamoHttpServletResponse pResponse) {
    
    RequestLocale requestLocale = pRequest.getRequestLocale();
    Locale currentLocale = requestLocale == null ? Locale.getDefault() : requestLocale.getLocale();
    ResourceBundle bundle = LayeredResourceBundle.getBundle(RESOURCE_NAME, currentLocale);
    
    return bundle.getString(pResourceKey);
  } 

}