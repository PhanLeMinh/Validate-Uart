//=============================================================================
// Project       : UART VIP
//=============================================================================
// Filename      : test_pkg.sv
// Author        : Huy Nguyen
// Company       : NO
// Date          : 20-Dec-2021
//=============================================================================
// Description   : 
//
//
//
//=============================================================================
`ifndef GUARD_UART_TEST_PKG__SV
`define GUARD_UART_TEST_PKG__SV

package test_pkg;
  import uvm_pkg::*;
  import uart_pkg::*;
  import seq_pkg::*;
  import env_pkg::*;

  // Include your file
  `include "uart_error_catcher.sv"
  `include "uart_base_test.sv"
  `include "full_duplex_random_test.sv"
  `include "half_trans_baud_4800_test.sv"
  `include "half_trans_baud_9600_test.sv"
  `include "half_trans_baud_57600_test.sv"
  `include "half_trans_baud_115200_test.sv"
  `include "half_trans_baud_random_test.sv"

  `include "half_trans_5_bit_test.sv"
  `include "half_trans_6_bit_test.sv"
  `include "half_trans_7_bit_test.sv"
  `include "half_trans_8_bit_test.sv"
  `include "half_trans_9_bit_test.sv"

  `include "half_trans_none_parity_test.sv"
  `include "half_trans_odd_parity_test.sv"
  `include "half_trans_even_parity_test.sv"

  `include "half_trans_1_stop_bit_test.sv"
  `include "half_trans_2_stop_bit_test.sv"

  `include "half_rcv_baud_4800_test.sv"
  `include "half_rcv_baud_9600_test.sv"
  `include "half_rcv_baud_57600_test.sv"
  `include "half_rcv_baud_115200_test.sv"
  `include "half_rcv_baud_random_test.sv"

  `include "half_rcv_5_bit_test.sv"
  `include "half_rcv_6_bit_test.sv"
  `include "half_rcv_7_bit_test.sv"
  `include "half_rcv_8_bit_test.sv"
  `include "half_rcv_9_bit_test.sv"

  `include "half_rcv_none_parity_test.sv"
  `include "half_rcv_odd_parity_test.sv"
  `include "half_rcv_even_parity_test.sv"

  `include "half_rcv_1_stop_bit_test.sv"
  `include "half_rcv_2_stop_bit_test.sv"

  `include "full_baud_4800_test.sv"
  `include "full_baud_9600_test.sv"
  `include "full_baud_57600_test.sv"
  `include "full_baud_115200_test.sv"

  `include "full_data_5_bit_test.sv"
  `include "full_data_6_bit_test.sv"
  `include "full_data_7_bit_test.sv"
  `include "full_data_8_bit_test.sv"
  `include "full_data_9_bit_test.sv"

  `include "full_parity_none_test.sv"
  `include "full_parity_odd_test.sv"
  `include "full_parity_even_test.sv"

  `include "full_stop_1_bit_test.sv"
  `include "full_stop_2_bit_test.sv"

  //`include "error_baud_test.sv"
  //`include "error_stop_bit_test.sv"
  //`include "error_parity_bit_test.sv"

endpackage: test_pkg

`endif


