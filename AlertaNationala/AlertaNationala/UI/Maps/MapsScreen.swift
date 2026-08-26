//
//  MapsScreen.swift
//  AlertaNationala
//
//  Created by Alexia Aldea on 20/08/2026.
//

import SwiftUI
import MapKit

struct MapsScreen: View {
    @EnvironmentObject private var navigation: Navigation
    
    @StateObject private var viewModel = MapsViewModel()
    @State private var hasReceivedInitialCameraUpdate = false
    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 45.9432, longitude: 24.9668),
            span: MKCoordinateSpan(latitudeDelta: 4, longitudeDelta: 4)
        )
    )
    
    var body: some View {
        VStack(spacing: 0) {
            TabOptionsView(itemsType: viewModel.selectedTab) { type in
                viewModel.selectedTab = type
            }.padding(.horizontal, 16)
            
            ScrollView(.horizontal, showsIndicators: false) {
                TabView(selection: $viewModel.selectedTab) {
                    if viewModel.selectedTab == .map {
                        ZStack {
                            Map(position: $cameraPosition) {
                                UserAnnotation()
                                ForEach(viewModel.points) { point in
                                    Annotation(point.name, coordinate: CLLocationCoordinate2D(latitude: point.lat, longitude: point.lng)) {
                                        Button {
                                            viewModel.selectedPoint = point
                                        } label: {
                                            Image(.icMapPin)
                                                .resizable()
                                                .frame(width: point.id == viewModel.selectedPoint?.id ? 44 : 36,
                                                       height: point.id == viewModel.selectedPoint?.id ? 44 : 36)
                                        }
                                    }
                                }
                            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                            
                            if let selected = viewModel.selectedPoint {
                                VStack {
                                    Spacer()
                                    AssemblyPointCardView(point: selected,
                                                          distance: viewModel.distanceString(point: selected))
                                    .padding(.horizontal, 16)
                                    .transition(.move(edge: .bottom).combined(with: .opacity))
                                }
                            }
                        }
                    } else {
                        if viewModel.points.isEmpty {
                            Spacer()
                            Text("Punctele de adunare se descarca la prima conectare la internet.")
                                .foregroundStyle(Color.textPrimary)
                                .font(.poppinsBold(size: 16))
                            Spacer()
                        } else {
                            AssemblyPointListView(viewModel: viewModel)
                        }
                    }
                }
                .frame(width: UIScreen.main.bounds.width)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(Color.bgPrimary)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(.container, edges: [.bottom, .horizontal])
        .onMapCameraChange(frequency: .onEnd) { _ in
            guard hasReceivedInitialCameraUpdate else {
                hasReceivedInitialCameraUpdate = true
                return
            }
            if viewModel.selectedPoint != nil {
                withAnimation(.easeInOut(duration: 0.2)) {
                    viewModel.selectedPoint = nil
                }
            }
        }
    }
}

fileprivate struct AssemblyPointCardView: View {
    let point: AssemblyPoint
    let distance: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "mappin.circle.fill")
                    .resizable()
                    .frame(width: 36, height: 36)
                    .foregroundStyle(point.isActive ? Color.redBadge : Color.offline)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(point.name)
                        .foregroundStyle(Color.textPrimary)
                        .font(.poppinsSemiBold(size: 16))
                    
                    Text(point.address)
                        .foregroundStyle(Color.textSecondary)
                        .font(Font.poppinsRegular(size: 12))
                    
                    HStack(spacing: 16) {
                        if let distance {
                            Label(distance, systemImage: "location.fill")
                                .font(.poppinsRegular(size: 12))
                                .foregroundStyle(Color.textSecondary)
                        }
                        if let capacity = point.capacity {
                            Label("\(capacity) locuri", systemImage: "person.2.fill")
                                .font(.poppinsRegular(size: 12))
                                .foregroundStyle(Color.textSecondary)
                        }
                    }
                    
                    if !point.isActive {
                        Text("Punct dezactivat momentan")
                            .font(.caption)
                            .foregroundStyle(Color.yellowBadge)
                    }
                }
                
                Spacer()
            }
            
            PrimaryButton(text: "Deschide in Google Maps") {
                let googleMapsAppURL = URL(string: "comgooglemaps://?daddr=\(point.lat),\(point.lng)&directionsmode=driving")!
                UIApplication.shared.open(googleMapsAppURL)
            }
        }
        .padding(.all, 12)
        .background(Color.sfCard)
        .cornerRadius(12, corners: .allCorners)
        .padding(.horizontal, 16)
        .padding(.bottom, 88)
    }
}

fileprivate struct TabOptionsView: View {
    var itemsType: ViewType
    let action: (ViewType) -> ()
    
    var body: some View {
        HStack(spacing: 0) {
            OptionView(title: "Harta", image: .icMapView, isSelected: itemsType == .map) {
                action(.map)
            }
            
            OptionView(title: "Lista", image: .icMapView, isSelected: itemsType == .list) {
                action(.list)
            }
        }
        .padding(.top, 16)
    }
}

fileprivate struct OptionView: View {
    let title: String
    let image: ImageResource
    var isSelected: Bool
    let action: () -> ()
    
    var body: some View {
        Button {
            action()
        } label: {
            VStack(spacing: 4) {
                HStack(spacing: 8) {
                    Spacer()
                    Image(image)
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 24, height: 24)
                        .foregroundStyle(Color.textPrimary)
                    
                    Text(title)
                        .foregroundStyle(Color.textPrimary)
                        .font(.poppinsRegular(size: 16))
                    Spacer()
                }
                
                Rectangle()
                    .frame(height: 2)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(isSelected ? Color.greenBadge : Color.clear)
                    .padding(.horizontal, 8)
                
            }.frame(maxWidth: .infinity)
        }
    }
}

fileprivate struct AssemblyPointListView: View {
    @ObservedObject var viewModel: MapsViewModel
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                ForEach(viewModel.points, id: \.id) { point in
                    Button {
                        viewModel.selectedPoint = point
                    } label: {
                        VStack(spacing: 12) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(point.name)
                                        .foregroundStyle(Color.textPrimary)
                                        .font(.poppinsSemiBold(size: 16))
                                    
                                    Text(point.address)
                                        .foregroundStyle(Color.textSecondary)
                                        .font(.poppinsRegular(size: 12))
                                }
                                Spacer()
                                if let distance = viewModel.distanceString(point: point) {
                                    Text(distance)
                                        .foregroundStyle(Color.textSecondary)
                                        .font(.poppinsRegular(size: 12))
                                }
                            }
                            
                            SecondaryButton(text: "Deschide in Google Maps") {
                                let googleMapsAppURL = URL(string: "comgooglemaps://?daddr=\(point.lat),\(point.lng)&directionsmode=driving")!
                                UIApplication.shared.open(googleMapsAppURL)
                            }
                        }
                        .padding(.all, 12)
                        .background(Color.sfCard)
                        .cornerRadius(12, corners: .allCorners)
                    }
                }
            }
            .padding([.top, .horizontal], 16)
            .padding(.bottom, 32 + SafeAreaInsets.bottom + 12)
        }
    }
}

#Preview {
    MapsScreen()
}
