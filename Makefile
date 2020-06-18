usage:
	cat README.md

dist:
	tar cvzf nixos-maas.$$(date +%Y%m%d%H%M%S).tgz --exclude .git --exclude-from .gitignore .

