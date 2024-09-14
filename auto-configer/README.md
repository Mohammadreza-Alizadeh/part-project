# Penguin Emperor's Firewall & System Configuration 🐧

This project automates the initial configuration of a Linux server, including user creation, firewall setup with `nftables`, SSH, NTP, and cron services. Ideal for penguins ruling over their Linux realm with secure infrastructure!

## Key Features 🛠️

### 1. **User Creation & Sudo Access**
- Creates a new user with a specified username.
- Grants the user `sudo` privileges for system administration.

### 2. **Change System Repositories**
- Updates the system to use Debian 12 Iran repositories.
- Supports changing sources using a custom `sources.list` file via `-f` option.

### 3. **SSH Configuration**
- Changes the default SSH port (default: `2324`).
- Customizes the SSH welcome message 
- Disables root login for enhanced security.

### 4. **NTP (Network Time Protocol) Setup**
- Configures the system to sync time with `pool.ntp.org` for accurate timekeeping.

### 5. **Cron Job Setup**
- Sets up a cron job to run every 2 minutes, gathering system data such as:
  - The total number of processes running as root.
  - All listening ports.
  - A list of users with UID less than 1000.

  ##### this one is important
- Outputs are appended to files in `/data/opt/`. I know it's a wierd location. it's because my document viewer tried to convert texts to RTL and messed up with english words direction, thereofore i tught this is the right location to put data  

### 6. **NFTables Firewall Configuration**
- Blocks **all incoming traffic** except for SSH.
- Accept only **self-established** incoming trafic
- Adds counters to monitor the number of requests to `org.debian.deb` and logs packet counts.

---

## How to Use

### Prerequisites
- **Debian 12** or compatible Linux distribution.
- Administrative (root) access to the server.

### Installation
Clone the repository and navigate to the auto-configer folder:

```bash
git clone https://github.com/Mohammadreza-Alizadeh/part-project.git
cd part-project/auto-configer
```
In this direcory there is a `.deb` package that you can install like any other debian package using : 
```bash
sudo dpkg -i <packagename.deb>
```

after installation you can run it by just typing `part` command ( must be root or have sudo privilage )
```bash
sudo part # show help
```

or if you want to install it without `dpkg`, you can do so by navigating to `./src` directory where source codes are placed. there is a `installer.sh` that you run and it will copy each file to its appropriated location **( not recommended )**

## Folder and File Structure

The project is organized as follows:

```bash
/usr/local/bin/
    └── part                           

/usr/local/share/part-tools/
    ├── change-sources.sh  
    ├── create-user.sh     
    ├── config-nft.sh      
    ├── config-ntp.sh                  
    ├── config-ssh.sh                  
    ├── data-collector.sh              
    └── setup-cron.sh 
    
/var/log/
    ├──  part-tool.log
```

### Explanation

*   **`/usr/local/bin/part`**:  
    The main script of the project. Users ( with sudo ) can execute this from the command line to perform various system management tasks, such as creating users, configuring SSH, or setting up cron jobs.
    
*   **`/usr/local/share/part-tools/`**:  
    This directory contains helper scripts used by `part`. These scripts handle specific tasks like configuring the firewall, setting up NTP, or managing package sources. The scripts in this folder are not meant to be run directly by the user but are sourced or called by `part`.
    
* **`/var/log/part-tool.log`**
    Just a normal log file.


