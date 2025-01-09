Das gegebene Skript behandelt die Erstellung und Nutzung von benutzerdefinierten Objekttypen, geschachtelten Tabellen (Nested Tables) sowie regulären und pipelined Table Functions in PL/SQL. Es zeigt, wie Funktionen Tabellen zurückgeben und wie diese Abfragen verarbeitet werden können.

1. Erstellen eines benutzerdefinierten Objekttyps
CREATE TYPE t_day AS OBJECT (
  v_date DATE,
  v_day_number INT
);
Beschreibung

t_day ist ein benutzerdefinierter Objekttyp.
v_date: Ein Attribut vom Typ DATE, das ein Datum speichert.
v_day_number: Ein Attribut vom Typ INT, das die Tagesnummer im Jahr speichert (z. B. 1 für den 1. Januar).
Solche Objekttypen dienen dazu, Daten strukturiert darzustellen und zu speichern.

  
  2. Erstellen eines geschachtelten Tabellen-Typs
CREATE TYPE t_days_tab IS TABLE OF t_day;
Beschreibung

t_days_tab ist ein geschachtelter Tabellen-Typ (Nested Table).
Es handelt sich um eine Sammlung von t_day-Objekten.
Der Typ ermöglicht es, mehrere Objekte des Typs t_day als Tabelle zu behandeln.

  
  3. Erstellung einer regulären Table Function
CREATE OR REPLACE FUNCTION f_get_days(p_start_date DATE, p_day_number INT) 
              RETURN t_days_tab IS
  v_days t_days_tab := t_days_tab();
BEGIN
  FOR i IN 1 .. p_day_number LOOP
    v_days.EXTEND();
    v_days(i) := t_day(p_start_date + i, to_number(to_char(p_start_date + i, 'DDD')));
  END LOOP;
  RETURN v_days;
END;
Beschreibung

Parameter:
p_start_date: Startdatum.
p_day_number: Anzahl der Tage, die ab dem Startdatum berechnet werden sollen.
Rückgabewert:
Ein Objekt vom Typ t_days_tab (Tabelle mit Einträgen vom Typ t_day).
Funktionsweise:
Initialisiert die geschachtelte Tabelle v_days.
Führt eine Schleife von 1 bis p_day_number aus.
Für jeden Tag:
Fügt einen neuen Eintrag (t_day) in die Tabelle ein.
Berechnet das Datum (p_start_date + i) und die Tagesnummer (DDD aus dem Datum).
Gibt die Tabelle v_days zurück.
Abfragen der Funktion

Mit dem TABLE-Operator:
select * from table(f_get_days(sysdate, 1000000));
Wandelt die geschachtelte Tabelle in eine relationale Tabelle um, damit SQL sie direkt abfragen kann.
Gibt eine Ergebnismenge mit den Attributen v_date und v_day_number zurück.
Ohne den TABLE-Operator:
select * from f_get_days(sysdate, 1000000);
Ohne den TABLE-Operator funktioniert die Abfrage nur in PL/SQL-Umgebungen, die geschachtelte Tabellen direkt unterstützen.

  
  4. Erstellung einer Pipelined Table Function
create or replace function f_get_days_piped (p_start_date DATE, p_day_number INT) 
              RETURN t_days_tab PIPELINED IS
BEGIN
  FOR i IN 1 .. p_day_number LOOP
    PIPE ROW (t_day(p_start_date + i, to_number(to_char(p_start_date + i, 'DDD'))));
  END LOOP;
  RETURN;
END;
Beschreibung

Unterschied zu regulären Table Functions:
Bei einer pipelined Table Function wird jede Zeile (ein t_day-Objekt) direkt an die aufrufende SQL-Abfrage zurückgegeben.
Es wird kein kompletter t_days_tab-Typ als Ganzes zurückgegeben.
Funktionsweise:
Führt eine Schleife von 1 bis p_day_number aus.
Für jeden Tag:
Erzeugt ein t_day-Objekt.
Gibt dieses Objekt mit dem Befehl PIPE ROW zurück.
Nach der Schleife endet die Funktion mit RETURN.
Abfragen der Funktion

select * from f_get_days_piped(sysdate, 1000000);
Die Ergebnisse der PIPELINED-Funktion können direkt abgefragt werden, ohne den TABLE-Operator.
Das Ergebnis ähnelt der regulären Table Function, aber die Verarbeitung erfolgt Zeile für Zeile (pipelineartig), was effizienter ist, insbesondere bei großen Datenmengen.
Vergleich: Reguläre vs. Pipelined Table Function
Eigenschaft	Reguläre Table Function	Pipelined Table Function
Rückgabe	Gibt eine gesamte geschachtelte Tabelle zurück	Gibt Zeile für Zeile zurück (Pipeline)
Speicherbedarf	Höher (Speicherung aller Daten vor Rückgabe)	Geringer (datenstromartige Verarbeitung)
Performance	Weniger effizient bei großen Ergebnismengen	Effizient bei großen Ergebnismengen
Komplexität	Einfacher zu schreiben	Etwas komplexer durch PIPE ROW und Pipeline
Nutzung	Braucht häufig den TABLE-Operator	Kein TABLE-Operator erforderlich
Zusammenfassung
Der Objekttyp t_day und der Tabellen-Typ t_days_tab bieten eine strukturierte Möglichkeit, Datum und Tagesnummer zu speichern.
Die reguläre Table Function eignet sich für kleinere Datenmengen, bei denen die gesamte Tabelle in den Speicher geladen wird.
Die pipelined Table Function ist für große Datenmengen besser geeignet, da sie Ergebnisse schrittweise zurückgibt, was Speicher spart und die Verarbeitung beschleunigt.

