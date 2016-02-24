attribute vec3 vert;

void kore() {
	// does not alter the verticies at all
	gl_Position = vec4(vert, 1.0);
}
