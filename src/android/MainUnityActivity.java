/**Alan Jose */
/**17/03/2021 */
package cordova.plugin.unityar;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.FrameLayout;

import com.company.product.OverrideUnityActivity;

import org.json.JSONException;
import org.json.JSONObject;

public class  MainUnityActivity extends OverrideUnityActivity{

    private static String returnMessage = null;
    public static MainUnityActivity mainUnityInstance = null;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mainUnityInstance = this;
        //TODO: add later the below line based on arguments from Cordova
        //addUIToUnityWindow();
        if(getIntent().hasExtra("messageJson")){
            try {
                JSONObject messageArgs = new JSONObject(getIntent().getStringExtra("messageJson"));
                sendMessage(messageArgs);
            }
        catch (Exception e){
                e.printStackTrace();
            }
        }
        Intent intent = getIntent();
        handleIntent(intent);
    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        handleIntent(intent);
        setIntent(intent);
    }


    protected void showMainActivity(String color){
        return;
    }

    void handleIntent(Intent intent) {
        if(intent == null || intent.getExtras() == null) return;

        if(intent.getExtras().containsKey("doQuit"))
            if(mUnityPlayer != null) {
                finish();
            }
    }

    void addUIToUnityWindow(){
        FrameLayout frameLayout = mUnityPlayer;
        {
            Button closeButton = new Button(this);
            closeButton.setText("CLOSE");
            closeButton.setX(10);
            closeButton.setY(20);

            closeButton.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    if(returnMessage!=null){
                        Intent intent = new Intent();
                        intent.putExtra("CORDOVA_MSG",returnMessage);
                        setResult(Activity.RESULT_OK,intent);
                    }
                    finish();
                }
            });
            frameLayout.addView(closeButton,300,200);
        }

    }

    void sendMessage(JSONObject messageArgs) {
        if(mUnityPlayer!=null){
            try {
                mUnityPlayer.UnitySendMessage(messageArgs.getString("gameobject"),messageArgs.getString("method"),messageArgs.getString("argument"));
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }
    }

    private void quitPlayer(String feedbackMessage)
    {
       sendResult(feedbackMessage);
       finish();
    }

    private void sendResult(String resultToSend)
    {
        if(resultToSend!=null){
            Intent intent = new Intent();
            intent.putExtra("CORDOVA_MSG",resultToSend);
            setResult(Activity.RESULT_OK,intent);
        }
    }

    public static void sendMessagetoCordova(String data)
    {
        mainUnityInstance.sendResult(data);
    }

    public static void quitUnityPlayer(String feedbackString)
    {
        mainUnityInstance.quitPlayer(feedbackString);
    }
}