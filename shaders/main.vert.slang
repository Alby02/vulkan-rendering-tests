// This matches the C++ struct we are about to create!
struct VertexInput {
    float2 position : POSITION;
    float3 color    : COLOR;
};

struct VertexOutput {
    float4 position : SV_Position;
    float3 color;
};

struct PushConstants {
    float4x4 mvp; // Model-View-Projection Matrix
};
[[vk::push_constant]] PushConstants pushConstants;

[shader("vertex")]
VertexOutput vertexMain(VertexInput input) {
    VertexOutput output;

    // We multiply our 3D matrix by our position to move it into 3D space
    float4 worldPosition = float4(input.position, 0.0, 1.0);
    output.position = mul(pushConstants.mvp, worldPosition);

    output.color = input.color;
    return output;
}