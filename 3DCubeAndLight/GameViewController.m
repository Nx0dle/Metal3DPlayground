//
//  GameViewController.m
//  3DCubeAndLight
//
//  Created by MotionVFX on 01/03/2024.
//

#import "GameViewController.h"
#import "Renderer.h"

@implementation GameViewController
{
    MTKView *_view;

    Renderer *_renderer;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _view = (MTKView *)self.view;

    _view.device = MTLCreateSystemDefaultDevice();

    if(!_view.device)
    {
        NSLog(@"Metal is not supported on this device");
        self.view = [[NSView alloc] initWithFrame:self.view.frame];
        return;
    }

    _renderer = [[Renderer alloc] initWithMetalKitView:_view];

    [_renderer mtkView:_view drawableSizeWillChange:_view.drawableSize];

    _view.delegate = _renderer;
}

- (void)mouseDragged:(NSEvent *)event
{
    printf("%s: %f %f\n", __func__, [event deltaX], [event deltaY]);
    [_renderer setRotationX:[event deltaX] Y:[event deltaY]];
    [_view setNeedsDisplay:YES];
}

@end
