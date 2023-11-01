
## How to switch torrent speed by Plex notifications in Tautulli

#### Tautulli/Notification Agents 
Add/Script
Script Folder:
```
C:\git\server\tautulli
```
Script File:
```
.\SwitchQBitTorrentAltSpeed.ps1
```
Triggers:
```
Playback Start
Playback Stop
Playback Pause
Playback Resume
Playback Error
```
Conditions:
```
{1} Actions is play or resume or pause
{2} Actions is stop or error
{3} Streams is 0
{4} Streams is 1
```
Condition Logic:
```
{1} and {4} or {2} and {3}
```
Arguments:
Playback Start: `TRUE`
Playback Stop: `FALSE`
Playback Pause: `FALSE`
Playback Resume: `TRUE`
Playback Error: `FALSE`