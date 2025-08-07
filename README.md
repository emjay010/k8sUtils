# Kubernetes & Helm Alias Manager (`set-alias.sh`)

`set-alias.sh` is a flexible, user-friendly Bash script to manage efficient Kubernetes (`kubectl`) and Helm alias commands. It provides dynamic namespace handling, seamless binary path configuration, and automatic alias persistence for interactive shell sessions.

---

## Features

- Define and manage concise `k*` aliases for `kubectl` commands and `h*` aliases for `helm`.
- Dynamic namespace variables `${KUBE_NAMESPACE}` and `${HELM_NAMESPACE}`, evaluated at runtime.
- Easily customize `kubectl` and `helm` binary paths.
- Add your own custom aliases with optional descriptions.
- Atomic and idempotent alias file management with persistent storage.
- Alias list, reload, and clear operations.
- Supports dry run, verbose, quiet, and force-overwrite modes.
- Auto-regenerates and reloads aliases after namespace or binary changes to reflect updates immediately.
- Compatible with Bash 4.0+.

---

## Installation

1. **Download or clone the script:**  
   Place `set-alias.sh` in your preferred directory, such as your home directory or a dev tools folder.

2. **Make sure the script is readable:**  
chmod +r set-alias.sh

3. **(Optional) Add your custom binaries:**  
If you use custom `kubectl` or `helm` binaries (like `oc` or `helm3`), note their absolute paths.

4. **(Optional) Choose alias storage location:**  
By default, aliases are stored in `.k8s_aliases` in the current directory when sourcing. You can override by setting the environment variable `ALIAS_FILE`, or by using the script's `-f` option.

---

## Usage

> **Important:** Always **source** the script rather than executing it, so environment variables and aliases are set in your current shell session.

source /path/to/set-alias.sh [options]

### Common Commands

| Option                       | Description                                        |
|------------------------------|--------------------------------------------------|
| `-n <namespace>`              | Set both Kubernetes and Helm namespace            |
| `-k <namespace>`              | Set Kubernetes namespace only                      |
| `-H <namespace>`              | Set Helm namespace only                            |
| `-b <kubectl> <helm>`         | Set custom kubectl and helm binaries               |
| `-a <alias> <cmd> [desc]`    | Add a custom alias with optional description      |
| `-f <alias_file>`             | Use a custom alias file                            |
| `-l`                         | List current `k*` and `h*` aliases                 |
| `-s`                         | Show current configuration                         |
| `-r`                         | Reload aliases from the alias file                  |
| `-c`                         | Clear all `k*` and `h*` aliases                    |
| `--force`                    | Force overwrite existing aliases                   |
| `--dry-run`                  | Preview alias creation without applying            |
| `--quiet` or `-q`            | Silence non-error output                            |
| `-v`                         | Verbose output                                     |
| `-h` or `--help`             | Show help and usage                                |

### Examples
Initialize default aliases, auto-create alias file
source set-alias.sh

Set namespaces (aliases reload automatically)
source set-alias.sh -n production

Set custom binaries for kubectl and helm
source set-alias.sh -b /root/exec/kubectl /root/exec/helm3

Add a custom alias
source set-alias.sh -a kgsw "kubectl get svc -o wide" "Get wide services"

List all current aliases
source set-alias.sh -l

Reload aliases manually
source set-alias.sh -r

Clear all Kubernetes and Helm aliases (k*/h*)
source set-alias.sh -c
---

## Setting Up Automatic Alias Loading

To automatically load your aliases in new shell sessions, add the following line (adjusting the path to your alias file if needed) into your shell startup file, such as `~/.bashrc` or `~/.zshrc`:

source /full/path/to/.k8s_aliases 2>/dev/null || true

This ensures aliases are loaded every time you open a shell.

If you use the default alias file location (current directory), consider placing this sourcing command in project-specific scripts or manual session initialization.

---

## Notes & Tips

- Aliases use **runtime namespace variables**, so changing the namespace variable via `-n`, `-k`, or `-H` will immediately affect all aliases.
- The script requires **Bash 4.0 or higher** for associative array support.
- When adding custom aliases, if your command involves `kubectl` or `helm` but lacks namespace flags, the namespace will be automatically appended.
- Reloading aliases (`-r`) reloads all aliases from the alias file and is done automatically after namespace or binary changes.
- Use `--force` to overwrite existing aliases.
- Use `--dry-run` to preview alias definitions without applying.

---

## Troubleshooting

- **Aliases not working as expected?**  
  Ensure you **source** the script instead of executing it. Aliases and environment variable exports only apply to the current shell session if sourced.

- **Command not found errors for kubectl or helm inside aliases?**  
  Ensure you set the `-b` option with full paths to your binaries before loading aliases or add your binary directory to your PATH.

- **Changes in namespace not reflecting immediately?**  
  The script automatically reloads aliases after namespace change, but make sure you didn't clear aliases (`-c`) without re-initializing.

---

## License

This script is provided as-is with no warranty. Use at your own risk.

---

## Contact

For support or contributions, please open an issue or pull request in the repository hosting this script.

---

Happy Kubernetes & Helm aliasing! 🚀
