# 3D Waypoint Indicator for RedM 🎯

<img src="./.github/assets/banner.png" alt="bln notify script - redm" width="100%" />
<div style="display: flex; justify-content: space-between;">
    <img src="./.github/assets/demo.gif" alt="Image 1" width="100%" />
</div>

A sleek and performant waypoint indicator system that shows a dynamic 3D marker pointing to your destination.

## Features ⭐
- Real-time 3D position tracking 🎮
- Smooth animations and transitions 🌊
- Distance indicator 📏
- Automatically shows/hides when setting waypoints 🗺️
- Performance optimized 🚀
- No external dependencies required 📦

## Preview
[Video Preview](https://youtu.be/OyLcVwynbtI)

## Installation 🛠️
1. Download the resource
2. Place it in your resources folder
3. Add `ensure redm-waypoint` to your `cfg` file

## Usage 🎯
1. Open your map
2. Set a waypoint anywhere
3. The 3D indicator will automatically appear and guide you!

## How it works 🔍
- Creates a dynamic 3D indicator that moves with your camera
- Shows distance to your destination
- Automatically hides when behind objects or out of view
- Optimized for smooth performance

## Configuration 🔧
You can adjust these values in `client.lua`:
```lua
local minDistance = 5.0     -- Minimum distance to show indicator
local heightOffset = 2.0    -- Height offset from ground
```

## Performance 📈
- Optimized rendering and updates
- Minimal resource usage
- Smooth real-time tracking
- GPU-accelerated animations

## Support 💬
Need help? Join our Discord server:
[Join Discord](https://discord.com/invite/MEZRYQVpnt)

## Credits 🙏
Created by [BLN Studio](https://bln.tebex.io)
Feel free to contribute to this project! 