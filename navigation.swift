import ApplicationServices; 
import Foundation; 
import Cocoa; 
import CoreGraphics

// Open iCloud Settings
NSWorkspace.shared.open(URL(string: "x-apple.systempreferences:com.apple.systempreferences.AppleIDSettings:icloud")!)

// Connect to Window
func getWindow() -> AXUIElement? {
    for _ in 1...20 {
        if let app = NSWorkspace.shared.runningApplications.first(where: { 
            ["com.apple.SystemSettings", "com.apple.systempreferences"].contains($0.bundleIdentifier) 
        }) {
            let pid = app.processIdentifier
            var ref: CFTypeRef?; AXUIElementCopyAttributeValue(AXUIElementCreateApplication(pid), kAXWindowsAttribute as CFString, &ref)
            if let w = (ref as? [AXUIElement])?.first { return w }
        }
        Thread.sleep(forTimeInterval: 0.5)
    }
    return nil
}

// Unified Recursive Search
func find(_ root: AXUIElement, match: (String, String) -> Bool) -> AXUIElement? {
    var q = [root]; var i = 0
    while !q.isEmpty && i < 5000 {
        let e = q.removeFirst(); i += 1
        var id: CFTypeRef?; AXUIElementCopyAttributeValue(e, kAXIdentifierAttribute as CFString, &id)
        var title: CFTypeRef?; AXUIElementCopyAttributeValue(e, kAXTitleAttribute as CFString, &title)
        var desc: CFTypeRef?; AXUIElementCopyAttributeValue(e, kAXDescriptionAttribute as CFString, &desc)
        
        let idS = id as? String ?? ""; let lblS = (title as? String) ?? (desc as? String) ?? ""
        if match(idS, lblS) { return e }
        
        var k: CFTypeRef?; AXUIElementCopyAttributeValue(e, kAXChildrenAttribute as CFString, &k)
        if let kids = k as? [AXUIElement] { q.append(contentsOf: kids) }
    }
    return nil
}

// Click with Visual Feedback
func click(_ e: AXUIElement) {
    var pV: CFTypeRef?; AXUIElementCopyAttributeValue(e, kAXPositionAttribute as CFString, &pV)
    var sV: CFTypeRef?; AXUIElementCopyAttributeValue(e, kAXSizeAttribute as CFString, &sV)
    if let p = pV as! AXValue?, let s = sV as! AXValue? {
        var pt = CGPoint.zero; var sz = CGSize.zero
        AXValueGetValue(p, .cgPoint, &pt); AXValueGetValue(s, .cgSize, &sz)
        let c = CGPoint(x: pt.x + sz.width/2.0, y: pt.y + sz.height/2.0)
        
        for t: CGEventType in [.mouseMoved, .leftMouseDown, .leftMouseUp] {
            CGEvent(mouseEventSource: nil, mouseType: t, mouseCursorPosition: c, mouseButton: .left)?.post(tap: .cghidEventTap)
            Thread.sleep(forTimeInterval: t == .mouseMoved ? 0.3 : 0.2)
        }
    } else { AXUIElementPerformAction(e, kAXPressAction as CFString) }
}

// Execution
guard let win = getWindow() else { print("Window missing"); exit(1) }

// --- LOCK MOUSE START ---
CGAssociateMouseAndMouseCursorPosition(0)

if let btn = find(win, match: { id, _ in id == "six-pack-card-Messages" }) {
    click(btn)
    Thread.sleep(forTimeInterval: 1.5)
    
    // Find Sync Now
    for _ in 1...15 {
        if let sync = find(win, match: { _, lbl in lbl == "Sync Now" }) {
            click(sync)
            Process.launchedProcess(launchPath: "/usr/bin/osascript", arguments: ["-e", "display notification \"Sync Started\" with title \"Success\""])
            CGAssociateMouseAndMouseCursorPosition(1) // Unlock before exit
            exit(0)
        }
        Thread.sleep(forTimeInterval: 0.5)
    }
    print("Sync button not found")
} else { print("Messages button not found") }

CGAssociateMouseAndMouseCursorPosition(1)
// --- LOCK MOUSE END ---