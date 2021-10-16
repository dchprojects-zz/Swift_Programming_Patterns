import Foundation

// -- //

enum SyncStep {
    case language
    case course
}

// -- //
enum SyncError: Error {
    case invalidRequest
}

// -- //

protocol SyncRequest {
    var accessToken: String { get }
}

// -- //

struct SyncResponse {
    let data: Data
}

// -- //

protocol SyncHandler {
    
    var syncHandler: SyncHandler { get }
    
    @available(macOS 12.0.0, *)
    func handle(request: SyncRequest) async throws -> SyncResponse
    
}

// -- //

struct LanguageSyncRequest: SyncRequest {
    let accessToken: String
}

// -- //

struct CoursesSyncRequest: SyncRequest {
    let accessToken: String
}

// -- //

open class BaseSyncHandler: SyncHandler {
    
    var syncHandler: SyncHandler
    
    init(syncHandler: SyncHandler) {
        self.syncHandler = syncHandler
    }
    
    @available(macOS 12.0.0, *)
    func handle(request: SyncRequest) async throws -> SyncResponse {
        return try await syncHandler.handle(request: request)
    }
    
}


// -- //

final class LanguageSyncHandler: BaseSyncHandler {
    
    @available(macOS 12.0.0, *)
    override func handle(request: SyncRequest) async throws -> SyncResponse {
        return .init(data: try await getLanguages())
    }
    
    @available(macOS 12.0.0, *)
    func getLanguages() async throws -> Data {
        return .init()
    }
    
}


// -- //

final class CourseSyncHandler: BaseSyncHandler {
    
    @available(macOS 12.0.0, *)
    override func handle(request: SyncRequest) async throws -> SyncResponse {
        return .init(data: try await getCourses())
    }
    
    @available(macOS 12.0.0, *)
    func getCourses() async throws -> Data {
        return .init()
    }
    
}


// -- //

final class SyncManagerN {
    
    fileprivate let syncHandler: SyncHandler
    fileprivate let languageSyncRequest: LanguageSyncRequest
    fileprivate let coursesSyncRequest: CoursesSyncRequest
    
    init(syncHandler: SyncHandler,
         languageSyncRequest: LanguageSyncRequest,
         coursesSyncRequest: CoursesSyncRequest) {
        
        self.syncHandler = syncHandler
        self.languageSyncRequest = languageSyncRequest
        self.coursesSyncRequest = coursesSyncRequest
        
    }
    
    @available(macOS 12.0.0, *)
    func start() async throws -> [SyncStep : SyncResponse] {
        
        var result: [SyncStep : SyncResponse] = [:]
        
        //
        
        result.updateValue(try await syncHandler.handle(request: languageSyncRequest),
                           forKey: .language)
        
        //
        
        result.updateValue(try await syncHandler.handle(request: coursesSyncRequest),
                           forKey: .course)
        
        //
        return result
        //
        
    }
    
}
