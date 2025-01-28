.section .text
/////////////////////////////////////////////////////////////////////////////////////
// GPIO General Purpose I/0 Subroutine package                         0.91 AC
/////////////////////////////////////////////////////////////////////////////////////
.equ GPIOA,  0x40010800     // GPIOB Base address.
.equ GPIOB,  0x40010C00     // GPIOB Base address.
.equ CTR0,   0x00           // Port control register 0 offset
.equ ISTAT,  0x08           // Port input status register
.equ OCTL,   0x0C           // Port output control register
.equ BOP,    0x10           // Port bit operate register offset
.equ BC,     0x14           // Port bit clear register offset
.equ GPIO_AM, 0x0           // Mode: Input, Analog Mode
.equ GPIO_50, 0x3           // Mode: Output, max speed 50MHz
.equ GPIO_FI, 0x4           // Conf: (Input) Floating input
.equ GPIO_UD, 0x8           // Conf: (Input) Pull-up/-down
.equ GPIO_PP, 0x0           // Conf: (Output) Push-pull
.equ GPIO_OD, 0x4           // Conf: (Output) Open-drain

// GPIOI Initialize ////////////////////////////////////////////////// 1.0 / AC ////
// a0 Targeted GPIO-module
// a1 Configuration bits (<<2)
// a2 Mode bits
// a3 Targeted pin
gpioi:  mv t0, a0           // t0 points to GPIOX...
        mv t4, a3           //    t4 marks selected pin...
        li t1,0x8           //    Use port control register 0 or 1,
        blt t4,t1, 1f       //    thus is pin > 7?
        addi t0, t0, 4      //       Yes, adjust base address,
        addi t4,t4,-8       //            and adjust selected pin.

1:      slli t4,t4,2        //    Multiply pin nb by 4 to get steps to shift!
        li t1, 0xF          //    Create inverted configuration mask...
        sll t1, t1, t4      //    ...and move it into right position.
        not t1, t1          //    ...invert it back, then...
        mv t2, a1           //    Create configuration bits...
        or t2, t2, a2       //    
        sll t2, t2, t4      //    ...and move it into right position.

        lw t3,CTR0(t0)      //    retreive port control register 0(/1)...
        and t3,t3,t1        //    ...clear out selected pin's config/mode bits...
        or t3, t3, t2       //    ...configure new config/mode bits...
        sw t3,CTR0(t0)      //    ...and write it back.
        ret                 //  then go home!

// GPIOBO Bit Operations ///////////////////////////////////////////// 1.0 / AC ///
// a0 Targeted GPIO-module
// a1 Targeted pattern
// a2 Targeted pin(s)
gpiobo: and a1, a1, a2      // (Clear all patterns bits that are not target bits)
        xor a2, a2, a1      // Find zeros in targeted bits...
        slli a2, a2, 16     // ...position clear requests...
        or a1, a1, a2       // ...add set requests...
        sw a1, BOP(a0)      // ...then execute...
        ret                 // ...and return to caller!

// GPIBC Bit Clear /////////////////////////////////////////////////// 1.0 / AC ///
// a0 Targeted GPIO-module
// a1 Targeted pin(s)
gpiobc: sw a1, BC(a0)       // Execute request...
        ret                 // ...and return to caller!

// GPIOC Output Control ////////////////////////////////////////////// 1.0 / AC ///
// a0 Targeted GPIO-module
// a1 value
gpiooc: sw a1, OCTL(a0)      // Execute request...
        ret                 // ...and return to caller!

// GPIOIS Input Status //////////////////////////////////////////////// 1.0 / AC ///
// a0 Targeted GPIO-module
// a1 read value
gpiois: lw a1, ISTAT(a0)    // Execute request...
        ret                 // ...and return to caller!

// GPIO General Purpose I/0 Subroutine package ////////////////////////// END ///////

