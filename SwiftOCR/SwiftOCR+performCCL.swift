
public extension SwiftOCR {
    /**
     
     Extracts the characters using [Connected-component labeling](https://en.wikipedia.org/wiki/Connected-component_labeling) and callbacks with their location data
     
     - Parameter image:             The image used for OCR
     - Parameter completionHandler: The completion handler that gets invoked after CCL is finished, returning
     results of this action.
     
     */
    open func performCCL(_ image: OCRImage, _ onCompleted: @escaping ([CGRect]) -> Void){
        DispatchQueue.global(qos: .userInitiated).async {
            let preprocessedImage      = self.delegate?.preprocessImageForOCR(image) ?? self.preprocessImageForOCR(image)
            
            let blobs                  = self.extractBlobs(preprocessedImage)
            onCompleted(blobs.map({$0.1}))
        }
    }
}

