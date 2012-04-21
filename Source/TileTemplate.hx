package;


import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.easing.Quad;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageQuality;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.Lib;


class TileTemplate {
	
	public var width : Int;
	public var height : Int;
	public var tiles: Array<Int>;

	public function new (?tiles : Array<Int>, ?width : Int, ?height : Int) {
		this.tiles = tiles;
		this.width = width;
		this.height = height;
	}
}