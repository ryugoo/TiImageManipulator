(function () {
    'use strict';
    var TiImageManipulator = require('net.imthinker.ti.imagemanipulator');
    Ti.API.info('module is => ' + TiImageManipulator);

    var win = Ti.UI.createWindow({
        backgroundColor: '#FFFFFF'
    });
    win.addEventListener('open', function () {
        var image_file = Ti.Filesystem.getFile(Ti.Filesystem.resourcesDirectory, 'sample.jpg'),
            image_blob = image_file.read();

        /* Ti.API.debug('blob is => ' + image_blob);
        Ti.API.debug('path is => ' + image_blob.nativePath);
        Ti.API.debug('width is => ' + image_blob.width);
        Ti.API.debug('height is => ' + image_blob.height);
        Ti.API.debug('mimetype is => ' + image_blob.mimeType);
        Ti.API.debug('filesize is => ' + image_blob.size); */

        var resized_blob = TiImageManipulator.resizeImage({
            image: image_blob,
            width: 160,
            height: 160,
            keepAspect: true
        });

        var file = Ti.Filesystem.createTempFile();
        file.write(resized_blob);

        Ti.API.debug('blob is => ' + resized_blob);
        Ti.API.debug('path is => ' + resized_blob.nativePath);
        Ti.API.debug('width is => ' + resized_blob.width);
        Ti.API.debug('height is => ' + resized_blob.height);
        Ti.API.debug('mimetype is => ' + resized_blob.mimeType);
        Ti.API.debug('filesize is => ' + resized_blob.size);

        // Upload test
        var http = Ti.Network.createHTTPClient();
        http.onload = function (e) {
            Ti.API.debug(e);
        };
        http.onerror = function (e) {
            Ti.API.error(e);
        };
        http.open('POST', 'http://127.0.0.1:9393/upload');
        http.send({
            file: resized_blob
        });

        var image_view = Ti.UI.createImageView({
            image: resized_blob,
            width: Ti.UI.SIZE,
            height: Ti.UI.SIZE
        });
        win.add(image_view);
    });
    win.open();
}());
