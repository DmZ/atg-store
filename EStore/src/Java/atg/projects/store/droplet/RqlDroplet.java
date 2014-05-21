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
package atg.projects.store.droplet;

import atg.core.util.StringUtils;

import atg.nucleus.naming.ParameterName;

import atg.projects.store.logging.LogUtils;

import atg.repository.Repository;
import atg.repository.RepositoryException;
import atg.repository.RepositoryItem;
import atg.repository.RepositoryView;

import atg.repository.rql.RqlStatement;

import atg.servlet.DynamoHttpServletRequest;
import atg.servlet.DynamoHttpServletResponse;
import atg.servlet.DynamoServlet;

import java.io.IOException;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;

import javax.transaction.*;

/**
 * <p>
 * This droplet is used in favor of the ATG RQLQueryForEach droplet. There are
 * two reasons for this. The first is that this droplet must be configured
 * from outside the JSP to prevent the setting of an RQL query string in the
 * JSP template. The second is that this droplet returns the result set (array
 * of repository items) which allows other droplets to loop through them
 * appropriately (Range for example). It also wraps the results in a
 * transaction, something RQLQueryForEach does not do.
 * </p>
 *
 * <p>
 * The repository, itemDescriptorName, and queryRql properties must be set on
 * the nucleus component that uses this class. For example:
 * <pre>
 *
 *  $class=com.awedirect.base.droplet.RqlDroplet
 *  transactionManager=/atg/dynamo/transaction/TransactionManager
 *  repository=/atg/commerce/catalog/ProductCatalog
 *  itemDescriptorName=promotionRelationship
 *  queryRql=contractType.code = ?0
 *
 * </pre>
 * </p>
 *
 * <p>
 * this droplet takes the following parameters
 *
 * <dl>
 * <dt>
 * numRQLParams
 * </dt>
 * <dd>
 * The parameter that defines the URL, relative or absolute, to which this page
 * that called the servlet will be redirected.
 * </dd>
 * </dl>
 *
 *
 * <dl>
 * <dt>
 * param#
 * </dt>
 * <dd>
 * The parameter.
 * </dd>
 * </dl>
 *
 *
 * <dl>
 * <dt>
 * rqlQuery
 * </dt>
 * <dd>
 * The parameter that defines a rqlQuery
 * </dd>
 * </dl>
 * </p>
 *
 * <p>
 * <b>Example </b><br>
 * <pre>
 *
 *
 *  &lt;dsp:droplet name=&quot;RqlDroplet&quot;&gt;
 *    &lt;param name=&quot;numRQLParams&quot; value=&quot;1&quot;&gt;
 *    &lt;param name=&quot;param0&quot; value=&quot;atg.com&quot;&gt;
 *    &lt;dsp:oparam name=&quot;output&quot;&gt;
 *      &lt;dsp:droplet name=&quot;ForEach&quot;&gt;
 *        &lt;dsp:param name=&quot;array&quot; param=&quot;items&quot;/&gt;
 *        &lt;dsp:oparam name=&quot;output&quot;&gt;
 *          &lt;dsp:getvalueof id=&quot;url&quot; idtype=&quot;java.lang.string&quot; param=&quot;element.url&quot;&gt;
 *          &lt;dsp:a page=&quot;&lt;=url&gt;&quot;&gt;
 *            &lt;dsp:valueof param=&quot;element.name&quot;/&gt;
 *          &lt;/dsp:a&gt;&lt;br&gt;
 *          &lt;/dsp:getvalueof&gt;
 *        &lt;/dsp:oparam&gt;
 *      &lt;/dsp:droplet&gt;
 *    &lt;/dsp:oparam&gt;
 *  &lt;/dsp:droplet&gt;
 *
 *
 * </pre>
 * </p>
 *
 * <p>
 * Parameters: <br>
 * &nbsp;&nbsp; <tt>empty</tt>- Rendered if no results found. <br>
 * &nbsp;&nbsp; <tt>output</tt>- Rendered on successful query. <br>
 * &nbsp;&nbsp;&nbsp;&nbsp; <tt>items</tt>- Array of RepositoryItem object
 * that match the query. <br>
 * </p>
 *
 * @author ATG
 * @version $Revision: #3 $
 */
public class RqlDroplet extends DynamoServlet {
  
  //-----------------------------------
  // STATIC
  //-----------------------------------

  /** Class version string. */
  public static final String CLASS_VERSION = "$Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/EStore/src/atg/projects/store/droplet/RqlDroplet.java#3 $$Change: 794457 $";

  /**
   * XA failure message.
   */
  public static final String XA_FAILURE = "Failure during transaction commit";

  /**
   * Output parameter name.
   */
  public static final ParameterName OUTPUT = ParameterName.getParameterName("output");

  /**
   * Empty parameter name.
   */
  public static final ParameterName EMPTY = ParameterName.getParameterName("empty");

  /**
   * Query RQL parameter name.
   */
  public static final ParameterName QUERY_RQL = ParameterName.getParameterName("queryRQL");

  /**
   * Items name.
   */
  public static final String ITEMS = "items"; 

  //-----------------------------------
  // PROPERTIES
  //-----------------------------------
  
  //-----------------------------------
  // property: repository
  private Repository mRepository;
  
  /**
   * @return The repository used to execute the query against.
   */
  public Repository getRepository() {
    return mRepository;
  }

  /**
   * @param pRepository Set a new repository.
   */
  public void setRepository(Repository pRepository) {
    mRepository = pRepository;
  }
  
  //-----------------------------------
  // property: itemDescriptorName
  private String mItemDescriptorName;

  /**
   * @return item descriptor name.
   */
  public String getItemDescriptorName() {
    return mItemDescriptorName;
  }

