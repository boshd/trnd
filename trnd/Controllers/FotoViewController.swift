/*
//  FotoViewController.swift
//  NextLevel (http://nextlevel.engineering/)
//
//  Copyright (c) 2016-present patrick piemonte (http://patrickpiemonte.com)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit
import AVFoundation
import Photos
import NextLevel

var CameraViewControllerAlbumTitle = "gif.t"

class FotoViewController: UIViewController {
    
    // MARK: - UIViewController
    override public var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - properties
    
    internal var previewView: UIView?
    internal var gestureView: UIView?
    internal var focusView: FocusIndicatorView?
    internal var controlDockView: UIView?
    
    internal var recordButton: UIButton?
    internal var flipButton: UIButton?
    internal var flashButton: UIButton?
    internal var saveButton: UIButton?
    
    internal var longPressGestureRecognizer: UILongPressGestureRecognizer?
    internal var photoTapGestureRecognizer: UITapGestureRecognizer?
    internal var focusTapGestureRecognizer: UITapGestureRecognizer?
    internal var flipDoubleTapGestureRecognizer: UITapGestureRecognizer?
    
    internal var _panStartPoint: CGPoint = .zero
    internal var _panStartZoom: CGFloat = 0.0
    
    @IBOutlet weak var blackView: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var images: [UIImage] = []
    var animatedImage: UIImage!
    
    // MARK: - object lifecycle
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    deinit {
    }
    
    @IBAction func captureAction(_ sender: Any) {
        NextLevel.shared.captureMode = NextLevelCaptureMode.photo
        takePhoto { (success) -> Void in
            if success {
                // do second task if success
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 10.0, execute: {
                    NavigationManager.showFotoPreviewViewController(withPresenter: self, withFotos: self.images)
                    self.endCapture()
                })
            }
        }
        //DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {

        //})
        
    }
    
    func takeTakePhoto() {
        self.view.bringSubview(toFront: blackView)
        self.view.bringSubview(toFront: indicator)
        blackView.isHidden = false
        indicator.isHidden = false
        indicator.startAnimating()
        NextLevel.shared.captureMode = NextLevelCaptureMode.photo
        takePhoto { (success) -> Void in
            if success {
                // do second task if success
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                    NavigationManager.showFotoPreviewViewController(withPresenter: self, withFotos: self.images)
                    self.endCapture()
                })
            }
        }
        //DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
        
        //})
    }
    @IBOutlet weak var captureButton: UIButton!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        blackView.isHidden = true
        indicator.isHidden = true
    }
    
    // MARK: - view lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        images = []
        blackView.isHidden = true
        indicator.isHidden = true
        self.view.backgroundColor = UIColor.black
        self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let screenBounds = UIScreen.main.bounds
        
        // preview
        self.previewView = UIView(frame: screenBounds)
        if let previewView = self.previewView {
            previewView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            previewView.backgroundColor = UIColor.black
            NextLevel.shared.previewLayer.frame = previewView.bounds
            previewView.layer.addSublayer(NextLevel.shared.previewLayer)
            self.view.addSubview(previewView)
        }
        
        self.focusView = FocusIndicatorView(frame: .zero)
        
        // buttons
        self.recordButton = UIButton(type: .custom)
        //self.longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGestureRecognizer(_:)))
        if let recordButton = self.recordButton {
            recordButton.setImage(UIImage(named: "record_button"), for: .normal)
            recordButton.isUserInteractionEnabled = true
            recordButton.sizeToFit()
            recordButton.addTarget(self, action: #selector(takeTakePhoto), for: .touchUpInside)
        }
        
        self.flipButton = UIButton(type: .custom)
        if let flipButton = self.flipButton {
            flipButton.setImage(UIImage(named: "flip_button"), for: .normal)
            flipButton.sizeToFit()
            flipButton.addTarget(self, action: #selector(handleFlipButton(_:)), for: .touchUpInside)
            
        }
        
        /*
        self.saveButton = UIButton(type: .custom)
        if let saveButton = self.saveButton {
            saveButton.setImage(UIImage(named: "save_button"), for: .normal)
            saveButton.sizeToFit()
            saveButton.addTarget(self, action: #selector(handleSaveButton(_:)), for: .touchUpInside)
        }
        */
        // capture control "dock"
        let controlDockHeight = screenBounds.height * 0.2
        self.controlDockView = UIView(frame: CGRect(x: 0, y: screenBounds.height - controlDockHeight, width: screenBounds.width, height: controlDockHeight))
        if let controlDockView = self.controlDockView {
            controlDockView.backgroundColor = UIColor.clear
            controlDockView.autoresizingMask = [.flexibleTopMargin]
            self.view.addSubview(controlDockView)
            
            if let recordButton = self.recordButton {
                recordButton.center = CGPoint(x: controlDockView.bounds.midX, y: controlDockView.bounds.midY)
                controlDockView.addSubview(recordButton)
            }
            
            if let flipButton = self.flipButton, let recordButton = self.recordButton {
                flipButton.center = CGPoint(x: recordButton.center.x + controlDockView.bounds.width * 0.25 + flipButton.bounds.width * 0.5, y: recordButton.center.y)
                controlDockView.addSubview(flipButton)
            }
            /*
            if let saveButton = self.saveButton, let recordButton = self.recordButton {
                saveButton.center = CGPoint(x: controlDockView.bounds.width * 0.25 - saveButton.bounds.width * 0.5, y: recordButton.center.y)
                controlDockView.addSubview(saveButton)
            }
            */
        }
        
        // gestures
        self.gestureView = UIView(frame: screenBounds)
        if let gestureView = self.gestureView, let controlDockView = self.controlDockView {
            gestureView.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
            gestureView.frame.size.height -= controlDockView.frame.height
            gestureView.backgroundColor = .clear
            self.view.addSubview(gestureView)
            
            self.focusTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleFocusTapGestureRecognizer(_:)))
            if let focusTapGestureRecognizer = self.focusTapGestureRecognizer {
                focusTapGestureRecognizer.delegate = self
                focusTapGestureRecognizer.numberOfTapsRequired = 1
                gestureView.addGestureRecognizer(focusTapGestureRecognizer)
            }
        }
        
        // Configure NextLevel by modifying the configuration ivars
        let nextLevel = NextLevel.shared
        nextLevel.delegate       = self
        nextLevel.deviceDelegate = self
        nextLevel.flashDelegate  = self
        nextLevel.videoDelegate  = self
        nextLevel.photoDelegate  = self
        
        // video configuration
        nextLevel.videoConfiguration.bitRate = 20000
        nextLevel.videoConfiguration.scalingMode = AVVideoScalingModeResizeAspectFill
        
        // audio configuration
        nextLevel.audioConfiguration.bitRate = 96000
        
        //self.view.bringSubview(toFront: self.captureButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        blackView.isHidden = true
        indicator.isHidden = true
        let nextLevel = NextLevel.shared
        if nextLevel.authorizationStatus(forMediaType: AVMediaTypeVideo) == .authorized &&
            nextLevel.authorizationStatus(forMediaType: AVMediaTypeAudio) == .authorized {
            do {
                try nextLevel.start()
            } catch {
                print("NextLevel, failed to start camera session")
            }
        } else {
            nextLevel.requestAuthorization(forMediaType: AVMediaTypeVideo)
            nextLevel.requestAuthorization(forMediaType: AVMediaTypeAudio)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NextLevel.shared.stop()
    }
    
}

