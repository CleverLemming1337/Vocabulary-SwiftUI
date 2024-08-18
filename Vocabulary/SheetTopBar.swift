import SwiftUI

struct SheetTopBar: ViewModifier {
    let cancel: LocalizedStringKey?
    let done: LocalizedStringKey
    
    let cancelFunc: (() -> Void)?
    let doneFunc: (() -> Void)?
    
    let destructiveCancel: Bool // shows a dialog when cancel button is pressed
    
    let disabledFunc: (() -> Bool)?
    
    let title: LocalizedStringKey
    
    @State private var showDialog = false
    
    func body(content: Content) -> some View {
        NavigationStack {
            content
                .toolbar {
                    if cancel != nil || cancelFunc == nil {
                        ToolbarItem(placement: .topBarLeading) {
                            Button(cancel!, role: .cancel) {
                                if destructiveCancel {
                                    showDialog = true
                                }
                                else {
                                    cancelFunc!()
                                }
                            }
                        }
                    }
                    if doneFunc != nil {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button(done) {
                                doneFunc!()
                            }
                            .disabled(disabledFunc != nil ? disabledFunc!() : false)
                        }
                    }
                }
                .navigationTitle(title)
        }
        
        .confirmationDialog("Destroy changes", isPresented: $showDialog, actions: {
            Button("Destroy changes", role: .destructive) { cancelFunc!() }
            Button("Cancel", role: .cancel) { showDialog = false }
        }, message: { Text("Continuing will destory all your changes. This action is irreversible.") })
    }
}

extension View {
    func sheetTopBar(title: LocalizedStringKey = "", cancel: LocalizedStringKey? = "Cancel", done: LocalizedStringKey = "**Done**", cancelFunc: (() -> Void)? = nil, destructiveCancel: Bool = false, disabledFunc: (() -> Bool)? = nil, _ doneFunc: (() -> Void)? = nil) -> some View {
        modifier(SheetTopBar(cancel: cancel, done: done, cancelFunc: cancelFunc, doneFunc: doneFunc, destructiveCancel: destructiveCancel, disabledFunc: disabledFunc, title: title))
    }
}
