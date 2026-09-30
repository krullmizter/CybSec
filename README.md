# Sec-Org’s Penetration Test

```
Subject: Information for the Sec-Org Penetration Test

> Welcome to Sec-Org!

> You have been contracted to perform an authorised penetration test of our server environment. The server hosts our public website, internal intranet, and file server.
> Unfortunately, our previous IT administrator left the company unexpectedly, and we have been unable to locate the server's login credentials.
> As part of the penetration test, determine whether there are any viable ways to gain access to the server using the information and services available to you.
> Your objective is to assess the security of the running server and identify any weaknesses that could allow unauthorised access.
> Once you have gained access, continue the assessment to determine the extent to which an attacker could compromise the system.
> Document any vulnerabilities, misconfigurations, credentials, or other security weaknesses you discover.
> If I remember correctly, we used separate subdomains for the public website and the internal intranet.
> Please document your findings and, where possible, provide recommendations for remediating the identified security issues.

> Best regards,
> The Boss
```

## Project Overview

> ⚠️ If you would like guidance or the course project translated into Swedish, contact me and I'll provide it.

You will use the penetration-testing knowledge and techniques covered in this course, together with your Kali Linux VM, to perform a penetration test against the intentionally vulnerable server infrastructure of **Sec-Org**, a fictitious company.

You are provided with a vulnerable VM representing Sec-Org's server environment and infrastructure. From here on, it is referred to as the _"Target VM"_.
 
