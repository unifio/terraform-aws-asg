## 0.1.1 (Dec 1, 2015)

#### IMPROVEMENTS:
* Updated template_file usage for 0.6.7 to remove deprecation warnings [GH-9]
* Added ASG name to module outputs [GH-8]
* Added default Name tag to auto scaling groups [GH-6]

#### BUG FIXES:
* Updated lifecycle hooks to prevent dependency cycles during destroy [GH-5]
* Added proper lifecycle management to allow launch configuration updates [GH-2]
* Removed `sg-` from ASG security group name [GH-1]

## 0.1.0 (Oct 26, 2015)

* Initial Release
