class monitor#(parameter pckg_sz,  FIFO_depth,  ROWS,  COLUMS);
    
    virtual mesh_if #(.pckg_sz(pckg_sz), .COLUMS(COLUMS), .ROWS(ROWS)) interface_virtual;
    mailbox monitor_mbx; 
    event monitor_listo;
  int trans_received=0;
    
  task check();
    $display ("El monitor fue inicializado");
    forever begin   @(negedge (interface_virtual.clk))
      begin
        for (int i=0; i<ROWS*COLUMS; i++) 
          if (interface_virtual.pndng[i]) 
             begin
               interface_virtual.pop[i]=1;
               monitor_mbx.put(interface_virtual.data_out[i]); 
               $display ("t = %g: Monitor: Enviado el dato de salida del DUT, dato = %0d", $time, interface_virtual.data_out[i]);
               ->monitor_listo; 
               trans_received=trans_received+1;
             end
        else interface_virtual.pop[i]=0;
      end
    end
  endtask
endclass