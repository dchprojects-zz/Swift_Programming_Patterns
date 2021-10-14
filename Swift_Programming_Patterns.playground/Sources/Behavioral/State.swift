import Foundation

enum SyncStep {
    case initialization
    case start
    case inProgress(progress: Float)
    case finish
}

protocol SyncManagerInterface {
    
    var isRunning: Bool { get }
    var currentStep: SyncStep { get }
    
    func start()
    func cancel()
    
}

final class SyncManager: SyncManagerInterface {
    
    public var isRunning: Bool {
        
        switch currentStep {
            
        case .initialization,
                .finish:
            
            return false
            
            
        case .start,
                .inProgress:
            
            return true
            
        }
        
    }
    
    public var currentStep: SyncStep
    
    init() {
        self.currentStep = .initialization
    }
    
}

// MARK: - Public Methods
extension SyncManager {
    
    func start() {
        
        // Update Current Step
        //
        self.currentStep = .start
        //
        
        // Code For Synchronization
        // ...
        // ...
                
        // Update Current Step
        //
        self.currentStep = .inProgress(progress: .zero)
        //
        
    }
    
    func cancel() {
        
        // Update Current Step
        //
        self.currentStep = .finish
        //
        
    }
    
}
