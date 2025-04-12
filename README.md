```markdown
# LSM – Local Server Manager (by Mealman1551)

[![License](https://img.shields.io/github/license/mealman1551/lsm)](LICENSE)
[![GitHub Repo stars](https://img.shields.io/github/stars/mealman1551/lsm?style=social)](https://github.com/mealman1551/lsm/stargazers)
[![Code Size](https://img.shields.io/github/languages/code-size/mealman1551/lsm)](https://github.com/mealman1551/lsm)
[![Issues](https://img.shields.io/github/issues/mealman1551/lsm)](https://github.com/mealman1551/lsm/issues)
[![Release](https://img.shields.io/github/v/release/mealman1551/lsm?include_prereleases)](https://github.com/mealman1551/lsm/releases)

**LSM (Local Server Manager)** is an automated, interactive tool for managing an Apache web server on Linux. With just a few keystrokes, you can create websites, deploy files, and manage permissions as if it were magic.  

> Written in pure Bash with no external dependencies other than Apache (and optionally PHP).
```markdown
# LSM – Local Server Manager (by Mealman1551)

[![License](https://img.shields.io/github/license/mealman1551/lsm)](LICENSE)
[![GitHub Repo stars](https://img.shields.io/github/stars/mealman1551/lsm?style=social)](https://github.com/mealman1551/lsm/stargazers)
[![Code Size](https://img.shields.io/github/languages/code-size/mealman1551/lsm)](https://github.com/mealman1551/lsm)
[![Issues](https://img.shields.io/github/issues/mealman1551/lsm)](https://github.com/mealman1551/lsm/issues)
[![Release](https://img.shields.io/github/v/release/mealman1551/lsm?include_prereleases)](https://github.com/mealman1551/lsm/releases)

**LSM (Local Server Manager)** is an automated, interactive tool for managing an Apache web server on Linux. With just a few keystrokes, you can create websites, deploy files, and manage permissions as if it were magic.  

> Written in pure Bash with no external dependencies other than Apache (and optionally PHP).

---

## Features

- Install and start Apache with a single command
- Automatically create VirtualHosts on port 80
- Deploy files or directories to specific websites
- Fix file permissions (chmod + chown)
- Full `lsm-info.txt` with metadata per site
- Looping menu: doesn't exit after each action
- Automatically generated `index.html` or `index.php`
- Clean, minimalistic shell script without comments

---

## Installation

### 1. Clone the repository

```bash
git clone https://github.com/mealman1551/lsm.git
cd lsm
chmod +x lsm.sh
```

### 2. Run the script

```bash
sudo ./lsm.sh
```

Make sure to run the script with root privileges (for example via `sudo`) as it needs to manage Apache and write to `/var/www/`.

---

## Menu Options

After running the script, you will be presented with the following menu:

```
=== Mealman1551's LSM ===
1) Install Apache (and default page)
2) Create a new virtual host
3) Deploy file or directory to site
4) Fix file permissions for site
5) List active LSM sites
q) Quit
```

---

## Example: Created Page

By default, the `index.html` page created looks like this:

```html
<!DOCTYPE html>
<html>
    <head><title>Web Server</title></head>
    <body>
        <h1>Apache is running</h1>
        <h2>Powered by Mealman1551's LSM (Local Server Manager)</h2>
    </body>
</html>
```

Or a PHP test page if you choose that option during site creation.

---

## Site Structure

Each website is created within `/var/www/`, and the following structure is used:

- `/var/www/<sitename>/`: The root directory for the website.
- `/var/www/<sitename>/index.html` or `index.php`: The main page for the site.
- `/var/www/<sitename>/lsm-info.txt`: Metadata file with details about the site, including whether PHP is enabled.

### Example:

```
/var/www/mysite/
        index.html
        lsm-info.txt
```

---

## Usage Instructions

### Install Apache and set up the default page

This option installs Apache and creates a default page at `/var/www/html/index.html`.

### Create a New Virtual Host

You can create a new virtual host by choosing this option. It will prompt you for the site name, whether to enable directory indexing, and whether to enable PHP. It will create the website's root directory, assign appropriate permissions, and create a VirtualHost configuration file.

### Deploy File or Directory to Site

This option allows you to deploy files or directories to an already existing site. You will need to specify the target site and the file or folder you want to upload.

### Fix File Permissions for Site

This option allows you to fix file permissions for a specific site. It sets appropriate ownership and permissions on the site's files and directories to ensure they are served correctly by Apache.

### List Active LSM Sites

Lists all active sites managed by LSM. Each site will have an `lsm-info.txt` file, containing metadata about the site.

---

## Example Outputs

### When creating a new site:

```
Enter site name (e.g. mysite): mysite
Enable directory indexing? (y/n): y
Enable PHP? (y/n): y
Created by Mealman1551's LSM
Site: mysite
Created: Sat, 10 Apr 2025 12:34:56
Root: /var/www/mysite
PHP: yes
Indexing: yes
```

```
Site 'mysite' created at /var/www/mysite
```

### When deploying files:

```
Enter site name: mysite
Enter path to file or folder to deploy: /home/user/project_files
Deployed to /var/www/mysite/
```

---

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

---

## Contributing

If you have suggestions or improvements, feel free to open an issue or submit a pull request!

---

## Support

If you have any questions, feel free to open an issue in the GitHub repository.

---

## Stars

If you find this project useful, please consider giving it a star on GitHub.
```
---

## Features

- Install and start Apache with a single command
- Automatically create VirtualHosts on port 80
- Deploy files or directories to specific websites
- Fix file permissions (chmod + chown)
- Full `lsm-info.txt` with metadata per site
- Looping menu: doesn't exit after each action
- Automatically generated `index.html` or `index.php`
- Clean, minimalistic shell script without comments

---

## Installation

### 1. Clone the repository

```bash
git clone https://github.com/mealman1551/lsm.git
cd lsm
chmod +x lsm.sh
```

### 2. Run the script

```bash
sudo ./lsm.sh
```

Make sure to run the script with root privileges (for example via `sudo`) as it needs to manage Apache and write to `/var/www/`.

---

## Menu Options

After running the script, you will be presented with the following menu:

```
=== Mealman1551's LSM ===
1) Install Apache (and default page)
2) Create a new virtual host
3) Deploy file or directory to site
4) Fix file permissions for site
5) List active LSM sites
q) Quit
```

---

## Example: Created Page

By default, the `index.html` page created looks like this:

```html
<!DOCTYPE html>
<html>
    <head><title>Web Server</title></head>
    <body>
        <h1>Apache is running</h1>
        <h2>Powered by Mealman1551's LSM (Local Server Manager)</h2>
    </body>
</html>
```

Or a PHP test page if you choose that option during site creation.

---

## Site Structure

Each website is created within `/var/www/`, and the following structure is used:

- `/var/www/<sitename>/`: The root directory for the website.
- `/var/www/<sitename>/index.html` or `index.php`: The main page for the site.
- `/var/www/<sitename>/lsm-info.txt`: Metadata file with details about the site, including whether PHP is enabled.

### Example:

```
/var/www/mysite/
        index.html
        lsm-info.txt
```

---

## Usage Instructions

### Install Apache and set up the default page

This option installs Apache and creates a default page at `/var/www/html/index.html`.

### Create a New Virtual Host

You can create a new virtual host by choosing this option. It will prompt you for the site name, whether to enable directory indexing, and whether to enable PHP. It will create the website's root directory, assign appropriate permissions, and create a VirtualHost configuration file.

### Deploy File or Directory to Site

This option allows you to deploy files or directories to an already existing site. You will need to specify the target site and the file or folder you want to upload.

### Fix File Permissions for Site

This option allows you to fix file permissions for a specific site. It sets appropriate ownership and permissions on the site's files and directories to ensure they are served correctly by Apache.

### List Active LSM Sites

Lists all active sites managed by LSM. Each site will have an `lsm-info.txt` file, containing metadata about the site.

---

## Example Outputs

### When creating a new site:

```
Enter site name (e.g. mysite): mysite
Enable directory indexing? (y/n): y
Enable PHP? (y/n): y
Created by Mealman1551's LSM
Site: mysite
Created: Sat, 10 Apr 2025 12:34:56
Root: /var/www/mysite
PHP: yes
Indexing: yes
```

```
Site 'mysite' created at /var/www/mysite
```

### When deploying files:

```
Enter site name: mysite
Enter path to file or folder to deploy: /home/user/project_files
Deployed to /var/www/mysite/
```

---

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

---

## Contributing

If you have suggestions or improvements, feel free to open an issue or submit a pull request!

---

## Support

If you have any questions, feel free to open an issue in the GitHub repository.

---

## Stars

If you find this project useful, please consider giving it a star on GitHub.
```