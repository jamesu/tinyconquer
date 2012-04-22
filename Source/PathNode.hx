package;


import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.easing.Quad;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageQuality;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.Lib;

class PathNode {
	public var g : Int;
	public var h : Int;
	public var f : Int;
	public var x : Int;
	public var y : Int;
	public var flags : Int;
	public var parent : PathNode;

	public var scanFlags : Int;

	public static var SCAN_OPEN = 0x1;
	public static var SCAN_CLOSED = 0x2;
	public static var BLOCK = 0x1;

	public function new() {
		g = 0;
		h = 0;
		x = 0;
		y = 0;
		f = 0;
		scanFlags = 0;

		parent = null;

		flags = 0;
	}
}
