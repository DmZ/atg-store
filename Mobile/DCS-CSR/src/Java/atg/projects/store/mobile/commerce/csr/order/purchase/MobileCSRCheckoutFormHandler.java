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

package atg.projects.store.mobile.commerce.csr.order.purchase;

import atg.commerce.CommerceException;
import atg.commerce.order.CreditCard;
import atg.commerce.order.PaymentGroup;
import atg.commerce.order.purchase.ExpressCheckoutFormHandler;
import atg.droplet.DropletFormException;
import atg.projects.store.order.purchase.StoreBillingProcessHelper;
import atg.repository.RepositoryException;
import atg.servlet.DynamoHttpServletRequest;
import atg.servlet.DynamoHttpServletResponse;

import javax.servlet.ServletException;
import java.io.IOException;

/**
 * This class provides checkout functionality used by the Mobile CSR client.
 *
 * @author ATG
 * @version: $Id: //product/DAS/main/Java/atg
 * @updated: $DateTime: 13:33
 */
public class MobileCSRCheckoutFormHandler extends ExpressCheckoutFormHandler {

  public static final String MSG_START_CHECKOUT_ERROR = "errorStartingCheckout";

  //-------------------------------------
  /** Class version string */
  //-------------------------------------
  public static final String CLASS_VERSION = "$Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/Mobile/DCS-CSR/src/atg/projects/store/mobile/commerce/csr/order/purchase/MobileCSRCheckoutFormHandler.java#3 $$Change: 853843 $";

  //--------------------------------------------------
  // Properties
  //--------------------------------------------------

  /**
   * Property BillingHelper
   */
  private StoreBillingProcessHelper mBillingHelper;

  /**
   * The billingHelper object.
   *
   * @return the billing helper
   */
  public StoreBillingProcessHelper getBillingHelper() {
    return mBillingHelper;
  }

  /**
   * Configures the billing helper.
   *
   * @param pBillingHelper the billing helper
   */
  public void setBillingHelper(StoreBillingProcessHelper pBillingHelper) {
    mBillingHelper = pBillingHelper;
  }

  /**
   * property: autoApplyStoreCredits
   */
  boolean mAutoApplyStoreCredits = false;

  /**
   * Set the AutoApplyStoreCredits property.
   *
   * @param pAutoApplyStoreCredits a <code>boolean</code> value.
   *
   * @beaninfo description: Should profile's store credits be auto-applied to the order?
   *           Set to true for auto-applying.
   */
  public void setAutoApplyStoreCredits(boolean pAutoApplyStoreCredits) {
    mAutoApplyStoreCredits = pAutoApplyStoreCredits;
  }

  /**
   * Return the AutoApplyStoreCredits property.
   *
   * @return a <code>boolean</code> value to determine whether to auto-apply store credits or not.
   */
  public boolean isAutoApplyStoreCredits() {
    return mAutoApplyStoreCredits;
  }

  /**
   * property: successURL
   */
  private String mSuccessURL;

  /**
   * The success URL for this form handler.
   *
   * @return the success URL
   */
  public String getSuccessURL() {
    return mSuccessURL;
  }

  /**
   * Configures the success URL for this form handler.
   *
   * @param pSuccessURL the success URL
   */
  public void setSuccessURL(String pSuccessURL) {
    mSuccessURL = pSuccessURL;
  }

  /**
   * property: errorURL
   */
  private String mErrorURL;

  /**
   * The error URL for this form handler.
   *
   * @return the error URL
   */
  public String getErrorURL() {
    return mErrorURL;
  }

  /**
   * Configures the error URL for this form handler.
   *
   * @param pErrorURL the error URL
   */
  public void setErrorURL(String pErrorURL) {
    mErrorURL = pErrorURL;
  }

  //--------------------------------------------------
  // Methods
  //--------------------------------------------------

  /**
   * <code>handleStartCheckout</code> is used to initialize the checkout process by applying store credit, and setting up the payment group.
   *
   * @param pRequest  the servlet's request
   * @param pResponse the servlet's response
   * @return a <code>boolean</code> value
   * @throws IOException      if there was an error with servlet io
   * @throws ServletException if there was an error while executing the code
   */
  public boolean handleStartCheckout(DynamoHttpServletRequest pRequest,
                                     DynamoHttpServletResponse pResponse) throws IOException, ServletException {
    try {
      getPaymentGroupManager().removeAllPaymentGroupsFromOrder(getOrder());

      // This call creates the payment group.
      PaymentGroup paymentGroup = getPaymentGroup();

      if ((paymentGroup == null) || (!(paymentGroup instanceof CreditCard))) {
        String msg = formatUserMessage(MSG_START_CHECKOUT_ERROR, pRequest, pResponse);
        addFormException(new DropletFormException(msg, MSG_START_CHECKOUT_ERROR));
      }

      // apply all available store credits, if configured to do so.
      if (isAutoApplyStoreCredits()) {
        getBillingHelper().setupStoreCreditPaymentGroupsForOrder(getOrder(), getProfile(), getBillingHelper().getStoreCreditIds(getProfile()));
      }
    } catch (CommerceException exec) {
      processException(exec, MSG_START_CHECKOUT_ERROR, pRequest, pResponse);
    } catch (RepositoryException exec) {
      processException(exec, MSG_START_CHECKOUT_ERROR, pRequest, pResponse);
    }

    // persist the changes
    try {
      getOrderManager().updateOrder(getOrder());
    } catch (CommerceException exc) {
      if (isLoggingError()) {
        logError(exc);
      }
    }

    // If no form errors are found, redirect to the success URL,
    // otherwise redirect to the error URL.
    return checkFormRedirect(getSuccessURL(), getErrorURL(),
        pRequest, pResponse);

  }

}
