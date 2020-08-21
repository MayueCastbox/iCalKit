//
//  iCalTests.swift
//  iCal
//
//  Created by Kilian Koeltzsch on {TODAY}.
//  Copyright © 2017 iCal. All rights reserved.
//

import XCTest
@testable import iCalKit

class iCalTests: XCTestCase {
    
    static let iCalString = """
BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//hacksw/handcal//NONSGML v1.0//EN
BEGIN:VEVENT
UID:uid1@example.com
DTSTAMP:19970714T170000Z
ORGANIZER;CN=John Doe:MAILTO:john.doe@example.com
DTSTART:19970714T170000Z
DTEND:19970715T035959Z
SUMMARY:Bastille Day Party
END:VEVENT
BEGIN:VEVENT
UID:uid2@example.com
DTSTAMP:20200614T170000Z
DTSTART:20200614T170000Z
DTEND:20200615T035959Z
SUMMARY;LANGUAGE=fr:Marathon de Paris 2020
LOCATION;LANGUAGE=fr:Paris
DESCRIPTION;LANGUAGE=fr:Marathon annuel de Paris
STATUS:CANCELLED
END:VEVENT
END:VCALENDAR
"""
    
    static var allTests = [
        ("testLoadLocalFile", testLoadLocalFile),
        ("testEventData", testEventData),
        ("testQuickstart", testQuickstart),
        ("testQuickstartFromUrl", testQuickstartFromUrl),
    ]

    var exampleCals: [iCalKit.Calendar] = []

    override func setUp() {
//        let bundle = Bundle(for: type(of: self))
//        guard let url = bundle.url(forResource: "example", withExtension: "ics") else {
//            XCTAssert(false, "no test ics file")
//            return
//        }
        
        self.exampleCals = iCal.load(string: iCalTests.iCalString)
    }

    func testLoadLocalFile() {
        XCTAssert(exampleCals.count > 0)
    }

    func testEventData() {
        guard let cal = exampleCals.first
            else {
                XCTAssert(false, "No calendar found")
                return
        }

        var firstEvent: Event = Event()
        firstEvent.uid = "uid1@example.com"
        firstEvent.dtstamp = VDate(rawValue: "19970714T170000Z")
        firstEvent.summary = "Bastille Day Party"
        firstEvent.dtstart = VDate(rawValue: "19970714T170000Z")
        firstEvent.dtend = VDate(rawValue: "19970715T035959Z")
        firstEvent.isCancelled = false
        // TODO add alarm to `firstEvent`

        var secondEvent: Event = Event()
        secondEvent.uid = "uid2@example.com"
        secondEvent.dtstamp = VDate(rawValue: "20200614T170000Z")
        secondEvent.summary = "Marathon de Paris 2020"
        secondEvent.dtstart = VDate(rawValue: "20200614T170000Z")
        secondEvent.dtend = VDate(rawValue: "20200615T035959Z")
        secondEvent.location = "Paris"
        secondEvent.descr = "Marathon annuel de Paris"
        secondEvent.isCancelled = true
        // TODO add organizer to `secondEvent`

        XCTAssertEqual(cal.subComponents.count, 2) // Should have 2 events
        XCTAssertEqual(cal.subComponents[0] as! Event, firstEvent)
        XCTAssertEqual(cal.subComponents[1] as! Event, secondEvent)
    }

    func testQuickstart() {
        var event = Event()
        event.summary = "Awesome event"
        let calendar = Calendar(withComponents: [event])
        let iCalString = calendar.toCal()

        XCTAssertEqual(iCalString.contains("SUMMARY:Awesome event"), true)
    }

    func testQuickstartFromUrl() {
        let url = URL(string: "https://raw.githubusercontent.com/kiliankoe/iCalKit/master/Tests/example.ics")!
        let cals = try! iCal.load(url: url)
        // or loadFile() or loadString(), all of which return [Calendar] as an ics file can contain multiple calendars

        for cal in cals {
            for event in cal.subComponents where event is Event {
                print(event)
            }
        }

        XCTAssertEqual(cals.count, 1)
        XCTAssertEqual(cals[0].subComponents.count, 2) // Should have 2 events
        XCTAssertEqual("\(cals[0].subComponents[0])", "Event(uid: Optional(\"uid1@example.com\"), dtstamp: 19970714T170000Z, location: nil, summary: Optional(\"Bastille Day Party\"), descr: nil, dtstart: Optional(\"19970714T170000Z\"), dtend: Optional(\"19970715T035959Z\"), isCancelled: false)")
        XCTAssertEqual("\(cals[0].subComponents[1])", "Event(uid: Optional(\"uid2@example.com\"), dtstamp: 19980714T170000Z, location: nil, summary: Optional(\"Something completely different\"), descr: nil, dtstart: Optional(\"19980714T170000Z\"), dtend: Optional(\"19980715T035959Z\"), isCancelled: false)")
    }
}
