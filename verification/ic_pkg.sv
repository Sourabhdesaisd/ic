//include timescale, macro file & import uvm_pkg

`timescale 1ns/1ps
`include "uvm_macros.svh"
import uvm_pkg::*;

package ic_pkg;
//Include list of TB files

`include "ic_seq_item.sv"
`include "ic_seq.sv"
`include "ic_seqr.sv"
`include "ic_drv.sv"
`include "ic_mon.sv"
`include "ic_agent.sv"
`include "ic_scb.sv"
`include "ic_subscr.sv"
`include "ic_env.sv"
`include "ic_test.sv"

endpackage
