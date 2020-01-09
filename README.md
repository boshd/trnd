# TRND - iOS Social Network for GIFs

**Deprecated, so use @ your own risk.**

## Features

- Users can like, comment, delete and report posts
- Users can search for other users
- Support for animated images (obviously)
- Seamless onboarding
- GIPHY built-in using their dev. API

Plus a bunch of other things that I don't remember so feel free to delve into this project. Also, it's worth mentioning that this project has been depricated. I'm not moving forward with it for many reasons ranging from inefficient architecture to the discontinuation of Parse ¯\__(ツ)__/¯.

## How to run the app
### Connect to server

Since Parse was open-sourced and officialy depricated, you'll need to setup a server using services like AWS, Heroku, etc.
Choose the service of your liking and add the information to the ParseServer.swift file and you should be set.

### Run
- Open the trnd.xcworkspace in Xcode.

- Open the terminal, navigate to project folder and run "pod update".

Note before last step:<i> if you don't have cocoapods installed on your computer, you have to install it first. You can do it by opening the terminal and running "sudo gem install cocoapods". If you already have cocoapods installed, ignore this note.</i>

## Compatibility
TRND is written in Swift 4.2 and requires iOS 12.0 or later.


## License
This project is licensed under the GNU General Public License v3.0 - see the [LICENSE.md](https://github.com/kareemarab/trnd/blob/master/LICENCE.md) file for details

Permissions of this strong copyleft license are conditioned on making available complete source code of licensed works and modifications, which include larger works using a licensed work, under the same license. Copyright and license notices must be preserved. Contributors provide an express grant of patent rights.
