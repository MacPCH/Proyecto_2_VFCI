//INSTITUTO TECNOLÓGICO DE COSTA RICA
//VERIFICACIÓN FUNCIONAL DE CIRCUITOS INTEGRADOS
//Proyecto 2
//Lenguaje: SystemVerilog
//Creado por: Mac Alfred Pinnock Chacón (mcalfred32@gmail.com)

// Generador
class Generador #(parameter pckg_sz,ROWS,COLUMS);
    event generador_listo;
    mailbox agente_mbx; 
  	comando_test_generador_mbx test_generador_mbx;
    tipos_de_transacciones instruccion_especifica = new();  
  	la_mama_de_las_transacciones #(.pckg_sz(pckg_sz),.ROWS(ROWS),.COLUMS(COLUMS)) trans_send;
  
    task run();
      $display ("El generador fue inicializado");
      forever begin
      #1
        if(test_generador_mbx.num() > 0)begin
      
      test_generador_mbx.try_get(instruccion_especifica);
      $display("Que hay aqui: %s", instruccion_especifica.tipo);	
      
  
        case(instruccion_especifica.tipo)
            ordenado:
              begin
                $display ("Generador: Se ha escogido la transaccion ordenada para el agente");
                for (int i=0; i<ROWS*COLUMS; i++) begin
                  la_mama_de_las_transacciones #(.pckg_sz(pckg_sz),.ROWS(ROWS),.COLUMS(COLUMS)) trans = new; // crea una nueva transacción
                  trans.randomize();
                  for (int h=0; h<=trans.delay*100;h++) begin
                    #1;
                  end
                  trans_send = new;
                  trans_send.dispo_salida=trans.dispo_salida;
                  trans_send.dispo_entrada=i;
                  trans_send.modo=trans.modo;
                  trans_send.mensaje=trans.mensaje;
                  trans_send.tiempo_envio=$time;
                  
                  
                  agente_mbx.put(trans_send);
        		  ->generador_listo;
                end
                $display (" ||  ||  ||  ||  ||  ||  ||  ||  ||  || ");
                $display (" ||  ||  ||  ||  ||  ||  ||  ||  ||  || ");
                $display (" \\/  \\/  \\/  \\/  \\/  \\/  \\/  \\/  \\/  \\/");
                $display ("t = %0t Generador: Generadas las %0d transacciones", $time, ROWS*COLUMS);
                $display (" /\\  /\\  /\\  /\\  /\\  /\\  /\\  /\\  /\\  /\\");
                $display (" ||  ||  ||  ||  ||  ||  ||  ||  ||  || ");
                $display (" ||  ||  ||  ||  ||  ||  ||  ||  ||  || ");
              end
              
            
          aleatorio:
              begin
                $display ("Generador: Se ha escogido la transaccion aleatoria para el agente");
                for (int i=0; i< instruccion_especifica.num_transacciones; i++) begin 
                  la_mama_de_las_transacciones #(.pckg_sz(pckg_sz),.ROWS(ROWS),.COLUMS(COLUMS)) trans = new;
                  trans.randomize();
                  for (int h=0; h<=trans.delay*100;h++) begin
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
            esquina:
              begin 
                case(instruccion_especifica.esquina)
                  fila_primero:
                    begin
                      $display("Generador: El caso de esquina es: %s", instruccion_especifica.esquina);
                      for (int i=0; i< instruccion_especifica.num_transacciones; i++) begin
                      la_mama_de_las_transacciones #(.pckg_sz(pckg_sz),.ROWS(ROWS),.COLUMS(COLUMS)) trans = new;
                      trans.randomize();
                      trans.mensaje={pckg_sz-17{1'b0}};
                      for (int h=0; h<=trans.delay*50;h++) begin
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
                  columna_primero:
                    begin
                      $display("Generador: El caso de esquina es: %s", instruccion_especifica.esquina);
                      for (int i=0; i< instruccion_especifica.num_transacciones; i++) begin
                      la_mama_de_las_transacciones #(.pckg_sz(pckg_sz),.ROWS(ROWS),.COLUMS(COLUMS)) trans = new;
                      trans.randomize();
                      trans.mensaje={pckg_sz-17{1'b0}};
                      for (int h=0; h<=trans.delay*50;h++) begin
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
                  error:
                    begin
                      $display("Generador: El caso de esquina es: %s", instruccion_especifica.esquina);
                    end
                  destino_igual_origen:
                    begin
                      $display("Generador: El caso de esquina es: %s", instruccion_especifica.esquina);
                      for (int i=0; i< instruccion_especifica.num_transacciones; i++) begin
                      la_mama_de_las_transacciones #(.pckg_sz(pckg_sz),.ROWS(ROWS),.COLUMS(COLUMS)) trans = new;
                      trans.randomize();
                      for (int h=0; h<=trans.delay*50;h++) begin
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
                
                
                /*
                repeat(16) begin 
                  trans.randomize();
                  trans.mensaje={pckg_sz-17{1'b0}};
                  for (int h=0; h<=trans.delay*50;h++) begin
                    #1;
                  end
                  trans_send = new;
                  trans_send.dispo_salida=trans.dispo_salida;
                  trans_send.dispo_entrada=trans.dispo_entrada;
                  trans_send.modo=trans.modo;
                  trans_send.mensaje=trans.mensaje;
                  trans_send.tiempo_envio=$time;
                  agente_mbx.put(trans_send);
        			    ->generador_listo;
                end
                
                repeat(16) begin 
                  trans.randomize();
                  trans.mensaje={pckg_sz-17{1'b1}};
                  for (int h=0; h<=trans.delay*50;h++) begin 
                    #1;
                  end
                  trans_send = new;
                  trans_send.dispo_salida=trans.dispo_salida;
                  trans_send.dispo_entrada=trans.dispo_entrada;
                  trans_send.modo=trans.modo;
                  trans_send.mensaje=trans.mensaje;
                  trans_send.tiempo_envio=$time;
                  agente_mbx.put(trans_send); 
        			    ->generador_listo;
                end
  
                repeat(16) begin
                  trans.randomize();
                  for (int i=0; i<pckg_sz-18; i++) 
                    begin
                      if (i%2==0) trans.mensaje[i]=0;
                      else trans.mensaje[i]=1;
                    end
                  for (int h=0; h<=trans.delay*50;h++) begin
                    #1;
                  end
                  trans_send = new;
                  trans_send.dispo_salida=trans.dispo_salida;
                  trans_send.dispo_entrada=trans.dispo_entrada;
                  trans_send.modo=trans.modo;
                  trans_send.mensaje=trans.mensaje;
                  trans_send.tiempo_envio=$time; 
                  agente_mbx.put(trans_send);
        			    ->generador_listo;
                  end

                repeat(16) begin 
                  trans.randomize();
                  for (int i=0; i<pckg_sz-18; i++) 
                    begin
                      if (i%2==0) trans.mensaje[i]=1;
                      else trans.mensaje[i]=0;
                    end
                  for (int h=0; h<=trans.delay*50;h++) begin 
                      #1;
                    end
                  trans_send = new;
                    trans_send.dispo_salida=trans.dispo_salida;
                    trans_send.dispo_entrada=trans.dispo_entrada;
                    trans_send.modo=trans.modo;
                    trans_send.mensaje=trans.mensaje;
                    trans_send.tiempo_envio=$time;
                    agente_mbx.put(trans_send);
        			      ->generador_listo;
                  end*/
                end


             overflow: 
               begin
                 int dispo_entrada_overflow;
                 dispo_entrada_overflow=$urandom_range(0,15);
                 for (int i=0; i<instruccion_especifica.num_transacciones; i++) begin 
                  la_mama_de_las_transacciones #(.pckg_sz(pckg_sz),.ROWS(ROWS),.COLUMS(COLUMS)) trans = new;
                  trans.randomize();
                  for (int h=0; h<=trans.delay;h++) begin
                    #1;
                  end
                   if (trans.dispo_salida!=dispo_entrada_overflow) begin
                     trans_send = new;
                     trans_send.num_transacciones = instruccion_especifica.num_transacciones;
                     trans_send.dispo_salida=trans.dispo_salida;
                     trans_send.dispo_entrada=dispo_entrada_overflow;
                     trans_send.modo=trans.modo;
                     trans_send.mensaje=trans.mensaje;
                     trans_send.tiempo_envio=$time;
                     agente_mbx.put(trans_send);
        			 ->generador_listo;
                   end
                 end
               end
             
        endcase
        end
      end
    endtask
endclass