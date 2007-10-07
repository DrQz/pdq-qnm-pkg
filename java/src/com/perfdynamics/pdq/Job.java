/*
 * This version is intended for use with the book 
 * THE PRACTICAL PERFORMANCE ANALYST 
 * by Dr. Neil J. Gunther, published by:
 * McGraw-Hill Companies 1998. ISBN: 0079129463 
 * or
 * iUniverse.com Inc., 2000.   ISBN: 059512674X

 *  Visit the www.perfdynamics.com for additional information
 * on the book and other resources.
 * 
 * 
 * 
*******************  DISCLAIMER OF WARRANTY ************************
 * Performance Dynamics Company(tm) and Neil J. Gunther make no warranty,
 * express or implied, that the source code contained PDQ or in the  book
 * are free from error, or are consistent with any particular standard of
 * merchantability, or that they will meet your requirements for a
 * particular application. They should not be relied upon for solving a
 * problem whose correct solution could result in injury to a person or
 * loss of property. The author disclaims all liability for direct or
 * consequential damages resulting from your use of this source code.
 * Please refer to the separate disclaimer from McGraw-Hill attached to
 * the diskette. 
************************* DO NOT REMOVE ****************************
 */
package com.perfdynamics.pdq;

/**
 * @author plh
 *
 */
public class Job {
	public static final int MAXSTREAMS = 30; // Max no of job streams (30)

	// Job types

	public static final int TERM  = 10;
	public static final int TRANS = 11;
	public static final int BATCH = 12;

   //---------------------------------------------------------------------
   
	public int should_be_class;  // stream should_be_class
	public int network;  // OPEN, CLOSED
	public Terminal term = null;
	public Batch batch = null;
	public Transaction trans = null;
}
