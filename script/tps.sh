set +v
#export BASE=${0%/*}
#cd $BASE

# CONFIG
export TPS=$1
export OK=0

export PRAIA_PATH=C:/workspace/Praia
export MAGIC_PATH=C:/workspace/Magic
export PIPAVB_PATH=C:/workspace/Pipavb

export TEXTUREPACKER_PATH=TexturePackerGUI.exe

export XML_PATH=/usr/bin/xmlstarlet.exe  

# PROCESS
echo "$TPS"

function fixPath()
{
	echo "fixpath $1 $2 $3"
	str=$($XML_PATH sel -T -t -c $1 "$TPS")
	echo "str $str"
	arr=${str// /_}
	arr2=(${arr//// })

	i=1
	for s in "${arr2[@]}"
	do
		ls=$(echo "$s" | tr '[:upper:]' '[:lower:]')
		if [[ "$ls" =~ $2 ]]
		then
			arr3="${arr2[@]:$i}"
			arr4=(${arr3// //})
			echo $3"/"${arr4[@]}
			echo $($XML_PATH ed -u $1 -v $3"/"${arr4[@]} "$TPS") > "$TPS" 
			OK=1
			break
		fi
		((i++))
	done
}

fixPath "//struct[@type='Settings']/filename"[1] "praia" $PRAIA_PATH
fixPath "//struct[@type='DataFile']"[1]"/filename"[1] "praia" $PRAIA_PATH

fixPath "//struct[@type='Settings']/filename"[1] "magic" $MAGIC_PATH
fixPath "//struct[@type='DataFile']"[1]"/filename"[1] "magic" $MAGIC_PATH

fixPath "//struct[@type='Settings']/filename"[1] "pipavb" $PIPAVB_PATH
fixPath "//struct[@type='DataFile']"[1]"/filename"[1] "pipavb" $PIPAVB_PATH




if [[ "$OK" != "0" ]]; then

	# RUN windows
	$TEXTUREPACKER_PATH "$TPS"

	# RUN mac os
	# open -a $TEXTUREPACKER_PATH "$TPS"

fi