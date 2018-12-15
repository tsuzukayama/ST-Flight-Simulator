#version 410

in vec3 fN;
in vec3 fE;
in vec3 fL;
in vec2 ftexCoord;

uniform vec4 ambientProduct;
uniform vec4 diffuseProduct;
uniform vec4 specularProduct;
uniform float shininess;
uniform sampler2D colorTexture;
uniform sampler2D colorTextureLayer;

out vec4 frag_color;

vec4 Phong(vec3 n)
{
    vec3 N = normalize(n);
    vec3 E = normalize(fE);
    vec3 L = normalize(fL);
    float NdotL = dot(N,L);
    vec3 R = normalize(2.0 *NdotL * N - L);
    float Kd = max(NdotL, 0.0);
    float Ks = (NdotL < 0.0) ? 0.0 : pow(max(dot(R, E), 0.0), shininess);
    float mossContrib = (texture(colorTextureLayer, ftexCoord)).r;
    vec4 mixtex = mix(texture(colorTexture, ftexCoord), texture(colorTextureLayer, ftexCoord), mossContrib);
    vec4 diffuse = Kd * diffuseProduct * mixtex;
    vec4 specular = Ks * specularProduct;
    vec4 ambient = ambientProduct;
    return ambient + diffuse + specular;
}

void main()
{
    float d = clamp(fE.z/100.0f, 0, 1); // Simulate black fog
    if (gl_FrontFacing)
    {

        frag_color.rgb = Phong(fN).xyz * (1.0f - d);
        frag_color.a = 1.0f;
    }
    else
    {
        frag_color.rgb = mix((Phong(-fN).xyz * (1.0f - d)), vec3(0.0, 2.0, 0.0), 0.7);
        frag_color.a = 1.0f;
    }
}
