### Cordova Plugin UnitAR

#### Description

The plugin describes how to integrate Unity into a cordova based project. Unity has introduced a new feature to use Unity as a library in native apps (Android and iOS). This feature is exploited to create this plugin.

I would like to give credits to the following repos that helped me while creating this plugin

- <https://github.com/yasirkula/UnityIonicIntegration>
- <https://github.com/Unity-Technologies/uaal-example>

#### Requirements

- Xcode 9.4+
- Android Studio 3.4.2+
- Unity version 2019.3.0b11+, 2020.1.0a13+
- Cordova 9.0.0
- Cordova Android 8.1.0
- Cordova iOS 5.1.1

#### Installation

Import the plugin to the cordova project

`cordova plugin add cordova-plugin-unityar`

- To launch unity from the cordova project call the following method in your javascript

`UnityAR.launchWithMessage(GameObject,MethodName,Argument)`

	UnityAR.launchWithMessage("Manager","GetMessageFromCordova","Cordova Msg",
    (data)=>{
         console.log("success ",data);
     },(err)=>{
         console.log("error ",err);
    });;

#### Unity Setup

Create a project in unity. Copy the following files from the files folder in the repository to the respective folders in unity project

- Copy *NativeCallProxy.mm* and *NativeCallProxy.h* to ***Assets/Plugins/iOS***
- Copy *OverrideUnityActivity.java* to ***Assets/Plugins/Android***
- Copy *CordovaComm.cs* to ***Scripts*** folder


The following method can be accessed from *CordovaComm.cs* Unity C# script to quit Unityplayer and come back to cordova project

	public void quitUnity(string feedbackMsg)
***feedbackMsg*** :- to send  message back to cordova from unity.


**For Android** :- Export project from Unity to generate an android project 
  ![](https://github.com/alantom1423/cordova-plugin-unityar/blob/master/images/unityscreen1.jpeg)

**For iOS** :- Export as an iOS project to a folder.



#### Cordova Android setup

- Copy *unitylibrary* generated in the unity build to the *platforms/android* folder of the cordova project
- Add `android.library.reference.3=unityLibrary` to ***project.properties***

  ![](https://github.com/alantom1423/cordova-plugin-unityar/blob/master/images/androidscreen1.jpeg)

- Add the following code
       `flatDir {
       		dirs "${project(':unityLibrary').projectDir}/libs"
       }`
to `allprojects { repositries {  }}` in ***build.gradle*** in platforms/android folder

  ![](https://github.com/alantom1423/cordova-plugin-unityar/blob/master/images/androidscreen2.jpeg)

- Add the following
		`implementation fileTree(dir: project(':unityLibrary').getProjectDir().toString() + ('\\libs'), include: ['*.jar'])`
to `dependencies` below subproject comment in platforms/android/app  ***build.gradle*** folder

  ![](https://github.com/alantom1423/cordova-plugin-unityar/blob/master/images/androidscreen3.jpeg)

- Make sure **min sdk** version of both cordova project and unityproject are same
- From **AndroidManifest.xml** of **unityLibrary** folder, remove the following code to prevent two apps from being installed on the device
		`<intent-filter>
			<action android:name="android.intent.action.MAIN" />
        	<category android:name="android.intent.category.LAUNCHER" />
		</intent-filter>`


#### Cordova iOS Setup

- Build the cordova project for iOS from terminal. When it fails open the workspace in xcode
- Delete *main.mm* from Cordova project *Other Sources*  Folder

  ![](https://github.com/alantom1423/cordova-plugin-unityar/blob/master/images/iosscreen1.jpeg)

- Copy or replace *AppDelegate.mm* and *AppDelegate.h*  from the files folder of this repo to Cordova project. The files should exist in *Classes* folder of cordova ios project

- Add unity ios project to this workspace

  ![](https://github.com/alantom1423/cordova-plugin-unityar/blob/master/images/iosscreen2.jpeg)

- Add *UnityFramework.framework*
  Select cordovaiOSApp target from cordovaiOSApp project.
  In `General` tab `Frameworks, Libraries, and Embedded Content` press '+'.
  Add `Unity-iPhone/UnityFramework.framework`.
  In `Build Phases` tab, expand `Link Binary With Libraries`.
  Remove `UnityFramework.framework` from the list (select it and press '-' ).
  
  ![](https://github.com/alantom1423/cordova-plugin-unityar/blob/master/images/iosscreen3.jpeg)
  
- Expose *NativeCallProxy.h*
  In Project navigator, find and select `Unity-iPhone/Libraries/Plugins/iOS/NativeCallProxy.h`.
  Enable *UnityFramework* in Target Membership and set header visibility from *project* to *public* (small dropdown on right side to UnityFramework)
  
  ![](https://github.com/alantom1423/cordova-plugin-unityar/blob/master/images/iosscreen4.jpeg)

- Make *Data* folder to be part of the UnityFramework
    change *Target Membership* for Data folder to *UnityFramework*
 
  ![](https://github.com/alantom1423/cordova-plugin-unityar/blob/master/images/iosscreen5.jpeg)
 
 - Copy Launcher files to Current project for splashscreen.mm
 
   ![](https://github.com/alantom1423/cordova-plugin-unityar/blob/master/images/iosscreen6.jpeg) 

