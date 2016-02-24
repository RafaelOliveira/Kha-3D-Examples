package;

import kha.Assets;
import kha.Framebuffer;
import kha.Color;
import kha.graphics4.TextureUnit;
import kha.Image;
import kha.Shaders;
import kha.graphics4.PipelineState;
import kha.graphics4.VertexStructure;
import kha.graphics4.VertexBuffer;
import kha.graphics4.IndexBuffer;
import kha.graphics4.FragmentShader;
import kha.graphics4.VertexShader;
import kha.graphics4.VertexData;
import kha.graphics4.Usage;
import kha.System;

class App 
{
	var vertexBuffer:VertexBuffer;
	var indexBuffer:IndexBuffer;
	var pipeline:PipelineState;
	
	var structure:VertexStructure;
	var structureLength:Int;
	
	var textureID:TextureUnit;
    var image:Image;

	public function new() 
	{
		Assets.loadEverything(loadingFinished);
    }
	
	function loadingFinished() 
	{
		loadShaders();
		loadTriangle();
		
		// start the rendering system after load everything
		System.notifyOnRender(render);
	}
	
	public function loadShaders()
	{
		// Define vertex structure
		structure = new VertexStructure();
        structure.add('vert', VertexData.Float3);
        structure.add('vertTexCoord', VertexData.Float2);
		
        // Save length - we store position and uv data
        structureLength = 5;

        // Compile pipeline state
		// Shaders are located in 'Sources/Shaders' directory
        // and Kha includes them automatically
		pipeline = new PipelineState();
		pipeline.inputLayout = [structure];
		pipeline.vertexShader = Shaders.simple_vert;
		pipeline.fragmentShader = Shaders.simple_frag;        
		pipeline.compile();

		// Get a handle for texture sample
		textureID = pipeline.getTextureUnit('tex');		

		// Texture
		image = Assets.images.hazard;
	}
	
	public function loadTriangle()
	{
		// An array of the triangle vertices
		var vertices:Array<Float> = [
		//  X     Y    Z
			0.0,  0.8, 0.0,
		   -0.8, -0.8, 0.0,
			0.8, -0.8, 0.0
		];
		
		// Array of texture coordinates (UV)
		var uvs:Array<Float> = [
		//	U	V
			0.5, 1.0,
			0.0, 0.0,
			1.0, 0.0
		];
		
		// Create vertex buffer
		vertexBuffer = new VertexBuffer(
			Std.int(vertices.length / 3), // Vertex count - 3 floats per vertex
			structure, // Vertex structure
			Usage.StaticUsage // Vertex data will stay the same
		);

		// Copy vertices and uvs to vertex buffer
		var vbData = vertexBuffer.lock();
		for (i in 0...Std.int(vbData.length / structureLength)) {
			vbData.set(i * structureLength, vertices[i * 3]);
			vbData.set(i * structureLength + 1, vertices[i * 3 + 1]);
			vbData.set(i * structureLength + 2, vertices[i * 3 + 2]);
			vbData.set(i * structureLength + 3, uvs[i * 2]);
			vbData.set(i * structureLength + 4, uvs[i * 2 + 1]);
		}
		vertexBuffer.unlock();

		// A 'trick' to create indices for a non-indexed vertex data
		var indices:Array<Int> = [];
		for (i in 0...Std.int(vertices.length / 3)) {
			indices.push(i);
		}

		// Create index buffer
		indexBuffer = new IndexBuffer(
			indices.length, // Number of indices for our cube
			Usage.StaticUsage // Index data will stay the same
		);
		
		// Copy indices to index buffer
		var iData = indexBuffer.lock();
		for (i in 0...iData.length) {
			iData[i] = indices[i];
		}
		indexBuffer.unlock();
	}

	public function render(frame:Framebuffer) 
	{
		// A graphics object which lets us perform 3D operations
		var g = frame.g4;

		// Begin rendering
        g.begin();

        // Clear screen to black
		g.clear(Color.Black);

		// Bind state we want to draw with
		g.setPipeline(pipeline);

		// Bind data we want to draw
		g.setVertexBuffer(vertexBuffer);
		g.setIndexBuffer(indexBuffer);
		
		// Set texture
		g.setTexture(textureID, image);

		// Draw!
		g.drawIndexedVertices();

		// End rendering
		g.end();
    }
}
