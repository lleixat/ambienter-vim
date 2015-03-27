## Introduction

Problem : I love dark colorshemes. Sometimes the ambient light or the backlight
makes the code difficult to read. 
Solution : My laptop have many built-in sensors included an Ambient Light
Sensor (als).

This plugin purpose the automatic switch between the "dark" and the "light" one,
based on the light sensor detection. 

## Compatibility

Tested on GNU/Linux but should work on any \*nix like system.

This plugin was fully tested and is running properly on :
 - Yoga2 Pro on Achlinux.

## Installation

Use your preferred `Pathogen|Bundle|NeoBundle|Vundle` thing.

```viml
Vundle 'lleixat/ambient-vim'
```

Additionally you can install the colorshemes used in this those examples:

```viml
Vundle 'chriskempson/base16-vim'
```

Here is an example using `Neobundle` with `chriskempson/base-16` repository as
dependency (optional):
```viml
NeoBundle 'lleixat/ambienter-vim', {'depends': 'chriskempson/base16-vim'}
```

## Usage

### Configuration

You have to set your custom config in your `vimrc`, just like this:

```viml
let g:ambienter_config = {
            \     "sensor": {
            \         "path": "/sys/class/backlight/intel_backlight/actual_brightness",
            \         "value": {"min": 200 }
            \     },
            \     "theme": {
            \         "light": {
            \             "background": "light",
            \             "colorsheme": "base16-solarized"
            \         },
            \         "dark": {
            \             "background": "dark",
            \             "colorsheme": "base16-ocean"
            \         }
            \     },
            \     "callbacks": [function("airline#load_theme")]
            \ }

```

#### Using sensor ...

I use the built-in ambient light sensor (als) on my laptop (Yoga2 Pro). Here are
my `"sensor"` values:

```viml
...
\ "sensor": {
\     "path": "/sys/bus/iio/devices/iio:device3/in_intensity_both_raw",
\     "value": {"min": 2000}
\ },
...
```
You must define the path accordingly to your system setup.

##### ... or not

If you don't have any built-in light sensor, you can detect your screen
brightness:

```viml
...
\ "sensor": {
\    "path": "/sys/class/backlight/intel_backlight/actual_brightness",
\    "value": {"min": 200}
\ },
...
```

Basically, you can use any self updated file that contain a digit.

The `"value.min"` option define the minimum value for the switch to occur
(basically from "dark" to "light").

> This value is obtained after trail and error, and probably needs some 
adjustments to suit everyone.

#### Theme

You have to define your own properties for `"light"` and`"dark"` theme. Usually,
the `background` value must be `dark` or `light`.

```viml
...
\ "theme": {
\     "light": {
\         "background": "light",
\         "colorsheme": "base16-solarized"
\     },
\     "dark": {
\         "background": "dark",
\         "colorsheme": "base16-ocean"
\     }
\ },
...
```


> I recommend to keep the `background` and `colorsheme` definition as usual,
somewhere in your vimrc:
>
> ```viml
> " Set default theme
> set background=dark
> colorscheme base16-ocean
> ```
>


#### Callback definition

Callbacks are fired after the theme switching and are defined in an array with the `g:ambienter_config.callbacks` key:

```viml
let g:ambienter_config.callbacks = [function("SendPlop"), function("MyAwesomeCustomFunction")]
```

Callback functions are optional and must be defined _before_ setting the
"callbacks" key:

```viml
" Defining Plop callback function for Ambienter
function! Plop()
    echom "Plop !"
endfunction

" Sending a 'plop' message after theme switching
let g:ambienter_config.callbacks = [function("SendPlop")]
```

You can from here, use one of those predefined commands decribed below.


### Commands

#### Toggling
```
:Ambienter
```

This command call the `Switch` function and allow toggling between your
predefined `dark` and `light` theme.
You can force the `dark` theme using the *bang* method:

```
:Ambienter!
```

#### Setting

```
:AmbienterSet <ambient>
```

Switch to the ambient passed in parameter. The `<ambient>` parameter could be
`dark`, `light` or `hellokittyambient` if you have setted the
`g:ambienter_config.theme.hellokittyambient` key...

```
:AmbienterSet hellokittyambient
```

#### Based on sensor value

Manually:

```
:AmbienterSensor
```

Automagic (ie: on `BufEnter` event):

```viml
au BufEnter * call Ambienter.Sensor() " Adapt colorsheme to ambient light
```

Enjoy !

## Screenshots and Links

![Ambienter in action](https://raw.github.com/lleixat/ambienter-vim/master/ambienter-vim.gif) (todo)

 - Themes :
  - I recommend this bundle : [https://github.com/chriskempson/base16-vim](https://github.com/chriskempson/base16-vim)
  - More info on [Base-16 theme](http://http://chriskempson.github.io/base16/)

 - Using the sensors on Yoga2 Pro running a Linux based distro:
  - Drivers: [https://github.com/pfps/yoga-laptop](https://github.com/pfps/yoga-laptop)

## Troubleshooting

### Debug

The debug mode is available with:
```
let g:ambienter_config.debug = 1
```

#### Airline

Airline won't refresh properly on `au BufEnter * ...` event.
Try to set this callback in  `g:ambienter_config`:

```vim
let g:ambienter_config.callbacks = [function("airline#load_theme")]
```

## Contributions

Feel free to contribute | fork | pull-request | issue | drop me good coffee etc.
