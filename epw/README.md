# EPWeather - Weather Automation Script

**EPWeather** is a bash script that retrieves and logs weather conditions for multiple cities. It supports periodic updates using a systemd timer and logs weather data to a local directory. It also allows real-time weather retrieval without logging, and it maintains a list of cities in a text file for easy management.

## Features

- **List of cities**: View or manage a list of cities for which you want to retrieve weather information.
- **Automatic weather updates**: Every 10 minutes, weather data for all listed cities is fetched and stored.
- **Real-time weather**: Retrieve the current weather for any city without updating the database.
- **Logging**: Weather data is logged to `/var/log/epweather/epw.log`.
- **User-friendly**: Automatically installs and sets up a systemd timer for weather updates.

## Installation

1. Clone part-project 
   ```bash
   git clone https://github.com/Mohammadreza-Alizadeh/part-project.git
   ```
2. Change directory to epw
   ```bash
   cd part-project/epw
   ```
3. Give execute permission to ./install.sh Run the installer.sh
    ```bash
    sudo chmod +x ./install.sh
    ```
4. Now Run ./install.sh, this will install the script and also create a service that runs `epw -u` and also creates a timer using **systemd-timer feature** that trigers mentiond service every 10 minutes    
    ```bash
    sudo ./install.sh
    ```

5. After installation you can use `epw` to run the script
    ```bash
    epw -h # show help
    ```

## Installed File Directories

After running the installation, several important directories and files are created. Here's a breakdown of where everything is located:

### 1. **Script Directory: `/opt/data/epweather/`**

   - **Purpose**: This directory is where the main script (`epwtr`) is installed.
   - **Contents**: 
     - `epwtr`: The main script that handles weather updates, city management, and real-time weather checks.
     - `db/cities.txt`: This file stores the list of cities for which weather updates are retrieved.

   - **Path**: `/opt/data/epweather/`
   
   Ensure that the script has execute permissions and that the directory is readable and writable by the necessary users.

### 2. **Database Directory: `/opt/data/epweather/db/`**

   - **Purpose**: This directory stores the database file that contains the list of cities.
   - **Contents**:
     - `cities.txt`: A text file that holds the names of the cities you want to track.

   - **Path**: `/opt/data/epweather/db/`

   This file will be updated whenever you add or remove cities using the script options.

### 3. **Log Directory: `/var/log/epweather/`**

   - **Purpose**: This directory stores log files where the weather updates for all cities are recorded.
   - **Contents**:
     - `epw.log`: A log file that records data for every time the script runs.
   
   - **Path**: `/var/log/

### 4. **Soft-link: `/usr/local/bin/epw`**

   - **Purpose**: This softlink allows users to run the script in command line in any location that they are in currenty just by typeing `epw` 
   - **Contents**:
     - `epw`: A soft link to `/opt/data/epweather/epwtr`
   
   - **Path**: `/usr/local/bin/epw` -> `/opt/data/epweather/epwtr/`







