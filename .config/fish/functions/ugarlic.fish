function ugarlic --description 'Enable STT\'s vpn'
	sudo wg-quick up /etc/wireguard/garlic.conf
end
