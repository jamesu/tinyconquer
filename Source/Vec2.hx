package;

class Vec2
{
	public var x : Int;
	public var y : Int;

	public static function new(?inX : Int, ?inY : Int) {
		this.x = (inX == null) ? 0 : inX;
		this.y = (inY == null) ? 0 : inY;
	}
}
