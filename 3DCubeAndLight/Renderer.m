@import MetalKit;

#import "Renderer.h"
#import "ShaderTypes.h"

#pragma mark-
#pragma mark Define vertices

// Global coordinates for full screen render
static const TextureVertex quadVertices[] =
{
    // Positions     , Texture coordinates
    { {  1.0,  -1.0 },  { 1.0, 1.0 } },
    { { -1.0,  -1.0 },  { 0.0, 1.0 } },
    { { -1.0,   1.0 },  { 0.0, 0.0 } },

    { {  1.0,  -1.0 },  { 1.0, 1.0 } },
    { { -1.0,   1.0 },  { 0.0, 0.0 } },
    { {  1.0,   1.0 },  { 1.0, 0.0 } },
};

static const TextureVertex3D cubeVertices[] = {
    // Position             // Texcoord  // Normal  // Tangent  // Bitangent
    // Front face
    {{-0.5, -0.5,  0.5, 1.0}, {0.0, 1.0}, {0, 0, 1}, {1, 0, 0}, {0, 1, 0}},
    {{ 0.5, -0.5,  0.5, 1.0}, {1.0, 1.0}, {0, 0, 1}, {1, 0, 0}, {0, 1, 0}},
    {{ 0.5,  0.5,  0.5, 1.0}, {1.0, 0.0}, {0, 0, 1}, {1, 0, 0}, {0, 1, 0}},
    {{ 0.5,  0.5,  0.5, 1.0}, {1.0, 0.0}, {0, 0, 1}, {1, 0, 0}, {0, 1, 0}},
    {{-0.5,  0.5,  0.5, 1.0}, {0.0, 0.0}, {0, 0, 1}, {1, 0, 0}, {0, 1, 0}},
    {{-0.5, -0.5,  0.5, 1.0}, {0.0, 1.0}, {0, 0, 1}, {1, 0, 0}, {0, 1, 0}},

    // Back face
    {{ 0.5, -0.5, -0.5, 1.0}, {0.0, 1.0}, {0, 0, -1}, {-1, 0, 0}, {0, 1, 0}},
    {{-0.5, -0.5, -0.5, 1.0}, {1.0, 1.0}, {0, 0, -1}, {-1, 0, 0}, {0, 1, 0}},
    {{-0.5,  0.5, -0.5, 1.0}, {1.0, 0.0}, {0, 0, -1}, {-1, 0, 0}, {0, 1, 0}},
    {{-0.5,  0.5, -0.5, 1.0}, {1.0, 0.0}, {0, 0, -1}, {-1, 0, 0}, {0, 1, 0}},
    {{ 0.5,  0.5, -0.5, 1.0}, {0.0, 0.0}, {0, 0, -1}, {-1, 0, 0}, {0, 1, 0}},
    {{ 0.5, -0.5, -0.5, 1.0}, {0.0, 1.0}, {0, 0, -1}, {-1, 0, 0}, {0, 1, 0}},

    // Top face
    {{-0.5,  0.5,  0.5, 1.0}, {0.0, 1.0}, {0, 1, 0}, {1, 0, 0}, {0, 0, -1}},
    {{ 0.5,  0.5,  0.5, 1.0}, {1.0, 1.0}, {0, 1, 0}, {1, 0, 0}, {0, 0, -1}},
    {{ 0.5,  0.5, -0.5, 1.0}, {1.0, 0.0}, {0, 1, 0}, {1, 0, 0}, {0, 0, -1}},
    {{ 0.5,  0.5, -0.5, 1.0}, {1.0, 0.0}, {0, 1, 0}, {1, 0, 0}, {0, 0, -1}},
    {{-0.5,  0.5, -0.5, 1.0}, {0.0, 0.0}, {0, 1, 0}, {1, 0, 0}, {0, 0, -1}},
    {{-0.5,  0.5,  0.5, 1.0}, {0.0, 1.0}, {0, 1, 0}, {1, 0, 0}, {0, 0, -1}},

    // Bottom face
    {{-0.5, -0.5, -0.5, 1.0}, {0.0, 1.0}, {0, -1, 0}, {1, 0, 0}, {0, 0, 1}},
    {{ 0.5, -0.5, -0.5, 1.0}, {1.0, 1.0}, {0, -1, 0}, {1, 0, 0}, {0, 0, 1}},
    {{ 0.5, -0.5,  0.5, 1.0}, {1.0, 0.0}, {0, -1, 0}, {1, 0, 0}, {0, 0, 1}},
    {{ 0.5, -0.5,  0.5, 1.0}, {1.0, 0.0}, {0, -1, 0}, {1, 0, 0}, {0, 0, 1}},
    {{-0.5, -0.5,  0.5, 1.0}, {0.0, 0.0}, {0, -1, 0}, {1, 0, 0}, {0, 0, 1}},
    {{-0.5, -0.5, -0.5, 1.0}, {0.0, 1.0}, {0, -1, 0}, {1, 0, 0}, {0, 0, 1}},

    // Left face
    {{-0.5, -0.5, -0.5, 1.0}, {0.0, 1.0}, {-1, 0, 0}, {0, 0, 1}, {0, 1, 0}},
    {{-0.5, -0.5,  0.5, 1.0}, {1.0, 1.0}, {-1, 0, 0}, {0, 0, 1}, {0, 1, 0}},
    {{-0.5,  0.5,  0.5, 1.0}, {1.0, 0.0}, {-1, 0, 0}, {0, 0, 1}, {0, 1, 0}},
    {{-0.5,  0.5,  0.5, 1.0}, {1.0, 0.0}, {-1, 0, 0}, {0, 0, 1}, {0, 1, 0}},
    {{-0.5,  0.5, -0.5, 1.0}, {0.0, 0.0}, {-1, 0, 0}, {0, 0, 1}, {0, 1, 0}},
    {{-0.5, -0.5, -0.5, 1.0}, {0.0, 1.0}, {-1, 0, 0}, {0, 0, 1}, {0, 1, 0}},

    // Right face
    {{ 0.5, -0.5,  0.5, 1.0}, {0.0, 1.0}, {1, 0, 0}, {0, 0, -1}, {0, 1, 0}},
    {{ 0.5, -0.5, -0.5, 1.0}, {1.0, 1.0}, {1, 0, 0}, {0, 0, -1}, {0, 1, 0}},
    {{ 0.5,  0.5, -0.5, 1.0}, {1.0, 0.0}, {1, 0, 0}, {0, 0, -1}, {0, 1, 0}},
    {{ 0.5,  0.5, -0.5, 1.0}, {1.0, 0.0}, {1, 0, 0}, {0, 0, -1}, {0, 1, 0}},
    {{ 0.5,  0.5,  0.5, 1.0}, {0.0, 0.0}, {1, 0, 0}, {0, 0, -1}, {0, 1, 0}},
    {{ 0.5, -0.5,  0.5, 1.0}, {0.0, 1.0}, {1, 0, 0}, {0, 0, -1}, {0, 1, 0}},
};

