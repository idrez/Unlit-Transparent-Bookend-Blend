// Unity built-in shader source. Copyright (c) 2016 Unity Technologies. MIT license (see license.txt)

// Unlit alpha-cutout shader.
// - no lighting
// - no lightmap support
// - no per-material color

Shader "Unlit/Transparent Bookend Blend" {
Properties {
	_Color  ("Color Blend", Color) = (1,1,1,1)
    _MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}

	_UCutoff ("Upper cutoff", Range(0,1)) = 0.5
	_UBlend ("Upper Blend Range", Range(0,.5)) = 0.0

	_LCutoff ("Lower cutoff", Range(0,1)) = 0.5
	_LBlend ("Lower Blend Range", Range(0,.5)) = 0.0
}
SubShader {
    Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="TransparentCutout"}
	Blend SrcAlpha OneMinusSrcAlpha
    LOD 100

    Lighting Off

	Cull Off

    Pass {
        CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 2.0
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata_t {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f {
                float4 vertex : SV_POSITION;
                float2 texcoord : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                UNITY_VERTEX_OUTPUT_STEREO
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
			fixed _LCutoff;
			fixed _UCutoff;
			fixed _UBlend;
			fixed _LBlend;
			fixed4 _Color;

            v2f vert (appdata_t v)
            {
                v2f o;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

			fixed4 frag (v2f i) : SV_Target
			{
				float pi = 3.14159;
				fixed4 col = tex2D(_MainTex, i.texcoord);
				float uBlend = _UCutoff + _UBlend * ((cos(pi * _UCutoff+pi)/2)+0.5);
				float lBlend = _LCutoff - ( _LBlend * ((cos(pi * _LCutoff)/2+0.5) ));


				if (col.a == 1 ) {
					col.a = 1;
				}
				else if (col.a == 0) {
					col.a = 0;
				}
				else if(col.a < lBlend || col.a > uBlend) {
					col.a = 0;
				}
				else {

					float low = 1;
					float high = 1;

					if (col.a > uBlend - _UBlend) { // blend is never zero here because previous conditionals
						high = 1-(col.a - (uBlend-_UBlend)) / _UBlend ;
					}

					if (col.a < lBlend + _LBlend) { // blend is never zero here because previous conditionals
						low = (col.a-lBlend) / _LBlend ;
					}


					col.a = (low*high);
				}

				col.r *= _Color.r;
				col.g *= _Color.g;
				col.b *= _Color.b;
				col.a *= _Color.a;
            	UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
        ENDCG
    }
}

}
