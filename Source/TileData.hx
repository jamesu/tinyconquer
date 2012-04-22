package;


import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.easing.Quad;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageQuality;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.Lib;


class TileData
{
	public var flags : Int;
	public var draw_x : Int;
	public var draw_y : Int;
	public var draw_width : Int;
	public var draw_height : Int;

	public var color : Vec4;

	public static var COLLISION_BLOCK = 0x1;

	public function new(inFlags : Int, ?dx : Int, ?dy : Int, ?dw : Int, ?dh : Int, ?inColor : Vec4) {
		flags = inFlags;
		draw_x = dx;
		draw_y = dy;
		draw_width = dw;
		draw_height = dh;
		color = inColor;
	}
}