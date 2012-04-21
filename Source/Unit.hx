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


class Unit
{
	private var mainSprite: Sprite;

	public function new()
	{
		mainSprite = new Sprite();

		mainSprite.graphics.beginFill(Std.int (0xFF0000));
		mainSprite.graphics.drawRect(-10, -10, 10, 10);

		mainSprite.x = 100;
		mainSprite.y = 100;
	}

	public function onClick(e : MouseEvent)
	{
		trace("Clicked on unit");
		mainSprite.graphics.beginFill(Std.int (0x00FF00));
		mainSprite.graphics.drawRect(-10, -10, 10, 10);
	}

	public function addToScene(field : PlayField)
	{
		trace("Added unit");
		field.addChildAt(mainSprite, 0);

		mainSprite.addEventListener(MouseEvent.CLICK, onClick);
	}
}