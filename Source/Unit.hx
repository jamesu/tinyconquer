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
	public var mainSprite: Sprite;

	public var pos : Vec2;
	public var vel : Vec2;
	public var bounds : MRect;
	public var max_vel : Int;

	public var target_pos : Vec2;

	public var flags : Int;
	public var collided_tile : Vec2;

	public static var GAMEOBJECT_CHECKTILE = 0x1;

	public function new()
	{
		max_vel = 8;

		pos = new Vec2(100, 100);
		vel = new Vec2();
		bounds = new MRect();
		collided_tile = new Vec2();
		target_pos = new Vec2();
		flags = Unit.GAMEOBJECT_CHECKTILE;

		bounds.x = -5;
		bounds.y = -5;
		bounds.width = 10;
		bounds.height = 10;

		mainSprite = new Sprite();

		mainSprite.graphics.beginFill(Std.int (0xFF0000));
		mainSprite.graphics.drawRect(bounds.x, bounds.y, bounds.width, bounds.height);

		setPosition(100,100);
	}

	public function setPosition(x : Int, y : Int)
	{
		pos.x = x;
		pos.y = y;
		target_pos.x = x;
		target_pos.y = y;
	}

	public function onClick(e : MouseEvent)
	{
		trace("Clicked on unit");
		//mainSprite.graphics.beginFill(Std.int (0x00FF00));
		//mainSprite.graphics.drawRect(-10, -10, 10, 10);
	}

	public function addToScene(field : PlayField)
	{
		trace("Added unit");
		field.addChildAt(mainSprite, 0);

		mainSprite.addEventListener(MouseEvent.CLICK, onClick);
	}
}