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
            if service.isFetchingCommits {
                ProgressView()
            }
            else {
                List {
                    ForEach (service.commits) { commit in
                        CommitListItem(commit: commit)
                    }
                }
                .navigationBarTitle("Commits", displayMode: .automatic)
            }
        }
        .onAppear() {
            fetchCommitList()
        }
    }
    
    private func fetchCommitList() {
        service.fetchLatest(author: "Alamofire", repo: "Alamofire") { success in
            //can do some UI functions if needed
        }
//        service.fetchLatest(author: "abhishek3322", repo: "Git-Commits") { success in
//            //can do some UI functions if needed
//        }
    }
}

struct CommitListView_Previews: PreviewProvider {
    static var previews: some View {
        CommitListView()
    }
}
