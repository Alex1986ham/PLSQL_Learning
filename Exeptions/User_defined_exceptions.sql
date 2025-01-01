1. Benutzerdefinierte Ausnahme (too_high_salary)
declare
  too_high_salary exception; -- Benutzerdefinierte Ausnahme
  v_salary_check pls_integer; -- Variable zum Speichern des Gehalts
begin
  select salary into v_salary_check from employees where employee_id = 100; -- Abfrage des Gehalts
  if v_salary_check > 20000 then
    raise too_high_salary; -- Ausnahme wird ausgelöst, wenn Gehalt zu hoch ist
  end if;
  dbms_output.put_line('The salary is in an acceptable range'); -- Wird ausgegeben, wenn Gehalt akzeptabel ist
exception
  when too_high_salary then
    dbms_output.put_line('This salary is too high. You need to decrease it.'); -- Behandelt die Ausnahme
end;
Ablauf:

Definition einer benutzerdefinierten Ausnahme: Die Exception too_high_salary wird definiert.
Ausnahme auslösen: Mit RAISE too_high_salary wird die benutzerdefinierte Ausnahme ausgelöst, wenn das Gehalt über 20.000 liegt.
Behandlung der Ausnahme: Im EXCEPTION-Block wird die Ausnahme too_high_salary abgefangen und eine entsprechende Nachricht ausgegeben.
Vorteil:

Ermöglicht die Definition von spezifischen Geschäftslogik-Fehlern, die nicht durch vordefinierte Ausnahmen abgedeckt sind.

  
2. Vordefinierte Ausnahme (INVALID_NUMBER)
declare
  too_high_salary exception; -- Benutzerdefinierte Ausnahme (nicht verwendet)
  v_salary_check pls_integer; -- Variable zum Speichern des Gehalts
begin
  select salary into v_salary_check from employees where employee_id = 100; -- Abfrage des Gehalts
  if v_salary_check > 20000 then
    raise invalid_number; -- Vordefinierte Ausnahme wird ausgelöst
  end if;
  dbms_output.put_line('The salary is in an acceptable range'); -- Wird ausgegeben, wenn Gehalt akzeptabel ist
exception
  when invalid_number then
    dbms_output.put_line('This salary is too high. You need to decrease it.'); -- Behandelt die Ausnahme
end;
Ablauf:

Ausnahme auslösen: Die vordefinierte Ausnahme INVALID_NUMBER wird mit RAISE ausgelöst.
Behandlung der Ausnahme: Im EXCEPTION-Block wird INVALID_NUMBER abgefangen und eine Nachricht ausgegeben.
Bemerkung:

Die Verwendung einer vordefinierten Ausnahme ist hier nicht ideal, da INVALID_NUMBER normalerweise für Konvertierungsfehler verwendet wird. Es ist besser, benutzerdefinierte Ausnahmen zu nutzen, um spezifische Fehler zu behandeln.

  
  3. Ausnahme innerhalb des Handlers erneut auslösen
declare
  too_high_salary exception; -- Benutzerdefinierte Ausnahme (nicht verwendet)
  v_salary_check pls_integer; -- Variable zum Speichern des Gehalts
begin
  select salary into v_salary_check from employees where employee_id = 100; -- Abfrage des Gehalts
  if v_salary_check > 20000 then
    raise invalid_number; -- Vordefinierte Ausnahme wird ausgelöst
  end if;
  dbms_output.put_line('The salary is in an acceptable range'); -- Wird ausgegeben, wenn Gehalt akzeptabel ist
exception
  when invalid_number then
    dbms_output.put_line('This salary is too high. You need to decrease it.'); -- Behandelt die Ausnahme
    raise; -- Löst die Ausnahme erneut aus
end;
Ablauf:

Ausnahme auslösen: Wie im vorherigen Beispiel wird INVALID_NUMBER ausgelöst, wenn das Gehalt über 20.000 liegt.
Behandlung der Ausnahme: Die Ausnahme wird abgefangen und eine Nachricht ausgegeben.
Ausnahme erneut auslösen: Mit RAISE wird die Ausnahme erneut ausgelöst, damit sie an die aufrufende Umgebung weitergegeben wird.
Verwendungszweck:

Durch das erneute Auslösen der Ausnahme wird sie weiter propagiert, sodass andere Ebenen (z. B. aufrufende Prozeduren) sie behandeln können.
Zusammenfassung:
Benutzerdefinierte Ausnahmen erlauben die Definition spezifischer Fehler, die auf die Geschäftslogik zugeschnitten sind.
Vordefinierte Ausnahmen sollten mit Bedacht verwendet werden, um den eigentlichen Zweck nicht zu verfälschen.
Erneutes Auslösen einer Ausnahme ist nützlich, wenn eine Ausnahme sowohl lokal behandelt als auch an die aufrufende Umgebung weitergegeben werden soll.
