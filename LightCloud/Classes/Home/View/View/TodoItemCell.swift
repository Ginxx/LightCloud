//
//  TodoItemCell.swift
//  LightCloud
//
//  Created by GorXion on 2018/5/23.
//  Copyright © 2018年 gaoX. All rights reserved.
//

import UIKit
import RxSwift

class TodoItemCell: UITableViewCell {
    
    lazy var followButton: UIButton = {
        UIButton(type: .custom).chain
            .image(#imageLiteral(resourceName: "unlike"), for: .normal)
            .image(#imageLiteral(resourceName: "like"), for: .selected)
            .systemFont(ofSize: 14).build
    }()
    
    var disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        addSubview(followButton)
        followButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(24)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 44, height: 44))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TodoItemCell: Updatable {
    
    func update(_ item: LCObject) {
        textLabel?.text = (item.value(forKey: "name") as? LCString)?.value
        followButton.isSelected = (item.value(forKey: "follow") as? LCBool)!.value
    }
}