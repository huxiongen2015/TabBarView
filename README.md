# TabBarView
滚动tab，可一次铺满，可无限排。有需要时再加载下一个界面


 navTabBarController = [[JTNavTabBarView alloc] initWithFrame:CGRectMake(0, 0, kScreenWid, kScreenHight)];//摆放位置
    navTabBarController.contenButtonsWidthMax = NO;//是否一排放满
    navTabBarController.showTitlesArr = _allleagueArr;//要显示tabview名字的数组
    [navTabBarController addParentController];//加载手势
    [navTabBarController viewDid];//初始化
    [navTabBarController viewInit:153*kHy];//放的位置
    [navTabBarController itemDidSelectedWithIndex:_index];//直接跳到某一个
