--
--  Test program to execute a `Redis.Set` operation
--

with Ada.Command_Line,
     Ada.Text_IO;

use Ada.Text_IO;

procedure Basic_Set is
  package CLI renames Ada.Command_Line;
begin
    if CLI.Argument_Count /= 2 then
      Put_Line(">> I require *TWO* arguments: key value");
      CLI.Set_Exit_Status(1);
      return;
    end if;

    CLI.Set_Exit_Status(0);
end Basic_Set;
