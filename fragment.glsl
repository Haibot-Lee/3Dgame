precision highp float;
uniform float time;
uniform vec2 resolution;
varying vec3 fPosition;
varying vec3 fNormal;

varying vec2 vUv;

uniform sampler2D texture;

vec2 blinnPhongDir(vec3 lightDir, float lightInt, float Ka, float Kd, float Ks, float shininess)
{
	vec3 s = normalize(lightDir);
	vec3 v = normalize(0.0 - fPosition); // camera = (0.0, 0.0, 0.0) *float point number
	vec3 n = normalize(fNormal);
	vec3 h = normalize(v+s);
	vec3 r = normalize(2.0 * dot(n, s) * n - s);
	//float ambient = Ka;
	float diffuse = Ka + Kd * lightInt * max(0.0, dot(n, s));
	float spec =  Ks * pow(max(0.0, dot(r, v)), shininess);
	return vec2(diffuse, spec);
}

void main()
{
    vec3 lightPosition = vec3(2.0, 1.0, 1.0);

	//vec3 lightDir = lightPosition - fPosition;

	vec2 ds = blinnPhongDir(lightPosition, 2.0, 1.0, 0.5, 1.0, 100.0);

	float brightness = ds.x + ds.y;

	float scaleNum = 1.0;

	// Divide color into different layers
	if (brightness < 1.1) {
		brightness = 0.1 * brightness * scaleNum;
	}else if (brightness < 1.2) {
		brightness = 0.4 * brightness * scaleNum;
	}else if (brightness < 1.6) {
		brightness = 0.6 * brightness * scaleNum;
	}else if (brightness < 2.2) {
		brightness = 2.0 * brightness * scaleNum;
	}else {
		//brightness = 3.0 * brightness * scaleNum;
	}
   	 

    //gl_FragColor = vec4(fNormal, 1.0);
    gl_FragColor = brightness * texture2D(texture, vUv);

	//gl_FragColor = vec4(brightness * fNormal, 1.0);
}