#pragma mark-
#pragma mark Define objects

// The main class performing the rendering.
@implementation Renderer
{
    // Texture to render to and then sample from.
    id<MTLTexture> _renderTargetTexture;
    id<MTLTexture> _textureFromFile;
    id<MTLTexture> _textureNormalFromFile;

    // Render pass descriptors to draw to the texture
    MTLRenderPassDescriptor* _renderToTextureRenderPassDescriptor_FBO;
    MTLRenderPassDescriptor* _renderToTextureRenderPassDescriptor_secondPass;
    
    // A pipeline object to render to the offscreen texture.
    id<MTLRenderPipelineState> _renderToTextureRenderPipeline;
    id<MTLRenderPipelineState> _renderToTextureSimpleRenderPipeline;

    // A pipeline object to render to the screen / save tmp texture.
    id<MTLRenderPipelineState> _drawableRenderPipeline;

    // Ratio of width to height to scale positions in the vertex shader.
    float _aspectRatio;

    id<MTLDevice> _device;

    id<MTLCommandQueue> _commandQueue;
    
    id<MTLBuffer> cubeVertexBuffer;
    
    id<MTLBuffer> mvpUniform;
    
    float _rotation;
    
    matrix_float4x4 _projectionMatrix;
    matrix_float4x4 modelViewMatrix;
    
    matrix_float4x4 modelMatrix;
    matrix_float4x4 viewMatrix;
    
    float _rotationX;
    float _rotationY;
    
    float scaleZ;
    
    float rotationLight;
}

