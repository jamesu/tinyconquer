package;


import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.easing.Quad;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageQuality;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.Lib;

class TinyConquer extends Sprite {
	public static var instance : TinyConquer;
	public var playField: PlayField;

	public var mouseDown : Bool;
	
	
	public function new() {
		super();
		
		Lib.current.stage.align = StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		Lib.current.stage.addEventListener(Event.ACTIVATE, stage_onActivate);
		Lib.current.stage.addEventListener(Event.DEACTIVATE, stage_onDeactivate);

		Lib.current.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);

		trace("TinyConquer init");
		//instance = this;
		playField = new PlayField();
		addChild(playField);

		mouseDown = false;
		playField.createUnit();
		playField.createUnit();
		playField.createUnit();

		Lib.current.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);

		playField.draw();


        var format = new flash.text.TextFormat();
        format.font = "assets_orbitron_black_ttf";

        var textField = new flash.text.TextField();
        textField.text = "Hello jeash Haxe!";
        textField.setTextFormat(format);
        flash.Lib.current.addChild( textField );
	}

	private function moveUnitToPos(x : Int, y : Int) : Void {
		//trace("Please try other APIs by yourself!");
		var unit = playField.units[0];

		unit.moveToPosition(x, y);
	}

	private function onMouseMove(e:MouseEvent) : Void {
		//trace("Please try other APIs by yourself!");

		if (mouseDown) {
			moveUnitToPos(Math.floor(e.stageX), Math.floor(e.stageY));
		}
	}
	
	private function onMouseDown(e:MouseEvent) : Void {
		//trace("Please try other APIs by yourself!");

		mouseDown = true;
		moveUnitToPos(Math.floor(e.stageX), Math.floor(e.stageY));
	}

	public function onMouseUp(e:MouseEvent) : Void {
		mouseDown = false;
	}
	
	// Events
	
	private function stage_onActivate(event:Event):Void {
		Actuate.resumeAll ();
	}
	
	
	private function stage_onDeactivate(event:Event):Void {
		Actuate.pauseAll ();
	}

	public function onEnterFrame(event:Event) : Void {
		// Update units
		playField.tick();
	}
	
	public static function main () {
		JSTrace.setRedirection();
		instance = new TinyConquer();
		Lib.current.addChild (instance);
	}
}
