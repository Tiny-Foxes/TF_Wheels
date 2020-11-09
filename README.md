# Rhythm Games Music Wheels

This is a collection of Music Wheels for Stepmania 5.

## Instructions / How to use.

### The files we need.

Okey so this is an example of how to use the DDR 4th Mix Wheel.
So the files we need are

* `Scripts\01 Main.lua`
This is the Main Script that has all the code to make the wheels work.

* `Modules\Songs.Loader.lua`
This is the Song Load function, It loads all the songs for the wheels.

* `Modules\Wheel.DDR4thMixPlusWheel.lua` 
This is the wheel we're gonna use for this example.

Also take the content from the Graphics and Fonts folder.

### The metrics.ini

To use a wheel, Make a new screen in the metrics.ini

like for example:

```ini
[OFSelectMusic]
PrevScreen="ScreenTitleMenu"
Class="ScreenWithMenuElements"
Fallback="ScreenWithMenuElements"
```

We define an empty screen, We can go to by using `NextScreen=` option or if we use a selector,

For example the [ScreenTitleMenu]:

```ini
[ScreenTitleMenu]

# Dont forget to add it to list
ChoiceNames="MusicWheel,Options,Edit,Jukebox,GameSelect,Exit"

ChoiceMusicWheel="screen,OFSelectMusic;text,Start"

```

Now that we got the metrics.ini set up, lets go to the BGAnimations.

### BGAnimations.

Ok so we want to load the wheel on DDRSelectMusic, Which is what we called our new screen.

To do so, we make a new file in the `BGAnimations` folder.

`OFSelectMusic overlay.lua`

This is going to be the file we use to contain the wheel, It's going to be in overlay so we can use underlay, background and other files for other stuff.

Now that we have created the file, Lets edit it, Open it with a text editor like Notepad++ or VSCode.

Here is an example of how to load the 4th mix Wheel:

```lua
return LoadModule("Wheel.DDR4thMixPlusWheel.lua")("dance_single")
```

This is a DDR theme so we only do Dance Single for now, Dance Single is also used for Versus, It just tells the Song.Loader which songs to load.

And thats basicly it, If you have any questions contact me on ZIV/Discord or make an Issue.
