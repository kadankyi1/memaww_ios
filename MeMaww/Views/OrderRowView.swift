//
//  OrderRowView.swift
//  MeMaww
//
//  Created by Dankyi Anno Kwaku on 4/20/24.
//


import SwiftUI
//import URLImage // Import the package module

struct OrderRowView: View {
    // MARK: - PROPERTIES
    var order: OrderModel
    
    // MARK: - BODY
    var body: some View {
        GroupBox(){
        HStack{
                VStack(){
                    
                    HStack{
                        Text("#"+order.orderId)
                            .font(.headline)
                            .fontWeight(.bold)
                        
                            Spacer()
                        
                        Text(order.orderPickupLocation)
                            .font(.caption)
                            .foregroundColor(Color.secondary)
                            .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                    } // END HSTACK
                    
                    
                    HStack{
                    Text("  " + order.orderStatusMessage + "  ")
                        .font(.footnote)
                        .bold()
                        .foregroundColor(Color.white)
                        .background(Color(order.orderStatusColor))
                        .cornerRadius(2)
                        
                        Spacer()
                        
                        Text(order.orderDate)
                            .font(.caption)
                            .foregroundColor(Color.secondary)
                            .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                    }
                    .padding(.vertical, 10)
                }
            /*
            let this_url = URL(string: order.image);
            URLImage(url: this_url!,
                     content: { image in
                         image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120, alignment: .center)
                            .clipped()
                            .cornerRadius(8)
                            /*
                            .renderingMode(.original)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.3), radius: 3, x: 2, y: 2)
                            .background(LinearGradient(gradient: Gradient(colors: [Color("ColorBlueInLoggedSpace")]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/))
                            .cornerRadius(8)
                            */
                     })
            */
            }
            .frame(maxWidth: .infinity)
        }
        .shadow(color: Color.gray, radius: 10, x: 0, y: 0)
    }
}

// MARK: - PREVIEW
struct OrderRowView_Previews: PreviewProvider {
    static var previews: some View {
        OrderRowView(order: orderData[0])
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
