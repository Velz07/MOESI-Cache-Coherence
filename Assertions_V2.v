//=====================================================================
// Design : MOESI FSM Assertion
// File Name : moesi_fsm_assert.sv
// Description : MOESI protocol state machine Assertion
// Designer : Zili Fang
//=====================================================================
// Notable Change History:
// Date By   Version Change Description
// 2021/6/23  1.0     Initial Release
//=====================================================================

module moesi_fsm_assert #(
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
                           input      [MOESI_WID - 1 : 0] updated_moesi
                         );

  parameter INVALID   = 3'b000;
  parameter SHARED    = 3'b001;
  parameter EXCLUSIVE = 3'b010;
  parameter MODIFIED  = 3'b011;
  parameter OWNED     = 3'b100;

  //Assertions
  //TO DO: add assertions here
  //Assertions
  //TO DO: add assertions here


// CHECK RESET
  property assr_RANDOM_reset_INVALID;
	@(posedge clk) (reset==0) |=> (updated_moesi == INVALID);
  endproperty
 

// CHECK FROM SHARED TO OTHER STATES
  property assr_SHARED_probe_wr_hit_INVALID;
	@(posedge clk) (reset==1) && (current_moesi == SHARED) && (probe_write_hit == 1) |=> (updated_moesi == INVALID);
  endproperty

  property assr_SHARED_write_hit_MODIFIED;
	@(posedge clk) (reset==1) &&  (current_moesi == SHARED) && (write_hit == 1) |=> (updated_moesi == MODIFIED);
  endproperty
  

  
// CHECK FROM INVALID TO OTHER STATES
  property assr_INVALID_read_miss_and_exclusive_EXCLUSIVE;
	@(posedge clk)  (reset==1) && (current_moesi == INVALID) && (read_miss == 1 && exclusive==1) |=> (updated_moesi == EXCLUSIVE);
  endproperty
  
  property assr_INVALID_read_miss_and_shared_SHARED;
	@(posedge clk)  (reset==1) && (current_moesi == INVALID) && (read_miss == 1 && shared==1) |=> (updated_moesi == SHARED);
  endproperty
  
  property assr_INVALID_write_miss_and_shared_MODIFIED;
	@(posedge clk)  (reset==1) && (current_moesi == INVALID) && (write_miss==1) |=> (updated_moesi == MODIFIED);
  endproperty  

// CHECK FROM EXCLUSIVE TO OTHER STATES
  property assr_EXCLUSIVE_probe_write_hit_INVALID;
	@(posedge clk)  (reset==1) && (current_moesi == EXCLUSIVE) && (probe_write_hit == 1) |=> (updated_moesi == INVALID);
  endproperty

  property assr_EXCLUSIVE_probe_read_hit_SHARED;
	@(posedge clk)  (reset==1) && (current_moesi == EXCLUSIVE) && (probe_read_hit == 1) |=> (updated_moesi == SHARED);
  endproperty

  property assr_EXCLUSIVE_write_hit_MODIFIED;
	@(posedge clk)  (reset==1) && (current_moesi == EXCLUSIVE) && (write_hit == 1) |=> (updated_moesi == MODIFIED);
  endproperty


// CHECK FROM MODIFIED TO OTHER STATES
  property assr_MODIFIED_write_hit_INVALID;
	@(posedge clk)  (reset==1) && (current_moesi == MODIFIED) && (probe_write_hit == 1) |=> (updated_moesi == INVALID);
  endproperty

  property assr_MODIFIED_write_hit_OWNED;
	@(posedge clk)  (reset==1) && (current_moesi == MODIFIED) && (probe_read_hit == 1) |=> (updated_moesi == OWNED);
  endproperty

// CHECK FROM OWNED TO OTHER STATES
  property assr_OWNED_write_hit_MODIFIED;
	@(posedge clk)  (reset==1) && (current_moesi == OWNED) && (write_hit == 1) |=> (updated_moesi == MODIFIED);
  endproperty
  
  property assr_OWNED_write_hit_INVALID;
	@(posedge clk)  (reset==1) && (current_moesi == OWNED) && (probe_write_hit == 1) |=> (updated_moesi == INVALID);
  endproperty


  

//SELF LOOP PROPERTY SHARED
   property assr_SHARED_probe_read_hit_SHARED;
	@(posedge clk) (reset==1) &&  (current_moesi == SHARED) && (probe_read_hit == 1) |=> (updated_moesi == SHARED);
  endproperty 

