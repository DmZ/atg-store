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
package atg.projects.store.assembler.navigation;

import java.util.List;

import com.endeca.infront.navigation.NavigationState;
import com.endeca.infront.navigation.UserState;
import com.endeca.infront.navigation.model.RangeFilter;

import atg.endeca.assembler.navigation.NavigationStateProcessor;


/**
 * This navigation state processor determines whether price range is applied to the current search request
 * and if not, adds NoPriceRange user segment to the navigation state. The NoPriceRange user segment allows
 * us to configure brand landing page in XM to be displayed only when no other dimensions or price range
 * are selected by the user.
 * 
 * @author Natallia Paulouskaya
 * @version $Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/Endeca/Assembler/src/atg/projects/store/assembler/navigation/PriceRangeNavigationStateProcessor.java#1 $$Change: 812282 $
 * @updated $DateTime: 2013/05/30 04:43:11 $$Author: npaulous $
 */
public class PriceRangeNavigationStateProcessor implements NavigationStateProcessor {
  
  //----------------------------------------
  /** Class version string. */
  public static final String CLASS_VERSION = 
    "$Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/Endeca/Assembler/src/atg/projects/store/assembler/navigation/PriceRangeNavigationStateProcessor.java#1 $$Change: 812282 $";
  
  //----------------------------------------------------------------------------
  // PROPERTIES
  //----------------------------------------------------------------------------
  
  //----------------------------------------------
  // property: rangeFilterPropertyName
  //----------------------------------------------
  private String mRangeFilterPropertyName;
  
  /**
   * The range filter's property name to add dimension for.
   * @return The range filter's property name to add dimension for.
   */
  public String getRangeFilterPropertyName() {
    return mRangeFilterPropertyName;
  }
  
  /**
   * Sets the range filter's property name to add dimension for.
   * @param pRangeFilterPropertyName - The range filter's property name to add dimension for.
   */
  public void setRangeFilterPropertyName(String pRangeFilterPropertyName) {
    mRangeFilterPropertyName = pRangeFilterPropertyName;
  }
  
  //----------------------------------
  // property: userState
  //----------------------------------
  private UserState mUserState = null;
  
  /**
   *  The userState object used to hold the user segment for use within Experience Manager to
   *  control routing the user to the brand landing page instead of the search results page.
   * @param pUserState - The userState object used to hold the user segment for use within Experience Manager to
   *                     control routing the user to the brand landing page instead of the search results page.
   */
  public void setUserState(UserState pUserState) {
    mUserState = pUserState;
  }

  /**
   * Returns  the userState object used to hold the user segment for use within Experience Manager to
   * control routing the user to the brand landing page instead of the search results page.
   * @return  The userState object used to hold the user segment for use within Experience Manager to
   *          control routing the user to the brand landing page instead of the search results page.
   */
  public UserState getUserState() {
    return mUserState;
  }
    
  //---------------------------------
  // property: userSegment
  //---------------------------------
  private String mUserSegment = null;

  /**
   * Sets the user segment to set on the user state and used within Experience Manager to 
   * control routing the user to the brand landing page instead of the search results page.
   * @param pUserSegment - The user segment to set on the user state and used within Experience Manager to 
   *                       control routing the user to the brand landing page instead of the search results page.
   */
  public void setUserSegment(String pUserSegment) {
    mUserSegment = pUserSegment;
  }
  
  /**
   * Returns the user segment to set on the user state and used within Experience Manager to 
   * control routing the user to the brand landing page instead of the search results page.
   * @return The user segment to set on the user state and used within Experience Manager to 
   *         control routing the user to the brand landing page instead of the search results page.
   */
  public String getUserSegment() {
    return mUserSegment;
  }

  /**
   * Add the NoPriceRange user segment. We only do this when there are
   * no price range filters. This is because we only want to land
   * on the brand landing page when only a brand is selected. 
   */
  @Override
  public void process(NavigationState pNavigationState) {

    // Check if the price range filter is applied to the navigation state and if not,
	// add NoPriceRange user segment.
    if (!isRangeFilterApplied(pNavigationState)){
      getUserState().addUserSegments(getUserSegment());
    }
  }
  
  /**
   * Checks whether price range filter presents in the navigation state.
   * @param pNavigationState - The NavigationState object that holds the current search/range filters.
   * @return <code>true</code> If price range filter presents in the navigation state.
   */
  public boolean isRangeFilterApplied(NavigationState pNavigationState){
    List<RangeFilter> rangeFilters = pNavigationState.getFilterState().getRangeFilters();
    for (RangeFilter rangeFilter : rangeFilters){
      if (rangeFilter.getPropertyName().equals(getRangeFilterPropertyName())){
        return true;
      }
    }
    return false;
  }
 
}
