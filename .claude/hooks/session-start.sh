#!/bin/bash
set -euo pipefail

# Only run in remote (Claude Code on the web) environments
if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

FLUTTER_VERSION="3.41.2"
FLUTTER_INSTALL_DIR="/opt/flutter"
FLUTTER_BIN="$FLUTTER_INSTALL_DIR/bin/flutter"
FLUTTER_URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz"

# Install Flutter SDK if not already present
if [ ! -f "$FLUTTER_BIN" ]; then
  echo "Installing Flutter ${FLUTTER_VERSION}..."
  curl -fsSL "$FLUTTER_URL" -o /tmp/flutter.tar.xz
  tar -xf /tmp/flutter.tar.xz -C /opt
  rm /tmp/flutter.tar.xz
  echo "Flutter installed."
else
  echo "Flutter ${FLUTTER_VERSION} already installed."
fi

# Add Flutter to PATH for this session
export PATH="$FLUTTER_INSTALL_DIR/bin:$PATH"

# Persist PATH for the session via CLAUDE_ENV_FILE
if [ -n "${CLAUDE_ENV_FILE:-}" ]; then
  echo "export PATH=\"$FLUTTER_INSTALL_DIR/bin:\$PATH\"" >> "$CLAUDE_ENV_FILE"
fi

# Allow git to access the Flutter directory (ownership may differ in containers)
git config --global --add safe.directory "$FLUTTER_INSTALL_DIR" 2>/dev/null || true
git config --global --add safe.directory "$FLUTTER_INSTALL_DIR/.git" 2>/dev/null || true

# Disable analytics and telemetry (non-interactive environments)
"$FLUTTER_BIN" config --no-analytics 2>/dev/null || true

# Install project dependencies
echo "Running flutter pub get..."
cd "$CLAUDE_PROJECT_DIR"
"$FLUTTER_BIN" pub get
echo "Dependencies installed."
