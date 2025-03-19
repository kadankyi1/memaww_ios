//
//  NotificationsListItemView.swift
//  MeMaww
//
//  Created by Dankyi Anno Kwaku on 4/20/24.
//


import SwiftUI
//import URLImage // Import the package module

struct NotificationsListItemView: View {
    // MARK: - PROPERTIES
    var notification: NotificationModel
    
    // MARK: - BODY
    var body: some View {
                        
        GroupBox(){
                VStack(){
                    
                    Text(notification.notification_title)
                        .bold()
                            .font(.footnote)
                            .foregroundColor(Color.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    
                        Text(notification.notification_body)
                            .font(.caption)
                            .foregroundColor(Color.black)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(notification.notification_date)
                            .font(.caption)
                            .foregroundColor(Color.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    
                    
                }
            .frame(maxWidth: .infinity)
        }
    }
}

// MARK: - PREVIEW
struct NotificationsListItemView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsListItemView(notification: notificationData[0])
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
