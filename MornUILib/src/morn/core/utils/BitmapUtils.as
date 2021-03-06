/**
 * Morn UI Version 2.0.0526 http://code.google.com/p/morn https://github.com/yungzhu/morn
 * Feedback yungzhu@gmail.com http://weibo.com/newyung
 */
package morn.core.utils {
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**位图工具集*/
	public class BitmapUtils {
		private static var m:Matrix = new Matrix();
		private static var newRect:Rectangle = new Rectangle();
		private static var clipRect:Rectangle = new Rectangle();
		private static var grid:Rectangle = new Rectangle();
		
		/**获取9宫格拉伸位图数据*/
		public static function scale9Bmd(bmd:BitmapData, sizeGrid:Array, width:int, height:int):BitmapData {
			if (bmd.width == width && bmd.height == height) {
				return bmd;
			}
			
			width = width > 1 ? width : 1;
			height = height > 1 ? height : 1;
			
			var gw:int = int(sizeGrid[0]) + int(sizeGrid[2]);
			var gh:int = int(sizeGrid[1]) + int(sizeGrid[3]);
			var newBmd:BitmapData = new BitmapData(width, height, bmd.transparent, 0x00000000);
			//如果目标大于九宫格，则进行9宫格缩放，否则直接缩放
			if (width > gw && height > gh) {
				setRect(grid, sizeGrid[0], sizeGrid[1], bmd.width - sizeGrid[0] - sizeGrid[2], bmd.height - sizeGrid[1] - sizeGrid[3]);
				var rows:Array = [0, grid.top, grid.bottom, bmd.height];
				var cols:Array = [0, grid.left, grid.right, bmd.width];
				var newRows:Array = [0, grid.top, height - (bmd.height - grid.bottom), height];
				var newCols:Array = [0, grid.left, width - (bmd.width - grid.right), width];
				for (var i:int = 0; i < 3; i++) {
					for (var j:int = 0; j < 3; j++) {
						
						setRect(newRect, cols[i], rows[j], cols[i + 1] - cols[i], rows[j + 1] - rows[j]);
						setRect(clipRect, newCols[i], newRows[j], newCols[i + 1] - newCols[i], newRows[j + 1] - newRows[j]);
						m.identity();
						m.a = clipRect.width / newRect.width;
						m.d = clipRect.height / newRect.height;
						m.tx = clipRect.x - newRect.x * m.a;
						m.ty = clipRect.y - newRect.y * m.d;
						newBmd.draw(bmd, m, null, null, clipRect, true);
					}
				}
			} else {
				m.identity();
				m.scale(width / bmd.width, height / bmd.height);
				setRect(grid, 0, 0, width, height);
				newBmd.draw(bmd, m, null, null, grid, true);
			}
			return newBmd;
		}
		
		/**设置rect，兼容player10*/
		public static function setRect(rect:Rectangle, x:Number = 0, y:Number = 0, width:Number = 0, height:Number = 0):Rectangle {
			rect.x = x;
			rect.y = y;
			rect.width = width;
			rect.height = height;
			return rect;
		}
		
		/**创建切片资源*/
		public static function createClips(bmd:BitmapData, xNum:int, yNum:int):Vector.<BitmapData> {
			var clips:Vector.<BitmapData> = new Vector.<BitmapData>();
			var width:int = Math.max(bmd.width / xNum, 1);
			var height:int = Math.max(bmd.height / yNum, 1);
			var point:Point = new Point();
			for (var i:int = 0; i < xNum; i++) {
				for (var j:int = 0; j < yNum; j++) {
					var item:BitmapData = new BitmapData(width, height);
					item.copyPixels(bmd, new Rectangle(i * width, j * height, width, height), point);
					clips.push(item);
				}
			}
			return clips;
		}
	}
}