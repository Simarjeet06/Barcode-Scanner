//
//  ContentView.swift
//  Barcode Scanner
//
//  Created by Simarjeet Kaur on 23/04/25.
//

import SwiftUI

struct BarcodeScanner: View {
    @State private var scannedCode=""
    var body: some View {
        NavigationView{
            VStack{
                ScannerView(scannedCode:$scannedCode)
                    .frame(maxWidth:.infinity,maxHeight:400)
                    
                    Spacer().frame(
                        height:100
                    )
            
                Label("Scanned Barcode",
                      systemImage:"barcode.viewfinder")
                .font(.title)
                
                Text(scannedCode.isEmpty ? "NOT YET SCANNED": scannedCode)
                    .bold()
                    .font(.largeTitle)
                    .foregroundColor(scannedCode.isEmpty ? .red:.green)
                    .padding()
            }
            
            .navigationTitle("Barcode Scanner")
        }
    }
}

#Preview {
    BarcodeScanner()
}
