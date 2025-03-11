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
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.textColor = .cocoBitBlack
        return label
    }()
    
    let changeLabel = {
        let label = UILabel()
        label.font = .setFont(.mediumBold)
        label.textColor = .cocoBitBlack
        return label
    }()
    
    let arrowImage = UIImageView()
    
    let updateLabel = {
        let label = UILabel()
        label.font = .setFont(.medium)
        label.textColor = .cocoBitGray
        return label
    }()
    
    let chart = LineChartView()
    
    func configureData(_ item: ChartItem) {
        priceLabel.text = item.crrentPrice
        changeLabel.text = item.change24h
        changeLabel.textColor = item.changeColor.color
        arrowImage.tintColor = item.changeColor.color
        updateLabel.text = item.lastUpdated
        
        switch item.changeColor {
        case .down: arrowImage.image = .setSymbol(.arrowDown)
        case .up: arrowImage.image = .setSymbol(.arrowUp)
        default: break
        }
        
        configureChart()
        let lineChartDataEntries = entryData(values: item.chartArray)
        setLineData(lineChartView: chart, lineChartDataEntries: lineChartDataEntries)
    }
    
    override func configureHierarchy() {
        contentView.addSubviews(priceLabel, changeLabel, arrowImage, updateLabel, chart)
    }
    override func configureLayout() {
        priceLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        arrowImage.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview()
            make.size.equalTo(14)
        }
        
        changeLabel.snp.makeConstraints { make in
            make.leading.equalTo(arrowImage.snp.trailing).offset(5)
            make.centerY.equalTo(arrowImage)
        }
        chart.snp.makeConstraints { make in
            make.top.equalTo(changeLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(-5)
            make.height.equalToSuperview().inset(40)
        }
        updateLabel.snp.makeConstraints { make in
            make.top.equalTo(chart.snp.bottom).offset(5)
            make.leading.equalToSuperview()
        }
    }
    
    func configureChart() {
        chart.noDataText = "출력 데이터가 없습니다."
        chart.noDataFont = .systemFont(ofSize: 20)
        chart.noDataTextColor = .lightGray
        chart.backgroundColor = .white

        chart.drawGridBackgroundEnabled = false
        chart.chartDescription.enabled = false
        
        chart.rightAxis.enabled = false
        chart.leftAxis.enabled = false
        
        chart.xAxis.enabled = false
        chart.legend.enabled = false
        
        chart.dragEnabled = false
        chart.pinchZoomEnabled = false
        chart.setScaleEnabled(false)
        chart.highlightPerTapEnabled = false
        chart.doubleTapToZoomEnabled = false
        
        chart.animate(xAxisDuration: 0.5)
    }
    
    func setLineData(lineChartView: LineChartView, lineChartDataEntries: [ChartDataEntry]) {
        let lineChartdataSet = LineChartDataSet(entries: lineChartDataEntries, label: "")
        
        lineChartdataSet.mode = .cubicBezier
        lineChartdataSet.lineWidth = 2.0
        lineChartdataSet.drawCircleHoleEnabled = false
        lineChartdataSet.drawCirclesEnabled = false
        lineChartdataSet.drawValuesEnabled = false
        lineChartdataSet.drawFilledEnabled = true
        lineChartdataSet.colors = [.cocoBitBlue]
        
        
        let fillColors = [UIColor.cocoBitBlue.withAlphaComponent(0.3).cgColor, UIColor.cocoBitBlue.cgColor]
        let locations:[CGFloat] = [0.0, 1.0]
        let colorspace = CGColorSpaceCreateDeviceRGB()
                    
        let gradient = CGGradient(colorsSpace: colorspace, colors: fillColors as CFArray, locations: locations)!
        lineChartdataSet.fill = LinearGradientFill(gradient: gradient, angle: 90)
        
        let lineChartData = LineChartData(dataSet: lineChartdataSet)
        lineChartView.data = lineChartData
    }

    func entryData(values: [Double]) -> [ChartDataEntry] {
        var lineDataEntries: [ChartDataEntry] = []
        for i in 0 ..< values.count {
            let lineDataEntry = ChartDataEntry(x: Double(i), y: values[i])
            lineDataEntries.append(lineDataEntry)
        }
        return lineDataEntries
    }
}
