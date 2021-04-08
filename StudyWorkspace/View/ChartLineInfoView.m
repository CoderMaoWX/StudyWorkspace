//
//  ChartLineInfoView.m
//  YDGJ
//
//  Created by mao wangxin on 16/9/20.
//  Copyright © 2016年 Galaxy360. All rights reserved.
//

#import "ChartLineInfoView.h"
#import <objc/runtime.h>
#import "Masonry.h"
#import "UIView+WXExtension.h"
#import "WXPublicHeader.h"

#define PageSize                12 //每页12个数据点
#define RowHieght               20 //每行高度
#define LeftTextWidth           33 //左边文字宽度
#define LeftTextHeight          RowHieght //左边文字高度
#define SpaceWidth              15 //左右两边间隙
#define RedRoundSize            4  //小圆点大小

static char const * const kScaleValueLabelKey = "kScaleValueLabelKey";
static char const * const kDateTimeLabelKey = "kDateTimeLabelKey";

@interface ChartLineInfoView ()<UIScrollViewDelegate>
{
    //默认一页
    NSInteger pageCount;
    UIButton *firstBtn;
}
/** 线条颜色 */
@property (nonatomic, strong) UIColor        *lineColor;
/** 左边刻度 */
@property (nonatomic, strong) NSArray        *leftScaleValueArr;
/** 底部刻度 */
@property (nonatomic, strong) NSArray        *bottomScaleValueArr;
/** 统计数值 */
@property (nonatomic, strong) NSArray        *lineDataArr;

/** 滚动视图*/
@property (nonatomic,strong ) UIScrollView   *chartScrollView;
/** 所有的红色小圆点位置数组 */
@property (nonatomic,strong ) NSMutableArray *allBtnPointArr;
/** 所有的红色小圆点按钮数组 */
@property (nonatomic,strong ) NSMutableArray *allBtnArr;
/** 弹框背景视图 */
@property (nonatomic,strong ) UIView         *scaleBgView;
/** 弹框线条 */
@property (nonatomic,strong ) UILabel        *lineLabel;
/** 弹框提示刻度 */
@property (nonatomic,strong ) UILabel        *scaleLabel;
/** 弹框提示时间 */
@property (nonatomic,strong ) UILabel        *dateTimeLabel;
@end

@implementation ChartLineInfoView

@synthesize lineColor = _lineColor;


- (instancetype)initWithFrame:(CGRect)frame lineColor:(UIColor *)lineColor leftScaleValueArr:(NSArray *)leftScaleValueArr bottomScaleValueArr:(NSArray *)bottomScaleValueArr lineDataArr:(NSArray *)lineDataArr
{
    if (self = [super initWithFrame:frame]) {
        pageCount = 1;//默认第一页
        self.allBtnPointArr = [NSMutableArray array];
        self.allBtnArr = [NSMutableArray array];
        self.lineColor = lineColor;
        self.leftScaleValueArr = leftScaleValueArr;
        self.bottomScaleValueArr = bottomScaleValueArr;
        self.lineDataArr = lineDataArr;
        
        //添加绘图
        [self addDetailViews];
    }
    return self;
}

/**
 *  线条颜色
 */
- (void)setLineColor:(UIColor *)lineColor
{
    _lineColor = lineColor;
}

- (UIColor *)lineColor{
    if (!_lineColor) {
        _lineColor = UIColorFromHex(0xff4f4f);
    }
    return _lineColor;
}

#pragma mark - 添加屏滚动视图

/**
 *  分屏滚动视图
 */
