//INSTITUTO TECNOLÓGICO DE COSTA RICA
//VERIFICACIÓN FUNCIONAL DE CIRCUITOS INTEGRADOS
//Proyecto 2
//Lenguaje: SystemVerilog
//Creado por: Mac Alfred Pinnock Chacón (mcalfred32@gmail.com)

//**************DEFINICION DE TIPOS DE TRANSACCION**************************
typedef enum {ordenado, esquina, aleatorio, overflow} tipos_trans;//definir los casos de generación del test

//**************DEFINICION DE LOS CASOS DE ESQUINA**************************
typedef enum {fila_primero, columna_primero, error, destino_igual_origen} caso_esquina;//definicion los casos de generación esquina del test

//**************DEFINICION DE LOS TIPOS DE REPORTES**************************
typedef enum {retraso_total, retraso_dispositivo, ancho_banda} tipos_reportes; //definicion los casos de generación del test

// Se establece la interfaz con el mesh del DUT
interface mesh_if #(parameter pckg_sz,ROWS,COLUMS)(input bit clk, input bit reset); 
    logic pndng[ROWS*2+COLUMS*2];
    logic [pckg_sz-1:0] data_out[ROWS*2+COLUMS*2];
    logic popin[ROWS*2+COLUMS*2];
    logic pop[ROWS*2+COLUMS*2];
    logic [pckg_sz-1:0]data_out_i_in[ROWS*2+COLUMS*2];
    logic pndng_i_in[ROWS*2+COLUMS*2];
endinterface

//Clase utilziada para sobrellevar los datos en los mailboxes desde el generador y otras instancias de la prueba 
class la_mama_de_las_transacciones #(parameter pckg_sz, ROWS,  COLUMS);
  	int num_transacciones;  //define el numero de transacciones que recibira cada transaccion
  	bit [pckg_sz-9:0] data; //
  	rand bit [3:0] dispo_salida; // dispositivo de salida del mesh
  	rand bit [3:0] dispo_entrada; // dispositivo de entrada del mesh
    bit modo; // tipo del modo ya sea fila o columna
    rand bit [pckg_sz-18:0] mensaje; //dato que se envia a las fifos
    rand bit [pckg_sz-1:0] empaquetado; //transaccion completa que entra al DUT
    rand bit [2:0] retraso; // se define el tiempo de retraso que va a tener el envio del mensaje desde el generador 
  	int tiempo_envio; // coleccion de variables para rescatra los tiempos de las transacciones para el reporte 
  	int tiempo_llegada;
  
  constraint pay_load {}
  	
endclass


class tipos_de_transacciones; // clase usada para establecer la conexion del test con el generador para recibir instruccione por un mailbos
  tipos_trans tipo; // valor por default
  int num_transacciones;
  caso_esquina esquina;
  tipos_reportes reportes;
endclass

class tipos_de_reportes; //clase usada por el test para pedir los reportes de las pruebas 
  int num_transacciones;
  int num_reportes;
  int profundidad_fifo;
  int fin_prueba;
endclass

// definicion de los tipos para los mailboxes que conectan al test con el generador y checker y que son empleados asi
// debido a la concepcion del tipo de prueba y la defincion del ambiente
typedef mailbox #(tipos_de_transacciones) comando_test_generador_mbx;
typedef mailbox #(tipos_de_reportes) comando_test_checker_mbx;
