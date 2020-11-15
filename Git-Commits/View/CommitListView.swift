//
//  CommitListView.swift
//  Git-Commits
//
//  Created by Abhishek Tyagi on 11/7/20.
//

import SwiftUI
import Alamofire

struct CommitListView: View {
    @EnvironmentObject var service: CommitService

    private var repoName: String? {
        return service.repoInfo["name"]
    }
    
    @State var textFieldRepoString: String = ""
    @State var textFieldAuthorString: String = ""
    @State var alert = Alert.init(title: Text(""), message: Text(""))
    @State var showAlert: Bool = false
    
    var body: some View {
        NavigationView{
            if repoName == nil {
                VStack(spacing: 10){
                    TextField("Enter Repo Name", text: $textFieldRepoString).padding()
                    
                    TextField("Enter Author Name", text: $textFieldAuthorString).padding()
                    Spacer().frame(height: 50)
                    
                    Text("Submit")
                        .onTapGesture {
                            fetchCommitList(for: textFieldAuthorString, textFieldRepoString)
                        }
                }
            }
            else {
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
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Validation Error"), message: Text("Kindly fill out all the details"), dismissButton: .default(Text("Ok")))
        }
    }
    
    private func fetchCommitList(for author: String, _ repo: String ) {
        if service.validateInformation(author: author, repo: repo) == true {
            service.updateCommitFetcher(for: repo, author: author)
            service.fetchLatest()
        }
        else {
            showAlert = true
        }
    }
}

struct CommitListView_Previews: PreviewProvider {
    static var previews: some View {
        CommitListView()
    }
}
