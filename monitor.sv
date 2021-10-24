//INSTITUTO TECNOLÓGICO DE COSTA RICA
//VERIFICACIÓN FUNCIONAL DE CIRCUITOS INTEGRADOS
//Proyecto 2
//Lenguaje: SystemVerilog
//Creado por: Mac Alfred Pinnock Chacón (mcalfred32@gmail.com)

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
               $display ("t = %g: Monitor: Obtenido el dato de salida del DUT, Dato = %0d, Dispositivo= %0d, Transacciones totales del test= %0d", $time, interface_virtual.data_out[i], i, trans_received+1);
               trans_received++;
               	->monitor_listo; 
               //break;
               
             end
        else interface_virtual.pop[i]=0;
      end
      //break;
    end
   
  endtask
endclass