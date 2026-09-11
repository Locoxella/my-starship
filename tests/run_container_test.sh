#!/usr/bin/env bash
set -e

IMAGE="$1"
if [ -z "$IMAGE" ]; then
    echo "Usage: $0 <docker-image>"
    exit 1
fi

case "$IMAGE" in
    *fedora*)   NAME="fedora" ;;
    *ubuntu*)   NAME="ubuntu" ;;
    *debian*)   NAME="debian" ;;
    *arch*)     NAME="archlinux" ;;
    *opensuse*) NAME="opensuse" ;;
    *)          NAME="generic" ;;
esac

echo "========================================="
echo " 🚀 Testing Container: $IMAGE ($NAME)"
echo "========================================="

CID="box-$NAME-$$"
docker rm -f "$CID" 2>/dev/null || true
docker run -d --name "$CID" -v "$PWD:/repo:z" -w /repo "$IMAGE" tail -f /dev/null

echo "[1/4] Bootstrapping container dependencies..."
docker exec "$CID" /repo/tests/bootstrap_distro.sh

echo "[2/4] Installing Starship & Modern CLI Tools..."
docker exec "$CID" /repo/dotfiles/setup_starship.sh

echo "[3/4] Running Automated Test Suite..."
docker exec -e GITHUB_STEP_SUMMARY=/tmp/summary.md "$CID" /repo/tests/verify_installation.sh

# Copy summary and log from container to host
if [ -n "$GITHUB_STEP_SUMMARY" ]; then
    docker exec "$CID" cat /tmp/summary.md >> "$GITHUB_STEP_SUMMARY"
fi
docker cp "$CID:/tmp/live_container_${NAME}.log" "/tmp/live_container_${NAME}.log" 2>/dev/null || true

echo "[4/4] Recording Live VHS Demo inside $NAME container..."
mkdir -p /tmp/previews
TAPE="/tmp/record_${NAME}.tape"
cat << TAPE_EOF > "$TAPE"
Output "/tmp/previews/preview_${NAME}.gif"
Set Shell "bash"
Set FontSize 14
Set Width 900
Set Height 550
Set Padding 20
Set FontFamily "Hack Nerd Font"
Set Theme "Catppuccin Mocha"

Hide
Type "docker exec -it $CID bash" Enter
Sleep 1s
Type "export STARSHIP_CONFIG=/repo/dotfiles/starship.toml" Enter
Type "source ~/.bashrc" Enter
Type "printf '\033[2J\033[H'" Enter
Show

Sleep 800ms
Type "fastfetch --structure Title:OS:Host:Kernel:Shell:Terminal"
Sleep 500ms
Enter
Sleep 3s

Type "eza --icons --group-directories-first dotfiles/"
Sleep 500ms
Enter
Sleep 2s
TAPE_EOF

vhs "$TAPE"
docker rm -f "$CID"
echo "[✓] Complete: Successfully generated /tmp/previews/preview_${NAME}.gif"
