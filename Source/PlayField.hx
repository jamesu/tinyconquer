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

class PlayField extends Sprite {

	public var tiles: Array<Int>;
	public var tileData : Array<TileData>;
	public var units: Array<Unit>;

	public var tileWidth : Int;
	public var tileHeight : Int;

	public static var markTileX : Int;
	public static var markTileY : Int;

	public function new () {
		
		super ();

		units = new Array<Unit>();

		tileWidth = 20;
		tileHeight = 20;

		markTileX = -1;
		markTileY = -1;

		var i;
		tiles = new Array<Int>();
		for (i in 0...tileWidth*tileHeight) {
			tiles.push(0);
		}

		tiles[10] = 1;

		tileData = new Array<TileData>();
		tileData.push(new TileData(0));
		tileData.push(new TileData(TileData.COLLISION_BLOCK, 0, 0, 32, 32, new Vec4(0, 255, 0, 255)));

		var template = new TileTemplate([0,1,1,0,1,1,1,1,0,1,1,
			                             0,1,0,0,0,0,0,0,0,0,1,
			                             0,1,0,0,0,0,0,0,0,0,1,
			                             0,1,0,0,0,0,0,0,0,0,1,
			                             0,1,1,1,1,1,1,1,1,1,1], 11, 5);
		paintTemplate(template, 8, 10);
	}

	public function paintTemplate(template : TileTemplate, x : Int, y : Int)
	{
		var destX = x;
		var destY = y;
		var destX2 = 0;
		var destY2 = 0;

		// Clip dest
		if (destX < 0)
			destX = 0;
		else if (destX >= tileWidth)
			destX = tileWidth;
		if (destY < 0)
			destY = 0;
		else if (destY >= tileHeight)
			destY = tileHeight;
		destX2 = destX + template.width - (destX-x);
		destY2 = destY + template.height - (destY-y);
		if (destX2 > tileWidth) {
			destX2 = tileWidth;
		} else if (destX2 < 0) {
			destX2 = 0;
		}
		if (destY2 > tileHeight) {
			destY2 = tileHeight;
		} else if (destY2 < 0) {
			destY2 = 0;
		}

		if (destY == destY2 && destX == destX2)
			return;

		var clipStartX = destX - x;
		var clipStartY = destY - y;

		// Clip src
		var xC = 0;
		var yC = 0;
		var ptr = (destY*tileWidth) + destX;
		var stride = tileWidth-(destX2-destX);
		for (yC in clipStartY...(clipStartY+(destY2-destY))) {
			for (xC in clipStartX...(clipStartX+(destX2-destX))) {
				tiles[ptr] = template.tiles[(template.width*yC) + xC];
				ptr += 1;
			}
			ptr += stride;
		}

	}

	public function draw()
	{
		graphics.clear();
		debugDraw();

		var x, y;
		for (y in 0...tileHeight) {
			for (x in 0...tileWidth) {
				var xPos = x*32;
				var yPos = y*32;

				//trace(markTileX + ',' + markTileY);

				var idx = (y*tileWidth) + x;
				var tile = tiles[idx];
				var tileData = tileData[tile];
				if (idx == markTileX) {
					graphics.beginFill(Std.int(0x0000FFFF));
					graphics.drawRect(xPos, yPos, 32, 32);
					graphics.endFill();
				} else if (idx == markTileY) {
					graphics.beginFill(Std.int(0xFF00FFFF));
					graphics.drawRect(xPos, yPos, 32, 32);
					graphics.endFill();
				} else if (tileData.color != null) {
					graphics.beginFill(Std.int(tileData.color.toInt()));
					graphics.drawRect(xPos, yPos, 32, 32);
					graphics.endFill();
				}
			}
		}
	}

	public function debugDraw()
	{
		//trace("DRAW");
		var i;
		graphics.lineStyle(1, 0x000000, 1.0);
		for (i in 0...tileWidth+1) {
			graphics.moveTo(i*32, 0);
			graphics.lineTo(i*32, tileHeight*32);
		}
		for (i in 0...tileHeight+1) {
			graphics.moveTo(0, i*32);
			graphics.lineTo(tileWidth*32, i*32);
		}
	}

