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



package atg.projects.store.profile;

import atg.core.util.Address;

/**
 * Contains reusable Address methods.
 * 
 * @author ATG
 */
public class StoreAddressTools {

  /** Class version string */
  public static final String CLASS_VERSION = "$Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/EStore/src/atg/projects/store/profile/StoreAddressTools.java#3 $$Change: 796588 $";

  //-----------------------------------
  // METHODS
  //-----------------------------------
  
  /**
   * Compares the properties of two addresses equality. If all properties are
   * equal then the addresses are equal.
   * 
   * @param pAddressA An Address
   * @param pAddressB An Address
   * @return A boolean indicating whether or not pAddressA and pAddressB 
   * represent the same address.
   */
  public static boolean compare(Address pAddressA, Address pAddressB){
    /*
     * Test the actual address objects. We don't want to use .equals to compare
     * the fields as we don't want to compare the owner Id. The address
     * associated with the order wont have an owner Id.
     */
    if(!equal(pAddressA, pAddressB, false)){
      return false;
    }

    /*
     * Test individual address fields that we are interested in. If they are all
     * equal then we say the addresses are equal, even though every property of 
     * both addresses may not be the same.
     */
    if(!equal(pAddressA.getFirstName(), pAddressB.getFirstName(), true)){
      return false;
    }

    if(!equal(pAddressA.getLastName(), pAddressB.getLastName(), true)){
      return false;
    }

    if(!equal(pAddressA.getAddress1(), pAddressB.getAddress1(), true)){
      return false;
    }

    if(!equal(pAddressA.getAddress2(), pAddressB.getAddress2(), true)){
      return false;
    }

    if(!equal(pAddressA.getCity(), pAddressB.getCity(), true)){
      return false;
    }

    if(!equal(pAddressA.getState(), pAddressB.getState(), true)){
      return false;
    }

    if(!equal(pAddressA.getPostalCode(), pAddressB.getPostalCode(), true)){
      return false;
    }

    if(!equal(pAddressA.getCountry(), pAddressB.getCountry(), true)){
      return false;
    }

    return true;
  }
  
  /**
   * Return true if both are null or equal, false otherwise.
   * 
   * @param pOne
   * @param pTwo
   * @param pUseEquals
   * @return
   */
  protected static boolean equal(Object pOne, Object pTwo, 
    boolean pUseEquals)
  {
    if(pOne == null && pTwo != null){
      return false;
    }
    
    if(pOne != null && pTwo == null){
      return false;
    }
    
    if(pOne == null && pTwo == null){
      return true;
    }
    
    if(pUseEquals){
      return pOne.equals(pTwo);
    }
    
    return true; // Both non null, we don't care if they are equal
  }
}
