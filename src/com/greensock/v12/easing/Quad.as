/**
 * VERSION: 1.0
 * DATE: 2012-03-22
 * AS3 (AS2 and JS versions are also available)
 * UPDATES AND DOCS AT: http://www.greensock.com
 **/
package com.greensock.v12.easing {
/**
 * Provides an <code>easeIn</code>, <code>easeOut</code>, and <code>easeInOut</code> with a power (or strength) 
 * of 1 which is identical to the <code>Power1</code> ease. The more power, the more 
 * exaggerated the easing effect. Using a numeric approach like Power1 instead of Quad makes experimenting 
 * easier and the code reads more intuitively. 
 * 
 * <p>This is one of the eases that is natively accelerated in TweenLite and TweenMax. All of the 
 * "Power" eases and their counterparts (Linear (0), Quad (1), Cubic (2), Quart (3), Quint (4), and Strong (4)) are 
 * accelerated.</p>
 * 
 * <p><strong>Example usage:</strong></p>
 * <p><code>
 * TweenLite.to(obj, 1, {x:100, ease:Quad.easeOut});
 * </code></p>
 * 
 * <p><strong>Copyright 2013, GreenSock. All rights reserved.</strong> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for <a href="http://www.greensock.com/club/">Club GreenSock</a> members, the software agreement that was issued with the membership.</p>
 * 
 * @author Jack Doyle, jack@greensock.com
 **/
	final public class Quad {
		
		/** Eases out with a power of 1. **/
		public static var easeOut:Ease = new Ease(null,null,1,1);
		
		/** Eases in with a power of 1. **/
		public static var easeIn:Ease = new Ease(null,null,2,1);
		
		/** Eases in and then out with a power of 1. **/
		public static var easeInOut:Ease = new Ease(null,null,3,1);
	}
}