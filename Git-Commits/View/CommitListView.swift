//
//  CommitListView.swift
//  Git-Commits
//
//  Created by Abhishek Tyagi on 11/7/20.
//

import SwiftUI

struct CommitListView: View {
    @EnvironmentObject var service: CommitService

    var body: some View {
        NavigationView{
            List {
                ForEach (service.commits) { commit in
                    CommitListItem(commit: commit)
                }
            }
            .navigationBarTitle("Commits", displayMode: .automatic)
        }
    }
}

struct CommitListView_Previews: PreviewProvider {
    static var previews: some View {
        CommitListView()
    }
}
