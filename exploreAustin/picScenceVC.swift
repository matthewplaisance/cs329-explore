
import UIKit

class picScenceVC: UIViewController,UIScrollViewDelegate {
//    zzlMIaoshuVC
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var themeLbl: UILabel!
    @IBOutlet weak var scrollerView: UIScrollView!
    @IBOutlet weak var dscLbl: UITextView!
    @IBOutlet weak var time: UILabel!
    var infozklgdic:[String:Any]?
    var cityImgData:[String]?
    var dscTxtData:[String]?
    var themeTxtData:[String]?
    var locafgdltimer :Timer!
    
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationItem.title = "Introduction"
//        cityImg.image = UIImage(named: "069164_png")
        time.text = "Time"
        
        let dscName:String = dscTxtData?[0] ?? ""
        dscLbl.text = dscName
        
        let themeName:String = themeTxtData?[0] ?? ""
        themeLbl.text = themeName
        
        locafgdltimer=Timer.scheduledTimer(timeInterval:1, target:self, selector:#selector(timelocals), userInfo:nil, repeats:true)
        scrollerView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(0)
            make.top.equalToSuperview().offset(0)
            make.width.equalTo(self.view.bounds.width)
            make.height.equalTo(170)
        }
        
        let width:Int = Int(scrollerView.frame.width)
        let height:Int = Int(scrollerView.frame.height)
        

        for i in 1..<(cityImgData!.count+1){
            print(i)
            let imageName:String = cityImgData?[i-1] ?? ""
            let xva = (i - 1) * width
            let imageView = UIImageView.init(frame: CGRect(x:CGFloat(xva), y:0, width:CGFloat(width), height:CGFloat(height)))
//            imageView.contentMode = scaleAspectFill
            imageView.image = UIImage(named: imageName)
            scrollerView.addSubview(imageView)
        }
        scrollerView.isPagingEnabled = true
        scrollerView.contentSize = CGSize(width: CGFloat(cityImgData!.count * width), height: 0)

        pageControl.numberOfPages = cityImgData!.count
        pageControl.currentPage = 0
        self.addScrollTimer()
        scrollerView.bringSubviewToFront(pageControl)
        // Do any additional setup after loading the view.
    }
    
    
    func addScrollTimer(){
        timer = Timer.scheduledTimer(timeInterval:3.0, target:self, selector:#selector(nextPage), userInfo:nil, repeats:true)
    }
    
    // 移除时间计时器
    func removeScrollTimer(){
        
        timer.invalidate()
        timer = nil
    }
    @objc func nextPage(){
        
        var currentPage = CGFloat(pageControl.currentPage)
        currentPage += 1
        if currentPage == 10 {
            currentPage = 0
        }
        let width:CGFloat = scrollerView.frame.width
        let offset:CGPoint = CGPoint(x: CGFloat(currentPage * width), y: 0)
        
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.scrollerView.contentOffset = offset
        })
        pageControl.currentPage = Int(currentPage)
        let dscName:String = dscTxtData?[Int(currentPage)] ?? ""
              dscLbl.text = dscName
        
        let themeName:String = themeTxtData?[Int(currentPage)] ?? ""
        themeLbl.text = themeName
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset:CGPoint = self.scrollerView.contentOffset
        let offsetX:CGFloat = offset.x;
        let width:CGFloat = self.scrollerView.frame.width
        self.pageControl.currentPage = (Int(offsetX + 0.5 * width) / Int(width))
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        removeScrollTimer()
    }
    
    @IBAction func clickBack(_ sender: Any) {
        dismiss(animated: true)
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        addScrollTimer()
//        let offset:CGPoint = self.scrollerView.contentOffset
//        let offsetX:CGFloat = offset.x;
//        let width:CGFloat = self.scrollerView.frame.width
//        self.pageControl.currentPage = (Int(offsetX + 0.5 * width) / Int(width))
        
//        let dscName:String = dscTxtData?[self.pageControl.currentPage] ?? ""
//        dscLbl.text = dscName
//
    }
    
    @objc func timelocals(){
        
//        let timhheStr = TimeZone.init(identifier: infozklgdic?["timezone"] as! String)
        let fokgtter = DateFormatter()
        fokgtter.dateFormat = "YYYY-MM-dd HH:mm:ss"
//        fokgtter.timeZone = timhheStr
        let datgfdgime = fokgtter.string(from: Date.init())
        time.text = datgfdgime
        
    }


}
