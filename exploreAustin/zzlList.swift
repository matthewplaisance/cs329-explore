

import UIKit

class zzlList: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "countryList"
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.zzlTableView)
        zzlTableView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(50)
            make.bottom.equalToSuperview().offset(-150)
        }
    }
    private lazy var zzlTableView : UITableView = {
        let zzlTableView = UITableView.init(frame:CGRect(x:0, y:100, width:self.view.bounds.width, height:self.view.bounds.height), style: UITableView.Style.grouped)
        zzlTableView.delegate = self
        zzlTableView.dataSource = self
        zzlTableView.backgroundColor = UIColor.white
        zzlTableView.register(zzlCell.self, forCellReuseIdentifier: "zzlCell")
        return zzlTableView
    }()
    
    private lazy var lgjsidf: Array = {
        return [["czzlame": "China","cityImg":"shanghai02"],
                ["czzlame": "Thailand","cityImg":"pujidao01"],
                ["czzlame": "Germany","cityImg":"situjiate03"]]
    }()
    
    private lazy var zzldfData: Array = {
        return [["infokey": "Located at No. 1 Century Avenue, Lujiazui, Pudong New Area, Oriental Pearl TV Tower radio and television tower, or Oriental Pearl TV Tower for short, is located on the Bank of Huangpu River, with modern buildings in Lujiazui area on its back. It interacts with the World Architecture Expo Group on the Bund across the river. Construction started on July 30, 1991, and was completed and put into use on October 1, 1994 [6]. It is a collection of urban tourism, fashion catering, shopping and entertainment, historical display, Pujiang tour, exhibition performance It is one of the landmark buildings in Shanghai with multiple functions such as radio and television transmission. As of 2019, it is the sixth tallest tower in Asia and the ninth tallest tower in the world. [5-7] [20]The main body of the Oriental Pearl TV Tower radio and television tower is a multi tube structure, consisting of three diagonal braces, three columns, a square, a tower base, a lower sphere, five small spheres, an upper sphere, a space capsule, a transmitting antenna mast, etc., with a total height of 468 meters and a total construction area of 100000 square meters. [1] [5-6] [10]In1995, the Oriental Pearl TV Tower radio and television tower was rated as one of the ten new sights in Shanghai. [9] In1999, the Oriental Pearl TV Tower radio and television tower won the first prize of excellent survey and design of Shanghai city and Zhan Tianyou prize of China civil engineering. [1] On May 8, 2007, the Oriental Pearl TV Tower radio and television tower was approved as a national AAAAA tourist attraction by the National Tourism Administration of the people's Republic of China. [8]Starting from June 1, 2022, the Oriental Pearl TV Tower TV Tower will open its garden to welcome guests. Some outdoor projects such as the 259 meter outdoor full transparent hanging sightseeing corridor and the 90 meter outdoor light corridor will be opened in advance. The business hours will be adjusted from 10:00 to 20:00 every day","timezone":"Asia/Beijing","cityImg":["shanghai01","shanghai02","shanghai03"]],
                ["infokey": "Phuket (Thai: ภเก็ต; English: Phuket), located in the southeast of the Andaman Sea in the Indian Ocean, is the only island in Thailand that has been granted provincial status. The environment on the island is pure and it is a famous holiday island. Phuket island covers an area of 576 square kilometers and has a population of 1.75 million (2004), belonging to the tropical monsoon climate.The main agricultural products of Phuket are rubber, coconut, cashew nuts and pineapple. In addition, there are shrimp farms and artificial pearl farms on the East and south banks of Phuket, but tourism is still the first source of income for Phuket Phuket Island and the Andaman coast in southern Thailand are connected by bridges.","timezone":"Asia/Bangkok","cityImg":["pujidao01","pujidao02","pujidao03"]],
                ["infokey": "Stuttgart (German: Stuttgart or translation: Stuttgart) is located in the Neckar River Valley in the central Baden Wuerttemberg state in southwest Germany, near the black forest. It is not only the state capital of the state, but also the capital of the state-level administrative region and Stuttgart region and the largest city of the state. It is also the political center of the state: the parliament, the state government, and many state government departments are all located here. Because of its economic, cultural and administrative importance, it is one of the most famous cities in Germany. In 2020, it ranked 28th in the global urban economic competitiveness ranking and 16th in the global urban sustainable competitiveness","timezone":"Europe/Berlin","cityImg":["situjiate01","situjiate02","situjiate03"]]
                ]
    }()

}
extension zzlList:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.lgjsidf.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cesdfgll:zzlCell = tableView.dequeueReusableCell(withIdentifier: "zzlCell", for: indexPath) as! zzlCell
        cesdfgll.selectionStyle = UITableViewCell.SelectionStyle.none
        cesdfgll.dataDic = lgjsidf[indexPath.row]
        return cesdfgll
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footfghhererView = UIView()
        footfghhererView.backgroundColor = UIColor.white
        return footfghhererView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let zzlMap = zzlMap()
//        let dicsdffgt: [String: Any] = zzldfData[indexPath.row]
//        zzlMap.zklgdic = dicsdffgt
//        self.navigationController?.pushViewController(zzlMap, animated: true)
        
        let zzlmiansu = zzlMIaoshuVC()
        let dicsdffgt: [String: Any] = zzldfData[indexPath.row]
        zzlmiansu.infozklgdic = dicsdffgt
        zzlmiansu.cityImgData = (dicsdffgt["cityImg"] as! [String])
        self.navigationController?.pushViewController(zzlmiansu, animated: true)
    }
}

