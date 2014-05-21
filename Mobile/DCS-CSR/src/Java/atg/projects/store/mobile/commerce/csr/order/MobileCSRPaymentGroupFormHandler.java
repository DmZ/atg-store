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

import atg.commerce.csr.order.CSRPaymentGroupFormHandler;
import atg.commerce.order.purchase.CommerceIdentifierPaymentInfo;
import atg.servlet.DynamoHttpServletRequest;
import atg.servlet.DynamoHttpServletResponse;

import javax.servlet.ServletException;
import java.io.IOException;
import java.util.List;

/**
 * This class overrides the <code>CSRPaymentGroupFormHandler</code> in order to suppress the creation of the ORDERAMOUNTREMAINING
 * relationship.  The Mobile CSR client handles this itself.
 *
 * @author ATG
 * @version: $Id: //product/DAS/main/Java/atg
 * @updated: $DateTime: 13:33
 */
public class MobileCSRPaymentGroupFormHandler extends CSRPaymentGroupFormHandler {

  //-------------------------------------
  /** Class version string */
  //-------------------------------------
  public static final String CLASS_VERSION = "$Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/Mobile/DCS-CSR/src/atg/projects/store/mobile/commerce/csr/order/MobileCSRPaymentGroupFormHandler.java#2 $$Change: 838976 $";

  private boolean mSuppressOrderAmountRemainingRelationship = false;

  /**
   * Configures this form handler to suppress the <code>ORDERAMOUNTREMAINING</code> relationship.
   *
   * @param pSuppress to suppress or not to suppress
   */
  public void setSuppressOrderAmountRemainingRelationship(boolean pSuppress) {
    mSuppressOrderAmountRemainingRelationship = pSuppress;

    if (mSuppressOrderAmountRemainingRelationship) {
      suppressOrderAmountRemainingPaymentGroup();
    }
  }

  /**
   * Is the <code>ORDERAMOUNTREMAINING</code> relationship being suppressed?
   * @return true if the relationship is being removed
   */
  public boolean isSuppressOrderAmountRemainingRelationship() {
    return mSuppressOrderAmountRemainingRelationship;
  }

  /**
   * Finds the CommerceIdentifierPaymentInfo object that has an <code>ORDERAMOUNTREMAINING</code> relationship, and converts it to a
   * <code>ORDERAMOUNT</code> relationship that no longer contains the remaining amount for the order.  This allows an arbitrary amount to be assigned
   * to that payment info.  This method must be called prior to payment amounts being set on the CommerceIdentifierPaymentInfo items and before
   * handleApplyPaymentGroups is called, otherwise this method will overwrite the payment amount to 0 for the CommerceIdentifierPaymentInfo that previously
   * contained the <code>ORDERAMOUNTREMAINING</code> relationship.
   */
  public void suppressOrderAmountRemainingPaymentGroup() {
    List commerceIdentifierPaymentInfos = getCommerceIdentifierPaymentInfoContainer().getAllCommerceIdentifierPaymentInfos();

    for (Object info : commerceIdentifierPaymentInfos) {
      CommerceIdentifierPaymentInfo cipo = (CommerceIdentifierPaymentInfo) info;
      if (cipo.getRelationshipType().equals(cipo.getAmountRemainingType())) {
        cipo.setRelationshipType(cipo.getAmountType());
        cipo.setAmount(0.0);
        // there can only be one ORDERAMOUNTREMAINING relationship, so we can break once we've found it.
        break;
      }
    }
  }

  /**
   * Overrides the superclass method in order to prevent that superclass method being called if <code>isSuppressOrderAmountRemainingRelationship</code>
   * is <code>true</code>.
   *
   * @param pRequest a <code>DynamoHttpServletRequest</code> value
   * @param pResponse a <code>DynamoHttpServletResponse</code> value
   * @throws ServletException
   * @throws IOException
   */
  public void preApplyPaymentGroups(DynamoHttpServletRequest pRequest,
                                    DynamoHttpServletResponse pResponse) throws ServletException, IOException {
    if (!mSuppressOrderAmountRemainingRelationship || getCSRAgentTools().getCSREnvironmentTools().isReturnExchange())
      super.preApplyPaymentGroups(pRequest, pResponse);
  }
}
