function dgarlic --description 'Disable STT\'s vpn'
	sudo wg-quick down /etc/wireguard/garlic.conf
end
