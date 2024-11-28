package xProfile.dpMaker.aiPhoto.removeBg.photoEditorPro.cropimage;

import android.graphics.Bitmap;
import android.net.Uri;

import io.reactivex.Single;
import xProfile.dpMaker.aiPhoto.removeBg.photoEditorPro.cropimage.callback.SaveCallback;

public class SaveRequest {

    private CropImageView cropImageView;
    private Bitmap image;
    private Bitmap.CompressFormat compressFormat;
    private int compressQuality = -1;

    public SaveRequest(CropImageView cropImageView, Bitmap image) {
        this.cropImageView = cropImageView;
        this.image = image;
    }

    public SaveRequest compressFormat(Bitmap.CompressFormat compressFormat) {
        this.compressFormat = compressFormat;
        return this;
    }

    public SaveRequest compressQuality(int compressQuality) {
        this.compressQuality = compressQuality;
        return this;
    }

    private void build() {
        if (compressFormat != null) {
            cropImageView.setCompressFormat(compressFormat);
        }
        if (compressQuality >= 0) {
            cropImageView.setCompressQuality(compressQuality);
        }
    }

    public void execute(Uri saveUri, SaveCallback callback) {
        build();
        cropImageView.saveAsync(saveUri, image, callback);
    }

    public Single<Uri> executeAsSingle(Uri saveUri) {
        build();
        return cropImageView.saveAsSingle(image, saveUri);
    }
}