# dotfiles

Declarative Guix configuration for my machines, plus the config files they
deploy.

## Layout

```
guix-config/
  channels.scm           bootstrap channels, free only (arbn)
  channels-nonfree.scm   bootstrap channels with nonguix
  signing-key.pub        substitute signing key, authorized by the system configs
  arbn/systems/          one file per machine
  arbn/modules/          shared package and service lists
  config-files/          files deployed into $HOME
```

Custom packages (the `arbn` channel) live in a separate repo:
[aurbsn/arbn-guix-channel](https://github.com/aurbsn/arbn-guix-channel).

## Machines

| Config | Kind | Notes |
| --- | --- | --- |
| `arbn-desktop` | Guix System | NVIDIA, GNOME on Xorg via lightdm, libvirt, HiDPI |
| `arbn-dev` | Guix System | GNOME on Wayland via gdm |
| `hackpad` | Guix System | Free only, BIOS/GRUB on `/dev/sda` |
| `foreign-home` | `guix home` | Guix on a foreign distro |

All three Guix System configs use LUKS full-disk encryption and are built on
`arbn/systems/base-system.scm`, which sets locale, timezone, the `arbn` user,
and wires the home environment in via `guix-home-service-type`. That last part
means **a system reconfigure also deploys the home environment** — you do not
run `guix home reconfigure` separately on a Guix System machine.

## Bootstrapping a new machine

Pull the channels first, so the `arbn` channel (and nonguix, where needed) is
available:

```sh
guix pull -C guix-config/channels-nonfree.scm   # arbn-desktop, arbn-dev, foreign-home
guix pull -C guix-config/channels.scm           # hackpad, or any free-only machine
```

Then reconfigure. `-L guix-config` puts `arbn/...` on the load path:

```sh
sudo guix system reconfigure -L guix-config guix-config/arbn/systems/arbn-desktop.scm
guix home reconfigure -L guix-config guix-config/arbn/systems/foreign-home.scm
```

After the first reconfigure, `~/.config/guix/channels.scm` is generated from
`create-home-services`, and later `guix pull` runs use it instead of the
bootstrap files. The `#:free` argument controls whether nonguix ends up in
the generated file.

To check a change without activating it, swap `reconfigure` for `build`:

```sh
guix system build -L guix-config guix-config/arbn/systems/hackpad.scm -n
```

## Not in git

- `config-files/emacs.d/customizations/secrets.el` — API keys. Deploy by
  copying to `~/.emacs.d/secrets.el`, which `init.el` loads if present.
  `~/.emacs.d/customizations/` is a read-only store symlink, so it cannot
  live there.
