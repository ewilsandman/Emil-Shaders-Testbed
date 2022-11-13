Shader "Hidden/FireShaderThing"
{
    Properties
    {
        _MainTex ("Albedo Texture", 2D) = "white" {}
        _Speed ("Speed", Float) = 1
        _Amplitude("Amplitude", Range (0.0,1.0)) = 0 
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST; // unsure what this actually does
            float _Amplitude;
            float _Speed;

            v2f vert (appdata v)
            {
                v2f o;
                if (_Amplitude > 0.5)
                {
                    v.vertex.y += sin(_Time.y * _Speed + v.vertex.y * _Amplitude); // should probably be replaced
                    o.vertex = UnityObjectToClipPos(v.vertex);
                    o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                    return o;
                }
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                // just invert the colors
                col.rgb = 1 - col.rgb;
                return col;
            }
            ENDCG
        }
    }
}
