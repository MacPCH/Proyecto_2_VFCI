//INSTITUTO TECNOLÓGICO DE COSTA RICA
//VERIFICACIÓN FUNCIONAL DE CIRCUITOS INTEGRADOS
//Proyecto 2
//Lenguaje: SystemVerilog
//Creado por: Mac Alfred Pinnock Chacón (mcalfred32@gmail.com) - Susana Astorga Rodríguez (susana.0297.ar@gmail.com)

class monitor#(parameter pckg_sz,  FIFO_depth,  ROWS,  COLUMS);
    
    virtual mesh_if #(.pckg_sz(pckg_sz), .COLUMS(COLUMS), .ROWS(ROWS)) interface_virtual; //se crea la interfaz virtual
    mailbox monitor_mbx; //mailbox del monitor al checker
    event monitor_listo; // indica cuando el monitor completó su transacción al Checker
    int trans_received=0;
    
  task check();
    $display ("El monitor fue inicializado");
    forever begin   @(negedge (interface_virtual.clk)) //cada vez que encuentro un flanco negativo del reloj de la interfaz
      begin
        for (int i=0; i<ROWS*COLUMS; i++)  // repite ciclo para cada FIFO hasta i=16
          if (interface_virtual.pndng[i]) // se ejecuta si la FIFO tiene datos
             begin
               interface_virtual.pop[i]=1;
               monitor_mbx.put(interface_virtual.data_out[i]);  //envío el dato de salida de la interfaz hacia el checker
               $display ("t = %g: Monitor: Obtenido el dato de salida del DUT, Dato = %0d, Dispositivo= %0d, Transacciones totales del test= %0d", $time, interface_virtual.data_out[i], i, trans_received+1);
               trans_received++;
               	->monitor_listo;  //se activa el evento
               //break;
               
             end
        else interface_virtual.pop[i]=0;
      end
      //break;
    end
   
  endtask
endclass
