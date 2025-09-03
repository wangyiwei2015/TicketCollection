//
//  ContentView+Filter.swift
//  TicketCollection
//
//  Created by leo on 2025.04.07.
//

extension ContentView {
    var filteredTickets: [TicketItem] {
        filteredTicketsFor(tickets)
    }
    
    func filteredTicketsInFolder(_ folder: TicketFolder) -> [TicketItem] {
        filteredTicketsFor(folder.tickets ?? [])
    }
    
    func filteredTicketsFor(_ src: [TicketItem]) -> [TicketItem] {
        src.filter { item in
            var matched = true
            
            let starFiltered = !filters[0] || item.starred
            let futureFiltered = !filters[1] || item.departTime > .now
            let studentFiltered = !filters[2] || item.isStudent
            let filtered1 = starFiltered && futureFiltered && studentFiltered
            let fG = filters[3] && item.trainNumber.first == "G"
            let fD = filters[4] && item.trainNumber.first == "D"
            let fZ = filters[5] && item.trainNumber.first == "Z"
            let fT = filters[6] && item.trainNumber.first == "T"
            let fK = filters[7] && item.trainNumber.first == "K"
            let fC = filters[8] && item.trainNumber.first == "C"
            let filtered2 = fG || fD || fZ || fT || fK || fC
            // 字母一个都没选 就不筛
            if !filters[3...8].contains(where: {$0}) { matched = filtered1 }
            else { matched = filtered1 && filtered2 }
            
            let searchItems = appliedSearchTerm
                .split(separator: try! Regex(",|;| |，|；"), omittingEmptySubsequences: true)
            if !searchItems.isEmpty {
                //deal with search
                var searchMatched = false
                for term in searchItems {
                    searchMatched ||= item.trainNumber.contains(term)
                    searchMatched ||= item.comments.contains(term)
                    searchMatched ||= item.notes.contains(term)
                    searchMatched ||= item.seat.contains(term)
                    searchMatched ||= item.carriage.contains(term)
                    searchMatched ||= item.entrance.contains(term)
                    searchMatched ||= item.stationSrcCN.contains(term)
                    searchMatched ||= item.stationSrcEN.contains(term)
                    searchMatched ||= item.stationDstCN.contains(term)
                    searchMatched ||= item.stationDstEN.contains(term)
                    searchMatched ||= item.seatLevel.contains(term)
                    searchMatched ||= item.passengerName.contains(term)
                    searchMatched ||= item.passengerID.contains(term)
                    searchMatched ||= item.ticketID.contains(term)
                    searchMatched ||= item.ticketSerial.contains(term)
                }
                //finally
                matched &&= searchMatched
            }
            return matched
        }
    }
}
