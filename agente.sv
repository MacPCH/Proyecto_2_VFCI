//INSTITUTO TECNOLÓGICO DE COSTA RICA
//VERIFICACIÓN FUNCIONAL DE CIRCUITOS INTEGRADOS
//Proyecto 2
//Lenguaje: SystemVerilog
//Creado por: Mac Alfred Pinnock Chacón (mcalfred32@gmail.com)

class Agente #(pckg_sz,ROWS,COLUMS);  
  mailbox agente_mbx;
  mailbox driver_mbx;
  mailbox gen_mbx;
  mailbox checker_mbx;
  event agente_listo;
  event generador_listo;
  task run();
  int contador = 0;
    
    la_mama_de_las_transacciones #(.pckg_sz(pckg_sz),.ROWS(ROWS),.COLUMS(COLUMS)) trans=new; 
    $display ("El agente fue inicializado");
  forever begin
    @(generador_listo) begin
      if (agente_mbx.num() != 0) $display("t = %g: Agente: Recibida una orden desde el generador", $time);
       agente_mbx.get(trans);
      
    case(trans.dispo_entrada)
      // A partir de aquí se define la trama de datas que sigue el DUT para cada dispositivo
      // En el siguiente orden: Next Jump(8bits)->ROW(4 bits)-COLUMN(4 bits)->MODO(1 bit)->Payload (n bits)
      0: 
        trans.empaquetado={{8'b0},{4'b0},{4'b0001},trans.modo,trans.mensaje};
      1:
        trans.empaquetado={{8'b0}, {4'b0},{4'b0010},trans.modo,trans.mensaje};
      2:
        trans.empaquetado={{8'b0},{4'b0},{4'b11},trans.modo,trans.mensaje};
      3:
        trans.empaquetado={{8'b0},{4'b0},{4'b100},trans.modo,trans.mensaje};
      4:
        trans.empaquetado={{8'b0},{4'b1},{4'b0},trans.modo,trans.mensaje};
      5:
        trans.empaquetado={{8'b0},{4'b10},{4'b0},trans.modo,trans.mensaje};
      6:
        trans.empaquetado={{8'b0},{4'b11},{4'b0},trans.modo,trans.mensaje};
      7:
        trans.empaquetado={{8'b0},{4'b100},{4'b0},trans.modo,trans.mensaje};
      8:
        trans.empaquetado={{8'b0},{4'b101},{4'b1},trans.modo,trans.mensaje};
      9:
        trans.empaquetado={{8'b0},{4'b101},{4'b10},trans.modo,trans.mensaje};
      10:
        trans.empaquetado={{8'b0},{4'b101},{4'b11},trans.modo,trans.mensaje};
      11:
        trans.empaquetado={{8'b0},{4'b101},{4'b100},trans.modo,trans.mensaje};
      12:
        trans.empaquetado={{8'b0},{4'b1},{4'b101},trans.modo,trans.mensaje};
      13:
        trans.empaquetado={{8'b0},{4'b10},{4'b101},trans.modo,trans.mensaje};
      14:
        trans.empaquetado={{8'b0},{4'b11},{4'b101},trans.modo,trans.mensaje};
      15:
        trans.empaquetado={{8'b0},{4'b100},{4'b101},trans.modo,trans.mensaje};
 		  default:
        trans.empaquetado={{8'b0},{4'b1},{4'b1},{1'b0},trans.mensaje};
      endcase
      trans.tiempo_envio=$time;
      driver_mbx.put(trans);
      checker_mbx.put(trans);
      $display("t = %g: Agente: Enviada la transaccion a el driver y checker, fila=  dato= %0d", $time,trans.empaquetado);
      contador++;
      $display("t = %g: Agente: Enviada la transaccion %0d de %0d", $time, contador, trans.num_transacciones);
      if (contador == trans.num_transacciones) begin
      	->agente_listo;
        contador = 0;
        //$display("Agente: Agente listo");
      end
      
      end
    end
  endtask
 endclass

