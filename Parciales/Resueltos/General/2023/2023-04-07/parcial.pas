program parcial;
const
    valoralto = 9999;
type
    infoArchivo = record
        codigoEquipo: integer;
        nombre: string;
        anio: integer;
        codigoTorneo: integer;
        codigoRival: integer;
        golesFavor: integer;
        golesContra: integer;
        puntos: integer;
    end;
    archivo = file of infoArchivo;
procedure leer(var a: archivo; var e: infoArchivo);
begin
    if(not eof(a)) then
        read(a, e)
    else
        e.anio:= valoralto;
end;
procedure maximo(nom: string; cant: integer; var nomMax: string; var max: integer);
begin
    if(cant > max) then
        begin
            max:= cant;
            nomMax:= nom;
        end;
end;
procedure corteDeControl(var a: archivo);
var
    e: infoArchivo;
    anioActual, torneoActual, max, equipoActual, cantFavor, cantContra, ganados, perdidos, empatados: integer;
    nombreActual, nombreMax: string;
begin
    reset(a);
    leer(a, e);
    while(e.anio <> valoralto) do
        begin
            writeln('Anio ', e.anio);
            anioActual:= e.anio;
            while(e.anio = anioActual) do
                begin
                    writeln('cod_torneo ', e.codigoTorneo);
                    torneoActual:= e.codigoTorneo;
                    max:= -1;
                    nombreMax:= '';
                    while((e.anio = anioActual) and (e.codigoTorneo = torneoActual)) do
                        begin
                            writeln('cod_equipo ', e.codigoEquipo, ' nombre equipo ', e.nombre);
                            nombreActual:= e.nombre;
                            equipoActual:= e.codigoEquipo;
                            cantFavor:= 0;
                            cantContra:= 0;
                            ganados:= 0;
                            empatados:= 0;
                            perdidos:= 0;
                            while((e.anio = anioActual) and (e.codigoTorneo = torneoActual) and (e.codigoEquipo = equipoActual)) do
                                begin
                                    cantFavor:= cantFavor + e.golesFavor;
                                    cantContra:= cantContra + e.golesContra;
                                    case e.puntos of
                                        0: perdidos:= perdidos + 1;
                                        1: empatados:= empatados + 1;
                                        3: ganados:= ganados + 1;
                                    end;
                                    leer(a, e);
                                end;
                            writeln('cantidad total de goles a favor equipo ', equipoActual, ' ', cantFavor);
                            writeln('cantidad total de goles a en contra equipo ', equipoActual, ' ', cantContra);
                            writeln('diferencia de gol (resta de goles a favor - goles en contra) equipo ', equipoActual, ' ', cantFavor-cantContra);
                            writeln('cantidad de partidos ganados equipo ', equipoActual, ' ', ganados);
                            writeln('cantidad de partidos perdidos equipo ', equipoActual, ' ', perdidos);
                            writeln('cantidad de partidos empatados equipo ', equipoActual, ' ', empatados);
                            writeln('cantidad total de puntos en el torneo equipo ', equipoActual, ' ', empatados + ganados * 3);
                            writeln('---------------------------------');
                            maximo(nombreActual, empatados + ganados * 3, nombreMax, max);
                        end;
                    writeln('El equipo ', nombreMax, ' fue campeon del torneo codigo de torneo ', torneoActual, ' anio ', anioActual);
                    writeln('--------------------------------------------------');
                end;
            writeln('--------------------------------------------------');
        end;
    close(a);
end;
procedure cargarArchivo(var a: archivo);
var
    p: infoArchivo;
    txt: text;
begin
    assign(txt, 'partidos.txt');
    reset(txt);
    assign(a, 'Archivo');
    rewrite(a);
    while(not eof(txt)) do
        begin
            readln(txt, p.anio, p.codigoTorneo, p.codigoEquipo, p.codigoRival, p.golesFavor, p.golesContra, p.puntos, p.nombre);
            write(a, p);
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