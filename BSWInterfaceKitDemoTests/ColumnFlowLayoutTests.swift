//
//  ColumnFlowLayoutTests.swift
//  BSWInterfaceKitDemoTests
//
//  Created by Pierluigi Cifani on 12/11/2018.
//

import BSWInterfaceKit
import XCTest

@available(iOS 11, *)
class ColumnFlowLayoutTests: BSWSnapshotTest {
    
    func testLayout() {
        let vc = ViewController()
        waitABitAndVerify(viewController: vc)
    }
}

//
//  Created by Pierluigi Cifani on 20/09/2018.
//  Copyright © 2018 The Left Bit. All rights reserved.
//

import UIKit

@available(iOS 11, *)
private class ViewController: UIViewController {
    
    let collectionView: UICollectionView = {
        return UICollectionView(
            frame: .zero,
            collectionViewLayout: ColumnFlowLayout()
        )
    }()
    
    var flowLayout: UICollectionViewFlowLayout {
        return collectionView.collectionViewLayout as! UICollectionViewFlowLayout
    }
    
    var dataSource: CollectionViewDataSource<PostCollectionViewCell>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let safeView = UIView.init()
        safeView.backgroundColor = .red
        view.addSubview(safeView)
        safeView.pinToSuperviewSafeLayoutEdges()
        
        view.backgroundColor = UIColor.lightGray
        view.addSubview(collectionView)
        
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = true
        collectionView.pinToSuperview()
        collectionView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        dataSource = .init(data: mockData, collectionView: collectionView)
    }
}

@available(iOS 11, *)
extension ViewController {
    var mockData: [PostCollectionViewCell.VM] {
        return [
            PostCollectionViewCell.VM(
                photo: Photo(url: nil),
                title: "Pork tail",
                description: "Bacon ipsum dolor amet ground round ham shoulder burgdoggen. Swine ribeye brisket pork belly bresaola strip steak ground round ham turducken capicola corned beef filet mignon jowl spare ribs",
                authorName: "Code Crafters",
                authorAvatar: Photo(url: nil)
            ),
            PostCollectionViewCell.VM(
                photo: Photo(url: nil),
                title: "Meatball",
                description: "Tenderloin frankfurter ham kielbasa short loin tri-tip kevin tongue beef ribs boudin.",
                authorName: "Code Crafters",
                authorAvatar: Photo(url: nil)
            ),
            PostCollectionViewCell.VM(
                photo: Photo(url: nil),
                title: "T-bone",
                description: "Spare ribs porchetta landjaeger pork filet mignon swine leberkas tri-tip venison pork loin alcatra turducken brisket kielba.",
                authorName: "Code Crafters",
                authorAvatar: Photo(url: nil)
            ),
            PostCollectionViewCell.VM(
                photo: Photo(url: nil),
                title: "Capicola ground round rump shank",
                description: "Biltong shankle venison swine. Doner short loin venison, alcatra buffalo beef burgdoggen. Swine beef ribs turducken, rump pig beef filet mignon landjaeger.",
                authorName: "Code Crafters",
                authorAvatar: Photo(url: nil)
            ),
            PostCollectionViewCell.VM(
                photo: Photo(url: nil),
                title: "Drumstick",
                description: "Pancetta bresaola leberkas, buffalo meatball alcatra swine chicken ham hock chuck. Ground round t-bone buffalo, strip steak meatball chuck tenderloin burgdoggen ball tip jowl fatback tongue tail.",
                authorName: "Code Crafters",
                authorAvatar: Photo(url: nil)
            )
        ]
    }
}
//
//  Created by Pierluigi Cifani on 20/09/2018.
//  Copyright © 2018 The Left Bit. All rights reserved.
//

import UIKit

private class PostCollectionViewCell: UICollectionViewCell, ViewModelReusable {
    
    private let imageView = UIImageView()
    
    private let textStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 5
        stackView.layoutMargins = UIEdgeInsets(uniform: 10)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    private let authorStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 5
        return stackView
    }()
    
    private let titleLabel = UILabel.unlimitedLinesLabel()
    private let descriptionLabel = UILabel.unlimitedLinesLabel()
    private let authorAvatar = UIImageView()
    private let authorName = UILabel.unlimitedLinesLabel()
    
    struct VM {
        let photo: Photo
        let title: String
        let description: String
        let authorName: String
        let authorAvatar: Photo
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.white
        contentView.roundCorners(radius: 5)
        
        authorAvatar.contentMode = .scaleAspectFill
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        authorStackView.addArrangedSubview(authorAvatar)
        authorStackView.addArrangedSubview(authorName)
        
        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(descriptionLabel)
        textStackView.addArrangedSubview(authorStackView)
        
        contentView.addAutolayoutSubview(imageView)
        contentView.addAutolayoutSubview(textStackView)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: textStackView.topAnchor),
            textStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            textStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.5),
            authorAvatar.widthAnchor.constraint(equalToConstant: 30),
            authorAvatar.heightAnchor.constraint(equalTo: authorAvatar.widthAnchor)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func configureFor(viewModel: VM) {
        imageView.setPhoto(viewModel.photo)
        titleLabel.attributedText = TextStyler.styler.attributedString(viewModel.title, forStyle: .subheadline).bolded
        descriptionLabel.attributedText = TextStyler.styler.attributedString(viewModel.description, color: .gray, forStyle: .footnote)
        authorName.attributedText = TextStyler.styler.attributedString(viewModel.authorName, color: .gray, forStyle: .footnote)
        authorAvatar.setPhoto(viewModel.authorAvatar)
    }
}
