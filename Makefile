ipd:
	hugo -D
	ipfs-deploy public/ -p pinata -d cloudflare