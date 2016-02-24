#ifdef GL_ES
precision highp float;
#endif

attribute vec3 vert;
attribute vec2 vertTexCoord;

varying vec2 fragTexCoord;

void kore() {
	// Pass the tex coord straight through to the fragment shader
	fragTexCoord = vertTexCoord;
	
	gl_Position = vec4(vert, 1.0);
}
