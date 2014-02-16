# TiImageManipulator

Image manipulator module for Titanium 3.2 (only iOS)

## Usage

See `example/app.js`

## Download the compiled release

* [iOS 1.0 (Compatible Titanium 3.2.x)](https://github.com/ryugoo/TiImageManipulator/tree/master/dist)

## Feature (Current release)

* Resize image<br />Ti.Blob.imageAsResized is **BROKEN!** This module provide alternate resize method!

## Sample code

```javascript
var TiImageManipulator = require('net.imthinker.ti.imagemanipulator');
var resized_blob = TiImageManipulator.resizeImage({
    image: <YOUR IMAGE BLOB>,
    width: 160,
    height: 160,
    keepAspect: true // If you want to keep aspect ratio
});
```

## License

See `LICENSE` file