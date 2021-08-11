buildroot-docker
================

A simple build environment for [Buildroot](https://buildroot.org/)
by using Docker.


Usage
-----

Use following command to build Docker image, volumes with volume only
container, and run a shell for the Buildroot.

```
make image volumes run
```

- The working directory is `/buildroot`, where the Buildroot is
  checked out.
- The default output directory `/output` and download directory
  `/buildroot/dl` are in volume only container.
- `images` is mounted `/output/images` to retrieve the images built.

> NOTE: See `Dockerfile` why it is using `/output` instead of
> default `/buildroot/output`.

### Example usage for Linux on LiteX VexRiscv

This is an example usage to build Linux image for
[Linux on LiteX VexRiscv](https://github.com/litex-hub/linux-on-litex-vexriscv).

```
$ make run ARGS='-v /path/to/linux-on-litex-vexriscv:/linux-on-litex-vexriscv'
$ make BR2_EXTERNAL=/linux-on-litex-vexriscv/buildroot litex_vexriscv_defconfig
$ make
```

Then you will get `Images`, `root.cpio`, place them in
`/path/to/linux-on-litex-vexriscv/images`.

Then, use `lxterm --images images/boot.json ...` or write them in a SD
Card and boot from the SD Card.
