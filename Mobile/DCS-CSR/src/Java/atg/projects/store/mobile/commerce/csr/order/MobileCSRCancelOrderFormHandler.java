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
import java.util.Map;

import javax.servlet.ServletException;
import javax.transaction.Transaction;

import atg.commerce.csr.environment.CSREnvironmentTools;
import atg.commerce.csr.events.CSRAgentMessagingTools;
import atg.commerce.csr.util.CSRAgentTools;
import atg.commerce.order.Order;
import atg.commerce.util.RepeatingRequestMonitor;
import atg.core.util.ResourceUtils;
import atg.core.util.StringUtils;
import atg.droplet.DropletException;
import atg.servlet.DynamoHttpServletRequest;
import atg.servlet.DynamoHttpServletResponse;
import atg.servlet.ServletUtil;

import atg.commerce.csr.order.CSRCancelOrderFormHandler;

/**
 * Mobile extension to CSROrderFormHandler
 * The MobileCSRCancelOrderFormHandler extends CSRCancelOrderFormHandler to prevent a new order from being created when an order is cancelled
 *
 * @author Paul Woodhead
 * @version $Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/Mobile/DCS-CSR/src/atg/projects/store/mobile/commerce/csr/order/MobileCSRCancelOrderFormHandler.java#2 $$Change: 855468 $
 * @updated $DateTime: 2013/12/05 09:03:38 $$Author: pmacrory $
 * @see atg.droplet.GenericFormHandler
 * @see atg.commerce.order.purchase.CancelOrderFormHandler
 *
 */
public class MobileCSRCancelOrderFormHandler extends CSRCancelOrderFormHandler {

  //-------------------------------------
  // Class version string
  //-------------------------------------

  public static final String CLASS_VERSION = "$Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/Mobile/DCS-CSR/src/atg/projects/store/mobile/commerce/csr/order/MobileCSRCancelOrderFormHandler.java#2 $$Change: 855468 $";

  // Property: createNewCartOnSavedOrderCancel
  protected boolean mCreateNewCartOnSavedOrderCancel;

  /**
   * Should a new cart be created when a saved order is cancelled?
   * @return true if a new cart should be created.
   */
  public boolean getCreateNewCartOnSavedOrderCancel() {
    return mCreateNewCartOnSavedOrderCancel;
  }

  /**
   * Configures whether or not this form handler should create a new cart when cancelling a saved order.
   * @param pCreateNewCartOnSavedOrderCancel create a new cart?
   */
  public void setCreateNewCartOnSavedOrderCancel(boolean pCreateNewCartOnSavedOrderCancel) {
    mCreateNewCartOnSavedOrderCancel = pCreateNewCartOnSavedOrderCancel;
  }

  /**
   * Override the base implementation to create a new transient order and
   * place it in the cart.
   *
   * @param pRequest a <code>DynamoHttpServletRequest</code> value
   * @param pResponse a <code>DynamoHttpServletResponse</code> value
   * @exception ServletException if an error occurs
   * @exception IOException if an error occurs
   */
  public void postCancelOrder(DynamoHttpServletRequest pRequest,
                              DynamoHttpServletResponse pResponse)
    throws ServletException,
    IOException
  {
    boolean createNewCart = true;

    // If we've been configured not to create a new cart post the cancellation of a saved order, then check whether or not the
    // order being cancelled is a saved order.
    if(getShoppingCart().getCurrent() != null && !getCreateNewCartOnSavedOrderCancel()) {
      // it's a saved order is the order being cancelled is not the current shopping cart.
      boolean savedOrder = !getOrderIdToCancel().equals(getShoppingCart().getCurrent().getId());
      createNewCart = !savedOrder;
    }

    if (createNewCart)
      super.postCancelOrder(pRequest, pResponse);
    }
}
