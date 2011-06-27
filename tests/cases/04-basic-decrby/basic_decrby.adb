--
--  Test program to execute a `Redis.Incr` operation
--

with Ada.Command_Line,
     Ada.Text_IO,
     Redis;

procedure Basic_DecrBy is
    use Ada.Text_IO;

    package CLI renames Ada.Command_Line;
    Conn : Redis.Connection;
begin
    declare
    begin
        Redis.Connect ("localhost", 6379, Conn);
        Conn.DecrBy ("simplekey", 2);
    exception
        when Error: others =>
            CLI.Set_Exit_Status (1);
    end;
    CLI.Set_Exit_Status (0);
end Basic_DecrBy;
