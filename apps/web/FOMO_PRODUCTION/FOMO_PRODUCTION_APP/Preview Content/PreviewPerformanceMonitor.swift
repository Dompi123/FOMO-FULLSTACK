import SwiftUI
import Foundation

#if DEBUG
@MainActor
final class PreviewPerformanceMonitor: ObservableObject {
    static let shared = PreviewPerformanceMonitor()
    
    @Published private(set) var metrics: [PerformanceMetric] = []
    @Published private(set) var securityStatus: SecurityStatus = .pending
    
    private var startTime: CFAbsoluteTime = 0
    private var frameCount: Int = 0
    private var lastFrameTime: CFAbsoluteTime = 0
    
    private init() {
        startMonitoring()
    }
    
    func startMonitoring() {
        startTime = CFAbsoluteTimeGetCurrent()
        lastFrameTime = startTime
        
        // Reset metrics
        metrics = [
            PerformanceMetric(name: "First Paint", value: 0, unit: "ms", threshold: 100),
            PerformanceMetric(name: "FPS", value: 0, unit: "fps", threshold: 58),
            PerformanceMetric(name: "Memory", value: 0, unit: "MB", threshold: 50),
            PerformanceMetric(name: "CPU", value: 0, unit: "%", threshold: 10)
        ]
        
        // Start security validation
        Task {
            await validateSecurity()
        }
        
        // Start frame monitoring
        displayLink = CADisplayLink(target: self, selector: #selector(frameUpdate))
        displayLink?.add(to: .main, forMode: .common)
    }
    
    private var displayLink: CADisplayLink?
    
    @objc private func frameUpdate() {
        frameCount += 1
        let currentTime = CFAbsoluteTimeGetCurrent()
        
        // Calculate FPS
        if currentTime - lastFrameTime >= 1.0 {
            let fps = Double(frameCount) / (currentTime - lastFrameTime)
            updateMetric(named: "FPS", value: fps)
            
            frameCount = 0
            lastFrameTime = currentTime
        }
        
        // First paint time
        if metrics[0].value == 0 {
            let firstPaint = (currentTime - startTime) * 1000
            updateMetric(named: "First Paint", value: firstPaint)
        }
        
        // Memory usage
        let memoryUsage = getMemoryUsage()
        updateMetric(named: "Memory", value: Double(memoryUsage))
        
        // CPU usage
        let cpuUsage = getCPUUsage()
        updateMetric(named: "CPU", value: cpuUsage)
    }
    
    private func updateMetric(named name: String, value: Double) {
        if let index = metrics.firstIndex(where: { $0.name == name }) {
            metrics[index].value = value
            metrics[index].status = value <= metrics[index].threshold ? .passed : .failed
        }
    }
    
    private func validateSecurity() async {
        securityStatus = .validating
        
        do {
            // Simulate security validation
            try await Task.sleep(nanoseconds: 2_000_000_000)
            
            // Check all metrics are within thresholds
            let allMetricsPassed = metrics.allSatisfy { $0.status == .passed }
            securityStatus = allMetricsPassed ? .passed : .failed
        } catch {
            securityStatus = .failed
        }
    }
    
    private func getMemoryUsage() -> Int {
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size)/4
        
        let kerr: kern_return_t = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_,
                         task_flavor_t(MACH_TASK_BASIC_INFO),
                         $0,
                         &count)
            }
        }
        
        return kerr == KERN_SUCCESS ? Int(info.resident_size / 1024 / 1024) : 0
    }
    
    private func getCPUUsage() -> Double {
        var totalUsageOfCPU: Double = 0.0
        var threadList: thread_act_array_t?
        var threadCount: mach_msg_type_number_t = 0
        
        let threadResult = task_threads(mach_task_self_, &threadList, &threadCount)
        
        if threadResult == KERN_SUCCESS, let threadList = threadList {
            for index in 0..<threadCount {
                var threadInfo = thread_basic_info()
                var threadInfoCount = mach_msg_type_number_t(THREAD_INFO_MAX)
                
                let infoResult = withUnsafeMutablePointer(to: &threadInfo) {
                    $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                        thread_info(threadList[Int(index)],
                                  thread_flavor_t(THREAD_BASIC_INFO),
                                  $0,
                                  &threadInfoCount)
                    }
                }
                
                if infoResult == KERN_SUCCESS {
                    let cpuUsage = Double(threadInfo.cpu_usage) / Double(TH_USAGE_SCALE)
                    totalUsageOfCPU += cpuUsage
                }
            }
            
            vm_deallocate(mach_task_self_,
                         vm_address_t(UInt(bitPattern: threadList)),
                         vm_size_t(Int(threadCount) * MemoryLayout<thread_t>.stride))
        }
        
        return totalUsageOfCPU * 100
    }
}

// MARK: - Supporting Types
extension PreviewPerformanceMonitor {
    struct PerformanceMetric: Identifiable {
        let id = UUID()
        let name: String
        var value: Double
        let unit: String
        let threshold: Double
        var status: MetricStatus = .pending
        
        var formattedValue: String {
            String(format: "%.1f%@", value, unit)
        }
    }
    
    enum MetricStatus {
        case pending
        case passed
        case failed
        
        var color: Color {
            switch self {
            case .pending: return FOMOTheme.Colors.warning
            case .passed: return FOMOTheme.Colors.success
            case .failed: return FOMOTheme.Colors.error
            }
        }
    }
    
    enum SecurityStatus {
        case pending
        case validating
        case passed
        case failed
        
        var color: Color {
            switch self {
            case .pending, .validating:
                return FOMOTheme.Colors.warning
            case .passed:
                return FOMOTheme.Colors.success
            case .failed:
                return FOMOTheme.Colors.error
            }
        }
        
        var icon: String {
            switch self {
            case .pending:
                return "clock"
            case .validating:
                return "arrow.clockwise"
            case .passed:
                return "checkmark.shield"
            case .failed:
                return "xmark.shield"
            }
        }
    }
}

// MARK: - Preview Support
struct PerformanceMonitorView: View {
    @ObservedObject private var monitor = PreviewPerformanceMonitor.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: FOMOTheme.Layout.gridSpacing) {
            ForEach(monitor.metrics) { metric in
                HStack {
                    Text(metric.name)
                        .font(FOMOTheme.Typography.bodyRegular)
                    
                    Spacer()
                    
                    Text(metric.formattedValue)
                        .font(FOMOTheme.Typography.bodyRegular)
                        .foregroundStyle(metric.status.color)
                }
            }
            
            Divider()
                .background(FOMOTheme.Colors.accent)
            
            HStack {
                Image(systemName: monitor.securityStatus.icon)
                Text("Security Status")
                    .font(FOMOTheme.Typography.bodyRegular)
                Spacer()
                Text(String(describing: monitor.securityStatus))
                    .font(FOMOTheme.Typography.bodyRegular)
                    .foregroundStyle(monitor.securityStatus.color)
            }
        }
        .padding()
        .background(FOMOTheme.Colors.surface)
        .cornerRadius(FOMOTheme.Layout.cornerRadius)
    }
}

#if DEBUG
struct PerformanceMonitorView_Previews: PreviewProvider {
    static var previews: some View {
        PerformanceMonitorView()
            .padding()
            .background(FOMOTheme.Colors.background)
            .previewLayout(.sizeThatFits)
    }
}
#endif 