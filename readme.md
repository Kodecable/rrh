# RRH

Rolling Release Helper

* **Pre/Post Update Script Execution** : Execute scripts automatically before and after updates.
* **Update Output Logging** : Record the output of each update.
* **Update Output Digest** : Collect erros from the update output for quick reviews.
* **Update Time Recording** : Keep track of the timestamp of the last system update.
* **Timely Update Reminders** : Receive timely reminders to ensure your system stays up to date.

## Installation

### Arch

1. Download Arch package in [latest release](https://github.com/Kodecable/rrh/releases/latest).
2. Install package by  `pacman -U FILE`.
3. (If you are using AUR Helper) Config your username in `/etc/rrh/user`.
4. (Optional, Highly recommended) Install `less` and `expect` for better output.

### Other

1. Download Basic package in [latest release](https://github.com/Kodecable/rrh/releases/latest).
2. Copy the files from package to your filesystem.

### Source

1. lone this repository.
2. Execute `./build.bash fs`.
3. Copy the files from `build/fs` to your filesystem.

## **Configuration**

To configure RRH, edit `/etc/rrh/cmd/update` as follows:

```bash
#!/bin/bash
pacman -Syu # Replace with your update command
```

Ensure that this file has execute permissions.

For more advanced configuration, please refer to [doc/configuration](https://github.com/Kodecable/rrh/blob/main/doc/configuration.md).

## Usage

Update your system easily using either of the following commands:

```bash
$ rrh-full-update
```

or

```bash
$ rfu
```

View the output of your last update command:

```bash
$ rrh-view-output
```

(If you are using bash) Add the following command to your `.bashrc` for timely update reminders:

```bash
rrh-echo-reminder
```

For more advanced usage, please refer to [doc/usage](https://github.com/Kodecable/rrh/blob/main/doc/usage.md).

## License

GNU GPLv3
