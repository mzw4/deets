//
//  DBScripts.swift
//  BluetoothTest
//
//  Created by Mike Wang on 10/28/15.
//  Copyright © 2015 Vivek Sudarsan. All rights reserved.
//

import Foundation
import Firebase

// Create some fake event data and stick it in the DB
func populateEvents() {
    var sampleEvents = ["Entrepreneurs Meetup", "Hilton Networking Event", "VC Meet & Greet", "Cornell Tech Meetup", "Comic Con: San Diego","Cornell Career Fair"]
    var companies = ["Facebook", "The Hilton", "Evil People United", "Cornell University", "The Indigo League","Crrrrraazy!"]
    var eventImages = ["event.jpg","event2.jpg","event3.jpg","event4.jpg","event5.png","event.jpg"]
    var locations = ["Javits Center","Hilton Union Square","W. Hotel Midtown West","Cornell Tech NYC","San Diego Convention Center","Cornell Tech NYC"]
    var descriptions = ["So great, just the best","So great, just the best","So great, just the best","So great, just the best","So great, just the best","So great, just the best"]
    var dates = [NSDate]()
    
    let dateFormatter: NSDateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
    dates = [dateFormatter.dateFromString("10/25/2015 18:00")!,
        dateFormatter.dateFromString("11/04/2015 12:00")!,
        dateFormatter.dateFromString("11/11/2015 12:00")!,
        dateFormatter.dateFromString("12/14/2015 12:00")!,
        dateFormatter.dateFromString("12/16/2015 12:00")!,
        dateFormatter.dateFromString("01/12/2015 4:00")!]
    DataHandler.eventsRef.removeValue()
    for i in 0...sampleEvents.count-1 {
        DataHandler.createEvent(sampleEvents[i], location: locations[i], startDate: dates[i], endDate: dates[i], company: companies[i], description: descriptions[i], eventPhoto: eventImages[i])
    }
}

// Create some fake user data and stick it in the DB
func populateUsers() {
    DataHandler.userRef.childByAppendingPath("e1c9384a-a279-4abe-9375-9bc8a813c034").setValue([
        "coverPhoto": "nightswatch.png",
        "description": "My name is Jon Snow. I am Lord Commander of the Night's Watch, steward of justice and killer of white walkers. I am son to a murdered father, brother to murdered kin, husband to a murdered wife, I'm not sure who my mother was, and I was murdered too. And I will have my vengenace, in this life or the next.",
        "email": "jonsnow@isalive.com",
        "linkedin": "https://www.linkedin.com/pub/jon-snow/b5/94/a61",
        "name": "Jon Snow",
        "numConnections": 9001,
        "numEvents": 42,
        "phone": "424-242-4242",
        "profile_pic": "jonsnow.png",
        "title": "Lord Commander, The Night's Watch",
        "twitter": "https://twitter.com/lordsnow"
        ])
}
