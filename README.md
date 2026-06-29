# MK-fire wall

**Creator:** Madhan Kumar  
**Platform:** Kali Linux  
**Type:** Advanced Firewall Manager  
**Version:** 1.0.0

## Overview

MK-fire wall is a Bash-based firewall manager for Kali Linux using UFW. It provides a simple menu interface and command-line options for enabling, disabling, checking, and managing firewall rules.

## Features

- Secure default deny incoming policy.
- Allow outgoing traffic by default.
- SSH protection enabled automatically.
- Support for allow, deny, and limit rules.
- Status, reload, and reset commands.
- Clean terminal banner and menu interface.
- Logging enabled at medium level.

## Installation

```bash
git clone https://github.com/YOUR_USERNAME/MK-fire-wall.git
cd MK-fire-wall
chmod +x mk-fire-wall.sh
```

## Usage

### Interactive mode

```bash
sudo ./mk-fire-wall.sh
```

### Direct commands

```bash
sudo ./mk-fire-wall.sh --enable
sudo ./mk-fire-wall.sh --disable
sudo ./mk-fire-wall.sh --status
sudo ./mk-fire-wall.sh --reload
sudo ./mk-fire-wall.sh --reset
sudo ./mk-fire-wall.sh --allow 80/tcp
sudo ./mk-fire-wall.sh --deny 23/tcp
sudo ./mk-fire-wall.sh --limit 22/tcp
```

## What enable does

When you enable MK-fire wall, it applies these secure defaults:

```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow OpenSSH
sudo ufw logging medium
sudo ufw --force enable
```

## Common UFW commands

```bash
sudo ufw status verbose
sudo ufw allow 443/tcp
sudo ufw deny 25/tcp
sudo ufw limit 22/tcp
sudo ufw reload
sudo ufw reset
sudo ufw disable
```

## Best practices

- Keep only required ports open.
- Use `limit` for SSH to reduce brute-force attacks.
- Add trusted IP rules only when needed.
- Check `ufw status verbose` after changes.

## Screenshots

Add terminal screenshots here after testing.

## License

MIT License
