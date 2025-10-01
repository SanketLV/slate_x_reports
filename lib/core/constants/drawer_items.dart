import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

enum AppTab {
  invoice,
  itemSales,
  categorySales,
  hourlySales,
  tax,
  cashDrawer,
  dailySales,
}

class DrawerTileSpec {
  final AppTab tab;
  final String title;
  final IconData icon;

  const DrawerTileSpec({
    required this.tab,
    required this.title,
    required this.icon,
  });
}

const List<DrawerTileSpec> drawerItems = [
  DrawerTileSpec(
    tab: AppTab.invoice,
    title: 'Invoice Report',
    icon: LucideIcons.paperclip,
  ),
  DrawerTileSpec(
    tab: AppTab.dailySales,
    title: 'Daily Sales Report',
    icon: LucideIcons.chartColumn,
  ),
  DrawerTileSpec(
    tab: AppTab.hourlySales,
    title: 'Hourly Sales Report',
    icon: LucideIcons.clock,
  ),
  DrawerTileSpec(
    tab: AppTab.tax,
    title: 'Tax Report',
    icon: LucideIcons.calculator,
  ),
  DrawerTileSpec(
    tab: AppTab.itemSales,
    title: 'Item Sales Report',
    icon: LucideIcons.shoppingCart,
  ),
  DrawerTileSpec(
    tab: AppTab.categorySales,
    title: 'Category Sales Report',
    icon: LucideIcons.squareStack,
  ),
  DrawerTileSpec(
    tab: AppTab.cashDrawer,
    title: 'Cash Drawer Report',
    icon: LucideIcons.panelTopClose,
  ),
];
