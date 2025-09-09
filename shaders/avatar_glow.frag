#version 320 es
precision mediump float;

layout(location = 0) out vec4 fragColor;
layout(location = 0) uniform float uTime;       // animation time
layout(location = 1) uniform float uWidth;      // widget width
layout(location = 2) uniform float uHeight;     // widget height

void main() {
  vec2 uv = gl_FragCoord.xy / vec2(uWidth, uHeight);
  float glow = 0.5 + 0.5 * sin(uTime + uv.y * 10.0);
  vec3 color = mix(vec3(0.3, 0.0, 0.7), vec3(0.7, 0.9, 1.0), glow);
  fragColor = vec4(color, 1.0);
}
