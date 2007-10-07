/*
 * Created on 19/02/2004
 *
 */
package com.perfdynamics.pdq;

/**
 * @author plh
 *
 */
public class Utils {
	private PDQ pdq = null;
	String previousProcess = null;

	//----------------------------------------------------------------

	public Utils(PDQ pdq) {
		this.pdq = pdq;
	}

	//---------------------------------------------------------------------

	public void println(String format, String info) {
	} // println

	//---------------------------------------------------------------------

	public void debug(String process, String info) {
		if (previousProcess == process) {
			System.err.println("\t" + info);
		} else {
			System.err.println("DEBUG: " + process + "\n\t" + info);
			previousProcess = process;
		}
	} // debug

	//---------------------------------------------------------------------

	public void errmsg(String pname, String msg) { // output to tty always
		System.out.println(
			"ERROR in model:\"" + pdq.getModelName() + "\" at " + pname + ": " + msg);
		// exit(2); -- Should exit
	} // errmsg

	//---------------------------------------------------------------------

	public static void main(String[] args) {
	}
}
