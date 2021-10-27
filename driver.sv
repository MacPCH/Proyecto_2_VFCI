//INSTITUTO TECNOLÓGICO DE COSTA RICA
//VERIFICACIÓN FUNCIONAL DE CIRCUITOS INTEGRADOS
//Proyecto 2
//Lenguaje: SystemVerilog
//Creado por: Mac Alfred Pinnock Chacón (mcalfred32@gmail.com)

// se define una FIFO simulada para simular el comportamiento esperado de las fifos del DUT
class FIFO_SIMULADA#(parameter FIFO_depth, parameter pckg_sz); 
        int num_fifo; 
        bit empty;
        bit full;
        int tamano; 
        bit pndng; 
        bit push=0;
        bit pop=0;
        bit [pckg_sz-1:0] pila [$];
        bit [pckg_sz-1:0] paquete_envio;
        bit [pckg_sz-1:0] D_pop;
        task run_fifo();
          
            tamano=pila.size();
            if (tamano==0) // en caso de que la fifo este vacia se ponen la bandera de vacio como activa y pendiente en inactiva 
                begin
                 empty=1;
                 pndng=0;
            end else pndng=1;
            if (tamano==FIFO_depth) // en caso de que la fifo este llena se ponen la bandera de llenado como activa
                begin
                full=1;
                $display("t = %0d: Driver: Overflow", $time, num_fifo);
            end else full=0;
            if ((pop==1)&& (empty!=1)) begin // se procede a sacar un dato si es requerido y si se cumple la condicion de que la fifo no está vacia
                 D_pop=pila.pop_front;
                full=0; 
            end
            if ((push==1)&&(full==0)) begin // se procede a ingresar un dato si es requerido y si se cumple la condicion de que la fifo está vacia
                pila.push_back(paquete_envio); 
                pndng=1; 
                empty=0;
            end
            if ((pop==1)&& (empty==1)) begin //por si se trata de sacar las datos sobre una fifo que ya esta vacia 
              $display("Driver: underflow");
            end
        endtask
endclass

// controlador que maneja la fifo simulada para comprobacion así como la del DUT 
class driver #(parameter pckg_sz,  FIFO_depth,  ROWS,  COLUMS);
  mailbox driver_mbx; //mailbos del agente al driver
  event agente_listo; // evento para cuando el agente haya terminado con todas las transacciones desde el generador
  virtual mesh_if #(.pckg_sz(pckg_sz), .COLUMS(COLUMS), .ROWS(ROWS)) interface_virtual; //Instanciacion de la interfaz con el DUT y de la fifo simulada
  FIFO_SIMULADA #(.FIFO_depth(FIFO_depth), .pckg_sz(pckg_sz)) FIFO_pila [$]; //tamaño COLUMS*ROWS

  task run(); //inicia la prueba llamada desde el ambiente 
    for (int i =0 ; i<=ROWS*COLUMS ; i++) begin // se crean 16 fifos para el test cada una con los objetos de la clase de la fifo simulada
      FIFO_SIMULADA #(.FIFO_depth(FIFO_depth), .pckg_sz(pckg_sz)) fifo_instancia= new(); 
      fifo_instancia.num_fifo=i; //Identificador o numero de la fifo
      FIFO_pila.insert(i, fifo_instancia);
      end
    forever begin
    @(agente_listo) //una vez todo el agente esté listo se comienza a ingresar los datos a las fifos simulada y luego copiadas a las del DUT
        begin
    forever begin 
          la_mama_de_las_transacciones #(.pckg_sz(pckg_sz),.ROWS(ROWS),.COLUMS(COLUMS)) transaccion_driver=new(); // instancia y construccion de la clases que va a tener la informacion desde el mailbos
          driver_mbx.get(transaccion_driver); // se van sacando los datos desde el agente
          $display ("t = %g: Driver: Se ha recibido una transaccion del agente", $time); 
          for (int i=0; i<=ROWS*COLUMS; i++)  //verifica para las 16 opciones si el dispositivo de salida se encuentra en la transaccion para ingresar ese mismo dato a la fifo simulada
            begin
              if (i==transaccion_driver.dispo_salida) begin
                FIFO_pila[i].push=1;
                FIFO_pila[i].paquete_envio=transaccion_driver.empaquetado; //se ingresa todo el paquete de datos porque es este paquete el que se mete al DUT 
                FIFO_pila[i].pop=0;
                FIFO_pila[i].run_fifo(); // se corre la funcion de a fifo simulada para luego de ingresar los datos segun corresponda
                break;
              end
          end
      if (driver_mbx.num()==0)begin // si no hay nada en el mailbox desde el agente quiere decir que el driver a metido todo a la fifo simulada
        break;
        end
    end
    end
    end
  endtask
  
  task FIFO_DUT(); // este task corre disrecatmnte en el for del ambiente, es independiente de los otros task del driver y es persistente, ingresa los datos desde la fifo simulada
    forever begin
      @(posedge (interface_virtual.clk)) 
        begin
            for (int i=0; i<=ROWS*COLUMS; i++) //todos los 16 dispositivos son recorridos para ingresar los datos desde el DUT simulado
                begin
                  FIFO_pila[i].push=0; //muy importante estar en cero porque esta funcion no hace nada hasta que el monitor lo indique con un pop virtual
                  FIFO_pila[i].pop=interface_virtual.popin[i]; //se obtiene el estado de POP desde el monitor si corresponde
                  FIFO_pila[i].run_fifo(); // si el pop existe obtendo los datos del DUT simulado y los ingreso al DUT real 
                  interface_virtual.data_out_i_in[i] <= FIFO_pila[i].pila[0];
                  if (interface_virtual.pndng[i]) begin //en el caso de existir un dato pendiente en el DUT real se saca
                    interface_virtual.pop[i]<=1;
                  end
                  else interface_virtual.pop[i]<=0;
                  interface_virtual.pndng_i_in[i] <= FIFO_pila[i].pndng; //se prende la bandera de la fifo del DUT
                end
            end
        end
    $display ("t = %g: Driver: Dato enviado al DUT", $time);
  endtask   
endclass