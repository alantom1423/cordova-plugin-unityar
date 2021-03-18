/*
 * Created by Alan Jose
 * Created on 17/03/2021
 * Script to send messages to cordova and quit the unity player
*/

using System.Collections;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using UnityEngine;

public class CordovaComm : MonoBehaviour
{
#if !UNITY_EDITOR && UNITY_IPHONE
    [DllImport("__Internal")]
    private static extern void sendMessageToCordova(string cordovaMessage);

    [DllImport("__Internal")]
    private static extern void quitUnityPlayer(string feedbackMsg);
#endif

    public void sendMessagetoCordova(string message)
    {
        SendToCordova(message);
    }

    public void quitUnity(string feedbackMsg)
    {
        QuitUnityPlayer(feedbackMsg);
    }

    private void SendToCordova(string messagetoCordova)
    {
#if !UNITY_EDITOR && UNITY_ANDROID
          using (AndroidJavaClass cls_UnityPlayer = new AndroidJavaClass("com.unity3d.player.UnityPlayer"))
          {
            using (AndroidJavaObject obj_Activity = cls_UnityPlayer.GetStatic<AndroidJavaObject>("currentActivity"))
            {
                obj_Activity .CallStatic("sendMessagetoCordova",messagetoCordova);
            }
          }
#endif
#if !UNITY_EDITOR && UNITY_IPHONE
        sendMessageToCordova(messagetoCordova);
#endif


    }

    private void QuitUnityPlayer(string feedbackMsg)
    {
        Debug.Log("called");
#if !UNITY_EDITOR && UNITY_ANDROID
          using (AndroidJavaClass cls_UnityPlayer = new AndroidJavaClass("com.unity3d.player.UnityPlayer"))
          {
            using (AndroidJavaObject obj_Activity = cls_UnityPlayer.GetStatic<AndroidJavaObject>("currentActivity"))
            {
                obj_Activity .CallStatic("quitUnityPlayer",feedbackMsg);
            }
          }
#endif
#if !UNITY_EDITOR && UNITY_IPHONE
        quitUnityPlayer(feedbackMsg);
#endif

    }

}
