// 虚式・茈 — Orbital ring variant (no particles)
// Charge: sphere + 4 rotating orbital rings, accelerating as charge builds
// Release: rings shatter outward + central white flash

#define COLOR_HOT     vec3(1.0, 0.95, 1.0)
#define COLOR_PURPLE  vec3(0.776, 0.4, 0.965)
#define COLOR_DEEP    vec3(0.4, 0.1, 0.6)
#define AFTERMATH     0.7
#define MAX_CHARGE    2.5
#define INTENSITY     0.85
#define NUM_RINGS     4

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    fragColor = texture(iChannel0, uv);

    float t = iTime - iTimeCursorChange;
    float charge_norm  = clamp((t - AFTERMATH) / (MAX_CHARGE - AFTERMATH), 0.0, 1.0);
    float release_norm = 1.0 - clamp(t / AFTERMATH, 0.0, 1.0);

    vec2 cur_center  = iCurrentCursor.xy  + iCurrentCursor.zw  * vec2(0.5, -0.5);
    vec2 prev_center = iPreviousCursor.xy + iPreviousCursor.zw * vec2(0.5, -0.5);

    vec2 dir_to_cur   = fragCoord - cur_center;
    float dist_to_cur = length(dir_to_cur);
    float angle       = atan(dir_to_cur.y, dir_to_cur.x);

    // --- Layer 1: central sphere ---
    float sphere_r  = 8.0 + charge_norm * 4.0;
    float core      = exp(-pow(dist_to_cur / sphere_r, 2.0));
    float halo      = exp(-pow(dist_to_cur / (sphere_r * 3.0), 2.0));
    fragColor.rgb  += mix(COLOR_PURPLE, COLOR_HOT, core) * core * INTENSITY * (0.5 + charge_norm * 0.5);
    fragColor.rgb  += COLOR_DEEP * halo * 0.4 * charge_norm;

    // --- Layer 2: orbital rings ---
    for (int i = 0; i < NUM_RINGS; i++) {
        float fi          = float(i);
        float orbit_r     = 22.0 + fi * 11.0;
        float ring_w      = 1.0;
        float rot_speed   = (1.0 + fi * 0.6) * (1.0 + charge_norm * 2.0);
        float band_count  = 3.0 + fi;
        float ring_d      = abs(dist_to_cur - orbit_r);
        float band        = sin(angle * band_count + iTime * rot_speed * 2.0) * 0.5 + 0.5;
        band              = pow(band, 3.0);
        float ring        = exp(-pow(ring_d / ring_w, 2.0)) * band;
        fragColor.rgb    += COLOR_PURPLE * ring * INTENSITY * (0.4 + charge_norm * 0.6);
    }

    // --- Layer 3: release ---
    if (release_norm > 0.0) {
        float prev_dist = length(fragCoord - prev_center);

        // Central flash (brief star)
        float flash_r = 60.0 * release_norm;
        float flash   = exp(-pow(prev_dist / flash_r, 2.0));
        fragColor.rgb += COLOR_HOT * flash * release_norm * 0.9;

        // Rings shatter outward
        for (int i = 0; i < NUM_RINGS; i++) {
            float fi        = float(i);
            float orbit_r   = 22.0 + fi * 11.0;
            float scatter_r = orbit_r + (1.0 - release_norm) * (200.0 + fi * 30.0);
            float ring_w    = 2.0 + (1.0 - release_norm) * 4.0;
            float ring_d    = abs(prev_dist - scatter_r);
            float ring      = exp(-pow(ring_d / ring_w, 2.0));
            fragColor.rgb  += COLOR_PURPLE * ring * release_norm * INTENSITY;
        }
    }
}
