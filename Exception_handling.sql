Die Skripte demonstrieren, wie Ausnahmen (Exceptions) in PL/SQL behandelt werden können. Die Ausnahmen reichen von spezifischen Fehlern wie NO_DATA_FOUND und TOO_MANY_ROWS bis hin zur allgemeinen Ausnahmebehandlung mit WHEN OTHERS. Ich werde jedes Beispiel erklären.

1. Ausnahmebehandlung mit NO_DATA_FOUND
declare
  v_name varchar2(6);
begin
  select first_name into v_name from employees where employee_id = 50;
  dbms_output.put_line('Hello');
exception
  when no_data_found then
    dbms_output.put_line('There is no employee with the selected id');
end;
Erklärung:
Der Code versucht, den first_name des Mitarbeiters mit der employee_id = 50 in die Variable v_name zu speichern.
Falls kein solcher Mitarbeiter existiert, wird eine NO_DATA_FOUND-Exception ausgelöst.
Im EXCEPTION-Block wird die Ausnahme abgefangen, und eine benutzerdefinierte Fehlermeldung wird ausgegeben.

  
  
  2. Behandlung mehrerer Ausnahmen
declare
  v_name varchar2(6);
  v_department_name varchar2(100);
begin
  select first_name into v_name from employees where employee_id = 100;
  select department_id into v_department_name from employees where first_name = v_name;
  dbms_output.put_line('Hello '|| v_name || '. Your department id is : '|| v_department_name );
exception
  when no_data_found then
    dbms_output.put_line('There is no employee with the selected id');
  when too_many_rows then
    dbms_output.put_line('There are more than one employees with the name '|| v_name);
    dbms_output.put_line('Try with a different employee');
end;
Erklärung:
Zwei mögliche Fehler werden behandelt:
NO_DATA_FOUND: Wenn keine Zeile für die Abfrage gefunden wird.
TOO_MANY_ROWS: Wenn mehr als eine Zeile zurückgegeben wird (z. B. bei der zweiten Abfrage, wenn mehrere Mitarbeiter denselben first_name haben).
Jede Ausnahme hat eine spezifische Fehlermeldung.

  
  
  3. Verwendung von WHEN OTHERS
declare
  v_name varchar2(6);
  v_department_name varchar2(100);
begin
  select first_name into v_name from employees where employee_id = 103;
  select department_id into v_department_name from employees where first_name = v_name;
  dbms_output.put_line('Hello '|| v_name || '. Your department id is : '|| v_department_name );
exception
  when no_data_found then
    dbms_output.put_line('There is no employee with the selected id');
  when too_many_rows then
    dbms_output.put_line('There are more than one employees with the name '|| v_name);
    dbms_output.put_line('Try with a different employee');
  when others then
    dbms_output.put_line('An unexpected error happened. Connect with the programmer..');
end;
Erklärung:
Der WHEN OTHERS-Block behandelt alle Ausnahmen, die nicht explizit definiert wurden.
Dieser Block sollte sparsam und für unerwartete Fehler verwendet werden, um Debugging zu erleichtern.

  
  
  4. Verwendung von SQLCODE und SQLERRM
declare
  v_name varchar2(6);
  v_department_name varchar2(100);
begin
  select first_name into v_name from employees where employee_id = 103;
  select department_id into v_department_name from employees where first_name = v_name;
  dbms_output.put_line('Hello '|| v_name || '. Your department id is : '|| v_department_name );
exception
  when no_data_found then
    dbms_output.put_line('There is no employee with the selected id');
  when too_many_rows then
    dbms_output.put_line('There are more than one employees with the name '|| v_name);
    dbms_output.put_line('Try with a different employee');
  when others then
    dbms_output.put_line('An unexpected error happened. Connect with the programmer..');
    dbms_output.put_line(sqlcode || ' ---> '|| sqlerrm);
end;
Erklärung:
SQLCODE: Gibt den numerischen Fehlercode der Ausnahme zurück.
SQLERRM: Gibt die entsprechende Fehlermeldung als Text zurück.
Diese Details sind hilfreich für Debugging und Fehlermeldungen.

  
  
  5. Innerer Block mit spezifischer Ausnahmebehandlung
declare
  v_name varchar2(6);
  v_department_name varchar2(100);
begin
  select first_name into v_name from employees where employee_id = 100;
  begin
    select department_id into v_department_name from employees where first_name = v_name;
  exception
    when too_many_rows then
      v_department_name := 'Error in department_name';
  end;
  dbms_output.put_line('Hello '|| v_name || '. Your department id is : '|| v_department_name );
exception
  when no_data_found then
    dbms_output.put_line('There is no employee with the selected id');
  when too_many_rows then
    dbms_output.put_line('There are more than one employees with the name '|| v_name);
    dbms_output.put_line('Try with a different employee');
  when others then
    dbms_output.put_line('An unexpected error happened. Connect with the programmer..');
    dbms_output.put_line(sqlcode || ' ---> '|| sqlerrm);
end;
Erklärung:
Der innere Block behandelt spezifisch TOO_MANY_ROWS.
Im Falle eines Fehlers wird v_department_name auf einen Platzhalterwert gesetzt.
Der äußere Block behandelt andere Fehler global.
