import Foundation

enum APIError: Error {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case decodingError(Error)
}

actor APIClient {
    static let shared = APIClient()
    private let baseURL = "https://www.nautilusplus.com/content/themes/nautilus/ajax/ajax-apinautilusplus.php"
    
    // ADD: URLSession with background configuration
    private lazy var session: URLSession = {
        let config = URLSessionConfiguration.default
        config.allowsExpensiveNetworkAccess = true
        config.allowsConstrainedNetworkAccess = true
        config.waitsForConnectivity = true
#if os(watchOS)
        config.sessionSendsLaunchEvents = true
#endif
        return URLSession(configuration: config)
    }()
    
    private init() {}
    
    func fetchBranches() async throws -> [Branch] {
        guard let url = URL(string: baseURL) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = "action=GetBranches".data(using: .utf8)
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw APIError.invalidResponse
            }
            
            let branchResponse = try JSONDecoder().decode(BranchResponse.self, from: data)
            return branchResponse.data.branches
            
        } catch let decodingError as DecodingError {
            throw APIError.decodingError(decodingError)
        } catch {
            throw APIError.networkError(error)
        }
    }
}
