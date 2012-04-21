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
	public var g;
	public var h;
	public var x : Int;
	public var y : Int;

	public function new() {
		g = 0;
		h = 0;
		x = 0;
		y = 0;
	}
}

class PathFinder {
	
	public var field : PlayField;

	public var grid: Array<PathNode>;

	public function new (playField : PlayField) {
		field = playField;
	}

	public function generateGrid() {
		// Generate a walkable-nonwalkable from the playfield
		grid = new Array<PathNode>();

		var i;
		for (i in 0...field.tiles.length) {
			var node = new PathNode();
			node.x = i % field.tileWidth;
			node.y = i / field.tileWidth;
			grid.push(node);
		}
	}
}