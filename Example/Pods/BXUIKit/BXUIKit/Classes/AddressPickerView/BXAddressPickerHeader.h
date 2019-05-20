//
//  BXAddressPickerHeader.h
//  BXUIKit
//
//  Created by Hmily on 2019/3/25.
//  Copyright © 2019 Document. All rights reserved.
//


#ifndef BXAddressPickerHeader_h
#define BXAddressPickerHeader_h


/////weakSelf
//#define CZHWeakSelf(type)  __weak typeof(type) weak##type = type;
//#define CZHStrongSelf(type)  __strong typeof(type) type = weak##type;
//
/**屏幕宽度*/
#define BXDP_SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
/**屏幕高度*/
#define BXDP_SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

/**宽度比例*/
#define BXDP_SCALE_WIGTH(__VA_ARGS__)  ([UIScreen mainScreen].bounds.size.width/375)*(__VA_ARGS__)

/**高度比例*/
#define BXDP_SCALE_HEIGHT(__VA_ARGS__)  ([UIScreen mainScreen].bounds.size.height/667)*(__VA_ARGS__)

///**颜色*/
#define BXDP_COLOR(__rgbValue__) [UIColor colorWithRed:((float)((__rgbValue__ & 0xFF0000) >> 16))/255.0 green:((float)((__rgbValue__ & 0xFF00) >> 8))/255.0 blue:((float)(__rgbValue__ & 0xFF))/255.0 alpha:1.0]
//
#define BXDP_RGB_COLOR(__rgbValue__, __a__) [UIColor colorWithRed:((float)((__rgbValue__ & 0xFF0000) >> 16))/255.0 green:((float)((__rgbValue__ & 0xFF00) >> 8))/255.0 blue:((float)(__rgbValue__ & 0xFF))/255.0 alpha:__a__]


#endif /* BXAddressPickerHeader_h */
