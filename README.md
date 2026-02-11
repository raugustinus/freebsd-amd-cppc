# AMD CPPC cpufreq driver for FreeBSD

A FreeBSD kernel module that enables AMD CPPC (Collaborative Processor Performance
Control) for fine-grained CPU frequency scaling on Zen 2+ processors.

## Background

I have a Lenovo Yoga Slim 7 (82CY / 13ACN5) with an AMD Ryzen 7 5800U that was
draining its battery rapidly under FreeBSD. The legacy hwpstate driver only exposes
a handful of discrete P-state frequency steps. This CPPC driver replaces it with
continuous frequency scaling from ~400 MHz to full boost, guided by an Energy
Performance Preference (EPP) hint — letting the CPU idle much lower and scale
much smoother.

Built with the help of [Claude Code](https://claude.ai/claude-code).

## What it does

- Reads per-core CPPC capabilities from MSR `0xC00102B0` (CAP1)
- Enables autonomous frequency management via MSR `0xC00102B1` (ENABLE)
- Programs frequency bounds and EPP via MSR `0xC00102B3` (REQ)
- Exposes ~30 frequency steps to the cpufreq framework (vs ~3 from hwpstate)
- Provides a `dev.amd_cppc.N.epp` sysctl for per-core power/performance tuning
- Supports suspend/resume

## Tested on

- Lenovo Yoga Slim 7 13ACN5 — Ryzen 7 5800U (Zen 3, Family 19h) — FreeBSD 15.0-RELEASE

Should work on any AMD Zen 2+ (Family 17h+) with CPPC support.

## Building and installing

Requires FreeBSD kernel source tree in `/usr/src`.

```sh
make
sudo cp amd_cppc.ko /boot/modules/
sudo kldload /boot/modules/amd_cppc.ko
```

To load at boot, add to `/boot/loader.conf`:

```
amd_cppc_load="YES"
```

## Next up

- Testing S0ix (Modern Standby) suspend support
- Validation on Zen 2 (Ryzen 7 4800U)

## License

This project is licensed under the BSD 2-Clause License. See [LICENSE](LICENSE) for details.

## Disclaimer

THIS SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND. USE AT YOUR OWN
RISK. This is a kernel module that writes to CPU MSRs — bugs could cause system
instability or crashes. The author accepts no liability for any damage resulting
from its use.
