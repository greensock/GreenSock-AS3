package com.greensock.plugins {
	import flash.geom.Point;
	import com.greensock.TweenLite;
/**
 * [AS3/AS2 only] Tweens values in the target point to values of another point.
 * 
 * <p><b>USAGE:</b></p>
 * <listing version="3.0">
import com.greensock.TweenLite; 
import com.greensock.plugins.TweenPlugin; 
import com.greensock.plugins.EndPointPlugin;
TweenPlugin.activate([EndPointPlugin]); //activation is permanent in the SWF, so this line only needs to be run once
TweenLite.to(this.somePoint, 3, {endPoint:new Point(250, 50)}); 
</listing>
 * 
 * @author Tomasz Łuczyński, t@programuje.pl
 */
	public class EndPointPlugin extends TweenPlugin {
		/** @private **/
		public static const API:Number = 2; //If the API/Framework for plugins changes in the future, this number helps determine compatibility
		
		/** @private **/
		protected var _target:Point;
		/** @private **/
		protected var _pointStart:Point;
		/** @private **/
		protected var _pointChange:Point;
		
		/** @private **/
		public function EndPointPlugin() {
			super("endPoint");
		}
		
		/** @private **/
		override public function _onInitTween(target:Object, value:*, tween:TweenLite):Boolean {
			if (!(target is Point) || !(value is Point)) {
				return false;
			}
			_target = target as Point;
			_pointStart = _target.clone();
			_pointChange = new Point(value.x - target.x, value.y - target.y);
			return true;
		}
		
		/** @private **/
		override public function setRatio(v:Number):void {
			_target.x = _pointStart.x + _pointChange.x * v;
			_target.y = _pointStart.y + _pointChange.y * v;
		}
		
	}
}