#pragma mark -
#pragma mark Init objects

- (nonnull instancetype)initWithMetalKitView:(nonnull MTKView *)mtkView
{
    self = [super init];
    if(self)
    {
        NSError *error;

        _device = mtkView.device;

        mtkView.clearColor = MTLClearColorMake(1.0, 1.0, 1.0, 1.0);
        
        cubeVertexBuffer = [_device newBufferWithLength:sizeof(cubeVertexBuffer) options:MTLResourceCPUCacheModeDefaultCache];
        
        rotationLight = 0.0;
        
#pragma mark -
#pragma mark Load texture from assets
        
        {
            MTKTextureLoader* textureLoader = [[MTKTextureLoader alloc] initWithDevice:_device];

            NSDictionary *textureLoaderOptions =
            @{
              MTKTextureLoaderOptionSRGB               : @(false),
              MTKTextureLoaderOptionGenerateMipmaps    : @(false),
              MTKTextureLoaderOptionTextureUsage       : @(MTLTextureUsageShaderRead),
              MTKTextureLoaderOptionTextureStorageMode : @(MTLStorageModePrivate)
              };

            _textureFromFile = [textureLoader newTextureWithName:@"ColorMap"
                                              scaleFactor:1.0
                                                   bundle:nil
                                                  options:textureLoaderOptions
                                                    error:&error];

            if(!_textureFromFile || error)
            {
                NSLog(@"Error creating texture %@", error.localizedDescription);
            }
        }
        
#pragma mark -
#pragma mark Settings and pipelines

        _commandQueue = [_device newCommandQueue];

        // Set up a texture for rendering to and sampling from
        MTLTextureDescriptor *texDescriptor = [MTLTextureDescriptor new];
        texDescriptor.textureType = MTLTextureType2D;
        texDescriptor.width = 512;
        texDescriptor.height = 512;
        texDescriptor.pixelFormat = MTLPixelFormatRGBA8Unorm;
        texDescriptor.usage = MTLTextureUsageRenderTarget |
                              MTLTextureUsageShaderRead |
                              MTLTextureUsageShaderWrite;

        // Create textures from texture descriptor
        _renderTargetTexture = [_device newTextureWithDescriptor:texDescriptor];
        
        // Set up FBO pass
        _renderToTextureRenderPassDescriptor_FBO = [MTLRenderPassDescriptor new];
        _renderToTextureRenderPassDescriptor_FBO.colorAttachments[0].texture = _renderTargetTexture;
        _renderToTextureRenderPassDescriptor_FBO.colorAttachments[0].loadAction = MTLLoadActionClear;
        _renderToTextureRenderPassDescriptor_FBO.colorAttachments[0].clearColor = MTLClearColorMake(0, 0, 0, 0);
        _renderToTextureRenderPassDescriptor_FBO.colorAttachments[0].storeAction = MTLStoreActionStore;
        
        // Set up next passes
        _renderToTextureRenderPassDescriptor_secondPass = [MTLRenderPassDescriptor new];
        _renderToTextureRenderPassDescriptor_secondPass.colorAttachments[0].texture = _renderTargetTexture;
        _renderToTextureRenderPassDescriptor_secondPass.colorAttachments[0].loadAction = MTLLoadActionClear;
        _renderToTextureRenderPassDescriptor_secondPass.colorAttachments[0].storeAction = MTLStoreActionStore;
        

        id<MTLLibrary> defaultLibrary = [_device newDefaultLibrary];

        MTLRenderPipelineDescriptor *pipelineStateDescriptor = [[MTLRenderPipelineDescriptor alloc] init];
        
        // Pipeline for FBO pass (texture load pass)
        pipelineStateDescriptor.label = @"Offscreen Render texture render pipeline";
        pipelineStateDescriptor.rasterSampleCount = 1;
        pipelineStateDescriptor.vertexFunction =  [defaultLibrary newFunctionWithName:@"textureVertexShader"];
        pipelineStateDescriptor.fragmentFunction =  [defaultLibrary newFunctionWithName:@"textureRender"];
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = _renderTargetTexture.pixelFormat;
        _renderToTextureRenderPipeline = [_device newRenderPipelineStateWithDescriptor:pipelineStateDescriptor error:&error];
        NSAssert(_renderToTextureRenderPipeline, @"Failed to create pipeline state to render to screen: %@", error);
        
        pipelineStateDescriptor.label = @"Offscreen Render texture render pipeline";
        pipelineStateDescriptor.rasterSampleCount = 1;
        pipelineStateDescriptor.vertexFunction =  [defaultLibrary newFunctionWithName:@"textureVertexShader3D"];
        pipelineStateDescriptor.fragmentFunction =  [defaultLibrary newFunctionWithName:@"phongLight"];
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = _renderTargetTexture.pixelFormat;
        _renderToTextureSimpleRenderPipeline = [_device newRenderPipelineStateWithDescriptor:pipelineStateDescriptor error:&error];
        NSAssert(_renderToTextureSimpleRenderPipeline, @"Failed to create pipeline state to render to screen: %@", error);
        
        // Pipeline for texture render to view
        pipelineStateDescriptor.label = @"Drawable Render Pipeline";
        pipelineStateDescriptor.rasterSampleCount = mtkView.sampleCount;
        pipelineStateDescriptor.vertexFunction =  [defaultLibrary newFunctionWithName:@"textureVertexShader"];
        pipelineStateDescriptor.fragmentFunction =  [defaultLibrary newFunctionWithName:@"textureRender"];
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = mtkView.colorPixelFormat;
        pipelineStateDescriptor.vertexBuffers[VertexInputIndexVertices].mutability = MTLMutabilityImmutable;
        _drawableRenderPipeline = [_device newRenderPipelineStateWithDescriptor:pipelineStateDescriptor error:&error];
        NSAssert(_drawableRenderPipeline, @"Failed to create pipeline state to render to screen: %@", error);
    }
    return self;
}

