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

---

## Contents

- [Project Overview](#project-overview) — scope, rules of engagement, submission and grading
  - [Update — Revised Target VM (October 2026)](#update--revised-target-vm-october-2026) — **read this if you started before 3 October**
- [Getting Started](#getting-started) — download and set up the Target VM (Apple Silicon or Intel/Windows)
- [Kali Linux Configuration](#kali-linux-configuration) — network adapters and the setup script
- [Penetration Testing Report](#penetration-testing-report) — what to write and submit
  - [Reconnaissance](#1-reconnaissance) · [Enumeration](#2-enumeration) · [Foothold](#3-foothold) · [Privilege Escalation](#4-privilege-escalation) · [Remediations](#5-remediations)

---

## Project Overview

> ⚠️ If you would like guidance or the course project translated into Swedish, contact me and I'll provide it.

You will use the penetration-testing knowledge and techniques covered in this course, together with your Kali Linux VM, to perform a penetration test against the intentionally vulnerable server infrastructure of **Sec-Org**, a fictitious company.

You are provided with a vulnerable VM representing Sec-Org's server environment and infrastructure. From here on, it is referred to as the _"Target VM"_.
 
> The download link for the Target VM (`sec-org.ova`) is in the [Getting Started](#getting-started) section.

---

### Update — Revised Target VM (October 2026)

The Target VM was updated on **3 October at 17:00**. If you downloaded `sec-org.ova` after that time, you already have the updated version and can ignore this notice.

**The update fixes a privilege-escalation misconfiguration and improves compatibility for Apple Silicon Macs.**

No new content was added to the course project. The "old" and "new" versions work the same way — the only change is a tweak to the privilege-escalation process. The same services, vulnerabilities, and intended attack paths still apply, so any reconnaissance, enumeration and foothold work you have already done and documented remains valid.

#### How the update affects you

1. **If you are using the old Target VM…**
    1. **…but you have not yet reached the privilege-escalation steps:** Switch to the updated `sec-org.ova` and continue from where you are. Everything before privilege escalation is identical on both versions, so you won't lose any written work, you'll just need to **re-capture your flags** from the new VM, since flags are unique per VM.
    2. **…but you are at, past, or have finished privilege escalation (all flags obtained):** Contact me directly before redoing anything. In many cases I can accept your existing work, and I'll confirm individually based on your report. You may still need to redo the privilege escalation and re-capture your flags on the new VM — I'll let you know. _Please don't share how you reached any flag with classmates._
2. **If you are using the new Target VM:** Just continue with the course project as described in [Getting Started](#getting-started) — nothing extra to do.

**What you need to do (if switching to the new VM):**
1. Download the new `sec-org.ova` and import it, following [Getting Started](#getting-started). _Make sure that you don't mix up the old and new VMs._
2. Re-run your access and privilege-escalation steps on the new VM and record the new `flag.txt` values.
    - Remember that you don't have to redo the entire project from scratch, just the privilege escalation needed to obtain all of the new flags.
3. Make sure every flag in your penetration testing report is a **`CTFv2{...}`** flag (see the flag-format note below).

**Flag format.** Valid flags now start with **`CTFv2{`**. Flags from the previous VM (which started with `CTF{`) are **no longer accepted**. Submit each flag exactly as shown in `flag.txt`, including the `CTFv2{` prefix and the closing `}`.

**Deadline.** Because this change was made mid-project, the deadline has been **extended to 23 October**. The late-submission policy is unchanged and applies from the new date, so no one is penalized for the switch.

⚠️ If the change causes you any problem, or you are unsure whether something you already did still counts, contact me.

---

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
- Each flag is a file named `flag.txt`. Its contents look like `CTFv2{...}` — submit the **whole** string, exactly as shown, including the `CTFv2{` prefix and the closing `}`.
- Flags are unique to each Target VM, so you cannot share your flags with or use flags from anyone else.
- If you submit as a group, submit the flags of all group members in the same submission.
  - If you are sharing a Target VM then only one set of flags needs to be submitted. However you need to explain how you worked as a group and how you technically carried out the course project.
---

## Getting Started
1. **Read the Scope & Rules of Engagement.**
2. **Download the pre-built Target VM** (`sec-org.ova`) to your host computer (not your Kali VM): [sec-org.fi.ova](https://arcadauas-my.sharepoint.com/:u:/g/personal/granviks_arcada_fi/IQBzl5eLKVkbSKuzzv6N1ToPAcxS-xbpfla_sEOicfGOaCY?e=zi2Hqg).
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
4. Accept the default storage settings. You will replace this drive in Step #3.
5. On the summary page, name the VM `sec-org`, select **Open VM Settings**, and click **Save**.

#### Step 3: Configure the Target VM

**Open VM Settings:**
1. Make sure that the Target VM is powered off.
2. Click on **Drives:** Delete the blank default drive. Then select **New… → Import** and select `sec-org.qcow2`.
    - Set the interface to **VirtIO** (if the VM won't boot, try **SATA**).
3. Add a second interface: in the left sidebar, under **Devices**, click **New…** and choose **Network** as the device type. Select the new **Network** entry and configure it:
    - **Network Mode** → **Host Only**.
    - **Host Network** → leave as **Default (private)**.
    - **Emulated Network Card** → leave as is.
    - **MAC Address** → leave as is.
4. With that second interface still selected, tick **Show Advanced Settings** and enter:

   | Setting       | Value             |
   |---------------|-------------------|
   | Guest Network | `192.168.56.0/24` |
   | DHCP Start    | `192.168.56.110`  |
   | DHCP End      | `192.168.56.254`  |

   _These settings place the Target VM on the network it expects and keep DHCP-assigned addresses from conflicting with the target's static IP address._
5. Click **Save**.

#### Step 4: Start the Target VM

1. Start the Target VM. _Emulation is slow, so allow several minutes for it to boot._
    - If the VM does not boot (for example, you see _"No bootable device"_ or a UEFI shell), open the VM's settings, select **QEMU**, turn off **UEFI Boot**, and try again.
    - If you see other errors, try restarting the VM. If the problem persists, contact me.
2. When the VM is ready, you should see something similar to:

  ```
  Ubuntu 20.04.5 LTS sec-org tty1

  sec-org login:
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
  Ubuntu 20.04.5 LTS sec-org tty1

  sec-org login:
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

1. Open the Kali VM's settings and go to **Network**.
2. The first network interface (**Adapter 1**) should be set to **Shared Network**, leave it as it is. _This is Kali's internet connection._
3. Add a second interface: in the left sidebar, under **Devices**, click **New…** and choose **Network** as the device type. Select the new **Network** entry and configure it:
    - **Network Mode** → **Host Only**
    - **Host Network** → leave as **Default (private)**
    - **Emulated Network Card** → should be `virtio-net-pci` by default, set it to that if it isn't.
    - **MAC Address** → leave as is.
5. With that second interface still selected, tick **Show Advanced Settings** and enter:

   | Setting       | Value             |
   |---------------|-------------------|
   | Guest Network | `192.168.56.0/24` |
   | DHCP Start    | `192.168.56.110`  |
   | DHCP End      | `192.168.56.254`  |

6. Click **Save**.

#### VirtualBox (Intel Mac or Windows PC)

1. Right-click your Kali VM and select **Settings → Network**.
2. **Adapter 1** should be enabled and attached to **NAT**. Leave it as it is.
3. Enable **Adapter 2** and attach it to **Host-only Adapter**, using the same host-only network as the Target VM. _On an Intel Mac with macOS 13 or later, use **Host-only Network** instead._
4. Click **OK**.

### Step 2: Start Kali and run the setup script

1. Make sure the Target VM is running.
2. Start your Kali VM, sign in, and run the following in a Kali terminal:

    ```bash
    curl -fsSL https://raw.githubusercontent.com/krullmizter/CybSec/main/setup.sh | sudo bash
    ```

The script above configures the hostname settings required for the assignment and verifies that the Target VM is reachable.

### Step 3: Finalize

**If the script completes successfully, the course project environment is ready 🎉**

However, there are still some finalizing configurations and checks you should perform before you start to hack.

#### 💾 Take a snapshot (or clone)
_This is not mandatory, but a useful safeguard._

Once both VMs are set up and talking to each other, save a known-good copy of each. If anything breaks later, you can roll back instead of starting over.

1. **UTM (Apple Silicon) — Clone:** right-click the VM in the sidebar → **Clone**. This makes a full, independent copy and is the most reliable safeguard in UTM.
2. **VirtualBox — Snapshot:** select the VM in VirtualBox Manager, then open the **Snapshots** view (the **Machine Tools** menu, the list/☰ icon next to the VM name, or the button in the top-right). Click the **Take** button (camera icon), give the snapshot a name, and confirm.
    - _UTM also has a snapshot feature, but it isn't available for every VM depending on its disk/config, if the option is missing or greyed out, use a clone instead._
    - While the VM is running you can also use **Machine → Take Snapshot** (Host + T).

Take another known-good copy before the **Remediations** phase, so you can re-run your attacks against the original, vulnerable state to confirm your fixes work.

#### 📋 Tools and wordlists on Kali
A couple of wordlists you'll likely need aren't ready to use out of the box:

- **`rockyou` wordlist:** ships compressed. Unpack it once with `sudo gunzip /usr/share/wordlists/rockyou.txt.gz`, after which it lives at `/usr/share/wordlists/rockyou.txt`.
- **SecLists** (large collection of wordlists, useful for subdomain/directory brute-forcing) is not installed by default: `sudo apt update && sudo apt install seclists`. It installs under `/usr/share/seclists/`.

#### 🛜 Enabling the UTM Host-Only Interface Inside Kali (Apple Silicon)

After adding the second (Host Only) adapter in UTM, Kali has a second virtual network card — however, UTM only provides the *hardware*.
Inside Kali, `NetworkManager` still has to bring that interface up and request an address.

In most cases this is automatic: Kali auto-connects new wired interfaces over DHCP, so the Host Only interface picks up a `192.168.56.x` address on its own with nothing to configure. **However, this isn't always reliable** — the interface may fail to activate on its own, so you sometimes have to set it up manually.

1. Check whether it came up automatically

```bash
ip -br addr
```

If one interface already shows a `192.168.56.x` address, it's working — you're done. If not, continue below.

2. Identify the Host Only interface

```bash
ip -br addr
```

This lists each interface with its state and IP address:

- The **Shared Network** adapter (internet, usually `eth0`) will have an address, but **not** in the `192.168.56.x` range.
- The **Host Only** adapter (usually `eth1`) is the one on the `192.168.56.x` subnet. If it already shows a `192.168.56.x` address it came up on its own; if it shows no IPv4 address, that's the interface to configure next.

(If you only need the interface names and link state, `ip -br link` shows those.)

3. Create the connection manually

Replace `eth1` with the name you found above for the Host Only interface:

```bash
sudo nmcli con add type ethernet ifname eth1 con-name hostonly ipv4.method auto ipv4.never-default yes ipv6.method ignore
sudo nmcli con up hostonly
```

> `ipv4.never-default yes` keeps your default route (and therefore internet access) on the Shared Network adapter, so the Host Only interface can't take over and break browsing.

This creates a saved connection profile, so it persists across reboots — you only need to do it once.

4. Verify

```bash
ip -br addr            # the Host Only interface should now show a 192.168.56.x address
ping -c3 <target-ip>   # should reach the target (the address you find for it during recon)
ping -c3 8.8.8.8       # internet should still work
```

**That was it!** Start to hack and have fun. If you run into issues, please contact me directly and we can sort things out.

---

### Technical Troubleshooting

- _**Target VM is not reachable:**_ Check that the Target VM has finished booting (it can take several minutes under UTM), that both VMs use the host-only network, and that `ip -br addr` on Kali shows a `192.168.56.x` address.
- _**No Host Only option for the second adapter in UTM:**_ Your Kali VM uses the Apple Virtualization backend and needs to be recreated with QEMU.
- _**Nonexistent host networking interface error in VirtualBox:**_ The VM's host-only adapter name doesn't exist on your computer. Open **Settings → Network** and select your host-only network in the **Name** field.
- _**Kali and the target VM run in different apps (e.g. VMware Fusion and UTM):**_ They are on separate networks and cannot reach each other. The simplest fix is to run both VMs in the same app.

---

## Penetration Testing Report

When you have finished testing, write and submit a penetration testing report. Structure it with the headings below.
 
For every step, document:
- **what** you did (tools and commands used)
- **what** you found (include screenshots or command output as evidence)
- **why** it matters (how it could be used by an attacker)

For each security weakness you find, also give it:
- a **severity** rating — High, Medium or Low (or a CVSS score if you prefer) — based on how easy it is to exploit and how much damage it allows
- a **classification**, so the finding is described in standard terms:
  - **CVE** — for known vulnerabilities in third-party software (e.g. an outdated package). Not every finding has a CVE.
  - **CWE** — the *type* of weakness ([cwe.mitre.org](https://cwe.mitre.org/)). Use this for issues in locally-developed code and configuration that have no CVE, e.g. SQL injection (CWE-89), weak password hashing (CWE-916), or insecure file permissions (CWE-732).
 
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

> ℹ️ If you're not sure where to start, think in categories rather than specific tools: port/service scanning, virtual-host and directory brute-forcing, web-application and CMS scanning, file-share enumeration, and (later) offline password/hash cracking. You decide which tools fit each category.
 
### 3. Foothold

Use your enumeration results to gain access to the system.

- Try the entry points you identified, using both manual and automated methods.
- Follow each path as far as you can, until you either gain access or decide to try another path.
- Document new findings as you go, and test any new entry points that come up.
- When you have gained access as a user, find `flag.txt` in that user's home directory. Include its contents and a screenshot in your report.
- Before moving on, check whether there is another way in. If you find another user's `flag.txt`, include that too.
 
### 4. Privilege Escalation

- From your user account, use privilege escalation techniques to become root.
- When you have succeeded, find `flag.txt` in the root user's home directory (`/root/flag.txt`). Include its contents and a screenshot in your report.
 
At this point, the server is completely under your control. Congratulations!

### 5. Remediations

Fix all security issues you find. This is an important part of the project: once you are finished, it must not be possible to gain access to the server using the same methods.

> ℹ️ **The target VM has no Internet access and must stay on the host-only network during the whole project.** Most security issues can be fixed without Internet access, for example by changing credentials, permissions, configuration or source code.

You do this work *on* the target, using the access you gained during the test (your shell or root), or the VM's own console if you lock yourself out. This is the one phase where you log in to the server directly rather than only attacking it from Kali.

- **Report all actions you take.** List every vulnerability you found and how you fixed it.
- **Look back at the enumeration phase.** Is there anything suspicious that you have not checked yet?
- **Locally developed source code:** The best solution is to fix the vulnerabilities so that everything continues to work. For this project, however, it is acceptable to "temporarily" disable or block vulnerable services and replace the frontend with a message such as "Update in progress".
- **Available patches and updates:** You cannot install updates on the target VM. Instead, for each vulnerable package or piece of software, document:
  - the software and its **installed version** (e.g. from `dpkg -l <package>` or `<program> --version` on the target VM)
  - the **vulnerability** (CVE number or security advisory, if one exists) and its **weakness type** (CWE)
  - the **severity** (High / Medium / Low, or CVSS)
  - the **patched version or update** that fixes it, and where you found it (e.g. the vendor's website)
  - the **mitigation** you applied instead, e.g. a configuration change or disabling the vulnerable feature
- **Findings without a CVE:** issues in the locally-developed code or configuration (for example SQL injection, insecure file permissions, or weak password storage) usually have **no CVE**. Classify these by **CWE** and severity, and document the fix you applied and how you verified it.
- **Keep the server working.** Do not simply shut everything down, the server must still be able to perform its primary functions.
- **Don't lock yourself out.** Keep at least port 22 (SSH) open. If you get locked out anyway, ask for help.
- **Verify your fixes.** After each fix, repeat the attack from Kali to confirm that it no longer works.
- **No root access?** If you did not complete the Privilege Escalation step, fix at least the issues that can be fixed with normal user privileges.
