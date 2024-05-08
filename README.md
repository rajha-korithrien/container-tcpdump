# Alpine Based Tcpdump
This repo contains some minimal code to build a linux container image based on alpine that can be used to run tcpdump
on systems that don't have it (and it is difficult to install) but do have a container runtime.

The general idea is that you:
* Get the container image on your system
* Use your container runtime (i.e. docker or podman) to run the container in the host network namespace with the necessary
privileges

# Example
You can run a tcpdump by putting the container execution into the host network namespace:
```text
# docker run --net=host rajhakorithrien/container-tcpdump:4.99.4 -nnni yaocp2UUimcVgeP
Unable to find image 'rajhakorithrien/container-tcpdump:4.99.4' locally
4.99.4: Pulling from rajhakorithrien/container-tcpdump
bca4290a9639: Already exists
c24f7ff72a4c: Pull complete
770f6ed3b04a: Pull complete
Digest: sha256:ae6c7984f6168394527ebb1cbedc61708326e61c093bb15c849d762ba69b0b9d
Status: Downloaded newer image for rajhakorithrien/container-tcpdump:4.99.4
tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
listening on yaocp2UUimcVgeP, link-type EN10MB (Ethernet), snapshot length 262144 bytes
```

In this example we start the container with standard tcpdump arguments. Note the use of `--net=host` also node that you
might need to use `--privileged` flag depending on your circumstances.

# Building
For anyone that wants to build the image you need 2 things:

* make (well technically not, you could look at the contents of the Makefile and manually do what make does)
* podman (also technically not, you could also use docker)

The expected build mechanism is (in a terminal at the top level of the checkout of the repo):
```text
make
```

Which should result in building an image for each platform. You should see things like:
```text
[linux/amd64] STEP 1/5: FROM alpine:3.19.1
...
[linux/arm64] STEP 1/5: FROM alpine:3.19.1
...
Writing manifest to image destination
```

Pushing the results to a remote registry will have access control details specific to that registry. Once you have correctly
setup whatever access tokens are needed, you can use:
```text
make push
```

Which will result in something like this:
```text
...
Getting image list signatures
Copying 2 images generated from 2 images in list
Copying image sha256:98bd9228262d888fc867518186bd6c6c1094fb2209098320e659df8a36ebce37 (1/2)
Getting image source signatures
Copying blob sha256:5723df8c9ef650995f34028efbc6ff21098e666f702368f12bc441a3228cb8d6
Copying blob sha256:d4fc045c9e3a848011de66f34b81f052d4f2c15a17bb196d637e526349601820
Copying blob sha256:8aa2b49df4efb6ca0c8a268eaa6f42028c67b8762843c4fb301df14567c79644
Copying config sha256:4a1954a3143eac3310f43e519c008493d6aa01bf86d3cfa6676ab7d9e920744a
Writing manifest to image destination
Copying image sha256:f0bf0c54a5c85920e0e322f767414583c59a4ccb5d3b14f968dfc196c1544475 (2/2)
Getting image source signatures
Copying blob sha256:5723df8c9ef650995f34028efbc6ff21098e666f702368f12bc441a3228cb8d6
Copying blob sha256:b09314aec293bcd9a8ee5e643539437b3846f9e5e55f79e282e5f67e3026de5e
Copying blob sha256:6b8a0bcfe29492dd0780b505d8744e00c3215e9b28582d87ccfcb5ba45cc6537
Copying config sha256:e2f0231196d7db130a66fad2465dfda72e38100d9ea4e5bb01c9e3d3bcdc0be1
Writing manifest to image destination
Writing manifest list to image destination
Storing list signatures
```

and you remote registry should have the manifest and images for each platform