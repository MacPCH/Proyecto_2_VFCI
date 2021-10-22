class FIFO#(parameter FIFO_depth, parameter pckg_sz); 
        int ID_FIFO; 
        bit [pckg_sz-1:0] pila [$];
        bit [pckg_sz-1:0] current_paquete;
        bit empty;
        bit full;
        int size; 
        bit pndng; 
        bit push=0;
        bit pop=0;
        bit [pckg_sz-1:0] D_pop;
        task run_fifo();
            size=pila.size();
            if (pila.size()==0)
                begin
                 empty=1;
                 pndng=0;
            end else pndng=1;
      
            if (size==FIFO_depth) 
                begin
                full=1;
                $display("La FIFO %0d está llena", ID_FIFO);
                $display("En este momento no se puede incluir datos a la FIFO");
                $display("Se recomienda aumentar la profundidad de la FIFO");
            end else full=0;

          if ((push==1)&&(full==0)) begin
                pila.push_back(current_paquete); 
                pndng=1; 
                empty=0;
            end

            if ((pop==1)&& (empty!=1)) begin 
                 D_pop=pila.pop_front;
                full=0; 
            end
          
            if ((pop==1)&& (empty==1)) begin 
                 $display("ERROR. POP AT EMPTY FIFO");
            end
        endtask
endclass

class driver #(parameter pckg_sz,  FIFO_depth,  ROWS,  COLUMS);
  mailbox driver_mbx; 
  event agente_listo;
  virtual mesh_if #(.pckg_sz(pckg_sz), .COLUMS(COLUMS), .ROWS(ROWS)) interface_virtual; 
  FIFO #(.FIFO_depth(FIFO_depth), .pckg_sz(pckg_sz)) FIFO_queue [$]; 
  int j=0; 

  task run(); 
    
    for (int i =0 ; i<=ROWS*COLUMS ; i++) begin
      FIFO #(.FIFO_depth(FIFO_depth), .pckg_sz(pckg_sz)) fifo_new= new(); 
      fifo_new.ID_FIFO=i; 
      FIFO_queue.insert(i, fifo_new);
      end
    
    
    forever begin 
      @(agente_listo) 
        begin
          la_mama_de_las_transacciones #(.pckg_sz(pckg_sz),.ROWS(ROWS),.COLUMS(COLUMS)) drvr_trn=new(); 
          driver_mbx.get(drvr_trn); 
          $display ("t = %g: Driver: Se ha recibido una transaccion del agente", $time);
          for (int i=0; i<=ROWS*COLUMS; i++) 
            begin
              if (i==drvr_trn.dispo_salida) begin
                FIFO_queue[i].push=1;
                FIFO_queue[i].current_paquete=drvr_trn.empaquetado;  
                FIFO_queue[i].pop=0;
                FIFO_queue[i].run_fifo(); 
                break;
              end
          end
        end
    end
  endtask
  
  task parallel_fifo_sample(); 
    forever begin
      @(posedge (interface_virtual.clk)) 
        begin
            for (int i=0; i<=ROWS*COLUMS; i++)
                begin
                  FIFO_queue[i].push=0; 
                  FIFO_queue[i].pop=interface_virtual.popin[i]; 
                  FIFO_queue[i].run_fifo(); 
                  interface_virtual.data_out_i_in[i]<=FIFO_queue[i].pila[0]; 
                  if (interface_virtual.pndng[i]) begin 
                    interface_virtual.pop[i]<=1; j=j+1;  
                  end
                  else interface_virtual.pop[i]<=0;
                  interface_virtual.pndng_i_in[i]<=FIFO_queue[i].pndng; 
                   
                  assert (!(FIFO_queue[i].pop && FIFO_queue[i].empty)) begin
                  end else begin
                    $display("[FAIL] Las banderas de pop y empty son iguales.");
                  end
                  assert (FIFO_queue[i].pndng != FIFO_queue[i].empty) begin 
                    end else begin
                    $display("[FAIL] Las banderas de pending y empty son iguales.");
                  end
                
                  
                end
            end
        end
  endtask   
endclass
