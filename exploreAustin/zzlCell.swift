

import UIKit

class zzlCell: UITableViewCell {
    
    lazy var IcsxvgonView:UIImageView = {
        let IcsxvgonView = UIImageView()
        return IcsxvgonView
    }()
    
    
    
    func slgfmiew(){
        
        self.addSubview(self.IcsxvgonView)
        self.IcsxvgonView.image = UIImage(named: "iconTwo")
        self.IcsxvgonView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.left.equalToSuperview().offset(20)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        self.addSubview(self.czzlame)
        self.czzlame.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(70)
            make.top.equalToSuperview().offset(0)
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    lazy var czzlame : UILabel = {
        let czzlame = UILabel()
        czzlame.font = UIFont.systemFont(ofSize: 19)
        czzlame.textColor = UIColor.red
        return czzlame
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        slgfmiew()
    }
    
    var dataDic:[String:String]?{
        didSet {
            self.czzlame.text = dataDic?["czzlame"]
            self.IcsxvgonView.image = UIImage(named: (dataDic?["cityImg"])!)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    
    }
    
}
