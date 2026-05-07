
`timescale 1ns/1ps

`include "uvm_macros.svh"
import uvm_pkg::*;

package ic_pkg;

//`include "/home/sgeuser111/DrRSK/5_Interrupt_Control/defines.svh"
`include "/home/sgeuser111/DrRSK/5_Interrupt_Control/ic_seq_item.sv"
`include "/home/sgeuser111/DrRSK/5_Interrupt_Control/ic_seq.sv"
`include "/home/sgeuser111/DrRSK/5_Interrupt_Control/ic_uncov_seq.sv"
`include "/home/sgeuser111/DrRSK/5_Interrupt_Control/ic_seqr.sv"
`include "/home/sgeuser111/DrRSK/5_Interrupt_Control/ic_drv.sv"
`include "/home/sgeuser111/DrRSK/5_Interrupt_Control/ic_mon.sv"
`include "/home/sgeuser111/DrRSK/5_Interrupt_Control/ic_agent.sv"
`include "/home/sgeuser111/DrRSK/5_Interrupt_Control/ic_scb.sv"
`include "/home/sgeuser111/DrRSK/5_Interrupt_Control/ic_subscr.sv"
`include "/home/sgeuser111/DrRSK/5_Interrupt_Control/ic_env.sv"
`include "/home/sgeuser111/DrRSK/5_Interrupt_Control/ic_test.sv"

endpackage

