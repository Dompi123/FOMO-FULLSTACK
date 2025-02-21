import Foundation

class NetworkLogger: URLProtocol {
    static var logs: [(request: URLRequest, response: URLResponse?, data: Data?, error: Error?)] = []
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let client = client else { return }
        
        // Create a mutable copy of the request
        let mutableRequest = (request as NSURLRequest).mutableCopy() as! NSMutableURLRequest
        
        // Create URLSession for actual network call
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: mutableRequest as URLRequest) { data, response, error in
            // Store the log
            Self.logs.append((
                request: self.request,
                response: response,
                data: data,
                error: error
            ))
            
            if let error = error {
                client.urlProtocol(self, didFailWithError: error)
                return
            }
            
            if let response = response {
                client.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            
            if let data = data {
                client.urlProtocol(self, didLoad: data)
            }
            
            client.urlProtocolDidFinishLoading(self)
        }
        task.resume()
    }
    
    override func stopLoading() {
        // No-op
    }
    
    static func generateReport() -> String {
        var report = "Network Traffic Report\n"
        report += "====================\n\n"
        
        for (index, log) in logs.enumerated() {
            report += "Request #\(index + 1)\n"
            report += "URL: \(log.request.url?.absoluteString ?? "N/A")\n"
            report += "Method: \(log.request.httpMethod ?? "N/A")\n"
            
            if let response = log.response as? HTTPURLResponse {
                report += "Status: \(response.statusCode)\n"
            }
            
            if let error = log.error {
                report += "Error: \(error.localizedDescription)\n"
            }
            
            report += "-------------------\n"
        }
        
        return report
    }
    
    static func clearLogs() {
        logs.removeAll()
    }
} 