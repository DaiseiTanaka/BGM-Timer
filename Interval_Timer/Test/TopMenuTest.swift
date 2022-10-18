//
//  TopMenuTest.swift
//  Interval_Timer
//
//  Created by 田中大誓 on 2022/10/01.
//


import SwiftUI

struct Content2View: View {
    @State private var selection = 1 //selected page
    @State var dataModel = ["Forums", "Learn", "Careers", "Store", "About"]
    var body: some View {
        NavigationView {
            VStack {
                //ScrollableTabView
                ScrollView(.horizontal, showsIndicators: false, content: {
                    ScrollViewReader { scrollReader in
                        ScrollableTabView(activeIdx: $selection, dataSet: self.dataModel)
                            .padding(.top).onChange(of: selection, perform: { value in
                                withAnimation{
                                    scrollReader.scrollTo(value, anchor: .center)
                                }
                            })
                    }
                })
                .background(Color(UIColor.secondarySystemFill))
                //Page View
                Button(action: {
                    //selection += 1
                    dataModel += ["add"]
                    print(dataModel)
                }) {
                    Text("Add")
                }
                LazyHStack {
                    PageView(selection: $selection, dataModel: dataModel)
                }
            }
            .navigationBarTitle("Demo", displayMode: .inline)
        }.onChange(of: selection, perform: { value in
            //update tab
        })
    }
}
//page view
struct PageView: View {
    @Binding var selection: Int
    let dataModel: [String]
    var body: some View {
        TabView(selection:$selection) {
            ForEach(0..<dataModel.count) { i in
                VStack {
                    HStack {
                        Text(dataModel[i])
                            .foregroundColor(Color.primary)
                            .padding()
                        Spacer()
                    }
                    Spacer()
                }.tag(i)
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 170)
        //give padding nav height + scrollable Tab
        .tabViewStyle(PageTabViewStyle.init(indexDisplayMode: .never))
        
    }
}
//Tab bar
extension HorizontalAlignment {
    private enum UnderlineLeading: AlignmentID {
        static func defaultValue(in d: ViewDimensions) -> CGFloat {
            return d[.leading]
        }
    }
    
    static let underlineLeading = HorizontalAlignment(UnderlineLeading.self)
}

struct WidthPreferenceKey: PreferenceKey {
    static var defaultValue = CGFloat(0)
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
    
    typealias Value = CGFloat
}


struct ScrollableTabView : View {
    @EnvironmentObject var timeManager: TimeManager

    @Binding var activeIdx: Int
    @State private var w: [CGFloat]
    private let dataSet: [String]
    init(activeIdx: Binding<Int>, dataSet: [String]) {
        self._activeIdx = activeIdx
        self.dataSet = dataSet
        _w = State.init(initialValue: [CGFloat](repeating: 0, count: dataSet.count))
        
    }
    
    var body: some View {
        VStack(alignment: .underlineLeading) {
            HStack {
                ForEach(0..<dataSet.count) { i in
                    Text(dataSet[i])
                    //.font(Font.title2.bold())
                        .modifier(ScrollableTabViewModifier(activeIdx: $activeIdx, idx: i))
                        .background(TextGeometry())
                        .onPreferenceChange(WidthPreferenceKey.self, perform: { self.w[i] = $0 })
                        .id(i)
                    Spacer().frame(width: 20)
                }
            }
            .padding(.horizontal, 5)
            Rectangle()
                .alignmentGuide(.underlineLeading) { d in d[.leading]  }
                .frame(width: w[activeIdx],  height: 4)
                .animation(.linear)
        }
    }
}

struct TextGeometry: View {
    var body: some View {
        GeometryReader { geometry in
            return Rectangle().fill(Color.clear).preference(key: WidthPreferenceKey.self, value: geometry.size.width)
        }
    }
}

struct ScrollableTabViewModifier: ViewModifier {
    @Binding var activeIdx: Int
    let idx: Int
    
    func body(content: Content) -> some View {
        Group {
            if activeIdx == idx {
                content.alignmentGuide(.underlineLeading) { d in
                    return d[.leading]
                }.onTapGesture {
                    withAnimation{
                        self.activeIdx = self.idx
                    }
                }
                
            } else {
                content.onTapGesture {
                    withAnimation{
                        self.activeIdx = self.idx
                    }
                }
            }
        }
    }
}
struct Content2View_Previews: PreviewProvider {
    static var previews: some View {
        Content2View()
    }
}
