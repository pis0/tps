http://macappstore.org/xmlstarlet/

https://coderwall.com/p/dmuxma/upgrade-bash-on-your-mac-os

# applescript:

on run args
    set the_script to "/usr/local/bin/bash /Applications/tps/tps.sh "
    set the_result to do shell script the_script & args
    display dialog the_result
end run