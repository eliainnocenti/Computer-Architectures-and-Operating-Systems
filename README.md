# Computer Architectures and Operating Systems

![polito](resources/logo_polito.jpg)

This repository contains all the materials and exercises for the **Computer Architectures and Operating Systems** course. The repository utilizes a script to keep all submodules up to date.
<!-- and provides a structured way to work on personal modifications within a separate branch. -->

## ⚠️ Important Notice

> **Note:** This repository is for educational purposes only. Make sure to follow the course rules and guidelines when utilizing these materials.

> **Note:** The current implementation is not fully up to date. Modifications will follow to address all outstanding issues.

<!-- > **Note:** The pulling and data collection from all submodules works, but managing the personal branch for developing personal modifications is still not functioning. -->

## Table of Contents

- [Overview](#overview)
- [Structure](#structure)
- [Current Repositories](#current-repositories)
- [Usage](#usage)
  - [Cloning the Repository](#cloning-the-repository)
  - [Running the Update Script](#running-the-update-script)
  - [Creating a Personal Branch](#creating-a-personal-branch)
- [Contributing](#contributing)
- [License](#license)

## Overview

This repository serves as a collection point for all the labs and exercises related to the course. It is designed to automatically clone or pull updates from the official teaching repositories and to provide a clear workflow for adding personal modifications to the exercises.

By using a script to manage submodules, the repository ensures that all dependencies and repositories are always up-to-date. 
<!-- The repository also supports working on a separate branch called `personal` to track personal modifications without affecting the main repository. -->

## Structure

- `Laboratories/`: Contains all laboratory repositories.
- `Exercises/`: Contains all exercise repositories.
- `urls.txt`: A file containing all repository URLs and their custom names.
- `manage_submodules.sh`: A script used to automatically clone and update all submodules (laboratories and exercises).

## Current Repositories

Below is the current list of repositories managed by the script:

| Type     | Repository URL                                                                                                  | Custom Name         |
| -------- | --------------------------------------------------------------------------------------------------------------- | ------------------- |
| CAOS     | [CAOS Repository](https://baltig.polito.it/teaching-material/CAOS.git)                                          | CAOS Repository     |
| FreeRTOS | [FreeRTOS Repository](https://github.com/FreeRTOS/FreeRTOS.git)                                                 | FreeRTOS Repository |
| Lab      | [Lab1 - Setup](https://baltig.polito.it/teaching-material/labs-caos-and-os/lab-1-setup.git)                     | Lab1 - Setup        |
| Lab      | [Lab2 - baremetal](https://baltig.polito.it/teaching-material/labs-caos-and-os/lab2-baremetal.git)              | Lab2 - baremetal    |
| Lab      | [Lab3 - FreeRTOS](https://baltig.polito.it/teaching-material/labs-caos-and-os/lab3-freertos.git)                | Lab3 - FreeRTOS     |
| Lab      | [Lab4 - Synch](https://baltig.polito.it/teaching-material/labs-caos-and-os/lab4-synch.git)                      | Lab4 - Synch        |
| Lab      | [Lab5 - Peripherals](https://baltig.polito.it/teaching-material/labs-caos-and-os/lab5-peripherals.git)          | Lab5 - Peripherals  |
| Exercise | [ARM Bare Metal](https://baltig.polito.it/teaching-material/exercises-caos-and-os/arm-bare-metal.git)           | ARM Bare Metal      |
| Exercise | [CrossCompilation](https://baltig.polito.it/teaching-material/exercises-caos-and-os/crosscompilation.git)       | CrossCompilation    |
| Exercise | [FreeRTOS_HelloWorld](https://baltig.polito.it/teaching-material/exercises-caos-and-os/freertos_helloworld.git) | FreeRTOS_HelloWorld |
| Exercise | [MyFirstOS](https://baltig.polito.it/teaching-material/exercises-caos-and-os/myfirstos.git)                     | MyFirstOS           |
| Exercise | [Process Scheduling](https://baltig.polito.it/teaching-material/exercises-caos-and-os/process-scheduling.git)   | Process Scheduling  |
| Exercise | [MySpinLockARM](https://baltig.polito.it/teaching-material/exercises-caos-and-os/myspinlockarm.git)             | MySpinLockARM       |
| Exercise | [Timers](https://baltig.polito.it/teaching-material/exercises-caos-and-os/timers.git)                           | Timers              |
| Exercise | [FreeRTOS_sampleapp](https://baltig.polito.it/teaching-material/exercises-caos-and-os/FreeRTOSsampleapp.git)    | FreeRTOS_sampleapp  |
| Exercise | [Interrupts](https://baltig.polito.it/teaching-material/exercises-caos-and-os/interrupts.git)                   | Interrupts          |
| Exercise | [Synchronization and intertask communications](https://baltig.polito.it/teaching-material/exercises-caos-and-os/test_vahid.git) | Synchronization and intertask communications |


## Usage

### Cloning the Repository

To clone the repository along with all the submodules:

```bash
git clone --recurse-submodules https://github.com/neo-CAOS/Teaching-material.git
cd Teaching-material
```

### Running the Update Script

The script `manage_submodules.sh` automates the process of updating all the submodules (labs and exercises). It reads repository URLs from the `urls.txt` file, clones them (if not already cloned), or pulls updates from the remote repositories.

To run the script:

```bash
./manage_submodules.sh
```

The script will:

1. Clone any missing repositories into the `Laboratories/` and `Exercises/` directories.
2. Pull updates for existing repositories.

### FreeRTOS Configuration [ Not working! ]

Although many labs and exercises rely on the `FreeRTOS` submodule, it is more convenient to clone the `FreeRTOS` repository only once at the root of this repository. This reduces redundancy and ensures that the FreeRTOS codebase remains consistent across all exercises and labs.

To simplify this process, the provided `manage_submodules.sh` script is designed to clone the FreeRTOS repository into the root directory of this repository (`Teaching-material`). Once cloned, users must manually update the paths in the `Makefile` file of each lab and exercise to use a relative path pointing to the centralized `FreeRTOS` repository.

#### Steps to Configure FreeRTOS

<!-- TODO: check -->

1. **Clone the FreeRTOS Repository:**
   If you haven't already cloned the `FreeRTOS` repository, run the following command:

   ```bash
   ./manage_submodules.sh
   ```
   
   This will clone the FreeRTOS repository into the root directory.
   
2. **Remove Empty FreeRTOS Directories:**
   To avoid potential conflicts, empty `FreeRTOS` directories in individual labs and exercises should be deleted. For example:
   
   ```bash
   find Laboratories/ Exercises/ -type d -name "FreeRTOS" -empty -delete
   ```
   
   This ensures that the centralized `FreeRTOS` repository is used instead.
   
3. **Update Relative Paths:**
   Update the paths in each lab and exercise's `README` or configuration files to point to the centralized `FreeRTOS` repository. For example:
   
   ```
   Old Path: ../../FreeRTOS
   New Path: ../../../FreeRTOS
   ```
   
   Ensure that these paths are consistent across all dependent repositories.
   
#### Important Notes

- It is the responsibility of each user to update the paths in their local environment. The repository does not automatically handle this configuration.
- Check the `README` of each lab or exercise for specific `FreeRTOS` requirements and compatibility information.

### Creating a Personal Branch [ Not working! ]

To work on the exercises and make your own modifications without affecting the main repository, follow these steps to create a new `personal` branch:

1. Switch to the `main` branch (if you're not already on it):

   ```bash
   git checkout main
   ```

2. Create and switch to a new branch called `personal`:

   ```bash
   git checkout -b personal
   ```

3. Make your changes and commit them:

   ```bash
   git add .
   git commit -m "My modifications to the exercises"
   ```

4. Push your personal `branch` to GitHub:

   ```bash
   git push -u origin personal
   ```

Once the branch is pushed, you will be able to switch between the `main` and `personal` branches in GitHub and view your modifications by selecting the corresponding branch.

## Contributing

Feel free to fork the repository and make pull requests to improve the workflow or fix any issues. Contributions are always welcome!

## License

<!-- TODO: check -->

This repository is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

### How to Use

- Copy the above content into a file named `README.md` and place it in the root directory of your repository.
- This provides a comprehensive overview of how to manage the repositories and how the script works, including a section for personal modifications.

Let me know if you'd like any changes!
