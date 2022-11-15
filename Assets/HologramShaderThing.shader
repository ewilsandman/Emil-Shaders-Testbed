Shader "Unlit/HologramShaderThing"
{
 Properties
    {
        _MainTex ("Albedo Texture", 2D) = "white" {}
        _TintColour("Tint Colour", Color) = (1,1,1,1)
        _Transparency("Transparency", Range(0.0,0.5)) = 0.25
        _CutoutThresh("Cutout Threshold", Range(0.0,1.0)) = 0.2
        _Distance("Distance", Float) = 1
        _Amplitude("Amplitude", Float) = 1
        _Speed ("Speed", Float) = 1
        _Direction("Direction", Range (0.0,1.0)) = 0 
        _MovementFactor("_MovementFactor", Range(0.0,1.0)) = 1
    }

    SubShader
    {
        Tags {"Queue"="Transparent" "RenderType"="Transparent" }
        LOD 100
        Blend SrcAlpha OneMinusSrcAlpha

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
            float4 _MainTex_ST;
            float4 _TintColour;
            float _Transparency;
            float _CutoutThresh;
            float _Distance;
            float _Amplitude;
            float _Speed;
            float _MovementFactor;
            float _Direction;

            v2f vert (appdata v)
            {
                v2f o;
                if (_Direction > 0.5)
                {
                    v.vertex.y += sin(_Time.y * _Speed + v.vertex.y * _Amplitude) * _Distance * _MovementFactor;
                    o.vertex = UnityObjectToClipPos(v.vertex);
                    o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                    return o;
                }
                else  // not strictly needed
                {
                    v.vertex.x += sin(_Time.y * _Speed + v.vertex.x * _Amplitude) * _Distance * _MovementFactor;
                    o.vertex = UnityObjectToClipPos(v.vertex);
                    o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                    return o;
                }
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv) + _TintColour;
                col.a = _Transparency;
                clip(col.r - _CutoutThresh);
                return col;
            }
            ENDCG
        }
    }
}
