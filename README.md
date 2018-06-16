# docker-clamav

This project shows how to create a ClamAV docker image.

Instructions are also provided to create a save file so that ClamAV can
be installed in places without internet access. Thus, the virus definitions
are baked into the image. It is designed to be immutable. When you need a
fresh set of virus definitions, build a new image.

## Prequisites

* Docker
* Internet connection

## Build Image

```
export CLAMAV_TS=$(date "+%Y-%m-%d")
docker build -t frog/clamav:$CLAMAV_TS .
docker build -t frog/clamav:latest .
```

## Run Image

```
export CLAMAV_TS=$(date "+%Y-%m-%d")
docker run \
  -it \
  --rm \
  --name clamav \
  -p 3310:3310 \
  frog/clamav:${CLAMAV_TS}
```

## Save Image

```
export CLAMAV_TS=$(date "+%Y-%m-%d")
docker save frog/clamav:${CLAMAV_TS} | gzip > frog-clamav-${CLAMAV_TS}.docker.save.tgz
```

## Load Image

```
export CLAMAV_TS=$(date "+%Y-%m-%d")
gunzip -c frog-clamav-${CLAMAV_TS}.docker.save.tgz | docker load
```

## Miscellany

### Debugging the Image

If you need to debug the image, use the `bash` script. This provides a
bash shell inside a new container.