// MARK: - library
extension FotoViewController {
    
    internal func albumAssetCollection(withTitle title: String) -> PHAssetCollection? {
        let predicate = NSPredicate(format: "localizedTitle = %@", title)
        let options = PHFetchOptions()
        options.predicate = predicate
        let result = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: options)
        if result.count > 0 {
            return result.firstObject
        }
        return nil
    }
    
}

// MARK: - capture
extension FotoViewController {
    
    func navigate() {
        NavigationManager.showFotoPreviewViewController(withPresenter: self, withFotos: images)
    }
    
    internal func takePhoto(completion: (_ success: Bool) -> Void) {
        for i in 0...3 {
            NextLevel.shared.capturePhoto()
        }
        
        // Call completion, when finished, success or faliure
        completion(true)
    }

    
    internal func startCapture() {
        self.photoTapGestureRecognizer?.isEnabled = false
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseInOut, animations: {
            self.recordButton?.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }) { (completed: Bool) in
        }
        NextLevel.shared.record()
    }
    
    internal func pauseCapture() {
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
            self.recordButton?.transform = .identity
        }) { (completed: Bool) in
        }
        NextLevel.shared.pause()
    }
    
    internal func endCapture() {
        self.photoTapGestureRecognizer?.isEnabled = true
        
        if let session = NextLevel.shared.session {
            
            if session.clips.count > 1 {
                NextLevel.shared.session?.mergeClips(usingPreset: AVAssetExportPresetHighestQuality, completionHandler: { (url: URL?, error: Error?) in
                    if let videoUrl = url {
                        self.saveVideo(withURL: videoUrl)
                    } else if let _ = error {
                        print("failed to merge clips at the end of capture \(String(describing: error))")
                    }
                })
            } else {
                if let videoUrl = NextLevel.shared.session?.lastClipUrl {
                    self.saveVideo(withURL: videoUrl)
                } else {
                    // prompt that the video has been saved
                    //let alertController = UIAlertController(title: "Something failed!", message: "Something failed!", preferredStyle: .alert)
                    //let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    //alertController.addAction(okAction)
                    //self.present(alertController, animated: true, completion: nil)
                }
            }
            
        }
        
    }
    
    internal func saveVideo(withURL url: URL) {
        PHPhotoLibrary.shared().performChanges({
            let albumAssetCollection = self.albumAssetCollection(withTitle: CameraViewControllerAlbumTitle)
            if albumAssetCollection == nil {
                let changeRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: CameraViewControllerAlbumTitle)
                let _ = changeRequest.placeholderForCreatedAssetCollection
            }}, completionHandler: { (success1: Bool, error1: Error?) in
                if let albumAssetCollection = self.albumAssetCollection(withTitle: CameraViewControllerAlbumTitle) {
                    PHPhotoLibrary.shared().performChanges({
                        if let assetChangeRequest = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url) {
                            let assetCollectionChangeRequest = PHAssetCollectionChangeRequest(for: albumAssetCollection)
                            let enumeration: NSArray = [assetChangeRequest.placeholderForCreatedAsset!]
                            assetCollectionChangeRequest?.addAssets(enumeration)
                        }
                    }, completionHandler: { (success2: Bool, error2: Error?) in
                        if success2 == true {
                            // prompt that the video has been saved
                            let alertController = UIAlertController(title: "Video Saved!", message: "Saved to the camera roll.", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alertController.addAction(okAction)
                            self.present(alertController, animated: true, completion: nil)
                        } else {
                            // prompt that the video has been saved
                            ///let alertController = UIAlertController(title: "Something failed!", message: "Something failed!", preferredStyle: .alert)
                            //let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            //alertController.addAction(okAction)
                            //self.present(alertController, animated: true, completion: nil)
                        }
                    })
                }
        })
    }
}

