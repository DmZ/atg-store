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

package atg.projects.store.assembler.cartridge.handler;

import atg.endeca.assembler.AssemblerTools;
import atg.projects.store.assembler.cartridge.StoreAnnouncementsContentItem;
import atg.repository.Query;
import atg.repository.QueryBuilder;
import atg.repository.QueryExpression;
import atg.repository.QueryOptions;
import atg.repository.Repository;
import atg.repository.RepositoryException;
import atg.repository.RepositoryItem;
import atg.repository.RepositoryView;
import atg.repository.SortDirective;
import atg.repository.SortDirectives;
import atg.servlet.ServletUtil;
import com.endeca.infront.assembler.BasicContentItem;
import com.endeca.infront.assembler.CartridgeHandlerException;
import com.endeca.infront.assembler.ContentItem;
import com.endeca.infront.cartridge.NavigationCartridgeHandler;

/**
 * Cartridge handler that retrieves X store announcements where X is the number of items configured in the Cartridge.
 *
 * @author pmacrory
 * @version: $Id: //product/DAS/main/Java/atg
 * @updated: $DateTime: 15:23
 */
public class StoreAnnouncementsHandler extends NavigationCartridgeHandler<ContentItem, StoreAnnouncementsContentItem> {

  //-------------------------------------
  /** Class version string */

  public static String CLASS_VERSION = "$Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/Mobile/DCS-CSR/Endeca/src/atg/projects/store/assembler/cartridge/handler/StoreAnnouncementsHandler.java#2 $$Change: 847832 $";

  protected final static String ITEM_COUNT = "itemCount";
  protected final static int DEFAULT_ITEMS_AMOUNT = 12;

  //--------------------------------------------------------------------------//
  // Properties
  //--------------------------------------------------------------------------//

  //--------------------------------------------------------------------------//
  /** Property storeTextRepository */
  private Repository mStoreTextRepository = null;

  /**
   * The StoreText repository instance
   * @return the repository
   */
  public Repository getStoreTextRepository() {
    return mStoreTextRepository;
  }

  /**
   * Sets the StoreText repository
   * @param pStoreTextRepository the repository
   */
  public void setStoreTextRepository(Repository pStoreTextRepository) {
    mStoreTextRepository = pStoreTextRepository;
  }

  //--------------------------------------------------------------------------//
  /** Property storeAnnouncementsItemDescriptor */
  private String mStoreAnnouncementsItemDescriptor = null;

  /**
   * The name of the itemDescriptor for store announcements
   * @return the itemDescriptor name
   */
  public String getStoreAnnouncementsItemDescriptor() {
    return mStoreAnnouncementsItemDescriptor;
  }

  /**
   * Sets the name of the storeAnnouncements itemDescriptor
   * @param pStoreAnnouncementsItemDescriptor the itemDescriptor name
   */
  public void setStoreAnnouncementsItemDescriptor(String pStoreAnnouncementsItemDescriptor) {
    mStoreAnnouncementsItemDescriptor = pStoreAnnouncementsItemDescriptor;
  }

  //--------------------------------------------------------------------------//
  /** Property enabledPropertyName */
  private String mEnabledPropertyName = "enabled";

  /**
   * The name of the enabled property.
   * @return the enabled property name
   */
  public String getEnabledPropertyName() {
    return mEnabledPropertyName;
  }

  /**
   * Sets the name of the enabled property
   * @param pEnabledPropertyName the enabled property name
   */
  public void setEnabledPropertyName(String pEnabledPropertyName) {
    mEnabledPropertyName = pEnabledPropertyName;
  }

  //--------------------------------------------------------------------------//
  /** Property creationTimePropertyName */
  private String mCreationTimePropertyName = "creationTime";

  /**
   * The name of the creationTime property.
   * @return the creationTime property name
   */
  public String getCreationTimePropertyName() {
    return mCreationTimePropertyName;
  }

  /**
   * Sets the name of the creationTime property
   * @param pCreationTimePropertyName the creationTime property name
   */
  public void setCreationTimePropertyName(String pCreationTimePropertyName) {
    mCreationTimePropertyName = pCreationTimePropertyName;
  }

