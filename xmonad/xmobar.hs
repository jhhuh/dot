Config { font = "xft:Ubuntu Mono:pixelsize=12"
       , additionalFonts = []
       , borderColor = "#2c2c2c"
       , border = TopB
       , bgColor = "#2c2c2c"
       , fgColor = "gray"
       , alpha = 255
       , position = Bottom
       , textOffset = -1
       , iconOffset = -1
       , lowerOnStart = True
       , pickBroadest = False
       , persistent = False
       , hideOnStart = False
       , iconRoot = "."
       , allDesktops = True
       , overrideRedirect = True
       , commands = [
            Run Network "wlp3s0" [] 10, 
            Run Cpu ["-L","3","-H","50","--normal","green","--high","red"] 10,
            Run Memory ["-t","Mem: <usedratio>%"] 10,
            Run Com "uname" ["-s","-r"] "" 36000,
            Run Date "%a %b %_d %Y %H:%M:%S" "date" 10,
            Run Battery ["-t", "Batt: <acstatus>", "-L", "10", "-H", "80",
                "--low", "red",
                "--normal", "orange",
                "--high", "green",
                "--",
                "-o", "<left>% (<timeleft>)",
                "-O", "<fc=#dAA520>Charging(<left>%)</fc>",
                "-i", "<fc=green>Charged(<left>%)</fc>" ] 50,
            Run Volume "default" "Master" ["-t", "Vol: <volume>%"] 10,
            Run XMonadLog
       ]
       , sepChar = "%"
       , alignSep = "}{"
       , template = "%XMonadLog% | %cpu% | %memory% | %wlp3s0% | %battery% } \
                    \{ %default:Master% | %date% | %uname%"
       }
