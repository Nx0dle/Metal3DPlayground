/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Metal vertex and fragment shaders.
*/

#include <metal_stdlib>

using namespace metal;

#include "ShaderTypes.h"

#pragma mark -

#pragma mark - Shaders for simple pipeline used to render triangle to renderable texture

// Vertex shader outputs and fragment shader inputs for simple pipeline
struct SimplePipelineRasterizerData
{
    float4 position [[position]];
    float4 color;
    float4 normalData;
    float4 lightVector;
    float4 lightPosition;
    float4 reflectDirection;
    float4 positionWorld;
};

// Vertex shader which passes position and color through to rasterizer.
vertex SimplePipelineRasterizerData
simpleVertexShader(const uint vertexID [[ vertex_id ]],
                   const device SimpleVertex3D *vertices [[ buffer(VertexInputIndexVertices) ]],
                   constant matrix_float4x4 &_projectionMatrix [[buffer(1)]],
                   constant matrix_float4x4 &modelViewMatrix [[buffer(2)]],
                   constant matrix_float4x4 &modelMatrix [[buffer(3)]])
{
    SimplePipelineRasterizerData out;
    
    out.lightPosition = float4(1, 1, 0, 1);
    out.positionWorld = modelMatrix * vertices[vertexID].position;
    
    float4 normalData = normalize(float4(vertices[vertexID].normal, 0.0));
    
    out.normalData = modelMatrix * normalData;
    
    float4 reflectDir = reflect(out.lightVector, normalData);
    
    out.reflectDirection = reflectDir;
    
    float4 position = float4(vertices[vertexID].position.xyz, 1.0);
    out.position = _projectionMatrix * modelViewMatrix * position;

    out.color = vertices[vertexID].color;
    
    return out;
}

// Fragment shader that just outputs color passed from rasterizer.
fragment float4 simpleFragmentShader(SimplePipelineRasterizerData in [[stage_in]],
                                     constant float &rotationLight [[buffer(4)]])
{
    float ambientStrength = 0.2;
    float specularStrength = 0.5;
    
    float radius = 1;
    
    float4 lightPosition = float4(radius * sin(rotationLight), 0, radius * cos(rotationLight), 1);
    
    in.lightVector = normalize(lightPosition - in.positionWorld);
    float brightness = (dot(in.normalData, in.lightVector));

    float4 lightColor = float4(1, 1, 1, 1);
    float4 ambient = ambientStrength * lightColor;
    float4 diffuse = brightness * lightColor;
    
    float4 viewDir = normalize(0 - in.position);
    float spec = pow(max(dot(viewDir, in.reflectDirection), 0.0), 256);
    float4 specular = specularStrength * spec * lightColor;

    
    
    float4 finalColor = in.color * (ambient + diffuse + specular);
    
    in.color = finalColor;
    
    return in.color;
}

#pragma mark -

#pragma mark Shaders for pipeline used texture from renderable texture when rendering to the drawable.

// Vertex shader outputs and fragment shader inputs for texturing pipeline.
struct TexturePipelineRasterizerData
{
    float4 position [[position]];
    float2 texcoord;
    float4 normalData;
    float4 lightVector;
    float4 lightPosition;
    float4 reflectDirection;
    float4 positionWorld;
};



// Vertex shader which adjusts positions by an aspect ratio and passes texture
// coordinates through to the rasterizer.
vertex TexturePipelineRasterizerData
textureVertexShader3D(const uint vertexID [[ vertex_id ]],
                    const device TextureVertex3D *vertices [[ buffer(VertexInputIndexVertices) ]],
                    constant float &aspectRatio [[ buffer(VertexInputIndexAspectRatio) ]],
                      constant matrix_float4x4 &_projectionMatrix [[buffer(5)]],
                      constant matrix_float4x4 &modelViewMatrix [[buffer(6)]],
                      constant matrix_float4x4 &modelMatrix [[buffer(7)]])
{
    TexturePipelineRasterizerData out;
    
    out.position = vector_float4(0.0, 0.0, 0.0, 1.0);

    out.position.x = vertices[vertexID].position.x;// * aspectRatio;
    out.position.y = vertices[vertexID].position.y;
    out.position.z = vertices[vertexID].position.z;

    out.texcoord = vertices[vertexID].texcoord;

    out.lightPosition = float4(1, 1, 0, 1);
    out.positionWorld = modelMatrix * vertices[vertexID].position;
    
    float4 normalData = normalize(float4(vertices[vertexID].normal, 0.0));
    
    out.normalData = modelMatrix * normalData;
    
    float4 reflectDir = reflect(out.lightVector, normalData);
    
    out.reflectDirection = reflectDir;
    
    float4 position = float4(vertices[vertexID].position.xyz, 1.0);
    out.position = _projectionMatrix * modelViewMatrix * position;

    return out;
}

#pragma mark -
#pragma mark Render texture shader

fragment float4 phongLight(TexturePipelineRasterizerData in [[stage_in]],
                                    texture2d<float> texture [[texture(0)]],
                              constant float &rotationLight [[buffer(8)]])
{
 
    sampler simpleSampler;
    
    float4 colorSample = texture.sample(simpleSampler, in.texcoord);
    
    float ambientStrength = 0.2;
    float specularStrength = 0.5;
    
    float radius = 1;
    
    float4 lightPosition = float4(radius * sin(rotationLight), 0, radius * cos(rotationLight), 1);
    
    in.lightVector = normalize(lightPosition - in.positionWorld);
    float brightness = (dot(in.normalData, in.lightVector));

    float4 lightColor = float4(1, 1, 1, 1);
    float4 ambient = ambientStrength * lightColor;
    float4 diffuse = brightness * lightColor;
    
    float4 viewDir = normalize(0 - in.position);
    float spec = pow(max(dot(viewDir, in.reflectDirection), 0.0), 256);
    float4 specular = specularStrength * spec * lightColor;

    
    
    float4 finalColor = colorSample * (ambient + diffuse + specular);
    
    colorSample = finalColor;
    
    return colorSample;
}

vertex TexturePipelineRasterizerData
textureVertexShader(const uint vertexID [[ vertex_id ]],
                    const device TextureVertex *vertices [[ buffer(VertexInputIndexVertices) ]],
                    constant float &aspectRatio [[ buffer(VertexInputIndexAspectRatio) ]])
{
    
    TexturePipelineRasterizerData out;

    out.position = vector_float4(0.0, 0.0, 0.0, 1.0);

    out.position.x = vertices[vertexID].position.x;// * aspectRatio;
    out.position.y = vertices[vertexID].position.y;

    out.texcoord = vertices[vertexID].texcoord;

    return out;
    
}

fragment float4 textureRender(TexturePipelineRasterizerData in [[stage_in]],
                              texture2d<float> texture [[texture(0)]])
{
    sampler simpleSampler;
    
    float4 colorSample = texture.sample(simpleSampler, in.texcoord);
    
    return colorSample;
}