#pragma mark -
#pragma mark - Render to generate textures

// Handles view orientation and size changes.
- (void)mtkView:(nonnull MTKView *)view drawableSizeWillChange:(CGSize)size
{
    _aspectRatio = size.width / (float)size.height;
    _projectionMatrix = matrix_perspective_right_hand(45.0f * (M_PI / 180.0f), _aspectRatio, 0.1f, 100.0f);
}

// Set up projection, translation and rotation matrices
- (void)projection_3D
{
    
    vector_float3 rotationAxisX = {1, 0, 0};
    matrix_float4x4 modelMatrixX = matrix4x4_rotation(_rotationX, rotationAxisX);

    vector_float3 rotationAxisY = {0, 1, 0};
    matrix_float4x4 modelMatrixY = matrix4x4_rotation(_rotationY, rotationAxisY);
    
    modelMatrix = matrix_multiply(modelMatrixX, modelMatrixY);
    
    viewMatrix = matrix4x4_translation(0.0, 0.0, -3.0 + scaleZ);

    modelViewMatrix = matrix_multiply(viewMatrix, modelMatrix);

}

- (void)setRotationX:(float)posX Y:(float)posY
{
    float mult = 0.01;
    _rotationX += posY * mult;
    _rotationY += posX * mult;
}

- (void) setTransformZWithScrollZ:(float)posY
{
    float mult = 0.1;
    scaleZ += posY * mult;
}

