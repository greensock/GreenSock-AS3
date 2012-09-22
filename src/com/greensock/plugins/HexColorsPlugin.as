/**
 * VERSION: 12.0
 * DATE: 2012-01-14
 * AS3
 * UPDATES AND DOCS AT: http://www.greensock.com
 **/
package com.greensock.plugins {
	import com.greensock.TweenLite;
/**
 * [AS3/AS2 only] Although hex colors are technically numbers, if you try to tween them conventionally, 
 * you'll notice that they don't tween smoothly. To tween them properly, the red, green, and 
 * blue components must be extracted and tweened independently. The HexColorsPlugin makes it easy. 
 * To tween a property of your object that's a hex color to another hex color, just pass a hexColors 
 * Object with properties named the same as your object's hex color properties. For example, 
 * if myObject has a "myHexColor" property that you'd like to tween to red (<code>0xFF0000</code>) over the 
 * course of 2 seconds, you'd do:<br /><br /><code>
 * 	
 * 	TweenMax.to(myObject, 2, {hexColors:{myHexColor:0xFF0000}});<br /><br /></code>
 * 	
 * You can pass in any number of hexColor properties. <br /><br />
 * 
 * <b>USAGE:</b><br /><br />
 * <code>
 * 		import com.greensock.TweenLite; <br />
 * 		import com.greensock.plugins.TweenPlugin; <br />
 * 		import com.greensock.plugins.HexColorsPlugin; <br />
 * 		TweenPlugin.activate([HexColorsPlugin]); //activation is permanent in the SWF, so this line only needs to be run once.<br /><br />
 * 
 * 		TweenLite.to(myObject, 2, {hexColors:{myHexColor:0xFF0000}}); <br /><br /></code>
 * 
 * Or if you just want to tween a color and apply it somewhere on every frame, you could do:<br /><br /><code>
 * 
 * var myColor:Object = {hex:0xFF0000};<br />
 * TweenLite.to(myColor, 2, {hexColors:{hex:0x0000FF}, onUpdate:applyColor});<br />
 * function applyColor():void {<br />
 * 		mc.graphics.clear();<br />
 * 		mc.graphics.beginFill(myColor.hex, 1);<br />
 * 		mc.graphics.drawRect(0, 0, 100, 100);<br />
 * 		mc.graphics.endFill();<br />
 * }<br /><br />
 * </code>
 * 
 * <p><strong>Copyright 2008-2012, GreenSock. All rights reserved.</strong> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for <a href="http://www.greensock.com/club/">Club GreenSock</a> members, the software agreement that was issued with the membership.</p>
 * 
 * @author Jack Doyle, jack@greensock.com
 */
	public class HexColorsPlugin extends TweenPlugin {
		/** @private **/
		public static const API:Number = 2; //If the API/Framework for plugins changes in the future, this number helps determine compatibility
		
		/** @private **/
		protected var _colors:Array;
		
		/** @private **/
		public function HexColorsPlugin() {
			super("hexColors");
			_overwriteProps = [];
			_colors = [];
		}
		
		/** @private **/
		override public function _onInitTween(target:Object, value:*, tween:TweenLite):Boolean {
			for (var p:String in value) {
				_initColor(target, p, uint(value[p]));
			}
			return true;
		}
		
		/** @private **/
		public function _initColor(target:Object, p:String, end:uint):void {
			var isFunc:Boolean = (typeof(target[p]) == "function"),
				start:uint = (!isFunc) ? target[p] : target[ ((p.indexOf("set") || !("get" + p.substr(3) in target)) ? p : "get" + p.substr(3)) ]();
			if (start != end) {
				var r:uint = start >> 16,
					g:uint = (start >> 8) & 0xff,
					b:uint = start & 0xff;
				_colors[_colors.length] = new ColorProp(target, p, isFunc, r, (end >> 16) - r, g, ((end >> 8) & 0xff) - g, b, (end & 0xff) - b);
				_overwriteProps[_overwriteProps.length] = p;
			}
		}
		
		/** @private **/
		override public function _kill(lookup:Object):Boolean {
			var i:int = _colors.length;
			while (i--) {
				if (lookup[_colors[i].p] != null) {
					_colors.splice(i, 1);
				}
			}
			return super._kill(lookup);
		}	
		
		/** @private **/
		override public function setRatio(v:Number):void {
			var i:int = _colors.length, clr:ColorProp, val:Number;
			while (--i > -1) {
				clr = _colors[i];
				val = (clr.rs + (v * clr.rc)) << 16 | (clr.gs + (v * clr.gc)) << 8 | (clr.bs + (v * clr.bc));
				if (clr.f) {
					clr.t[clr.p](val);
				} else {
					clr.t[clr.p] = val;
				}
			}
		}
		

	}
}

internal class ColorProp {
	public var t:Object;
	public var p:String;
	public var f:Boolean;
	public var rs:int;
	public var rc:int;
	public var gs:int;
	public var gc:int;
	public var bs:int;
	public var bc:int;
	
	public function ColorProp(t:Object, p:String, f:Boolean, rs:int, rc:int, gs:int, gc:int, bs:int, bc:int) {
		this.t = t;
		this.p = p;
		this.f = f;
		this.rs = rs;
		this.rc = rc;
		this.gs = gs;
		this.gc = gc;
		this.bs = bs;
		this.bc = bc;
	}
}