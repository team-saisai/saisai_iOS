//
//  CourseRidingView.swift
//  SaiSai
//
//  Created by 이창현 on 7/23/25.
//

import SwiftUI
import MapKit

struct CourseRidingView: View {
    
    @ObservedObject var vm: CourseDetailViewModel
    
    var body: some View {
        Map {
            if let courseDetail = vm.courseDetail {
                MapPolyline(MKPolyline(coordinates: courseDetail.locations, count: courseDetail.locations.count))
                    .stroke(.customLime, lineWidth: 5)
                
                Annotation("출발", coordinate: courseDetail.locations[0]) {
                    Circle()
                        .fill(Color.customLime)
                        .frame(width: 14, height: 14)
                }
                
                Annotation("도착", coordinate: courseDetail.locations.last!) {
                    Circle()
                        .fill(Color.customLime)
                        .frame(width: 14, height: 14)
                }
                
                if let heading = vm.heading {
                    UserAnnotation {
                        CustomUserAnnotationView(heading: heading)
                    }
                }
                
                if !vm.checkpointList.isEmpty {
                    ForEach(vm.checkpointList.indices, id: \.self) {
                        Annotation(
                            "체크포인트 \($0 + 1)",
                            coordinate: CLLocationCoordinate2D(
                                latitude: vm.checkpointList[$0].latitude,
                                longitude: vm.checkpointList[$0].longitude
                            )
                        ) {
                            Circle()
                                .fill(Color.customLime)
                                .frame(width: 14, height: 14)
                        }
                    }
                }
            }
        }
        .ignoresSafeArea(.all)
        .mapControls {
            MapUserLocationButton()
        }
        .onAppear {
            vm.startUpdatingLocation()
        }
        .onDisappear() {
            vm.stopUpdatingLocation()
        }
    }
}
