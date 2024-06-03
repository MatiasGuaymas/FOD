program parcial;
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