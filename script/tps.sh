set +v  
export BASE=${0%/*} 
cd $BASE 



# CONFIG
export TPS=$1
export PRAIA_PATH=C:/workspace/Praia
export TEXTUREPACKER_PATH=TexturePackerGUI.exe




# PROCESS
echo $TPS

function fixPath()
{
	str=$(xmlstarlet sel -T -t -c $1 $TPS)
	arr=${str// /_}
	arr2=(${arr//// })

	i=1
	for s in "${arr2[@]}"
	do
		#echo $i $s
		if [[ ${s,,} =~ "praia" ]]
		then
			arr3="${arr2[@]:$i}"
			arr4=(${arr3// //})
			echo $PRAIA_PATH"/"${arr4[@]}
			echo $(xmlstarlet ed -u $1 -v $PRAIA_PATH"/"${arr4[@]} $TPS) > $TPS
			break
		fi
		((i++))
	done
}

fixPath "//struct[@type='Settings']/filename"[1]
fixPath "//struct[@type='DataFile']"[1]"/filename"[1] 



# RUN
$TEXTUREPACKER_PATH $TPS  
