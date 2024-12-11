package statusimages.makephotostatus.editorscode;

import android.content.ContentUris;
import android.content.Context;
import android.content.Intent;
import android.database.Cursor;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.os.Handler;
import android.os.Looper;
import android.provider.MediaStore;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.Display;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import com.google.android.gms.ads.AdError;
import com.google.android.gms.ads.AdSize;
import com.google.android.gms.ads.FullScreenContentCallback;
import com.squareup.picasso.NetworkPolicy;
import com.squareup.picasso.Picasso;
import java.util.ArrayList;
import java.util.List;

import statusimages.makephotostatus.AdLoadingDialog;
import statusimages.makephotostatus.R;
import statusimages.makephotostatus.Start;

import static statusimages.makephotostatus.st.loadAllBanner;
import static statusimages.makephotostatus.st.loadInterstitialAds;
import static statusimages.makephotostatus.st.mInterstitialAd;

public class SaveImageGallary extends AppCompatActivity {
    RecyclerView recyclerView;
    RecyclerView.Adapter mReAdapter;
    GridLayoutManager gLay;
    TextView tv;
    ImageView cryingEmoji;
    List<String> muList;
    LinearLayout linearLayout;
    private ImageView backBtn;

    private AdLoadingDialog loadingDialog;
    private Handler handler;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_save_image_gallary);
        loadAllBanner(SaveImageGallary.this);

        loadingDialog = new AdLoadingDialog(this);
        handler = new Handler(Looper.getMainLooper());
        backBtn = findViewById(R.id.back_btn);

        recyclerView =findViewById(R.id.savedPicturesRecView);
        recyclerView.setHasFixedSize(true);
        recyclerView.setItemViewCacheSize(30);
        recyclerView.setDrawingCacheEnabled(true);
        recyclerView.setDrawingCacheQuality(View.DRAWING_CACHE_QUALITY_HIGH);
        gLay = new GridLayoutManager(SaveImageGallary.this, 2);
        tv = findViewById(R.id.statTxt2);
        cryingEmoji = findViewById(R.id.cryingEmoji);
        recyclerView.setLayoutManager(gLay);
        muList= new ArrayList<String>();
        fetchImage();
        mReAdapter = new myAdapter((ArrayList<String>) muList, SaveImageGallary.this);
        recyclerView.setAdapter(mReAdapter);

        backBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                onBackPressed();
            }
        });

    }

    private AdSize getAdSize() {
        Display display = getWindowManager().getDefaultDisplay();
        DisplayMetrics outMetrics = new DisplayMetrics();
        display.getMetrics(outMetrics);

        float widthPixels = outMetrics.widthPixels;
        float density = outMetrics.density;

        int adWidth = (int) (widthPixels / density);

        return AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(this, adWidth);
    }

    private void fetchImage(){
        try {
            //if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
          //  Log.e("Dir", Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q ? MediaStore.Images.Media.RELATIVE_PATH + " = '" + Environment.DIRECTORY_PICTURES + "/" + getResources().getString(R.string.file_path)  + "'" : MediaStore.Images.Media.DATA + " LIKE '" + Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES).getAbsolutePath() + "/" + getResources().getString(R.string.file_path_new) + "%'");
            Cursor cursor = getContentResolver().query(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, null, Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q ? MediaStore.Images.Media.RELATIVE_PATH + " = '" + Environment.DIRECTORY_PICTURES + "/" + getResources().getString(R.string.file_path)  + "'" : MediaStore.Images.Media.DATA + " LIKE '" + Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES).getAbsolutePath() + "/" + getResources().getString(R.string.file_path_new) + "%'", null, MediaStore.Images.Media.DATE_MODIFIED + " DESC");
            Log.e("Image Size", cursor.getCount() + "");
            if (cursor.getCount() > 0) {
                recyclerView.setVisibility(View.VISIBLE);
                tv.setVisibility(View.GONE);
                cryingEmoji.setVisibility(View.GONE);
                while (cursor.moveToNext()) {
                    muList.add(ContentUris.withAppendedId(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, cursor.getLong(cursor.getColumnIndexOrThrow(MediaStore.Images.Media._ID))).toString());
                }
            }

        } catch (Exception ex) {
            //Toast.makeText(getContext(), ex.getMessage().toString(), Toast.LENGTH_LONG).show();
        }
    }

    @Override
    public void onResume() {
        super.onResume();
        muList.clear();
        fetchImage();
        mReAdapter.notifyDataSetChanged();
    }

    @Override
    public void onStart() {
        super.onStart();
    }

    public class myAdapter extends RecyclerView.Adapter<myAdapter.MyPictureHolder> {

        List<String> muList = new ArrayList<String>();

        public myAdapter(ArrayList<String> mylist, Context context) {
            this.muList = mylist;
        }

        @Override
        public myAdapter.MyPictureHolder onCreateViewHolder(ViewGroup parent, int viewType) {
            View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.pictures_template, parent, false);
            MyPictureHolder holder = new MyPictureHolder(view);
            return holder;
        }

        @Override
        public void onBindViewHolder(final myAdapter.MyPictureHolder holder, int position) {

            Picasso.get().load(muList.get(position)).centerCrop().networkPolicy(NetworkPolicy.OFFLINE).fit().into(holder.imgV);
        }

        @Override
        public int getItemCount() {
            return muList.size();
        }

        class MyPictureHolder extends RecyclerView.ViewHolder implements View.OnClickListener {
            ImageView imgV;
            ImageButton imgB;

            public MyPictureHolder(View itemView) {
                super(itemView);

                imgV = itemView.findViewById(R.id.imageView);
                imgB = itemView.findViewById(R.id.imgBdon);
                imgV.setOnClickListener(this);

            }

            @Override
            public void onClick(View view) {
                if(mInterstitialAd!= null){
                    loadingDialog.show(getSupportFragmentManager(), "loadingDialog");
                    handler.postDelayed(new Runnable() {
                        @Override
                        public void run() {
                            loadingDialog.dismiss();
                    mInterstitialAd.show(SaveImageGallary.this); //Displays the ad in a full screen activity
                    mInterstitialAd.setFullScreenContentCallback(new FullScreenContentCallback(){
                        @Override
                        public void onAdDismissedFullScreenContent() {
                            // Called when fullscreen content is dismissed.
                            Start.adShow = false;
                            loadInterstitialAds(SaveImageGallary.this);
                            Intent intent = new Intent(SaveImageGallary.this, ShowPictureItems.class);
                            intent.putExtra("pos", "" + getAdapterPosition());
                            intent.setFlags(Intent.FLAG_ACTIVITY_MULTIPLE_TASK);
                            startActivity(intent);
                        }

                        @Override
                        public void onAdFailedToShowFullScreenContent(AdError adError) {
                            // Called when fullscreen content failed to show.
                            Log.d("TAG", "The ad failed to show.");
                        }

                        @Override
                        public void onAdShowedFullScreenContent() {
                            // Called when fullscreen content is shown.
                            // Make sure to set your reference to null so you don't
                            // show it a second time.
                            mInterstitialAd = null;
                            Start.adShow = true;
                            Log.d("TAG", "The ad was shown.");
                        }
                    });}
                    }, 2500);
                }else {
                    loadInterstitialAds(SaveImageGallary.this);
                    Intent intent = new Intent(SaveImageGallary.this, ShowPictureItems.class);
                    intent.putExtra("pos", "" + getAdapterPosition());
                    intent.setFlags(Intent.FLAG_ACTIVITY_MULTIPLE_TASK);
                    startActivity(intent);
                }

            }
        }

    }
}
