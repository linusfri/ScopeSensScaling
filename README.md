# Scope sensitivity scaling

### What is doesn't do
Work with PIP scopes. This mod does not scale sens when PIP is enabled. Because the behaviour of PIP is very strange at the moment and zooms baseFOV as well as scope FOV. So i did not bother fixing that in this first version.

### What is does
This mod scales the sensitivity based on the current fov when using scopes. It scales the perceived sensitivity to try to get the same feeling when aiming hipfire/ads/scope. So this should hopefully make the sensitivity transitions between fov transitions less jarring. You can still adjust your scope sens and this mod will use your sensitivity to make the calculations. Although i recommend using the same scope sensitivity as aim/look sensitivity. The scaling calculation is based on ``focal length scaling`` https://www.kovaak.com/sens-scaling/. It is calculated at 75% monitor distance to reach a nice middle ground.

### How to install
1. Download this mod
2. Go to steam -> right click road to vostok -> Manage -> Browse Local Files
3. If not already created, create a folder in game directory named ``mods``
4. Drag the downloaded mod to ``mods`` folder
