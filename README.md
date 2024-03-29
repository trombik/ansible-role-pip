# `trombik.pip`

Install pip package(s), and create a symlink, `pip3`.

# Requirements

None

# Role Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `pip_packages` | list of pip package names to install | `{{ __pip_packages }}` |
| `pip_extra_packages` | list of extra packages to install | `[]` |
| `pip_executable_file` | real path to `pip`  executable | `{{ __pip_executable_file }}` |

## Debian

| Variable | Default |
|----------|---------|
| `__pip_packages` | `["python3-pip"]` |
| `__pip_executable_file` | `/usr/bin/pip3` |

## FreeBSD

| Variable | Default |
|----------|---------|
| `__pip_packages` | `["py38-pip"]` |
| `__pip_executable_file` | `/usr/local/bin/pip-3.8` |

## OpenBSD

| Variable | Default |
|----------|---------|
| `__pip_packages` | `["py3-pip"]` |
| `__pip_executable_file` | `/usr/local/bin/pip3.8` |

# Dependencies

None

# Example Playbook

```yaml
---
- hosts: localhost
  roles:
    - ansible-role-pip
  post_tasks:
    - name: Install platformio
      ansible.builtin.pip:
        name: platformio
        extra_args: --user
      become: yes
      become_user: vagrant
      # pip needs `-H` when sudo is used
      become_flags: -H
  vars:
```

# License

```
Copyright (c) 2019 Tomoyuki Sakurai <y@trombik.org>

Permission to use, copy, modify, and distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
```

# Author Information

Tomoyuki Sakurai <y@trombik.org>

This README was created by [qansible](https://github.com/trombik/qansible)
