program parcial;
const
    valoralto = 'ZZZ';
type
    infoArchivo = record
        razon: string;
        genero: string;
        nombre: string;
        precio: real;
        cantidad: integer;
    end;
    archivo = file of infoArchivo;
procedure leer(var a: archivo; var info: infoArchivo);
begin
    if(not eof(a)) then
        read(a, info)
    else
        info.razon:= valoralto;
end;
procedure corteDeControl(var a: archivo);
var
    info: infoArchivo;
    montoTotal, montoRazon, montoGenero, precio: real;
    razonActual, generoActual, libroActual: string;
    cantActual: integer;
begin
    reset(a);
    leer(a, info);
    montoTotal:= 0;
    while(info.razon <> valoralto) do
        begin
            writeln('Libreria ', info.razon);
            razonActual:= info.razon;
            montoRazon:= 0;
            while(info.razon = razonActual) do
                begin
                    writeln('Genero ', info.genero);
                    generoActual:= info.genero;
                    montoGenero:= 0;
                    while((info.razon = razonActual) and (info.genero = generoActual)) do
                        begin
                            writeln('Nombre de libro: ', info.nombre);
                            libroActual:= info.nombre;
                            precio:= info.precio;
                            cantActual:= 0;
                            while((info.razon = razonActual) and (info.genero = generoActual) and (info.nombre = libroActual)) do
                                begin
                                    cantActual:= cantActual + info.cantidad;
                                    leer(a, info);
                                end;
                            writeln('Total vendido del libro ', libroActual, ': ', cantActual);
                            montoGenero:= montoGenero + cantActual * precio;
                        end;
                    writeln('Monto vendido genero ', generoActual, ': ', montoGenero:0:2);
                    montoRazon:= montoRazon + montoGenero;
                end;
            writeln('Monto vendido liberia ', razonActual, ': ', montoRazon:0:2);
            montoTotal:= montoTotal + montoRazon;
        end;
    writeln('Monto total librerias: ', montoTotal:0:2);
    close(a);
end;
procedure cargarArchivo(var a: archivo);
var
    txt: text;
    info: infoArchivo;
begin
    assign(txt, 'libros.txt');
    reset(txt);
    assign(a, 'ArchivoMaestro');
    rewrite(a);
    while(not eof(txt)) do
        begin
            readln(txt, info.cantidad, info.precio, info.razon);
            readln(txt, info.genero);
            readln(txt, info.nombre);
            write(a, info);
        end;
    close(txt);
    close(a);
end;
var
    a: archivo;
begin
    cargarArchivo(a);
    corteDeControl(a);
end.