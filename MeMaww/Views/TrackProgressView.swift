//
//  TrackProgressView.swift
//  MeMaww
//
//  Created by Dankyi Anno Kwaku on 5/20/24.
//

import SwiftUI

struct TrackProgressView: View {
    
    var status: String
    var isFirst: Bool
    var isLast: Bool
    var viewNumber: Int
    var state: Int
    
    var body: some View {
            HStack {
                /*
                 Text ("May 12")
                    .frame(width: 80)
                 */
                Spacer ()
                ZStack {
                    VStack{
                        Rectangle()
                        .frame(width: 4, height: 25)
                        .foregroundColor(self.state < self.viewNumber ? Color("Gray") : Color.blue.opacity(0.2))
                        .opacity(self.isFirst ? 0.0 : 1.0)
                                         
                                         
                         Rectangle()
                         .frame(width: 4, height: 25)
                         //.foregroundColor(Color.gray)
                         .foregroundColor(self.state < self.viewNumber ? Color("Gray")  : Color.blue.opacity(0.2))
                         .opacity(self.isLast ? 0.0 : 1.0)
                    }
                  
                  
                  Circle()
                  .frame(width: 17, height: 17)
                  .foregroundColor(self.state < self.viewNumber ? Color("Gray")  : Color.blue.opacity(0.5))
                  .opacity(self.state < self.viewNumber ? 0.0 : 1.0)
                  
                  
                  Circle()
                  .frame(width: 10, height: 10)
                  .foregroundColor(self.state < self.viewNumber ? Color("Gray")  : Color.blue.opacity(0.5))
                }
                
            HStack{
                /*
                 Image(systemName:"a.circle.fill")
                    .font(.title)
                    .foregroundColor(.blue)
                 */
                                          
                  Text(status)
                  .font(.system(size: 12))
                  .foregroundColor((self.state < self.viewNumber ? Color.gray : Color.black))
                  Spacer ()
            }
            .padding(.all,8)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
                                          
            Spacer ()
            }
                       
    }
}

struct TrackProgressView_Previews: PreviewProvider {
    static var previews: some View {
        TrackProgressView(status: "Pending", isFirst: true, isLast: false, viewNumber: 2, state: 1).previewLayout(.sizeThatFits)
    }
}
