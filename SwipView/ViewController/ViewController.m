//
//  ViewController.m
//  SwipView
//
//  Created by xianghaitao on 16/8/29.
//
//

#import "DragViewController.h"
#import "ImageCycleViewController.h"
#import "SwipViewController.h"
#import "ViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray *dataArr;

@end

@implementation ViewController

#pragma mark - life cycle
- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"项目";
  [self setupSubviews];
  // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - setup methods
- (void)setupSubviews {
  [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellId = @"cellID";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
  if (!cell) {
    cell = [UITableViewCell new];
    NSInteger row = indexPath.row;
    cell.textLabel.text = self.dataArr[row];
  }
  return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
  switch (indexPath.row) {
  case 0:
    [[self navigationController] pushViewController:[SwipViewController new]
                                           animated:YES];
    break;
  case 1:
    [self.navigationController pushViewController:[ImageCycleViewController new]
                                         animated:YES];
    break;
  case 2:
    [self.navigationController pushViewController:[DragViewController new]
                                         animated:YES];
    break;
  default:
    break;
  }
}

#pragma mark - getter and setter

- (UITableView *)tableView {
  if (!_tableView) {
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    _tableView.dataSource = self;
    _tableView.delegate = self;
  }
  return _tableView;
}

- (NSArray *)dataArr {
  if (!_dataArr) {
    _dataArr = @[ @"视图切换", @"轮播", @"拖动" ];
  }
  return _dataArr;
}

@end
