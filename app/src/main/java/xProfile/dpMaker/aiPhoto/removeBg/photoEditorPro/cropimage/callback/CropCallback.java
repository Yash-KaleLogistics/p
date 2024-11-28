package xProfile.dpMaker.aiPhoto.removeBg.photoEditorPro.cropimage.callback;

import android.graphics.Bitmap;

public interface CropCallback extends Callback {
    void onSuccess(Bitmap cropped);
}