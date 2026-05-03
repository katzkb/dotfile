#define COLOR      vec3(0.545, 0.835, 0.792)  // Catppuccin Macchiato teal
#define DURATION   1.6     // ring lifetime (s)
#define MAX_RADIUS 220.0   // max ring radius (px)
#define RING_W     1.5     // ring thickness (px) — thin like water surface
#define INTENSITY  0.85    // brighter to compensate for thin line

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    vec4 base = texture(iChannel0, uv);

    float t = iTime - iTimeCursorChange;
    if (t >= 0.0 && t < DURATION) {
        vec2 cur_center = iCurrentCursor.xy + iCurrentCursor.zw * vec2(0.5, -0.5);
        float dist   = length(fragCoord - cur_center);
        float radius = (t / DURATION) * MAX_RADIUS;
        float ring   = exp(-pow(dist - radius, 2.0) / (RING_W * RING_W));
        float fade   = 1.0 - t / DURATION;
        fragColor = base + vec4(COLOR * ring * fade * INTENSITY, 0.0);
    } else {
        fragColor = base;
    }
}
