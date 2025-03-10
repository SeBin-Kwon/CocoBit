//
//  ChartCollectionViewCell.swift
//  CocoBit
//
//  Created by Sebin Kwon on 3/11/25.
//

import UIKit
import SnapKit
import DGCharts

class ChartCollectionViewCell: BaseCollectionViewCell {
    let priceLabel = {
        let label = UILabel()
        label.font = .setFont(.medium)
        label.textColor = .cocoBitBlack
        return label
    }()
    
    let changeLabel = {
        let label = UILabel()
        label.font = .setFont(.medium)
        label.textColor = .cocoBitBlack
        return label
    }()
    
    let updateLabel = {
        let label = UILabel()
        label.font = .setFont(.medium)
        label.textColor = .cocoBitGray
        return label
    }()
    
    let myBarChartView = LineChartView()
    
    var priceData: [Double]! = [100, 345, 20, 120, 90, 300, 450, 220, 120]
    
    override func configureHierarchy() {
        self.setLineData(lineChartView: self.myBarChartView, lineChartDataEntries: self.entryData(values: self.priceData))
        
        contentView.addSubviews(priceLabel, changeLabel, updateLabel, myBarChartView)
    }
    override func configureLayout() {
        priceLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        myBarChartView.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(200)
        }
    }
    
    func configureChart() {
        self.myBarChartView.noDataText = "출력 데이터가 없습니다."
        self.myBarChartView.noDataFont = .systemFont(ofSize: 20)
        self.myBarChartView.noDataTextColor = .lightGray
        self.myBarChartView.backgroundColor = .white
    }
    
    // 데이터 적용하기
    func setLineData(lineChartView: LineChartView, lineChartDataEntries: [ChartDataEntry]) {
        // Entry들을 이용해 Data Set 만들기
        let lineChartdataSet = LineChartDataSet(entries: lineChartDataEntries, label: "매출")
        // DataSet을 차트 데이터로 넣기
        let lineChartData = LineChartData(dataSet: lineChartdataSet)
        // 데이터 출력
        lineChartView.data = lineChartData
    }

    // entry 만들기
    func entryData(values: [Double]) -> [ChartDataEntry] {
        // entry 담을 array
        var lineDataEntries: [ChartDataEntry] = []
        // 담기
        for i in 0 ..< values.count {
            let lineDataEntry = ChartDataEntry(x: Double(i), y: values[i])
            lineDataEntries.append(lineDataEntry)
        }
        // 반환
        return lineDataEntries
    }
}
