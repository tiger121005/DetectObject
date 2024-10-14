//
//  Methods.swift
//  DetectObject
//
//  Created by TAIGA ITO on 2024/10/09.
//

import Foundation
import Vision
import UIKit
import CoreML

class Methods {
    static let shared = Methods()
    
    let config = MLModelConfiguration()
    var requestDetectModel: VNCoreMLRequest!
    
    public func detectObject(image: UIImage, completion: @escaping ([String]) -> Void) {
        
        var labels: [String] = []
        
        // YOLOv3のモデルを取得
        //YOLOv3はMLファイルの名前
        guard let mlModel: MLModel = try? YOLOv3(configuration: self.config).model else { return }
        guard let model = try? VNCoreMLModel(for: mlModel) else { return }
        requestDetectModel = VNCoreMLRequest(model: model) { request, error in
            if let error {
                return
            }
            //認識された物体の数がresultsの要素の個数
            guard let results = request.results as? [VNRecognizedObjectObservation] else { return }
            //
            for result in results {
                //認識された物体で、可能性の高いものから配列で並んでいる。　
                //その中から一番最初のもの（一番正解確率が高いもの）の名前を取得している。
                guard let label = result.labels.first?.identifier else { return }
                labels.append(label)
            }
        }
        guard let cgImage = image.cgImage else { return }
        // imageRequestHanderにimageをセット
        let imageRequestHandler = VNImageRequestHandler(cgImage: cgImage)
        // imageRequestHandlerにrequestをセットし、実行
        try? imageRequestHandler.perform([requestDetectModel])
        completion(labels)
    }
    
}
