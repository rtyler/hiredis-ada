--
--  Test program to execute a `Redis.Set` operation
--

with Ada.Command_Line,
     Ada.Text_IO,
     Redis;

use Ada.Text_IO;

procedure Basic_Set is
  package CLI renames Ada.Command_Line;
  Conn : Redis.Connection;
begin
    if CLI.Argument_Count /= 2 then
      Put_Line (">> I require *TWO* arguments: key value");
      CLI.Set_Exit_Status (1);
      return;
    end if;

    declare
    begin
        Redis.Connect ("localhost", 6379, Conn);
        Redis.Set (Conn, "simplekey", "simplevalue");
    exception
        when Error: others =>
            CLI.Set_Exit_Status (1);
    end;
    CLI.Set_Exit_Status (0);
end Basic_Set;