  /**
   * @param pItemDescriptorName - item descriptor name.
   */
  public void setItemDescriptorName(String pItemDescriptorName) {
    mItemDescriptorName = pItemDescriptorName;
  }
  
  //-----------------------------------
  // property: queryRql
  private String mQueryRql;

  /**
   * @return The RQL query that will be executed.
   */
  public String getQueryRql() {
    return mQueryRql;
  }

  /**
   * @param pQueryRql - RQL query text.
   */
  public void setQueryRql(String pQueryRql) {
    mQueryRql = pQueryRql;
  }
  
  //-----------------------------------
  // property: transactionManager
  private TransactionManager mTransactionManager;
  
  /**
   * @return transaction manager.
   */
  public TransactionManager getTransactionManager() {
    return mTransactionManager;
  }

  /**
   * @param pTransactionManager - transaction manager.
   */
  public void setTransactionManager(TransactionManager pTransactionManager) {
    mTransactionManager = pTransactionManager;
  }
  
  //-----------------------------------
  // property: statementMap
  private Map<String, RqlStatement> mStatementMap = new HashMap<String, RqlStatement>();
  
  /**
   * @return A cache of RQL querys to their equivalent statement objects.
   */
  public Map<String, RqlStatement> getStatementMap() {
    return mStatementMap;
  }
  
  //-----------------------------------
  // METHODS
  //-----------------------------------

  /**
   * Executes the RQL query and returns the results in the "items" output
   * parameter inside the "output" open parameter.
   */
  public void service(DynamoHttpServletRequest pRequest, DynamoHttpServletResponse pResponse)
    throws ServletException, IOException 
  {
    Repository repository = getRepository();
    if (repository == null) { 
      vlogError("The repository property has not been configured.");
      return;
    }

    String descName = getItemDescriptorName();
    if (StringUtils.isEmpty(descName)) {
      vlogError("The item descriptor property has not been configured.");
      return;
    }

    // Check to see if queryRQL was passed in from page
    String query = (String) pRequest.getLocalParameter(QUERY_RQL);
    if (query == null) {
      query = getQueryRql();
    }
    
    if (StringUtils.isEmpty(query)) {     
      vlogError("The query has not been passed and no default query has been configured.");
      return;
    }

    RepositoryItem[] results = null;
    
    try {
      // Parse the rql statement and cache it
      RqlStatement statement = getStatementMap().get(query);
      if (statement == null) {
        statement = RqlStatement.parseRqlStatement(query);
        getStatementMap().put(query, statement);
      }

      vlogDebug("Querying with statement: " + statement);
      results = performQuery(repository, descName, statement);
    } 
    catch (RepositoryException re) {
      vlogError(re, "RepositoryException using a droplet on a page occurred.");
    }
    
    // Service the empty open parameter when we receive no results
    if (results == null || results.length == 0) {
      pRequest.serviceLocalParameter(EMPTY, pRequest, pResponse);
    }
    // Otherwise service the output open parameter
    else {
      vlogDebug("Found {0} items for query", results.length);
      
      Collection <RepositoryItem> resultedCollections = new ArrayList <RepositoryItem>(results.length);
      for(RepositoryItem item : results){
        resultedCollections.add(item);
      }
      
      pRequest.setParameter(ITEMS, resultedCollections);
      pRequest.serviceLocalParameter(OUTPUT, pRequest, pResponse);
    }
  }

  /**
   * <p>
   * Performs the query against the view of the particular repository.
   * </p>
   *
   * @param pRepository - repository
   * @param pViewName - view name
   * @param pStatement - statement
   * @param pParams - parameters
   *
   * @return selected data array
   *
   * @throws RepositoryException if an error occurs
   */
  protected RepositoryItem[] performQuery(Repository pRepository, 
    String pViewName, RqlStatement pStatement) throws RepositoryException 
  {
    RepositoryItem[] items = null;

    // begin transaction
    Transaction trx = ensureTransaction();

    try {
      // execute query
      RepositoryView view = pRepository.getView(pViewName);
      items = pStatement.executeQuery(view, new Object[0]);
    } finally {
      if (trx != null) {
        try {
          trx.commit();
        } catch (RollbackException exc) {
          if (isLoggingError()) {
            logError(LogUtils.formatMajor(XA_FAILURE), exc);
          }
        } catch (HeuristicMixedException exc) {
          if (isLoggingError()) {
            logError(LogUtils.formatMajor(XA_FAILURE), exc);
          }
        } catch (HeuristicRollbackException exc) {
          if (isLoggingError()) {
            logError(LogUtils.formatMajor(XA_FAILURE), exc);
          }
        } catch (SystemException exc) {
          if (isLoggingError()) {
            logError(LogUtils.formatMajor(XA_FAILURE), exc);
          }
        }
      }
    }

    return items;
  }

  /**
   * Attempts to get current transaction from TransactionManager. If no
   * existing transaction, attempts to start one.
   *
   * @return transaction 
   */
  private Transaction ensureTransaction() {
    TransactionManager trxMgr = getTransactionManager();

    try {
      Transaction trx = trxMgr.getTransaction();

      if (trx == null) {
        trxMgr.begin();

        return trxMgr.getTransaction();
      } else {
        // transaction already exists, don't start and don't commit
        return null;
      }
    } catch (NotSupportedException exc) {
      if (isLoggingError()) {
        logError(LogUtils.formatMajor("failure getting transaction: "), exc);
      }
    } catch (SystemException exc) {
      if (isLoggingError()) {
        logError(LogUtils.formatMajor("failure getting transaction: "), exc);
      }
    }

    return null;
  }
}
