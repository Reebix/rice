#!/usr/bin/env bash
set -e

# Detect ASUS hardware
IS_ASUS=false

if [[ -r /sys/class/dmi/id/sys_vendor ]] &&
   grep -qi 'ASUSTeK\|ASUS' /sys/class/dmi/id/sys_vendor; then
    IS_ASUS=true
fi

# Base packages
PACKAGES=(
    yay
    github-cli
    thunderbird
    vesktop-bin
    solaar
    euro-office-bin
    nextcloud-client
    wireguard-tools
    git
    btop
    nvtop
    appmenu-gtk-module
    libdbusmenu-glib
    fuse2
    flatpak
    cachyos-samba-settings
    vscodium
    plasma-browser-integration
)

# Install ASUS utilities only on ASUS hardware
if "$IS_ASUS"; then
    PACKAGES+=(asusctl)
    echo "ASUS hardware detected; including asusctl."
else
    echo "Non-ASUS hardware detected; skipping asusctl."
fi

# Install yay and the selected packages
sudo pacman -Syu --needed "${PACKAGES[@]}"

# Optional ASUS battery charge limit
if "$IS_ASUS" && command -v asusctl >/dev/null 2>&1; then
    read -r -p "Set ASUS battery charge limit to 80%? [y/N] " answer

    if [[ "$answer" =~ ^[Yy]$ ]]; then
        sudo asusctl battery limit 80 ||
            echo "Could not set battery limit; check hardware support."
    else
        echo "Skipping ASUS battery limit."
    fi
fi

# Firefox extensions: temporary enterprise policies
FIREFOX_POLICY_DIR="/usr/lib/firefox/distribution"
POLICY_FILE="$FIREFOX_POLICY_DIR/policies.json"

sudo install -d "$FIREFOX_POLICY_DIR"

sudo tee "$POLICY_FILE" > /dev/null <<'EOF'
{
  "policies": {
    "DisableTelemetry": true,
    "DisableFirefoxStudies": true,
    "DisablePocket": true,
    "DisableFeedbackCommands": true,
    "DisableRemoteImprovements": true,
    "Cookies": {
      "Behavior": "partition-foreign"
    },
    "Preferences": {
      "datareporting.policy.dataSubmissionEnabled": {
        "Value": false,
        "Status": "locked"
      },
      "browser.newtabpage.activity-stream.feeds.telemetry": {
        "Value": false,
        "Status": "locked"
      },
      "browser.newtabpage.activity-stream.telemetry": {
        "Value": false,
        "Status": "locked"
      }
    },
    "EnableTrackingProtection": {
      "Value": true,
      "Cryptomining": true,
      "Fingerprinting": true,
      "EmailTracking": true,
      "SuspectedFingerprinting": true,
      "Category": "strict"
    },
    "Extensions": {
      "Install": [
        "https://addons.mozilla.org/firefox/downloads/latest/{a6c4a591-f1b2-4f03-b3ff-767e5bedf4e7}/latest.xpi",
        "https://addons.mozilla.org/firefox/downloads/latest/uBlock0@raymondhill.net/latest.xpi",
        "https://addons.mozilla.org/firefox/downloads/latest/{446900e4-71c2-419f-a6a7-df9c091e268b}/latest.xpi",
        "https://addons.mozilla.org/firefox/downloads/latest/reddituntranslate/latest.xpi",
        "https://addons.mozilla.org/firefox/downloads/latest/plasma-integration/latest.xpi",
        "https://addons.mozilla.org/firefox/downloads/latest/clear-browsing-data/latest.xpi"
      ]
    }
  }
}
EOF

echo "Launching Firefox with temporary policies..."
firefox

echo "Firefox has closed."
echo "Verify all six extensions in about:addons before continuing."
read -r -p "Remove temporary policies now? [Y/n] " answer

if [[ "$answer" =~ ^[Nn]$ ]]; then
    echo "Policies retained at: $POLICY_FILE"
else
    sudo rm -f "$POLICY_FILE"
    echo "Policies removed. Restart Firefox to use normal settings."
fi


echo yay: jetbrains-toolbox galaxybudsclient-bin
echo after reboot: flatpak install flathub it.mijorus.gearlever
