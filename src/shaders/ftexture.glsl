#version 410
in fData {
    vec3 fN;
    vec3 fE;
    vec3 fL;
    vec2 ftexCoord;
}frag;

uniform vec4 ambientProduct;
uniform vec4 diffuseProduct;
uniform vec4 specularProduct;
uniform float shininess;
uniform sampler2D colorTexture;

out vec4 frag_color;

vec4 Phong(vec3 n)
{
    vec3 N = normalize(n);
    vec3 E = normalize(frag.fE);
    vec3 L = normalize(frag.fL);
    float NdotL = dot(N, L);
    vec3 R = normalize(2.0 * NdotL * N - L);
    float Kd = max(NdotL, 0.0);
    float Ks = (NdotL < 0.0) ? 0.0 : pow(max(dot(R, E), 0.0), shininess);
    vec4 diffuse = Kd * diffuseProduct * texture(colorTexture, frag.ftexCoord);
    vec4 specular = Ks * specularProduct;
    vec4 ambient = ambientProduct;
    return ambient + diffuse + specular;
}

void main()
{
    if (gl_FrontFacing)
    {
        frag_color = vec4(Phong(frag.fN).xyz, 1);
    }
    /**else {
        frag_color = mix(vec4(Phong(-fN).xyz, 1), vec4(0.0, 2.0, 0.0, 1.0), 0.7);
    }**/
}
