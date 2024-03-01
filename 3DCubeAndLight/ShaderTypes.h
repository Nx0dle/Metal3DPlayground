/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Header containing types and enum constants shared between Metal shaders
 and Objective-C source.
*/

#ifndef AAPLShaderTypes_h
#define AAPLShaderTypes_h

#include <simd/simd.h>

typedef enum AAPLVertexInputIndex
{
    VertexInputIndexVertices    = 0,
    VertexInputIndexAspectRatio = 1,
    kawaseIterator = 2,
} VertexInputIndex;

typedef enum TextureInputIndex
{
    AAPLTextureInputIndexColor = 0,
} TextureInputIndex;

typedef struct
{
    vector_float2 position;
    vector_float4 color;
} SimpleVertex;

typedef struct
{
    vector_float2 position;
    vector_float2 texcoord;
} TextureVertex;

typedef struct
{
    vector_float4 position;
    vector_float4 color;
} SimpleVertex3D;

typedef struct
{
    vector_float4 position;
    vector_float2 texcoord;
} TextureVertex3D;

typedef struct
{
    matrix_float4x4 modelMatrix;
    matrix_float4x4 viewMatrix;
    matrix_float4x4 perspectiveMatrix;
} TransformationData;

typedef struct
{
    matrix_float4x4 projectionMatrix;
    matrix_float4x4 modelViewMatrix;
} Uniforms;

#endif /* AAPLShaderTypes_h */