// MARK: - UIButton
extension FotoViewController {
    
    internal func handleFlipButton(_ button: UIButton) {
        NextLevel.shared.flipCaptureDevicePosition()
    }
    
    internal func handleFlashModeButton(_ button: UIButton) {
    }
    
    internal func handleSaveButton(_ button: UIButton) {
        self.endCapture()
    }
    
}

// MARK: - UIGestureRecognizerDelegate
extension FotoViewController: UIGestureRecognizerDelegate {
    
    internal func handleLongPressGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            self.startCapture()
            self._panStartPoint = gestureRecognizer.location(in: self.view)
            self._panStartZoom = CGFloat(NextLevel.shared.videoZoomFactor)
            break
        case .changed:
            let newPoint = gestureRecognizer.location(in: self.view)
            let scale = (self._panStartPoint.y / newPoint.y)
            let newZoom = (scale * self._panStartZoom)
            NextLevel.shared.videoZoomFactor = Float(newZoom)
            break
        case .ended:
            fallthrough
        case .cancelled:
            fallthrough
        case .failed:
            self.pauseCapture()
            fallthrough
        default:
            break
        }
    }
}

extension FotoViewController {
    
    internal func handlePhotoTapGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) {
        // play system camera shutter sound
        AudioServicesPlaySystemSoundWithCompletion(SystemSoundID(1108), nil)
        NextLevel.shared.capturePhotoFromVideo()
    }
    
    internal func handleFocusTapGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) {
        let tapPoint = gestureRecognizer.location(in: self.previewView)
        
        if let focusView = self.focusView {
            var focusFrame = focusView.frame
            focusFrame.origin.x = CGFloat((tapPoint.x - (focusFrame.size.width * 0.5)).rounded())
            focusFrame.origin.y = CGFloat((tapPoint.y - (focusFrame.size.height * 0.5)).rounded())
            focusView.frame = focusFrame
            
            self.previewView?.addSubview(focusView)
            focusView.startAnimation()
        }
        
        let adjustedPoint = NextLevel.shared.previewLayer.captureDevicePointOfInterest(for: tapPoint)
        NextLevel.shared.focusExposeAndAdjustWhiteBalance(atAdjustedPoint: adjustedPoint)
    }
    
}

