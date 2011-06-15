--
--
--

with Ada.Text_IO,
     System;

package body Redis is
    use Ada.Text_IO,
        Interfaces.C,
        Interfaces.C.Strings;

    procedure Connect (Host : in String; Port : in Port_Type; Conn : out Connection) is
        Host_Ptr : aliased Chars_Ptr := New_String (Host);
    begin
        Conn.Context := Hiredis.redisConnect (Host_Ptr, Int (Port));
        Free (Host_Ptr);
    end Connect;

    procedure Set (C : in Redis.Connection; Key : in String; Value : in String) is
        Unused : System.Address;

        Argc : aliased Int := 3;
        Argv : array (0 .. 2) of aliased Chars_Ptr;
    begin
        Argv (0) := New_String ("SET");
        Argv (1) := New_String (Key);
        Argv (2) := New_String (Value);

        Unused := Hiredis.redisCommandArgv (C.Context, Argc, Argv (0)'Access, null);

        for Index in Argv'Range loop
            Free (Argv (Index));
        end loop;
    end Set;
end Redis;
