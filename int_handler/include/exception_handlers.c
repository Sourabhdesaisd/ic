#include <stdint.h>

/*
 * Replace these registers and clear values with the actual SoC details.
 */
//#define REG32(addr) (*(volatile uint32_t *)(addr))
//
//#define IRQ5_CLEAR_REG_ADDR  0x40001008U
//#define IRQ6_CLEAR_REG_ADDR  0x40002008U
//
//#define IRQ5_CLEAR_VALUE     (1U << 5)
//#define IRQ6_CLEAR_VALUE     (1U << 6)
//
//#define IRQ5_CLEAR_REG       REG32(IRQ5_CLEAR_REG_ADDR)
//#define IRQ6_CLEAR_REG       REG32(IRQ6_CLEAR_REG_ADDR)


/*
 * Read the machine exception program counter.
 */
static inline uint32_t read_mepc(void)
{
    uint32_t mepc_value;

    __asm__ volatile (
        "csrr %0, mepc"
        : "=r" (mepc_value)
    );

    return mepc_value;
}


/*
 * Write the machine exception program counter.
 */
static inline void write_mepc(uint32_t mepc_value)
{
    __asm__ volatile (
        "csrw mepc, %0"
        :
        : "r" (mepc_value)
    );
}


/*
 * Common recovery operation:
 *
 * Skip the faulting instruction so that mret continues execution
 * from the instruction after the invalid memory access.
 *
 * This assumes:
 *   1. mepc contains the faulting instruction address.
 *   2. Compressed instructions are disabled.
 *   3. Every instruction is 4 bytes.
 */
static inline void skip_faulting_instruction(void)
{
    uint32_t mepc_value;

    mepc_value = read_mepc();
    mepc_value = mepc_value + 4U;
    write_mepc(mepc_value);
}


/*
 * IRQ0: Watchdog Timer interrupt.
 *
 * Interrupt source:
 *     WDT timeout
 *
 * Expected SoC connection:
 *     WDT -> ext_int0_i -> Interrupt Controller -> CPU
 *
 * Linker places this handler at:
 *     0x0000_C000
 */

void irq0_handler(void)
    __attribute__((interrupt("machine"),
                   section(".irq0_handler"),
                   used,
                   aligned(4)));

void irq0_handler(void)
{
    /*
     * WDT interrupt has reached the CPU.
     *
     * Keep the first version simple.
     * We only prove that the CPU successfully entered
     * the IRQ0 handler.
     */

    info_print(0xA000);

    /*
     * IMPORTANT:
     * Do not add mret here.
     *
     * The GCC:
     *
     *     interrupt("machine")
     *
     * attribute generates the interrupt return sequence.
     */
}



/*
 * IRQ5: Data-memory address decode error.
 *
 * The address does not match any valid memory/peripheral slave.
 * CPU directly jumps to 0x0000_D400.
 */
void irq5_handler(void)
    __attribute__((interrupt("machine"),
                   section(".irq5_handler"),
                   used,
                   aligned(4)));

void irq5_handler(void)
{
    /*
     * Clear the address-decode error source.
     */
    //IRQ5_CLEAR_REG = IRQ5_CLEAR_VALUE;

    /*
     * Avoid executing the same invalid load/store again.
     */
    skip_faulting_instruction();

    /*
     * interrupt("machine") makes the compiler generate mret.
     */
}


/*
 * IRQ6: Data-memory slave address decode error.
 *
 * The address selects a valid slave, but the offset inside the
 * slave is reserved or unsupported.
 * CPU directly jumps to 0x0000_D800.
 */
void irq6_handler(void)
    __attribute__((interrupt("machine"),
                   section(".irq6_handler"),
                   used,
                   aligned(4)));

void irq6_handler(void)
{
    /*
     * Clear the slave address-decode error source.
     */
    //IRQ6_CLEAR_REG = IRQ6_CLEAR_VALUE;

    /*
     * Avoid executing the same invalid load/store again.
     */
    skip_faulting_instruction();

    /*
     * interrupt("machine") makes the compiler generate mret.
     */
}


void irq10_handler(void)
    __attribute__((interrupt("machine"),
                   section(".irq10_handler"),
                   used,
                   aligned(4)));

void irq10_handler(void)
{
    /*
     * Clear the slave address-decode error source.
     */
    //IRQ6_CLEAR_REG = IRQ6_CLEAR_VALUE;

    /*
     * Avoid executing the same invalid load/store again.
     */
  //  skip_faulting_instruction();

    /*
     * interrupt("machine") makes the compiler generate mret.
     */
}
