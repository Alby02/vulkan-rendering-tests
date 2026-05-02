struct VertexOutput {
    // SV_Position tells the GPU this is the final screen coordinate
    float4 position : SV_Position;
    float3 color;
};

[shader("vertex")]
VertexOutput vertexMain(uint vertexID : SV_VertexID) {
    VertexOutput output;
    
    // Hardcoded triangle corners (X, Y)
    float2 positions[3] = {
        float2(0.0, -0.5), // Top center
        float2(0.5, 0.5),  // Bottom right
        float2(-0.5, 0.5)  // Bottom left
    };
    
    // Hardcoded colors (Red, Green, Blue)
    float3 colors[3] = {
        float3(1.0, 0.0, 0.0),
        float3(0.0, 1.0, 0.0),
        float3(0.0, 0.0, 1.0)
    };
    
    output.position = float4(positions[vertexID], 0.0, 1.0);
    output.color = colors[vertexID];
    
    return output;
}