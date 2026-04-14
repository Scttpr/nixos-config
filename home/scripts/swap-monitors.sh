#!/usr/bin/env bash
# Swap the two Acer ET241Y monitors while keeping eDP-1 in place.

set -euo pipefail

monitors=$(hyprctl monitors -j)

# Find the two Acer monitors (everything that isn't eDP-1)
acers=$(echo "$monitors" | jq -c '[.[] | select(.name != "eDP-1")]')
count=$(echo "$acers" | jq 'length')

if [[ "$count" -ne 2 ]]; then
  echo "Expected 2 external monitors, found $count. Aborting." >&2
  exit 1
fi

name_a=$(echo "$acers" | jq -r '.[0].name')
name_b=$(echo "$acers" | jq -r '.[1].name')
x_a=$(echo "$acers" | jq '.[0].x')
y_a=$(echo "$acers" | jq '.[0].y')
x_b=$(echo "$acers" | jq '.[1].x')
y_b=$(echo "$acers" | jq '.[1].y')
res_a=$(echo "$acers" | jq -r '.[0] | "\(.width)x\(.height)@\(.refreshRate)"')
res_b=$(echo "$acers" | jq -r '.[1] | "\(.width)x\(.height)@\(.refreshRate)"')

echo "Swapping $name_a (${x_a}x${y_a}) <-> $name_b (${x_b}x${y_b})"

# Compute eDP-1 centred position using pre-swap bounding box (same after swap)
edp=$(echo "$monitors" | jq -c '.[] | select(.name == "eDP-1")')
edp_w=$(echo "$edp" | jq '.width')
edp_h=$(echo "$edp" | jq '.height')
edp_rate=$(echo "$edp" | jq -r '.refreshRate')
min_x=$(echo "$acers" | jq '[.[].x] | min')
max_x=$(echo "$acers" | jq '[.[] | .x + .width] | max')
edp_y=$(echo "$acers" | jq '[.[] | .y + .height] | max')
edp_x=$(( min_x + (max_x - min_x - edp_w) / 2 ))

# Kill waybar before the swap to avoid zombie instances
killall -q waybar || true

# Apply all three monitor changes atomically
hyprctl --batch "\
keyword monitor $name_a,$res_a,${x_b}x${y_b},1 ; \
keyword monitor $name_b,$res_b,${x_a}x${y_a},1 ; \
keyword monitor eDP-1,${edp_w}x${edp_h}@${edp_rate},${edp_x}x${edp_y},1"

# Restart waybar after monitors have settled
sleep 0.5
waybar &disown

echo "Done."
