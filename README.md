# prosody-docker
Prosody IM XMPP server, Dockerized

This is a lightweight container of the Prosody XMPP server, ~8MB in size, built on Alpine Linux.

Be sure to use persisted storage (2 named volumes, one for config/certs, the other for data) for your servers' storage. If you use host bind mounts, you'll have to produce a ```prosody.cfg.lua``` first ~ otherwise, one is included.

### Management

If you want a shell within the container, just run:
```docker exec --user=root -it running_instance_name ash```

If you would like to install additional packages within your container, you can add them with ```apk```

e.g. ```apk add --no-cache vim```

# Volumes
There are two important volumes:
```/var/lib/prosody``` - Persistent storage data, like your users' profiles
```/etc/prosody/``` -  Configuration, certificates, additional modules

# Networking
The server listens on ```tcp/5222``` (c2s) and ```tcp/5269``` (s2s)

Please comment if you have any issues, and I'll try to resolve them as soon as possible.

See: [https://hub.docker.com/r/garrettboast/prosody/](https://hub.docker.com/r/garrettboast/prosody/)
