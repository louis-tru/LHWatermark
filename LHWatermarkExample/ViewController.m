//
//  ViewController.m
//  LHWatermarkExample
//
//  Created by Leon on 2017/6/29.
//  Copyright © 2017年 LeonHwa. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+Helper.h"
#import "LHWatermarkProcessor.h"
#import "NextViewController.h"
#import "LHConfig.h"
#define ImageName @"yourName"
//#define ImageName @"lena"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView* topImgView;
@property (weak, nonatomic) IBOutlet UIImageView* bottomImgView;
@property (nonatomic, copy) NSString *imagePath;
@property (nonatomic) LHConfig *cfg;
@end

@implementation ViewController

- (void) viewDidLoad {
	[super viewDidLoad];
	
	self.cfg = [[LHConfig alloc] initWithAlpha: 3
																				seed: 1024
																				font: [UIFont systemFontOfSize:100]];
	
	[self.topImgView addGestureRecognizer: [[UITapGestureRecognizer alloc]
																					initWithTarget:self
																					action:@selector(presenting:)]];
	[self.bottomImgView addGestureRecognizer: [[UITapGestureRecognizer alloc]
																						 initWithTarget:self
																						 action:@selector(presenting:)]];

	UIImage* image = [UIImage imageNamed:ImageName];
	UIImage* qr = [UIImage imageNamed:@"qr"];

	LHWatermarkProcessor* processor = [[LHWatermarkProcessor alloc] initWithImage:image
																																				 config:_cfg];
	// [processor addMarkText:@"楚学文"
	[processor addMarkImage:qr
									 result:^(UIImage *watermarkImage) {
		_topImgView.image = watermarkImage;
	
		NSString *save = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];

		_imagePath = [NSString stringWithFormat:@"%@/code_%@", save, ImageName];
		
		[UIImagePNGRepresentation(watermarkImage) writeToFile:_imagePath atomically:YES];
		[UIImagePNGRepresentation(watermarkImage) writeToFile:@"/Users/louis/Downloads/test.png" atomically:YES];

		NSLog(@"%@", _imagePath);
	}];
}

- (IBAction) restore:(id) sender {
	
	UIImage* image = [UIImage imageNamed:ImageName];
	UIImage* watermarkImage = [UIImage imageNamed:@"test"];
//	UIImage* watermarkImage = [UIImage imageWithContentsOfFile:_imagePath];
	
	// 传入元图像和加了水印的图像 异步线程
	[LHWatermarkProcessor restoreImageWithOriginImage:watermarkImage
																		 watermarkImage:image
																						 config:_cfg
																						 result:^(UIImage *markImage) {
		// block中返回水印的图片 主线程
		 self.bottomImgView.image = markImage;
	}];
}

- (void) presenting:(UITapGestureRecognizer*) tap {
	UIImageView *imgView = (UIImageView *)tap.view;
	NextViewController *nVC = [NextViewController new];
	nVC.image = imgView.image;
	nVC.imgColor = imgView.backgroundColor;
	[self presentViewController:nVC animated:YES completion:nil];
}

@end
