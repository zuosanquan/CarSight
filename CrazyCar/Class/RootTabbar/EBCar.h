//
//  EBCar.h
//  CrazyCar
//
//  Created by Edward on 16/2/29.
//  Copyright © 2016年 Edward. All rights reserved.
//

#ifndef EBCar_h
#define EBCar_h
/**车系列表API*/
#define CARLIST @"http://cheyouapi.ycapp.yiche.com/car/getmasterbrandlist"
/**车标故事*/
#define LOGOSTORY @"http://api.ycapp.yiche.com/car/getmasterbrandstory?masterid=%ld"
/**车系详情API*/
#define CARDETAIL @"http://api.ycapp.yiche.com/car/getseriallist?masterid=%ld&allserial=false"
/**车系详情cell点击*/
#define BRAND @"http://api.ycapp.yiche.com/car/GetSerialInfo?csid=%ld&tracker=172_ycapp"
/**车款型cell*/
#define BRANDTYPE @"http://api.ycapp.yiche.com/car/GetCarListV61?csid=%ld&cityId=201"
/**头条*/
#define HOTNEW @"http://api.ycapp.yiche.com/appnews/toutiaov64/?page=%ld&length=20&platform=2"
/**头条较窄的cell点击*/
#define LittleCell @"http://api.ycapp.yiche.com/struct/GetStructNews?newsId=%ld&ts=%@&plat=2"
/**media的WebAPI*/
#define MediaCell @"http://api.ycapp.yiche.com/struct/GetStructMedia?newsId=%ld&ts=%@&plat=2"
/**新车API*/
#define NewCarCell @"http://api.ycapp.yiche.com/struct/GetStructYCNews?newsId=%ld&ts=%@&plat=2"
/**头条较宽的cell点击*/
#define WideCell @"http://api.ycapp.yiche.com/appnews/GetNewsAlbum?newsid=%ld"
/**视频页面API*/
#define VEDIOAPI @"http://api.ycapp.yiche.com/video/getvideolist?categoryid=-2&pagesize=6"
/**分类视频API*/
#define CATEGORYVEDIO @"http://api.ycapp.yiche.com/video/getvideolist?categoryid=%@&pageindex=%ld&pagesize=20"

/**新车API*/
#define NEWCAR @"http://api.ycapp.yiche.com/news/GetNewsList?categoryid=3&serialid=&pageindex=%ld&pagesize=20&appver=6.8"
/**图片API*/
#define PICTURE @"http://api.ycapp.yiche.com/AppNews/GetAppNewsAlbumList?page=%ld&length=20&platform=2"
/**说车API*/
#define CARSHOW @"http://api.ycapp.yiche.com/media/getnewslist?pageindex=%ld&pagesize=20"
/**今日油价*/
#define OILPRICE @"http://api.avatardata.cn/OilPrice/LookUp"
/**车内饰API*/
#define DETAILPICTURE @"http://api.ycapp.yiche.com/photo/getimagesingroups?serialid=%ld&carid=%@&colorid=&yearid=%@&pageindex=%ld&length=6"
/**搜索API*/
#define SearchAPI @"http://59.151.102.96/yicheappsug.php?k=%@"
#endif /* EBCar_h */
