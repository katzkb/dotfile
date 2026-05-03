// 虚式・茈 — Vortex variant (no particles)
// Charge: vortex sphere at cursor + chromatic aberration
// Release: multi-wave shockwave + lingering haze at previous cursor

#define COLOR_HOT     vec3(1.0, 0.95, 1.0)
#define COLOR_PURPLE  vec3(0.776, 0.4, 0.965)
#define COLOR_DEEP    vec3(0.4, 0.1, 0.6)
#define AFTERMATH     0.7      // release effect lifetime (s)
#define MAX_CHARGE    2.5      // time to fully charge (s, after aftermath ends)
#define INTENSITY     0.85

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;

    float t = iTime - iTimeCursorChange;
    float charge_norm  = clamp((t - AFTERMATH) / (MAX_CHARGE - AFTERMATH), 0.0, 1.0);
    float release_norm = 1.0 - clamp(t / AFTERMATH, 0.0, 1.0);

    vec2 cur_center  = iCurrentCursor.xy  + iCurrentCursor.zw  * vec2(0.5, -0.5);
    vec2 prev_center = iPreviousCursor.xy + iPreviousCursor.zw * vec2(0.5, -0.5);

    // --- Layer 0: chromatic aberration around charging sphere ---
    vec2 dir_to_cur   = fragCoord - cur_center;
    float dist_to_cur = length(dir_to_cur);
    float ab_strength = charge_norm * 5.0 * exp(-dist_to_cur / 80.0);
    vec2 ab_offset    = normalize(dir_to_cur + vec2(0.001)) * ab_strength;

    vec3 col;
    col.r = texture(iChannel0, (fragCoord - ab_offset) / iResolution.xy).r;
    col.g = texture(iChannel0,  fragCoord              / iResolution.xy).g;
    col.b = texture(iChannel0, (fragCoord + ab_offset) / iResolution.xy).b;
    float a = texture(iChannel0, fragCoord / iResolution.xy).a;
    fragColor = vec4(col, a);

    // --- Layer 1: vortex sphere ---
    float angle      = atan(dir_to_cur.y, dir_to_cur.x);
    float sphere_r   = 10.0 + charge_norm * 10.0;
    float spiral     = sin(angle * 4.0 + dist_to_cur * 0.15 - iTime * 6.0) * 0.5 + 0.5;
    float core       = exp(-pow(dist_to_cur / sphere_r, 2.0));
    float halo       = exp(-pow(dist_to_cur / (sphere_r * 2.8), 2.0));
    vec3 sphere_col  = mix(COLOR_PURPLE, COLOR_HOT, core) * core * (0.7 + spiral * 0.5);
    sphere_col      += COLOR_DEEP * halo * 0.6;
    fragColor.rgb   += sphere_col * charge_norm * INTENSITY;

    // --- Layer 2: release effects at prev_center ---
    if (release_norm > 0.0) {
        float prev_dist = length(fragCoord - prev_center);

        // 3 staggered shockwaves
        for (int i = 0; i < 3; i++) {
            float fi      = float(i);
            float wt      = t - fi * 0.12;
            if (wt >= 0.0 && wt < AFTERMATH) {
                float wn      = wt / AFTERMATH;
                float wr      = wn * 320.0;
                float ring_w  = 3.0 + fi * 2.5;
                float ring    = exp(-pow(prev_dist - wr, 2.0) / (ring_w * ring_w));
                float fade    = 1.0 - wn;
                fragColor.rgb += COLOR_PURPLE * ring * fade * INTENSITY * 0.8;
            }
        }

        // lingering haze
        float haze = exp(-prev_dist * prev_dist / (160.0 * 160.0));
        fragColor.rgb += COLOR_DEEP * haze * release_norm * 0.18;
    }
}
