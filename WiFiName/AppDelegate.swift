//
//  AppDelegate.swift
//  WiFiName
//
//  Created by Leonardo Hammer on 2019/5/16.
//  Copyright © 2019 tuesleep. All rights reserved.
//

import Cocoa
import CoreWLAN

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    let wifiClient = CWWiFiClient.shared()

    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength);

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Add menu
        let menu = NSMenu()
        let exitItem = NSMenuItem(title: "Exit", action: #selector(exitAction), keyEquivalent:"")
        menu.addItem(exitItem)

        statusItem.menu = menu

        let interface = wifiClient.interface();

        let button = statusItem.button
        button?.font = NSFont.userFont(ofSize: 9)
        button?.alignment = NSTextAlignment.center

        if let ssid = interface?.ssid() {
            button?.title = "Wi-Fi:\n \(ssid)"
        } else {
            button?.title = "No connect"
        }

        wifiClient.delegate = self
        try! wifiClient.startMonitoringEvent(with: .ssidDidChange)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @objc func exitAction() {
        exit(0)
    }
}

extension AppDelegate: CWEventDelegate {
    func ssidDidChangeForWiFiInterface(withName interfaceName: String) {
        let interface = wifiClient.interface();

        let button = statusItem.button

        DispatchQueue.main.async {
            if let ssid = interface?.ssid() {
                button?.title = "Wi-Fi:\n \(ssid)"
            } else {
                button?.title = "No connect"
            }
        }
    }
}
