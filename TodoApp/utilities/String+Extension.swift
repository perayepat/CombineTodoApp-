import Foundation

extension String {
    func getFileName() -> String {
        return URL(fileURLWithPath: self).deletingPathExtension().lastPathComponent
    }
    
    func getFileExtension() -> String {
        return URL(fileURLWithPath: self).pathExtension
    }
}
