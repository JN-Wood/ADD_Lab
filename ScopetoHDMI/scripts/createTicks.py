T_EDGE = 135
L_EDGE = 240
R_EDGE = 1040
B_EDGE = 585

BORDER_LINE_WIDTH = 10


# ============================================================
# Inner Grid Boundaries
# ============================================================

gridLeft   = L_EDGE + BORDER_LINE_WIDTH       # 250
gridRight  = R_EDGE - BORDER_LINE_WIDTH       # 1030
gridTop    = T_EDGE + BORDER_LINE_WIDTH       # 145
gridBottom = B_EDGE - BORDER_LINE_WIDTH       # 575

screenWidth  = gridRight - gridLeft           # 780
screenHeight = gridBottom - gridTop           # 430

centerX = gridLeft + screenWidth // 2         # 640
centerY = gridTop + screenHeight // 2         # 360

tickWidth = 1


# ============================================================
# Number of major divisions
# ============================================================

NUM_DIVISIONS = 10

# Four ticks divide each division into five equal sections
TICKS_PER_DIVISION = 4
SUBDIVISIONS = 5


# ============================================================
# Horizontal Ticks
#
# 10 divisions
# 4 ticks per division
# = 40 ticks total
#
# Each tick is located at:
#
#   1/5, 2/5, 3/5, 4/5
#
# of the way through each division.
# ============================================================

ticks_h = []

divisionWidth = screenWidth / NUM_DIVISIONS

for division in range(NUM_DIVISIONS):

    divisionStart = gridLeft + division * divisionWidth

    for tick in range(1, SUBDIVISIONS):

        x = round(
            divisionStart +
            tick * divisionWidth / SUBDIVISIONS
        )

        for y in range(centerY - tickWidth,
                       centerY + tickWidth + 1):

            ticks_h.append(
                f"(pixelHorz = {x} and pixelVert = {y})"
            )


print("TickHorz <= '1' when")
print("                " + " or\n                ".join(ticks_h))
print("            else '0';\n")


# ============================================================
# Vertical Ticks
#
# 10 divisions
# 4 ticks per division
# = 40 ticks total
# ============================================================

ticks_v = []

divisionHeight = screenHeight / NUM_DIVISIONS

for division in range(NUM_DIVISIONS):

    divisionStart = gridTop + division * divisionHeight

    for tick in range(1, SUBDIVISIONS):

        y = round(
            divisionStart +
            tick * divisionHeight / SUBDIVISIONS
        )

        for x in range(centerX - tickWidth,
                       centerX + tickWidth + 1):

            ticks_v.append(
                f"(pixelVert = {y} and pixelHorz = {x})"
            )


print("TickVert <= '1' when")
print("                " + " or\n                ".join(ticks_v))
print("            else '0';\n")


# ============================================================
# Horizontal Grid Lines
# ============================================================

lines_h = []

for division in range(1, NUM_DIVISIONS):

    y = round(
        gridTop +
        division * screenHeight / NUM_DIVISIONS
    )

    lines_h.append(
        f"pixelVert = {y}"
    )


print(
    f"LineHorz <= '1' when "
    f"(pixelHorz >= {gridLeft} and "
    f"pixelHorz <= {gridRight}) and ("
)

print("    " + "\n    or ".join(lines_h))

print(") else '0';\n")


# ============================================================
# Vertical Grid Lines
# ============================================================

lines_v = []

for division in range(1, NUM_DIVISIONS):

    x = round(
        gridLeft +
        division * screenWidth / NUM_DIVISIONS
    )

    lines_v.append(
        f"pixelHorz = {x}"
    )


print(
    f"LineVert <= '1' when "
    f"(pixelVert >= {gridTop} and "
    f"pixelVert <= {gridBottom}) and ("
)

print("    " + "\n    or ".join(lines_v))

print(") else '0';")