// Handles view rendering for a new frame.
- (void)drawInMTKView:(nonnull MTKView *)view
{

    id<MTLCommandBuffer> commandBuffer = [_commandQueue commandBuffer];
    commandBuffer.label = @"Command Buffer";
    
    {
        id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:_renderToTextureRenderPassDescriptor_secondPass];
        
        [self projection_3D];
        
        renderEncoder.label = @"Offscreen render shader pass";
        [renderEncoder setRenderPipelineState:_renderToTextureSimpleRenderPipeline];
        [renderEncoder setCullMode:MTLCullModeFront];
        [renderEncoder setFragmentTexture:_textureFromFile atIndex:0];
        
        [renderEncoder setVertexBytes:&cubeVertices
                               length:sizeof(cubeVertices)
                              atIndex:VertexInputIndexVertices];
        
        [renderEncoder setVertexBytes:&_projectionMatrix
                               length:sizeof(_projectionMatrix)
                              atIndex:5];
        
        [renderEncoder setVertexBytes:&modelViewMatrix
                               length:sizeof(modelViewMatrix)
                              atIndex:6];
        
        [renderEncoder setVertexBytes:&modelMatrix
                               length:sizeof(modelMatrix)
                              atIndex:7];
        
        [renderEncoder setFragmentBytes:&rotationLight
                                 length:sizeof(rotationLight)
                                atIndex:8];
        
        rotationLight += 0.0;
        
        [renderEncoder drawPrimitives:MTLPrimitiveTypeTriangle
                          vertexStart:0
                          vertexCount:36];
        
        [renderEncoder endEncoding];
    }
        
        
#pragma mark -
#pragma mark Draw texture to view / store tmp texture
        
        MTLRenderPassDescriptor *drawableRenderPassDescriptor = view.currentRenderPassDescriptor;
        if(drawableRenderPassDescriptor != nil)
        {
            id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:drawableRenderPassDescriptor];
            renderEncoder.label = @"Drawable Render Pass shader final";
            
            [renderEncoder setRenderPipelineState:_drawableRenderPipeline];
            
            
            [renderEncoder setVertexBytes:&quadVertices
                                   length:sizeof(quadVertices)
                                  atIndex:VertexInputIndexVertices];
            
            
            // Set the offscreen texture as the source texture.
            [renderEncoder setFragmentTexture:_renderTargetTexture atIndex:0];
            
            // Draw quad with rendered texture.
            [renderEncoder drawPrimitives:MTLPrimitiveTypeTriangle
                              vertexStart:0
                              vertexCount:6];
            
            [renderEncoder endEncoding];
    }

#pragma mark -
#pragma mark Present texture to view
    
    [commandBuffer presentDrawable:view.currentDrawable];
    [commandBuffer commit];
}

#pragma mark Matrix Math Utilities

matrix_float4x4 matrix4x4_translation(float tx, float ty, float tz)
{
    return (matrix_float4x4) {{
        { 1,   0,  0,  0 },
        { 0,   1,  0,  0 },
        { 0,   0,  1,  0 },
        { tx, ty, tz,  1 }
    }};
}

static matrix_float4x4 matrix4x4_rotation(float radians, vector_float3 axis)
{
    axis = vector_normalize(axis);
    float ct = cosf(radians);
    float st = sinf(radians);
    float ci = 1 - ct;
    float x = axis.x, y = axis.y, z = axis.z;

    return (matrix_float4x4) {{
        { ct + x * x * ci,     y * x * ci + z * st, z * x * ci - y * st, 0},
        { x * y * ci - z * st,     ct + y * y * ci, z * y * ci + x * st, 0},
        { x * z * ci + y * st, y * z * ci - x * st,     ct + z * z * ci, 0},
        {                   0,                   0,                   0, 1}
    }};
}

matrix_float4x4 matrix_perspective_right_hand(float fovyRadians, float aspect, float nearZ, float farZ)
{
    float ys = 1 / tanf(fovyRadians * 0.5);
    float xs = ys / aspect;
    float zs = farZ / (nearZ - farZ);

    return (matrix_float4x4) {{
        { xs,   0,          0,  0 },
        {  0,  ys,          0,  0 },
        {  0,   0,         zs, -1 },
        {  0,   0, nearZ * zs,  0 }
    }};
}

@end