-(void)addDetailViews
{
    //每一页绘图宽度
    CGFloat pageWidth = kScreenWidth - (SpaceWidth*2+LeftTextWidth);
    CGFloat pageHeight = self.bounds.size.height;
    
    self.chartScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake((SpaceWidth+LeftTextWidth), 0, pageWidth, pageHeight)];
    self.chartScrollView.backgroundColor = [UIColor clearColor];
    self.chartScrollView.delegate = self;
    self.chartScrollView.bounces = NO;
    self.chartScrollView.scrollsToTop = NO;
    self.chartScrollView.showsHorizontalScrollIndicator = NO;
    [self.chartScrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchTipView:)]];
    [self addSubview:self.chartScrollView];
    
    //数据大于一页
    if (self.bottomScaleValueArr.count > PageSize) {
        
        //计算所有数据的页面
        pageCount = self.bottomScaleValueArr.count / PageSize;
        CGFloat odd = self.bottomScaleValueArr.count % PageSize;
        if (odd>0) {
            pageCount += 1;
        }
        self.chartScrollView.contentSize = CGSizeMake(self.chartScrollView.bounds.size.width*pageCount, self.chartScrollView.height);
        self.chartScrollView.pagingEnabled = NO;
        self.chartScrollView.scrollEnabled = NO;
    }
    
    //移动主视图
    UIView *pageBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, pageWidth*pageCount, pageHeight)];
    [self.chartScrollView addSubview:pageBgView];
    
    //添加左侧y轴额度
    [self addLeftViews];
    
    //添加x轴分栏线
    [self addLines1With:pageBgView];
    
    //添加底部月份
    [self addBottomViewsWith:pageBgView bottomScaleArr:self.bottomScaleValueArr];
    
    //根据数据绘图
    [self drawChartView:pageBgView drawDataArr:self.lineDataArr timeDataArr:self.bottomScaleValueArr];
}


#pragma mark - 添加y轴,x轴,月份

/**
 *  添加y轴刻度
 */
-(void)addLeftViews{
    if (!self.leftScaleValueArr) {
        self.leftScaleValueArr = @[@"1000",@"800",@"600",@"400",@"200",@"0"];
    }
    
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(SpaceWidth-8, -1*LeftTextHeight-LeftTextHeight/2, LeftTextWidth, LeftTextHeight)];
    leftLabel.backgroundColor = [UIColor clearColor];
    leftLabel.adjustsFontSizeToFitWidth = YES;
    leftLabel.textColor = UIColorFromHex(0x666666);
    leftLabel.textAlignment = NSTextAlignmentRight;
    leftLabel.font = [UIFont systemFontOfSize:9];
    leftLabel.text = @"单位:元";
    [self addSubview:leftLabel];
    
    for (int i = 0;i<self.leftScaleValueArr.count ;i++ ) {
        UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(SpaceWidth-8, i*LeftTextHeight-LeftTextHeight/2, LeftTextWidth, LeftTextHeight)];
        leftLabel.backgroundColor = [UIColor clearColor];
        leftLabel.adjustsFontSizeToFitWidth = YES;
        leftLabel.textColor = UIColorFromHex(0x666666);
        leftLabel.textAlignment = NSTextAlignmentRight;
        leftLabel.font = [UIFont systemFontOfSize:9];
        leftLabel.text = self.leftScaleValueArr[i];
        [self addSubview:leftLabel];
    }
}


/**
 *  添加x轴分栏线
 */
-(void)addLines1With:(UIView *)view
{
    //添加水平分割线
    for (int i = 0; i<self.leftScaleValueArr.count; i++ ) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, RowHieght*i, view.bounds.size.width, 1)];
        label.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
        [view addSubview:label];
    }
}


/**
 *  添加底部月份刻度
 */
-(void)addBottomViewsWith:(UIView *)UIView bottomScaleArr:(NSArray *)bottomScaleArr
{
    CGFloat monthY = (self.leftScaleValueArr.count-1) * RowHieght;
    CGFloat monthWidth = UIView.bounds.size.width/bottomScaleArr.count;
    
    for (int i = 0;i<bottomScaleArr.count; i++ ) {
//        if (i%2 == 0) { //间隔显示
            UILabel *bottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(i * monthWidth, monthY, monthWidth, 30)];
            bottomLabel.textColor = UIColorFromHex(0x666666);
            bottomLabel.font = [UIFont systemFontOfSize:9];
            bottomLabel.adjustsFontSizeToFitWidth = YES;
            bottomLabel.text = bottomScaleArr[i];
            bottomLabel.textAlignment = NSTextAlignmentCenter;
            bottomLabel.backgroundColor = [UIColor clearColor];
            [UIView addSubview:bottomLabel];
//        }
    }
}

