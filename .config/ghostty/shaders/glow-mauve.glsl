#define COLOR     vec3(0.776, 0.627, 0.965)  // Catppuccin Macchiato mauve
#define RADIUS    60.0    // halo falloff (px)
#define INTENSITY 0.35    // 0.2 whisper, 0.6 noticeable
#define PERIOD    2.0     // breathing cycle (s)

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    vec4 base = texture(iChannel0, uv);

    vec2 cur_center = iCurrentCursor.xy + iCurrentCursor.zw * vec2(0.5, -0.5);
    float dist  = length(fragCoord - cur_center);
    float halo  = exp(-(dist * dist) / (RADIUS * RADIUS));
    float pulse = 0.7 + 0.3 * sin(iTime * 6.2832 / PERIOD);
    fragColor = base + vec4(COLOR * halo * pulse * INTENSITY, 0.0);
}
