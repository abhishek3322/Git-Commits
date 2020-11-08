//
//  CommitListItem.swift
//  Git-Commits
//
//  Created by Abhishek Tyagi on 11/7/20.
//

import SwiftUI
import Alamofire

struct CommitListItem: View {
    var commit: Commit
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 5) {
                Text( commit.details.committer.name)
                    .font(.callout)
                Text(commit.details.message)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(commit.details.committer.updatedOn.timeAgo())
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            Spacer()
            Text(commit.hash)
                .font(.caption)
                .padding(5)
                .background(Color.commitBackground)
                .foregroundColor(.white)
                .cornerRadius(5)
        }
    }
}
