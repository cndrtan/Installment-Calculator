//
//  ContentView.swift
//  Installment Calculator
//
//  Created by Candra Winardi on 26/04/22.
//

import SwiftUI

struct ContentView: View {
    
    @State private var presentValue: Double = 0
    @State private var interestRate: Double = 0
    @State private var tenor: Double = 0
    @State private var PMT: Double = 0
    @State private var PMTConvert: String = ""
    @State private var selectedOptions = 1
    @FocusState private var hideKeyboardButton: Bool
    @State private var showingAlert = false
    @State private var enteredNumber = ""
    var enteredNumberFormatted: Double {
        return (Double(enteredNumber) ?? 0) / 100
    }
    
    
    let numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.zeroSymbol = ""
        return numberFormatter
    }()
    
    let decimalFormatter: NumberFormatter = {
        let decimalFormatter = NumberFormatter()
        decimalFormatter.numberStyle = .decimal
        decimalFormatter.zeroSymbol = ""
        return decimalFormatter
    }()
    
    //form
    var body: some View {
        NavigationView{
            Form{
                Section(header: Text("Present Value").foregroundColor(.black)){
                    ZStack(alignment: .leading) {
                        TextField("", text: $enteredNumber)
                            .keyboardType(.numberPad).foregroundColor(.clear)
                            .textFieldStyle(PlainTextFieldStyle())
                            .disableAutocorrection(true)
                            .accentColor(.clear)
                        Text("\(enteredNumberFormatted, specifier: "%.2f")")
                    }.focused($hideKeyboardButton)
                        .accessibilityLabel(Text("Input the Present Value"))
                }
                Section(header: Text("Interest Rate").foregroundColor(.black)){
                    TextField("Enter your Interest Rate", value: $interestRate, formatter: numberFormatter).keyboardType(.decimalPad).focused($hideKeyboardButton)
                        .accessibilityLabel(Text("Input the Interest Rate"))
                }
                Section(header: Text("Tenor").foregroundColor(.black)){
                    TextField("Enter your Tenor in Month", value: $tenor, formatter: decimalFormatter).keyboardType(.decimalPad).focused($hideKeyboardButton)
                        .accessibilityLabel(Text("Input the Tenor"))
                }
                Section(header: Text("Suku Bunga").foregroundColor(.black)){
                    Picker("Type", selection: $selectedOptions, content: {
                        Text("Effective").tag(1)
                        Text("Flat").tag(2)
                    }).pickerStyle(.automatic)
                }.foregroundColor(.black)
                
                Button{
                    presentValue = enteredNumberFormatted
                    
                    if(selectedOptions == 1){
                        PMT = (presentValue * ((interestRate/100)/12))/(1 - pow((1+((interestRate/100)/12)),-tenor))
                    }else{
                        PMT = (presentValue / tenor) + (presentValue * ((interestRate/100)/12))
                    }
                    
                    PMTConvert = numberFormatter.string(from: NSNumber(value: PMT)) ?? ""
                    
                    showingAlert = true
                }label: {
                    Text("Calculate").font(.system(.body))
                }.frame(maxWidth: .infinity, alignment: .center).listRowBackground(Color(red: 43/255, green: 116/255, blue: 212/255)).accentColor(.white)
                    .alert(isPresented: $showingAlert){
                        Alert(title: Text("Result"), message: Text("Your Installment is \(PMTConvert) per Month"), dismissButton: .default(Text("Done")))
                    }
                
            }.navigationTitle("Installment Calc").background(.red)
                .toolbar{
                    ToolbarItemGroup(placement: .keyboard) {
                        Button("Done"){
                            hideKeyboardButton = false
                        }
                    }
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.portrait)
    }
}

//untuk hide keyboard
extension View{
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
