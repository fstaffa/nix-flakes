# General

### Apply home manager

```sh
nix-shell -p home-manager
nix-shell -p git
cd $(mktemp -d)
git clone --depth 1 https://github.com/fstaffa/nix-configuration.git
home-manager switch --flake "."
```

### Try gpg

after install, gpg has problem using yubikey and this unblocks it

```sh
echo "test" | gpg --clearsign
```

### Chezmoi install

```sh
chezmoi init --source ~/.local/share/chezmoi git@github.com:fstaffa/dotfiles.git
```

### Refresh fonts

```sh
fc-cache -f -v
```

# Install macos

```sh
nix shell --extra-experimental-features nix-command --extra-experimental-features flakes "nixpkgs#git"
cd $(mktemp -d)
git clone https://github.com/fstaffa/nix-configuration.git
nix shell --extra-experimental-features nix-command --extra-experimental-features flakes "nixpkgs#home-manager"
home-manager switch --flake ".#raptor" --extra-experimental-features "flakes nix-command"


nix build ".#darwinConfigurations.raptor.system"

printf 'run\tprivate/var/run\n' | sudo tee -a /etc/synthetic.conf
/System/Library/Filesystems/apfs.fs/Contents/Resources/apfs.util -t

./result/sw/bin/darwin-rebuild switch --flake ".#fstaffa@raptor"
```
## Download apps
```sh
cd $(mktemp -d)
curl --location "https://download.mozilla.org/?product=firefox-latest-ssl&os=osx&lang=en-US" --output Firefox.dmg
curl --location "https://dl.pstmn.io/download/latest/osx_arm64" --output Postman.zip
open .
```

# Linux with zfs

```sh
git clone --depth 1 https://github.com/fstaffa/nix-configuration.git
cd nix-configuration/nixos-configurations/hosts/iguana

find /dev/disk/by-id -not -name "*-part*"
source zfs-install.sh $DISK

nixos-install --root "${MNT}" --flake "${MNT}/etc/nixos#iguana"

umount -Rl "${MNT}"
zpool export -a
swapoff -a
reboot
```

# Install vm

```sh
sudo -i
export ROOT_DISK=/dev/sda
parted -a opt --script "${ROOT_DISK}" \
    mklabel gpt \
    mkpart primary fat32 0% 512MiB \
    mkpart primary 512MiB 100% \
    set 1 esp on \
    name 1 boot \
    set 2 lvm on \
    name 2 root

fdisk /dev/vda -l

mkfs.fat -F 32 -n boot /dev/sda1
mkfs.ext4 -L nixos /dev/sda2


mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot

git clone https://github.com/fstaffa/nix-configuration.git /mnt/etc/nixos

nixos-install --root /mnt --flake /mnt/etc/nixos#vm-test
```
