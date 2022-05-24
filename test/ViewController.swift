//
//  ViewController.swift
//  test
//
//  Created by Rakhman on 15.05.2022.
//

import UIKit

struct Object: Decodable {
    var name: String = "NaN"
    var responsible: String = "NaN"
    var place: String = "NaN"
    var initial_date: Date?
    var initial_cost: Int64 = 0
    
    var current_cost: Int64 {
        Int64(initial_cost - 1000)
    }
}

struct InformationViewModel {
    let title: String
    let text: String
    let isEditable: Bool

    init(title: String, text: String, isEditable: Bool) {
        self.title = title
        self.text = text
        self.isEditable = isEditable
    }
}

class InformationView: UIView {
    // MARK: Variables
    
    private var object: Object?

    private var title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return label
    }()

    private var textView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.borderColor = Constants.Colors.ObjectBorderColor
        view.layer.borderWidth = 1
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()

    private var text: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 5
        return label
    }()

    private var button: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Edit", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.addTarget(self, action: #selector(editButtonFunction), for: .touchUpInside)
        return button
    }()

    // MARK: Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    // my initialization
    init(info: InformationViewModel) {
        super.init(frame: .zero)
        setupViews()
        self.text.text = info.text
        self.title.text = info.title
        if info.isEditable == true {
            addButton()
        }
    }

    // MARK: Methods

    public func configure(_ str: String) {
        self.text.text = str
    }
    
    public func configure(_ int: Int64) {
        self.text.text = String(int)
    }
    
    public func configure(_ date: Date) {
        self.text.text = Constants.dateFormatter.string(from: date)
    }

    @objc private func editButtonFunction() {
        print("Edit Button")
    }

    private func setupViews() {
        addSubview(title)
        addSubview(textView)
        addSubview(text)
        setupConstraints()
    }

    private func addButton() {
        addSubview(button)
        button.trailingAnchor.constraint(equalTo: text.trailingAnchor, constant: -6).isActive = true
        button.topAnchor.constraint(equalTo: title.topAnchor).isActive = true
        button.heightAnchor.constraint(equalToConstant: button.titleLabel?.frame.height ?? 30).isActive = true
    }

    private func setupConstraints() {

        title.topAnchor.constraint(equalTo: self.topAnchor, constant: 6).isActive = true
        textView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        textView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 12/13).isActive = true
        title.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 6).isActive = true

        textView.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 3).isActive = true
        textView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true

        text.topAnchor.constraint(equalTo: textView.topAnchor, constant: 5).isActive = true
        text.bottomAnchor.constraint(equalTo: textView.bottomAnchor, constant: -5).isActive = true
        text.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 8).isActive = true
        text.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: -8).isActive = true
    }
}

// MARK: ViewController
class ViewController: UIViewController {
    // MARK: Variables
    
    public var searchString: String?
    
    var obj = Object.init()
    
    lazy var informationViews = [
        InformationView.init(info: InformationViewModel(title: "Name", text: "None", isEditable: false)),
        InformationView.init(info: InformationViewModel(title: "Responsible", text: "", isEditable: true)),
        InformationView.init(info: InformationViewModel(title: "Place", text: "", isEditable: true)),
        InformationView.init(info: InformationViewModel(title: "Initial Date", text: "", isEditable: false)),
        InformationView.init(info: InformationViewModel(title: "Initial Cost", text: "", isEditable: false)),
        InformationView.init(info: InformationViewModel(title: "Current Cost", text: "", isEditable: false))
    ]
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .medium)
        ai.translatesAutoresizingMaskIntoConstraints = false
        ai.color = .white
        ai.transform = CGAffineTransform(scaleX: 2, y: 2)
        ai.backgroundColor = UIColor(white: 0, alpha: 0.7)
        ai.layer.masksToBounds = true
        ai.layer.cornerRadius = 10
//        ai.backgroundColor = .white
        return ai
    }()
    
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.Colors.ObjectBackgroundColor
        
        
        getAPI(url: "http://localhost:8080/BiLclimate07", completionHandler: isDecoded)
        setupViews()
    }
    
    // MARK: Methods
    
    func getAPI(url: String, completionHandler: @escaping (Bool) -> Void){
        print("At the start: ", Date.timeIntervalSinceReferenceDate)
        if let url = URL(string: "http://localhost:8080/getdata/BiLclimate07") {
           URLSession.shared.dataTask(with: url) { data, response, error in
               if let error = error {
                   print("Error message: ", error)
//                   completionHandler(.failure(error))
               }
               
               if let data = data {
                   do {
                       let jsonDecoder = JSONDecoder()
                       jsonDecoder.dateDecodingStrategy = .iso8601
                       self.obj = try jsonDecoder.decode(Object.self, from: data)
                       
                       DispatchQueue.main.async {
                           
                           self.informationViews[0].configure(self.obj.name)
                           self.informationViews[1].configure(self.obj.responsible)
                           self.informationViews[2].configure(self.obj.place)
                           self.informationViews[3].configure(self.obj.initial_date!)
                           self.informationViews[4].configure(self.obj.initial_cost)
                           self.informationViews[5].configure(self.obj.current_cost)
                           self.activityIndicator.stopAnimating()
                       }
                       print("Found: ", Date.timeIntervalSinceReferenceDate)
//                       completionHandler(.success(data))
                   } catch {
                       print("Error message: ", error)
//                       completionHandler(.failure(error))
                   }
               }
           }.resume()
        }
        print("After func: ", Date.timeIntervalSinceReferenceDate)
        print("After func: ", obj.name)
    }
    
    private func isDecoded(_ result: Bool) {
        
        print("Configure")
        print("In configure: ", Date.timeIntervalSinceReferenceDate)
            
        if result == false {
            
        } else {
            
        }
    }

    private func setupViews() {
        view.addSubview(activityIndicator)
        for i in 0 ..< informationViews.count {
            view.addSubview(informationViews[i])
            informationViews[i].translatesAutoresizingMaskIntoConstraints = false
        }
        setupConstraints()
    }

    private func setupConstraints() {
        for i in 0 ..< informationViews.count {
            informationViews[i].centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            informationViews[i].widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
            
            if i == 0 {
                informationViews[i].topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 6).isActive = true
            } else {
                informationViews[i].topAnchor.constraint(equalTo: informationViews[i - 1].bottomAnchor, constant: 6).isActive = true
            }
        }
        
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/8).isActive = true
        activityIndicator.heightAnchor.constraint(equalTo: activityIndicator.widthAnchor).isActive = true
        view.bringSubviewToFront(activityIndicator)
        
        activityIndicator.startAnimating()
    }

}
