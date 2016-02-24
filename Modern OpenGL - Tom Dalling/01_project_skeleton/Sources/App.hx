package;

import kha.Framebuffer;
import kha.Color;
import kha.Shaders;
import kha.graphics4.PipelineState;
import kha.graphics4.VertexStructure;
import kha.graphics4.VertexBuffer;
import kha.graphics4.IndexBuffer;
import kha.graphics4.FragmentShader;
import kha.graphics4.VertexShader;
import kha.graphics4.VertexData;
import kha.graphics4.Usage;

class App 
{
	var vertexBuffer:VertexBuffer;
	var indexBuffer:IndexBuffer;
	var pipeline:PipelineState;
	
	var structure:VertexStructure;

	public function new() 
	{
		loadShaders();
		loadTriangle();
    }
	
	public function loadShaders()
	{
		// Define vertex structure
		structure = new VertexStructure();
        structure.add('vert', VertexData.Float3);
		
        // Save length - we only store position in vertices for now
        // Eventually there will be texture coords, normals,...
        var structureLength = 3;
	
		// Compile pipeline state
		// Shaders are located in 'Shaders' directory
        // and Kha includes them automatically
		pipeline = new PipelineState();
		pipeline.inputLayout = [structure];
		pipeline.fragmentShader = Shaders.simple_frag;
		pipeline.vertexShader = Shaders.simple_vert;
		pipeline.compile();
	}
	
	public function loadTriangle()
	{
		// An array of 3 vectors representing 3 vertices to form a triangle
		var vertices:Array<Float> = [
		//  X     Y     Z
		    0.0,  0.8, 0.0, // Top
		   -0.8, -0.8, 0.0, // Bottom-left
			0.8, -0.8, 0.0  // Bottom-right
		];
		
		// Indices for our triangle, these will point to vertices above
		var indices:Array<Int> = [
			0, // Top
			1, // Bottom-left
			2  // Bottom-right
		];
		
		// Create vertex buffer
		vertexBuffer = new VertexBuffer(
			Std.int(vertices.length / 3), // Vertex count - 3 floats per vertex
			structure, // Vertex structure
			Usage.StaticUsage // Vertex data will stay the same
		);
		
		// Copy vertices to vertex buffer
		var vbData = vertexBuffer.lock();
		for (i in 0...vbData.length) {
			vbData.set(i, vertices[i]);
		}
		vertexBuffer.unlock();

		// Create index buffer
		indexBuffer = new IndexBuffer(
			indices.length, // 3 indices for our triangle
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

		// Draw!
		g.drawIndexedVertices();

		// End rendering
		g.end();
    }
}