//SELF LOOP PROPERTY OWNED  
  property assr_OWNED_probe_read_hit_OWNED;
	@(posedge clk)  (reset==1) && (current_moesi == OWNED) && (probe_read_hit == 1) |=> (updated_moesi == OWNED);
  endproperty
  

  // assertions// CHECK FROM RANDOM TO INVALID 
  assert property(assr_RANDOM_reset_INVALID) $display("assr_RANDOM_reset_INVALID SUCCESS");
	else $error("assr_RANDOM_reset_INVALID FAIL"); 

  // assertions// CHECK FROM SHARED TO OTHER STATES 
  assert property(assr_SHARED_probe_wr_hit_INVALID) $display("assr_SHARED_probe_wr_hit_INVALID SUCCESS");
	else $error("assr_SHARED_probe_wr_hit_INVALID FAIL");
	
  assert property(assr_SHARED_write_hit_MODIFIED) $display("assr_SHARED_write_hit_MODIFIED SUCCESS");
	else $error("assr_SHARED_write_hit_MODIFIED FAIL");	
  
	
	
// CHECK FROM INVALID TO OTHER STATES 
  assert property(assr_INVALID_read_miss_and_exclusive_EXCLUSIVE) $display("assr_INVALID_read_miss_and_exclusive_EXCLUSIVE SUCCESS");
	else $error("assr_INVALID_read_miss_and_exclusive_EXCLUSIVE FAIL");	
	
  assert property(assr_INVALID_read_miss_and_shared_SHARED) $display("assr_INVALID_read_miss_and_shared_SHARED SUCCESS");
	else $error("assr_INVALID_read_miss_and_shared_SHARED FAIL");	
	
  assert property(assr_INVALID_write_miss_and_shared_MODIFIED) $display("assr_INVALID_write_miss_and_shared_MODIFIED SUCCESS");
	else $error("assr_INVALID_write_miss_and_shared_MODIFIED FAIL");		

// CHECK FROM EXCLUSIVE TO OTHER STATES
  assert property(assr_EXCLUSIVE_probe_write_hit_INVALID) $display("assr_EXCLUSIVE_probe_write_hit_INVALID SUCCESS");
	else $error("assr_EXCLUSIVE_probe_write_hit_INVALID FAIL");		

	
  assert property(assr_EXCLUSIVE_probe_read_hit_SHARED) $display("assr_EXCLUSIVE_probe_read_hit_SHARED SUCCESS");
	else $error("assr_EXCLUSIVE_probe_read_hit_SHARED FAIL");		

	
  assert property(assr_EXCLUSIVE_write_hit_MODIFIED) $display("assr_EXCLUSIVE_write_hit_MODIFIED SUCCESS");
	else $error("assr_EXCLUSIVE_write_hit_MODIFIED FAIL");		
  
// CHECK FROM MODIFIED TO OTHER STATES
  assert property(assr_MODIFIED_write_hit_INVALID) $display("assr_MODIFIED_write_hit_INVALID SUCCESS");
	else $error("assr_MODIFIED_write_hit_INVALID FAIL");	

  assert property(assr_MODIFIED_write_hit_OWNED) $display("assr_MODIFIED_write_hit_OWNED SUCCESS");
	else $error("assr_MODIFIED_write_hit_OWNED FAIL");	
	
// CHECK FROM OWNED TO OTHER STATES
  assert property(assr_OWNED_write_hit_MODIFIED) $display("assr_OWNED_write_hit_MODIFIED SUCCESS");
	else $error("assr_OWNED_write_hit_MODIFIED FAIL");	

  assert property(assr_OWNED_write_hit_INVALID) $display("assr_OWNED_write_hit_INVALID SUCCESS");
	else $error("assr_OWNED_write_hit_INVALID FAIL");		

  assert property(assr_OWNED_probe_read_hit_OWNED) $display("assr_OWNED_probe_read_hit_OWNED SUCCESS");
	else $error("assr_OWNED_probe_read_hit_OWNED FAIL");
	
// SELF LOOP SHARED
  assert property(assr_SHARED_probe_read_hit_SHARED) $display("assr_SHARED_probe_read_hit_SHARED SUCCESS");
	else $error("assr_SHARED_probe_read_hit_SHARED FAIL");	

// SELF LOOP OWNED	
  assert property(assr_OWNED_probe_read_hit_OWNED) $display("assr_OWNED_probe_read_hit_OWNED SUCCESS");
	else $error("assr_OWNED_probe_read_hit_OWNED FAIL");

endmodule
