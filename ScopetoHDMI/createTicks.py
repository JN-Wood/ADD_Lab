screenWidth = 200
screenHeight = 100

tickSpacingV = int(screenHeight/40)
tickSpacingH = int(screenWidth/40)
linespacingV = int(screenHeight/10)
linespacingH = int(screenWidth/10)
tickWidth = 1

print("TickHorz <= '1' when ")
count = 0
pixel = 0
lineCount = 0
while True:
    if pixel == screenWidth:
        break
    if count == tickSpacingH:
        for i in range(-tickWidth+int(screenHeight/2), tickWidth+1+int(screenHeight/2)):
            print(f"(PixelHorz = {pixel} and pixelVert  = {i}) or")
            count = 0
        lineCount+=1
    pixel+=1
    count+=1
print("else '1';")

print("TickVert <= '1' when ")
count = 0
pixel = 0
while True:
    if pixel == screenHeight:
        break
    if count == tickSpacingV:
        for i in range(-tickWidth+int(screenWidth/2), tickWidth+1+int(screenWidth/2)):
            print(f"(pixelVert = {pixel} and pixelHorz  = {i}) or")
            count = 0
    pixel+=1
    count+=1




"""
print("LineHorz <= '1' when")
count = 0
pixel = 0         
while True:
    if pixel == screenWidth:
        break
    if count == linespacingH:
"""     

print(lineCount)