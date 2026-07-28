# Audio Setup on Arch Linux (PipeWire)

This machine (`rocket`) uses **PipeWire** as the audio server with **WirePlumber** as the session
manager. This is the modern Arch Linux default and replaces the legacy PulseAudio stack.

---

## Stack Overview

| Component | Package | Role |
|---|---|---|
| `pipewire` | `pipewire` | Core audio/video router |
| `pipewire-audio` | `pipewire-audio` | Audio support for PipeWire |
| `pipewire-pulse` | `pipewire-pulse` | PulseAudio compatibility layer |
| `wireplumber` | `wireplumber` | Session & policy manager |

> **Important:** Do **not** install the standalone `pulseaudio` package alongside PipeWire.
> They conflict over the ALSA device and will cause applications (e.g. Spotify) to produce
> no sound even though streams appear connected.

---

## Fresh Installation

Install the full PipeWire stack:

```bash
sudo pacman -S pipewire pipewire-audio pipewire-pulse wireplumber
```

Enable and start the user services:

```bash
systemctl --user enable --now pipewire pipewire-pulse wireplumber
```

---

## Migrating from PulseAudio to PipeWire

If you have the standalone PulseAudio installed, follow these steps to migrate cleanly.

### 1. Stop PulseAudio

```bash
systemctl --user stop pulseaudio.service pulseaudio.socket 2>/dev/null
pulseaudio --kill 2>/dev/null
```

### 2. Install `pipewire-pulse` (replaces PulseAudio)

```bash
sudo pacman -S pipewire-pulse
```

Pacman will automatically remove `pulseaudio` and `pulseaudio-bluetooth` since `pipewire-pulse`
conflicts with them. Confirm the removal when prompted.

### 3. Restart PipeWire services

```bash
systemctl --user restart pipewire wireplumber
```

### 4. Verify the setup

```bash
# PipeWire status — check Sinks, Sources and active Streams
wpctl status

# Should report: Server Name: PulseAudio (on PipeWire x.x.x)
pactl info
```

---

## Verifying Audio Health

### Check all services are running

```bash
systemctl --user status pipewire wireplumber
```

### Check available audio sinks and sources

```bash
pactl list sinks short
pactl list sources short
```

### Check default sink volume and mute state

```bash
pactl get-sink-volume @DEFAULT_SINK@
pactl get-sink-mute @DEFAULT_SINK@
```

Or using the WirePlumber CLI:

```bash
wpctl get-volume @DEFAULT_AUDIO_SINK@
```

### Check active audio streams (useful for debugging apps)

```bash
pactl list sink-inputs
```

---

## Common Issues

### No sound in Spotify (or other PulseAudio apps)

**Symptom:** Application is running and a stream appears in `pactl list sink-inputs`, but the sink
state is `SUSPENDED` and `wpctl status` shows no active streams.

**Cause:** Standalone `pulseaudio` is installed and conflicts with PipeWire over the ALSA device.

**Fix:** Follow the [migration steps](#migrating-from-pulseaudio-to-pipewire) above.

---

### Sink is SUSPENDED

A sink suspends automatically when idle — this is normal. It will resume as soon as an application
plays audio. If it stays suspended while audio should be playing, check for the PulseAudio conflict
described above.

---

### WirePlumber warnings on startup

The following warnings are **harmless** on this machine and can be ignored:

```
Failed to get percentage from UPower: org.freedesktop.DBus.Error.NameHasNoOwner
SPA handle 'api.libcamera.enum.manager' could not be loaded
```

The first is about battery info (irrelevant for desktops), the second is about libcamera support
for certain camera types.

---

## Hardware Reference

This machine has the following audio hardware:

```
card 0: PCH [HDA Intel PCH]
  - device 0: ALC298 Analog        ← main output (speakers/headphones)
  - device 3: HDMI 0
  - device 7: HDMI 1
  - device 8: HDMI 2
```

The default sink is `alsa_output.pci-0000_00_1f.3.analog-stereo` (ALC298 analog output).

To change the default output device permanently:

```bash
# List available sinks with their IDs
wpctl status

# Set a new default sink by ID
wpctl set-default <SINK_ID>
```

---

## Useful Tools

| Tool | Package | Purpose |
|---|---|---|
| `pavucontrol` | `pavucontrol` | GUI volume control & stream routing |
| `wpctl` | bundled with `wireplumber` | WirePlumber CLI |
| `pactl` | bundled with `pipewire-pulse` | PulseAudio-compatible CLI |
| `aplay -l` | bundled with `alsa-utils` | List ALSA hardware devices |
| `amixer` | bundled with `alsa-utils` | ALSA mixer controls |
