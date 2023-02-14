import Foundation
import PhotosUI

@objc(CDVPHPicker)
public class CDVPHPicker : CDVPlugin, PHPickerViewControllerDelegate {
    private var command: CDVInvokedUrlCommand?;
    @available(iOS 14, *)
    public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: .none)
        
        if let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) {
                [weak self] image, error in
                DispatchQueue.main.async {
                    itemProvider.loadDataRepresentation(forTypeIdentifier: "public.image") { [weak self] data, _ in
                        let bytes = [UInt8](data ?? Data());
                        
                        itemProvider.loadFileRepresentation(forTypeIdentifier: "public.image") { [weak self] url, _ in
                            let result: [String: Any] = ["bytes": bytes, "url": url?.absoluteString ?? "", "name": url?.lastPathComponent ?? ""];
                                let pluginResult:CDVPluginResult = CDVPluginResult.init(status: CDVCommandStatus_OK, messageAs: result)

                            self?.commandDelegate.send(pluginResult, callbackId: self?.command?.callbackId)
                            
                        }
                    }
                }
            }
        }
    }
    
  @objc
  func execute(_ command: CDVInvokedUrlCommand) {
      self.command = command;

    if #available(iOS 14, *) {
          var phPickerConfig = PHPickerConfiguration(photoLibrary: .shared())
          phPickerConfig.selectionLimit = 1
          phPickerConfig.filter = PHPickerFilter.any(of: [.images, .livePhotos])
          let phPickerVC = PHPickerViewController(configuration: phPickerConfig)
          phPickerVC.delegate = self
          self.viewController.present(phPickerVC, animated: true)
      } else {
          // Fallback on earlier versions
      }
  }
}
