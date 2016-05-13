package effects.trail 
{
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.Geometry;
	import away3d.entities.Mesh;
	import away3d.materials.MaterialBase;
	import flash.geom.Vector3D;
	
	public class TrailMesh extends Mesh 
	{
		private var trailGeometry:TrailGeometry;
		private var target:ObjectContainer3D;
		
		private var rotationVecotr:Vector3D = new Vector3D();
		
		public function TrailMesh(material:MaterialBase=null, trailWidth:Number = 15, segmentsCount:int = 15) 
		{
			trailGeometry = new TrailGeometry(trailWidth, segmentsCount);
			super(trailGeometry, material);
			
			this.bounds.fromSphere(rotationVecotr, 100000);
		}
		
		public function attachTo(target:ObjectContainer3D):void
		{
			this.target = target;
		}
		
		public function update():void
		{
			if (target == null)
				return;
				
			rotationVecotr.setTo(target.rotationX, target.rotationY, target.rotationZ);
			trailGeometry.updateTrail(target.scenePosition, rotationVecotr)
		}
	}
}