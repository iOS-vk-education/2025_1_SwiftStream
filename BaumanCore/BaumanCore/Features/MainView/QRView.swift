import SwiftUI
import UIKit

struct QRView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme

    @State private var qrImage: UIImage? = nil
    @State private var showSourceDialog = false
    @State private var showImagePicker = false
    @State private var pickerSourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var showDeleteAlert = false

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            VStack(spacing: 20) {
                Spacer()

                qrContainer
                    .padding(.horizontal, 24)

                VStack(spacing: 12) {
                    Button {
                        showSourceDialog = true
                    } label: {
                        Text(qrImage == nil ? Translation.QR.upload : Translation.QR.change)
                            .foregroundColor(Colors.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Colors.MainColor)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 24)

                    if qrImage != nil {
                        Button {
                            showDeleteAlert = true
                        } label: {
                            Text(Translation.QR.delete)
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.clear)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.red, lineWidth: 1)
                                )
                        }
                        .padding(.horizontal, 24)
                    }
                }

                Spacer()
            }

            Button {
                dismiss()
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: "chevron.left")
                    Text(Translation.ForgotPassword.backButton)
                }
                .foregroundColor(Colors.white)
                .padding(.horizontal, 18)
                .padding(.vertical, 12)
                .background(Colors.MainColor)
                .clipShape(Capsule())
            }
            .padding(.leading, 24)
            .padding(.bottom, 28)
        }
        .confirmationDialog(Translation.QR.selectSource, isPresented: $showSourceDialog, titleVisibility: .visible) {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                Button(Translation.QR.takePhoto) {
                    pickerSourceType = .camera
                    showImagePicker = true
                }
            }

            Button(Translation.QR.chooseFromGallery) {
                pickerSourceType = .photoLibrary
                showImagePicker = true
            }

            Button(Translation.Profile.cancel, role: .cancel) { }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(
                image: $qrImage,
                sourceType: pickerSourceType,
                allowsEditing: true
            ) { selectedImage in
                QRStorage.save(selectedImage)
            }
        }
        .alert(Translation.QR.deleteAlertTitle, isPresented: $showDeleteAlert) {
            Button(Translation.Profile.cancel, role: .cancel) { }

            Button(Translation.Profile.delete, role: .destructive) {
                qrImage = nil
                QRStorage.delete()
            }
        } message: {
            Text(Translation.QR.deleteAlertMessage)
        }
        .onAppear {
            qrImage = QRStorage.load()
        }
    }

    private var qrContainer: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(containerBackgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(containerBorderColor, lineWidth: 1.5)
                )

            Group {
                if let qrImage {
                    Image(uiImage: qrImage)
                        .resizable()
                        .scaledToFit()
                        .padding(20)
                } else {
                    VStack(spacing: 14) {
                        Image(systemName: "qrcode.viewfinder")
                            .font(.system(size: 54, weight: .regular))
                            .foregroundColor(placeholderIconColor)

                        Text(Translation.QR.placeholderTitle)
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(primaryTextColor)
                            .multilineTextAlignment(.center)

                        Text(Translation.QR.placeholderDescription)
                            .font(.system(size: 15))
                            .foregroundColor(secondaryTextColor)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 16)
                    }
                    .padding(24)
                }
            }
        }
        .frame(height: 360)
    }

    private var containerBackgroundColor: Color {
        colorScheme == .dark ? Color.white.opacity(0.06) : Color.white
    }

    private var containerBorderColor: Color {
        colorScheme == .dark ? Color.white.opacity(0.22) : Color.black.opacity(0.14)
    }

    private var placeholderIconColor: Color {
        colorScheme == .dark ? Color.white.opacity(0.85) : Colors.MainColor
    }

    private var primaryTextColor: Color {
        colorScheme == .dark ? Color.white : Colors.black
    }

    private var secondaryTextColor: Color {
        colorScheme == .dark ? Color.white.opacity(0.7) : Color.gray
    }
}
