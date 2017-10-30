//
//  TweetD.swift
//  Smashtag
//
//  Created by Tatiana Kornilova on 10/5/17.
//  Copyright © 2017 Fabric. All rights reserved.
//

import UIKit
import CoreData

class TweetD: NSManagedObject {
    class func findOrCreateTweet(matching twitterInfo: Tweet, in context: NSManagedObjectContext) throws -> TweetD
    {
        let request: NSFetchRequest<TweetD> = TweetD.fetchRequest()
        request.predicate = NSPredicate(format: "unique = %@", twitterInfo.identifier)
        
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                assert(matches.count == 1, "Tweet.findOrCreateTweet -- database inconsistency")
                return matches[0]
            }
        } catch {
            throw error
        }
        
        let tweet = TweetD(context: context)
        tweet.unique = twitterInfo.identifier
        tweet.text = twitterInfo.text
        tweet.ctreated = twitterInfo.created
        tweet.tweeter = try? TwitterUser.findOrCreateTwitterUser(matching: twitterInfo.user, in: context)
        return tweet
    }
}
