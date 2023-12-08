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

Run Buildroot Docker container.

```
$ make run ARGS='-v /path/to/linux-on-litex-vexriscv:/linux-on-litex-vexriscv'
```

In Docker container, run Buildroot.

```
$ make BR2_EXTERNAL=/linux-on-litex-vexriscv/buildroot litex_vexriscv_defconfig
$ make
```

It builds `fw_jump.bin`, `Images`, and `rootfs.cpio`, places them in
`/output/images` where is mounted from `images` also place symlinks in
`/linux-on-litex-vexriscv/images` where is mounted from
`/path/to/linux-on-litex-vexriscv/images`,
but these are pointing the locaiton in container thus replace them with
the one in `images`.
