#ifdef GL_ES
precision mediump float;
#endif

uniform sampler2D tex;

varying vec2 fragTexCoord;

void kore() {	
	gl_FragColor = texture2D(tex, fragTexCoord);
}
