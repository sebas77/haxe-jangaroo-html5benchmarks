package ;
import flash.display.Bitmap;

class Background extends Bitmap
{
	public function new() 
	{
		super ();
		
		bitmapData = nme.Assets.getBitmapData ("assets/images/space.jpg");
	}
}