/* 
 * The MIT License
 *
 * Copyright (c) 2008
 * United Nations Office at Geneva
 * Center for Advanced Visual Analytics
 * http://cava.unog.ch
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */


package org.un.cava.birdeye.geo.symbols
{
	import com.degrafa.GeometryGroup;
	import com.degrafa.geometry.Path;
	import com.degrafa.geometry.Circle
	
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import mx.containers.Canvas;
	import mx.containers.VBox;
	import mx.controls.Alert;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	import org.un.cava.birdeye.geo.projections.Projections;
	
	[Inspectable("key")] 
	public class Symbols extends Canvas
	{
		private var _key:String="";
		public var myUIComp:UIComponent;
		
		public function set key(value:String):void{
			_key=value;
		}
		
		public function Symbols()
		{
			super();
			this.mouseEnabled=false;
			this.mouseChildren=false;
			myUIComp=new UIComponent();
			addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
		}
		
		private function creationCompleteHandler (event:FlexEvent):void{
			if(_key!=""){
				var dynamicClassName:String=getQualifiedClassName(this.parent);
				var dynamicClassRef:Class = getDefinitionByName(dynamicClassName) as Class;
				var proj:String=(this.parent as dynamicClassRef).projection;
				var region:String=(this.parent as dynamicClassRef).region;
				
				var GeoData:Object=Projections.getData(proj,region);
				
				var GPGeom:GeometryGroup=new GeometryGroup();
				GPGeom.transform.matrix = new Matrix(GeoData.scaleX,0,0,GeoData.scaleY,GeoData.translateX,1*GeoData.translateY);
				GPGeom.addEventListener(MouseEvent.CLICK,handleClickEvent);
				var cntry:Path=new Path();
				cntry.data=GeoData.getCoordinates(_key);
				
				GPGeom.geometryCollection.addItem(cntry);
				
				var arrChildren:Array=new Array();
				var arrWidth:Array=new Array();
				var arrHeight:Array=new Array();
				
				arrChildren=this.getChildren();
				
				var myVBox:VBox=new VBox();
				myVBox.percentWidth=100;
				myVBox.percentHeight=100;
				myVBox.horizontalScrollPolicy="off";
				myVBox.verticalScrollPolicy="off";
				var childNumber:int=0;
				//Alert.show(arrChildren.length.toString());
				while (childNumber<arrChildren.length) { 
					myVBox.addChild(arrChildren[childNumber]);	
					arrWidth[childNumber]=arrChildren[childNumber].width;
					arrHeight[childNumber]=arrChildren[childNumber].height;
					childNumber++
				}
				
				arrWidth.sort(Array.NUMERIC, Array.DESCENDING);
				arrHeight.sort(Array.NUMERIC, Array.DESCENDING);
				
				
				//myVBox.x=313.2;
				//myVBox.y=64.9+174.8;
				//UIComp.x=GPGeom.x-UIComp.width/2;
				//UIComp.y=GPGeom.y-UIComp.width/2;
				//Alert.show(parent.name);
				//myUIComp.addChild(myVBox);
				//this.addChild(myUIComp);
				//Alert.show('/'+myUIComp.height+'/'+myUIComp.width+'/'+myUIComp.x+'/'+myUIComp.y+'/');
				///myVBox.x=GPGeom.x-(arrWidth[arrWidth.length-1]/2);
				///myVBox.y=GPGeom.y-(arrHeight[arrHeight.length-1]/2);
				this.addChild(myVBox);
				//Alert.show(GPGeom.height+'/'+GPGeom.width+'/'+GPGeom.x+'/'+GPGeom.y);
			}
		}	
		
		private function handleClickEvent(eventObj:MouseEvent):void {
			eventObj.stopPropagation()
		}
		
	}
}