	public function testObjectCollision()
	{
		var unit;
		for (unit in units) {
		}
	}

	public function testTileCollision()
	{
	    var tilew = 32;
	    var tileh = 32;

		markTileX = -1;
		markTileY = -1;
	    
		var unit;
		for (unit in units) {
		    // Skip non-colliding objects
	        if ((unit.flags & Unit.GAMEOBJECT_CHECKTILE) == 0)
	            continue;
	        //return;
	        var final_x = unit.vel.x;
	        var final_y = unit.vel.y;
	        
	        var tile = new Vec2();
	        tile.x = Math.floor(unit.pos.x / tilew);
	        tile.y = Math.floor((unit.pos.y+tileh) / tileh);
	        
	        //trace("Object collided with tile", unit, tileAtPosition(unit.pos.x, unit.pos.y, tile));
	        
	        // Check x 
	        if (final_x != 0) {
	        	trace("FINAL_x != 0 ==" + final_x);
	            var tile_at_x = -1;
	            var tile_at = new Vec2();
	            
	            if (final_x > 0) // right
	                tile_at_x = tileAtPosition(Math.floor(unit.pos.x + (unit.bounds.x+unit.bounds.width) + final_x), unit.pos.y, tile_at);
	            else // left
	                tile_at_x = tileAtPosition(Math.floor(unit.pos.x + (unit.bounds.x) + final_x), unit.pos.y, tile_at);
	            
	            markTileX = Math.floor(tile_at.x) + Math.floor(tile_at.y * tileWidth);
	            trace(unit.pos.y + "|" + markTileX + ',' + tile_at.x + ',' + tile_at.y);

	            var txdat = tile_at_x < 0 ? tileData[1] : tileData[tile_at_x];
	            switch (txdat.flags) {
	                case TileData.COLLISION_BLOCK:
	                    // Solid, so stop collisions at point incorporating width
	                    if (final_x > 0) { // right
	                        final_x = (tile_at.x*tilew) - (unit.pos.x + unit.bounds.x + unit.bounds.width);
	                    } else { // left
	                        final_x = ((tile_at.x+1)*tilew) - (unit.pos.x + unit.bounds.x);
	                    }
	                    
	                    //unit.collided_object = 10;
	                    //break;
	                    /*
	                case COLLISION_RAMP:
	                    // err
	                    final_y = 1;
	                    break; 
	                    */
	            }
	        }
	        
	        
	        unit.pos.x += final_x;
	        
	        // Check y (note: to fix the "cant move down" bug we need to test against left AND right
	        if (final_y != 0) {
	        	trace("FINAL_y != 0" + '=' + final_y);
	            var tile_at_y = -1;
	            var tile_at = new Vec2();
	            
	            if (final_y > 0) // bottom of object
	                tile_at_y = tileAtPosition(unit.pos.x, unit.pos.y + (unit.bounds.y + unit.bounds.height) + final_y, tile_at);
	            else // top of object
	                tile_at_y = tileAtPosition(unit.pos.x, unit.pos.y + (unit.bounds.y) + final_y, tile_at);
	            
	            markTileY = Math.floor(tile_at.x) + Math.floor(tile_at.y * tileWidth);

	            //printf("TILE AT Y: %i\n", tile_at_y);
	            var tydat = tile_at_y < 0 ? tileData[1] : tileData[tile_at_y];
	            var txpd = 0;
	            switch (tydat.flags) {
	                case TileData.COLLISION_BLOCK:
	                    // Solid, so stop collisions at point incorporating height
	                    if (final_y > 0) { // top of tile

	                    	// 2-1 == 1, 32
	                    	// 
	                        final_y = ((tile_at.y)*tileh) - (unit.pos.y + unit.bounds.y + unit.bounds.height) - 1;
	                    } else { // bottom of tile

	                    	// 2 == 2, 64,   64 - 48 == 16, 
	                    	//
	                        final_y = ((tile_at.y+1)*tileh) - (unit.pos.y + unit.bounds.y) + 0;
	                    }
	                    
	                    //unit.collided_object = 20;
	                    //break;
	                    /*
	                case TileData.COLLISION_RAMP:
	                    // Ramp, we need to set the Y position to the current ramp position
	                    if (final_y > 0) { // top of tile
	                        txpd = tydat.ramp[unit.pos.x % tilew];
	                        if (txpd != -1)
	                            final_y = ((tile_at_ypos-1)*tileh) - unit.pos.y + txpd - 1;
	                    } else { // bottom of tile
	                        final_y = ((tile_at_ypos)*tileh) - (unit.pos.y - (unit.height)) + 0;
	                    }
	                    //final_y = ((tile_x * tilew) + tydat.ramp[(unit.pos.x % tilew)]) - unit.pos.y;
	                    break;
	                    */
	            }
	        }
	        
	        unit.collided_tile.x = tile.x;
	        unit.collided_tile.y = tile.y;
	        
	        
	        // Update position based on final velocity
	        //unit.pos.x += final_x;
	        unit.pos.y += final_y;
	    }
	}

