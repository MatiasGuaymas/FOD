{17. Se cuenta con un archivo con información de los casos de COVID-19 registrados en los
diferentes hospitales de la Provincia de Buenos Aires cada día. Dicho archivo contiene: código
de localidad, nombre de localidad, código de municipio, nombre de municipio, código de hospital,
nombre de hospital, fecha y cantidad de casos positivos detectados. El archivo está ordenado
por localidad, luego por municipio y luego por hospital.
Escriba la definición de las estructuras de datos necesarias y un procedimiento que haga un
listado con el siguiente formato:
Nombre: Localidad 1
    Nombre: Municipio 1
        Nombre Hospital 1…………….Cantidad de casos Hospital 1
        ……………………..
        Nombre Hospital N…………….Cantidad de casos Hospital N
    Cantidad de casos Municipio 1
    …………………………………………………………………….
    Nombre Municipio N
        Nombre Hospital 1……………..Cantidad de casos Hospital 1
        ……………………..
        NombreHospital N…………….Cantidad de casos Hospital N
    Cantidad de casos Municipio N
Cantidad de casos Localidad 1
-----------------------------------------------------------------------------------------
Nombre Localidad N
    Nombre Municipio 1
        Nombre Hospital 1……………..Cantidad de casos Hospital 1
        ……………………..
        Nombre Hospital N…………….Cantidad de casos Hospital N
    Cantidad de casos Municipio 1
    …………………………………………………………………….
    Nombre Municipio N
        Nombre Hospital 1……………..Cantidad de casos Hospital 1
        ……………………..
        Nombre Hospital N…………….Cantidad de casos Hospital N
    Cantidad de casos Municipio N
Cantidad de casos Localidad N    
Cantidad de casos Totales en la Provincia
Además del informe en pantalla anterior, es necesario exportar a un archivo de texto la siguiente
información: nombre de localidad, nombre de municipio y cantidad de casos del municipio, para
aquellos municipios cuya cantidad de casos supere los 1500. El formato del archivo de texto
deberá ser el adecuado para recuperar la información con la menor cantidad de lecturas
posibles.}

program ejercicio17;
const
    valoralto = 999;
type
    hospital = record
        localidad: integer;
        nombreLocalidad: string;
        municipio: integer;
        nombreMunicipio: string;
        hospital: integer;
        nombreHospital: string;
        fecha: string;
        casosPositivos: integer;
    end;
    maestro = file of hospital;
procedure crearMaestro(var mae: maestro);
var
    txt: text;
    hos: hospital;
    nombre: string;
begin
    assign(txt, 'hospitales.txt');
    reset(txt);
    writeln('Ingrese un nombre para el archivo maestro');
    readln(nombre);
    assign(mae, nombre);
    rewrite(mae);
    while(not eof(txt)) do
        begin
            with hos do
                begin
                    readln(txt, localidad, municipio, hospital, nombreLocalidad);
                    readln(txt, nombreMunicipio);
                    readln(txt, fecha);
                    readln(txt, casosPositivos, nombreHospital);
                    write(mae, hos);
                end;
        end;
    writeln('Archivo binario maestro creado');
    close(txt);
    close(mae);
end;
procedure leer(var mae: maestro; var data: hospital);
begin
    if(not eof(mae)) then
        read(mae, data)
    else
        data.localidad:= valoralto;
end;
procedure corteDeControl(var mae: maestro);
var
    hos: hospital;
    total, locActual, cantLocalidad, munActual, cantMunicipio, hosActual, cantHospital: integer;
    nomLocalidad, munNombre, hosNombre: string;
var
    txt: text;
begin
    assign(txt, 'municipiosMas1500Casos.txt');
    rewrite(txt);
    reset(mae);
    leer(mae, hos);
    total:= 0;
    while(hos.localidad <> valoralto) do
        begin
            nomLocalidad:= hos.nombreLocalidad;
            locActual:= hos.localidad;
            cantLocalidad:= 0;
            writeln('---------------------');
            writeln(nomLocalidad, ': Localidad ', hos.localidad);
            while(locActual = hos.localidad) do
                begin
                    munActual:= hos.municipio;
                    munNombre:= hos.nombreMunicipio;
                    cantMunicipio:= 0;
                    writeln();
                    writeln(munNombre, ': Municipio ', hos.municipio);
                    while(locActual = hos.localidad) and (munActual = hos.municipio) do
                        begin
                            hosActual:= hos.hospital;
                            hosNombre:= hos.nombreHospital;
                            cantHospital:= 0;
                            while(locActual = hos.localidad) and (munActual = hos.municipio) and (hosActual = hos.hospital) do
                                begin
                                    cantHospital:= cantHospital + hos.casosPositivos;
                                    leer(mae, hos);
                                end;
                            writeln(hosNombre, ' ', hosActual, ' Cantidad de casos Hospital ', hosActual, ': ', cantHospital);
                            cantMunicipio:= cantMunicipio + cantHospital;
                        end;
                    writeln('Cantidad de casos municipio ', munActual, ': ', cantMunicipio);
                    cantLocalidad:= cantLocalidad + cantMunicipio;
                    if(cantMunicipio > 1500) then
                        begin
                            writeln(txt, nomLocalidad);
                            writeln(txt, cantMunicipio,' ' ,munNombre);
                        end;
                end;
            writeln('Cantidad de casos localidad ', locActual, ': ', cantLocalidad);
            total:= total + cantLocalidad;
        end;
    writeln();
    writeln('Cantidad de casos totales en la provincia: ', total);
    close(mae);
    close(txt);
end;
var
    mae: maestro;
begin
    crearMaestro(mae);
    corteDeControl(mae);
end.
