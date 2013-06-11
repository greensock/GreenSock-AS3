/**
 * VERSION: 12.01
 * DATE: 2012-09-10
 * AS3
 * UPDATES AND DOCS AT: http://www.greensock.com/tweenvars/
 **/
package com.greensock.v12.data {
	import com.greensock.v12.TweenLite;
	import com.greensock.v12.motionPaths.MotionPath;
	
	import flash.display.Stage;
	import flash.geom.Point;
/**
 * 	[AS3 only] There are 3 primary benefits of using a TweenLiteVars instance to define your TweenLite's "vars" parameter:
 *  <ol>
 *		<li> In most code editors, code hinting will be activated which helps remind you which special properties are available.</li>
 *		<li> It allows you to code using strict data typing which can improve debugging.</li>
 * 		<li> It will trace() a warning if you forgot to activate a particular plugin. For example, if you define an autoAlpha value in a TweenLiteVars instance but you didn't activate() the plugin, you'll see a trace() output when you test/compile the file (an Error isn't thrown because in some very rare circumstances it can be perfectly legitimate to avoid activating the plugin)</li>
 *  </ol>
 * 
 * <p>The down side, of course, is that the code is more verbose and TweenLiteVars adds about 5kb to your published swf. </p>
 *
 * <p><strong>USAGE:</strong></p>
 * <p>Note that each method returns the TweenLiteVars object, so you can reduce the lines of code by method chaining (see example below).</p>
 *	
 * <p><strong>Without TweenLiteVars:</strong></p>
 * <p><code>TweenLite.to(mc, 1, {x:300, y:100, tint:0xFF0000, onComplete:myFunction, onCompleteParams:[mc]})</code></p>
 * 
 * <p><strong>With TweenLiteVars</strong></p>
 * <p><code>TweenLite.to(mc, 1, new TweenLiteVars().move(300, 100).tint(0xFF0000).onComplete(myFunction, [mc]));</code></p>
 *
 * <p>You can use the prop() method to set individual generic properties (like "myCustomProperty" or "rotationY") or you can 
 * pass a generic Object into the constructor to make it a bit more concise, like this:</p>
 * 
 * <p><code>TweenLite.to(mc, 1, new TweenLiteVars({myCustomProperty:300, rotationY:100}).tint(0xFF0000).onComplete(myFunction, [mc]));</code></p>
 * 
 * <p><strong>NOTES:</strong></p>
 * <ul>
 *	<li> To get the generic vars object that TweenLiteVars builds internally, simply access its "vars" property.
 * 		 In fact, if you want maximum backwards compatibility, you can tack ".vars" onto the end of your chain like this:<code>
 * 		 TweenLite.to(mc, 1, new TweenLiteVars({x:300, y:100}).tint(0xFF0000).onComplete(myFunction, [mc]).vars);</code></li>
 *	<li> This class adds about 6kb to your published SWF (not including TweenLite or any plugins).</li>
 *	<li> Using TweenLiteVars is completely optional. If you prefer the shorter generic object synatax, feel
 *	  	 free to use it. The purpose of this utility is simply to enable code hinting and to allow for strict datatyping.</li>
 * </ul>
 * 
 * <p><strong>Copyright 2008-2013, GreenSock. All rights reserved.</strong> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for <a href="http://www.greensock.com/club/">Club GreenSock</a> members, the software agreement that was issued with the membership.</p>
 * 
 * @author Jack Doyle, jack@greensock.com
 */	 
	public class TweenLiteVars {
		/** @private **/
		public static const version:Number = 12.0;
		
		/** @private **/
		protected var _vars:Object;
		
		/**
		 * Constructor
		 * @param vars A generic Object containing properties that you'd like added (copied) to this TweenLiteVars instance. This is particularly useful for generic properties that don't have a corresponding method for setting the values (although you can use it for properties that do have corresponding methods too). For example, to tween the x and y properties of a DisplayObject, <code>new TweenLiteVars({x:300, y:0})</code>
		 */
		public function TweenLiteVars(vars:Object=null) {
			_vars = {};
			if (vars != null) {
				for (var p:String in vars) {
					_vars[p] = vars[p];
				}
			}
		}
		
		/** @private **/
		protected function _set(property:String, value:*, requirePlugin:Boolean=false):TweenLiteVars {
			if (value == null) {
				delete _vars[property]; //in case it was previously set
			} else {
				_vars[property] = value;
			}
			if (requirePlugin && !(property in TweenLite._plugins)) {
				trace("WARNING: you must activate() the " + property + " plugin in order for the feature to work in TweenLite. See http://www.greensock.com/tweenlite/#plugins for details.");
			}
			return this;
		}
		
		/**
		 * Adds a dynamic property for tweening and allows you to indicate whether the value is relative or not.
		 * For example, to tween "x" to 50 less than whatever it currently is:
		 * 
		 * <p><code>prop("x", -50, true);</code></p>
		 * 
		 * @param property Property name
		 * @param value Numeric end value (or beginning value for <code>from()</code> tweens)
		 * @param relative If <code>true</code>, the value will be interpreted as relative to the target's current value. For example, if mc.x is currently 300 and you do <code>prop("x", 200, true)</code>, the end value will be 500.
		 */
		public function prop(property:String, value:Number, relative:Boolean=false):TweenLiteVars {
			return _set(property, (!relative) ? value : (value < 0) ? "-=" + (-value) : "+=" + value);
		}
		
		
//---- BUILT-IN SPECIAL PROPERTIES (NO PLUGIN ACTIVATION REQUIRED) --------------------------------------------------------------
		
		/** Any generic data that you'd like associated with your tween. **/
		public function data(data:*):TweenLiteVars {
			return _set("data", data);
		}
		
		/** The number of seconds (or frames for frames-based tweens) to delay before the tween begins. **/
		public function delay(delay:Number):TweenLiteVars {
			return _set("delay", delay);
		}
		
		/** 
		 * Controls the rate of change. Use any standard easing equation like <code>ElasticOut.ease</code>. The Default is <code>QuadOut.ease</code>.
		 * 
		 * @param ease An ease (i.e. <code>com.greensock.v12.easing.ElasticOut.ease</code>) The default is <code>QuadOut.ease</code>.
		 * @param easeParams An Array of extra parameter values to feed the easing equation (beyond the standard 4). This can be useful with easing equations like Elastic that accept extra parameters like the amplitude and period. Most easing equations, however, don't accept extra parameters so you won't need to pass in any easeParams.
		 **/
		public function ease(ease:*, easeParams:Array=null):TweenLiteVars {
			_set("easeParams", easeParams);
			return _set("ease", ease);
		}
		
		/** 
		 * Normally when you create a tween, it begins rendering on the very next frame (when 
		 * the Flash Player dispatches an ENTER_FRAME event) unless you specify a <code>delay</code>. 
		 * This allows you to insert tweens into timelines and perform other actions that may affect 
		 * its timing. However, if you prefer to force the tween to render immediately when it is 
		 * created, set <code>immediateRender</code> to true. from() tweens
		 * render immediately by default, so to prevent that behavior, set <code>immediateRender</code>
		 * to <code>false</code>.
		 **/
		public function immediateRender(value:Boolean):TweenLiteVars {
			return _set("immediateRender", value, false);
		}
		
		/** 
		 * A function that should be called when the tween has completed. 
		 * 
		 * @param func A function that should be called when the tween has completed. 
		 * @param params An Array of parameters to pass the onComplete function
		 **/
		public function onComplete(func:Function, params:Array=null):TweenLiteVars {
			_set("onCompleteParams", params);
			return _set("onComplete", func);
		}
		
		/** 
		 * A function that should be called after the tween has completed and rendered its final state to the stage (waits for the next ENTER_FRAME event is dispatched after the tween finishes). Target must be a DisplayObject.
		 * 
		 * @param func A function that should be called after the tween has completed and rendered its final state to the stage (waits for the next ENTER_FRAME event is dispatched after the tween finishes).
		 * @param params An Array of parameters to pass the onCompleteRender function
		 **/
		public function onCompleteRender(func:Function, params:Array=null):TweenLiteVars {
			_set("onCompleteRenderParams", params);
			return _set("onCompleteRender", func, true);
		}
		
		/** 
		 * A function that should be called when the tween begins (when its <code>time()</code> is at 0 
		 * and changes to some other value which can happen more than once if the tween is restarted multiple times). 
		 * 
		 * @param func A function that should be called when the tween begins.
		 * @param params An Array of parameters to pass the onStart function.
		 **/
		public function onStart(func:Function, params:Array=null):TweenLiteVars {
			_set("onStartParams", params);
			return _set("onStart", func);
		}
		
		/** 
		 * A function to call whenever the tweening values are updated (on every frame during the time the tween is active). 
		 * 
		 * @param func A function to call whenever the tweening values are updated. 
		 * @param params An Array of parameters to pass the onUpdate function
		 **/
		public function onUpdate(func:Function, params:Array=null):TweenLiteVars {
			_set("onUpdateParams", params);
			return _set("onUpdate", func);
		}
		
		/** 
		 * A function that should be called when the tween has reached its starting point again after having been reversed.  
		 * 
		 * @param func A function that should be called when the tween has reached its starting point again after having been reversed.
		 * @param params An Array of parameters to pass the onReverseComplete function
		 **/
		public function onReverseComplete(func:Function, params:Array=null):TweenLiteVars {
			_set("onReverseCompleteParams", params);
			return _set("onReverseComplete", func);
		}
		
		/** 
		 * Controls how (and if) other tweens of the same target are overwritten. 
		 * There are several modes to choose from, but <code>"auto"</code> is the default (although
		 * you can change the default mode using the <code>TweenLite.defaultOverwrite</code> property):
		 * <ul>
		 * 	<li><code>"none"</code> - no overwriting will occur.</li>
		 * 						
		 * 	<li><code>"all"</code> - immediately overwrites all existing 
		 * 				tweens of the same target even if they haven't started yet or don't have 
		 * 				conflicting properties.</li>
		 * 													
		 * 	<li><code>"auto"</code> - when the tween renders for the first time, it will analyze 
		 * 				tweens of the same target that are currently active/running and only overwrite 
		 * 				individual tweening properties that overlap/conflict. Tweens that haven't begun
		 * 				yet are ignored. For example, if another active tween is found that is tweening
		 * 				3 properties, only 1 of which it shares in common with the new tween, the other
		 * 				2 properties will be left alone. Only the conflicting property gets overwritten/killed.
		 * 				This is the default mode and typically the most intuitive for developers.</li>
		 * 							
		 * 	<li><code>"concurrent"</code> - when the tween renders for the first time, it kills
		 * 				only the active (in-progress) tweens of the same target regardless of whether 
		 * 				or not they contain conflicting properties. Like a mix of <code>"all"</code> 
		 * 				and <code>"auto"</code>. Good for situations where you only want one tween 
		 * 				controling the target at a time.</li>
		 * 												
		 * 	<li><code>"allOnStart"</code> - Identical to <code>"all"</code> but waits to run
		 * 				the overwrite logic until the tween begins (after any delay). Kills
		 * 				tweens of the same target even if they don't contain conflicting properties
		 * 				or haven't started yet.</li>
		 * 												
		 * 	<li><code>"preexisting"</code> - when the tween renders for the first time, it kills
		 * 				only the tweens of the same target that existed BEFORE this tween was created
		 * 				regardless of their scheduled start times. So, for example, if you create a tween
		 * 				with a delay of 10 and then a tween with a delay of 1 and then a tween with a 
		 * 				delay of 2 (all of the same target), the 2nd tween would overwrite the first
		 * 				but not the second even though scheduling might seem to dictate otherwise. 
		 * 				<code>"preexisting"</code> only cares about the order in which the instances
		 * 				were actually created. This can be useful when the order in which your code runs 
		 * 				plays a critical role.</li>
		 * </ul>
		 **/
		public function overwrite(value:String):TweenLiteVars {
			return _set("overwrite", value, false);
		}
		
		/** Controls the paused state of the tween - if true, the tween will be paused initially. **/
		public function paused(value:Boolean):TweenLiteVars {
			return _set("paused", value, false);
		}
		
		/** When true, the tween will flip the start and end values which is exactly what <code>TweenLite.from()</code> does. **/
		public function runBackwards(value:Boolean):TweenLiteVars {
			return _set("runBackwards", value, false);
		}
		
		/** 
		 * If <code>useFrames</code> is set to true, the tweens's timing mode will be based on frames. 
		 * Otherwise, it will be based on seconds/time. <strong>NOTE:</strong> a tween's timing mode is always 
		 * determined by its parent timeline. 
		 **/
		public function useFrames(value:Boolean):TweenLiteVars {
			return _set("useFrames", value, false);
		}
		

//---- COMMON CONVENIENCE PROPERTIES (NO PLUGIN REQUIRED) -------------------------------------------------------------------
		
		/** Tweens the "x" and "y" properties of the target **/
		public function move(x:Number, y:Number, relative:Boolean=false):TweenLiteVars {
			prop("x", x, relative);
			return prop("y", y, relative);
		}
		
		/** Tweens the "scaleX" and "scaleY" properties of the target **/
		public function scale(value:Number, relative:Boolean=false):TweenLiteVars {
			prop("scaleX", value, relative);
			return prop("scaleY", value, relative);
		}
		
		/** Tweens the "rotation" property of the target **/
		public function rotation(value:Number, relative:Boolean=false):TweenLiteVars {
			return prop("rotation", value, relative);
		}
		
		/** Tweens the "scaleX" property of the target **/
		public function scaleX(value:Number, relative:Boolean=false):TweenLiteVars {
			return prop("scaleX", value, relative);
		}
		
		/** Tweens the "scaleY" property of the target **/
		public function scaleY(value:Number, relative:Boolean=false):TweenLiteVars {
			return prop("scaleY", value, relative);
		}
		
		/** Tweens the "width" property of the target **/
		public function width(value:Number, relative:Boolean=false):TweenLiteVars {
			return prop("width", value, relative);
		}
		
		/** Tweens the "height" property of the target **/
		public function height(value:Number, relative:Boolean=false):TweenLiteVars {
			return prop("height", value, relative);
		}
		
		/** Tweens the "x" property of the target **/
		public function x(value:Number, relative:Boolean=false):TweenLiteVars {
			return prop("x", value, relative);
		}
		
		/** Tweens the "y" property of the target **/
		public function y(value:Number, relative:Boolean=false):TweenLiteVars {
			return prop("y", value, relative);
		}
		

//---- PLUGIN REQUIRED -------------------------------------------------------------------------------------------
		
		/** Same as changing the "alpha" property but with the additional feature of toggling the "visible" property to false whenever alpha is 0, thus improving rendering performance in the Flash Player. **/
		public function autoAlpha(alpha:Number):TweenLiteVars {
			return _set("autoAlpha", alpha, true);
		}
		
		/**
		 * Tweens a BevelFilter
		 * 
		 * @param distance The offset distance of the bevel.
		 * @param angle The angle of the bevel.
		 * @param highlightColor The highlight color of the bevel.
		 * @param highlightAlpha The alpha transparency value of the highlight color.
		 * @param shadowColor The shadow color of the bevel.
		 * @param shadowAlpha The alpha transparency value of the shadow color.
		 * @param blurX The amount of horizontal blur, in pixels.
		 * @param blurY The amount of vertical blur, in pixels.
		 * @param strength The strength of the imprint or spread.
		 * @param quality The number of times to apply the filter.
		 * @param remove If true, the filter will be removed as soon as the tween completes
		 * @param addFilter If true, a new BevelFilter will be added to the target even if a BevelFilter is already in its filters array.
		 * @param index Allows you to target a particular BevelFilter if there are multiple BevelFilters in the target's filters array - simply define the index value corresponding to the BevelFilter's position in the filters array.
		 * @return The TweenLiteVars instance
		 */
		public function bevelFilter(distance:Number=4, angle:Number=45, highlightColor:uint=0xFFFFFF, highlightAlpha:Number=0.5, shadowColor:uint=0x000000, shadowAlpha:Number=0.5, blurX:Number=4, blurY:Number=4, strength:Number=1, quality:int=2, remove:Boolean=false, addFilter:Boolean=false, index:int=-1):TweenLiteVars {
			var filter:Object = {distance:distance, angle:angle, highlightColor:highlightColor, highlightAlpha:highlightAlpha, shadowColor:shadowColor, shadowAlpha:shadowAlpha, blurX:blurX, blurY:blurY, strength:strength, quality:quality, addFilter:addFilter, remove:remove};
			if (index > -1) {
				filter.index = index;
			}
			return _set("bevelFilter", filter, true);
		}
		
		/** 
		 * Bezier tweening allows you to tween in a non-linear way. For example, you may want to tween
		 * a MovieClip's position from the origin (0,0) 500 pixels to the right (500,0) but curve downwards
		 * through the middle of the tween. Simply pass as many objects in the bezier Array as you'd like, 
		 * one for each "control point" (see documentation on Flash's curveTo() drawing method for more
		 * about how control points work).
		 * 
		 * <p>Keep in mind that you can bezier tween ANY properties, not just x/y. </p>
		 * 
		 * <p><strong>USAGE:</strong></p>
		 * <listing version="3.0">
import com.greensock.TweenLite; 
import com.greensock.v12.data.TweenLiteVars;
import com.greensock.v12.plugins.TweenPlugin;
import com.greensock.v12.plugins.BezierPlugin;
TweenPlugin.activate([BezierPlugin]); //activation is permanent in the SWF, so this line only needs to be run once.

TweenLite.to(mc, 3, new TweenLiteVars().bezier([{x:250, y:50}, {x:500, y:0}])); //makes my_mc travel through 250,50 and end up at 500,0.
</listing>
		 * 
		 * @param values An array of objects with key/value pairs that define the bezier points like <code>[{x:250, y:50}, {x:500, y:0}]</code>
		 * @see #bezierThrough()
		 **/
		public function bezier(values:Array):TweenLiteVars {
			return _set("bezier", values, true);
		}
		
		/** 
		 * Identical to bezier except that instead of passing Bezier control point values, you pass values through 
		 * which the Bezier values should move. This can be more intuitive than using control points. 
		 * 
		 * @param values An array of objects with key/value pairs that define the bezier points like <code>[{x:250, y:50}, {x:500, y:0}]</code>
		 * @see #bezier()
		 **/
		public function bezierThrough(values:Array):TweenLiteVars {
			return _set("bezierThrough", values, true);
		}
		
		/**
		 * Tweens a BlurFilter
		 * 
		 * @param blurX The amount of horizontal blur.
		 * @param blurY The amount of vertical blur.
		 * @param quality The number of times to perform the blur.
		 * @param remove If true, the filter will be removed as soon as the tween completes
		 * @param addFilter If true, a new BlurFilter will be added to the target even if a BlurFilter is already in its filters array.
		 * @param index Allows you to target a particular BlurFilter if there are multiple BlurFilters in the target's filters array - simply define the index value corresponding to the BlurFilter's position in the filters array.
		 * @return The TweenLiteVars instance
		 */
		public function blurFilter(blurX:Number, blurY:Number, quality:int=2, remove:Boolean=false, addFilter:Boolean=false, index:int=-1):TweenLiteVars {
			var filter:Object = {blurX:blurX, blurY:blurY, quality:quality, addFilter:addFilter, remove:remove};
			if (index > -1) {
				filter.index = index;
			}
			return _set("blurFilter", filter, true);
		}
		
		/**
		 * Tweens an object along a CirclePath2D motion path in any direction (clockwise, counter-clockwise, or shortest).
		 * 
		 * <p><strong>USAGE:</strong></p>
		 * <listing version="3.0">
import com.greensock.TweenLite; 
import com.greensock.v12.data.TweenLiteVars;
import com.greensock.v12.plugins.~~;
import com.greensock.v12.motionPaths.~~
TweenPlugin.activate([CirclePath2DPlugin]); //activation is permanent in the SWF, so this line only needs to be run once.

var circle:CirclePath2D = new CirclePath2D(150, 150, 100);
TweenLite.to(mc, 2, new TweenLiteVars().circlePath2D(circle, 90, 270, false, Direction.CLOCKWISE, 2)); 
</listing>
		 * 
		 * @param path The CirclePath2D instance to follow (<code>com.greensock.v12.motionPaths.CirclePath2D</code>)
		 * @param startAngle The position at which the target should begin its rotation (described in degrees unless useRadians is true in which case it is described in radians). For example, to begin at the top of the circle, use 270 or -90 as the startAngle.
		 * @param endAngle The position at which the target should end its rotation (described in degrees unless useRadians is true in which case it is described in radians). For example, to end at the bottom of the circle, use 90 as the endAngle.
		 * @param autoRotate When <code>autoRotate</code> is <code>true</code>, the target will automatically be rotated so that it is oriented to the angle of the path. To offset this value (like to always add 90 degrees for example), use the <code>rotationOffset</code> property.
		 * @param direction The direction in which the target should travel around the path. Options are <code>Direction.CLOCKWISE</code> ("clockwise"), <code>Direction.COUNTER_CLOCKWISE</code> ("counterClockwise"), or <code>Direction.SHORTEST</code> ("shortest").
		 * @param extraRevolutions If instead of going directly to the endAngle, you want the target to travel one or more extra revolutions around the path before going to the endAngle, define that number of revolutions here.
		 * @param rotationOffset When <code>autoRotate</code> is <code>true</code>, this value will always be added to the resulting <code>rotation</code> of the target.
		 * @param useRadians If you prefer to define values in radians instead of degrees, set <code>useRadians</code> to true.
		 * @return The TweenLiteVars instance
		 */
		public function circlePath2D(path:MotionPath, startAngle:Number, endAngle:Number, autoRotate:Boolean=false, direction:String="clockwise", extraRevolutions:uint=0, rotationOffset:Number=0, useRadians:Boolean=false):TweenLiteVars {
			return _set("circlePath2D", {path:path, startAngle:startAngle, endAngle:endAngle, autoRotate:autoRotate, direction:direction, extraRevolutions:extraRevolutions, rotationOffset:rotationOffset, useRadians:useRadians}, true);
		}
		
		/**
		 * ColorMatrixFilter tweening offers an easy way to tween a DisplayObject's saturation, hue, contrast,
		 * brightness, and colorization. 
		 * 
		 * <p><strong>HINT</strong>: If you'd like to match the ColorMatrixFilter values you created in the Flash IDE on a particular object, 
		 * you can get its matrix like this:</p>
		 * 
		 * <listing version="3.0">
import flash.display.DisplayObject; 
import flash.filters.ColorMatrixFilter;

function getColorMatrix(mc:DisplayObject):Array {
	var f:Array = mc.filters, i:uint; 
	for (i = 0; i &lt; f.length; i++) { 
	    if (f[i] is ColorMatrixFilter) {
		    return f[i].matrix; 
		} 
	} 
	return null; 
}

var myOriginalMatrix:Array = getColorMatrix(my_mc); //store it so you can tween back to it anytime
</listing>
		 * 
		 * <p><strong>USAGE:</strong></p>
		 * <listing version="3.0">
import com.greensock.TweenLite; 
import com.greensock.v12.data.TweenLiteVars;
import com.greensock.v12.plugins.TweenPlugin;
import com.greensock.v12.plugins.ColorMatrixFilterPlugin;
TweenPlugin.activate([ColorMatrixFilterPlugin]); //activation is permanent in the SWF, so this line only needs to be run once.

TweenLite.to(mc, 1, new TweenLiteVars().colorMatrixFilter(0xFF0000));
</listing>
		 * 
		 * @param colorize The color to use for the colorizing effect - colorizing a DisplayObject makes it look as though you're seeing it through a colored piece of glass whereas tinting it makes every pixel exactly that color. You can control the amount of colorization using the "amount" parameter where 1 is full strength, 0.5 is half-strength, and 0 has no colorization effect.
		 * @param amount A number between 0 and 1 that determines the potency of the colorize effect. This parameter is ignored if the <code>colorize</code> parameter is left at its default value of 0xFFFFFF.
		 * @param saturation A number indicating the saturation where 1 is normal saturation, 0 makes the target look grayscale, and 2 would be double the normal saturation.
		 * @param contrast A number indicating the contrast where 1 is normal contrast, 0 is no contrast, and 2 is double the normal contrast, etc.
		 * @param brightness A number indicating the brightness where 1 is normal brightness, 0 is much darker than normal, and 2 is twice the normal brightness, etc.
		 * @param hue An angle-like number between 0 and 360 indicating the change in hue. Think of it as degrees, so 180 would be rotating the hue to be exactly opposite as normal, 360 would be the same as 0, etc.
		 * @param threshold A number from 0 to 255 that controls the threshold of where the pixels turn white or black (leave as -1 to avoid any threshold effect whatsoever).
		 * @param remove If true, the filter will be removed as soon as the tween completes
		 * @param addFilter If true, a new ColorMatrixFilter will be added to the target even if a ColorMatrixFilter is already in its filters array.
		 * @param index Allows you to target a particular ColorMatrixFilter if there are multiple ColorMatrixFilters in the target's filters array - simply define the index value corresponding to the ColorMatrixFilter's position in the filters array.
		 * @return The TweenLiteVars instance
		 */
		public function colorMatrixFilter(colorize:uint=0xFFFFFF, amount:Number=1, saturation:Number=1, contrast:Number=1, brightness:Number=1, hue:Number=0, threshold:Number=-1, remove:Boolean=false, addFilter:Boolean=false, index:int=-1):TweenLiteVars {
			var filter:Object = {saturation:saturation, contrast:contrast, brightness:brightness, hue:hue, addFilter:addFilter, remove:remove};
			if (colorize != 0xFFFFFF) {
				filter.colorize = colorize;
				filter.amount = amount;
			}
			if (threshold > -1) {
				filter.threshold = threshold;
			}
			if (index > -1) {
				filter.index = index;
			}
			return _set("colorMatrixFilter", filter, true);
		}
		
		/**
		 * Tweens ColorTransform properties of a DisplayObject to do advanced effects like overexposing, altering
		 * the brightness or setting the percent/amount of tint. 
		 *  
		 * @param tint The color value for a ColorTransform object.
		 * @param tintAmount A numeric value between 0 and 1 indicating the potency of the tint. For example, if tint is 0xFF0000 and tintAmount is 0.5, the target would be tinted halfway to red.
		 * @param exposure A numeric value between 0 and 2 where 1 is normal exposure, 0, is completely underexposed, and 2 is completely overexposed. Overexposing an object is different then changing the brightness - it seems to almost bleach the image and looks more dynamic and interesting (subjectively speaking).
		 * @param brightness A numeric value between 0 and 2 where 1 is normal brightness, 0 is completely dark/black, and 2 is completely bright/white
		 * @param redMultiplier A decimal value that is multiplied with the red channel value.
		 * @param greenMultiplier A decimal value that is multiplied with the green channel value.
		 * @param blueMultiplier A decimal value that is multiplied with the blue channel value.
		 * @param alphaMultiplier A decimal value that is multiplied with the alpha transparency channel value.
		 * @param redOffset A number from -255 to 255 that is added to the red channel value after it has been multiplied by the redMultiplier value.
		 * @param greenOffset A number from -255 to 255 that is added to the green channel value after it has been multiplied by the greenMultiplier value.
		 * @param blueOffset A number from -255 to 255 that is added to the blue channel value after it has been multiplied by the blueMultiplier value.
		 * @param alphaOffset A number from -255 to 255 that is added to the alpha transparency channel value after it has been multiplied by the alphaMultiplier value.
		 * @return The TweenLiteVars instance
		 */
		public function colorTransform(tint:Number=NaN, tintAmount:Number=NaN, exposure:Number=NaN, brightness:Number=NaN, redMultiplier:Number=NaN, greenMultiplier:Number=NaN, blueMultiplier:Number=NaN, alphaMultiplier:Number=NaN, redOffset:Number=NaN, greenOffset:Number=NaN, blueOffset:Number=NaN, alphaOffset:Number=NaN):TweenLiteVars {
			var values:Object = {tint:tint, tintAmount:isNaN(tint) ? NaN : tintAmount, exposure:exposure, brightness:brightness, redMultiplier:redMultiplier, greenMultiplier:greenMultiplier, blueMultiplier:blueMultiplier, alphaMultiplier:alphaMultiplier, redOffset:redOffset, greenOffset:greenOffset, blueOffset:blueOffset, alphaOffset:alphaOffset};
			for (var p:String in values) {
				if (isNaN(values[p])) {
					delete values[p];
				}
			}
			return _set("colorTransform", values, true);
		}
		
		/**
		 * Tweens a DropShadowFilter.
		 * 
		 * @param distance The offset distance for the shadow, in pixels.
		 * @param blurX The amount of horizontal blur.
		 * @param blurY The amount of vertical blur.
		 * @param alpha The alpha transparency value for the shadow color.
		 * @param angle The angle of the shadow.
		 * @param color The color of the shadow.
		 * @param strength The strength of the imprint or spread.
		 * @param inner Indicates whether or not the shadow is an inner shadow.
		 * @param knockout Applies a knockout effect (true), which effectively makes the object's fill transparent and reveals the background color of the document.
		 * @param hideObject Indicates whether or not the object is hidden.
		 * @param quality The number of times to apply the filter.
		 * @param remove If true, the filter will be removed as soon as the tween completes
		 * @param addFilter If true, a new DropShadowFilter will be added to the target even if a DropShadowFilter is already in its filters array.
		 * @param index Allows you to target a particular DropShadowFilter if there are multiple DropShadowFilters in the target's filters array - simply define the index value corresponding to the DropShadowFilter's position in the filters array.
		 * @return The TweenLiteVars instance
		 */
		public function dropShadowFilter(distance:Number=4, blurX:Number=4, blurY:Number=4, alpha:Number=1, angle:Number=45, color:uint=0x000000, strength:Number=2, inner:Boolean=false, knockout:Boolean=false, hideObject:Boolean=false, quality:uint=2, remove:Boolean=false, addFilter:Boolean=false, index:int=-1):TweenLiteVars {
			var filter:Object = {distance:distance, blurX:blurX, blurY:blurY, alpha:alpha, angle:angle, color:color, strength:strength, inner:inner, knockout:knockout, hideObject:hideObject, quality:quality, addFilter:addFilter, remove:remove};
			if (index > -1) {
				filter.index = index;
			}
			return _set("dropShadowFilter", filter, true);
		}
		
		/** 
		 * If you'd like to tween something to a destination value that may change at any time,
		 * dynamicProps allows you to simply associate a function with a property so that
		 * every time the tween is rendered, it calls that function to get the new destination value 
		 * for the associated property. For example, if you want a MovieClip to tween to wherever the
		 * mouse happens to be, you could do:
		 * 
		 * <listing version="3.0">
TweenLite.to(mc, 3, new TweenLiteVars().dynamicProps({x:getMouseX, y:getMouseY})); 
function getMouseX():Number {
	return this.mouseX;
}
function getMouseY():Number {
	return this.mouseY;
}
</listing>
		 * 
		 * <p>Of course you can get as complex as you want inside your custom function, as long as
		 * it returns the destination value, TweenLite/Max will take care of adjusting things 
		 * on the fly.</p>
		 * 
		 * <p>You can optionally pass any number of parameters to functions using the "params" 
		 * parameter like so:</p>
		 * 
		 * <listing version="3.0">
TweenLite.to(mc, 3, new TweenLiteVars().dynamicProps({x:myFunction, y:myFunction}, {x:[mc2, "x"], y:[mc2, "y"]})); 
function myFunction(object:MovieClip, propName:String):Number {
	return object[propName];
}
</listing>
		 * 
		 * <p>DynamicPropsPlugin is a <a href="http://www.greensock.com/club/">Club GreenSock</a> membership benefit. 
		 * You must have a valid membership to use this class without violating the terms of use. 
		 * Visit <a href="http://www.greensock.com/club/">http://www.greensock.com/club/</a> to sign up or get 
		 * more details. </p>
		 * 
		 * <p><strong>USAGE:</strong></p>
		 * <listing version="3.0">
import com.greensock.TweenLite; 
import com.greensock.v12.data.TweenLiteVars;
import com.greensock.v12.plugins.~~;
TweenPlugin.activate([DynamicPropsPlugin]); //activation is permanent in the SWF, so this line only needs to be run once.

TweenLite.to(my_mc, 3, new TweenLiteVars().dynamicProps({x:getMouseX, y:getMouseY}));
	
function getMouseX():Number {
	return this.mouseX;
}
function getMouseY():Number {
	return this.mouseY;
}
</listing>
		 * @param props An object containing properties that are named cooresponding to the properties of the target that should be affected, and the value should point to the function that handles returning the appropriate value, like <code>{x:getMouseX, y:getMouseY}</code>.
		 * @param params An object containing properties that are named corresponding to the properties of the target that should be affected, and the value should be an array of parameters that are passed to the corresponding function, like <code>{x:[mc, "param2"], y:[mc, "param2"]}</code>
		 * @return self
		 **/
		public function dynamicProps(props:Object, params:Object=null):TweenLiteVars {
			if (params != null) {
				props.params = params;
			}
			return _set("dynamicProps", props, true);
		}
		
		/** An Array containing numeric end values of the target Array. Keep in mind that the target of the tween must be an Array with at least the same length as the endArray. **/
		public function endArray(values:Array):TweenLiteVars {
			return _set("endArray", values, true);
		}
		
		/** 
		 * Tweens a MovieClip to a particular frame. 
		 * 
		 * <p><strong>USAGE:</strong></p>
		 * 
		 * <listing version="3.0">
import com.greensock.TweenLite; 
import com.greensock.v12.data.TweenLiteVars;
import com.greensock.v12.plugins.TweenPlugin;
import com.greensock.v12.plugins.FramePlugin;
TweenPlugin.activate([FramePlugin]); //activation is permanent in the SWF, so this line only needs to be run once.

TweenLite.to(mc, 1, new TweenLiteVars().frame(125)); 
</listing>
		 * 
		 * <p>Note: When tweening the frames of a MovieClip, any audio that is embedded on the MovieClip's timeline 
		 * (as "stream") will not be played. Doing so would be impossible because the tween might speed up or slow 
		 * down the MovieClip to any degree.</p>
		 * 
		 * @param value The frame to which the MovieClip should be tweened (or if <code>relative</code> is <code>true</code>, this value would represent the number of frames to travel from the current frame)
		 * @param relative If <code>true</code>, the frame value will be interpreted as relative to the current frame. So for example, if the MovieClip is at frame 5 currently and <code>frame(10, true) is used, the MovieClip will tween 10 frames and end up on frame 15.</code>
		 **/
		public function frame(value:int, relative:Boolean=false):TweenLiteVars {
			return _set("frame", (relative) ? String(value) : value, true);
		}
		
		/** 
		 * Tweens a MovieClip backward to a particular frame number, wrapping it if/when it reaches the beginning
		 * of the timeline. For example, if your MovieClip has 20 frames total and it is currently at frame 10
		 * and you want tween to frame 15, a normal frame tween would go forward from 10 to 15, but a frameBackward
		 * would go from 10 to 1 (the beginning) and wrap to the end and continue tweening from 20 to 15.
		 **/
		public function frameBackward(frame:int):TweenLiteVars {
			return _set("frameBackward", frame, true);
		}
		
		/** 
		 * Tweens a MovieClip forward to a particular frame number, wrapping it if/when it reaches the end
		 * of the timeline. For example, if your MovieClip has 20 frames total and it is currently at frame 10
		 * and you want tween to frame 5, a normal frame tween would go backwards from 10 to 5, but a frameForward
		 * would go from 10 to 20 (the end) and wrap to the beginning and continue tweening from 1 to 5. 
		 **/
		public function frameForward(frame:int):TweenLiteVars {
			return _set("frameForward", frame, true);
		}
		
		/** Tweens a MovieClip to a particular frame. **/
		public function frameLabel(label:String):TweenLiteVars {
			return _set("frameLabel", label, true);
		}
		
		
		/**
		 * Tweens a GlowFilter
		 * 
		 * @param blurX The amount of horizontal blur.
		 * @param blurY The amount of vertical blur.
		 * @param color The color of the glow.
		 * @param alpha The alpha transparency value for the color.
		 * @param strength The strength of the imprint or spread.
		 * @param inner Specifies whether the glow is an inner glow.
		 * @param knockout Specifies whether the object has a knockout effect.
		 * @param quality The number of times to apply the filter.
		 * @param remove If true, the filter will be removed as soon as the tween completes
		 * @param addFilter If true, a new GlowFilter will be added to the target even if a GlowFilter is already in its filters array.
		 * @param index Allows you to target a particular GlowFilter if there are multiple GlowFilters in the target's filters array - simply define the index value corresponding to the GlowFilter's position in the filters array.
		 * @return The TweenLiteVars instance
		 */
		public function glowFilter(blurX:Number=10, blurY:Number=10, color:uint=0xFFFFFF, alpha:Number=1, strength:Number=2, inner:Boolean=false, knockout:Boolean=false, quality:uint=2, remove:Boolean=false, addFilter:Boolean=false, index:int=-1):TweenLiteVars {
			var filter:Object = {blurX:blurX, blurY:blurY, color:color, alpha:alpha, strength:strength, inner:inner, knockout:knockout, quality:quality, addFilter:addFilter, remove:remove};
			if (index > -1) {
				filter.index = index;
			}
			return _set("glowFilter", filter, true);
		}
		
		/** 
		 * Although hex colors are technically numbers, if you try to tween them conventionally, 
		 * you'll notice that they don't tween smoothly. To tween them properly, the red, green, and 
		 * blue components must be extracted and tweened independently. The HexColorsPlugin makes it easy. 
		 * To tween a property of your object that's a hex color to another hex color, just pass a hexColors 
		 * Object with properties named the same as your object's hex color properties. For example, 
		 * if myObject has a "myHexColor" property that you'd like to tween to red (<code>0xFF0000</code>) over the 
		 * course of 2 seconds, you'd do:
		 * 
		 * <p><code>
		 * TweenMax.to(myObject, 2, new TweenLiteVars().hexColors({myHexColor:0xFF0000}));
		 * </code></p>
		 * 	
		 * <p>You can pass in any number of hexColor properties.</p>
		 * 
		 * <p><strong>USAGE:</strong></p>
		 * <listing version="3.0">
import com.greensock.TweenLite; 
import com.greensock.v12.data.TweenLiteVars;
import com.greensock.v12.plugins.TweenPlugin;
import com.greensock.v12.plugins.HexColorsPlugin;
TweenPlugin.activate([HexColorsPlugin]); //activation is permanent in the SWF, so this line only needs to be run once.

TweenLite.to(myObject, 2, new TweenLiteVars().hexColors({myHexColor:0xFF0000}));
</listing>
		 * <p>Or if you just want to tween a color and apply it somewhere on every frame, you could do:</p>
		 * <listing version="3.0">
var myColor:Object = {hex:0xFF0000};
TweenLite.to(myColor, 2, new TweenLiteVars().hexColors({hex:0x0000FF}).onUpdate(applyColor));
function applyColor():void {
	mc.graphics.clear();
	mc.graphics.beginFill(myColor.hex, 1);
	mc.graphics.drawRect(0, 0, 100, 100);
	mc.graphics.endFill();
}
</listing>
		 * 
		 **/
		public function hexColors(values:Object):TweenLiteVars {
			return _set("hexColors", values, true);
		}
		
		
		/**
		 * MotionBlurPlugin provides an easy way to apply a directional blur to a DisplayObject based on its velocity
		 * and angle of movement in 2D (x/y). This creates a much more realistic effect than a standard BlurFilter for
		 * several reasons:
		 * <ol>
		 * 		<li>A regular BlurFilter is limited to blurring horizontally and/or vertically whereas the motionBlur 
		 * 		   gets applied at the angle at which the object is moving.</li>
		 * 
		 * 		<li>A BlurFilter tween has static start/end values whereas a motionBlur tween dynamically adjusts the
		 * 			values on-the-fly during the tween based on the velocity of the object. So if you use a <code>Strong.easeInOut</code>
		 * 			for example, the strength of the blur will start out low, then increase as the object moves faster, and 
		 * 			reduce again towards the end of the tween.</li>
		 * </ol>
		 * 
		 * <p>motionBlur even works on bezier/bezierThrough tweens!</p>
		 * 
		 * <p>To accomplish the effect, MotionBlurPlugin creates a Bitmap that it places over the original object, changing 
		 * alpha of the original to [almost] zero during the course of the tween. The original DisplayObject still follows the 
		 * course of the tween, so MouseEvents are properly dispatched. You shouldn't notice any loss of interactivity. 
		 * The DisplayObject can also have animated contents - MotionBlurPlugin automatically updates on every frame. 
		 * Be aware, however, that as with most filter effects, MotionBlurPlugin is somewhat CPU-intensive, so it is not 
		 * recommended that you tween large quantities of objects simultaneously. You can activate <code>fastMode</code>
		 * to significantly speed up rendering if the object's contents and size/color doesn't need to change during the
		 * course of the tween. </p>
		 *  
		 * @param strength Determines the strength of the blur. The default is 1. For a more powerful blur, increase the number. Or reduce it to make the effect more subtle.
		 * @param fastMode Setting fastMode to <code>true</code> will significantly improve rendering performance but it is only appropriate for situations when the target object's contents,  size, color, filters, etc. do not need to change during the course of the tween. It works by essentially taking a BitmapData snapshot of the target object at the beginning of the tween and then reuses that throughout the tween, blurring it appropriately. The default value for <code>fastMode</code> is <code>false</code>.
		 * @param quality The lower the quality, the less CPU-intensive the effect will be. Options are 1, 2, or 3. The default is 2.
		 * @param padding padding controls the amount of space around the edges of the target object that is included in the BitmapData capture (the default is 10 pixels). If the target object has filters applied to it like a GlowFilter or DropShadowFilter that extend beyond the bounds of the object itself, you might need to increase the padding to accommodate the filters.
		 * @return The TweenLiteVars instance
		 */
		public function motionBlur(strength:Number=1, fastMode:Boolean=false, quality:int=2, padding:int=10):TweenLiteVars {
			return _set("motionBlur", {strength:strength, fastMode:fastMode, quality:quality, padding:padding}, true);
		}
		
		/**
		 * A common effect that designers/developers want is for a MovieClip/Sprite to orient itself in the direction of 
		 * a Bezier path (alter its rotation). orientToBezier makes it easy. In order to alter a rotation property accurately, 
		 * TweenLite/Max needs 4 pieces of information:
		 * <ol>
		 * 		<li>Position property 1 (typically "x")</li>
		 * 		<li>Position property 2 (typically "y")</li>
		 * 		<li>Rotational property (typically "rotation")</li>
		 * 		<li>Number of degrees to add (optional - makes it easy to orient your MovieClip/Sprite properly)</li>
		 * </ol>
		 * 
		 * <p>The orientToBezier property should be an Array containing one Array for each set of these values. 
		 * For maximum flexibility, you can pass in any number of Arrays inside the container Array, one for 
		 * each rotational property. This can be convenient when working in 3D because you can rotate on multiple axis. 
		 * If you're doing a standard 2D x/y tween on a bezier, you can simply pass in a boolean value of true and 
		 * TweenMax will use a typical setup, <code>[["x", "y", "rotation", 0]]</code>. 
		 * Hint: Don't forget the container Array (notice the double outer brackets)</p>
		 * 
		 * <p>To use the default value (<code>[["x", "y", "rotation", 0]]</code>), you can simply leave the values parameter as null. </p>
		 */
		public function orientToBezier(values:Object=null):TweenLiteVars {
			return _set("orientToBezier", (values == null) ? true : values, false);
		}
		
		
		/**
		 * Provides simple physics functionality for tweening a DisplayObject's x and y coordinates based on a
		 * combination of velocity, angle, gravity, acceleration, accelerationAngle, and/or friction. It is not intended
		 * to replace a full-blown physics engine and does not offer collision detection, but serves 
		 * as a way to easily create interesting physics-based effects with the GreenSock tweening platform. Parameters
		 * are not intended to be dynamically updateable, but one unique convenience is that everything is reverseable. 
		 * So if you spawn a bunch of particle tweens, for example, and throw them into a TimelineLite, you could
		 * simply call reverse() on the timeline to watch the particles retrace their steps right back to the beginning. 
		 * Keep in mind that any easing equation you define for your tween will be completely ignored for these properties.
		 * 
		 * <p><strong>USAGE:</strong></p>
		 * <listing version="3.0">
import com.greensock.TweenLite; 
import com.greensock.TweenLiteVars; 
import com.greensock.v12.plugins.TweenPlugin;
import com.greensock.v12.plugins.Physics2DPlugin;
TweenPlugin.activate([Physics2DPlugin]); //activation is permanent in the SWF, so this line only needs to be run once.

TweenLite.to(mc, 2, new TweenLiteVars().physics2D(300, -60, 400)); 
</listing>
		 * 
		 * <p>Physics2DPlugin is a Club GreenSock membership benefit. You must have a valid membership to use this class
		 * without violating the terms of use. Visit http://www.greensock.com/club/ to sign up or get more details.</p>
		 * 
		 * @param velocity The initial velocity of the object measured in pixels per time unit (usually seconds, but for tweens where useFrames is true, it would be measured in frames). The default is zero.
		 * @param angle The initial angle (in degrees) at which the object is traveling. Only pertinent when a velocity is defined. For example, if the object should start out traveling at -60 degrees (towards the upper right), the angle would be -60. The default is zero.
		 * @param acceleration The amount of acceleration applied to the object, measured in pixels per time unit (usually seconds, but for tweens where useFrames is true, it would be measured in frames). To apply the acceleration in a specific direction that is different than the <code>angle</code>, use the <code>accelerationAngle</code> property.
		 * @param accelerationAngle The angle at which acceleration is applied (if any), measured in degrees. So if, for example, you want the object to accelerate towards the left side of the screen, you'd use an <code>accelerationAngle</code> of 180.
		 * @param friction A value between 0 and 1 where 0 is no friction, 0.08 is a small amount of friction, and 1 will completely prevent any movement. This is not meant to be precise or scientific in any way, but rather serves as an easy way to apply a friction-like physics effect to your tween. Generally it is best to experiment with this number a bit. Also note that friction requires more processing than physics tweens without any friction.
		 * @return The TweenLiteVars instance
		 * @see #physicsProps()
		 */
		public function physics2D(velocity:Number, angle:Number, acceleration:Number=0, accelerationAngle:Number=90, friction:Number=0):TweenLiteVars {
			return _set("physics2D", {velocity:velocity, angle:angle, acceleration:acceleration, accelerationAngle:accelerationAngle, friction:friction}, true);
		}
		
		/** 
		 * Sometimes you want to tween a property (or several) but you don't have a specific end value in mind - instead,
		 * you'd rather describe the movement in terms of physics concepts, like velocity, acceleration, 
		 * and/or friction. physicsProps allows you to tween any numeric property of any object based
		 * on these concepts. Keep in mind that any easing equation you define for your tween will be completely
		 * ignored for these properties. Instead, the physics parameters will determine the movement/easing.
		 * These parameters, by the way, are not intended to be dynamically updateable, but one unique convenience 
		 * is that everything is reverseable. So if you create several physics-based tweens, for example, and 
		 * throw them into a TimelineLite, you could simply call reverse() on the timeline to watch the objects 
		 * retrace their steps right back to the beginning. Here are the parameters you can define (note that 
		 * friction and acceleration are both completely optional):
		 * <ul>
		 * 		<li><strong>velocity : Number</strong> - the initial velocity of the object measured in units per time 
		 * 								unit (usually seconds, but for tweens where useFrames is true, it would 
		 * 								be measured in frames). The default is zero.</li>
		 * 		<li><strong>acceleration : Number</strong> [optional] - the amount of acceleration applied to the object, measured
		 * 								in units per time unit (usually seconds, but for tweens where useFrames 
		 * 								is true, it would be measured in frames). The default is zero.</li>
		 * 		<li><strong>friction : Number</strong> [optional] - a value between 0 and 1 where 0 is no friction, 0.08 is a small amount of
		 * 								friction, and 1 will completely prevent any movement. This is not meant to be precise or 
		 * 								scientific in any way, but rather serves as an easy way to apply a friction-like
		 * 								physics effect to your tween. Generally it is best to experiment with this number a bit.
		 * 								Also note that friction requires more processing than physics tweens without any friction.</li>
		 * 	</ul>
		 * 
		 * <p><strong>USAGE:</strong></p>
		 * <listing version="3.0">
import com.greensock.TweenLite; 
import com.greensock.v12.data.TweenLiteVars;
import com.greensock.v12.plugins.TweenPlugin;
import com.greensock.v12.plugins.PhysicsPropsPlugin;
TweenPlugin.activate([PhysicsPropsPlugin]); //activation is permanent in the SWF, so this line only needs to be run once.

TweenLite.to(mc, 2, new TweenLiteVars().physicsProps({
				x:{velocity:100, acceleration:200},
				y:{velocity:-200, friction:0.1}
			}
)); 
</listing>
		 * 
		 * <p>PhysicsPropsPlugin is a Club GreenSock membership benefit. You must have a valid membership to use this class
		 * without violating the terms of use. Visit http://www.greensock.com/club/ to sign up or get more details.</p>
		 * 
		 * @see #physics2D()
		 **/
		public function physicsProps(values:Object):TweenLiteVars {
			return _set("physicsProps", values, true);
		}
		
		/** An object with properties that correspond to the quaternion properties of the target object. For example, if your my3DObject has "orientation" and "childOrientation" properties that contain quaternions, and you'd like to tween them both, you'd do: {orientation:myTargetQuaternion1, childOrientation:myTargetQuaternion2}. Quaternions must have the following properties: x, y, z, and w. **/
		public function quaternions(values:Object):TweenLiteVars {
			return _set("quaternions", values, true);
		}
		
		/** Removes the tint of a DisplayObject over time. **/
		public function removeTint(remove:Boolean=true):TweenLiteVars {
			return _set("removeTint", remove, true);
		}
		
		/** 
		 * Tweens the scrollRect property of a DisplayObject. You can define any (or all) of the following properties:
		 * <code>
		 * <ul>
		 * 		<li> x : Number</li>
		 * 		<li> y : Number</li>
		 * 		<li> width : Number</li>
		 * 		<li> height : Number</li>
		 * 		<li> top : Number</li>
		 * 		<li> bottom : Number</li>
		 * 		<li> left : Number</li>
		 * 		<li> right : Number</li>
		 * </ul>
		 * </code>
		 * 
		 * <p><strong>USAGE:</strong></p>
		 * <listing version="3.0">
import com.greensock.TweenLite; 
import com.greensock.v12.data.TweenLiteVars
import com.greensock.v12.plugins.TweenPlugin;
import com.greensock.v12.plugins.ScrollRectPlugin;
TweenPlugin.activate([ScrollRectPlugin]); //activation is permanent in the SWF, so this line only needs to be run once.

TweenLite.to(mc, 1, new TweenLiteVars().scrollRect({x:50, y:300, width:100, height:100})); 
</listing>
		 **/
		public function scrollRect(props:Object):TweenLiteVars {
			return _set("scrollRect", props, true);
		}
		
		/** 
		 * Some components require resizing with setSize() instead of standard tweens of width/height in
		 * order to scale properly. The SetSizePlugin accommodates this easily. You can define the width, 
		 * height, or both. 
		 * 
		 * <p><strong>USAGE:</strong></p>
		 * <listing version="3.0">
import com.greensock.TweenLite; 
import com.greensock.v12.data.TweenLiteVars;
import com.greensock.v12.plugins.TweenPlugin;
import com.greensock.v12.plugins.SetSizePlugin;
TweenPlugin.activate([SetSizePlugin]); //activation is permanent in the SWF, so this line only needs to be run once.

TweenLite.to(myComponent, 1, new TweenLiteVars().setSize(200, 30)); 
</listing>
		 **/
		public function setSize(width:Number=NaN, height:Number=NaN):TweenLiteVars {
			var values:Object = {};
			if (!isNaN(width)) {
				values.width = width;
			}
			if (!isNaN(height)) {
				values.height = height;
			}
			return _set("setSize", values, true);
		}
		
		/** 
		 * To tween any rotation property of the target object in the shortest direction, use "shortRotation" 
		 * For example, if <code>myObject.rotation</code> is currently 170 degrees and you want to tween it to 
		 * -170 degrees, a normal rotation tween would travel a total of 340 degrees in the counter-clockwise 
		 * direction, but if you use shortRotation, it would travel 20 degrees in the clockwise direction instead. 
		 * You can define any number of rotation properties in the shortRotation object which makes 3D tweening
		 * easier, like:
		 * 
		 * <p><code> 
		 * TweenLite.to(mc, 2, new TweenLiteVars().shortRotation({rotationX:-170, rotationY:35, rotationZ:200}));
		 * </code></p>
		 * 
		 * <p><strong>USAGE:</strong></p>
		 * <listing version="3.0">
import com.greensock.TweenLite; 
import com.greensock.v12.data.TweenLiteVars;
import com.greensock.v12.plugins.TweenPlugin;
import com.greensock.v12.plugins.ShortRotationPlugin;
TweenPlugin.activate([ShortRotationPlugin]); //activation is permanent in the SWF, so this line only needs to be run once.

TweenLite.to(mc, 1, new TweenLiteVars().shortRotation({rotation:-170}));

//or for a 3D tween with multiple rotation values...
TweenLite.to(mc, 1, new TweenLiteVars().shortRotation({rotationX:-170, rotationY:35, rotationZ:10})); 
</listing>
		 **/
		public function shortRotation(values:Object):TweenLiteVars {
			if (typeof(values) == "number") {
				values = {rotation:values};
			}
			return _set("shortRotation", values, true);
		}
		
		
		/**
		 * Tweens properties of an object's soundTransform property (like the volume, pan, leftToRight, etc. 
		 * of a MovieClip/SoundChannel/NetStream). 
		 * 
		 * <p><strong>USAGE:</strong></p>
		 * <listing version="3.0">
import com.greensock.TweenLite; 
import com.greensock.v12.data.TweenLiteVars;
import com.greensock.v12.plugins.TweenPlugin;
import com.greensock.v12.plugins.SoundTransformPlugin;
TweenPlugin.activate([SoundTransformPlugin]); //activation is permanent in the SWF, so this line only needs to be run once.

TweenLite.to(mc, 1, new TweenLiteVars().soundTransform(0.2, 0.5)); 
</listing>
		 *  
		 * @param volume The volume, ranging from 0 (silent) to 1 (full volume).
		 * @param pan The left-to-right panning of the sound, ranging from -1 (full pan left) to 1 (full pan right).
		 * @param leftToLeft A value, from 0 (none) to 1 (all), specifying how much of the left input is played in the left speaker.
		 * @param leftToRight A value, from 0 (none) to 1 (all), specifying how much of the left input is played in the right speaker.
		 * @param rightToLeft A value, from 0 (none) to 1 (all), specifying how much of the right input is played in the left speaker.
		 * @param rightToRight A value, from 0 (none) to 1 (all), specifying how much of the right input is played in the right speaker.
		 * @return The TweenLiteVars instance
		 */
		public function soundTransform(volume:Number=1, pan:Number=0, leftToLeft:Number=1, leftToRight:Number=0, rightToLeft:Number=0, rightToRight:Number=1):TweenLiteVars {
			return _set("soundTransform", {volume:volume, pan:pan, leftToLeft:leftToLeft, leftToRight:leftToRight, rightToLeft:rightToLeft, rightToRight:rightToRight}, true);
		}
		
		/**
		 * Sets the stage's <code>quality</code> to a particular value during a tween and another value after
		 * the tween which can be useful for improving rendering performance in the Flash Player while things are animating.
		 * 
		 * <p><strong>USAGE:</strong></p>
		 * <listing version="3.0">
import com.greensock.TweenLite; 
import com.greensock.v12.data.TweenLiteVars;
import com.greensock.v12.plugins.TweenPlugin;
import com.greensock.v12.plugins.StageQualityPlugin;
import flash.display.StageQuality; 
TweenPlugin.activate([StageQualityPlugin]); //activation is permanent in the SWF, so this line only needs to be run once.

TweenLite.to(mc, 1, new TweenLiteVars().prop("x", 100).stageQuality(this.stage, StageQuality.LOW, StageQuality.HIGH)); 
</listing>
		 * 
		 * @param stage A reference to the stage
		 * @param during The stage quality that should be used during the tween
		 * @param after The stage quality that should be set after the tween completes
		 * @return The TweenLiteVars instance
		 */
		public function stageQuality(stage:Stage, during:String="medium", after:String=null):TweenLiteVars {
			if (after == null) {
				after = stage.quality;
			}
			return _set("stageQuality", {stage:stage, during:during, after:after}, true);
		}
		
		/** 
		 * Allows you to define an initial velocity at which a property (or multiple properties) will start tweening, 
		 * as well as [optional] maximum and/or minimum end values and then it will calculate the appropriate landing 
		 * position and plot a smooth course to it based on the easing equation you define (Quad.easeOut by default, 
		 * as set in TweenLite). This is perfect for flick-scrolling or animating things as though they are being thrown.
		 * 
		 * <p>In its simplest form, you can pass just the initial velocity for each property like this: <code>
		 * {x:500, y:-300}</code></p>
		 * 
		 * <p>In the above example, <code>x</code> will animate at 500 pixels per second initially and 
		 * <code>y</code> will animate at -300 pixels per second. Both will decelerate smoothly 
		 * until they come to rest based on the tween's duration. </p>
		 * 
		 * <p>To impose maximum and minimum boundaries on the end values, use the nested object syntax 
		 * with the <code>max</code> and <code>min</code> special properties like this: <code>
		 * {x:{velocity:500, max:1024, min:0}, y:{velocity:-300, max:720, min:0}};
		 * </code></p>
		 * 
		 * <p>Notice the nesting of the objects ({}). The <code>max</code> and <code>min</code> values refer
		 * to the range for the final resting position (coordinates in this case), NOT the velocity. 
		 * So <code>x</code> would always land between 0 and 1024 in this case, and <code>y</code> 
		 * would always land between 0 and 720. If you want the target object to land on a specific value 
		 * rather than within a range, simply set <code>max</code> and <code>min</code> to identical values. 
		 * Also notice that you must define a <code>velocity</code> value for each property in the object syntax.</p>
		 * 
		 * <p><code>throwProps</code> isn't just for tweening x and y coordinates. It works with any numeric 
		 * property, so you could use it for spinning the <code>rotation</code> of an object as well. Or the 
		 * <code>scaleX</code>/<code>scaleY</code> properties. Maybe the user drags to spin a wheel and
		 * lets go and you want it to continue increasing the <code>rotation</code> at that velocity, 
		 * decelerating smoothly until it stops.</p>
		 * 
		 * <p>ThrowPropsPlugin is a <a href="http://www.greensock.com/club/">Club GreenSock</a> membership benefit. 
		 * You must have a valid membership to use this class without violating the terms of use. Visit 
		 * <a href="http://www.greensock.com/club/">http://www.greensock.com/club/</a> to sign up or get more details.</p>
		 **/
		public function throwProps(props:Object):TweenLiteVars {
			return _set("throwProps", props, true);
		}
		
		/** 
		 * To change a DisplayObject's tint, set this to the hex value of the color you'd like the DisplayObject 
		 * to end up at (or begin at if you're using TweenLite.from()). An example hex value would be 0xFF0000. 
		 * If you'd like to remove the tint from a DisplayObject, use the removeTint special property. 
		 * @see #removeTint()
		 * @see #colorMatrixFilter()
		 * @see #colorTransform()
		 **/
		public function tint(color:uint):TweenLiteVars {
			return _set("tint", color, true);
		}
		
		/** 
		 * Normally, all transformations (scale, rotation, and position) are based on the DisplayObject's registration
		 * point (most often its upper left corner), but TransformAroundCenter allows you to make the transformations
		 * occur around the DisplayObject's center. 
		 * 
		 * <p>If you define an x or y value in the transformAroundCenter object, it will correspond to the center which 
		 * makes it easy to position (as opposed to having to figure out where the original registration point 
		 * should tween to). If you prefer to define the x/y in relation to the original registration point, do so outside 
		 * the transformAroundCenter object, like: </p>
		 * 
		 * <p><code>
		 * TweenLite.to(mc, 3, new TweenLiteVars().prop("x", 50).prop("y", 40).transformAroundCenter({scale:0.5, rotation:30}));
		 * </code></p>
		 * 
		 * <p>TransformAroundCenterPlugin is a <a href="http://www.greensock.com/club/">Club GreenSock</a> membership benefit. 
		 * You must have a valid membership to use this class without violating the terms of use. Visit 
		 * <a href="http://www.greensock.com/club/">http://www.greensock.com/club/</a> to sign up or get more details. </p>
		 * 
		 * <p><strong>USAGE:</strong></p>
		 * <listing version="3.0">
import com.greensock.TweenLite; 
import com.greensock.v12.data.TweenLiteVars;
import com.greensock.v12.plugins.TweenPlugin;
import com.greensock.v12.plugins.TransformAroundCenterPlugin;
TweenPlugin.activate([TransformAroundCenterPlugin]); //activation is permanent in the SWF, so this line only needs to be run once.

TweenLite.to(mc, 1, new TweenLiteVars().transformAroundCenter({scale:1.5, rotation:150})); 
</listing> 
		 * @see #transformAroundPoint()
		 **/
		public function transformAroundCenter(props:Object):TweenLiteVars {
			return _set("transformAroundCenter", props, true);
		}
		
		/** 
		 * Normally, all transformations (scale, rotation, and position) are based on the DisplayObject's registration
		 * point (most often its upper left corner), but TransformAroundPoint allows you to define ANY point around which
		 * transformations will occur during the tween. For example, you may have a dynamically-loaded image that you 
		 * want to scale from its center or rotate around a particular point on the stage. 
		 * 
		 * <p>If you define an x or y value in the transformAroundPoint object, it will correspond to the custom registration
		 * point which makes it easy to position (as opposed to having to figure out where the original registration point 
		 * should tween to). If you prefer to define the x/y in relation to the original registration point, do so outside 
		 * the transformAroundPoint object, like: </p>
		 * 
		 * <p><code>
		 * TweenLite.to(mc, 3, new TweenLiteVars().prop("x", 50).prop("y", 40).transformAroundPoint(new Point(200, 300), {scale:0.5, rotation:30}));
		 * </code></p>
		 * 
		 * <p>TransformAroundPointPlugin is a <a href="http://www.greensock.com/club/">Club GreenSock</a> membership benefit. 
		 * You must have a valid membership to use this class without violating the terms of use. Visit 
		 * <a href="http://www.greensock.com/club/">http://www.greensock.com/club/</a> to sign up or get more details. </p>
		 * 
		 * <p><strong>USAGE:</strong></p>
		 * <listing version="3.0">
import com.greensock.TweenLite; 
import com.greensock.v12.data.TweenLiteVars;
import com.greensock.v12.plugins.TweenPlugin;
import com.greensock.v12.plugins.TransformAroundPointPlugin;
TweenPlugin.activate([TransformAroundPointPlugin]); //activation is permanent in the SWF, so this line only needs to be run once.

TweenLite.to(mc, 1, new TweenLiteVars().transformAroundPoint(new Point(100, 300), {scaleX:2, scaleY:1.5, rotation:150})); 
</listing>
		 * @see #transformAroundCenter()
		 **/
		public function transformAroundPoint(point:Point, props:Object):TweenLiteVars {
			props.point = point;
			return _set("transformAroundPoint", props, true);
		}
		
		/**
		 * transformMatrix tweens a DisplayObject's transform.matrix values directly either using
		 * the standard matrix properties (<code>a, b, c, d, tx, and ty</code>) or common properties 
		 * like <code>x, y, scaleX, scaleY, skewX, skewY, rotation</code> and even <code>shortRotation</code>.
		 * To skew without adjusting scale visually, use skewX2 and skewY2 instead of skewX and skewY. 
		 * 
		 * 
		 * <p>transformMatrix tween will affect all of the DisplayObject's transform properties, so do not use
		 * it in conjunction with regular x/y/scaleX/scaleY/rotation tweens concurrently.</p>
		 * 
		 * <p><strong>USAGE:</strong></p>
		 * <listing version="3.0">
import com.greensock.TweenLite; 
import com.greensock.v12.data.TweenLiteVars;
import com.greensock.v12.plugins.TweenPlugin;
import com.greensock.v12.plugins.TransformMatrixPlugin;
TweenPlugin.activate([TransformMatrixPlugin]); //activation is permanent in the SWF, so this line only needs to be run once.

TweenLite.to(mc, 1, new TweenLiteVars().transformMatrix({x:50, y:300, scaleX:2, scaleY:2})); 
	
//-OR-

TweenLite.to(mc, 1, new TweenLiteVars().transformMatrix({tx:50, ty:300, a:2, d:2})); 
</listing>
		 **/
		public function transformMatrix(properties:Object):TweenLiteVars {
			return _set("transformMatrix", properties, true);
		}
		
		/** Sets a DisplayObject's "visible" property at the end of the tween. **/
		public function visible(value:Boolean):TweenLiteVars {
			return _set("visible", value, true);
		}
		
		/** Changes the volume of any object that has a soundTransform property (MovieClip, SoundChannel, NetStream, etc.) **/
		public function volume(volume:Number):TweenLiteVars {
			return _set("volume", volume, true);
		}
		
		
//---- GETTERS / SETTERS -------------------------------------------------------------------------------------------------------------
		
		/** The generic object populated by all of the method calls in the TweenLiteVars instance. This is the raw data that gets passed to the tween. **/
		public function get vars():Object {
			return _vars;
		}
		
		/** @private **/
		public function get _isGSVars():Boolean {
			return true;
		}
		
	}
}