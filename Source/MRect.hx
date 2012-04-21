package;

class MRect
{
	public var x : Int;
	public var y : Int;
	public var width : Int;
	public var height : Int;

	public static function new(?inX : Int, ?inY : Int, ?inW : Int, ?inH : Int) {
		this.x = (inX == null) ? 0 : inX;
		this.y = (inY == null) ? 0 : inY;
		this.width = (inW == null) ? 0 : inW;
		this.height = (inH == null) ? 0 : inH;
	}
}