/////////////////////////////////////////////////////////////////////////////////////
// RCU Reset and Clock Unit Subroutine package                         0.91 AC
/////////////////////////////////////////////////////////////////////////////////////
.equ RCU,    0x40021000
.equ APB1EN, 0x1C
.equ T5EN,   0x10
.equ APB2EN, 0x18
.equ PAEN,   0x4
.equ PBEN,   0x8
// RCU1EN Enabel APB1 bus devices //////////////////////////////////// 1.0 / AC ///
rcu1en: li t0,RCU           // t0 points to RCU...
        lw t1,APB1EN(t0)    // ...retrieve current configuration...
        or t1,t1,a0         // ...and update the configuration...
        sw t1,APB1EN(t0)    // ...then save back the updated config...
        ret                 // and go home!

// RCU2EN Enabel APB2 bus devices //////////////////////////////////// 1.0 / AC ///
rcu2en: li t0,RCU           // t0 points to RCU...
        lw t1,APB2EN(t0)    // ...retrieve current configuration...
        or t1,t1,a0         // ...and update the configuration...
        sw t1,APB2EN(t0)    // ...then save back the updated config...
        ret                 // and go home!
        
// RCU Reset and Clock Unit Subroutine package ////////////////////////// END /////// 


/////////////////////////////////////////////////////////////////////////////////////
//                                LAB 1 Nivå 1                                     //
/////////////////////////////////////////////////////////////////////////////////////
.section .text
.global main

.equ GPIOB,  0x40010C00   # GPIOB Base address (LEDs)
.equ GPIOA,  0x40010800   # GPIOA Base address (Switches)
.equ OCTL,   0x0C         # Port output control register
.equ ISTAT,  0x08         # Port input status register

main:
                          # Enable clocks for GPIOA and GPIOB
    li a0, 0x0C           # Enable GPIOA and GPIOB
    call rcu2en           # Enable APB2 peripherals

                          # Initialize GPIOB for LEDs (PB0..PB2 as output)
    li a0, GPIOB
    li a1, 0x0            # Push-pull configuration
    li a2, 0x3            # Output mode (50 MHz)
    li a3, 0              # Start pin (PB0)
    li a4, 3              # End pin (PB2)
1:
    call gpioi
    addi a3, a3, 1
    bne a3, a4, 1b

                          # Initialize GPIOA for switches (PA5, PA6, PA7 as input)
    li a0, GPIOA
    li a1, 0x8            # Pull-up/pull-down configuration
    li a2, 0x0            # Input mode
    li a3, 5              # Start pin (PA5)
    li a4, 8              # End pin (PA7)
1:
    call gpioi
    addi a3, a3, 1
    bne a3, a4, 1b

    # Main loop
    li t3, 0              # t3 will act as the "lock" (0 = no LED lit, 1 = LED lit)
loop:
    # Read switches (PA5..PA7)
    li a0, GPIOA
    call gpiois
    srli a1, a1, 5        # Shift input down to get bits 5..7
    andi a1, a1, 0x07     # Mask to isolate PA5..PA7

    # Check if an LED is already lit
    bnez t3, skip_check   # If t3 != 0, skip checking switches

    # Check switches in no specific priority
    li t0, 0x01           # Mask for PA5
    and t2, t0, a1        # Check PA5
    bnez t2, light_up_b0  # If ON, light up PB0

    li t0, 0x02           # Mask for PA6
    and t2, t0, a1        # Check PA6
    bnez t2, light_up_b1  # If ON, light up PB1

    li t0, 0x04           # Mask for PA7
    and t2, t0, a1        # Check PA7
    bnez t2, light_up_b2  # If ON, light up PB2

    # If no switches are ON, turn off all LEDs
    li t1, 0
    j write_leds

light_up_b0:
    li t1, 0x01           # Turn on PB0
    li t3, 1              # Lock the state (LED lit)
    j write_leds

light_up_b1:
    li t1, 0x02           # Turn on PB1
    li t3, 1              # Lock the state (LED lit)
    j write_leds

light_up_b2:
    li t1, 0x04           # Turn on PB2
    li t3, 1              # Lock the state (LED lit)
    j write_leds

skip_check:
    # If an LED is lit, check if all switches are OFF
    beqz a1, reset_lock   # If no switches are ON, reset the lock
    j loop                # Otherwise, keep looping

reset_lock:
    li t1, 0              # Turn off all LEDs
    li t3, 0              # Reset the lock
    j write_leds

write_leds:
    li a0, GPIOB
    sw t1, OCTL(a0)       # Update LED states
    j loop                # Repeat loop