// MARK: - NextLevelDelegate
extension FotoViewController: NextLevelDelegate {
    
    // permission
    func nextLevel(_ nextLevel: NextLevel, didUpdateAuthorizationStatus status: NextLevelAuthorizationStatus, forMediaType mediaType: String) {
        print("NextLevel, authorization updated for media \(mediaType) status \(status)")
        if nextLevel.authorizationStatus(forMediaType: AVMediaTypeVideo) == .authorized &&
            nextLevel.authorizationStatus(forMediaType: AVMediaTypeAudio) == .authorized {
            do {
                try nextLevel.start()
            } catch {
                print("NextLevel, failed to start camera session")
            }
        } else if status == .notAuthorized {
            // gracefully handle when audio/video is not authorized
            print("NextLevel doesn't have authorization for audio or video")
        }
    }
    
    // configuration
    func nextLevel(_ nextLevel: NextLevel, didUpdateVideoConfiguration videoConfiguration: NextLevelVideoConfiguration) {
    }
    
    func nextLevel(_ nextLevel: NextLevel, didUpdateAudioConfiguration audioConfiguration: NextLevelAudioConfiguration) {
    }
    
    // session
    func nextLevelSessionWillStart(_ nextLevel: NextLevel) {
        print("nextLevelSessionWillStart")
    }
    
    func nextLevelSessionDidStart(_ nextLevel: NextLevel) {
        print("nextLevelSessionDidStart")
    }
    
    func nextLevelSessionDidStop(_ nextLevel: NextLevel) {
        print("nextLevelSessionDidStop")
    }
    
    // interruption
    func nextLevelSessionWasInterrupted(_ nextLevel: NextLevel) {
    }
    
    func nextLevelSessionInterruptionEnded(_ nextLevel: NextLevel) {
    }
    
    // preview
    func nextLevelWillStartPreview(_ nextLevel: NextLevel) {
    }
    
    func nextLevelDidStopPreview(_ nextLevel: NextLevel) {
    }
    
    // mode
    func nextLevelCaptureModeWillChange(_ nextLevel: NextLevel) {
    }
    
    func nextLevelCaptureModeDidChange(_ nextLevel: NextLevel) {
    }
    
}

extension FotoViewController: NextLevelDeviceDelegate {
    
    // position, orientation
    func nextLevelDevicePositionWillChange(_ nextLevel: NextLevel) {
    }
    
    func nextLevelDevicePositionDidChange(_ nextLevel: NextLevel) {
    }
    
    func nextLevel(_ nextLevel: NextLevel, didChangeDeviceOrientation deviceOrientation: NextLevelDeviceOrientation) {
    }
    
    // format
    func nextLevel(_ nextLevel: NextLevel, didChangeDeviceFormat deviceFormat: AVCaptureDeviceFormat) {
    }
    
    // aperture
    func nextLevel(_ nextLevel: NextLevel, didChangeCleanAperture cleanAperture: CGRect) {
    }
    
    // focus, exposure, white balance
    func nextLevelWillStartFocus(_ nextLevel: NextLevel) {
    }
    
    func nextLevelDidStopFocus(_  nextLevel: NextLevel) {
        if let focusView = self.focusView {
            if focusView.superview != nil {
                focusView.stopAnimation()
            }
        }
    }
    
    func nextLevelWillChangeExposure(_ nextLevel: NextLevel) {
    }
    
    func nextLevelDidChangeExposure(_ nextLevel: NextLevel) {
        if let focusView = self.focusView {
            if focusView.superview != nil {
                focusView.stopAnimation()
            }
        }
    }
    
    func nextLevelWillChangeWhiteBalance(_ nextLevel: NextLevel) {
    }
    
