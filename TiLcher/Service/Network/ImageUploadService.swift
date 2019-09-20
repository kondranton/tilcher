import UIKit
import Alamofire
import PromiseKit

final class ImageUploadService {
    private let keychainService: KeychainServiceProtocol = KeychainService()

    func upload(image: UIImage) -> Promise<RemoteImage> {
        return Promise { seal in
            guard
                let fullSizeImageData = image.jpegData(compressionQuality: 0.1),
                let token = keychainService.fetchAccessToken()
            else {
                return
            }

            Alamofire.upload(
                multipartFormData: { multipartFormData in
                    multipartFormData.append(
                        fullSizeImageData,
                        withName: "image",
                        fileName: "image.jpg",
                        mimeType: "image/jpg"
                    )
                },
                to: Environment.current.baseURL + "images/",
                headers: [
                    "Authorization": "JWT \(token)"
                ],
                encodingCompletion: { result in
                    switch result {
                    case .success(let upload, _, _):
                        upload.uploadProgress { (progress) in
                            print("Upload Progress: \(progress.fractionCompleted)")
                        }
                        upload.responseJSON { response in
                            print(String(describing: response.result.value))
                            guard let data = response.data else {
                                assertionFailure("No data")
                                return
                            }
                            do {
                                let decoder = JSONDecoder.common
                                let mappedResponse = try decoder.decode(RemoteImage.self, from: data)
                                seal.fulfill(mappedResponse)
                            } catch {
                                assertionFailure(error.localizedDescription)
                            }
                        }
                    case .failure(let encodingError):
                        print(encodingError)
                    }
                }
            )
        }
    }
}
