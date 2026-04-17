# Skill Point website

domain name:
https://www.skillpointschool.ru/

## Local mobile preview

Run this from the repo root:

```powershell
powershell -ExecutionPolicy Bypass -File .\start-mobile-preview.ps1
```

Then open the shown address on your phone while both devices are on the same Wi-Fi.

## Android USB debugging preview

If the phone cannot access the PC over Wi-Fi, you can open the local site through USB instead.

1. Enable `Developer options` on the phone.
2. Enable `USB debugging`.
3. Connect the phone to the PC by USB and approve the debugging prompt on the phone.
4. Start the local preview server:

```powershell
powershell -ExecutionPolicy Bypass -File .\start-mobile-preview.ps1 -Port 8000
```

5. In the [Android SDK](https://developer.android.com/tools/releases/platform-tools) `platform-tools` folder, run:

```powershell
.\adb.exe devices
.\adb.exe reverse tcp:8000 tcp:8000
```

6. Open this address on the phone:

```text
http://127.0.0.1:8000
```

Notes:

- `http://127.0.0.1:8000` is the correct phone URL for the USB-debugging path.
- `http://192.168.x.x:8000` is only for the Wi-Fi path.
- If `adb.exe devices` shows `unauthorized`, confirm the USB debugging prompt on the phone.

Why this is better than Chrome device emulation:

- DevTools emulation does not match the real mobile browser UI, font rendering, DPR, and dynamic address-bar behavior.
- Opening the local site on the actual phone shows the true layout and touch behavior.

For proper inspection without redeploying:

1. Start the local preview script.
2. Open the printed `http://<your-pc-ip>:8000` URL on the phone.
3. If you use Android + Chrome, connect the phone by USB and open `chrome://inspect/#devices` in desktop Chrome.
4. If you use iPhone + Safari, enable Web Inspector on the phone and inspect it from Safari on macOS.
