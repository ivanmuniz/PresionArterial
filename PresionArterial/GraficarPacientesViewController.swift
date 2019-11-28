//
//  GraficarPacientesViewController.swift
//  PresionArterial
//
//  Created by Alumno on 11/25/19.
//  Copyright © 2019 Iván Muñiz. All rights reserved.
//

import UIKit
import Charts


class GraficarPacientesViewController: UIViewController {

    var diastolica = [Int]()
    var sistolica = [Int]()
    
    @IBOutlet weak var linechart: LineChartView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func grafica(_ sender: Any) {
//     print(sistolica[0])
        setCharValues()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func setCharValues(){
        let formatter = DateFormatter()
        
        
        
        formatter.dateFormat = "dd/MM"

        
        //CFDateGetTimeIntervalSinceDate(Date as CFDate, usuario.presion[rows].timestamp.dateValue() as CFDate)
       
            
            
            
          
        
        linechart.xAxis.valueFormatter = (DateFormatter() as? IAxisValueFormatter)
        //lineChartGrafica.xAxis.valueFormatter =
        linechart.xAxis.valueFormatter =  XAxisValueFormatter()
        linechart.xAxis.spaceMin = 0.5
        linechart.xAxis.spaceMax = 1
        
        let valores = (0..<sistolica.count).map { (i) -> ChartDataEntry in
            let val = Double(sistolica[i])
            return ChartDataEntry(x: Double(i), y: val)
        }
        let set1 = LineChartDataSet(entries: valores, label: "Sistolica")
        set1.setColor( UIColor(red: 20.0/255.0, green: 150.0/255.0, blue: 150.0/255.0, alpha: 1.0))
        set1.lineWidth = 2
        set1.setCircleColor(UIColor(red: 20.0/255.0, green: 150.0/255.0, blue: 150.0/255.0, alpha: 1.0))
        set1.circleRadius = 3
        set1.circleHoleColor = NSUIColor(red: 20.0/255.0, green: 150.0/255.0, blue: 150.0/255.0, alpha: 1.0)
        
        
        
        
        let valores2 = (0..<diastolica.count).map { (i) -> ChartDataEntry in
            let val2 = Double(diastolica[i])
            return ChartDataEntry(x: Double(i), y: val2)
        }
        let set2 = LineChartDataSet(entries: valores2, label: "Diastolica")
        
        
       /* let valores3 = (0..<pulso.count).map { (i) -> ChartDataEntry in
                   let val3 = Double(pulso[i])
                   return ChartDataEntry(x: Double(i), y: val3)
               }
        let set3 = LineChartDataSet(entries: valores3, label: "Pulso")*/
        set2.setColor( UIColor(red: 200.0/255.0, green: 100.0/255.0, blue: 30.0/255.0, alpha: 1.0))
        let data2 =  LineChartData(dataSets:  [set1,set2] )
        set2.lineWidth = 2
        
        set2.setCircleColor(UIColor(red: 200.0/255.0, green: 100.0/255.0, blue: 30.0/255.0, alpha: 1.0))
        set2.circleRadius = 3
        set2.circleHoleColor = NSUIColor(red: 200.0/255.0, green: 100.0/255.0, blue: 30.0/255.0, alpha: 1.0)
        
    
        self.linechart.data = data2
        
    }
}
