# Border Center Definitions
T_EDGE = 135
L_EDGE = 240
R_EDGE = 1040
B_EDGE = 585
BORDER_LINE_WIDTH = 10  # Half border width

# Inner Grid Boundaries
gridLeft = L_EDGE + BORDER_LINE_WIDTH      # 250
gridRight = R_EDGE - BORDER_LINE_WIDTH    # 1030
gridTop = T_EDGE + BORDER_LINE_WIDTH       # 145
gridBottom = B_EDGE - BORDER_LINE_WIDTH    # 575

screenWidth = gridRight - gridLeft         # 780
screenHeight = gridBottom - gridTop        # 430

centerX = gridLeft + (screenWidth // 2)    # 640
centerY = gridTop + (screenHeight // 2)    # 360

tickWidth = 1  # Crosshair arm half-width (+/- 1 pixel)

# 1. Horizontal Ticks along centerY (3 ticks per division x 10 = 30 total ticks)
ticks_h = []
for k in range(1, 40):
    if k % 4 != 0:  # Exclude indices that land directly on major grid lines
        x = gridLeft + round(k * screenWidth / 40.0)
        for y in range(centerY - tickWidth, centerY + tickWidth + 1):
            ticks_h.append(f"(pixelHorz = {x} and pixelVert = {y})")

print("TickHorz <= '1' when " + " or\n                ".join(ticks_h) + " else '0';\n")

# 2. Vertical Ticks along centerX (3 ticks per division x 10 = 30 total ticks)
ticks_v = []
for k in range(1, 40):
    if k % 4 != 0:  # Exclude indices that land directly on major grid lines
        y = gridTop + round(k * screenHeight / 40.0)
        for x in range(centerX - tickWidth, centerX + tickWidth + 1):
            ticks_v.append(f"(pixelVert = {y} and pixelHorz = {x})")

print("TickVert <= '1' when " + " or\n                ".join(ticks_v) + " else '0';\n")

# 3. Horizontal Grid Lines (Bounded inside gridLeft and gridRight)
lines_h = [f"pixelVert = {gridTop + round(d * screenHeight / 10.0)}" for d in range(1, 10)]
print(f"LineHorz <= '1' when (pixelHorz >= {gridLeft} and pixelHorz <= {gridRight}) and (\n    " +
      "\n    or ".join(lines_h) + "\n) else '0';\n")

# 4. Vertical Grid Lines (Bounded inside gridTop and gridBottom)
lines_v = [f"pixelHorz = {gridLeft + round(d * screenWidth / 10.0)}" for d in range(1, 10)]
print(f"LineVert <= '1' when (pixelVert >= {gridTop} and pixelVert <= {gridBottom}) and (\n    " +
      "\n    or ".join(lines_v) + "\n) else '0';")