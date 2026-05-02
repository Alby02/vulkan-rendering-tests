struct FragmentInput {
    float3 color;
};

[shader("fragment")]
// SV_Target tells the GPU this goes to the Swapchain image
float4 fragmentMain(FragmentInput input) : SV_Target {
    return float4(input.color, 1.0); // Return RGB + Alpha
}