#pragma mark - 添加小圆点, 连线

/**
 *  设置左边数据源
 */
-(void)drawChartView:(UIView *)pageBgView drawDataArr:(NSArray *)drawDataArr timeDataArr:(NSArray *)timeDataArr
{
    //添加点
    [self addDataPointWith:pageBgView drawDataArr:drawDataArr timeDataArr:timeDataArr];
    
    //添加连线
    [self addLeftBezierPoint:pageBgView];
}


/**
 *  添加每页每个数据的小圆点
 */
-(void)addDataPointWith:(UIView *)pageBgView drawDataArr:(NSArray *)drawDataArr timeDataArr:(NSArray *)timeDataArr
{
    CGFloat height = (self.leftScaleValueArr.count-1) * RowHieght;
    
    CGFloat btnXmargin = pageBgView.width/timeDataArr.count;
    
    //初始点
    NSMutableArray *arr = [NSMutableArray arrayWithArray:drawDataArr];
    
    for (int i = 0; i<arr.count; i++) {
        CGFloat btnY = height - ([arr[i] floatValue] / 1000)* height;
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(btnXmargin*i + btnXmargin/2, btnY, RedRoundSize, RedRoundSize)];
        btn.backgroundColor = self.lineColor;
        btn.layer.borderColor = self.lineColor.CGColor;
        btn.layer.borderWidth = 2;
        btn.layer.cornerRadius = btn.bounds.size.height/2;
        btn.layer.masksToBounds = YES;
        btn.tag = i;
        [btn addTarget:self action:@selector(clickTopBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        //记住刻度值,在弹框时显示
        objc_setAssociatedObject(btn, kScaleValueLabelKey, [NSString stringWithFormat:@"%.2f元",[arr[i] floatValue]], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        //记住时间值,在弹框时显示
        if (timeDataArr.count > i) {
            objc_setAssociatedObject(btn, kDateTimeLabelKey, [NSString stringWithFormat:@"%@",timeDataArr[i]], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        
        if (i == 0) {
            firstBtn = btn;
        }
        
        [self.allBtnArr addObject:btn];
        
        NSValue *point = [NSValue valueWithCGPoint:btn.center];
        [self.allBtnPointArr addObject:point];
    }
}


/**
 *  添加连线
 */
-(void)addLeftBezierPoint:(UIView *)pageBgView
{
    //取得起始点
    CGPoint p1 = [[self.allBtnPointArr objectAtIndex:0] CGPointValue];
    
    //直线的连线
    UIBezierPath *beizer = [UIBezierPath bezierPath];
    [beizer moveToPoint:p1];
    
    //遮罩层的形状
    UIBezierPath *bezier1 = [UIBezierPath bezierPath];
    bezier1.lineCapStyle = kCGLineCapRound;
    bezier1.lineJoinStyle = kCGLineJoinMiter;
    [bezier1 moveToPoint:p1];
    
    //最后一个坐标点
    CGPoint lastPoint;
    
    for (int i = 0;i<self.allBtnPointArr.count;i++ ) {
        if (i == 0)  continue;
        
        CGPoint point = [[self.allBtnPointArr objectAtIndex:i] CGPointValue];
        [beizer addLineToPoint:point];
        
        [bezier1 addLineToPoint:point];
        
        if (i == self.allBtnPointArr.count-1) {
            lastPoint = point;
        }
    }
    
    //获取最后一个点的X值
    CGFloat lastPointX = lastPoint.x;
    
    CGFloat bgViewHeight = (self.leftScaleValueArr.count-1) * RowHieght;
    
    //最后一个点对应的X轴的值
    CGPoint lastPointX1 = CGPointMake(lastPointX, bgViewHeight);
    
    [bezier1 addLineToPoint:lastPointX1];
    
    //回到原点
    [bezier1 addLineToPoint:CGPointMake(p1.x, bgViewHeight)];
    [bezier1 addLineToPoint:p1];
    
    //遮罩层
    CAShapeLayer *shadeLayer = [CAShapeLayer layer];
    shadeLayer.path = bezier1.CGPath;
    shadeLayer.fillColor = [UIColor greenColor].CGColor;
    
    //渐变图层
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(p1.x, 0, 0, pageBgView.bounds.size.height-RowHieght*2);
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    gradientLayer.cornerRadius = 5;
    gradientLayer.masksToBounds = YES;
    gradientLayer.colors = @[(__bridge id)UIColorFromHex_A(0xff4f4f, 0.4).CGColor,(__bridge id)UIColorFromHex_A(0xff4f4f, 0.0).CGColor];
    gradientLayer.locations = @[@(0.5f)];
    
    CALayer *baseLayer = [CALayer layer];
    [baseLayer addSublayer:gradientLayer];
    [baseLayer setMask:shadeLayer];
    
    [pageBgView.layer addSublayer:baseLayer];
    
    CABasicAnimation *anmi1 = [CABasicAnimation animation];
    anmi1.keyPath = @"bounds";
    anmi1.duration = 2.0f * pageCount;//绘制渐变图层持续的时间
    anmi1.toValue = [NSValue valueWithCGRect:CGRectMake(p1.x, 0, 2*lastPoint.x, pageBgView.bounds.size.height-RowHieght*2)];
    anmi1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anmi1.fillMode = kCAFillModeForwards;
    anmi1.autoreverses = NO;
    anmi1.removedOnCompletion = NO;
    
    [gradientLayer addAnimation:anmi1 forKey:@"bounds"];
    
    
    //*****************添加动画连线******************//
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = beizer.CGPath;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = self.lineColor.CGColor;
    shapeLayer.lineWidth = 1;
    [pageBgView.layer addSublayer:shapeLayer];
    
    
    CABasicAnimation *anmi = [CABasicAnimation animation];
    anmi.keyPath = @"strokeEnd";
    anmi.fromValue = [NSNumber numberWithFloat:0];
    anmi.toValue = [NSNumber numberWithFloat:1.0f];
    anmi.duration = 1.5f * pageCount;//连线持续的时间
    anmi.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anmi.autoreverses = NO;
    
    [shapeLayer addAnimation:anmi forKey:@"stroke"];
    
    
    //一边绘图一边滚动
    [UIView animateWithDuration:(2.0f * pageCount) animations:^{
        self.chartScrollView.contentOffset = CGPointMake((pageCount-1)*self.chartScrollView.width, 0);
    } completion:^(BOOL finished) {
        if (finished) {
            self.chartScrollView.scrollEnabled = YES;
        }
    }];

    for (UIButton *btn in self.allBtnArr) {
        [pageBgView addSubview:btn];
        
        //小红点下面添加一个大的点击按钮
        UIButton *bigTouchBtn = [[UIButton alloc] init];
        bigTouchBtn.size = CGSizeMake(30, 30);
        bigTouchBtn.center = btn.center;
        bigTouchBtn.backgroundColor = [UIColor clearColor];
        [bigTouchBtn addTarget:self action:@selector(clickTopBtn:) forControlEvents:UIControlEventTouchUpInside];
        [pageBgView addSubview:bigTouchBtn];
    }
}


#pragma mark - 点击小圆点事件

/**
 *  点击小圆点事件
 */
-(void)clickTopBtn:(UIButton *)sender
{
    if (sender != firstBtn) {
        firstBtn.layer.borderColor = self.lineColor.CGColor;
        firstBtn = sender;
    }
    
    if (self.scaleBgView) {
        [self.scaleBgView removeFromSuperview];
    }
    self.scaleBgView = [[UIView alloc]init];
    [sender.superview addSubview:self.scaleBgView];
    
    CGFloat height = self.chartScrollView.bounds.size.height;
    CGFloat lineHeight = 0.5*height;
    
    //判断提示弹框显示在上面还是下面
    if (sender.frame.origin.y<lineHeight) {
        
        if (sender.tag == 0 || sender.tag == 100) {
            
            [self.scaleBgView  mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(sender.mas_bottom).offset(0);
                make.left.equalTo(sender.mas_centerX).offset(0);
                make.height.mas_offset(lineHeight);
                make.width.mas_offset(80);
                
            }];
            
        } else if (sender.tag == 6 || sender.tag == 106){
            
            [self.scaleBgView  mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(sender.mas_bottom).offset(0);
                make.right.equalTo(sender.mas_centerX).offset(0);
                make.height.mas_offset(lineHeight);
                make.width.mas_offset(80);
            }];
            
        } else{
            [self.scaleBgView  mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(sender.mas_bottom).offset(0);
                make.centerX.equalTo(sender.mas_centerX).offset(0);
                make.height.mas_offset(lineHeight);
                make.width.mas_offset(80);
            }];
        }
        
        [self.scaleBgView addSubview:self.scaleLabel];
        [self.scaleBgView addSubview:self.dateTimeLabel];
        [self.scaleBgView addSubview:self.lineLabel];
        
        [self.dateTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.scaleBgView.mas_left).offset(0);
            make.bottom.equalTo(self.scaleBgView.mas_bottom).offset(0);
            make.right.equalTo(self.scaleBgView.mas_right).offset(0);
            make.height.mas_equalTo(20);
            
        }];
        
        [self.scaleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.scaleBgView.mas_left).offset(0);
            make.bottom.equalTo(self.dateTimeLabel.mas_top).offset(0);
            make.right.equalTo(self.scaleBgView.mas_right).offset(0);
            make.height.mas_equalTo(20);
        }];
        
        
        if (sender.tag == 0 || sender.tag == 100) {
            
            [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.scaleBgView.mas_left).offset(0);
                make.top.equalTo(self.scaleBgView.mas_top).offset(0);
                make.bottom.equalTo(self.scaleLabel.mas_top).offset(0);
                make.width.mas_equalTo(2);
            }];
            
            
        } else if (sender.tag == 6 || sender.tag == 106){
            
            [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.scaleBgView.mas_right).offset(0);
                make.top.equalTo(self.scaleBgView.mas_top).offset(0);
                make.bottom.equalTo(self.scaleLabel.mas_top).offset(0);
                make.width.mas_equalTo(2);
            }];
            
        } else{
            
            [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.scaleBgView.mas_centerX).offset(0);
                make.top.equalTo(self.scaleBgView.mas_top).offset(0);
                make.bottom.equalTo(self.scaleLabel.mas_top).offset(0);
                make.width.mas_equalTo(2);
                
            }];
        }
        
    } else {
        
        if (sender.tag == 0 || sender.tag == 100) {
            
            [self.scaleBgView  mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(sender.mas_top).offset(0);
                make.left.equalTo(sender.mas_centerX).offset(0);
                make.height.mas_offset(lineHeight);
                make.width.mas_offset(80);
            }];
            
        } else if (sender.tag == 6 || sender.tag == 106){
            
            [self.scaleBgView  mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(sender.mas_top).offset(0);
                make.right.equalTo(sender.mas_centerX).offset(0);
                make.height.mas_offset(lineHeight);
                make.width.mas_offset(80);
            }];
            
        } else{
            
            [self.scaleBgView  mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(sender.mas_top).offset(0);
                make.centerX.equalTo(sender.mas_centerX).offset(0);
                make.height.mas_offset(lineHeight);
                make.width.mas_offset(80);
            }];
            
        }
        
        [self.scaleBgView addSubview:self.lineLabel];
        [self.scaleBgView addSubview:self.dateTimeLabel];
        [self.scaleBgView addSubview:self.scaleLabel];
        
        [self.scaleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.scaleBgView.mas_left).offset(0);
            make.top.equalTo(self.scaleBgView.mas_top).offset(0);
            make.right.equalTo(self.scaleBgView.mas_right).offset(0);
            make.height.mas_equalTo(20);
        }];
        
        [self.dateTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.scaleBgView.mas_left).offset(0);
            make.top.equalTo(self.scaleLabel.mas_bottom).offset(0);
            make.right.equalTo(self.scaleBgView.mas_right).offset(0);
            make.height.mas_equalTo(20);
        }];
        
        if (sender.tag == 0 || sender.tag == 100) {
            
            [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.scaleBgView.mas_left).offset(0);
                make.top.equalTo(self.dateTimeLabel.mas_bottom).offset(0);
                make.bottom.equalTo(self.scaleBgView.mas_bottom).offset(0);
                make.width.mas_equalTo(2);
            }];
            
            
        } else if (sender.tag == 6 || sender.tag == 106){
            
            [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.scaleBgView.mas_right).offset(0);
                make.top.equalTo(self.dateTimeLabel.mas_bottom).offset(0);
                make.bottom.equalTo(self.scaleBgView.mas_bottom).offset(0);
                make.width.mas_equalTo(2);
            }];
            
            
        } else{
            
            [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.scaleBgView.mas_centerX).offset(0);
                make.top.equalTo(self.dateTimeLabel.mas_bottom).offset(0);
                make.bottom.equalTo(self.scaleBgView.mas_bottom).offset(0);
                make.width.mas_equalTo(2);
            }];
        }
    }
    
    //显示刻度值
    NSString *scaleString = objc_getAssociatedObject(sender, kScaleValueLabelKey);
    NSString *dateTimeString = objc_getAssociatedObject(sender, kDateTimeLabelKey);
    self.scaleLabel.text = scaleString;
    self.dateTimeLabel.text = dateTimeString;
    
    //延迟自动消失弹框提示
    [self.scaleBgView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:4];
}


