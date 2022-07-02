#!/bin/bash
#Autoscroll basic installer

get_script_dir () {
     SOURCE="${BASH_SOURCE[0]}"
     while [ -h "$SOURCE" ]; do
          DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
          SOURCE="$( readlink "$SOURCE" )"
          [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
     done
     $( cd -P "$( dirname "$SOURCE" )" )
     pwd
} #Lifted from https://www.ostricher.com/2014/10/the-right-way-to-get-the-directory-of-a-bash-script/

bashdir="$(get_script_dir)"
echo $bashdir


#Modify below if you have custom install needs.
echo \~button2 >> $HOME/.config/sxhkd/sxhkdrc
echo "    \""\$HOME/.config/sxhkd/autoscroll.sh\""" >> $HOME/.config/sxhkd/sxhkdrc
echo \@button2 >> $HOME/.config/sxhkd/sxhkdrc

cp $bashdir/autoscroll.sh $HOME/.config/sxhkd/autoscroll.sh
chmod +x $HOME/.config/sxhkd/autoscroll.sh

echo Installation complete. Setup sxhkd as a system service or set it to autorun however you prefer.