    func nextLevelDidChangeWhiteBalance(_ nextLevel: NextLevel) {
    }
    
}

// MARK: - NextLevelFlashDelegate
extension FotoViewController: NextLevelFlashAndTorchDelegate {
    
    func nextLevelDidChangeFlashMode(_ nextLevel: NextLevel) {
    }
    
    func nextLevelDidChangeTorchMode(_ nextLevel: NextLevel) {
    }
    
    func nextLevelFlashActiveChanged(_ nextLevel: NextLevel) {
    }
    
    func nextLevelTorchActiveChanged(_ nextLevel: NextLevel) {
    }
    
    func nextLevelFlashAndTorchAvailabilityChanged(_ nextLevel: NextLevel) {
    }
    
}

// MARK: - NextLevelVideoDelegate
extension FotoViewController: NextLevelVideoDelegate {
    func nextLevel(_ nextLevel: NextLevel, willProcessRawVideoSampleBuffer sampleBuffer: CMSampleBuffer) {
    }
    
    // video zoom
    func nextLevel(_ nextLevel: NextLevel, didUpdateVideoZoomFactor videoZoomFactor: Float) {
    }
    
    // video frame processing
    func nextLevel(_ nextLevel: NextLevel, willProcessRawVideoSampleBuffer sampleBuffer: CMSampleBuffer, onQueue queue: DispatchQueue) {
    }
    
    // enabled by isCustomContextVideoRenderingEnabled
    func nextLevel(_ nextLevel: NextLevel, renderToCustomContextWithImageBuffer imageBuffer: CVPixelBuffer, onQueue queue: DispatchQueue) {
    }
    
    // video recording session
    func nextLevel(_ nextLevel: NextLevel, didSetupVideoInSession session: NextLevelSession) {
        //        print("setup video")
    }
    
    func nextLevel(_ nextLevel: NextLevel, didSetupAudioInSession session: NextLevelSession) {
        //        print("setup audio")
    }
    
    func nextLevel(_ nextLevel: NextLevel, didStartClipInSession session: NextLevelSession) {
    }
    
    func nextLevel(_ nextLevel: NextLevel, didCompleteClip clip: NextLevelClip, inSession session: NextLevelSession) {
    }
    
    func nextLevel(_ nextLevel: NextLevel, didAppendVideoSampleBuffer sampleBuffer: CMSampleBuffer, inSession session: NextLevelSession) {
    }
    
    func nextLevel(_ nextLevel: NextLevel, didAppendAudioSampleBuffer sampleBuffer: CMSampleBuffer, inSession session: NextLevelSession) {
    }
    
    func nextLevel(_ nextLevel: NextLevel, didSkipVideoSampleBuffer sampleBuffer: CMSampleBuffer, inSession session: NextLevelSession) {
    }
    
    func nextLevel(_ nextLevel: NextLevel, didSkipAudioSampleBuffer sampleBuffer: CMSampleBuffer, inSession session: NextLevelSession) {
    }
    
    func nextLevel(_ nextLevel: NextLevel, didCompleteSession session: NextLevelSession) {
        // called when a configuration time limit is specified
        self.endCapture()
    }
    
    // video frame photo
    func nextLevel(_ nextLevel: NextLevel, didCompletePhotoCaptureFromVideoFrame photoDict: [String : Any]?) {
        
        if let dictionary = photoDict,
            let photoData = dictionary[NextLevelPhotoJPEGKey] {
            
            PHPhotoLibrary.shared().performChanges({
                
                let albumAssetCollection = self.albumAssetCollection(withTitle: CameraViewControllerAlbumTitle)
                if albumAssetCollection == nil {
                    let changeRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: CameraViewControllerAlbumTitle)
                    let _ = changeRequest.placeholderForCreatedAssetCollection
                }
                
            }, completionHandler: { (success1: Bool, error1: Error?) in
                
                if success1 == true {
                    if let albumAssetCollection = self.albumAssetCollection(withTitle: CameraViewControllerAlbumTitle) {
                        PHPhotoLibrary.shared().performChanges({
                            if let data = photoData as? Data,
                                let photoImage = UIImage(data: data) {
                                
                                    //PostService.createPostWith(data as NSData, title: "photo", successBlock: {
                                    ///    print("Posted")
                                    //})
                                
                                    let assetChangeRequest = PHAssetChangeRequest.creationRequestForAsset(from: photoImage)
                                    let assetCollectionChangeRequest = PHAssetCollectionChangeRequest(for: albumAssetCollection)
                                    let enumeration: NSArray = [assetChangeRequest.placeholderForCreatedAsset!]
                                    assetCollectionChangeRequest?.addAssets(enumeration)
                                }
                        }, completionHandler: { (success2: Bool, error2: Error?) in
                            if success2 == true {
                                let alertController = UIAlertController(title: "Photo Saved!", message: "Saved to the camera roll.", preferredStyle: .alert)
                                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                alertController.addAction(okAction)
                                self.present(alertController, animated: true, completion: nil)
                            }
                        })
                    }
                } else if let _ = error1 {
                    print("failure capturing photo from video frame \(String(describing: error1))")
                }
                
            })
            
        }
        
    }
    
}

