class Delay_terminal;
  int num_transactions; 
  int delay=0;
  int delay_prom;
  int identifier; 
endclass

class Checker #(parameter pckg_sz,  ROWS,  COLUMS,  FIFO_depth);

    string mensaje, dispo_entrada, dispo_salida, tiempo_llegada, tsend, receive_delay,ID;
    string outputTXT_line, comma = ",";
    event agente_listo;
    event monitor_listo;
    bit [pckg_sz-9:0] data_in;
    time delays [$];
    int time_delay; 
    bit error;
    Delay_terminal delay_list [$];
  	la_mama_de_las_transacciones #(.pckg_sz(pckg_sz),.ROWS(ROWS),.COLUMS(COLUMS)) paquete;
    mailbox checker_mbx;
    mailbox monitor_mbx;
    int j=0; 

  la_mama_de_las_transacciones #(.pckg_sz(pckg_sz),.ROWS(ROWS),.COLUMS(COLUMS)) scb[$];

    task delay_terminal_prom(); 
      for (int i =0 ; i<=ROWS*COLUMS ; i++) begin
            Delay_terminal  delay_new= new();
            delay_new.identifier=i; 
            delay_new.num_transactions=0; 
            delay_new.delay=0; 
            delay_new.delay_prom=0; 
            delay_list.insert(i, delay_new); 
      end
    endtask

    task run(); 
      $display ("El checker fue inicializado");
        $system("echo ID,Tiempo_Envio[ns],Terminal_Procedencia,Dato,Tiempo_Recibido[ns],Terminal_Llegada,Retraso[ns] > reporte.txt");
        forever begin
          @(agente_listo) 
            begin
                la_mama_de_las_transacciones #(.pckg_sz(pckg_sz),.ROWS(ROWS),.COLUMS(COLUMS)) paquete1 = new();
                checker_mbx.get(paquete); 
                paquete1.dispo_salida= paquete.dispo_salida;
                paquete1.dispo_entrada=paquete.dispo_entrada;
                paquete1.modo=paquete.modo;
                paquete1.mensaje=paquete.mensaje;
                paquete1.empaquetado=paquete.empaquetado;
                paquete1.tiempo_envio=paquete.tiempo_envio;
                paquete1.tiempo_llegada=paquete.tiempo_llegada;
                scb.push_front(paquete1); 
            end
        end
    endtask
  
   task check(); 
   forever begin
     @(monitor_listo)
        begin
          la_mama_de_las_transacciones #(.pckg_sz(pckg_sz),.ROWS(ROWS),.COLUMS(COLUMS)) paquete_monitor=new();
            monitor_mbx.get(data_in);
            paquete_monitor.data=data_in;
            paquete_monitor.tiempo_llegada=$time;
      case(data_in [pckg_sz-9: pckg_sz-16])
        1:
          paquete_monitor.dispo_entrada=0;
        2:
          paquete_monitor.dispo_entrada=1;
        3:
          paquete_monitor.dispo_entrada=2;
        4:
         paquete_monitor.dispo_entrada=3;
        16:
          paquete_monitor.dispo_entrada=4;
        32:
         paquete_monitor.dispo_entrada=5;
        48:
          paquete_monitor.dispo_entrada=6;
        64:
         paquete_monitor.dispo_entrada=7;
        81:
          paquete_monitor.dispo_entrada=8;
        82: 
          paquete_monitor.dispo_entrada=9;
        83:
          paquete_monitor.dispo_entrada=10;
        84:
         paquete_monitor.dispo_entrada=11;
        21:
          paquete_monitor.dispo_entrada=12;
        37:
         paquete_monitor.dispo_entrada=13;
        53:
          paquete_monitor.dispo_entrada=14;
        69:
          paquete_monitor.dispo_entrada=15;
 		    default:
          paquete_monitor.dispo_entrada=16;

    endcase
            for (int i=0; i<scb.size(); i++) 
                begin
                    error=0; 
                    if (paquete_monitor.data==scb[i].empaquetado[pckg_sz-9:0]) 
                        begin
                          if (paquete_monitor.dispo_entrada==scb[i].dispo_entrada) 
                            begin
                            error=1; 
                            time_delay= paquete_monitor.tiempo_llegada-(scb[i].tiempo_envio);
                            delays.insert(j,time_delay);
                              $display("%0d: Checker: Dispositivo que llega del DUT: %d, dispositivo esperado: %d", $time, paquete_monitor.dispo_entrada, scb[i].dispo_entrada);
                              $display("%0d: Checker: Dato que llega del DUT: %d, dato esperado: %d", $time, paquete_monitor.data, scb[i].empaquetado[pckg_sz-9:0]);
                              $display("%0d: Checker: Todo bien, todo correcto y yo que me alegro", $time);
                              for (int k=0; k<16; k++) 
                              begin
                                if (k==scb[i].dispo_entrada)
                                  begin
                                  delay_list[k].delay=delay_list[k].delay+time_delay; 
                                  delay_list[k].num_transactions= delay_list[k].num_transactions+1; 
                                  end
                              end
                            mensaje.itoa(paquete_monitor.data);
                            dispo_entrada.itoa(paquete_monitor.dispo_entrada);
                            dispo_salida.itoa(scb[i].dispo_salida);
                            tiempo_llegada.itoa(paquete_monitor.tiempo_llegada);
                            tsend.itoa(scb[i].tiempo_envio);
                            receive_delay.itoa(time_delay);
                            ID.itoa(j);
                            
                            outputTXT_line = {ID,comma,tsend,comma,dispo_salida,comma,mensaje,comma,tiempo_llegada,comma,dispo_entrada,comma,receive_delay};
                            $system($sformatf("echo %0s >> reporte.txt",outputTXT_line));
                            break; 
                            error = 1;
                            end
                    else $fatal("EL DISPOSITIVO DE LLEGADA Y EL DESTINO DEL MENSAJE NO CONCUERDAN"); 
                end

                end
                j=j+1;
        end
     if (!error) $fatal("ERROR, EL DATO RECIBIDO POR EL DRIVER NO CORRESPONDE A NINGÚN DATO ENVIADO");
    end
  endtask
endclass
