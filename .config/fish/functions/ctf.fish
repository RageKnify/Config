function ctf --description 'cd to the current CTF'
	if test -d /home/jp/Documents/STT/ctf
		set CTF (ls -td1 /home/jp/Documents/STT/ctf/*/ | head -1)
		test -d $CTF && cd $CTF
	else
		echo "/home/jp/Documents/STT/ctf is not a directory"
	end
end
