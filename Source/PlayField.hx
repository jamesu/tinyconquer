package;


import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.easing.Quad;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageQuality;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.Lib;


class PlayField extends Sprite {
	
	public static var instance : PlayField;

	public var units: Array<Unit>;

	public function new () {
		
		super ();

		units = new Array<Unit>();
	}

	public function createUnit() : Unit {
		var unit = new Unit();
		unit.addToScene(this);

		return unit;
	}
}