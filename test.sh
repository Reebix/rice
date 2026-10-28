# Firefox extensions
# Assumes Firefox is installed from the CachyOS repositories.

FIREFOX_POLICY_DIR="/usr/lib/firefox/distribution"

sudo install -d "$FIREFOX_POLICY_DIR"

sudo tee "$FIREFOX_POLICY_DIR/policies.json" > /dev/null <<'EOF'
{
  "policies": {
    "Extensions": {
      "Install": [
        "https://addons.mozilla.org/firefox/downloads/latest/user-agent-string-switcher/latest.xpi",
        "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi",
        "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi",
        "https://addons.mozilla.org/firefox/downloads/latest/reddituntranslate/latest.xpi",
        "https://addons.mozilla.org/firefox/downloads/latest/plasma-integration/latest.xpi"
      ]
    }
  }
}
EOF
