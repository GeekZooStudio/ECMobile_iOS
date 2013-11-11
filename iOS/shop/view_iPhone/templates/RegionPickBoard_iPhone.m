/*
 *                                                                          
 *       _/_/_/                      _/        _/_/_/_/_/                     
 *    _/          _/_/      _/_/    _/  _/          _/      _/_/      _/_/    
 *   _/  _/_/  _/_/_/_/  _/_/_/_/  _/_/          _/      _/    _/  _/    _/   
 *  _/    _/  _/        _/        _/  _/      _/        _/    _/  _/    _/    
 *   _/_/_/    _/_/_/    _/_/_/  _/    _/  _/_/_/_/_/    _/_/      _/_/       
 *                                                                          
 *
 *  Copyright 2013-2014, Geek Zoo Studio
 *  http://www.ecmobile.cn/license.html
 *
 *  HQ China:
 *    2319 Est.Tower Van Palace 
 *    No.2 Guandongdian South Street 
 *    Beijing , China
 *
 *  U.S. Office:
 *    One Park Place, Elmira College, NY, 14901, USA
 *
 *  QQ Group:   329673575
 *  BBS:        bbs.ecmobile.cn
 *  Fax:        +86-10-6561-5510
 *  Mail:       info@geek-zoo.com
 */

#import "Bee.h"
#import "BaseBoard_iPhone.h"
#import "RegionPickBoard_iPhone.h"
#import "AppBoard_iPhone.h"

@implementation RegionPickBoard_iPhone

- (void)load
{
    [super load];
    
    self.style = UITableViewStylePlain;

    self.addressModel = [[[AddressModel alloc] init] autorelease];
    [self.addressModel addObserver:self];
    
    self.regionModel = [[[RegionModel alloc] init] autorelease];
    [self.regionModel addObserver:self];
}

- (void)unload
{
    [self.regionModel removeObserver:self];
    self.regionModel = nil;
}

#pragma mark -

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal_BeeUIBoard:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        self.titleString = __TEXT(@"select_address");
        [self showNavigationBarAnimated:NO];
        [self hideBarButton:BeeUINavigationBar.RIGHT];
        [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"nav-back.png"]];
    }
	else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
	}
	else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
	{
	}
    else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
    {
        
    }
    else if ( [signal is:BeeUIBoard.FREE_DATAS] )
    {
    }
    else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
    {
		[[AppBoard_iPhone sharedInstance] setTabbarHidden:YES];
        
        if ( [RegionModel sharedInstance].level == 0 )
        {
            [[RegionModel sharedInstance] clearTempRegion];
        }
        else if ( [RegionModel sharedInstance].level == 1 )
        {
            [RegionModel sharedInstance].tempAddress.province = nil;
            [RegionModel sharedInstance].tempAddress.province_name = nil;
            [RegionModel sharedInstance].tempAddress.city = nil;
            [RegionModel sharedInstance].tempAddress.city_name = nil;
            [RegionModel sharedInstance].tempAddress.district = nil;
            [RegionModel sharedInstance].tempAddress.district_name = nil;
        }
        else if ( [RegionModel sharedInstance].level == 2 )
        {
            [RegionModel sharedInstance].tempAddress.city = nil;
            [RegionModel sharedInstance].tempAddress.city_name = nil;
            [RegionModel sharedInstance].tempAddress.district = nil;
            [RegionModel sharedInstance].tempAddress.district_name = nil;
        }
        else if ( [RegionModel sharedInstance].level == 3 )
        {    
            [RegionModel sharedInstance].tempAddress.district = nil;
            [RegionModel sharedInstance].tempAddress.district_name = nil;
        }
    }
    else if ( [signal is:BeeUIBoard.DID_APPEAR] )
    {
        self.datas = [self datasFromRegions:self.regions];
        [self reloadData];
    }
    else if ( [signal is:BeeUIBoard.WILL_DISAPPEAR] )
    {
    }
}

- (NSMutableArray *)datasFromRegions:(NSMutableArray *)regions
{
    NSMutableArray * datas = [NSMutableArray array];

    for ( REGION * region in regions )
    {
        FormElement * element = [FormElement cell];
        element.title = region.name;
        element.data = region;
        
        [datas addObject:element];
    }
    
    return [NSMutableArray arrayWithObject:datas];
}

ON_SIGNAL2( BeeUINavigationBar, signal )
{
	[super handleUISignal:signal];

    if ( [signal is:BeeUINavigationBar.LEFT_TOUCHED] )
    {
        [RegionModel sharedInstance].level -= 1 ;
        [self.stack popBoardAnimated:YES];
    }
    else if ( [signal is:BeeUINavigationBar.RIGHT_TOUCHED] )
    {
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FormElement * elment = [[self.datas objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    REGION * region = elment.data;
    
    if ( region )
    {   
        if ( [RegionModel sharedInstance].level == 0 )
        {
            [RegionModel sharedInstance].tempAddress.country = region.id;
            [RegionModel sharedInstance].tempAddress.country_name = region.name;
        }
        else if ( [RegionModel sharedInstance].level == 1 )
        {
            [RegionModel sharedInstance].tempAddress.province = region.id;
            [RegionModel sharedInstance].tempAddress.province_name = region.name;
        }
        else if ( [RegionModel sharedInstance].level == 2 )
        {
            [RegionModel sharedInstance].tempAddress.city = region.id;
            [RegionModel sharedInstance].tempAddress.city_name = region.name;
        }
        else if ( [RegionModel sharedInstance].level == 3 )
        {
            [RegionModel sharedInstance].tempAddress.district = region.id;
            [RegionModel sharedInstance].tempAddress.district_name = region.name;
        }
        
        [RegionModel sharedInstance].level += 1 ;
        
        self.regionModel.parent_id = region.id;
        [self.regionModel fetchFromServer];
    }
}

- (void)handleMessage:(BeeMessage *)msg
{
    if ( msg.sending )
    {
        [self presentLoadingTips:__TEXT(@"tips_loading")];
    }
    else if ( msg.failed )
    {
        [self dismissTips];
        [ErrorMsg presentErrorMsg:msg inBoard:self];
        return;
    }
    else
    {
        [self dismissTips];
    }
    
    if ( [msg is:API.region] )
    {
        if ( msg.succeed )
        {
            if ( self.regionModel.regions.count )
            {
                RegionPickBoard_iPhone * board = [[[RegionPickBoard_iPhone alloc] init] autorelease];
                board.rootBoard = self.rootBoard;
                board.regions = self.regionModel.regions;
                
                [self.stack pushBoard:board animated:YES];
            }
            else 
            {
                [[RegionModel sharedInstance] setRegionFromAddress:[RegionModel sharedInstance].tempAddress];
                [RegionModel sharedInstance].level = 0;
                [self.stack popToBoard:self.rootBoard animated:YES];
            }
        }
    }
}

@end