#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //移除显示的弹框
    if (self.scaleBgView) {
        [self.scaleBgView removeFromSuperview];
    }
}

#pragma mark - 点击圆点显示UI

-(UILabel *)scaleLabel{
    if (!_scaleLabel) {
        _scaleLabel = [[UILabel alloc]init];
        _scaleLabel.textAlignment = 1;
        _scaleLabel.font = ZXFontSystem(14);
        _scaleLabel.backgroundColor = UIColorFromHex(0xfe9b00);
        _scaleLabel.textColor = WhiteColor;
        _scaleLabel.userInteractionEnabled = YES;
        [_scaleLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchTipView:)]];
    }
    return _scaleLabel;
}

-(UILabel *)dateTimeLabel{
    if (!_dateTimeLabel) {
        _dateTimeLabel = [[UILabel alloc]init];
        _dateTimeLabel.textAlignment = 1;
        _dateTimeLabel.userInteractionEnabled = YES;
        _dateTimeLabel.font = ZXFontSystem(11);
        _dateTimeLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _dateTimeLabel.textColor = Color_grayFont;
        [_dateTimeLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchTipView:)]];
    }
    return _dateTimeLabel;
}

-(UILabel *)lineLabel{
    if (!_lineLabel) {
        _lineLabel = [[UILabel alloc]init];
        _lineLabel.backgroundColor = UIColorFromHex(0xfe9b00);
        _lineLabel.userInteractionEnabled = YES;
        [_lineLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchTipView:)]];
    }
    return _lineLabel;
}

- (void)touchTipView:(UITapGestureRecognizer *)gesturer
{
    if (self.scaleBgView) {
        [self.scaleBgView removeFromSuperview];
    }
}

@end
