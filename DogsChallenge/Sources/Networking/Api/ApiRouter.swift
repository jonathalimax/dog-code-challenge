import Alamofire
import Foundation

protocol ApiRouter: URLRequestConvertible {
    var baseUrl: String { get }
}
