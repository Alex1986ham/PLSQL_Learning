1. Berechtigungen (GRANT-Befehle):
grant create session to my_user;
Gibt dem Benutzer my_user die Berechtigung, sich bei der Datenbank anzumelden.
grant select any table to my_user;
Erlaubt my_user, jede Tabelle in der Datenbank zu lesen.
grant update on hr.employees_copy to my_user;
Gestattet my_user, Daten in der Tabelle employees_copy zu aktualisieren.
grant update on hr.departments to my_user;
Gestattet my_user, Daten in der Tabelle departments zu aktualisieren.


2. Optionen für Zeilensperren in Cursor-Deklarationen:
Diese Optionen betreffen, wie die Datenbank Zeilensperren verarbeitet, während ein Cursor geöffnet ist:

a. Kein expliziter WAIT oder NOWAIT:

declare
  cursor c_emps is select employee_id, first_name, last_name, department_name
      from employees_copy join departments using (department_id)
      where employee_id in (100, 101, 102)
      for update;
begin
  open c_emps;
end;
Standardverhalten:
Die Datenbank wartet unbegrenzt, wenn eine andere Transaktion die Zeilen gesperrt hat. Es gibt keine Zeitbeschränkung für die Sperre.



b. Mit WAIT-Option:

declare
  cursor c_emps is select employee_id, first_name, last_name, department_name
      from employees_copy join departments using (department_id)
      where employee_id in (100, 101, 102)
      for update of employees_copy.phone_number, departments.location_id wait 5;
begin
  open c_emps;
end;
Spezifisches Verhalten:
Die Datenbank wartet bis zu 5 Sekunden, falls eine andere Transaktion die Zeilen sperrt.
Wenn die Sperre nach 5 Sekunden nicht aufgehoben wird, gibt die Datenbank einen Fehler zurück.



c. Mit NOWAIT-Option:

declare
  cursor c_emps is select employee_id, first_name, last_name, department_name
      from employees_copy join departments using (department_id)
      where employee_id in (100, 101, 102)
      for update of employees_copy.phone_number, departments.location_id nowait;
begin
  open c_emps;
end;
Spezifisches Verhalten:
Die Datenbank gibt sofort einen Fehler zurück, wenn die gewünschten Zeilen durch eine andere Transaktion gesperrt sind. Es wird nicht gewartet.
