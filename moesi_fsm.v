//=====================================================================
// Design : MOESI Finite State Machine
// File Name : moesi_fsm.sv
// Description : MOESI protocol state machine
// Designer : Zili Fang
//=====================================================================
// Notable Change History:
// Date By   Version Change Description
// 2021/6/22  1.0     Initial Release
//=====================================================================

module moesi_fsm #(
                   parameter MOESI_WID = 3
                  )(
                    input                          read_miss,
                    input                          write_miss,
                    input                          write_hit,
                    input                          shared,
                    input                          exclusive,
                    input                          probe_write_hit,
                    input                          probe_read_hit,
                    input                          reset,
                    input                          clk,
                    input      [MOESI_WID - 1 : 0] current_moesi,
                    output reg [MOESI_WID - 1 : 0] updated_moesi
                  );

  parameter INVALID   = 3'b000;
  parameter SHARED    = 3'b001;
  parameter EXCLUSIVE = 3'b010;
  parameter MODIFIED  = 3'b011;
  parameter OWNED     = 3'b100;

  always @(posedge clk) begin
    if (!reset) begin
      updated_moesi <= INVALID;
    end else begin
      case (current_moesi)
        INVALID : begin
          if (read_miss && exclusive)
            updated_moesi <= EXCLUSIVE;
          else if (read_miss && shared)
            updated_moesi <= SHARED;
		  else if( write_miss)
	        updated_moesi <= MODIFIED;
          else
            updated_moesi <= INVALID;
        end
        SHARED : begin
          if (probe_write_hit)
            updated_moesi <= INVALID;
          else if (write_hit)
            updated_moesi <= MODIFIED;
          else
            updated_moesi <= SHARED;
        end
        EXCLUSIVE : begin
          if (probe_write_hit)
            updated_moesi <= INVALID;
          else if (write_hit)
            updated_moesi <= MODIFIED;
          else if (probe_read_hit)
            updated_moesi <= SHARED;
          else
            updated_moesi <= EXCLUSIVE;
        end
        MODIFIED : begin
          if (probe_write_hit)
            updated_moesi <= INVALID;
          else if (probe_read_hit)
            updated_moesi <= OWNED;
          else
            updated_moesi <= MODIFIED;
        end
        OWNED : begin
          if (write_hit)
            updated_moesi <= MODIFIED;
          else if (probe_write_hit)
            updated_moesi <= INVALID;
          else
            updated_moesi <= OWNED;
        end
        default : 
          updated_moesi <= INVALID;
      endcase
    end
  end

endmodule