  //--------------------------------------------------------------------------//
  /** Property storesPropertyName */
  private String mStoresPropertyName = "stores";

  /**
   * The name of the stores property.
   * @return the stores property name
   */
  public String getStoresPropertyName() {
    return mStoresPropertyName;
  }

  /**
   * Sets the name of the stores property
   * @param pStoresPropertyName the stores property name
   */
  public void setStoresPropertyName(String pStoresPropertyName) {
    mStoresPropertyName = pStoresPropertyName;
  }

  //--------------------------------------------------------------------------//
  // Methods
  //--------------------------------------------------------------------------//

  /**
   * Create a new BasicContentItem using the passed in ContentItem.
   *
   * @param pContentItem - The cartridge content item to be wrapped.
   * @return a new TargetedItems configuration.
   */
  @Override
  protected ContentItem wrapConfig(ContentItem pContentItem) {
    return new BasicContentItem(pContentItem);
  }

  /**
   * Output the store announcements into the ContentItem.
   *
   * @param pCartridgeConfig - The cartridge content item.
   * @return the StoreAnnouncementsContentItem, populated with the store announcements.
   */
  @Override
  public StoreAnnouncementsContentItem process(ContentItem pCartridgeConfig)
      throws CartridgeHandlerException
  {
    StoreAnnouncementsContentItem contentItem = new StoreAnnouncementsContentItem(pCartridgeConfig);

    int itemCount = contentItem.getIntProperty(ITEM_COUNT, DEFAULT_ITEMS_AMOUNT);
    RepositoryItem[] announcements = null;

    String storeID = ServletUtil.getCurrentRequest().getParameter("storeID");
    AssemblerTools.getApplicationLogging().vlogDebug("Finding announcements for store with ID: {0}.", storeID);

    try {
      RepositoryView announcementsView = getStoreTextRepository().getView(getStoreAnnouncementsItemDescriptor());

      // First section of the Query: is storeList null?
      QueryExpression storeListQueryExpression = announcementsView.getQueryBuilder().createPropertyQueryExpression(getStoresPropertyName());
      Query isNullQuery = announcementsView.getQueryBuilder().createIsNullQuery(storeListQueryExpression);

      // Second section of the Query: does storeList contain the storeID?
      QueryExpression storeIDValueQueryExpression = announcementsView.getQueryBuilder().createConstantQueryExpression(storeID);
      Query containsStoreIDQuery = announcementsView.getQueryBuilder().createIncludesQuery(storeListQueryExpression, storeIDValueQueryExpression);

      // 'OR' Query of sections 1 and 2.
      Query orQuery = announcementsView.getQueryBuilder().createOrQuery(new Query[] {isNullQuery, containsStoreIDQuery});

      // Only return enabled announcements.
      QueryExpression enabledPropertyQueryExpression = announcementsView.getQueryBuilder().createPropertyQueryExpression(getEnabledPropertyName());
      QueryExpression trueQueryExpression = announcementsView.getQueryBuilder().createConstantQueryExpression(true);
      Query isEnabledQuery = announcementsView.getQueryBuilder().createComparisonQuery(enabledPropertyQueryExpression, trueQueryExpression, QueryBuilder.EQUALS);

      // the final query: all announcements that are enabled and either configured for no stores, or configured for the current store.
      Query finalQuery = announcementsView.getQueryBuilder().createAndQuery(new Query[] {isEnabledQuery, orQuery});

      SortDirectives sorting = new SortDirectives();
      sorting.addDirective(new SortDirective(getCreationTimePropertyName(), SortDirective.DIR_DESCENDING));
      QueryOptions options = new QueryOptions(0, itemCount, sorting, null);

      announcements = announcementsView.executeQuery(finalQuery, options);
      AssemblerTools.getApplicationLogging().vlogDebug("Found {0} announcements.", (announcements == null ? 0 : announcements.length));

    } catch (RepositoryException e) {
        AssemblerTools.getApplicationLogging().vlogError("Unable to retrieve store announcements.  An exception occurred.");
    }

    contentItem.setAnnouncements(announcements);
    return contentItem;
  }
}
