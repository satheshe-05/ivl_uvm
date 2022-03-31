class ivl_uvm_semaphore_2_processes_access_same_resource;
//	semaphore s0;
	int cur_key_count;

	function new (int keyCount = 0);
	  this.cur_key_count = keyCount;
	endfunction : new

	function void put (int keyCount = 1);
	  this.cur_key_count += keyCount;
	endfunction : put

	task get (int keyCount = 1);
	  while (this.cur_key_count < keyCount) begin
			#1;
	  end
	  this.cur_key_count -= keyCount;
	endtask : get

	function int try_get (int keyCount = 1);
		try_get = 0;
	  if (this.cur_key_count >= keyCount) begin
		  try_get = this.cur_key_count;
	    	  this.cur_key_count -= keyCount;
          end
	endfunction : try_get

endclass : ivl_uvm_semaphore_2_processes_access_same_resource

module t;
  ivl_uvm_semaphore_2_processes_access_same_resource sm_0;
	
  	initial begin : test
		sm_0 = new(1);
		fork
		  sm_0.get();
	          $display ("SM: cur_key: %0d", sm_0.cur_key_count);
		  sm_0.put();
		  $display ("SM: cur_key: %0d", sm_0.cur_key_count);
		join
	end : test

endmodule : t
