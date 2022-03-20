# osp-docker
This is a docker container for running the Open Satellite Project's xritdemod and goesdump on a Linux host.

Building the container:
`cd osp-docker/ && docker build -t osp-docker .`

Running the container for the first time:
`docker run --name osp-docker --privileged -v /dev/bus/usb:/dev/bus/usb -v ~/osp-docker:/root/run -p 8090:8090 -t osp-docker`
where "~/osp-docker" is the path to the directory of this repository. CTRL+C to exit.

Subsequent starting, stopping, and attaching to the container:
`docker container start osp-docker`
`docker container stop osp-docker`
`docker container attach osp-docker`
Detach with CTRL+P, CTRL+Q.

Configuration:
Edit the xritdecoder.cfg and xritdemod.cfg files as you would normally. Restart the docker container after edits are made.
