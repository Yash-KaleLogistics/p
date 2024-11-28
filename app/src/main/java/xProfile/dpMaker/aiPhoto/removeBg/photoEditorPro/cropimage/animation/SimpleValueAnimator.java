package xProfile.dpMaker.aiPhoto.removeBg.photoEditorPro.cropimage.animation;

@SuppressWarnings("unused") public interface SimpleValueAnimator {
    void startAnimation(long duration);

    void cancelAnimation();

    boolean isAnimationStarted();

    void addAnimatorListener(SimpleValueAnimatorListener animatorListener);
}