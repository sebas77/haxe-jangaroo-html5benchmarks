package mylittleframework
{

//copied from somewhere and improved

public class Vector2D 
{
	public var x:Number;
	public var y:Number;

	public function Vector2D(_opt_px:Number, _opt_py:Number) 
	{
		var px:Number = _opt_px;
		var py:Number = _opt_py;
		x = px;
		y = py;
	}

	public function setTo(px:Number, py:Number):void 
	{
		x = px;
		y = py;
	}

	public function copy(v:Vector2D):void 
	{
		x = v.x;
		y = v.y;
	}


	public function dot(v:Vector2D):Number 
	{
		return x * v.x + y * v.y;
	}


	public function cross(v:Vector2D):Number 
	{
		return x * v.y - y * v.x;
	}


	public function plus(v:Vector2D):Vector2D 
	{
		return new Vector2D(x + v.x, y + v.y);
	}


	public function plusEquals(v:Vector2D):Vector2D 
	{
		x += v.x;
		y += v.y;
		return this;
	}


	public function minus(v:Vector2D):Vector2D 
	{
		return new Vector2D(x - v.x, y - v.y);
	}


	public function minusEquals(v:Vector2D):Vector2D 
	{
		x -= v.x;
		y -= v.y;
		return this;
	}


	public function mult(s:Number):Vector2D 
	{
		return new Vector2D(x * s, y * s);
	}


	public function multEquals(s:Number):Vector2D 
	{
		x *= s;
		y *= s;
		return this;
	}


	public function times(v:Vector2D):Vector2D 
	{
		return new Vector2D(x * v.x, y * v.y);
	}


	public function divEquals(s:Number):Vector2D 
	{
		if (s == 0) s = 0.0001;
		x /= s;
		y /= s;
		return this;
	}


	public function magnitude():Number 
	{
		return Math.sqrt(x * x + y * y);
	}


	public function distance(v:Vector2D):Number 
	{
		var delta:Vector2D = this.minus(v);
		return delta.magnitude();
	}
	
	public function zero():void 
	{
		x = 0;
		y = 0;
	}

	public function normalize():Vector2D 
	{
		 var m:Number = magnitude();
		 if (m == 0) m = 0.0001;
		 return mult(1 / m);
	}
	
	public function normalizeEquals():Vector2D 
	{
		 var m:Number = magnitude();
		 if (m == 0) m = 0.0001;
		 return multEquals(1 / m);
	}


	public function rotate(r:Vector2D):Vector2D 
	{
		return new Vector2D(x*r.x - y*r.y, x*r.y + y*r.x);
	}
	
	public function perpendicular():Vector2D
	{
		return new Vector2D( -y , x);
	}
	
	public function toAngle():Number 
	{
		return (Math.atan2(y, x) * 180.0) / (Math.PI);	
	}
	
	public function toString():String 
	{
		return (x + " : " + y);
	}
}

}