//
//  DetailViewController.swift
//  Milestone1
//
//  Created by Thiago Alves on 7/9/19.
//  Copyright © 2019 Thiago Alves. All rights reserved.
//

// swiftlint:disable identifier_name

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var countryName: String?
    var imageName: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = countryName
        navigationItem.largeTitleDisplayMode = .never

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self,
                                                            action: #selector(shareTapped))

        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.lightGray.cgColor

        if let imageToLoad = imageName {
            imageView.image = UIImage(named: imageToLoad)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }

    @objc func shareTapped() {
        guard let country = countryName else {
            print("No image found")
            return
        }

        guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
            print("No image found")
            return
        }

        let vc = UIActivityViewController(activityItems: [country, image], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }

}
