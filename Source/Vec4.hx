package;

class Vec4
{
	public var x : Int;
	public var y : Int;
	public var z : Int;
	public var w : Int;

	public static function new(?inX : Int, ?inY : Int, ?inZ : Int, ?inW : Int) {
		this.x = (inX == null) ? 0 : inX;
		this.y = (inY == null) ? 0 : inY;
		this.z = (inZ == null) ? 0 : inZ;
		this.w = (inW == null) ? 0 : inW;
	}

	public function toInt() : Int
	{
		return ((this.x) | (this.y << 8) | (this.z << 16) | (this.w << 24)) & 0xFFFFFFFF;
	}
}
