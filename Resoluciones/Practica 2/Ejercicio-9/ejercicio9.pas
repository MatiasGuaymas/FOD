{9. Se necesita contabilizar los votos de las diferentes mesas electorales registradas por
provincia y localidad. Para ello, se posee un archivo con la siguiente información: código de
provincia, código de localidad, número de mesa y cantidad de votos en dicha mesa.
Presentar en pantalla un listado como se muestra a continuación:
Código de Provincia
Código de Localidad              Total de Votos
................................ ......................
................................ ......................
Total de Votos Provincia: ____
Código de Provincia
Código de Localidad              Total de Votos
................................ ......................
Total de Votos Provincia: ___
…………………………………………………………..
Total General de Votos: ___
NOTA: La información está ordenada por código de provincia y código de localidad.}

program ejercicio9;
const
    valoralto = 999;
type
    provincia = record
        codProv: integer;
        codLocalidad: integer;
        mesa: integer;
        cantVotos: integer;
    end;
    maestro = file of provincia;
procedure leer(var mae: maestro; var data: provincia);
begin
    if(not eof(mae)) then
        read(mae, data)
    else
        data.codProv:= valoralto;
end;
procedure corteDeControl(var mae: maestro);
var
    prov, actual: provincia;
    total, totalProvincia, totalLocalidad, provActual, localidadActual: integer;
begin
    reset(mae);
    leer(mae, prov);
    total:= 0;
    while(prov.codProv <> valoralto) do
        begin
            writeln();
            writeln('CodigoProv: ', prov.codProv);
            totalProvincia:= 0;
            provActual:= prov.codProv;
            while(provActual = prov.codProv) do //Misma provincia
                begin
                    writeln('CodigoLocalidad           Total de Votos');
                    localidadActual:= prov.codLocalidad;
                    totalLocalidad:= 0;
                    while((provActual = prov.codProv) and (localidadActual = prov.codLocalidad)) do //Misma localidad
                        begin
                            totalLocalidad:= totalLocalidad + prov.cantVotos;
                            leer(mae, prov);
                        end;
                    writeln(localidadActual, '                             ', totalLocalidad);
                    totalProvincia:= totalProvincia + totalLocalidad;
                end;
            writeln('Total de votos Provincia: ', totalProvincia);
            total:= total + totalProvincia;
        end;
    writeln();
    writeln('Total General de Votos: ', total);
    close(mae);
end;
procedure crearMaestro(var mae: maestro; var carga: text);
var
    nombre: string;
    infoMae: provincia;
begin
    reset(carga);
    writeln('Ingrese un nombre para el archivo maestro');
    readln(nombre);
    assign(mae, nombre);
    rewrite(mae);
    while(not eof(carga)) do
        begin
            with infoMae do
                begin
                    readln(carga, codProv, codLocalidad, mesa, cantVotos);
                    write(mae, infoMae);
                end;
        end;
    writeln('Archivo binario maestro creado');
    close(mae);
    close(carga);
end;
var
    mae: maestro;
    cargaMae: text;
begin
    assign(cargaMae, 'maestro.txt');
    crearMaestro(mae, cargaMae);
    corteDeControl(mae);
end.