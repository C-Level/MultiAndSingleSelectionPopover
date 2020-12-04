//
//  MultiAndSingleSelectionPopover.swift
//  MultiAndSingleSelectionPopover
//
//  Created by Barış Güngör on 4.12.2020.
//

import UIKit

class MultiAndSingleSelectionPopover: UIViewController {
    
    private var spacialTableView: Choice!
    
    public var inputArray: [Selectable]!
    
    public var readyArray = [Selectable]()
    
    public var titleHeader : String!
    
    public var okButtonTitle: String!
    
    public var resetButtonTitle: String!
    
    public var font: UIFont!
    
    public var barFont: UIFont!
    
    public var headerColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
    
    public var buttonsColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    
    public var selectedImage : UIImage!
    
    public var unselectedImage: UIImage!
    
    public var cellHeight : CGFloat!
    
    public var doneButton: UIBarButtonItem!
    
    public var resetButton: UIBarButtonItem!
    
    private var tobePresentController: UINavigationController!
    
    private var popover : UIPopoverPresentationController!
    
    public var selectiontype : SelectionType! = .multiple
    
    typealias ButtonListener = ((_ readyArray : [Selectable]) -> Void)
    typealias EachSelectionButtonListener = ((_ selected : Selectable) -> Void)
    public var listener : ButtonListener?
    public var eachSelectionListener : EachSelectionButtonListener?
    
    
    init(inputArray: [Selectable],
         selectionType: SelectionType,
         selectedImage: UIImage =  UIImage(systemName: "checkmark.circle.fill")!,
         unselectedImage: UIImage = UIImage(systemName: "checkmark.circle")!,
         titleHeader: String = "Uzmanlık",
         okButtonTitle: String = "Done",
         resetButtonTitle: String = "Reset",
         font: UIFont = UIFont.systemFont(ofSize: 15, weight: .regular),
         barFont:  UIFont = UIFont.systemFont(ofSize: 15, weight: .regular),
         headerColor: UIColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1),
         buttonsColor: UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),
         cellHeight: CGFloat = 60){
        
        super.init(nibName: nil, bundle: nil)
        self.inputArray = inputArray
        self.selectiontype = selectionType
        self.selectedImage = selectedImage
        self.unselectedImage = unselectedImage
        self.titleHeader = titleHeader
        self.okButtonTitle = okButtonTitle
        self.resetButtonTitle = resetButtonTitle
        self.headerColor = headerColor
        self.cellHeight = cellHeight
        self.buttonsColor = buttonsColor
        self.font = font
        self.barFont = barFont
        
        setupView()
        setupTableView()
        setButtonsAndTitle()
        setPopover()
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
            super.viewWillTransition(to: size, with: coordinator)
//            print(spacialTableView.frame.size.height)
            print(tobePresentController.preferredContentSize.height)
            if UIDevice.current.orientation.isLandscape {
                print("Landscape")
               
            } else {
                print("Portrait")
          
            }
        }

    
    func setupView(){
        self.spacialTableView = Choice(frame: self.view.frame)
        spacialTableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(spacialTableView)
        makeConstraints()
        
    }
    
    func makeConstraints(){
        NSLayoutConstraint.activate([
            spacialTableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            spacialTableView.bottomAnchor.constraint(equalTo:self.view.bottomAnchor),
            spacialTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            spacialTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        ])
        
    }
    
    private func setButtonsAndTitle(){
        
        tobePresentController = UINavigationController(rootViewController: self)
        tobePresentController.modalPresentationStyle = .popover
        tobePresentController.navigationBar.barTintColor = headerColor
        
        let textAttributes = [NSAttributedString.Key.foregroundColor: buttonsColor, NSAttributedString.Key.font : barFont!]
        
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.title = titleHeader
        
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        let navigationItem = self.navigationItem
        doneButton =  UIBarButtonItem(title: okButtonTitle, style: .plain, target: self, action: #selector(doneAction))
        resetButton = UIBarButtonItem(title: resetButtonTitle, style: .plain, target: self, action: #selector(resetAction))
        doneButton.setTitleTextAttributes(textAttributes, for: .normal)
        resetButton.setTitleTextAttributes(textAttributes, for: .normal)
        navigationItem.rightBarButtonItem = doneButton
        navigationItem.leftBarButtonItem = resetButton
    }
    
    private func setPopover(){
        popover = tobePresentController.popoverPresentationController!
        popover.delegate = self
        popover.permittedArrowDirections = .any
    }
    
    public func  hideDoneButton(){
        let navigationItem = self.navigationItem
        navigationItem.rightBarButtonItem = nil
        
    }
    
    
    public func  hideResetButton(){
        let navigationItem = self.navigationItem
        navigationItem.leftBarButtonItem = nil
        
    }
    
    
    private func setupTableView(){
          spacialTableView.delegate = self
          spacialTableView.data = inputArray
          spacialTableView.selectionType = selectiontype
          spacialTableView.cellHeight = cellHeight
          spacialTableView.arrowImage = nil
          spacialTableView.selectedImage = selectedImage
          spacialTableView.unselectedImage = unselectedImage
          spacialTableView.font = font
    
      }
    
    func showPopup(from: UIViewController, sender: UIView, size: CGSize? = nil, resultListener: @escaping ButtonListener, eachSelectionListener: @escaping EachSelectionButtonListener){
        
        
        self.listener = resultListener
        self.eachSelectionListener = eachSelectionListener
        if size != nil { tobePresentController.preferredContentSize = size! }
        popover.sourceView = sender
//        popover.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 330, height: 330)
        from.present(tobePresentController, animated: true, completion: nil)
    }
    
    @objc func resetAction(){
        
        for (index, _) in inputArray.enumerated() {
            inputArray[index].isSelected = false
        }
        
        setupTableView()
        
        spacialTableView.reload()
        
        readyArray.removeAll()
        
    }
    
    
    @objc func doneAction(){
        
        print("last: ///")
        for index in readyArray{
            print(index.title)
        }
        listener?(readyArray)
        dismiss(animated: true, completion: nil)
    }
    
    

}


extension MultiAndSingleSelectionPopover : ChoiceDelegate{
    func didSelectRowAt(indexPath: IndexPath, sender: UITableView) {
        
        
        eachSelectionListener!(spacialTableView.data[indexPath.row])
        if self.selectiontype == .multiple{
            var isRemoved = Bool()
            isRemoved = false
            
            
            
            for (index, element) in readyArray.enumerated() {
               
                
                if element.id == spacialTableView.data[indexPath.row].id{
                    readyArray.remove(at: index)
                    isRemoved = true
                }
            }
            
            if !isRemoved {
                
                readyArray.append(spacialTableView.data[indexPath.row])
            }
            
        }else{
            for (index, _) in readyArray.enumerated() {
               
                    readyArray.remove(at: index)
                    
            }
            
            readyArray.append(spacialTableView.data[indexPath.row])
        }
    }
    
}

extension MultiAndSingleSelectionPopover: UIPopoverPresentationControllerDelegate{
    
    public func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        doneAction()
        return false
    }
    
    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    public func popoverPresentationController(_ popoverPresentationController: UIPopoverPresentationController, willRepositionPopoverTo rect: UnsafeMutablePointer<CGRect>, in view: AutoreleasingUnsafeMutablePointer<UIView>){
        
        
        
    }
    
}
