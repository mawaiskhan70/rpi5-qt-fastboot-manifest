# Boot Time Analysis

## How to Measure

### Wall-clock time (what the user experiences)
Use a stopwatch or phone camera (slow-mo) from power-on to first frame.
This is the only number that matters for the end goal.

### Kernel + userspace time (what systemd-analyze measures)
```bash
systemd-analyze time
```
Reports kernel + userspace separately. Does NOT include the firmware phase.

```bash
systemd-analyze blame
```
Shows which systemd unit cost what — your primary tool for userspace tuning.

```bash
systemd-analyze critical-chain
```
Shows the actual dependency bottleneck path — often more useful than blame.

## Baseline (unoptimized Yocto image)
| Phase              | Time     |
|--------------------|----------|
| Firmware (SD)      | ~5–6s    |
| Kernel             | TBD      |
| Userspace          | TBD      |
| Qt first frame     | TBD      |
| **Total**          | **TBD**  |

## Results Log
<!-- Update this table after each optimization iteration -->

| Date | Change made | Firmware | Kernel | Userspace | Qt frame | Total |
|------|-------------|----------|--------|-----------|----------|-------|
| -    | Baseline    | TBD      | TBD    | TBD       | TBD      | TBD   |

## Key Insight
`systemd-analyze` time ≠ wall-clock time.
The firmware phase (~4–6s on SD) runs before the kernel starts and is
invisible to all software measurement tools. Always measure wall-clock
separately with a physical timer.
