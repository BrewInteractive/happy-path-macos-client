//
//  Graphqls.swift
//  BHappyWatch Watch App
//
//  Created by Gorkem Sevim on 23.06.2024.
//

import Foundation

final class Graphqls {
    static let timers = """
        query getTimers($startsAt: String!, $endsAt: String!) {
            timers(
                startsAt: $startsAt,
                endsAt: $endsAt) {
                id,
                endsAt,
                startsAt,
                duration,
                totalDuration,
                relations,
                task {
                    id,
                    name
                },
                project {
                    id,
                    name
                },
                notes
            }
        }
        """
    
    static let me = """
        query Me {
            me {
                email
            }
        }
        """
}
