## Develop and Validate UART VIP
- Analyzed UART frame structure (Start, Data, Parity, Stop bits), baud rate, parity modes, and communication between TX and RX.
- Built UVM components including uart_agent, uart_driver, uart_monitor, uart_sequencer, uart_sequence, and uart_scoreboard.
- Enabled flexible setup through uvm_config_db (virtual interface, baud rate, data_witdh, parity, stop bits).
- Created UVM environment with TX and RX agents and multiple testcases for single or multiple data transmission, parity checks, baud rate variation, and error injection (frame, data, parity, stop bit).
- Verified functionality via scoreboard comparison, ensuring correct operation in both half-duplex and full-duplex modes.
- Testcases were created please read in file Vplan.
- Testbench structure
<img width="1190" height="622" alt="image" src="https://github.com/user-attachments/assets/ce05ab27-dcd3-4519-8ec8-075b861a4e79" />

