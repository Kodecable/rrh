# RRH Configuration

[toc]

## Doas

Sudo and OpenDoas are supported out-of-the-box. If both of them exist, Sudo will be used.

If you are using another solution, you need to create `/etc/rrh/cmd/doas`, and it should look like `Usage: /etc/rrh/cmd/doas USER COMMAND...`

## User & Privilege Elevation

By default, `rrh-full-update` will attempt to elevate to root. When `/etc/rrh/auto_sudo` exists, `rrh-remove-action`, `rrh-mark-update`, and `rrh-auto-remove` will also attempt to elevate.

If `/etc/rrh/user` exists, `rrh-full-update` will execute the update command as the configured user.

## Auto Remove

By default, `rrh-auto-remove` will be executed after the update to control disk usage. It will remove old actions and keep actions less than or equal to 5.

If you do not want auto remove after an update, create `/etc/rrh/no_auto_remove`.

If you want to change the `KEEP_COUNT`, edit `/etc/rrh/keep_count`.

## Auto Digest

`rrh-output-digest` can digest command output by only printing error messages.

If you want to get a digest automatically after an update, create `/etc/rrh/auto_digest`.

## Outdated Time

By default, your system will be considered outdated after 7 days.

If you want to change this, edit `/etc/rrh/outdate_time`.

## Pre/Post Update Script

`/etc/rrh/cmd/pre_update` and `/etc/rrh/cmd/post_update` will be executed before/after update.

`pre_update` fail will abort update.

## Auto check

`rrh-auto-check` will execute `/etc/rrh/cmd/auto_check_outdated` when the system is outdated.

A systemd timer called `rrh-daily-check.timer` is available out-of-the-box to execute `rrh-auto-check` daily.
