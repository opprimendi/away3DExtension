package effects.trail 
{
	import away3d.materials.TextureMaterial;
	import away3d.textures.Anisotropy;
	import away3d.textures.BitmapTexture;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.geom.Point;

	public function createTrailMaterial():TextureMaterial
	{
		var bmp:BitmapData = new BitmapData(256, 256, true, 0x0);
		bmp.perlinNoise(256, 64, 4, 1, true, true, BitmapDataChannel.GREEN , false);
		bmp.copyChannel(bmp, bmp.rect, new Point(), BitmapDataChannel.GREEN, BitmapDataChannel.ALPHA);
		
		var bmp2:BitmapData = new BitmapData(256, 256, true, 0x0);
		bmp2.perlinNoise(256, 64, 4, 1, true, true, BitmapDataChannel.RED , false);
		bmp2.copyChannel(bmp2, bmp2.rect, new Point(), BitmapDataChannel.RED, BitmapDataChannel.ALPHA);
		
		bmp.merge(bmp2, bmp2.rect, new Point(), 256, -125, 0, 250);
		bmp.merge(bmp2, bmp2.rect, new Point(), 125, 200, 0, 250);
		bmp.copyChannel(bmp, bmp.rect, new Point(), BitmapDataChannel.RED, BitmapDataChannel.ALPHA);
		
		var material:TextureMaterial = new TextureMaterial(new BitmapTexture(bmp, true), true, false, true, Anisotropy.ANISOTROPIC16X);
		material.bothSides = true;
		material.alphaBlending = true;
		
		return material;
	}

}