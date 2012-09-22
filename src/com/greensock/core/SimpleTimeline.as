/**
 * VERSION: 12.0 beta 4.2
 * DATE: 2012-03-22
 * AS3 (AS2 version is also available)
 * UPDATES AND DOCS AT: http://www.greensock.com
 **/
package com.greensock.core {
/**
 * SimpleTimeline is the base class for TimelineLite and TimelineMax, providing the
 * most basic timeline functionality and it is used for the root timelines in TweenLite but is only
 * intended for internal use in the GreenSock tweening platform. It is meant to be very fast and lightweight.
 * 
 * <p><strong>Copyright 2008-2012, GreenSock. All rights reserved.</strong> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for <a href="http://www.greensock.com/club/">Club GreenSock</a> members, the software agreement that was issued with the membership.</p>
 * 
 * @author Jack Doyle, jack@greensock.com
 */	
	public class SimpleTimeline extends Animation {
		
		/** If <code>true</code>, child tweens/timelines will be removed as soon as they complete. (<code>false</code> by default except on the root timeline(s)) **/
		public var autoRemoveChildren:Boolean; 
		
		/** 
		 * Controls whether or not child tweens/timelines are repositioned automatically (changing their <code>startTime</code>) 
		 * in order to maintain smooth playback when properties are changed on-the-fly. For example, imagine that 
		 * the timeline's playhead is on a child tween that is 75% complete, moving mc.x from 0 to 100 and then 
		 * that tween's <code>reverse()</code> method is called. If <code>smoothChildTiming</code> is <code>false</code> 
		 * (the default except for the root timelines), the tween would flip in place, keeping its <code>startTime</code> 
		 * consistent. Therefore the playhead of the timeline would now be at the tween's 25% completion point instead 
		 * of 75%. Remember, the timeline's playhead position and direction are unaffected by child tween/timeline changes.
		 * mc.x would jump from 75 to 25, but the tween's position in the timeline would remain consistent. 
		 * However, if <code>smoothChildTiming</code> is <code>true</code>, that child tween's <code>startTime</code> would
		 * be adjusted so that the timeline's playhead intersects with the same spot on the tween (75% complete) as it had 
		 * immediately before <code>reverse()</code> was called, thus playback appears perfectly smooth. mc.x would 
		 * still be 75 and it would continue from there as the playhead moves on, but since the tween is reversed now
		 * mc.x will travel back towards 0 instead of 100. Ultimately it's a decision between prioritizing smooth 
		 * on-the-fly playback (<code>true</code>) or consistent position(s) of child tweens/timelines (<code>false</code>). 
		 * 
		 * <p>Some examples of on-the-fly changes to child tweens/timelines that could cause their <code>startTime</code>
		 * to change when <code>smoothChildTiming</code> is <code>true</code> are: <code>reversed, timeScale, progress, 
		 * totalProgress, time, totalTime, delay, pause, resume, duration,</code> and <code>totalDuration</code>.</p>
		 **/
		public var smoothChildTiming:Boolean;
		
		/** @private If true, children are sorted in order of their <code>startTime</code> when inserted (improves rendering accuracy in certain situations) **/
		public var _sortChildren:Boolean;
		
		/** @private first child in the linked list **/
		public var _first:Animation;
		
		/** @private last child in the linked list **/
		public var _last:Animation;
		
		/**
		 * Constructor
		 * 
		 * @param vars Object containing configuration variables like onComplete, onUpdate, onStart, data, etc.
		 */
		public function SimpleTimeline(vars:Object=null) {
			super(0, vars);
			this.autoRemoveChildren = this.smoothChildTiming = true;
		}
		
		/**
		 * Inserts a TweenLite, TweenMax, TimelineLite, or TimelineMax instance into the timeline at a specific time. 
		 * In classes like TimelineLite and TimelineMax that override this method, it allows things like callbacks,
		 * labels, and arrays of tweens/timelines/callbacks/labels to be inserted too. They also allow the time to
		 * be defined in terms of either a numeric time or a label (String).
		 * 
		 * @param tween TweenLite, TweenMax, TimelineLite, or TimelineMax instance to insert
		 * @param time The time in seconds (or frames for frames-based timelines) at which the tween/timeline should be inserted. For example, <code>myTimeline.insert(myTween, 3)</code> would insert myTween 3 seconds into the timeline.
		 * @return this timeline instance (useful for chaining like <code>myTimeline.insert(...).insert(...)</code>)
		 */
		public function insert(tween:*, time:*=0):* {
			tween._startTime = Number(time || 0) + tween._delay;
			if (tween._paused) if (this != tween._timeline) { //we only adjust the _pauseTime if it wasn't in this timeline already. Remember, sometimes a tween will be inserted again into the same timeline when its startTime is changed so that the tweens in the TimelineLite/Max are re-ordered properly in the linked list (so everything renders in the proper order). 
				tween._pauseTime = tween._startTime + ((rawTime() - tween._startTime) / tween._timeScale);
			}
			if (tween.timeline) {
				tween.timeline._remove(tween, true); //removes from existing timeline so that it can be properly added to this one.
			}
			tween.timeline = tween._timeline = this;
			if (tween._gc) {
				tween._enabled(true, true);
			}
			
			var prevTween:Animation = _last;
			if (_sortChildren) {
				var st:Number = tween._startTime;
				while (prevTween && prevTween._startTime > st) {
					prevTween = prevTween._prev;
				}
			}
			if (prevTween) {
				tween._next = prevTween._next;
				prevTween._next = Animation(tween);
			} else {
				tween._next = _first;
				_first = Animation(tween);
			}
			if (tween._next) {
				tween._next._prev = tween;
			} else {
				_last = Animation(tween);
			}
			tween._prev = prevTween;
			
			if (_timeline) {
				_uncache(true);
			}
			
			return this;
		}
		
		/** @private **/
		public function _remove(tween:Animation, skipDisable:Boolean=false):* {
			if (tween.timeline == this) {
				if (!skipDisable) {
					tween._enabled(false, true);
				}
				tween.timeline = null;
				
				if (tween._prev) {
					tween._prev._next = tween._next;
				} else if (_first === tween) {
					_first = tween._next;
				}
				if (tween._next) {
					tween._next._prev = tween._prev;
				} else if (_last === tween) {
					_last = tween._prev;
				}
				
				if (_timeline) {
					_uncache(true);
				}
			}
			return this;
		}

		/** @inheretDoc **/
		override public function render(time:Number, suppressEvents:Boolean=false, force:Boolean=false):void {
			var tween:Animation = _first, next:Animation;
			_totalTime = _time = _rawPrevTime = time;
			while (tween) {
				next = tween._next; //record it here because the value could change after rendering...
				if (tween._active || (time >= tween._startTime && !tween._paused)) {
					if (!tween._reversed) {
						tween.render((time - tween._startTime) * tween._timeScale, suppressEvents, false);
					} else {
						tween.render(((!tween._dirty) ? tween._totalDuration : tween.totalDuration()) - ((time - tween._startTime) * tween._timeScale), suppressEvents, false);
					}
				}
				tween = next;
			}
		}
		
		
//---- GETTERS / SETTERS ------------------------------------------------------------------------------
		
		/**
		 * @private
		 * Reports the totalTime of the timeline without capping the number at the <code>totalDuration</code> (max) and zero (minimum) 
		 * which can be useful when unpausing tweens/timelines. Imagine a case where a paused tween is in a timeline that has already 
		 * reached the end, but then the tween gets unpaused - it needs a way to place itself accurately in time AFTER what was 
		 * previously the timeline's end time. In a SimpleTimeline, <code>rawTime</code> is always the same as <code>_totalTime</code>, 
		 * but in TimelineLite and TimelineMax, it can be different.
		 * 
		 * @return The <code>totalTime</code> of the timeline without capping the number at the <code>totalDuration</code> (max) and zero (minimum)
		 */
		public function rawTime():Number {
			return _totalTime;			
		}
		
	}
}