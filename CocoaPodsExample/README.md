# CocoaPodsExample

Tutorial on adding CocoaPods to exiting Xcode project. To set up CocoaPods on Mountain Lion:

* Launch Terminal
* Run **ruby -v** to ensure Ruby is installed
* Enter **sudo gem update --system** 
* Enter **sudo gem install cocoapods**
* Enter **pod setup**

You should see a confirmation that looks something like this:

	Setting up CocoaPods master repo
	Cloning spec repo `master' from `https://github.com/CocoaPods/Specs.git' (branch `master')
	Setup completed (read-only access)
	
_NOTE:_ You should exit Xcode before running "pod install" or you may get a warning that an
external application has modified the workspace. If this happens, choose "Revert"
to save the changes applied by Cocoapods to the Xcode workspace.

