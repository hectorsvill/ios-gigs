//
//  GigDetailViewController.swift
//  gigs
//
//  Created by Hector Steven on 5/9/19.
//  Copyright © 2019 Hector Steven. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
        descriptionTextView.text = ""
		setupViews()
    }
	
	@objc func save() {
		guard let description = descriptionTextView.text,
			let title = jobTitleTextField.text,
				!description.isEmpty, !title.isEmpty else {
					
			//return alert
			print("empty fields")
			return
		}
		
		let newgig = Gig(title: title, description: description, dueDate: datePicker.date)
		if gigController.isDuplicate(newgig: newgig) {
			duplicateGigAlert()
		} else {
			gigController.creatGig(gig: newgig) { error in
				
				if let error = error {
					print("error creating gig: \(error)")
				} else {
					DispatchQueue.main.async {
						self.navigationController?.popViewController(animated: true)
					}
				}
				
			}
		}
		
		
		
	}
	
	func duplicateGigAlert() {
		let alertController = UIAlertController(title: "Duplicate gig", message: "Please change Title", preferredStyle: .actionSheet)
		alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
			self.jobTitleTextField?.text = ""
		}))
		present(alertController, animated: true)
		
	}
	
	func setupViews() {
		guard let gig = gig else { return }
		descriptionTextView?.text = gig.description
		jobTitleTextField?.text = gig.title
	}

	@IBOutlet var descriptionTextView: UITextView!
	@IBOutlet var jobTitleTextField: UITextField!
	@IBOutlet var datePicker: UIDatePicker!
	var gigController: GigController!
	var gig: Gig? {
		didSet {
			setupViews()
		}
	}
	
}
