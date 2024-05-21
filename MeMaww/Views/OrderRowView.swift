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
                        Text(order.orderId)
                        .font(.headline)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)

                        
                        Text(order.orderStatusMessage)
                            .font(.caption)
                            .foregroundColor(Color.black)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(spacing: 0){
                        TrackProgressView(status: "Pending", isFirst: true, isLast: false, viewNumber: 1, state: order.orderStatus)
                        TrackProgressView(status: "Picked", isFirst: false, isLast: false, viewNumber: 2, state: order.orderStatus)
                        TrackProgressView(status: "Washing", isFirst: false, isLast: false, viewNumber: 3, state: order.orderStatus)
                        TrackProgressView(status: "Delivered", isFirst: false, isLast: true, viewNumber: 4, state: order.orderStatus)
                    }
                    
                    HStack{
                        Text("Ordered")
                            .font(.footnote)
                            .bold()
                            .foregroundColor(Color.black)
                            .background(Color(order.orderStatusColor))
                            .cornerRadius(2)
                        Text(order.orderDate)
                            .font(.footnote)
                            .foregroundColor(Color.gray)
                            .background(Color(order.orderStatusColor))
                            .cornerRadius(2)
                        
                        Spacer()
                        
                            Text("Items")
                                .font(.footnote)
                                .bold()
                                .foregroundColor(Color.black)
                                .background(Color(order.orderStatusColor))
                                .cornerRadius(2)
                            Text(order.orderAllItemsQuantity)
                                .font(.footnote)
                                .foregroundColor(Color.gray)
                                .background(Color(order.orderStatusColor))
                                .cornerRadius(2)
                    }
                    .padding(.vertical, 10)
                    
                    
                    
                    HStack{
                        Text("Delivery")
                            .font(.footnote)
                            .bold()
                            .foregroundColor(Color.black)
                            .cornerRadius(2)
                        Text(order.orderDeliveryDate)
                            .font(.footnote)
                            .foregroundColor(Color.gray)
                            .cornerRadius(2)
                        
                        Spacer()
                        
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
