Das Skript zeigt zwei Ansätze für den Umgang mit benutzerdefinierten Ausnahmen und deren Nutzung in Verbindung mit der RAISE_APPLICATION_ERROR-Prozedur. Diese Prozedur erlaubt es, benutzerdefinierte Fehlermeldungen mit spezifischen Fehlercodes zu erstellen. Hier die Analyse der beiden Abschnitte:

1. Auslösen eines benutzerdefinierten Fehlers mit RAISE_APPLICATION_ERROR
declare
  too_high_salary exception; -- Benutzerdefinierte Ausnahme
  v_salary_check pls_integer; -- Variable für das Gehalt
begin
  select salary into v_salary_check from employees where employee_id = 100; -- Gehalt abfragen
  if v_salary_check > 20000 then
    raise_application_error(-20243, 'The salary of the selected employee is too high!'); 
    -- Benutzerdefinierter Fehlercode (-20243) und Fehlermeldung
  end if;
  dbms_output.put_line('The salary is in an acceptable range'); -- Nachricht bei akzeptablem Gehalt
exception
  when too_high_salary then
    dbms_output.put_line('This salary is too high. You need to decrease it.'); -- Ausnahmebehandlung
end;
Analyse:

Fehlererzeugung mit RAISE_APPLICATION_ERROR:
Anstelle der Ausnahme too_high_salary wird direkt RAISE_APPLICATION_ERROR verwendet.
Der Fehlercode -20243 und die Fehlermeldung werden übergeben.
Dies ist nützlich, um benutzerdefinierte Fehlermeldungen mit Codes zu erstellen, die von der Anwendungslogik interpretiert werden können.
Kein Nutzen von too_high_salary:
Die definierte Ausnahme too_high_salary wird in diesem Fall nicht verwendet, was sie überflüssig macht.
RAISE_APPLICATION_ERROR übernimmt die Rolle der Fehlerauslösung und -meldung.
Einschränkung:
Die Ausnahme wird nicht separat behandelt, da sie direkt über RAISE_APPLICATION_ERROR an die aufrufende Umgebung weitergegeben wird.



  
2. Fehlerauslösung innerhalb des EXCEPTION-Abschnitts
declare
  too_high_salary exception; -- Benutzerdefinierte Ausnahme
  v_salary_check pls_integer; -- Variable für das Gehalt
begin
  select salary into v_salary_check from employees where employee_id = 100; -- Gehalt abfragen
  if v_salary_check > 20000 then
    raise too_high_salary; -- Benutzerdefinierte Ausnahme auslösen
  end if;
  dbms_output.put_line('The salary is in an acceptable range'); -- Nachricht bei akzeptablem Gehalt
exception
  when too_high_salary then
    dbms_output.put_line('This salary is too high. You need to decrease it.'); -- Ausnahmebehandlung
    raise_application_error(-1403, 'The salary of the selected employee is too high!', true); 
    -- Fehlercode -1403 (Reserviert für "NO_DATA_FOUND")
    -- `TRUE` ermöglicht das Einfügen in den Error-Stack
end;
Analyse:

Fehlererzeugung innerhalb der Ausnahmebehandlung:
Die Ausnahme too_high_salary wird im EXCEPTION-Block behandelt.
Nach der Verarbeitung wird erneut ein Fehler ausgelöst, diesmal mit RAISE_APPLICATION_ERROR.
Durch den Parameter TRUE bleibt der ursprüngliche Fehler im Error-Stack erhalten.
Kombination von benutzerdefinierten und Systemfehlern:
Zuerst wird eine benutzerdefinierte Ausnahme (too_high_salary) verwendet.
Im Exception-Handler wird RAISE_APPLICATION_ERROR aufgerufen, um die Fehlermeldung weiterzugeben.
Fehlercode beachten:
Der Code -1403 ist normalerweise für den Fehler NO_DATA_FOUND reserviert. Das Verwenden eines falschen oder reservierten Codes kann Verwirrung stiften.
Es ist empfehlenswert, für benutzerdefinierte Fehler immer einen Bereich von -20000 bis -20999 zu verwenden.
Vergleich der beiden Ansätze:
Merkmal	1. Ansatz	2. Ansatz
Fehlerauslösung	Direkt mit RAISE_APPLICATION_ERROR	Erst benutzerdefinierte Ausnahme, dann RAISE_APPLICATION_ERROR
Fehlercode	Benutzerdefiniert	Benutzerdefiniert, aber reservierter Code (-1403) verwendet
Flexibilität	Einfacher, aber keine Ausnahmebehandlung	Mehr Kontrolle durch Vorverarbeitung im EXCEPTION-Block
Empfehlung	Gut für einfache Fehlerlogik	Gut für komplexe Logik mit spezifischer Vorverarbeitung

  
Zusammenfassung:
1. Ansatz: Direktes Nutzen von RAISE_APPLICATION_ERROR ist effizient für einfache Szenarien. Eine benutzerdefinierte Ausnahme ist hier nicht nötig.
2. Ansatz: Die Kombination von benutzerdefinierten Ausnahmen und RAISE_APPLICATION_ERROR bietet mehr Flexibilität, ist aber komplexer. Achte darauf, gültige Fehlercodes im Bereich -20000 bis -20999 zu verwenden.






