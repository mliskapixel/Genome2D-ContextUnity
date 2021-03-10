/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2014 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package com.genome2d.context.renderers;

import unityengine.*;
import genome2dnativeplugin.*;
import com.genome2d.context.GProjectionMatrix;
import com.genome2d.context.IGContext;
import com.genome2d.context.IGRenderer;
import com.genome2d.debug.GDebug;
import com.genome2d.geom.GFloat4;
import com.genome2d.geom.GMatrix3D;
import com.genome2d.textures.GTexture;

class G3DRenderer implements IGRenderer
{
	private var g2d_context:GUnityContext;

	public var modelMatrix:GMatrix3D;
	public var cameraMatrix:GMatrix3D;
	public var projectionMatrix:GProjectionMatrix;
	
	
	public var lightDirection:GFloat4;
	public var lightColor:GFloat4;
    public var ambientColor:GFloat4;
    public var tintColor:GFloat4;
	
	public var texture:GTexture;

	private var nativeRenderer:GNativeUnity3DRenderer;


	public function getProgram() {
		return null;
	}
	
	public function invalidateGeometry(p_vertices:Array<Float>, p_uvs:Array<Float>, p_indices:Array<UInt>, p_normals:Array<Float>):Void {
		if (nativeRenderer == null) {
			nativeRenderer = new GNativeUnity3DRenderer(cs.Lib.nativeArray(p_vertices, false), cs.Lib.nativeArray(p_uvs, false), cs.Lib.nativeArray(p_indices,false), cs.Lib.nativeArray(p_normals,false));
		} else {
			nativeRenderer.InvalidateGeometry(cs.Lib.nativeArray(p_vertices, false), cs.Lib.nativeArray(p_uvs, false), cs.Lib.nativeArray(p_indices,false), cs.Lib.nativeArray(p_normals,false));
		}
	}
	
	public function new(p_vertices:Array<Float>, p_uvs:Array<Float>, p_indices:Array<UInt>, p_normals:Array<Float>, p_generatePerspectiveMatrix:Bool = false):Void {
		invalidateGeometry(p_vertices, p_uvs, p_indices, p_normals);
		
		modelMatrix = new GMatrix3D();
		cameraMatrix = new GMatrix3D();
		lightDirection = new GFloat4();
    }

    public function initialize(p_context:GUnityContext):Void {
		g2d_context = p_context;
		
	}

    public function bind(p_context:IGContext, p_reinitialize:Int):Void {
		
    }

	private var _lightDirection = new Vector3(0, 0, 0);
	private var _lightColor = new Color(0, 0, 0);
	private var _ambientColor = new Color(0, 0, 0);
	private var _tintColor = new Color(0, 0, 0);
	public function draw(p_cull:Int, p_renderType:Int):Void {
		_lightDirection.x = lightDirection.x; _lightDirection.y = lightDirection.y; _lightDirection.z = lightDirection.z;
		nativeRenderer.lightDirection = _lightDirection;

		_lightColor.r = lightColor.x; _lightColor.g = lightColor.y; _lightColor.b = lightColor.z;
		nativeRenderer.lightColor = _lightColor;

		_ambientColor.r = ambientColor.x; _ambientColor.g = ambientColor.y; _ambientColor.b = ambientColor.z;
		nativeRenderer.ambientColor = _ambientColor;

		_tintColor.r = tintColor.x; _tintColor.g = tintColor.y; _tintColor.b = tintColor.z; _tintColor.a = tintColor.w;
		nativeRenderer.tintColor = _tintColor;

		nativeRenderer.Draw(texture.nativeTexture, modelMatrix.rawData, cameraMatrix.rawData);
	}
	
	public function push():Void {
		
	}

    public function clear():Void {

    }
	
	public function dispose():Void {

	}
}