// 虚式・茈 — Reality distortion variant
// Charge: gravitational lens-like refraction of background + chromatic aberration
// Release: distortion wave propagating outward + brief color inversion + sphere flash

#define COLOR_HOT     vec3(1.0, 0.95, 1.0)
#define COLOR_PURPLE  vec3(0.776, 0.4, 0.965)
#define COLOR_DEEP    vec3(0.4, 0.1, 0.6)
#define AFTERMATH     0.7
#define MAX_CHARGE    2.5
#define INTENSITY     0.85

// Hash + interpolated noise for jagged lightning displacement
float hash11(float p) {
    p = fract(p * 0.1031);
    p *= p + 33.33;
    p *= p + p;
    return fract(p);
}
float noise1d(float x) {
    float i = floor(x);
    float f = fract(x);
    f = f * f * (3.0 - 2.0 * f);
    return mix(hash11(i), hash11(i + 1.0), f);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;

    float t = iTime - iTimeCursorChange;
    float charge_norm  = clamp((t - AFTERMATH) / (MAX_CHARGE - AFTERMATH), 0.0, 1.0);
    float release_norm = 1.0 - clamp(t / AFTERMATH, 0.0, 1.0);

    vec2 cur_center  = iCurrentCursor.xy  + iCurrentCursor.zw  * vec2(0.5, -0.5);
    vec2 prev_center = iPreviousCursor.xy + iPreviousCursor.zw * vec2(0.5, -0.5);

    vec2 dir_to_cur   = fragCoord - cur_center;
    float dist_to_cur = length(dir_to_cur);
    vec2 dir_norm     = normalize(dir_to_cur + vec2(0.001));

    // --- Layer 1: gravitational lensing (refraction toward cursor) ---
    float lens_strength = charge_norm * 12.0 * exp(-dist_to_cur / 70.0);
    vec2 lens_offset    = -dir_norm * lens_strength;

    // Sample with chromatic aberration: stronger color split with charge
    float ab_amount = charge_norm * 4.0 * exp(-dist_to_cur / 100.0);
    vec3 col;
    col.r = texture(iChannel0, (fragCoord + lens_offset - dir_norm * ab_amount) / iResolution.xy).r;
    col.g = texture(iChannel0, (fragCoord + lens_offset)                        / iResolution.xy).g;
    col.b = texture(iChannel0, (fragCoord + lens_offset + dir_norm * ab_amount) / iResolution.xy).b;
    float a = texture(iChannel0, fragCoord / iResolution.xy).a;
    fragColor = vec4(col, a);

    // --- Layer 2: subtle sphere ---
    float sphere_r = 8.0 + charge_norm * 6.0;
    float core     = exp(-pow(dist_to_cur / sphere_r, 2.0));
    float halo     = exp(-pow(dist_to_cur / (sphere_r * 3.5), 2.0));
    fragColor.rgb += mix(COLOR_PURPLE, COLOR_HOT, core) * core * charge_norm * INTENSITY * 0.7;
    fragColor.rgb += COLOR_DEEP * halo * 0.3 * charge_norm;

    // --- Layer 3: release ---
    if (release_norm > 0.0) {
        float prev_dist    = length(fragCoord - prev_center);
        vec2 prev_dir_norm = normalize(fragCoord - prev_center + vec2(0.001));

        // Pre-compute jump factor so prev effects can dampen on big jumps
        // (energy transfers to arrival side; departure stays subtle)
        float jump_dist   = length(iCurrentCursor.xy - iPreviousCursor.xy);
        float jump_factor = smoothstep(60.0, 200.0, jump_dist);
        float prev_atten  = 1.0 - jump_factor * 0.6;   // dampens to 40% on full jumps

        // Distortion wave at prev (energy departing)
        float wave_r       = (1.0 - release_norm) * 350.0;
        float wave_w       = 50.0;
        float wave_mask    = exp(-pow(prev_dist - wave_r, 2.0) / (wave_w * wave_w));
        vec2 wave_offset   = -prev_dir_norm * wave_mask * 20.0 * release_norm;
        vec3 wave_col;
        wave_col.r = texture(iChannel0, (fragCoord + wave_offset + prev_dir_norm * wave_mask * 6.0) / iResolution.xy).r;
        wave_col.g = texture(iChannel0, (fragCoord + wave_offset)                                    / iResolution.xy).g;
        wave_col.b = texture(iChannel0, (fragCoord + wave_offset - prev_dir_norm * wave_mask * 6.0) / iResolution.xy).b;
        fragColor.rgb = mix(fragColor.rgb, wave_col, wave_mask * release_norm * prev_atten);
        fragColor.rgb += COLOR_PURPLE * wave_mask * release_norm * 0.4 * prev_atten;

        // Central flash at prev (dampened on big jump)
        float flash_r = 50.0 * release_norm;
        float flash   = exp(-pow(prev_dist / flash_r, 2.0));
        fragColor.rgb += COLOR_HOT * flash * release_norm * 0.7 * prev_atten;

        // Lingering purple haze (always — feels like residue, fine at full intensity)
        float haze = exp(-prev_dist * prev_dist / (200.0 * 200.0));
        fragColor.rgb += COLOR_DEEP * haze * release_norm * 0.2;

        // --- Big-jump extras: pane switches / window jumps ---
        if (jump_factor > 0.0) {
            // ===== Cross-shaped release burst at prev (lens-flare style) =====
            vec2 prev_dir2 = fragCoord - prev_center;
            // Horizontal + vertical arms (thin, bright)
            float h_arm     = exp(-pow(prev_dir2.y / 1.2, 2.0));
            float v_arm     = exp(-pow(prev_dir2.x / 1.2, 2.0));
            float main_arms = max(h_arm, v_arm);
            // Diagonal arms (45° rotated, fainter)
            vec2 rot        = vec2(prev_dir2.x + prev_dir2.y, prev_dir2.y - prev_dir2.x) * 0.7071;
            float diag_arms = max(exp(-pow(rot.y / 1.0, 2.0)), exp(-pow(rot.x / 1.0, 2.0)));
            // Length falloff so arms don't extend infinitely
            float arm_extent = exp(-pow(prev_dist / 80.0, 2.0));
            float cross_int  = release_norm * jump_factor * 0.55;
            fragColor.rgb   += COLOR_HOT    * main_arms * arm_extent * cross_int;
            fragColor.rgb   += COLOR_PURPLE * diag_arms * arm_extent * cross_int * 0.5;

            // ----- Mass sphere travels prev→cur, lightning trails behind it -----
            vec2 ab          = cur_center - prev_center;
            float ab_len2    = max(dot(ab, ab), 0.0001);
            float ab_len     = sqrt(ab_len2);
            vec2 ab_perp     = vec2(-ab.y, ab.x) / ab_len;
            float t_along    = clamp(dot(fragCoord - prev_center, ab) / ab_len2, 0.0, 1.0);
            vec2 proj        = prev_center + ab * t_along;
            float beam_d     = length(fragCoord - proj);

            float bolt_int   = release_norm * jump_factor * INTENSITY;

            // Travel progress: sphere reaches cur in first ~14% of aftermath window
            float travel_progress = clamp((1.0 - release_norm) * 7.0, 0.0, 1.0);
            vec2  sphere_pos      = mix(prev_center, cur_center, travel_progress);
            // Impact timing — destruction starts when sphere arrives at cur
            float arrival_t       = AFTERMATH / 7.0;          // matches travel multiplier
            float impact_t        = t - arrival_t;
            float impact_active   = step(0.0, impact_t);       // 1 after arrival, 0 before
            float impact_progress = clamp(impact_t / max(AFTERMATH - arrival_t, 0.001), 0.0, 1.0); // 0→1 across impact window
            float impact_intensity = (1.0 - impact_progress) * impact_active;                       // 1 at impact, 0 at end
            // Trail mask — lightning visible only behind sphere's current position
            float trail_mask      = 1.0 - smoothstep(travel_progress - 0.03, travel_progress + 0.05, t_along);

            // Wide faint halo (trail body)
            float halo_l     = exp(-pow(beam_d / 14.0, 2.0));
            fragColor.rgb   += COLOR_DEEP * halo_l * bolt_int * 0.5 * trail_mask;

            // 2 lightning bolts: noise-based jagged displacement (3 octaves)
            for (int i = 0; i < 2; i++) {
                float fi   = float(i);
                float seed = fi * 17.31;
                // 4 octaves: coarse + mid + fine + ultra-fine for max jaggedness
                float n1   = noise1d(t_along * 22.0  + iTime * 14.0 + seed);
                float n2   = noise1d(t_along * 55.0  + iTime * 9.0  + seed * 1.7);
                float n3   = noise1d(t_along * 130.0 + iTime * 5.0  + seed * 2.3);
                float n4   = noise1d(t_along * 280.0 + iTime * 3.0  + seed * 3.1);
                float disp = (n1 - 0.5) * 20.0
                           + (n2 - 0.5) * 11.0
                           + (n3 - 0.5) * 5.0
                           + (n4 - 0.5) * 2.0;
                // Taper to zero at endpoints (clean attach to prev/cur)
                float taper     = sin(t_along * 3.14159);
                disp           *= taper;
                vec2 disp_proj  = proj + ab_perp * disp;
                float lit_d     = length(fragCoord - disp_proj);
                float thickness = 1.4 + 0.5 * taper;
                float bolt      = exp(-pow(lit_d / thickness, 2.0));
                float core      = exp(-pow(lit_d / 0.55, 2.0));
                fragColor.rgb  += COLOR_PURPLE * bolt * bolt_int * 0.7 * trail_mask;
                fragColor.rgb  += COLOR_HOT    * core * bolt_int * 0.75 * trail_mask;
            }

            // ===== Traveling mass sphere — the "imaginary mass" of 茈 in flight =====
            float sphere_dist  = length(fragCoord - sphere_pos);
            float sphere_r     = 18.0;
            float sphere_core  = exp(-pow(sphere_dist / sphere_r, 2.0));
            float sphere_halo  = exp(-pow(sphere_dist / (sphere_r * 2.8), 2.0));
            // Fade as sphere nears destination — impact destruction takes over from there
            float sphere_alive = (1.0 - smoothstep(0.88, 1.0, travel_progress)) * release_norm * jump_factor;
            fragColor.rgb     += mix(COLOR_PURPLE, COLOR_HOT, sphere_core) * sphere_core * sphere_alive * INTENSITY * 1.4;
            fragColor.rgb     += COLOR_DEEP * sphere_halo * sphere_alive * 0.5;

            // === DESTRUCTION at arrival point — fires when sphere arrives ===
            vec2  cur_dir   = fragCoord - cur_center;
            float cur_angle = atan(cur_dir.y, cur_dir.x);

            // 1. Central explosion sphere — bright bloom, expands & fades
            float exp_r       = 40.0 + impact_progress * 70.0;
            float explosion   = exp(-pow(dist_to_cur / exp_r, 2.0));
            fragColor.rgb    += mix(COLOR_PURPLE, COLOR_HOT, explosion) * explosion * impact_intensity * jump_factor * INTENSITY * 1.4;

            // 2. Hot collapsing core — small white-hot center, fades fast
            float core_r      = max(28.0 * impact_intensity, 0.5);
            float core        = exp(-pow(dist_to_cur / core_r, 2.0));
            fragColor.rgb    += COLOR_HOT * core * impact_intensity * jump_factor * 1.0;

            // 3. Radial rays bursting outward (8 rays from impact)
            float ray_pat     = pow(abs(sin(cur_angle * 4.0)), 8.0);
            float ray_len_r   = 60.0 + impact_progress * 220.0;     // rays extend outward over time
            float ray_falloff = exp(-pow(dist_to_cur / ray_len_r, 2.0));
            fragColor.rgb    += COLOR_PURPLE * ray_pat * ray_falloff * impact_intensity * jump_factor * INTENSITY * 1.1;
            // hot inner of rays
            float ray_hot     = pow(abs(sin(cur_angle * 4.0)), 16.0);
            float ray_hot_r   = exp(-pow(dist_to_cur / (40.0 + impact_progress * 120.0), 2.0));
            fragColor.rgb    += COLOR_HOT * ray_hot * ray_hot_r * impact_intensity * jump_factor * 0.6;

            // 4. Lingering scar — purple haze that persists at impact
            float scar        = exp(-pow(dist_to_cur / 75.0, 2.0));
            fragColor.rgb    += COLOR_DEEP * scar * impact_intensity * jump_factor * 0.35;
        }
    }
}
