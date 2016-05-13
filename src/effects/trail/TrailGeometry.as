package effects.trail
{
	import away3d.arcane;
	import away3d.core.base.CompactSubGeometry;
	import away3d.core.math.Vector3DUtils;
	import away3d.primitives.PrimitiveBase;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	use namespace arcane;
	
	/**
	 * A Plane primitive mesh.
	 */
	public class TrailGeometry extends PrimitiveBase
	{
		private var _segmentsW:uint;
		private var _segmentsH:uint;
		private var _yUp:Boolean;
		private var _width:Number;
		private var _height:Number;
		private var _doubleSided:Boolean;
		
		private var lastIndex:int = 0;
		private var lastPosition:Vector3D;
		private var lastRotation:Vector3D;
		private var target:CompactSubGeometry;
	
		private static const VEC:Vector3D = new Vector3D();
		private var data:Vector.<Number>;
		private var indices:Vector.<uint>;
		private var segmentsCount:int;
		private var trailWidth:Number;
		
		/**
		 * Creates a new Plane object.
		 * @param width The width of the plane.
		 * @param height The height of the plane.
		 * @param segmentsW The number of segments that make up the plane along the X-axis.
		 * @param segmentsH The number of segments that make up the plane along the Y or Z-axis.
		 * @param yUp Defines whether the normal vector of the plane should point along the Y-axis (true) or Z-axis (false).
		 * @param doubleSided Defines whether the plane will be visible from both sides, with correct vertex normals.
		 */
		public function TrailGeometry(trailWidth:Number = 15, segmentsCount:int = 15)
		{
			super();
			
			this.trailWidth = trailWidth;
			this.segmentsCount = segmentsCount;
			
			_segmentsW = segmentsW;
			_segmentsH = segmentsH;
			_yUp = yUp;
			_width = width;
			_height = height;
			_doubleSided = doubleSided;
		}
		
		/**
		 * The number of segments that make up the plane along the X-axis. Defaults to 1.
		 */
		public function get segmentsW():uint
		{
			return _segmentsW;
		}
		
		public function set segmentsW(value:uint):void
		{
			_segmentsW = value;
			invalidateGeometry();
			invalidateUVs();
		}
		
		/**
		 * The number of segments that make up the plane along the Y or Z-axis, depending on whether yUp is true or
		 * false, respectively. Defaults to 1.
		 */
		public function get segmentsH():uint
		{
			return _segmentsH;
		}
		
		public function set segmentsH(value:uint):void
		{
			_segmentsH = value;
			invalidateGeometry();
			invalidateUVs();
		}
		
		/**
		 *  Defines whether the normal vector of the plane should point along the Y-axis (true) or Z-axis (false). Defaults to true.
		 */
		public function get yUp():Boolean
		{
			return _yUp;
		}
		
		public function set yUp(value:Boolean):void
		{
			_yUp = value;
			invalidateGeometry();
		}
		
		/**
		 * Defines whether the plane will be visible from both sides, with correct vertex normals (as opposed to bothSides on Material). Defaults to false.
		 */
		public function get doubleSided():Boolean
		{
			return _doubleSided;
		}
		
		public function set doubleSided(value:Boolean):void
		{
			_doubleSided = value;
			invalidateGeometry();
		}
		
		/**
		 * The width of the plane.
		 */
		public function get width():Number
		{
			return _width;
		}
		
		public function set width(value:Number):void
		{
			_width = value;
			invalidateGeometry();
		}
		
		/**
		 * The height of the plane.
		 */
		public function get height():Number
		{
			return _height;
		}
		
		public function set height(value:Number):void
		{
			_height = value;
			invalidateGeometry();
		}
		
		private function setVertexXYZ(vertexIndex:int, x:Number, y:Number, z:Number):void
		{
			target.vertexData[vertexIndex] = x;
			target.vertexData[vertexIndex + 1] = y;
			target.vertexData[vertexIndex + 2] = z;
		}
		
		private function setVertexUV(vertexIndex:int, u:Number, v:Number):void
		{
			target.vertexData[vertexIndex + 9] = u;
			target.vertexData[vertexIndex + 10] = v;
		}
		
		public function updateTrail(pos:Vector3D, r:Vector3D = null):void
		{
			var vertexStride:int = target.vertexStride;

			if (lastPosition == null) 
				lastPosition = new Vector3D(pos.x, pos.y, pos.z);
				
			if (lastRotation == null)
				lastRotation = new Vector3D(r.x, r.y, r.z);
			
			
			var uvSegment:Number = 1 / segmentsCount;
			var uvPart:Number = 1 / segmentsCount * (segmentsCount - lastIndex);
			
			/**
			 * A-------B
			 * |       |
			 * |       |
			 * C-------D
			 */
			var indexA:int = lastIndex * 4 * vertexStride;
			var indexB:int = indexA + vertexStride * 2;
			var indexC:int = indexA + vertexStride
			var indexD:int = indexB + vertexStride
			
			
			VEC.setTo(-trailWidth, 0, 0);
			Vector3DUtils.rotatePoint(VEC, lastRotation);
			setVertexXYZ(indexA, lastPosition.x + VEC.x, lastPosition.y + VEC.y, lastPosition.z + VEC.z); //A
			
			VEC.setTo(-trailWidth, 0, 0);
			Vector3DUtils.rotatePoint(VEC, r);
			setVertexXYZ(indexC, pos.x + VEC.x, pos.y + VEC.y, pos.z + VEC.z); //C
			
			
			VEC.setTo(trailWidth, 0, 0);
			Vector3DUtils.rotatePoint(VEC, lastRotation);	
			setVertexXYZ(indexB, lastPosition.x + VEC.x, lastPosition.y + VEC.y, lastPosition.z + VEC.z); //B
			
			
			
			VEC.setTo(trailWidth, 0, 0);
			Vector3DUtils.rotatePoint(VEC, r);
			setVertexXYZ(indexD, pos.x + VEC.x, pos.y + VEC.y, pos.z + VEC.z); //D
			
			if ( ++lastIndex == segmentsCount ) 
			{
				lastIndex = 0;
			}
			
			lastPosition.setTo(pos.x, pos.y, pos.z);
			lastRotation.setTo(r.x, r.y, r.z);
			
			target.invalidateVertexData(0);
		}
		
		private function addSegment(segmentId:int):void
		{
			var segmentPos:Number = segmentId * 10 - (10 * 10 / 2);
			
			var uvSegment:Number = 1 / segmentsCount;
			var uvPart:Number = 1 / segmentsCount * (segmentsCount - segmentId);
			
			var vertexIndexBySegment:int = segmentId * 52;
			addVertex(vertexIndexBySegment, segmentPos + -trailWidth, -trailWidth, uvPart, 0);
			addVertex(vertexIndexBySegment+13, segmentPos + trailWidth, -trailWidth, uvPart - uvSegment, 0);
			addVertex(vertexIndexBySegment+26, segmentPos + -trailWidth, trailWidth, uvPart, 1);
			addVertex(vertexIndexBySegment + 39, segmentPos + trailWidth, trailWidth, uvPart - uvSegment, 1);
			
			var indicesIndex:int = segmentId * 6;
			//indices[indicesIndex + 0] = segmentId;
			//indices[indicesIndex + 1] = segmentId + 2
			//indices[indicesIndex + 2] = segmentId + 1
			//indices[indicesIndex + 3] = segmentId + 2
			//indices[indicesIndex + 4] = segmentId + 3
			//indices[indicesIndex + 5] = segmentId + 1;
			
			var tw:Number = 2;
			var base:int = segmentId * 4;
			indices[indicesIndex++] = base;
			indices[indicesIndex++] = (base + tw);
			indices[indicesIndex++] = (base + tw + 1);
			indices[indicesIndex++] = base;
			indices[indicesIndex++] = (base + tw + 1);
			indices[indicesIndex++] = (base + 1);
		}
		
		private function addVertex(index:int, x:Number, y:Number, u:Number, v:Number):void
		{
			data[index + 0] = x;//x
			data[index + 1] = 0;//z
			data[index + 2] = y;//y
			
			data[index + 3] = 0;
			data[index + 4] = 1;
			data[index + 5] = 0;
			
			data[index + 6] = 0;
			data[index + 7] = 0;
			data[index + 8] = 1;
			
			data[index + 9] = u;
			data[index +10] = v;
		}
		
		/**
		 * @inheritDoc
		 */
		protected override function buildGeometry(target:CompactSubGeometry):void
		{
			this.target = target;
			
			var numVertices:Number = segmentsCount * 4;
			var numIndices:int = segmentsCount * 6;
			
			if (numVertices == target.numVertices) 
			{
				data = target.vertexData;
				indices = target.indexData || new Vector.<uint>(numIndices, true);
			}
			else 
			{
				data = new Vector.<Number>(numVertices * target.vertexStride, true);
				indices = new Vector.<uint>(numIndices, true);
				invalidateUVs();
			}
			
			for (var i:int = 0; i < segmentsCount; i++)
				addSegment(i);
			
			target.updateData(data);
			target.updateIndexData(indices);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function buildUVs(target:CompactSubGeometry):void
		{
			return;
			var data:Vector.<Number>;
			var stride:uint = target.UVStride;
			var numUvs:uint = (_segmentsH + 1)*(_segmentsW + 1)*stride;
			var skip:uint = stride - 2;
			
			if (_doubleSided)
				numUvs *= 2;
			
			if (target.UVData && numUvs == target.UVData.length)
				data = target.UVData;
			else {
				data = new Vector.<Number>(numUvs, true);
				invalidateGeometry();
			}
			
			var index:uint = target.UVOffset;
			
			for (var yi:uint = 0; yi <= _segmentsH; ++yi) {
				for (var xi:uint = 0; xi <= _segmentsW; ++xi) {
					data[index++] = (xi/_segmentsW)*target.scaleU;
					data[index++] = (1 - yi/_segmentsH)*target.scaleV;
					index += skip;
					
					if (_doubleSided) {
						data[index++] = (xi/_segmentsW)*target.scaleU;
						data[index++] = (1 - yi/_segmentsH)*target.scaleV;
						index += skip;
					}
				}
			}
			
			target.updateData(data);
		}
	}
}
