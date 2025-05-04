//
//  ScannerView.swift
//  Barcode Scanner
//
//  Created by Simarjeet Kaur on 03/05/25.
//

import SwiftUI

struct ScannerView: UIViewControllerRepresentable {
    @Binding var scannedCode:String
    func makeUIViewController(context: Context) -> ScannerVC {
        ScannerVC(scanDelegate: context.coordinator)
    }
    
    func updateUIViewController(_ uiViewController: ScannerVC, context: Context){}
    func makeCoordinator() -> Coordinator {
        Coordinator(scannerView:self)
    }
    final class Coordinator: NSObject, ScannerVCDelegate {
        let scannerView:ScannerView
        init(scannerView: ScannerView) {
            self.scannerView = scannerView
        }
        func didFind(barcode: String) {
            scannerView.scannedCode=barcode
            print(barcode)
        }
        
        func didSurfaceError(error: CameraError) {
            print(error.rawValue)
        }
        
        
    }
}

#Preview {
    ScannerView(scannedCode: .constant("123456"))
}