// MARK: - NextLevelPhotoDelegate
extension FotoViewController: NextLevelPhotoDelegate {
    
    // photo
    func nextLevel(_ nextLevel: NextLevel, willCapturePhotoWithConfiguration photoConfiguration: NextLevelPhotoConfiguration) {
    }
    
    func nextLevel(_ nextLevel: NextLevel, didCapturePhotoWithConfiguration photoConfiguration: NextLevelPhotoConfiguration) {
    }
    
    func nextLevel(_ nextLevel: NextLevel, didProcessPhotoCaptureWith photoDict: [String : Any]?, photoConfiguration: NextLevelPhotoConfiguration) {
        
        if let dictionary = photoDict,
            let photoData = dictionary[NextLevelPhotoJPEGKey] {
            
            PHPhotoLibrary.shared().performChanges({
                
                let albumAssetCollection = self.albumAssetCollection(withTitle: CameraViewControllerAlbumTitle)
                if albumAssetCollection == nil {
                    let changeRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: CameraViewControllerAlbumTitle)
                    let _ = changeRequest.placeholderForCreatedAssetCollection
                }
                
            }, completionHandler: { (success1: Bool, error1: Error?) in
                
                if success1 == true {
                    if let albumAssetCollection = self.albumAssetCollection(withTitle: CameraViewControllerAlbumTitle) {
                        PHPhotoLibrary.shared().performChanges({
                            if let data = photoData as? Data,
                                let photoImage = UIImage(data: data) {
                                
                                self.images.append(photoImage)
                                
                                let assetChangeRequest = PHAssetChangeRequest.creationRequestForAsset(from: photoImage)
                                let assetCollectionChangeRequest = PHAssetCollectionChangeRequest(for: albumAssetCollection)
                                let enumeration: NSArray = [assetChangeRequest.placeholderForCreatedAsset!]
                                assetCollectionChangeRequest?.addAssets(enumeration)
                            }
                        }, completionHandler: { (success2: Bool, error2: Error?) in
                            if success2 == true {
                                print("PHOTO SAVED YO!!")
                    
                                
                                //let alertController = UIAlertController(title: "Photo Saved!!", message: "Saved to the camera roll.", preferredStyle: .alert)
                                //let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                //alertController.addAction(okAction)
                                //self.present(alertController, animated: true, completion: nil)
                            }
                        })
                    }
                } else if let _ = error1 {
                    print("failure capturing photo from video frame \(String(describing: error1))")
                }
                
            })
            
        }
        
    }
    
    func nextLevel(_ nextLevel: NextLevel, didProcessRawPhotoCaptureWith photoDict: [String : Any]?, photoConfiguration: NextLevelPhotoConfiguration) {
    }
    
    func nextLevelDidCompletePhotoCapture(_ nextLevel: NextLevel) {
    }
    
}

// MARK: - KVO
private var CameraViewControllerNextLevelCurrentDeviceObserverContext = "CameraViewControllerNextLevelCurrentDeviceObserverContext"

extension FotoViewController {
    
    internal func addKeyValueObservers() {
        self.addObserver(self, forKeyPath: "currentDevice", options: [.new], context: &CameraViewControllerNextLevelCurrentDeviceObserverContext)
    }
    
    internal func removeKeyValueObservers() {
        self.removeObserver(self, forKeyPath: "currentDevice")
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &CameraViewControllerNextLevelCurrentDeviceObserverContext {
            //self.captureDeviceDidChange()
        }
    }
    
}
*/
