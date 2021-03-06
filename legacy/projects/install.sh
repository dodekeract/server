#!/bin/bash

TARGET="/srv/docker/nginx/root/projects"
SITES="/srv/docker/nginx/config/sites-enabled"

# create folder

mkdir -p "$TARGET"

# clone

function clone () {
	(git clone https://github.com/dodekeract/$1 &> /dev/null) || (pushd $1 && git pull && popd)
}

# go

pushd "$TARGET"

	clone line-replace-fractals
	clone mandelbrot
	clone particles
	clone sierpinski
	clone some-old-stuff
	clone spirograph
	clone spot-the-difference

	# manta

	clone manta-config-engine-app
	pushd manta-config-engine-app
		npm install
		npm run build
		rm -r ../manta
		mv build ../manta
	popd

popd

# copy nginx config

cp ./nginx.conf "$SITES/projects.dodekeract.com"
cp ./legacy.conf "$SITES/projects-legacy"

# copy favicons

cp ./favicons/projects.ico "$TARGET/favicon.ico"

# reload nginx

docker exec -it nginx nginx -s reload
