// Turn on screen
extern void turnOnScreen();

// Turn off screen
extern void turnOffScreen();

// Transfer to VRAM
extern void transferToVRAM(ptr<byte> _source, word _dest, word _size);

// Transfer to Palette RAM
extern void transferToPaletteRAM(ptr<byte> _source, word _dest, word _size);

// Wait for vblank
extern void waitForVBlank();
