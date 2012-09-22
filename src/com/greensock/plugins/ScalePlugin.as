/**
 * VERSION: 12.0
 * DATE: 2012-03-29
 * AS3
 * UPDATES AND DOCS AT: http://www.TweenMax.com
 **/
package com.greensock.plugins {
	import com.greensock.TweenLite;
/**
 * [AS3/AS2 only] ScalePlugin combines scaleX and scaleY into one "scale" property. <br /><br />
 * 
 * <b>USAGE:</b><br /><br />
 * <code>
 * 		import com.greensock.TweenLite; <br />
 * 		import com.greensock.plugins.TweenPlugin; <br />
 * 		import com.greensock.plugins.ScalePlugin; <br />
 * 		TweenPlugin.activate([ScalePlugin]); //activation is permanent in the SWF, so this line only needs to be run once.<br /><br />
 * 
 * 		TweenLite.to(mc, 1, {scale:2});  //tweens horizontal and vertical scale simultaneously <br /><br />
 * </code>
 * 
 * <p><strong>Copyright 2008-2012, GreenSock. All rights reserved.</strong> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for <a href="http://www.greensock.com/club/">Club GreenSock</a> members, the software agreement that was issued with the membership.</p>
 * 
 * @author Jack Doyle, jack@greensock.com
 */
	public class ScalePlugin extends TweenPlugin {
		/** @private **/
		public static const API:Number = 2;
  
		/** @private **/
		public function ScalePlugin() {
			super("scale,scaleX,scaleY,width,height");
		}
  
		/** @private **/
		override public function _onInitTween(target:Object, value:*, tween:TweenLite):Boolean {
			if (!target.hasOwnProperty("scaleX")) {
				return false;
			}
			_addTween(target, "scaleX", target.scaleX, value, "scaleX");
			_addTween(target, "scaleY", target.scaleY, value, "scaleY");
			return true;
		}
		
	}
}