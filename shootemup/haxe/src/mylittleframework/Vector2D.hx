package mylittleframework;

//copied from somewhere and improved

class Vector2D 
{
	public var x:Float;
	public var y:Float;

	public function new(?_opt_px:Null<Float>, ?_opt_py:Null<Float>) 
	{
		var px:Float = _opt_px==null ? 0 : _opt_px;
		var py:Float = _opt_py==null ? 0 : _opt_py;
		x = px;
		y = py;
	}

	public function setTo(px:Float, py:Float):Void 
	{
		x = px;
		y = py;
	}

	public function copy(v:Vector2D):Vector2D 
	{
		x = v.x;
		y = v.y;
		
		return this;
	}

	public function dot(v:Vector2D):Float 
	{
		return x * v.x + y * v.y;
	}

	public function cross(v:Vector2D):Float 
	{
		return x * v.y - y * v.x;
	}


	public function plusEquals(v:Vector2D):Vector2D 
	{
		x += v.x;
		y += v.y;
		
		return this;
	}

	public function minusEquals(v:Vector2D):Vector2D 
	{
		x -= v.x;
		y -= v.y;
		
		return this;
	}

	public function multEquals(s:Float):Vector2D 
	{
		x *= s;
		y *= s;
		
		return this;
	}

	public function divEquals(s:Float):Vector2D 
	{
		if (s == 0) s = 0.0001;
		x /= s;
		y /= s;
		return this;
	}

	public function magnitude():Float 
	{
		return Math.sqrt(x * x + y * y);
	}

	public function distance(v:Vector2D):Float 
	{
		var delta:Vector2D = new Vector2D(this.x - v.x, this.y - v.y);
		
		return delta.magnitude();
	}
	
	public function zero():Void 
	{
		x = 0;
		y = 0;
	}

	public function normalizeEquals():Vector2D 
	{
		 var m:Float = magnitude();
		 if (m == 0) m = 0.0001;
		 
		 return multEquals(1 / m);
	}

	public function perpendicular():Vector2D
	{
		setTo( -y , x);
		
		return this;
	}
	
	public function toAngle():Float 
	{
		return (Math.atan2(y, x) * 180.0) / (Math.PI);	
	}
	
	public function toString():String 
	{
		return (x + " : " + y);
	}
}

