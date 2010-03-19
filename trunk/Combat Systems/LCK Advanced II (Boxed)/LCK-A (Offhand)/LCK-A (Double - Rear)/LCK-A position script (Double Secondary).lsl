﻿string hiltname;
vector hiltpos;
key hiltkey;

//string LCKscript = "~*LCK double-bladed second saber script v1.5";
default
{
    state_entry()
    {
        llListen(0,"",llGetOwner(),"");
        llSetRot(ZERO_ROTATION);
        llRequestPermissions(llGetOwner(),PERMISSION_CHANGE_LINKS);
    }
    on_rez(integer param)
    {
        llResetScript();

    }
    listen(integer channel,string name,key id,string msg)
    {
        if(id == llGetOwner())
        {
            if(llGetSubString(llToLower(msg),0,8) == "/ls2 hilt")
            {
                llOwnerSay("Locating hilt");
                hiltname = llGetSubString(msg,10,-1);
                llSensor(hiltname,NULL_KEY,PASSIVE | ACTIVE | SCRIPTED,96,PI);
                return;
            }
            if(llToLower(msg) == "/ls2 link")
            {
                if(hiltkey != NULL_KEY)
                {
                    llOwnerSay("Linking.");
                    llCreateLink(hiltkey,FALSE);
                    llOwnerSay("Link Created, activating saber and setting name.");
                    llSetObjectName("LCK-A with " + hiltname);
                    
//                    llSetScriptState(LCKscript,TRUE);
                    llOwnerSay("It is now safe to use your saber.");
                    llRemoveInventory(llGetScriptName());
                    
                }
                else
                {
                    llOwnerSay("You must define a hilt in order for the script to autolink to it.");
                }
                return;
            }
            if(llToLower(msg) == "/ls oldschool")
            {
                llRemoveInventory(llGetScriptName());
            }
        }
    }
    sensor(integer num)
    {
        hiltkey = llDetectedKey(0);
        hiltname = llKey2Name(hiltkey);
        if(llGetOwnerKey(hiltkey) == llGetOwner())
        {
            llOwnerSay("Moving to hilt position.");
            llSetPos(llDetectedPos(0) - <0,0,.5>);
            llOwnerSay("Moved to position. Some tweaking will be required.");
        }
        else
        {
            llOwnerSay("You do not own this hilt. Cannot link.");
            hiltkey = NULL_KEY;
        }
    }
    no_sensor()
    {
        llOwnerSay("Could not find hilt. Please make sure that the name is spelled correctly. This IS case sensitive.");
    }
}