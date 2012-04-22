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
	public var turret: Sprite;

	public var pos : Vec2;
	public var vel : Vec2;
	public var bounds : MRect;
	public var max_vel : Int;

	// Rotation
	public var rotationSpeed : Int;
	public var turretRotationSpeed : Int;
	public var rotation : Int;
	public var turretRotation : Int;

	public var target_pos : Vec2;

	public var type : Int;
	public var flags : Int;
	public var collided_tile : Vec2;
	public var collided_object : Unit;

	public static var GAMEOBJECT_CHECKTILE = 0x1;
	public static var GAMEOBJECT_CHECKOBJECTS = 0x2;
	public static var GAMEOBJECT_AUTOPUSH = 0x4;     // automatically push out objects

	public var current_tile : Int;
	public var start_tile : Int;
	public var target_tile : Int;
	public var next_tile : Int;

	public var field : PlayField;


	public static var TYPE_TANK = 1;
	public static var TYPE_SHELL = 2;

	public function new(aType : Int)
	{
		max_vel = 8;

		pos = new Vec2(100, 100);
		vel = new Vec2();
		bounds = new MRect();
		collided_tile = new Vec2();
		target_pos = new Vec2();
		flags = Unit.GAMEOBJECT_CHECKTILE | Unit.GAMEOBJECT_CHECKOBJECTS | Unit.GAMEOBJECT_AUTOPUSH;
		collided_object = null;
		turret = null;
		mainSprite = null;

		rotation = 0;
		turretRotation = 0;
		rotationSpeed = 1;
		turretRotationSpeed = 1;

		type = aType;

		switch (type) {
			case TYPE_TANK:
				bounds.x = -12;
				bounds.y = -12;
				bounds.width = 24;
				bounds.height = 24;

				mainSprite = new Sprite();
				turret = new Sprite();

				mainSprite.addChild(turret);

			case TYPE_SHELL:
				bounds.x = -8;
				bounds.y = -8;
				bounds.width = 8;
				bounds.height = 8;

				mainSprite = new Sprite();

		}

		current_tile = -1;
		next_tile = -1;
		target_tile = -1;
		start_tile = -1;

		draw();

		setPosition(100,100);
	}

	public function draw()
	{
		switch (type) {
			case TYPE_TANK:
				mainSprite.graphics.clear();
				mainSprite.graphics.beginFill(Std.int (0xFF0000));
				mainSprite.graphics.drawRect(bounds.x, bounds.y, bounds.width, bounds.height);

				turret.graphics.clear();
				turret.graphics.beginFill(Std.int (0x000000));
				turret.graphics.drawRect(-2, 6, 2, 10);

				turret.rotation = turretRotation;
				mainSprite.rotation = rotation;

			case TYPE_SHELL:	
				mainSprite.graphics.clear();
				mainSprite.graphics.beginFill(Std.int (0x0000FF));
				mainSprite.graphics.drawRect(bounds.x, bounds.y, bounds.width, bounds.height);
		}
	}

	public function moveToPosition(x : Int, y : Int)
	{
		var out_pos = new Vec2();
		field.tileAtPosition(x, y, out_pos);

		trace("tile at " + x + ',' + y + '=' + out_pos.x + ',' + out_pos.y);

		target_tile = field.tilePositionToIndex(out_pos.x, out_pos.y);
		next_tile = current_tile;
		start_tile = current_tile;
		current_tile = next_tile;

		trace("Moving to " + target_tile + ':current=' + current_tile);
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

	public function addToScene(aField : PlayField)
	{
		trace("Added unit");
		field = aField;
		field.addChildAt(mainSprite, 0);

		mainSprite.addEventListener(MouseEvent.CLICK, onClick);
	}
}