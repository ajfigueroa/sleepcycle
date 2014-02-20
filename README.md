SleepCycle
==========

Not to be confused with the popular sleep tracking application of the similar name. 
SleepCycle is meant as a mobile alternative to the fantastic website sleepyti.me.

## To Do
* Complete Unit Test Coverage
* Implement Brief Tutorial using [iPhone-IntroductionTutorial](https://github.com/MatthewYork/iPhone-IntroductionTutorial)
* Finish "About" section in Settings
* Inform user that the alarm feature is not meant to be a replacement to their alarm app but a supplement. A design decision was made to not force the user to keep the app running (i.e. similar to "do not lock the phone" type alarms).
* Fix GIF color issue, the app is much brighter when in non-gif form.


## Feature Overview

Similar to sleepyti.me, the user will initially be presented with a date picker to choose the time they wish to wake up at. 
The suggested bed times will then be provided where the lightest colors indicate the most ideal times ("go towards the light" mantra).

![Calculate Bed Times](README%20Images/calculatebedtime.gif)
----------------------------------------------

Given the average time it takes to fall asleep (14 minutes), the user (assuming, permission to use Reminders is granted) can set a reminder (long pressing on the time) to go off about 14 minutes prior to the suggested bed time. This is to inform them that they should be in bed now to achieve the optimal sleep cycle durations needed to not feel groggy in the morning.

![Suggested Bed Times with Reminder](README%20Images/calculatebedtimereminder.gif)
----------------------------------------------

In addition to the reminder, if the user wanted to set an alarm for the time they entered as their desired wake time. They can do so by pressing the Clock icon to the top right.

For both Reminder and Alarms, I essentially normalize all times to today and then compare if these times are before the current time ([NSDate date]) to determine if I can set an Alarm or Reminder to go off today and tomorrow. (You don't want to set one for a time that already has happened). This is why you'll often see one (1) or two (2) options presented in the Action Sheets.

![Suggested Bed Times with Alarm](README%20Images/calculatebedtimesetalarm.gif)
----------------------------------------------

The user can also calculate suggested wake times given their expected bed time. The "head towards the light" idea still holds here.

![Calculate Wake Times](README%20Images/calculatewaketimeconfirmtime.gif)
----------------------------------------------

The "Sleep Now" button presents suggest wake times based on the current time plus the time it takes to fall asleep (This property is modifiable and shown further below).

Essentially, performing the suggested wake time calculations on input bed time of: 

> [[NSDate date] dateByAddingInterval:(timeToFallAsleep)];

From the suggested wake times, long pressing any of the wake times brings up a prompt for setting an alarm. 

If the alarm doesn't exist, a success prompt will be shown.
If the alarm already exists, no notification is sent. (This will be changed in upcoming builds).

No gif is shown as the alarm prompt is identical to the alarm action above: "Suggested Bed Times with Alarm".

![Calculate Wake Times with Sleep Now](README%20Images/calculatewaketimesleepnow.gif)
--------------------------------------------------------------------------------------------------

All hierarchal navigation can be done through swiping in from the left bezel or by clicking the Menu List button.

![Menu Navigation](README%20Images/settingsopen.gif)
----------------------------------------------------

All the alarms created can be viewed within the application. Reminders (if permission was granted) can be viewed through the default Reminders.app.

![Alarms](README%20Images/alarms.gif)
----------------------------------------------------

The Settings is presented modally and allows the user to change theme and basic behavioral options. Feel free to find out where that ping-pong match is!

![Settings View Controller](README%20Images/settingspopup.gif)
----------------------------------------------------

Here is an example of one of the theme options allowed.

![Red Rose Theme](README%20Images/redrosetheme.gif)
----------------------------------------------------

As mentioned before, the time to fall asleep (minutes) property can be adjusted. (0-60 only is allowed)

![Adjusting time to fall asleep (in minutes)](README%20Images/adjustminutestofallasleep.gif)
----------------------------------------------------

Users can provide feedback through the Feedback option, which presents an MFMailComposerViewController.

![Feedback](README%20Images/feedback.gif)
----------------------------------------------------

Lastly, all Attributions can be seen within the Attributions section. I also included a nifty barebones web view controller.

![Attributions from Settings](README%20Images/attributions.gif)

![WebViewController](README%20Images/webviewcontroller.gif)
