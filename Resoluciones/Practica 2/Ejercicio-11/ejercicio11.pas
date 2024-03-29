{11. La empresa de software ‘X’ posee un servidor web donde se encuentra alojado el sitio web
de la organización. En dicho servidor, se almacenan en un archivo todos los accesos que se
realizan al sitio. La información que se almacena en el archivo es la siguiente: año, mes, día,
idUsuario y tiempo de acceso al sitio de la organización. El archivo se encuentra ordenado
por los siguientes criterios: año, mes, día e idUsuario.
Se debe realizar un procedimiento que genere un informe en pantalla, para ello se indicará
el año calendario sobre el cual debe realizar el informe. El mismo debe respetar el formato
mostrado a continuación:
Año : ---
    Mes:-- 1
        día:-- 1
            idUsuario 1 Tiempo Total de acceso en el dia 1 mes 1
            --------
            idusuario N Tiempo total de acceso en el dia 1 mes 1
        Tiempo total acceso dia 1 mes 1
        -------------
        día N
            idUsuario 1 Tiempo Total de acceso en el dia N mes 1
            --------
            idusuario N Tiempo total de acceso en el dia N mes 1
        Tiempo total acceso dia N mes 1
    Total tiempo de acceso mes 1
        ------
    Mes 12
        día 1
            idUsuario 1 Tiempo Total de acceso en el dia 1 mes 12
            --------
            idusuario N Tiempo total de acceso en el dia 1 mes 12
        Tiempo total acceso dia 1 mes 12
        -------------
        día N
            idUsuario 1 Tiempo Total de acceso en el dia N mes 12
            --------
            idusuario N Tiempo total de acceso en el dia N mes 12
        Tiempo total acceso dia N mes 12
    Total tiempo de acceso mes 12
Total tiempo de acceso año
Se deberá tener en cuenta las siguientes aclaraciones:
● El año sobre el cual realizará el informe de accesos debe leerse desde el teclado.● El año puede no existir en el archivo, en tal caso, debe informarse en pantalla “año
no encontrado”.
● Debe definir las estructuras de datos necesarias.
● El recorrido del archivo debe realizarse una única vez procesando sólo la información
necesaria.}

program ejercicio11;
const
    valoralto = 9999;
type
    usuario = record  
        anio: integer;
        mes: integer;
        dia: integer;
        id: integer;
        tiempo: real;
    end;
    maestro = file of usuario;
procedure crearMaestro(var mae: maestro);
var
    carga: text;
    nombre: string;
    infoMae: usuario;
begin
    assign(carga, 'usuarios.txt');
    reset(carga);
    writeln('Ingrese un nombre para el archivo maestro');
    readln(nombre);
    assign(mae, nombre);
    rewrite(mae);
    while(not eof(carga)) do
        begin
            with infoMae do
                begin
                    readln(carga, anio, mes, dia, id, tiempo);
                    write(mae, infoMae);
                end;
        end;
    writeln('Archivo binario maestro creado');
    close(mae);
    close(carga);
end;
procedure leer(var mae: maestro; var usu: usuario);
begin
    if(not eof(mae)) then
        read(mae, usu)
    else
        usu.anio:= valoralto;
end;
procedure corteDeControl(var mae: maestro);
var
    usu: usuario;
    anio, mesActual, diaActual, idActual: integer;
    tiempoAnio, tiempoMes, tiempoDia, tiempoUsuario: real;
begin
    writeln('Ingrese el anio el cual se realizara el informe');
    readln(anio);
    reset(mae);
    leer(mae, usu);
    if(usu.anio <> valoralto) then
        begin
            while(usu.anio <> valoralto) and (usu.anio < anio) do
                leer(mae, usu);
            if(usu.anio = anio) then
                begin
                    tiempoAnio:= 0;
                    writeln('Anio: ', usu.anio);
                    while(anio = usu.anio) do
                        begin
                            mesActual:= usu.mes;
                            tiempoMes:= 0;
                            writeln('-------------------------------');
                            writeln('Mes: ', usu.mes);
                            while((anio = usu.anio) and (usu.mes = mesActual)) do
                                begin
                                    diaActual:= usu.dia;
                                    tiempoDia:= 0;
                                    writeln();
                                    writeln('Dia ', usu.dia);
                                    while((anio = usu.anio) and (usu.mes = mesActual) and (diaActual = usu.dia)) do
                                        begin
                                            idActual:= usu.id;
                                            tiempoUsuario:= 0;
                                            while((anio = usu.anio) and (usu.mes = mesActual) and (diaActual = usu.dia) and (idActual = usu.id)) do
                                                begin
                                                    tiempoUsuario:= tiempoUsuario + usu.tiempo;
                                                    leer(mae, usu);
                                                end;
                                            writeln('idUsuario ', idActual, ' Tiempo total de acceso en el dia ', diaActual, ' del mes ', mesActual, ': ', tiempoUsuario:0:2);
                                            tiempoDia:= tiempoDia + tiempoUsuario;
                                        end;
                                    writeln('Tiempo total acceso dia ', diaActual, ' mes ', mesActual, ': ', tiempoDia:0:2);
                                    tiempoMes:= tiempoMes + tiempoDia;
                                end;
                            writeln();
                            writeln('Total tiempo de acceso de mes ', mesActual, ': ', tiempoMes:0:2);
                            tiempoAnio:= tiempoAnio + tiempoMes;
                        end;
                    writeln('-------------------------------');
                    writeln('Total tiempo de acceso anio: ', tiempoAnio:0:2);
                end
            else
                writeln('Anio no encontrado');
        end;
    close(mae);
end;
var
    mae: maestro;
begin
    crearMaestro(mae);
    corteDeControl(mae);
end.