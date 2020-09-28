#/bin/tcsh -f
clear

set maxHeight = 5
set text = ( a b c d e f r g h i j k l m n o p q r s t u v w x y z A B C D E F G H I J K L M N O P Q R S T U V W X Y Z 1 2 3 4 5 6 7 8 9 0)

#Randoms
set rands = ( 100 3231 532 85 33563 647745 747477 779 76 40)
set r = 0
set random

alias rand 'set rands = (`shuf -i 1-52`) && @ r = $r % $#rands + 1 && @ random = $rands[$r] '


#Goto x,y
set cX = 14
set cY = 16
alias gotoSpotRegular 'echo "\e[0m\e[32m\e[${cY};${cX}H$text2"'
alias gotoSpotBold 'echo "\e[1m\e[32m\e[${cY};${cX}H$text2"'



set width = `tput cols`
@ width = $width 
set height = `tput lines` 
@ height = $height - 1
@ streams = $width
@ virtHeight = $height + $maxHeight

@ width2 = 2 * $width

set streamsX = (`seq 1 1 $width2`)
set streamsY = (`seq 1 1 $width2`) #dummy values
set streamsCount = (`seq 1 1 $width2`)
set streamLetters = (`seq 1 1 $width2`)
set streamHeights= (`seq 1 1 $width2`)

#Fill Y's with randoms
foreach yI (`seq 1 $width2`)
                rand
                @ streamsY[$yI] = $random * 31 % $height
end

#Fill counts with randoms
foreach cI (`seq 1 $width2`)
                rand
                @ streamsCount[$cI] = $random * 65 % 6
end


while (1)
	set xArray = (`shuf -i 1-$width2`)
	foreach xO ($xArray)
		@ x = $xO % $width
		@ cX = $x
	        @ cY = $streamsY[$xO]
		
		#Echo New Char Text
		rand
		@ letterI = $random % $#text + 1
		set text2 = $text[$letterI]
		set tmp = $text[$letterI]
		if($cY <= $height && $cY >= 1) then
			gotoSpotBold
		endif

		# Write old letter as regular
		@ cY = $cY - 1
		set text2=$streamLetters[$xO]
		if($cY <= $height && $cY >= 0) then 
			gotoSpotRegular
		endif

		# Store new letter ito streamLetters
		set streamLetters[$xO] = $tmp

		# Clear space above based on height
		if($streamHeights[$xO] < $cY ) then
			set oldY = $cY
			set text2 = " "
			@ cY= $cY - $streamHeights[$xO]
			if($cY <= $height && $cY >= 0) then 
				gotoSpotRegular
			endif

			set cY = $oldY
		endif
 
		# Decrement count
		@ streamsCount[$xO] = $streamsCount[$xO] - 1
		if ($streamsCount[$xO] <= 0) then
			# New Count
			rand
			@ count =  3
			@ streamsCount[$xO] = $count * 6

			# Random new Y	
			rand
			@ newY = $random * 31 % $virtHeight + 1
			@ streamsY[$xO] = $newY

			#Random height
			rand
			@ newHeight = $random % $maxHeight % $virtHeight
			@ streamHeights[$xO] = $newHeight 
		else
			if($streamsY[$xO] < $virtHeight) then
				@ streamsY[$xO] = $streamsY[$xO] + 1
			else 
				@ streamsY[$xO] = 1
				
				#Make end char regular
				set text2 = $streamLetters[$xO]
				@ cY= $cY + 1
				if($cY <= $height && $cY >= 0) then
					gotoSpotRegular
				endif
			endif
		endif
	end
end
