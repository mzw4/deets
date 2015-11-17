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
func makeEvents() {
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
func makeUsers() {
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
    
    DataHandler.userRef.childByAppendingPath("0bf5ce44-8422-4754-9ff2-568b6fec27bd").setValue([
        "coverPhoto": "",
        "description": "When my dragons are grown, we will take back what was stolen from me and destroy those who wronged me! We will lay waste to armies and burn cities to the ground!",
        "email": "daenerys@thrones.com",
        "linkedin": "https://www.linkedin.com/pub/daenerys-targaryen/b9/119/315",
        "name": "Daenerys Targaryen",
        "numConnections": 435,
        "numEvents": 284,
        "phone": "424-242-4242",
        "profile_pic": "daenerys.png",
        "title": "Mother of Dragons, Queen of Meereen",
        "twitter": "https://twitter.com/daenerys"
        ])
    
    DataHandler.userRef.childByAppendingPath("100a1497-746f-43ce-81fc-120d87457d2b").setValue([
        "coverPhoto": "",
        "description": "Tell me, if I stabbed the Mad King in the belly instead of the back, would you admire me more?",
        "email": "jaime@thrones.com",
        "linkedin": "https://www.linkedin.com/pub/jon-snow/b5/94/a61",
        "name": "Jaime Lannister",
        "numConnections": 74,
        "numEvents": 12,
        "phone": "424-242-4242",
        "profile_pic": "jaime.png",
        "title": "Ser, Lord Commander of the Kingsguard",
        "twitter": "https://twitter.com/SerJaime"
        ])

    DataHandler.userRef.childByAppendingPath("e4714436-3e81-4671-ad22-0729ddd1579c").setValue([
        "coverPhoto": "",
        "description": "I am the god of tits and wine.",
        "email": "tyrion@thrones.com",
        "linkedin": "https://www.linkedin.com/pub/jon-snow/b5/94/a61",
        "name": "Tyrion Lannister",
        "numConnections": 137,
        "numEvents": 43,
        "phone": "424-242-4242",
        "profile_pic": "tyrion.png",
        "title": "Master of Coin, Hand of the King",
        "twitter": "https://twitter.com/GoT_Tyrion"
        ])
    
    DataHandler.userRef.childByAppendingPath("e20f44bb-bec1-48d5-a35f-ae5e6571735d").setValue([
        "coverPhoto": "",
        "description": "Money buys a man's silence for a time. A bolt in the heart buys it forever.",
        "email": "littlefinger@thrones.com",
        "linkedin": "https://www.linkedin.com/pub/jon-snow/b5/94/a61",
        "name": "Peter Baelish",
        "numConnections": 99999,
        "numEvents": 1,
        "phone": "424-242-4242",
        "profile_pic": "littlefinger.png",
        "title": "Lord Protector of the Vale, Lord of Harrenhal",
        "twitter": "https://twitter.com/MasterofCoin"
        ])
    
    DataHandler.userRef.childByAppendingPath("72b2974f-ced9-4332-a79a-c418dca455cc").setValue([
        "coverPhoto": "",
        "description": "Some day I'm going to put a sword through your eye and out the back of your skull.",
        "email": "arya@thrones.com",
        "linkedin": "https://www.linkedin.com/pub/jon-snow/b5/94/a61",
        "name": "Arya Stark",
        "numConnections": 35,
        "numEvents": 94,
        "phone": "424-242-4242",
        "profile_pic": "arya.png",
        "title": "Princess of Winterfell",
        "twitter": "https://twitter.com/SerJaime"
        ])
}

func makeConnectionRequests() {
//    DataHandler.
}
