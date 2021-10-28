//INSTITUTO TECNOLÓGICO DE COSTA RICA
//VERIFICACIÓN FUNCIONAL DE CIRCUITOS INTEGRADOS
//Proyecto 2
//Lenguaje: SystemVerilog
//Creado por: Mac Alfred Pinnock Chacón (mcalfred32@gmail.com) - Susana Astorga Rodríguez (susana.0297.ar@gmail.com)

// Generador
class Generador #(parameter pckg_sz, num_trans, ROWS,COLUMS);
    event generador_listo; // indica cuando la transacción del generador  está lista
    mailbox agente_mbx; //mailbox del generador al agente
  	comando_test_generador_mbx test_generador_mbx; //mailbox del test al generador
    tipos_de_transacciones instruccion_especifica = new();  
  	la_mama_de_las_transacciones #(.pckg_sz(pckg_sz),.ROWS(ROWS),.COLUMS(COLUMS)) trans_send; //declaro la transacción que va hacia el agente
  
    task run(); //task donde corre el generador
      $display ("El generador fue inicializado");
      forever begin
      #1
        if(test_generador_mbx.num() > 0)begin
      
      test_generador_mbx.try_get(instruccion_especifica); //intenta obetner la instrucción específica y si está vacío devuelve cero
      $display("Que hay aqui: %s", instruccion_especifica.tipo);	
      
  
        case(instruccion_especifica.tipo) //case para saber el tipo de transacción 
            ordenado: //genera una transacción ordenada
              begin
                $display ("Generador: Se ha escogido la transaccion ordenada para el agente");
                for (int i=0; i<ROWS*COLUMS; i++) begin //ejecuta el ciclo para la cantidad indicada de iteraciones
                  la_mama_de_las_transacciones #(.pckg_sz(pckg_sz),.ROWS(ROWS),.COLUMS(COLUMS)) trans = new; // crea una nueva transacción
                  trans.randomize();
                  for (int h=0; h<=trans.retraso*100;h++) begin
                    #1;
                  end
                  trans_send = new;
                  trans_send.num_transacciones = instruccion_especifica.num_transacciones;
                  trans_send.dispo_salida=trans.dispo_salida;
                  trans_send.dispo_entrada=i;
                  trans_send.modo=trans.modo;
                  trans_send.mensaje=trans.mensaje;
                  trans_send.tiempo_envio=$time;
                  agente_mbx.put(trans_send);  //envío la transacccion hacia el agente
        		  ->generador_listo; //indica que la transacción del generador está completa
                end
                $display (" ||  ||  ||  ||  ||  ||  ||  ||  ||  || ");
                $display (" ||  ||  ||  ||  ||  ||  ||  ||  ||  || ");
                $display (" \\/  \\/  \\/  \\/  \\/  \\/  \\/  \\/  \\/  \\/");
                $display ("t = %0t Generador: Generadas las %0d transacciones", $time, ROWS*COLUMS);
                $display (" /\\  /\\  /\\  /\\  /\\  /\\  /\\  /\\  /\\  /\\");
                $display (" ||  ||  ||  ||  ||  ||  ||  ||  ||  || ");
                $display (" ||  ||  ||  ||  ||  ||  ||  ||  ||  || ");
              end
              
            
          aleatorio: //genera una transacción aleatoria
              begin
                $display ("Generador: Se ha escogido la transaccion aleatoria para el agente");
                for (int i=0; i< instruccion_especifica.num_transacciones; i++) begin  //ejecuta el ciclo para la cantidad indicada de iteraciones
                  la_mama_de_las_transacciones #(.pckg_sz(pckg_sz),.ROWS(ROWS),.COLUMS(COLUMS)) trans = new; // crea e instancio una nueva transacción
                  trans.randomize();
                  for (int h=0; h<=trans.retraso*100;h++) begin
                    #1;
                  end
                  trans_send = new;
                  trans_send.num_transacciones = instruccion_especifica.num_transacciones;
                  trans_send.dispo_salida=trans.dispo_salida;
                  trans_send.dispo_entrada=trans.dispo_entrada;
                  trans_send.modo=trans.modo;
                  trans_send.mensaje=trans.mensaje;
                  trans_send.tiempo_envio=$time;
                  agente_mbx.put(trans_send);
        			    ->generador_listo; 
                end
                $display (" ||  ||  ||  ||  ||  ||  ||  ||  ||  || ");
                $display (" ||  ||  ||  ||  ||  ||  ||  ||  ||  || ");
                $display (" \\/  \\/  \\/  \\/  \\/  \\/  \\/  \\/  \\/  \\/");
                $display ("t = %0t Generador: Generadas las %0d transacciones", $time, instruccion_especifica.num_transacciones);
                $display (" /\\  /\\  /\\  /\\  /\\  /\\  /\\  /\\  /\\  /\\");
                $display (" ||  ||  ||  ||  ||  ||  ||  ||  ||  || ");
                $display (" ||  ||  ||  ||  ||  ||  ||  ||  ||  || ");
                
              end
            esquina: //genera transacciones de acuerdo al tipo de caso de esquina
              begin 
                case(instruccion_especifica.esquina)
                  fila_primero:  //genera una transacción del caso esquina fila primero
                    begin
                      $display("Generador: El caso de esquina es: %s", instruccion_especifica.esquina);
                      for (int i=0; i< instruccion_especifica.num_transacciones; i++) begin
                      la_mama_de_las_transacciones #(.pckg_sz(pckg_sz),.ROWS(ROWS),.COLUMS(COLUMS)) trans = new;
                      trans.randomize();
                      trans.mensaje={pckg_sz-17{1'b0}};
                      for (int h=0; h<=trans.retraso*50;h++) begin
                        #1;
                      end
                      trans_send = new;
                      trans_send.num_transacciones = instruccion_especifica.num_transacciones;
                      trans_send.dispo_salida = trans.dispo_salida;
                      trans_send.dispo_entrada = trans.dispo_entrada;
                      trans_send.modo = 1'b0;
                      trans_send.mensaje = trans.mensaje;
                      trans_send.tiempo_envio=$time;
                      agente_mbx.put(trans_send);
                            ->generador_listo;
                    end
                    end
                  columna_primero: //genera una transacción del caso esquina columna primero
                    begin
                      $display("Generador: El caso de esquina es: %s", instruccion_especifica.esquina);
                      for (int i=0; i< instruccion_especifica.num_transacciones; i++) begin
                      la_mama_de_las_transacciones #(.pckg_sz(pckg_sz),.ROWS(ROWS),.COLUMS(COLUMS)) trans = new;
                      trans.randomize();
                      trans.mensaje={pckg_sz-17{1'b0}};
                      for (int h=0; h<=trans.retraso*50;h++) begin
                        #1;
                      end
                      trans_send = new;
                      trans_send.num_transacciones = instruccion_especifica.num_transacciones;
                      trans_send.dispo_salida = trans.dispo_salida;
                      trans_send.dispo_entrada = trans.dispo_entrada;
                      trans_send.modo = 1'b1;
                      trans_send.mensaje = trans.mensaje;
                      trans_send.tiempo_envio=$time;
                      agente_mbx.put(trans_send);
                            ->generador_listo;
                    end
                    end
                  error: //genera una transacción del caso esquina error
                    begin
                      $display("Generador: El caso de esquina es: %s", instruccion_especifica.esquina);
                    end
                  destino_igual_origen: //genera una transacción del caso esquina destino igual al origen
                    begin
                      $display("Generador: El caso de esquina es: %s", instruccion_especifica.esquina);
                      for (int i=0; i< instruccion_especifica.num_transacciones; i++) begin
                      la_mama_de_las_transacciones #(.pckg_sz(pckg_sz),.ROWS(ROWS),.COLUMS(COLUMS)) trans = new;
                      trans.randomize();
                      for (int h=0; h<=trans.retraso*50;h++) begin
                        #1;
                      end
                      trans_send = new;
                      trans_send.num_transacciones = instruccion_especifica.num_transacciones;
                      trans_send.dispo_salida = trans.dispo_entrada;
                      trans_send.dispo_entrada = trans_send.dispo_salida;
                      trans_send.modo = trans.modo;
                      trans_send.mensaje = trans.mensaje;
                      trans_send.tiempo_envio=$time;
                      agente_mbx.put(trans_send);
                            ->generador_listo;
                    end
                    end
                endcase
                
                
                
                end


             overflow: 
               begin
                 for (int i=0; i<instruccion_especifica.num_transacciones; i++) begin 
                  la_mama_de_las_transacciones #(.pckg_sz(pckg_sz),.ROWS(ROWS),.COLUMS(COLUMS)) trans = new;
                  trans.randomize(); //se aleatoriza trans
                  for (int h=0; h<=trans.retraso;h++) begin
                    #1;
                  end
                   //if (trans.dispo_salida!=dispo_entrada_overflow) begin
                     trans_send = new;
                     trans_send.num_transacciones = instruccion_especifica.num_transacciones;
                     trans_send.dispo_salida = trans.dispo_salida;
                     trans_send.dispo_entrada = 10;
                     trans_send.modo=trans.modo;
                     trans_send.mensaje=trans.mensaje;
                     trans_send.tiempo_envio=$time;
                     agente_mbx.put(trans_send);
        			 ->generador_listo;
                   //end
                 end
               end
             
        endcase
        end
      end
    endtask
endclass