	public function updateObjects()
	{
		var unit;
		for (unit in units) {
			unit.vel.x = Math.floor(unit.vel.x * 0.9);
			unit.vel.y = Math.floor(unit.vel.y * 0.9);

			// Move to target
			var deltaTargetX = unit.target_pos.x - unit.pos.x;
			var deltaTargetY = unit.target_pos.y - unit.pos.y;
			var deltaLen = Math.sqrt((deltaTargetX*deltaTargetX) + (deltaTargetY*deltaTargetY));

			if (deltaLen > 1) {
				var speed = deltaLen > 2 ? 2 : deltaLen;
				unit.vel.x = Math.floor((deltaTargetX / deltaLen) * speed);
				unit.vel.y = Math.floor((deltaTargetY / deltaLen) * speed);

				//trace('ln'+deltaLen+','+deltaTargetX+','+unit.vel.x+','+unit.vel.y);
			} else {
				unit.vel.x = 0;
				unit.vel.y = 0;
			}

			// Cap velocity
			if (unit.vel.x > unit.max_vel)
				unit.vel.x = unit.max_vel;
			if (unit.vel.x < -unit.max_vel)
				unit.vel.x = -unit.max_vel;
			if (unit.vel.y > unit.max_vel)
				unit.vel.y = unit.max_vel;
			if (unit.vel.y < -unit.max_vel)
				unit.vel.y = -unit.max_vel;

			unit.mainSprite.x = unit.pos.x;
			unit.mainSprite.y = unit.pos.y;
		}
	}

	public function tileAtPosition(x : Int, y : Int, ?outPos : Vec2) : Int
	{
	    var tilew = 32;
	    var tileh = 32;
	    
	    var tile_x = Math.floor(x / tilew);
	    var tile_y = Math.floor(y/ tileh);
	    
	    if (outPos != null) {
	    	outPos.x = tile_x;
	    	outPos.y = tile_y;
	    }

	    if (x < 0 || y < 0)
	        return -1;

	    if (tile_x >= tileWidth || tile_y >= tileHeight)
	        return -1;
	    
	    return tiles[(tile_y * tileWidth) + tile_x];
	}

	public function testRectIntersects(rect1 : MRect, rect2 : MRect) : Bool
	{
	    var bl_x = Math.min(rect1.x + rect1.width - 1, rect2.x + rect2.width - 1);
	    var bl_y = Math.min(rect1.y + rect1.height - 1, rect2.y + rect2.height - 1);
	    
	    var newPos_x = Math.max(rect1.x, rect2.x);
	    var newPos_y = Math.max(rect1.y, rect2.y);
	    
	    var newExtent_x = bl_x - newPos_x + 1;
	    var newExtent_y = bl_y - newPos_y + 1;
	    
	    return (newExtent_x > 0 && newExtent_y > 0);
	}

	public function tick()
	{
		//trace("tick");
		updateObjects();
		testObjectCollision();
		testTileCollision();

		draw();
	}

	public function createUnit() : Unit {
		var unit = new Unit();
		unit.addToScene(this);
		units.push(unit);

		return unit;
	}
}