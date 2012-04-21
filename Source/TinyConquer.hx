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

	public var playField: PlayField;
	
	
	public function new() {
		super();
		
		Lib.current.stage.align = StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		Lib.current.stage.addEventListener (Event.ACTIVATE, stage_onActivate);
		Lib.current.stage.addEventListener (Event.DEACTIVATE, stage_onDeactivate);

		trace("TinyConquer init");
		//instance = this;
		playField = new PlayField();

		addChild(playField);

		playField.createUnit();

		Lib.current.stage.addEventListener(MouseEvent.CLICK, onClick);
				
	}
	
	private function onClick(e:MouseEvent):Void{
		trace("Please try other APIs by yourself!");
	}
	
	// Events
	
	private function stage_onActivate(event:Event):Void {
		Actuate.resumeAll ();
	}
	
	
	private function stage_onDeactivate(event:Event):Void {
		Actuate.pauseAll ();
	}
	
	public static function main () {
		JSTrace.setRedirection();
		Lib.current.addChild (new TinyConquer());
	}
}
