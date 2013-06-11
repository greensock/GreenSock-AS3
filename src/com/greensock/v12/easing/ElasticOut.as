/**
 * VERSION: 1.1
 * DATE: 2012-07-27
 * AS3 (AS2 and JS versions are also available)
 * UPDATES AND DOCS AT: http://www.greensock.com
 **/
package com.greensock.v12.easing {
/**
 * @private
 * Eases using a sine wave that starts fast and then decelerates over time.
 * 
 * <p><strong>Copyright 2013, GreenSock. All rights reserved.</strong> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for <a href="http://www.greensock.com/club/">Club GreenSock</a> members, the software agreement that was issued with the membership.</p>
 * 
 * @author Jack Doyle, jack@greensock.com
 **/
	final public class ElasticOut extends Ease {
		
		/** @private **/
		private static const _2PI:Number = Math.PI * 2;
		
		/** The default ease instance which can be reused many times in various tweens in order to conserve memory and improve performance slightly compared to creating a new instance each time. **/
		public static var ease:ElasticOut = new ElasticOut();
		
		/**
		 * Constructor
		 * 
		 * @param amplitude the amplitude of the sine wave (how exaggerated its movement is). Default is 1.
		 * @param period the period of the sine wave (how far apart its waves are spaced, like its frequency where a lower value produces more cycles). Default is 0.3.
		 */
		public function ElasticOut(amplitude:Number=1, period:Number=0.3) {
			_p1 = amplitude || 1;
			_p2 = period || 0.3;
			_p3 = _p2 / _2PI * (Math.asin(1 / _p1) || 0); 
		}
		
		/** @inheritDoc **/
		override public function getRatio(p:Number):Number {
			return _p1 * Math.pow(2, -10 * p) * Math.sin( (p - _p3) * _2PI / _p2 ) + 1;
		}
		
		/**
		 * Permits customization of the ease with various parameters.
		 * 
		 * @param amplitude the amplitude of the sine wave (how exaggerated its movement is). Default is 1.
		 * @param period the period of the sine wave (how far apart its waves are spaced, like its frequency where a lower value produces more cycles). Default is 0.3.
		 * @return new ElasticOut instance that is configured according to the parameters provided
		 */
		public function config(amplitude:Number=1, period:Number=0.3):ElasticOut {
			return new ElasticOut(amplitude, period);
		}
		
	}
	
}
