/**Alan Jose */
/**17/03/2021 */
package cordova.plugin.unityar;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.PluginResult;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;


import android.content.Intent;


/**
 * This class echoes a string called from JavaScript.
 */
public class UnityAR extends CordovaPlugin {

    private CallbackContext callbackFromPlugin;
    public final int RQCODE = 1;

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        this.callbackFromPlugin = callbackContext;
        if(action.equals("launchUnity")){
            String message = args.getString(0);
            this.launchUnity(callbackContext,message);
            return true;
        }
        else if(action.equals("launchwithMessage")){
            JSONObject jsonObject = args.getJSONObject(0);
            this.launchUnityMessage(callbackContext,jsonObject);
            return true;
        }
        return false;
    }

    private void launchUnity(CallbackContext callbackContext, String message){
        try
        {
            Intent unityIntent = new Intent(cordova.getActivity().getApplicationContext(),MainUnityActivity.class);
            unityIntent.setFlags(Intent.FLAG_ACTIVITY_REORDER_TO_FRONT);
            cordova.startActivityForResult(this,unityIntent,1);            
        }
        catch(Exception ex)
        {
            callbackContext.error("There was an error "+ex);
        }
        
    }

    private void launchUnityMessage(CallbackContext callbackContext, JSONObject messageArg){
        try
        {
            Intent unityIntent = new Intent(cordova.getActivity().getApplicationContext(),MainUnityActivity.class);
            unityIntent.putExtra("messageJson",messageArg.toString());
            unityIntent.setFlags(Intent.FLAG_ACTIVITY_REORDER_TO_FRONT);
            cordova.startActivityForResult(this,unityIntent,RQCODE);
            PluginResult pluginResult = new PluginResult(PluginResult.Status.OK, "Launched Unity with message");
            pluginResult.setKeepCallback(true);
            callbackContext.sendPluginResult(pluginResult);
        }
        catch(Exception ex)
            {
                callbackContext.error("There was an error "+ex);
            }
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data){
        if(requestCode == RQCODE){
            String messageToCordova =  data.getStringExtra("CORDOVA_MSG");
            PluginResult pluginResult = new PluginResult(PluginResult.Status.OK,messageToCordova);
            pluginResult.setKeepCallback(true);
            callbackFromPlugin.sendPluginResult(pluginResult);
        }
    }
}
