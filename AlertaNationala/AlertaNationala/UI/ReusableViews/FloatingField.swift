//
//  FloatingField.swift
//  AlertaNationala
//
//  Created by Alexia Aldea
//

import SwiftUI

struct FloatingField: View {
    @Binding var text: String
    var placeHolder: String
    var secureField: Bool = false
    var keyboardType: UIKeyboardType = .default
    var colors: (bgColor: Color, borderColor: Color, placeholderForeground: Color) = (.fieldSecondary, .fieldSecondary, .fieldTextSecondary)
    var icon: ImageResource?
    var leftIcon: ImageResource?
    var leftIconHeight: CGFloat? = 28
    var errorMessage: String? = nil
    var isDisabled: Bool = false
    
    @State private var secure: Bool = true
    @State private var isEditing: Bool = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            ZStack {
                HStack {
                    if let leftIcon = leftIcon {
                        Image(leftIcon)
                            .resizable()
                            .renderingMode(.template)
                            .scaledToFit()
                            .frame(height: leftIconHeight)
                            .foregroundColor(.black)
                            .padding(.trailing, 4)
                    }
                    
                    if $text.wrappedValue.isEmpty {
                        Text(placeHolder)
                            .foregroundColor(isDisabled ? colors.placeholderForeground.opacity(0.5) : colors.placeholderForeground)
                            .font(.poppinsRegular(size: 14))
                            .multilineTextAlignment(.leading)
                    } else {
                        Text(placeHolder)
                            .foregroundColor(colors.placeholderForeground)
                            .font(.poppinsRegular(size: 14))
                            .scaleEffect(0.75, anchor: .leading)
                            .offset(y: -12)
                            .multilineTextAlignment(.leading)
                            .lineLimit(1)
                            .truncationMode(.middle)
                    }
                    
                    Spacer()
                }.padding(.horizontal, 16)
                
                HStack {
                    if let leftIcon = leftIcon {
                        Image(leftIcon)
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.black)
                            .scaledToFit()
                            .frame(height: leftIconHeight)
                            .padding(.trailing, 4)
                            .opacity(0)
                    }
                    
                    VStack {
                        Group {
                            if secureField && secure {
                                SecureField(text: $text) {
                                }
                                .autocapitalization(.none)
                            } else {
                                TextField(text: $text) {
                                }
                                .keyboardType(keyboardType)
                                .autocapitalization(.none)
                            }
                        }.foregroundColor(isDisabled ? colors.placeholderForeground.opacity(0.5) : .black)
                            .font(.poppinsRegular(size: 14))
                            .padding(.leading, 16)
                            .offset(y: $text.wrappedValue.isEmpty ? 0 : 4 )
                    }
                    .padding(.trailing, secureField ? 60 : 16)
                }
                
                HStack {
                    Spacer()
                    if secureField {
                        Button {
                            secure.toggle()
                        } label: {
                            Image(systemName: self.secure ? "eye" : "eye.slash")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.black)
                                .frame(width: 24, height: 16)
                                .padding(.trailing, 16)
                        }
                    } else if let icon = icon {
                        Button {
                            text.removeAll()
                        } label: {
                            Image(icon)
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.black)
                                .frame(width: 24, height: 24)
                                .padding(.trailing, 16)
                        }
                    }
                }
            }
            .frame(height: 54)
            .background(!isEditing ? colors.bgColor : isDisabled ? colors.bgColor.opacity(0.5) : .white)
            .cornerRadius(4, corners: .allCorners)
            .border((errorMessage ?? "").isEmpty ? (!isEditing ? colors.borderColor :  isDisabled ? colors.borderColor.opacity(0.5) : .black) : Color.lightRed,
                    width: 1,
                    cornerRadius: 4)
            .onTapGesture {
                self.isEditing = true
            }
            .onChange(of: text) { _, _ in
                self.isEditing = true
            }
            .onSubmit {
                self.isEditing = false
            }
            
            if let errorMessage = errorMessage {
                HStack {
                    Text(errorMessage)
                        .font(.poppinsRegular(size: 12))
                        .foregroundColor(Color.lightRed)
                    Spacer()
                }
                .padding(.top, 4)
            }
        }.disabled(isDisabled)
    }
}

struct SelectZonesView: View {
    @Binding var selectedZones: [String]
    var zonesList: [String]
    var colors: (bgColor: Color, borderColor: Color, placeholderForeground: Color) = (.fieldSecondary, .fieldSecondary, .fieldTextSecondary)
    var errorMessage: String? = nil
    @State private var isSheetShown: Bool = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            HStack {
                Image(.icFieldMapPin)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 28)
                    .padding(.trailing, 4)
                
                if selectedZones.isEmpty {
                    Text("Selecteaza zonele")
                        .foregroundColor(colors.placeholderForeground)
                        .font(.poppinsRegular(size: 14))
                        .multilineTextAlignment(.leading)
                } else {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Selecteaza zonele")
                            .foregroundColor(colors.placeholderForeground)
                            .font(.poppinsRegular(size: 10))
                        
                        Text(selectedZones.joined(separator: ", "))
                            .foregroundColor(Color.black)
                            .font(.poppinsRegular(size: 14))
                            .lineLimit(1)
                            .truncationMode(.tail)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.down")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(colors.placeholderForeground)
                    .frame(width: 16, height: 12)
            }
            .padding(.horizontal, 16)
            .frame(height: 54)
            .background(colors.bgColor)
            .cornerRadius(4, corners: .allCorners)
            .border((errorMessage ?? "").isEmpty ? colors.borderColor : Color.lightRed,
                    width: 1,
                    cornerRadius: 4)
            .onTapGesture {
                isSheetShown = true
            }
            
            if let errorMessage = errorMessage {
                HStack {
                    Text(errorMessage)
                        .font(.poppinsRegular(size: 12))
                        .foregroundColor(Color.lightRed)
                    Spacer()
                }
                .padding(.top, 4)
            }
        }
        .sheet(isPresented: $isSheetShown) {
            ZoneMultiSelectSheet(selectedZones: $selectedZones, zonesList: zonesList)
                .presentationDetents([.medium, .large])
        }
    }
}

struct ZoneMultiSelectSheet: View {
    @Binding var selectedZones: [String]
    var zonesList: [String]
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List(zonesList, id: \.self) { zone in
                HStack {
                    Text(zone)
                        .font(.poppinsSemiBold(size: 20))
                        .foregroundColor(Color.textPrimary)
                    
                    Spacer()
                    
                    if selectedZones.contains(zone) {
                        Image(.icCheckedOn)
                            .resizable()
                            .renderingMode(.template)
                            .foregroundStyle(Color.bgPrimary)
                            .frame(width: 24, height: 24)
                    } else {
                        Image(.icCheckedOff)
                            .resizable()
                            .renderingMode(.template)
                            .foregroundStyle(Color.bgPrimary)
                            .frame(width: 24, height: 24)
                    }
                }
                .listRowBackground(Color.textSecondary)
                .contentShape(Rectangle())
                .onTapGesture {
                    toggleZone(zone)
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.textSecondary)
            .navigationTitle("Selecteaza zone")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Gata") {
                        dismiss()
                    }
                    .font(.poppinsSemiBold(size: 16))
                    .foregroundColor(Color.bluePrimary)
                }
            }
        }
        .presentationBackground(Color.fieldSecondary)
    }
    
    private func toggleZone(_ zone: String) {
        if let index = selectedZones.firstIndex(of: zone) {
            selectedZones.remove(at: index)
        } else {
            selectedZones.append(zone)
        }
    }
}
