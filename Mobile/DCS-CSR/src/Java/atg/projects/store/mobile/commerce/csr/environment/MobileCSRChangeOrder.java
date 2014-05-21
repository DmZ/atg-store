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

package atg.projects.store.mobile.commerce.csr.environment;

import atg.commerce.csr.environment.ChangeOrder;
import atg.servlet.DynamoHttpServletRequest;
import atg.servlet.DynamoHttpServletResponse;

import javax.servlet.ServletException;
import java.io.IOException;

/**
 * Extends the DCS-CSR <code>ChangeOrder</code> class in order to ensure redirect URLs are constructed correctly.  This is a workaround for an
 * issue in <code>EnvironmentChangeFormHandler</code> that in some cases forces all redirect URLs to begin with '/agent', which is not what we want
 * for REST calls.
 *
 * @author ATG
 * @version: $Id: //product/DAS/main/Java/atg
 * @updated: $DateTime: 12:09
 */
public class MobileCSRChangeOrder extends ChangeOrder {

  //-------------------------------------
  /** Class version string */

  public static String CLASS_VERSION = "$Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/Mobile/DCS-CSR/src/atg/projects/store/mobile/commerce/csr/environment/MobileCSRChangeOrder.java#1 $$Change: 835668 $";

  // should we ensure redirect URLs are REST URLs?
  private boolean mEnsureRestURLs = false;

  /**
   * Does this class insist upon all redirect URLs being REST URLs?
   *
   * @return true if ensuring redirect URLs are REST URLs
   */
  public boolean isEnsureRestURLs() {
    return mEnsureRestURLs;
  }

  /**
   * Configures whether or not this class should ensure all redirect URLs are REST URLs.
   *
   * @param pEnsureRestURLs true if this class should ensure all redirect URLs are REST URLs.
   */
  public void setEnsureRestURLs(boolean pEnsureRestURLs) {
    mEnsureRestURLs = pEnsureRestURLs;
  }

  // the context root for REST services
  private String mRestContextRoot = "/rest";

  /**
   * The context root for REST services
   * @return the REST context root.
   */
  public String getRestContextRoot() {
    return mRestContextRoot;
  }

  /**
   * Sets the REST context root.
   *
   * @param pRestContextRoot the context root.
   */
  public void setRestContextRoot(String pRestContextRoot) {
    mRestContextRoot = pRestContextRoot;
  }

  /**
   * Performs post processing by ensuring each of this form handler's redirect URLs is valid, forcing them to be REST URLs if
   * <code>isEnsureRestURLs</code> is true..
   */
  @Override
  protected boolean postChangeEnvironment(DynamoHttpServletRequest pRequest,
                                          DynamoHttpServletResponse pResponse) throws ServletException, IOException {
    boolean result = super.postChangeEnvironment(pRequest, pResponse);

    if (isLoggingDebug()) {
      logDebug("Ensuring all redirection URLs are REST URLs...");
    }

    if (isEnsureRestURLs() && !getRestContextRoot().equalsIgnoreCase(getEnvironmentTools().getAgentApplicationContextRoot())) {

      if (getSuccessURL().startsWith(getEnvironmentTools().getAgentApplicationContextRoot()))
        setSuccessURL(getSuccessURL().replace(getEnvironmentTools().getAgentApplicationContextRoot(), getRestContextRoot()));

      if (getErrorURL().startsWith(getEnvironmentTools().getAgentApplicationContextRoot()))
        setErrorURL(getErrorURL().replace(getEnvironmentTools().getAgentApplicationContextRoot(), getRestContextRoot()));

      if (getConfirmURL().startsWith(getEnvironmentTools().getAgentApplicationContextRoot()))
        setConfirmURL(getConfirmURL().replace(getEnvironmentTools().getAgentApplicationContextRoot(), getRestContextRoot()));

      if (getConfirmPromptURL().startsWith(getEnvironmentTools().getAgentApplicationContextRoot()))
        setConfirmPromptURL(getConfirmPromptURL().replace(getEnvironmentTools().getAgentApplicationContextRoot(), getRestContextRoot()));
    }

    return result;
  }

}
