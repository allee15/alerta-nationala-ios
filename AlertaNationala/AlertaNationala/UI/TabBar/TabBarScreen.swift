//
//  TabBarScreen.swift
//  AlertaNationala
//
//  Created by Alexia Aldea
//

import SwiftUI
import Combine

enum TabBarNavigation {
    case home
    case maps
    case guides
}

class TabBarCoordinator: ObservableObject {
    static let instance = TabBarCoordinator()
    @Published var tabBarNavigation: TabBarNavigation?
    @Published var showTabBar: Bool = true
}

struct TabBarScreen: View {
    @EnvironmentObject private var navigation: Navigation

    @ObservedObject private var tabBarCoordinator = TabBarCoordinator.instance
    @StateObject private var viewModel = TabBarViewModel()
    
    @StateObject private var homeNavigation = Navigation(root: HomeScreen().asDestination())
    @StateObject private var mapsNavigation = Navigation(root: MapsScreen().asDestination())
    @StateObject private var guidesNavigation = Navigation(root: GuidesScreen().asDestination())
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            GeometryReader { proxy in
                LazyHStack(spacing: 0) {
                    Group {
                        switch viewModel.selectedTabItem {
                        case .home:
                            NavigationHostView(navigation: homeNavigation)
                        case .maps:
                            NavigationHostView(navigation: mapsNavigation)
                        case .guides:
                            NavigationHostView(navigation: guidesNavigation)
                        }
                    }.frame(width: proxy.size.width, height: proxy.size.height)
                }.onChange(of: viewModel.selectedTabItem) { _, newValue in
                    homeNavigation.popToRoot(animated: false)
                    mapsNavigation.popToRoot(animated: false)
                    guidesNavigation.popToRoot(animated: false)
                    self.viewModel.oldSelectedTab = newValue
                }.onReceive(tabBarCoordinator.$tabBarNavigation, perform: { value in
                    if let value {
                        switch value {
                        case .home:
                            if viewModel.selectedTabItem != .home {
                                viewModel.selectedTabItem = .home
                            }
                            homeNavigation.popToRoot(animated: true)
                        case .maps:
                            if viewModel.selectedTabItem != .maps {
                                viewModel.selectedTabItem = .maps
                            }
                            mapsNavigation.popToRoot(animated: true)
                        case .guides:
                            if viewModel.selectedTabItem != .guides {
                                viewModel.selectedTabItem = .guides
                            }
                            guidesNavigation.popToRoot(animated: true)
                        }
                    }
                })
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .ignoresSafeArea(.container)
        .ignoresSafeArea(.keyboard)
        .safeAreaInset(edge: .bottom) {
            TabBarView(
                selectedItem: $viewModel.selectedTabItem,
                items: viewModel.tabBarItems
            )
        }
    }
}
