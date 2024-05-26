; NES Game Development Tutorial
;
; Author: Jonathan Moody
; Github: https://github.com/jonmoody

  .inesprg 1    ; Defines the number of 16kb PRG banks
  .ineschr 1    ; Defines the number of 8kb CHR banks
  .inesmap 0    ; Defines the NES mapper
  .inesmir 1    ; Defines VRAM mirroring of banks

  .rsset $0000
pointerBackgroundLowByte  .rs 1
pointerBackgroundHighByte .rs 1

  .bank 0
  .org $C000

RESET:
  JSR LoadBackground
  LDA #%10000000
  STA $2000
  LDA #%00011110
  STA $2001
  LDA #$00
  STA $2006
  STA $2006
  STA $2005
  STA $2005

LoadBackground: ; Load the value #$2000 to the address $2006
  LDA $2002 ; Load $2002 to the Accumulator to reset the PPU 
  LDA #$20  ; Load the first byte (#$20) to the Accumulator
  STA $2006 ; Store the value from the Accumulator (#$20) to address $2006
  LDA #$00  ; Load the second byte (#$00) to the Accumulator
  STA $2006 ; Store the value from the Accumulator (#$00) to address $2006

; Load the background into the memory
  LDA #LOW(background)
  STA pointerBackgroundLowByte
  LDA #HIGH(background)
  STA pointerBackgroundHighByte

; Initialize x and y registers to #$00
  LDX #$00
  LDY #$00
.Loop:
  LDA [pointerBackgroundLowByte], y
  STA $2007

  INY
  CPY #$00
  BNE .Loop

  INC pointerBackgroundHighByte
  INX
  CPX #$04
  BNE .Loop
  RTS

InfiniteLoop:
  JMP InfiniteLoop

NMI:
  RTI

  .bank 1
  .org $E000

background:
  .include "graphics/background.asm"

  .org $FFFA
  .dw NMI
  .dw RESET
  .dw 0

  .bank 2
  .org $0000
  .incbin "graphics.chr"

