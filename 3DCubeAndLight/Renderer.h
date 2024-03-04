//
//  Renderer.h
//  3DCubeAndLight
//
//  Created by MotionVFX on 01/03/2024.
//

#import <MetalKit/MetalKit.h>

// Our platform independent renderer class.   Implements the MTKViewDelegate protocol which
//   allows it to accept per-frame update and drawable resize callbacks.
@interface Renderer : NSObject <MTKViewDelegate>

-(nonnull instancetype)initWithMetalKitView:(nonnull MTKView *)view;

- (void)setRotationX:(float)posX Y:(float)posY;
@end

