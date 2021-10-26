//INSTITUTO TECNOLÓGICO DE COSTA RICA
//VERIFICACIÓN FUNCIONAL DE CIRCUITOS INTEGRADOS
//Proyecto 2
//Lenguaje: SystemVerilog
//Creado por: Mac Alfred Pinnock Chacón (mcalfred32@gmail.com) - Susana Astorga Rodríguez (susana.0297.ar@gmail.com)

class FIFO_SIMULADA#(parameter FIFO_depth, parameter pckg_sz); 
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
              $display("UNDERFLOW");
            end
        endtask
endclass

class driver #(parameter pckg_sz,  FIFO_depth,  ROWS,  COLUMS);
  mailbox driver_mbx; 
  event agente_listo;
  virtual mesh_if #(.pckg_sz(pckg_sz), .COLUMS(COLUMS), .ROWS(ROWS)) interface_virtual; 
  FIFO_SIMULADA #(.FIFO_depth(FIFO_depth), .pckg_sz(pckg_sz)) FIFO_pila [$]; 

  task run(); 
    
    for (int i =0 ; i<=ROWS*COLUMS ; i++) begin
      FIFO_SIMULADA #(.FIFO_depth(FIFO_depth), .pckg_sz(pckg_sz)) fifo_instancia= new(); 
      fifo_instancia.ID_FIFO=i; 
      FIFO_pila.insert(i, fifo_instancia);
      end
    forever begin
    @(agente_listo) 
        begin
    forever begin 
      //@(agente_listo) 
        //begin
          la_mama_de_las_transacciones #(.pckg_sz(pckg_sz),.ROWS(ROWS),.COLUMS(COLUMS)) drvr_trn=new(); 
          driver_mbx.get(drvr_trn); 
          $display ("t = %g: Driver: Se ha recibido una transaccion del agente", $time);
          for (int i=0; i<=ROWS*COLUMS; i++) 
            begin
              if (i==drvr_trn.dispo_salida) begin
                FIFO_pila[i].push=1;
                FIFO_pila[i].current_paquete=drvr_trn.empaquetado;  
                FIFO_pila[i].pop=0;
                FIFO_pila[i].run_fifo(); 
                break;
              end
          end
      if (driver_mbx.num()==0)break;
        end
    end
    end
  endtask
  
  task FIFO_DUT(); 
    forever begin
      @(posedge (interface_virtual.clk)) 
        begin
            for (int i=0; i<=ROWS*COLUMS; i++)
                begin
                  FIFO_pila[i].push=0; 
                  FIFO_pila[i].pop=interface_virtual.popin[i]; 
                  FIFO_pila[i].run_fifo(); 
                  interface_virtual.data_out_i_in[i] <= FIFO_pila[i].pila[0];
                  //$display("Driver: dato ingresado a la FIFO = %0d", FIFO_pila[i].pila[0]);
                  if (interface_virtual.pndng[i]) begin 
                    interface_virtual.pop[i]<=1;
                  end
                  else interface_virtual.pop[i]<=0;
                  interface_virtual.pndng_i_in[i] <= FIFO_pila[i].pndng; 
                  
                  
                   
                  if (FIFO_pila[i].pop && FIFO_pila[i].empty) begin
                    $display("%0d: Driver: El estado de POP y EMPTY es igual.",$time);
                    $finish;
                  end
                
                  if (FIFO_pila[i].pndng == FIFO_pila[i].empty) begin 
                    $display("%0d: Driver: El estado del PENDING y EMPTY es igual.", $time);
                    $finish; 
                  end
                end
            end
        end
    $display ("t = %g: Driver: Dato enviado al DUT", $time);
  endtask   
endclass
