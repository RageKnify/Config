function fish_greeting
	set fishes (pidof /bin/fish | wc -w)
	if test $fishes -eq "1"
		greeting
	end
end
