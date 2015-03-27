" Ambienter VIM plugin

" Description: Switch colorsheme based on ambient light sensor detection
" Author:      <https://github.com/lleixat>

" Version:     1.0
" Licence:     See LICENCE file
" Help:        See README or ambienter.txt file
" -----------------------------------------------------------------------------

if empty(g:ambienter_config)
    " Customise to your needs in your vimrc file
    let g:ambienter_config = {
         \     "debug": 0,
         \     "sensor": {
         \         "path": "/sys/class/backlight/intel_backlight/actual_brightness",
         \         "value": {"min": 300 }
         \     },
         \     "theme": {
         \         "light": {
         \             "background": "light",
         \             "colorsheme": ""
         \         },
         \         "dark": {
         \             "background": "dark",
         \             "colorsheme": ""
         \         }
         \     },
         \     "callbacks": []
         \ }
endif

let Ambienter = {'conf': g:ambienter_config }

function! Ambienter.Log(mess, ...) dict
    let l:force = a:0 > 0 ? a:1 : 0
    if has_key(self.conf, 'debug') && self.conf.debug == 1 || l:force == 1
        echom 'Ambienter: ' . string(a:mess)
    endif
endfunction

if !empty(Ambienter.conf.sensor)
    if !filereadable(Ambienter.conf.sensor.path)
        Ambienter.Log("Sensor file " . Ambienter.conf.sensor.path . " not found or not readable.")
        exit
    else

        function! Ambienter.Set(ambient) dict
            if has_key(self.conf.theme, a:ambient)

                exe 'colorscheme '. self.conf.theme[a:ambient].colorsheme
                exe 'set background=' . self.conf.theme[a:ambient].background

                " Fire callbacks if exists
                if has_key(self.conf, 'callbacks') && !empty(self.conf.callbacks)
                    for Cb in self.conf.callbacks
                        call Cb()
                    endfor
                endif
            else
                " Forcing log here
                return self.Log('['.a:ambient.'] is not a valid ambient name.', 1)
            endif
        endfunction

        " Switch between light/dark theme
        " Use banged version to force 'dark' theme
        function! Ambienter.Switch(isBanged) dict
            if &background == "dark" && a:isBanged == 0
                return self.Set("light")
            else
                return self.Set("dark")
            endif
        endfunction

        " Define colorsheme based on ambient light
        function! Ambienter.Sensor() dict
            " read als current value
            let self.conf.sensor.value.current = join(readfile(self.conf.sensor.path), "\n")
            call self.Log('Sensor value [' . self.conf.sensor.value.current . ']')

            if len(self.conf.sensor.value.current) > 0
                if self.conf.sensor.value.current > self.conf.sensor.value.min
                    if &background != 'light'
                        call self.Log('Switch to light theme')
                        " set light colo
                        return self.Set('light')
                    else
                        return self.Log('Nothing to do.')
                    endif
                elseif &background != 'dark'
                    call self.Log('Switch to dark theme')
                    return self.Set('dark')
                else
                    return self.Log('Nothing to do.')
                endif
            else
                return self.Log('Light sensor value not found.')
            endif
        endfunction

        command! -bang Ambienter call Ambienter.Switch(<bang>0)
        command! -nargs=1 AmbienterSet call Ambienter.Set(<f-args>)
        command! AmbienterSensor call Ambienter.Sensor()

    endif
else
    echom "Ambienter: Disabled."
    exit
endif

"------------------------------------------------------------------------------
" vim: filetype=vim foldmethod=indent
