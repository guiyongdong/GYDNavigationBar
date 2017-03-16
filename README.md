# GYDNavigationBar
一款解决导航栏渐变的组件


### 描述

开发中我们经常会遇到导航栏透明度的问题，有时候非常难解决。此组件就是为解决上述问题所产生的。用起来很方便。



### 效果

<div align=center>
<img src="https://github.com/guiyongdong/Resource/blob/master/hexoImage/GYDNavigationBar.gif?raw=true"/>
</div>


### 使用方法

在你需要改变导航栏透明度的地方导入`UIViewController+GYDNav.h`

```objc
- (void)viewDidLoad {
    [super viewDidLoad];
    self.d_navBarAlpha = 0.5;
    [self.navigationController d_setNavigationBarAlpha:0.5];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    BTableViewController *vc = [[BTableViewController alloc] init];
    self.d_transitionEnable = YES;
    [self.navigationController d_pushViewController:vc fromAlpha:self.d_navBarAlpha toAlpha:0];
}
```

### API 

公开的API有：

```objc
@interface UIViewController (GYDNav)

/**
 当前navigationBar的透明度 默认1.0
 */
@property (nonatomic, assign) CGFloat d_navBarAlpha;

/**
 是否启用转场动画 默认YES  此转场动画代理只在动画即将开始时启用在结束时废弃
 */
@property (nonatomic, assign) BOOL d_transitionEnable;


/**
 是否启用全屏侧滑返回 默认YES
 */
@property (nonatomic, assign) BOOL d_fullScreenEnable;



@end


@interface UINavigationController (GYDNav)


/**
 设置导航栏的alpha  非动画型
 
 @param alpha 透明度
 */
- (void)d_setNavigationBarAlpha:(CGFloat)alpha;


/**
 设置导航栏线是否隐藏

 @param hidden 是否隐藏
 */
- (void)d_setShaowViewHidden:(BOOL)hidden;


/**
 在push下一个控制器之前 添加转场动画代理 动态地修改导航栏的alpha 防止突兀

 @param viewController toViewController
 @param fromAlpha 上一个控制器所持有的Alpha
 @param toAlpha 下一个控制器所持有的Alpha
 */
- (void)d_pushViewController:(UIViewController *)viewController fromAlpha:(CGFloat)fromAlpha toAlpha:(CGFloat)toAlpha;


@end

```

当然 你也可以直接使用系统的push和pop，如果你想自定义转场动画，需要设置`d_transitionEnable`为NO，此属性表示是否启用转场动画，默认YES。

### 注意

如果你不设置当前控制器的`d_navBarAlpha`透明度，默认为1.0

1.1版本以后添加全屏侧滑返回手势，返回手势依旧使用系统自带的手势。在你不需要全屏侧滑返回的时候，你需要这样做
```objc
- (void)viewDidLoad {
    [super viewDidLoad];
    //取消全屏侧滑返回
    self.d_fullScreenEnable = NO;
}
```


如果你发现有什么BUG，欢迎随时Issues



