## Scripts for Ubuntu set up after fresh install

Tested on 22.04.4 and 24.04 LTS releases

### Usage

```bash
git clone https://github.com/boldyshev/ubuntu-install.git
cd ubuntu-install
bash install.sh 24.04 # or 22.04
```
User name, necessary paths and IPs are sourced from [`config/install.conf`](config/install.conf) file as variables


### What does it do:

1. Change `/etc/resolv.conf` symlink from 
   ```
   /run/systemd/resolve/stub-resolv.conf
   ``` 
   to 
   ```
   /run/systemd/resolve/resolv.conf
   ```
   It disables local DNS caching which is known to cause problems with domain names resolving 
   https://github.com/systemd/systemd/issues/5755 <br>
   Terminal command
   ```
   sudo ln -sfn /run/systemd/resolve/resolv.conf /etc/resolv.conf
   ```
2. 
   ```
   apt update && apt upgrade
   ```

3. Generate ssh keys and copy public key to local Network Attached Storage
4. Install apts<br>
   ```
   xargs sudo apt install -y < "${SCRIPT_DIR}/config/list_apts"
   ```
5. Install snaps. Attempt to install multiple snaps with 
   ```
   sudo snap install <package_1> <package_2>
   ``` 
   returns
   ```
   error: cannot specify mode for multiple store snaps (only for one store snap or several local ones)
   ```

   Installing in a loop is OK, but it won't output the snap downloading progress in terminal<br>
    ```
    while read p; do
     sudo snap install $p
    done < "${SCRIPT_DIR}/config/list_snaps"
    ```
   So I ended up installing snaps line by line
6. Install from deb packages. [`deb.sh`](deb.sh) function is used. Input_remapper 2 doesn't have static download link for 
it's latest release, so the latest release number is scraped from the webpage 
https://github.com/sezanzeb/input-remapper/releases/latest with `curl` and `grep` ([`deb_input_remapper.sh`](deb_input_remapper.sh)).
7. Load various UI and keymap configurations. Main part is saving/loading gnome config via `dconf load / < file.dconf`<br>
https://askubuntu.com/questions/984205/how-to-save-gnome-settings-in-a-file
8. Install `ubuntu-restricted-extars` in the end as the component `ttf-mscorefonts-installer` prompts a window to read 
the Microsoft Software License Agreement which may break you terminal session sometimes
9. Reboot