> The download link for the Target VM (`sec-org.ova`) is in the [Getting Started](#getting-started) section.

### Scope & Rules of Engagement

> The Target VM must only use a host-only network adapter. Further explanations and configuration instructions are provided in the [Getting Started](#getting-started) section.

✅ **You may:**
- Scan the provided Target VM.
- Enumerate its services.
- Attempt authentication against services running on the Target VM.
- Exploit vulnerabilities in the Target VM.
- Perform privilege escalation on the Target VM.
- Retrieve the assignment flags.

⛔ **You must not:**
- Target any real companies, systems, websites or domain names associated with Sec-Org or with any domain used in this assignment. **Sec-Org is entirely fictitious and exists solely for the purposes of this assignment.**
- Scan or attack Arcada's infrastructure.
- Use the techniques from this assignment against systems on the public Internet.
- Use discovered credentials against any other systems.
- Perform denial-of-service attacks against anything outside your own lab environment.
- Attempt to compromise another student's virtual machine.
- Change the target VM's network settings, for example by adding a NAT or bridged adapter.

> ⚠️ If you are unsure whether an action is within scope, ask before performing it.

### Sources & Academic Integrity
- Provide sources for the methods you use. For example, if you use a tutorial or an exploit from GitHub, reference it with a link in your report _(a formal bibliography is not required)_.
- If you use AI tools, state which tools you used, where and how.
- You must not share your findings or methods with other students, including students taking the course in later years.
- You must not ask other students for solutions. If you get stuck, ask the teacher for hints.

### Submission
- Submit your report here in Word, PDF or Markdown format.
- The report can be written in either Swedish or English.
- If you are part of a hacking team, you may submit as a group.
    - One member submits the report and lists all team members.
    - You must have been part of the team from the start of the project, you cannot join a team just before the submission.
- Late submissions will be assessed, but 10% of the total points (6 points) are deducted for each started week of lateness.

### Point Distribution

Total course project points: **60 points**

| Points | Criteria |
|---|---|
| **30** | The report (written thoroughly and clearly) |
| **10** | User flags found (before or after gaining root) |
| **5** | Root flag found |
| **15** | Fixing security issues, including documenting available patches and updates |

⚠️ **Notice**
- Flags are unique to each Target VM, so you cannot share your flags with or use flags from anyone else.
- If you submit as a group, submit the flags of all group members in the same submission.

---

## Getting Started
1. **Read the Scope & Rules of Engagement.**
2. **Download the pre-built Target VM** (`sec-org.ova`) to your host computer (not your Kali VM) from the [Sec-Org download page](https://arcadauas-my.sharepoint.com/:u:/g/personal/granviks_arcada_fi/IQDjhIOeIZzSRqGmqK0DnwIMAYHgWQZxFvhF-nCgBjqAcAY?e=Z48BtT).
3. **Set up the Target VM and your Kali VM.**
Check which type of processor your host computer has, then follow the matching instructions below:
- **Apple Silicon Mac** – M1, M2, M3, M4 or M5
- **Intel Mac or Windows PC** – Intel or AMD x86-64 processor

---

### Apple Silicon Mac (M1, M2, M3, M4 or M5)

If you are using a Mac with an Apple Silicon processor, you cannot run the provided Sec-Org Target VM directly in VirtualBox, because the Target VM is an x86-64 virtual machine.

Instead, you will run the Target VM as an emulated x86-64 virtual machine in UTM (QEMU). _You are most likely already using UTM to run Kali Linux, so the setup will be similar to your Kali VM setup._

> ⚠️ **VMware Fusion users**: Kali itself runs fine in VMware Fusion, but the Sec-Org Target VM (x86-64) can only run in UTM. VMs in different apps are on separate networks and cannot reach each other, so run your Kali VM in UTM as well.

#### Step 1: Convert the Target VM's disk
1. Install [UTM](https://mac.getutm.app/) if you don't have it.
2. Install QEMU: `brew install qemu`, which includes the `qemu-img` tool needed to convert the disk.
3. In Terminal, Create a directory for the Target VM, and move into the new directory:
   
   ```bash
   mkdir ~/Downloads/sec-org && cd ~/Downloads/sec-org
   ```
4. Extract the `.ova` file:

   ```bash
   tar -xvf ~/Downloads/sec-org.ova
   ```
5. Run `ls`. You should see an `.ovf` file and a `.vmdk` disk (for example, `sec-org.fi-disk001.vmdk`).
6. Convert the disk to the `qcow2` format. If your `.vmdk` file has a different name, use the name shown by `ls`: 
 
    ```bash
    qemu-img convert -p -f vmdk -O qcow2 sec-org.fi-disk001.vmdk sec-org.qcow2
    ```
 When the conversion finishes, you should have a file named `sec-org.qcow2`.

#### Step 2: Create the Target VM in UTM

1. Open UTM and select **Create a New Virtual Machine → Emulate → Other**.
2. Skip the boot ISO by selecting **None** as the boot device.
3. Select **x86_64** as the architecture, and set **2** CPU cores and **2048–4096 MB** of memory.
4. Accept the default storage settings. You will replace this drive in Step 3.
5. On the summary page, name the VM `sec-org`, select **Open VM Settings**, and click **Save**.

#### Step 3: Configure the Target VM

1. **Drives:** Delete the blank default drive. Then select **New… → Import** and select `sec-org.qcow2`.
    - Set the interface to **VirtIO** (if the VM won't boot, try **SATA**).
3. **Network:** Set **Network Mode** to **Host Only**. Do not add any other network devices.
4. On the same **Network** page, click **Show Advanced Settings** and enter:

   | Setting       | Value             |
   |---------------|-------------------|
   | Guest Network | `192.168.56.0/24` |
   | Host Address  | `192.168.56.1`    |
   | DHCP Start    | `192.168.56.110`  |
   | DHCP End      | `192.168.56.254`  |

   These settings place the Target VM on the network it expects and keep DHCP-assigned addresses from conflicting with the target's static IP address.

5. Click **Save**.

#### Step 4: Start the Target VM

1. Start the Target VM. _Emulation is slow, so allow several minutes for it to boot._
    - If the VM does not boot (for example, you see _"No bootable device"_ or a UEFI shell), open the VM's settings, select **QEMU**, turn off **UEFI Boot**, and try again.
    - If you see other errors, try restarting the VM. If the problem persists, contact me.
2. When the VM is ready, you should see something similar to:

  ```
  Ubuntu 20.04.5 LTS firman tty1

  firman login:
  ```

The Target VM must remain powered on while you work on the project. It represents the vulnerable server infrastructure, and you will perform the penetration test against it from your Kali Linux VM. You can now leave it running; you won't need to interact with it directly from here on.

Continue to [Kali Linux Configuration](#kali-linux-configuration).

---

### Intel Mac or Windows PC

If you are using an Intel Mac or a Windows PC, you can run the provided x86-64 Target VM directly in VirtualBox by importing the `sec-org.ova` file.

1. Open VirtualBox.
2. Select **File → Import Appliance**.
3. Select the downloaded `sec-org.ova` file.
4. Complete the import process without changing any of the default settings.
5. Configure the host-only network (**File → Tools → Network Manager → Host-only Networks**):
   - If no host-only network exists, click **Create**.
   - On the **Adapter** tab, the IPv4 address must be `192.168.56.1` and the network mask must be `255.255.255.0`.
   - On the **DHCP Server** tab, set **Lower Address Bound** to `192.168.56.110` and click **Apply**. This prevents IP address conflicts with the Target VM.

   > ⚠️ **Intel Mac with macOS 13 (Ventura) or later:** VirtualBox uses **Host-only Network** instead of **Host-only Adapter** on these macOS versions. Create a host-only network with lower bound `192.168.56.110`, upper bound `192.168.56.254` and mask `255.255.255.0`. In step 6, attach Adapter 1 to **Host-only Network** and select that network.

6. Verify the Target VM's network configuration:
   - Right-click the Target VM and select **Settings**.
   - Select **Network**.
   - Only **Adapter 1** should be enabled.
   - Adapter 1 must be attached to **Host-only Adapter**. The **Name** must match the host-only network from step 5 (e.g. `VirtualBox Host-Only Ethernet Adapter` on Windows).
   - Do not use **Bridged Adapter** or **NAT** for the Target VM.
7. Start the Target VM.
   - If you see errors, try restarting the VM. If the problem persists, contact me.
   - When the VM is ready, you should see something similar to:

  ```
  Ubuntu 20.04.5 LTS firman tty1

  firman login:
  ```

The Target VM must remain powered on while you work on the project. It represents the vulnerable server infrastructure, and you will perform the penetration test against it from your Kali Linux VM. You can now leave it running; you won't need to interact with it directly from here on.

---

## Kali Linux Configuration

The Target VM has no Internet access by design. It is only reachable from Kali (and your host computer) over the host-only network.

Your Kali VM needs two network adapters:

- **Adapter 1 – Internet access:** used for course resources and other authorised services. It is configured by default, so you don't need to change it.
- **Adapter 2 – Host-only:** a private network between your Kali VM and the Sec-Org Target VM, similar to a penetration tester working from a machine on the same local network as the target. You need to set it up manually.

### Step 1: Configure the network adapters

Shut down your Kali VM first.

#### UTM (Apple Silicon)

> ⚠️ **Important:** Your Kali VM must use UTM's **QEMU** backend, not **Apple Virtualization**. VMs using Apple Virtualization do not support Host Only networking, so they cannot reach the Target VM.

1. Open the Kali VM's settings and go to **Network**.
2. **Adapter 1** should be set to **Shared Network**. Leave it as it is.
3. Add a second adapter with **New… → Network** and set **Network Mode** to **Host Only**.
4. Click **Show Advanced Settings** and enter the same values as for the Target VM:

   | Setting       | Value             |
   |---------------|-------------------|
   | Guest Network | `192.168.56.0/24` |
   | Host Address  | `192.168.56.1`    |
   | DHCP Start    | `192.168.56.110`  |
   | DHCP End      | `192.168.56.254`  |

5. Click **Save**.

#### VirtualBox (Intel Mac or Windows PC)

1. Right-click your Kali VM and select **Settings → Network**.
2. **Adapter 1** should be enabled and attached to **NAT**. Leave it as it is.
3. Enable **Adapter 2** and attach it to **Host-only Adapter**, using the same host-only network as the Target VM. On an Intel Mac with macOS 13 or later, use **Host-only Network** instead.
4. Click **OK**.

### Step 2: Start Kali and run the setup script

1. Make sure the Sec-Org Target VM is running.
2. Start your Kali VM, sign in, and run the following in a Kali terminal:

    ```bash
    curl -fsSL https://raw.githubusercontent.com/krullmizter/CybSec/main/setup.sh | sudo bash
    ```

The script configures the hostname settings required for the assignment and verifies that the Target VM is reachable.

If the script completes successfully, the course project environment is ready. From here, use the penetration-testing methodology covered in the course to assess the Sec-Org environment and meet the requirements in the email from the boss.

---

### Technical Troubleshooting

- **"Target VM is not reachable":** Check that the Target VM has finished booting (it can take several minutes under UTM), that both VMs use the host-only network, and that `ip -br addr` on Kali shows a `192.168.56.x` address.
- **No Host Only option for the second adapter in UTM:** Your Kali VM uses the Apple Virtualization backend and needs to be recreated with QEMU.
- **"Nonexistent host networking interface" error in VirtualBox:** The VM's host-only adapter name doesn't exist on your computer. Open **Settings → Network** and select your host-only network in the **Name** field.
- **Kali and the target VM run in different apps (e.g. VMware Fusion and UTM):** They are on separate networks and cannot reach each other. Run both VMs in the same app.

---

## Penetration Testing Report

When you have finished testing, write and submit a penetration testing report. Structure it with the headings below.
 
For every step, document:
- **what** you did (tools and commands used)
- **what** you found (include screenshots or command output as evidence)
- **why** it matters (how it could be used by an attacker)
 
### Executive Summary

A short, non-technical summary for the Boss (max. half a page): the overall security level of the server, the most serious findings and your most important recommendations.

### 1. Reconnaissance

What publicly available information could help you gain access? Examine the email from the Boss and the public website.

- This step is **passive**. You may read the email and browse the website like a normal visitor, but do **not** scan, enumerate or brute-force anything yet.

> ℹ️ Have you read the email from the Boss carefully? What information can you find there?

### 2. Enumeration

Use manual and automated methods to scan and enumerate the target VM. Document:

- Open ports and services
- Subdomains, directories and files
- Usernames and other information about users
- Software versions, and any known vulnerabilities (CVEs) for them
- A list of possible entry points, based on the above
 
### 3. Foothold

Use your enumeration results to gain access to the system.

- Try the entry points you identified, using both manual and automated methods.
- Follow each path as far as you can, until you either gain access or decide to try another path.
- Document new findings as you go, and test any new entry points that come up.
- When you have gained access as a user, find `flag.txt` in that user's home directory. Include its contents and a screenshot in your report.
- Before moving on, check whether there is another way in. If you find another user's `flag.txt`, include that too.
 
### 4. Privilege Escalation

- From your user account, use privilege escalation techniques to become root.
- When you have succeeded, find `root.txt` in the root user's home directory. Include its contents and a screenshot in your report.
 
At this point, the server is completely under your control. Congratulations!

### 5. Remediations

Fix all security issues you find. This is an important part of the project: once you are finished, it must not be possible to gain access to the server using the same methods.

> ℹ️ **The target VM has no Internet access and must stay on the host-only network during the whole project.** Most security issues can be fixed without Internet access, for example by changing credentials, permissions, configuration or source code.

- **Report all actions you take.** List every vulnerability you found and how you fixed it.
- **Look back at the enumeration phase.** Is there anything suspicious that you have not checked yet?
- **Locally developed source code:** The best solution is to fix the vulnerabilities so that everything continues to work. For this project, however, it is acceptable to "temporarily" disable or block vulnerable services and replace the frontend with a message such as "Update in progress".
- **Available patches and updates:** You cannot install updates on the target VM. Instead, for each vulnerable package or piece of software, document:
  - the software and its **installed version** (e.g. from `dpkg -l <package>` or `<program> --version` on the target VM)
  - the **vulnerability** (CVE number or security advisory, if one exists)
  - the **patched version or update** that fixes it, and where you found it (e.g. the vendor's website)
  - the **mitigation** you applied instead, e.g. a configuration change or disabling the vulnerable feature
- **Keep the server working.** Do not simply shut everything down, the server must still be able to perform its primary functions.
- **Don't lock yourself out.** Keep at least port 22 (SSH) open. If you get locked out anyway, ask for help.
- **Verify your fixes.** After each fix, repeat the attack from Kali to confirm that it no longer works.
- **No root access?** If you did not complete the Privilege Escalation step, fix at least the issues that can be fixed with normal user privileges.

